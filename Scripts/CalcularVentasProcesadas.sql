USE [bd_staging_2026_G06];
GO

CREATE OR ALTER VIEW dbo.vw_stg_ventas_procesadas AS
WITH 
-- 1. Unificamos las ventas históricas y las actuales en un solo flujo unificado
-- El historial puede tener múltiples líneas del mismo producto en una factura (quantities distintas),
-- por eso se agrega con SUM para que quede una sola fila por (billing_id, product_id).
VentasUnificadas AS (
    SELECT billing_id, [date] AS Fecha, customer_id, employee_id, product_id, SUM(quantity) AS quantity
    FROM dbo.stg_billing_history_G06
    GROUP BY billing_id, [date], customer_id, employee_id, product_id
    UNION ALL
    SELECT billing_id, [date] AS Fecha, customer_id, employee_id, product_id, quantity
    FROM dbo.stg_billing_G06
),

-- 2. Consolidamos los datos geográficos de los clientes (minoristas y mayoristas)
-- Esto nos permitirá pasarle a SSIS los datos limpios para cruzar con DIM_GEOGRAFIA
ClientesGeografia AS (
    SELECT TRY_CAST(CUSTOMER_ID AS INT) AS customer_id, CITY, STATE, ZIPCODE FROM dbo.stg_customer_min_G06
    UNION ALL
    SELECT TRY_CAST(CUSTOMER_ID AS INT) AS customer_id, CITY, STATE, ZIPCODE FROM dbo.stg_customer_may_G06
),

-- 3. Buscamos el precio correspondiente a la fecha de la venta (Precio Vigente)
-- Usamos OUTER APPLY para traer el "TOP 1" precio anterior o igual a la fecha de la factura
VentasConPrecio AS (
    SELECT 
        v.*,
        ISNULL(p.PriceVigente, 0) AS PrecioUnitario,
        v.quantity * ISNULL(p.PriceVigente, 0) AS MontoBrutoLinea,
        RTRIM(CAST(cg.CITY AS VARCHAR(100))) AS ClientCity,
        RTRIM(CAST(cg.STATE AS VARCHAR(100))) AS ClientState,
        CAST(cg.ZIPCODE AS VARCHAR(100)) AS ClientZipCode
    FROM VentasUnificadas v
    LEFT JOIN ClientesGeografia cg ON v.customer_id = cg.customer_id
    OUTER APPLY (
        SELECT TOP 1 TRY_CAST(pr.price AS DECIMAL(18,2)) AS PriceVigente
        FROM dbo.stg_prices_G06 pr
        WHERE TRY_CAST(pr.product_id AS INT) = v.product_id
          AND TRY_CAST(pr.[date] AS DATETIME) <= v.Fecha
        ORDER BY TRY_CAST(pr.[date] AS DATETIME) DESC
    ) p
),
-- 4. Calculamos el Monto Bruto Total por Factura (Header) para evaluar los descuentos
CabeceraFactura AS (
    SELECT 
        billing_id,
        MIN(Fecha) AS FechaFactura,
        SUM(MontoBrutoLinea) AS TotalMontoBrutoFactura
    FROM VentasConPrecio
    GROUP BY billing_id
),

-- 5. Evaluamos las reglas de negocio de los descuentos aplicables
-- "Se aplica si supera el monto, si rige la fecha y, si hay más de uno, el de mayor porcentaje"
DescuentoPorFactura AS (
    SELECT 
        cf.billing_id,
        ISNULL(MAX(TRY_CAST(d.percentage AS DECIMAL(5,2))), 0) AS PorcentajeDescuento
    FROM CabeceraFactura cf
    LEFT JOIN dbo.stg_discounts_G06 d 
        ON cf.FechaFactura >= TRY_CAST(d.[from] AS DATETIME)
       AND cf.FechaFactura <= TRY_CAST(d.[until] AS DATETIME)
       AND cf.TotalMontoBrutoFactura >= TRY_CAST(d.total_billing AS DECIMAL(18,2))
    GROUP BY cf.billing_id
)

-- 6. Selección final uniendo las métricas de líneas de venta con sus descuentos y capacidades
SELECT 
    CAST(v.Fecha AS DATE) AS FechaVenta,
    v.billing_id AS BillingID,
    CAST(v.customer_id AS VARCHAR(50)) AS CustomerID,
    CAST(v.employee_id AS VARCHAR(50)) AS EmployeeID,
    v.product_id AS ProductoID,
    v.ClientCity,
    v.ClientState,
    -- Se paddea a 5 digitos porque el XML de clientes omite el cero a la izquierda
    RIGHT('00000' + ISNULL(v.ClientZipCode, ''), 5) AS ClientZipCode,
    v.quantity AS Cantidad,
    CAST((v.quantity * dp.CapacidadML) / 1000.0 AS DECIMAL(18,2)) AS Litros,
    CAST(v.MontoBrutoLinea AS DECIMAL(18,2)) AS MontoBruto,
    CAST(df.PorcentajeDescuento AS DECIMAL(5,2)) AS PorcentajeDescuento,
    CAST(v.MontoBrutoLinea * (1.0 - (df.PorcentajeDescuento / 100.0)) AS DECIMAL(18,2)) AS MontoNeto
FROM VentasConPrecio v
INNER JOIN DescuentoPorFactura df ON v.billing_id = df.billing_id
INNER JOIN bd_datawarehouse_2025_G15.dbo.DIM_PRODUCTO dp ON v.product_id = dp.ProductoID
WHERE v.Fecha IS NOT NULL;
GO