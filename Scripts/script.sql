USE [bd_staging_2026_G06]
GO
/****** Object:  Table [dbo].[stg_billing_G06]    Script Date: 2/6/2026 17:16:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[stg_billing_G06](
	[id] [int] NULL,
	[billing_id] [int] NULL,
	[date] [datetime] NULL,
	[customer_id] [int] NULL,
	[employee_id] [int] NULL,
	[product_id] [int] NULL,
	[quantity] [int] NULL,
	[region] [varchar](45) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[stg_billing_detail_G06]    Script Date: 13/6/2026 ******/
CREATE TABLE [dbo].[stg_billing_detail_G06](
	[billing_id] [int] NULL,
	[product_id] [int] NULL,
	[quantity] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[stg_billing_history_G06]    Script Date: 13/6/2026 ******/
-- Ventas históricas (SQL Server 2000-2008), TDChistorySales
CREATE TABLE [dbo].[stg_billing_history_G06](
	[id] [int] NULL,
	[billing_id] [int] NULL,
	[date] [datetime] NULL,
	[customer_id] [int] NULL,
	[employee_id] [int] NULL,
	[product_id] [int] NULL,
	[quantity] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[stg_prices_G06]    Script Date: 9/6/2026 23:19:41 ******/
CREATE TABLE [dbo].[stg_prices_G06](
    [product_id]  [nvarchar](255) NULL,
    [date]        [nvarchar](255) NULL,
    [price]       [nvarchar](255) NULL
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[stg_discounts_G06]    Script Date: 9/6/2026 23:36:45 ******/
CREATE TABLE [dbo].[stg_discounts_G06](
    [discount_id]    [nvarchar](255) NULL,
    [from]           [nvarchar](255) NULL,
    [until]          [nvarchar](255) NULL,
    [total_billing]  [nvarchar](255) NULL,
    [percentage]     [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[stg_customer_may_G06]    Script Date: 2/6/2026 17:16:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[stg_customer_may_G06](
	[CUSTOMER_ID] [nvarchar](255) NULL,
	[FULL_NAME] [nvarchar](255) NULL,
	[BIRTH_DATE] [nvarchar](255) NULL,
	[CITY] [nvarchar](255) NULL,
	[STATE] [nvarchar](255) NULL,
	[ZIPCODE] [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[stg_customer_min_G06]    Script Date: 2/6/2026 17:16:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[stg_customer_min_G06](
	[CUSTOMER_ID] [nvarchar](255) NULL,
	[FULL_NAME] [nvarchar](255) NULL,
	[BIRTH_DATE] [nvarchar](255) NULL,
	[CITY] [nvarchar](255) NULL,
	[STATE] [nvarchar](255) NULL,
	[ZIPCODE] [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[stg_empleados_G06]    Script Date: 2/6/2026 17:16:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[stg_empleados_G06](
	[EMPLOYEE_ID] [nvarchar](255) NULL,
	[FULL_NAME] [nvarchar](255) NULL,
	[CATEGORY] [nvarchar](255) NULL,
	[EMPLOYMENT_DATE] [nvarchar](255) NULL,
	[BIRTH_DATE] [nvarchar](255) NULL,
	[EDUCATION_LEVEL] [nvarchar](255) NULL,
	[GENDER] [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[stg_holidays_G06]    Script Date: 2/6/2026 17:16:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[stg_holidays_G06](
	[DATE] [nvarchar](255) NULL,
	[HOLIDAY] [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[stg_productos_G06]    Script Date: 2/6/2026 17:16:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[stg_productos_G06](
	[CodProducto] [varchar](100) NULL,
	[DescrProducto] [varchar](100) NULL,
	[PresentacionProducto] [varchar](100) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[stg_regiones_G06]    Script Date: 2/6/2026 17:16:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[stg_regiones_G06](
	[Region] [varchar](100) NULL,
	[Estado] [varchar](100) NULL,
	[Ciudad] [varchar](100) NULL,
	[CodPostal] [varchar](100) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[stg_stock_G06]    Script Date: 2/6/2026 17:16:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[stg_stock_G06](
	[CodProdStock] [varchar](100) NULL,
	[Fecha] [varchar](100) NULL,
	[Variation] [decimal](18, 2) NULL
) ON [PRIMARY]
GO
