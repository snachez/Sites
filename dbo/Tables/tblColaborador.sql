CREATE TABLE [dbo].[tblColaborador] (
    [Id]                  INT            IDENTITY (1, 1) NOT NULL,
    [Nombre]              NVARCHAR (50)  NULL,
    [Apellido1]           NVARCHAR (50)  NULL,
    [Apellido2]           NVARCHAR (50)  NULL,
    [Cedula]              NVARCHAR (50)  NULL,
    [UserActiveDirectory] NVARCHAR (100) NOT NULL,
    [Activo]              BIT            CONSTRAINT [DF__tblColabo__Activ__29572725] DEFAULT ((1)) NOT NULL,
    [Correo]              NVARCHAR (50)  NULL,
    [FechaCreacion]       DATETIME       CONSTRAINT [DF__tblColabo__Fecha__2A4B4B5E] DEFAULT (getdate()) NOT NULL,
    [FechaModificacion]   DATETIME       NULL,
    CONSTRAINT [PK__tblColab__3214EC07AF01A720] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [UQ__tblColab__096B01A58329558D] UNIQUE NONCLUSTERED ([UserActiveDirectory] ASC)
);



