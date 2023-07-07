CREATE TABLE [dbo].[tblTipoCambio] (
    [Id]                   INT          IDENTITY (1, 1) NOT NULL,
    [fk_Id_DivisaCotizada] INT          NOT NULL,
    [CompraColones]        DECIMAL (18) NOT NULL,
    [VentaColones]         DECIMAL (18) NOT NULL,
    [Activo]               BIT          DEFAULT ((1)) NOT NULL,
    [FechaCreacion]        DATETIME     DEFAULT (getdate()) NOT NULL,
    [FechaModificacion]    DATETIME     NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);