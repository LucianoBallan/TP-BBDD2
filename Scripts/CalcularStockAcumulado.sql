USE [bd_staging_2026_G06];
GO

CREATE OR ALTER VIEW dbo.vw_stg_stock_procesado AS
SELECT 
    CAST(s.Fecha AS DATE) AS FechaMovimiento,
    -- Forzamos la conversión a INT para que coincida con el Data Warehouse
    CAST(s.CodProdStock AS INT) AS ProductoID, 
    s.Variation AS Variacion,
    SUM(s.Variation) OVER (
        PARTITION BY s.CodProdStock 
        ORDER BY CAST(s.Fecha AS DATE) 
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS StockAcumulado
FROM [dbo].[stg_stock_G06] s;
GO