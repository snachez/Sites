/*
Post-Deployment Script Template							
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be appended to the build script.		
 Use SQLCMD syntax to include a file in the post-deployment script.			
 Example:      :r .\myfile.sql								
 Use SQLCMD syntax to reference a variable in the post-deployment script.		
 Example:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/
Use [Sites.Global];
GO

IF NOT EXISTS (SELECT * FROM [dbo].[tblColaborador] WHERE [Nombre] = 'Esteban' AND [Apellido1] = 'Cordoba' AND [Apellido2] = 'Calderon')
BEGIN
INSERT [dbo].[tblColaborador] ([Nombre], [Apellido1], [Apellido2], [Cedula], [UserActiveDirectory], [Activo], [Correo], [FechaCreacion], [FechaModificacion]) VALUES (N'Esteban ', N'Cordoba', N'Calderon', N'60011013', N'ecordoba', 1, N'ecordobaca@baccredomatic.cr', CAST(N'2023-01-10T08:41:27.797' AS DateTime), NULL);
END
GO

IF NOT EXISTS ( SELECT * FROM [dbo].[tblHabilitarBanner] where [Id] = 'cdbaadcc-a24f-47eb-af27-8e000591c682')
BEGIN
INSERT [dbo].[tblHabilitarBanner] ([Id], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (N'cdbaadcc-a24f-47eb-af27-8e000591c682', 1, CAST(N'2023-01-19T10:18:00' AS SmallDateTime), CAST(N'2023-02-15T17:17:00' AS SmallDateTime));
END
GO

IF NOT EXISTS ( SELECT * FROM [dbo].[tblDivisa] where [Nombre] = 'Colón' OR [Nombre] = 'Dólar' OR [Nombre] = 'Euro')
BEGIN
SET IDENTITY_INSERT [dbo].[tblDivisa] ON 

INSERT [dbo].[tblDivisa] ([Id], [Nombre], [Nomenclatura], [Simbolo], [Descripcion], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (1, N'Colón', N'CRC', N'¢', N'Moneda De Costa Rica', 1, CAST(N'2023-01-24T10:16:00' AS SmallDateTime), NULL)
INSERT [dbo].[tblDivisa] ([Id], [Nombre], [Nomenclatura], [Simbolo], [Descripcion], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (2, N'Dólar', N'USD', N'$', N'Moneda De Estados Unidos', 1, CAST(N'2023-01-24T10:16:00' AS SmallDateTime), NULL)
INSERT [dbo].[tblDivisa] ([Id], [Nombre], [Nomenclatura], [Simbolo], [Descripcion], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (3, N'Euro', N'EUR', N'€', N'Moneda De La Union Europea', 1, CAST(N'2023-01-24T10:16:00' AS SmallDateTime), NULL)
SET IDENTITY_INSERT [dbo].[tblDivisa] OFF
END
GO

IF NOT EXISTS ( SELECT * FROM [dbo].[tblTipoCambio] where [FechaCreacion] = CAST(N'2023-01-24T10:20:36.233' AS DateTime) OR [FechaCreacion] = CAST(N'2023-01-24T13:02:05.863' AS DateTime))
BEGIN
SET IDENTITY_INSERT [dbo].[tblTipoCambio] ON 

INSERT [dbo].[tblTipoCambio] ([Id], [fk_Id_DivisaCotizada], [CompraColones], [VentaColones], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (1, 2, CAST(630 AS Decimal(18, 0)), CAST(645 AS Decimal(18, 0)), 1, CAST(N'2023-01-24T10:20:36.233' AS DateTime), NULL)
INSERT [dbo].[tblTipoCambio] ([Id], [fk_Id_DivisaCotizada], [CompraColones], [VentaColones], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (2, 3, CAST(720 AS Decimal(18, 0)), CAST(810 AS Decimal(18, 0)), 1, CAST(N'2023-01-24T13:02:05.863' AS DateTime), NULL)
SET IDENTITY_INSERT [dbo].[tblTipoCambio] OFF
END
GO

IF NOT EXISTS ( SELECT * FROM [dbo].[tblTipoComunicado] where [Id] = '1d97da84-26ad-4038-9e3b-05730d187a1e' OR [Id] = '142f65e5-68ab-4441-9145-45bc6a576b67' OR [Id] = '8f1915e4-9911-4082-a1d2-9e570459292b')
BEGIN
INSERT [dbo].[tblTipoComunicado] ([Id], [Nombre], [Imagen], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (N'1d97da84-26ad-4038-9e3b-05730d187a1e', N'Informativo', N'#1075BB', 1, CAST(N'2023-01-19T08:51:00' AS SmallDateTime), NULL)
INSERT [dbo].[tblTipoComunicado] ([Id], [Nombre], [Imagen], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (N'142f65e5-68ab-4441-9145-45bc6a576b67', N'Correctivo', N'#E4002B', 1, CAST(N'2023-01-19T09:15:00' AS SmallDateTime), NULL)
INSERT [dbo].[tblTipoComunicado] ([Id], [Nombre], [Imagen], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (N'8f1915e4-9911-4082-a1d2-9e570459292b', N'Advertencia', N'#F5881F', 1, CAST(N'2023-01-19T09:20:00' AS SmallDateTime), NULL)
END
GO




