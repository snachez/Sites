CREATE TABLE [dbo].[tblDivisa] (
    [Id]                INT            IDENTITY (1, 1) NOT NULL,
    [Nombre]            NVARCHAR (150) NULL,
    [Nomenclatura]      NVARCHAR (4)   NULL,
    [Simbolo]           NVARCHAR (3)   NULL,
    [Descripcion]       NVARCHAR (300) NULL,
    [Activo]            BIT            CONSTRAINT [DF__tblDivisa__Activ__403A8C7D] DEFAULT ((1)) NOT NULL,
    [FechaCreacion]     SMALLDATETIME  CONSTRAINT [DF__tblDivisa__Fecha__3864608B] DEFAULT (CONVERT([smalldatetime],getdate())) NOT NULL,
    [FechaModificacion] SMALLDATETIME  NULL,
    CONSTRAINT [PK__tblDivis__3214EC07FE718203] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [Unique_Nombre_Divisa] UNIQUE NONCLUSTERED ([Nombre] ASC),
    CONSTRAINT [Unique_Nomenclatura_Divisa] UNIQUE NONCLUSTERED ([Nomenclatura] ASC)
);



