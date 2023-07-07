CREATE TABLE [dbo].[tblModulo] (
    [Id]                INT           IDENTITY (1, 1) NOT NULL,
    [Nombre]            VARCHAR (250) NULL,
    [FechaCreacion]     SMALLDATETIME CONSTRAINT [DF_tblAreas_FechaCreacion] DEFAULT (CONVERT([smalldatetime],getdate())) NULL,
    [FechaModificacion] SMALLDATETIME NULL,
    [Activo]            BIT           NULL,
    CONSTRAINT [PK_tblAreas] PRIMARY KEY CLUSTERED ([Id] ASC)
);

