CREATE TABLE [dbo].[tblDepartamento] (
    [Id]                INT           IDENTITY (1, 1) NOT NULL,
    [Nombre]            NVARCHAR (50) NOT NULL,
    [Activo]            BIT           CONSTRAINT [DF_tblDepartamento_Activo] DEFAULT ((1)) NOT NULL,
    [FechaCreacion]     SMALLDATETIME CONSTRAINT [DF_tblDepartamento_FechaCreacion] DEFAULT (CONVERT([smalldatetime],getdate())) NOT NULL,
    [FechaModificacion] SMALLDATETIME NULL,
    CONSTRAINT [PK_tblDepartamento] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [t2_C1_Unique_Nombre_Departamento] UNIQUE NONCLUSTERED ([Nombre] ASC)
);



