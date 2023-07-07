CREATE TABLE [dbo].[tblTipoComunicado] (
    [Id]                UNIQUEIDENTIFIER NOT NULL,
    [Nombre]            NVARCHAR (50)    NOT NULL,
    [Imagen]            NVARCHAR (MAX)   NOT NULL,
    [Activo]            INT              NOT NULL,
    [FechaCreacion]     SMALLDATETIME    NOT NULL,
    [FechaModificacion] SMALLDATETIME    NULL
);

