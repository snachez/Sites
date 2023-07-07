﻿CREATE TABLE [dbo].[tblDiasHabilesEntregaPedidosInternos] (
    [Id]                      INT           IDENTITY (1, 1) NOT NULL,
    [Dia]                     INT           NOT NULL,
    [NombreDia]               NVARCHAR (30) NOT NULL,
    [PermiteRemesas]          BIT           DEFAULT ((0)) NOT NULL,
    [PermiteEntregasMismoDia] BIT           DEFAULT ((0)) NOT NULL,
    [EntregarLunes]           BIT           DEFAULT ((0)) NOT NULL,
    [EntregarMartes]          BIT           DEFAULT ((0)) NOT NULL,
    [EntregarMiercoles]       BIT           DEFAULT ((0)) NOT NULL,
    [EntregarJueves]          BIT           DEFAULT ((0)) NOT NULL,
    [EntregarViernes]         BIT           DEFAULT ((0)) NOT NULL,
    [EntregarSabado]          BIT           DEFAULT ((0)) NOT NULL,
    [EntregarDomingo]         BIT           DEFAULT ((0)) NOT NULL,
    [HoraDesde]               TIME (7)      NULL,
    [HoraHasta]               TIME (7)      NULL,
    [HoraLimiteMismoDia]      TIME (7)      NULL,
    [Codigo]                  NVARCHAR (90) DEFAULT (newid()) NOT NULL,
    [FechaCreacion]           SMALLDATETIME DEFAULT (CONVERT([smalldatetime],getdate())) NOT NULL,
    [FechaModificacion]       SMALLDATETIME NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [tbl001_C2_Check_Dia_Between_1_and_7] CHECK ([Dia]>=(1) AND [Dia]<=(7)),
    CONSTRAINT [tbl001_C3_Check_Hora_Desde_Hasta_Not_Null] CHECK (case when [PermiteRemesas]=(1) then case when [HoraDesde] IS NOT NULL AND [HoraHasta] IS NOT NULL then (1) else (0) end else (1) end=(1)),
    CONSTRAINT [tbl001_C4_Check_Rango_Hora_Desde_Hasta_Valido] CHECK ([HoraDesde]<=[HoraHasta]),
    CONSTRAINT [tbl001_C5_Check_Al_Menos_Un_DiaEntrega_Requerido_Distinto_Al_De_Entregas_Mismo_Dia] CHECK ([dbo].[FN_VALIDACION_CONTRAINT_tbl001_C5]([Dia],[PermiteRemesas],[PermiteEntregasMismoDia],[EntregarLunes],[EntregarMartes],[EntregarMiercoles],[EntregarJueves],[EntregarViernes],[EntregarSabado],[EntregarDomingo])=(1)),
    CONSTRAINT [tbl001_C6_Check_Regla_De_Los_Dos_Dias] CHECK ([dbo].[FN_VALIDACION_CONTRAINT_tbl001_C6]([Dia],[PermiteRemesas],[EntregarLunes],[EntregarMartes],[EntregarMiercoles],[EntregarJueves],[EntregarViernes],[EntregarSabado],[EntregarDomingo])=(1)),
    CONSTRAINT [tbl001_C7_Check_Hora_Limite_Mismo_Dia_Requerido] CHECK (case when [PermiteEntregasMismoDia]=(1) then case when [HoraLimiteMismoDia] IS NOT NULL then (1) else (0) end else (1) end=(1)),
    CONSTRAINT [tbl001_C8_Check_Hora_Limite_Mismo_Dia_Valida] CHECK ([HoraLimiteMismoDia]>=[HoraDesde] AND [HoraLimiteMismoDia]<=[HoraHasta]),
    CONSTRAINT [tbl001_C1_Unique_Dia] UNIQUE NONCLUSTERED ([Dia] ASC)
);

