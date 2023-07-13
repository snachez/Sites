CREATE TABLE [dbo].[tblDenominacion] (
    [Id]                INT            IDENTITY (1, 1) NOT NULL,
    [Nombre]            NVARCHAR (30)  NOT NULL,
    [Valor]             INT            NOT NULL,
    [fk_Id_Divisa]      INT            NOT NULL,
    [EsBillete]         BIT            DEFAULT ((0)) NOT NULL,
    [Descripcion]       NVARCHAR (150) NULL,
    [Activo]            BIT            DEFAULT ((1)) NOT NULL,
    [FechaCreacion]     DATETIME       DEFAULT (getdate()) NULL,
    [FechaModificacion] DATETIME       NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);

