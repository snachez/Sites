CREATE TABLE [dbo].[tblUnidadMedida_x_Divisa] (
    [Id]                  INT           IDENTITY (1, 1) NOT NULL,
    [Fk_Id_Unidad_Medida] INT           NULL,
    [Fk_Id_Divisa]        INT           NULL,
    [Activo]              BIT           NULL,
    [Fecha_Creacion]      SMALLDATETIME CONSTRAINT [DF_tblUnidadMedida_x_Divisa_FechaCreacion] DEFAULT (CONVERT([smalldatetime],getdate())) NULL,
    [Fecha_Modificacion]  SMALLDATETIME NULL,
    CONSTRAINT [PK_tblUnidadMedida_x_Divisa] PRIMARY KEY CLUSTERED ([Id] ASC)
);




GO
CREATE NONCLUSTERED INDEX [Unique_UnidadMedida_Divisa]
    ON [dbo].[tblUnidadMedida_x_Divisa]([Fk_Id_Divisa] ASC, [Fk_Id_Unidad_Medida] ASC);



