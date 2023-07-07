CREATE TABLE [dbo].[tblUnidadMedida_x_TipoEfectivo] (
    [Id]                  INT           IDENTITY (1, 1) NOT NULL,
    [Fk_Id_Unidad_Medida] INT           NULL,
    [Fk_Id_Tipo_Efectivo] INT           NULL,
    [Activo]              BIT           NULL,
    [Fecha_Creacion]      SMALLDATETIME CONSTRAINT [DF_tblUnidadMedida_x_TipoEfectivo_FechaCreacion] DEFAULT (CONVERT([smalldatetime],getdate())) NULL,
    [Fecha_Modificacion]  SMALLDATETIME NULL,
    CONSTRAINT [PK_tblUnidadMedida_x_TipoEfectivo] PRIMARY KEY CLUSTERED ([Id] ASC)
);



