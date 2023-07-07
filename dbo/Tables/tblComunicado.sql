CREATE TABLE [dbo].[tblComunicado] (
    [Id]                UNIQUEIDENTIFIER NOT NULL,
    [FkTipoComunicado]  UNIQUEIDENTIFIER NOT NULL,
    [FKColaborador]     INT              NOT NULL,
    [Mensaje]           NVARCHAR (500)   NOT NULL,
    [FkHabilitarBanner] UNIQUEIDENTIFIER NOT NULL,
    [Activo]            INT              NOT NULL,
    [FechaCreacion]     SMALLDATETIME    NOT NULL,
    [FechaModificacion] SMALLDATETIME    NULL
);