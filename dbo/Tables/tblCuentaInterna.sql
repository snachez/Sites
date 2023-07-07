CREATE TABLE [dbo].[tblCuentaInterna] (
    [Id]                BIGINT        IDENTITY (1, 1) NOT NULL,
    [NumeroCuenta]      NVARCHAR (30) NOT NULL,
    [Codigo]            NVARCHAR (90) DEFAULT (newid()) NOT NULL,
    [FkIdDivisa]        INT           NOT NULL,
    [Activo]            BIT           DEFAULT ((1)) NOT NULL,
    [FechaCreacion]     SMALLDATETIME DEFAULT (CONVERT([smalldatetime],getdate())) NOT NULL,
    [FechaModificacion] SMALLDATETIME NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [Unique_numero_cuenta] UNIQUE NONCLUSTERED ([NumeroCuenta] ASC)
);

