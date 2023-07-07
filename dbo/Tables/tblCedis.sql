CREATE TABLE [dbo].[tblCedis] (
    [Id_Cedis]          INT            IDENTITY (1, 1) NOT NULL,
    [Nombre]            NVARCHAR (50)  NOT NULL,
    [Codigo_Cedis]      NVARCHAR (100) NOT NULL,
    [Fk_Id_Pais]        INT            NOT NULL,
    [Activo]            BIT            CONSTRAINT [DF_tblCedis_Activo] DEFAULT ((1)) NOT NULL,
    [FechaCreacion]     SMALLDATETIME  CONSTRAINT [DF_tblCedis_FechaCreacion] DEFAULT (CONVERT([smalldatetime],getdate())) NOT NULL,
    [FechaModificacion] SMALLDATETIME  NULL,
    CONSTRAINT [PK_tblCedis] PRIMARY KEY CLUSTERED ([Id_Cedis] ASC),
    CONSTRAINT [tblCedis_C4_Asignacion_Pais_Activo] CHECK ([dbo].[FN_VALIDACION_CONTRAINT_tblCedis_C4]([Fk_Id_Pais])=(1)),
    CONSTRAINT [tblCedis_C4_Reactivacion_Valida] CHECK ([dbo].[FN_VALIDACION_CONTRAINT_REACTIVAR_tblCedis_C4]([Activo],[Fk_Id_Pais])=(1)),
    CONSTRAINT [FK_tblCedis_tblPais] FOREIGN KEY ([Fk_Id_Pais]) REFERENCES [dbo].[tblPais] ([Id]),
    CONSTRAINT [Unique_Codigo_Cedis] UNIQUE NONCLUSTERED ([Codigo_Cedis] ASC),
    CONSTRAINT [Unique_Nombre_Cedis] UNIQUE NONCLUSTERED ([Nombre] ASC, [Fk_Id_Pais] ASC)
);





