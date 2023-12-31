﻿CREATE TABLE [dbo].[tblDenominaciones] (
    [Id]                INT           IDENTITY (1, 1) NOT NULL,
    [ValorNominal]      DECIMAL (18)  NOT NULL,
    [Nombre]            VARCHAR (500) NULL,
    [IdDivisa]          INT           NOT NULL,
    [BMO]               INT           NOT NULL,
    [Imagen]            VARCHAR (MAX) NULL,
    [Activo]            BIT           NULL,
    [FechaCreacion]     SMALLDATETIME CONSTRAINT [DF_tblDenominaciones_FechaCreacion] DEFAULT (CONVERT([smalldatetime],getdate())) NULL,
    [FechaModificacion] SMALLDATETIME NULL,
    CONSTRAINT [PK] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [Contrains_Validate_Relaciones_Denominaciones] CHECK ([dbo].[FN_VALIDACION_CONTRAINT_CHANGE_ESTADO_tblDenominaciones]([Activo],[Id])=(0)),
    CONSTRAINT [UNIQUE_NOMINAL_DIVISA_BMO] UNIQUE NONCLUSTERED ([ValorNominal] ASC, [IdDivisa] ASC, [BMO] ASC)
);







