USE [bd_datawarehouse_2025_G15]
GO

-- DIM_TIEMPO
CREATE TABLE [dbo].[DIM_TIEMPO](
    [SK_TIEMPO]          INT IDENTITY(1,1) PRIMARY KEY,
    [Fecha]              DATE NOT NULL,
    [Dia]                INT NOT NULL,
    [Mes]                INT NOT NULL,
    [NombreMes]          VARCHAR(20) NOT NULL,
    [Trimestre]          INT NOT NULL,
    [Semestre]           INT NOT NULL,
    [Anio]               INT NOT NULL,
    [DiaSemana]          INT NOT NULL,
    [NombreDiaSemana]    VARCHAR(20) NOT NULL,
    [EsFinDeSemana]      BIT NOT NULL,
    [EsFeriado]          BIT NOT NULL,
    [NombreFeriado]      VARCHAR(100) NULL
) ON [PRIMARY]
GO

-- DIM_PRODUCTO
CREATE TABLE [dbo].[DIM_PRODUCTO](
    [SK_PRODUCTO]        INT IDENTITY(1,1) PRIMARY KEY,
    [ProductoID]         INT NOT NULL,
    [Detalle]            VARCHAR(100) NOT NULL,
    [Rubro]              VARCHAR(50) NOT NULL,
    [Presentacion]       VARCHAR(100) NOT NULL,
    [EsDiet]             BIT NOT NULL,
    [CapacidadML]        INT NOT NULL,
    [TipoEnvase]         VARCHAR(20) NOT NULL
) ON [PRIMARY]
GO

-- DIM_CLIENTE
CREATE TABLE [dbo].[DIM_CLIENTE](
    [SK_CLIENTE]         INT IDENTITY(1,1) PRIMARY KEY,
    [CustomerID]         VARCHAR(50) NOT NULL,
    [NombreCompleto]     VARCHAR(100) NOT NULL,
    [FechaNacimiento]    DATE NULL,
    [TipoCliente]        VARCHAR(20) NOT NULL,
    [Ciudad]             VARCHAR(100) NULL,
    [Estado]             VARCHAR(100) NULL,
    [Region]             VARCHAR(100) NULL,
    [ZipCode]            VARCHAR(100) NULL
) ON [PRIMARY]
GO

-- DIM_EMPLEADO
CREATE TABLE [dbo].[DIM_EMPLEADO](
    [SK_EMPLEADO]        INT IDENTITY(1,1) PRIMARY KEY,
    [EmployeeID]         VARCHAR(50) NOT NULL,
    [NombreCompleto]     VARCHAR(100) NOT NULL,
    [Genero]             VARCHAR(10) NULL,
    [Categoria]          VARCHAR(50) NULL,
    [FechaIngreso]       DATE NULL,
    [NivelEducativo]     VARCHAR(50) NULL,
    [Edad]               INT NULL,
    [FechaNacimiento]    DATE NULL,
    [Antiguedad]         INT NULL,
    [GrupoEtario]        VARCHAR(30) NULL
) ON [PRIMARY]
GO

-- DIM_GEOGRAFIA
CREATE TABLE [dbo].[DIM_GEOGRAFIA](
    [SK_GEOGRAFIA]       INT IDENTITY(1,1) PRIMARY KEY,
    [Region]             VARCHAR(100) NOT NULL,
    [Estado]             VARCHAR(100) NOT NULL,
    [Ciudad]             VARCHAR(100) NOT NULL,
    [ZipCode]            VARCHAR(100) NULL
) ON [PRIMARY]
GO

-- FACT_VENTAS
CREATE TABLE [dbo].[FACT_VENTAS](
    [SK_TIEMPO]              INT NOT NULL,
    [SK_PRODUCTO]            INT NOT NULL,
    [SK_CLIENTE]             INT NOT NULL,
    [SK_EMPLEADO]            INT NOT NULL,
    [SK_GEOGRAFIA]           INT NOT NULL,
    [BillingID]              INT NOT NULL,
    [Cantidad]               INT NOT NULL,
    [Litros]                 DECIMAL(18,2) NOT NULL,
    [MontoBruto]             DECIMAL(18,2) NOT NULL,
    [PorcentajeDescuento]    DECIMAL(5,2) NULL,
    [MontoNeto]              DECIMAL(18,2) NOT NULL,
    CONSTRAINT PK_FACT_VENTAS PRIMARY KEY (SK_TIEMPO, SK_PRODUCTO, SK_CLIENTE, SK_EMPLEADO, SK_GEOGRAFIA, BillingID),
    CONSTRAINT FK_FACT_VENTAS_TIEMPO    FOREIGN KEY (SK_TIEMPO)    REFERENCES DIM_TIEMPO(SK_TIEMPO),
    CONSTRAINT FK_FACT_VENTAS_PRODUCTO  FOREIGN KEY (SK_PRODUCTO)  REFERENCES DIM_PRODUCTO(SK_PRODUCTO),
    CONSTRAINT FK_FACT_VENTAS_CLIENTE   FOREIGN KEY (SK_CLIENTE)   REFERENCES DIM_CLIENTE(SK_CLIENTE),
    CONSTRAINT FK_FACT_VENTAS_EMPLEADO  FOREIGN KEY (SK_EMPLEADO)  REFERENCES DIM_EMPLEADO(SK_EMPLEADO),
    CONSTRAINT FK_FACT_VENTAS_GEOGRAFIA FOREIGN KEY (SK_GEOGRAFIA) REFERENCES DIM_GEOGRAFIA(SK_GEOGRAFIA)
) ON [PRIMARY]
GO

-- FACT_STOCK
CREATE TABLE [dbo].[FACT_STOCK](
    [SK_TIEMPO]          INT NOT NULL,
    [SK_PRODUCTO]        INT NOT NULL,
    [Variacion]          DECIMAL(18,2) NOT NULL,
    [StockAcumulado]     DECIMAL(18,2) NOT NULL,
    CONSTRAINT PK_FACT_STOCK PRIMARY KEY (SK_TIEMPO, SK_PRODUCTO),
    CONSTRAINT FK_FACT_STOCK_TIEMPO   FOREIGN KEY (SK_TIEMPO)   REFERENCES DIM_TIEMPO(SK_TIEMPO),
    CONSTRAINT FK_FACT_STOCK_PRODUCTO FOREIGN KEY (SK_PRODUCTO) REFERENCES DIM_PRODUCTO(SK_PRODUCTO)
) ON [PRIMARY]
GO
