CREATE TABLE [dbo].[tblUnidadBase] (
    [Id]                INT            IDENTITY (1, 1) NOT NULL,
    [Nombre]            NVARCHAR (50)  NULL,
    [Descripcion]       NVARCHAR (270) NULL,
    [Activo]            BIT            DEFAULT ((1)) NOT NULL,
    [FechaCreacion]     DATETIME       DEFAULT (getdate()) NULL,
    [FechaModificacion] DATETIME       NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);

