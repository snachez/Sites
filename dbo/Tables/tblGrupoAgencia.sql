CREATE TABLE [dbo].[tblGrupoAgencia] (
    [Id]                INT            IDENTITY (1, 1) NOT NULL,
    [Nombre]            NVARCHAR (300) NULL,
    [Codigo]            NVARCHAR (90)  DEFAULT (newid()) NOT NULL,
    [EnviaRemesas]      BIT            DEFAULT ((0)) NOT NULL,
    [SolicitaRemesas]   BIT            DEFAULT ((0)) NOT NULL,
    [Activo]            BIT            DEFAULT ((1)) NOT NULL,
    [FechaCreacion]     SMALLDATETIME  DEFAULT (CONVERT([smalldatetime],getdate())) NOT NULL,
    [FechaModificacion] SMALLDATETIME  NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [Unique_Nombre_Grupo_Agencia] UNIQUE NONCLUSTERED ([Nombre] ASC)
);

