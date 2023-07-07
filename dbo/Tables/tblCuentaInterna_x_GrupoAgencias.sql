CREATE TABLE [dbo].[tblCuentaInterna_x_GrupoAgencias] (
    [Id]                INT           IDENTITY (1, 1) NOT NULL,
    [FkIdCuentaInterna] BIGINT        NOT NULL,
    [FkIdGrupoAgencias] INT           NOT NULL,
    [Codigo]            NVARCHAR (90) DEFAULT (newid()) NOT NULL,
    [Activo]            BIT           DEFAULT ((1)) NOT NULL,
    [FechaCreacion]     SMALLDATETIME DEFAULT (CONVERT([smalldatetime],getdate())) NOT NULL,
    [FechaModificacion] SMALLDATETIME NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [Unique_cuenta_x_grupo] UNIQUE NONCLUSTERED ([FkIdCuentaInterna] ASC, [FkIdGrupoAgencias] ASC)
);

