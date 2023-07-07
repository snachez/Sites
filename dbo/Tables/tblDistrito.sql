CREATE TABLE [dbo].[tblDistrito] (
    [Id]                INT           NOT NULL,
    [Nombre]            VARCHAR (50)  NOT NULL,
    [fk_Id_Canton]      INT           NOT NULL,
    [Activo]            BIT           CONSTRAINT [DF__tblDistri__Activ__793DFFAF] DEFAULT ((1)) NOT NULL,
    [FechaCreacion]     SMALLDATETIME CONSTRAINT [DF__tblDistri__Fecha__7A3223E8] DEFAULT (CONVERT([smalldatetime],getdate())) NOT NULL,
    [FechaModificacion] SMALLDATETIME NULL,
    CONSTRAINT [PK_tblDistrito] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_tblDistrito_tblCanton] FOREIGN KEY ([fk_Id_Canton]) REFERENCES [dbo].[tblCanton] ([Id])
);



