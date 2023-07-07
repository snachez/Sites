CREATE TABLE [dbo].[tblArea] (
    [Id]                 INT            IDENTITY (1, 1) NOT NULL,
    [Nombre]             NVARCHAR (300) NULL,
    [Fk_Id_Departamento] INT            NULL,
    [Codigo]             NVARCHAR (90)  DEFAULT (newid()) NOT NULL,
    [Activo]             BIT            DEFAULT ((1)) NOT NULL,
    [FechaCreacion]      SMALLDATETIME  DEFAULT (CONVERT([smalldatetime],getdate())) NOT NULL,
    [FechaModificacion]  SMALLDATETIME  NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [t2_C3_Asignacion_Departamento_Activo] CHECK ([dbo].[FN_VALIDACION_CONTRAINT_T2_C3]([Fk_Id_Departamento])=(1)),
    CONSTRAINT [t2_C4_Reactivacion_Valida] CHECK ([dbo].[FN_VALIDACION_CONTRAINT_T2_C4]([Activo],[Fk_Id_Departamento])=(1)),
    CONSTRAINT [t2_C2_Foreign_Key_Departamento] FOREIGN KEY ([Fk_Id_Departamento]) REFERENCES [dbo].[tblDepartamento] ([Id]),
    CONSTRAINT [t2_C1_Unique_Nombre_Area] UNIQUE NONCLUSTERED ([Nombre] ASC, [Fk_Id_Departamento] ASC)
);





