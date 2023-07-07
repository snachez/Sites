CREATE TABLE [dbo].[tblUnidadMedida] (
    [Id]                         INT            IDENTITY (1, 1) NOT NULL,
    [Nombre]                     VARCHAR (250)  NULL,
    [Simbolo]                    VARCHAR (250)  NULL,
    [Cantidad_Unidades]          INT            NULL,
    [Divisa]                     VARCHAR (1000) NULL,
    [Presentaciones_Habilitadas] VARCHAR (1000) NULL,
    [Activo]                     BIT            NULL,
    [Fecha_Creacion]             SMALLDATETIME  NULL,
    [Fecha_Modificacion]         SMALLDATETIME  NULL,
    CONSTRAINT [PK_tblUnidadMedida] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO

