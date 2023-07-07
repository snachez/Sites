CREATE TABLE [dbo].[tblPuntoVenta] (
    [Id]                INT            IDENTITY (1, 1) NOT NULL,
    [Nombre]            NVARCHAR (150) NULL,
    [fk_Id_Cliente]     INT            NULL,
    [Activo]            BIT            DEFAULT ((1)) NOT NULL,
    [FechaCreacion]     DATETIME       DEFAULT (getdate()) NULL,
    [FechaModificacion] DATETIME       NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);

