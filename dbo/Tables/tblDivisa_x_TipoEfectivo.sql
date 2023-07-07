CREATE TABLE [dbo].[tblDivisa_x_TipoEfectivo] (
    [Id]                 INT            IDENTITY (1, 1) NOT NULL,
    [FkIdTipoEfectivo]   INT            NULL,
    [FkIdDivisa]         INT            NULL,
    [FechaCreacion]      SMALLDATETIME  CONSTRAINT [DF_tblDivisa_x_TipoEfectivo_FechaCreacion] DEFAULT (CONVERT([smalldatetime],getdate())) NULL,
    [FechaModificacion]  SMALLDATETIME  NULL,
    [Activo]             BIT            CONSTRAINT [DF_tblDivisa_x_TipoEfectivo_Activo] DEFAULT ((1)) NULL,
    [NombreTipoEfectivo] NVARCHAR (150) NULL,
    [NombreDivisa]       NVARCHAR (150) NULL,
    CONSTRAINT [PK_tblDivisa_x_TipoEfectivo] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_tblDivisa_x_TipoEfectivo_tblDivisa] FOREIGN KEY ([FkIdDivisa]) REFERENCES [dbo].[tblDivisa] ([Id]),
    CONSTRAINT [Unique_] FOREIGN KEY ([Id]) REFERENCES [dbo].[tblDivisa_x_TipoEfectivo] ([Id])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [Unique_Divisa_x_TipoEfectivo]
    ON [dbo].[tblDivisa_x_TipoEfectivo]([FkIdDivisa] ASC, [FkIdTipoEfectivo] ASC);

