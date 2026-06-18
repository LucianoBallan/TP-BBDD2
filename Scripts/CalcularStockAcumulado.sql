USE [bd_staging_2026_G06];
GO

CREATE OR ALTER VIEW dbo.vw_stg_stock_procesado AS
WITH movimientos AS (
    -- Fecha viene en formato MM/DD/YYYY HH:MM:SS a.m./p.m.
    SELECT
        CONVERT(DATE, LEFT(LTRIM(RTRIM(s.Fecha)), 10), 101) AS FechaMovimiento,
        CAST(s.CodProdStock AS INT) AS ProductoID,
        s.Variation AS Variacion,
        SUM(s.Variation) OVER (
            PARTITION BY s.CodProdStock
            ORDER BY CONVERT(DATE, LEFT(LTRIM(RTRIM(s.Fecha)), 10), 101),
                     s.Variation
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS StockAcumulado,
        ROW_NUMBER() OVER (
            PARTITION BY CAST(s.CodProdStock AS INT),
                         CONVERT(DATE, LEFT(LTRIM(RTRIM(s.Fecha)), 10), 101)
            ORDER BY CONVERT(DATE, LEFT(LTRIM(RTRIM(s.Fecha)), 10), 101) DESC,
                     s.Variation DESC
        ) AS rn
    FROM [dbo].[stg_stock_G06] s
)
-- Una sola fila por (dia, producto): el stock acumulado al final del dia
SELECT FechaMovimiento, ProductoID, Variacion, StockAcumulado
FROM movimientos
WHERE rn = 1;
GO
