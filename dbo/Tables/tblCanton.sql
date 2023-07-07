CREATE TABLE [dbo].[tblCanton] (
    [Id]                INT           NOT NULL,
    [Nombre]            VARCHAR (50)  NOT NULL,
    [fk_Id_Provincia]   INT           NOT NULL,
    [Activo]            BIT           DEFAULT ((1)) NOT NULL,
    [FechaCreacion]     SMALLDATETIME DEFAULT (CONVERT([smalldatetime],getdate())) NOT NULL,
    [FechaModificacion] SMALLDATETIME NULL,
    CONSTRAINT [PK_tblCanton] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_tblCanton_tblProvincia] FOREIGN KEY ([fk_Id_Provincia]) REFERENCES [dbo].[tblProvincia] ([Id])
);



