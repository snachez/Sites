CREATE TABLE [dbo].[tblTipoEfectivo] (
    [Id]                INT            IDENTITY (1, 1) NOT NULL,
    [Nombre]            NVARCHAR (250) NOT NULL,
    [Activo]            BIT            NULL,
    [FechaCreacion]     SMALLDATETIME  CONSTRAINT [DF_tblTipoEfectivo_FechaCreacion] DEFAULT (CONVERT([smalldatetime],getdate())) NULL,
    [FechaModificacion] SMALLDATETIME  NULL,
    CONSTRAINT [PK_tblTipoEfectivo] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [Unique_Nombre_TipoEfectivo] UNIQUE NONCLUSTERED ([Nombre] ASC)
);



