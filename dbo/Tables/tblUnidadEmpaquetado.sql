CREATE TABLE [dbo].[tblUnidadEmpaquetado] (
    [Id]                INT            IDENTITY (1, 1) NOT NULL,
    [Nombre]            NVARCHAR (50)  NULL,
    [Descripcion]       NVARCHAR (250) NULL,
    [MaxUnidadesBase]   INT            NULL,
    [OrdenJerarquia]    INT            NULL,
    [fk_Id_UnidadBase]  INT            NULL,
    [Activo]            BIT            DEFAULT ((1)) NOT NULL,
    [FechaCreacion]     DATETIME       DEFAULT (getdate()) NULL,
    [FechaModificacion] DATETIME       NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);

