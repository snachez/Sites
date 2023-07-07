CREATE TABLE [dbo].[tblPais] (
    [Id]                INT            IDENTITY (1, 1) NOT NULL,
    [Nombre]            VARCHAR (250)  NULL,
    [Codigo]            NVARCHAR (100) NULL,
    [Activo]            BIT            NOT NULL,
    [FechaCreacion]     SMALLDATETIME  CONSTRAINT [DF_tblPais_FechaCreacion] DEFAULT (CONVERT([smalldatetime],getdate())) NOT NULL,
    [FechaModificacion] SMALLDATETIME  NULL,
    CONSTRAINT [PK_tblPais] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [Unique_Codigo_Pais] UNIQUE NONCLUSTERED ([Codigo] ASC),
    CONSTRAINT [Unique_Nombre_Pais] UNIQUE NONCLUSTERED ([Nombre] ASC)
);



