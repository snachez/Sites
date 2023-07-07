CREATE TABLE [dbo].[tblAgenciaBancaria] (
    [Id]                INT            IDENTITY (1, 1) NOT NULL,
    [Nombre]            NVARCHAR (300) NOT NULL,
    [FkIdGrupoAgencia]  INT            NOT NULL,
    [UsaCuentasGrupo]   BIT            DEFAULT ((0)) NOT NULL,
    [EnviaRemesas]      BIT            DEFAULT ((0)) NOT NULL,
    [SolicitaRemesas]   BIT            DEFAULT ((0)) NOT NULL,
    [CodigoBranch]      NVARCHAR (30)  NOT NULL,
    [CodigoProvincia]   INT            NOT NULL,
    [CodigoCanton]      INT            NOT NULL,
    [CodigoDistrito]    INT            NOT NULL,
    [Direccion]         NVARCHAR (450) NOT NULL,
    [Activo]            BIT            DEFAULT ((1)) NOT NULL,
    [FechaCreacion]     SMALLDATETIME  DEFAULT (CONVERT([smalldatetime],getdate())) NOT NULL,
    [FechaModificacion] SMALLDATETIME  NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_tblAgenciaBancaria_tblGrupoAgencia] FOREIGN KEY ([FkIdGrupoAgencia]) REFERENCES [dbo].[tblGrupoAgencia] ([Id]),
    CONSTRAINT [Unique_Codigo_Agencia] UNIQUE NONCLUSTERED ([Nombre] ASC),
    CONSTRAINT [Unique_Codigo_Branch] UNIQUE NONCLUSTERED ([CodigoBranch] ASC)
);



