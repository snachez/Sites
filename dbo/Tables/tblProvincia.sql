CREATE TABLE [dbo].[tblProvincia] (
    [Id]                INT           NOT NULL,
    [Nombre]            VARCHAR (50)  NOT NULL,
    [Activo]            BIT           DEFAULT ((1)) NOT NULL,
    [FechaCreacion]     SMALLDATETIME DEFAULT (CONVERT([smalldatetime],getdate())) NOT NULL,
    [FechaModificacion] SMALLDATETIME NULL,
    CONSTRAINT [PK_tblProvincia] PRIMARY KEY CLUSTERED ([Id] ASC)
);



