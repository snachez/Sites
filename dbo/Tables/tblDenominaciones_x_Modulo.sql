CREATE TABLE [dbo].[tblDenominaciones_x_Modulo] (
    [Id]                 INT           IDENTITY (1, 1) NOT NULL,
    [FkIdModulo]         INT           NULL,
    [FkIdDenominaciones] INT           NULL,
    [FechaCreacion]      SMALLDATETIME CONSTRAINT [DF_tblDenominaciones_x_Areas_FechaCreacion] DEFAULT (CONVERT([smalldatetime],getdate())) NULL,
    [FechaModificacion]  SMALLDATETIME NULL,
    [Activo]             BIT           NULL,
    CONSTRAINT [PK_tblDenominaciones_x_Areas] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [Unique_denominacion_x_area]
    ON [dbo].[tblDenominaciones_x_Modulo]([FkIdModulo] ASC, [FkIdDenominaciones] ASC);

