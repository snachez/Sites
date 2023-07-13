CREATE TABLE [dbo].[tblTipoEfectivo] (
    [Id]                INT            IDENTITY (1, 1) NOT NULL,
    [Nombre]            NVARCHAR (250) NOT NULL,
    [Activo]            BIT            NULL,
    [FechaCreacion]     SMALLDATETIME  CONSTRAINT [DF_tblTipoEfectivo_FechaCreacion] DEFAULT (CONVERT([smalldatetime],getdate())) NULL,
    [FechaModificacion] SMALLDATETIME  NULL,
    CONSTRAINT [PK_tblTipoEfectivo] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [Constrains_Validate_Relaciones_TipoEfectivo] CHECK ([dbo].[FN_VALIDACION_CONTRAINT_DESACTIVAR_tblTipoEfectivo]([Activo],[Id])=(0)),
    CONSTRAINT [Unique_Nombre_TipoEfectivo] UNIQUE NONCLUSTERED ([Nombre] ASC)
);





