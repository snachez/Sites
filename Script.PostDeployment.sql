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

IF NOT EXISTS ( SELECT * FROM [dbo].[tblProvincia] where [Id] = 1)
BEGIN
INSERT [dbo].[tblProvincia] ([Id], [Nombre], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (1, N'SAN JOSE', 1, CAST(N'2023-03-08T08:21:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblProvincia] ([Id], [Nombre], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (2, N'ALAJUELA', 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblProvincia] ([Id], [Nombre], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (3, N'CARTA', 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblProvincia] ([Id], [Nombre], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (4, N'HEREDIA', 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblProvincia] ([Id], [Nombre], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (5, N'GUANACASTE', 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblProvincia] ([Id], [Nombre], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (6, N'PUNTARENAS', 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblProvincia] ([Id], [Nombre], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (7, N'LIMON', 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblCanton] ([Id], [Nombre], [fk_Id_Provincia], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (101, N'SAN JOSE', 1, 1, CAST(N'2023-03-08T08:21:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblCanton] ([Id], [Nombre], [fk_Id_Provincia], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (102, N'ESCAZU', 1, 1, CAST(N'2023-03-08T08:21:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblCanton] ([Id], [Nombre], [fk_Id_Provincia], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (103, N'DESAMPARADOS', 1, 1, CAST(N'2023-03-08T08:21:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblCanton] ([Id], [Nombre], [fk_Id_Provincia], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (104, N'PURISCAL', 1, 1, CAST(N'2023-03-08T08:21:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblCanton] ([Id], [Nombre], [fk_Id_Provincia], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (105, N'TARRAZU', 1, 1, CAST(N'2023-03-08T08:21:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblCanton] ([Id], [Nombre], [fk_Id_Provincia], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (106, N'ASERRI', 1, 1, CAST(N'2023-03-08T08:21:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblCanton] ([Id], [Nombre], [fk_Id_Provincia], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (107, N'MORA', 1, 1, CAST(N'2023-03-08T08:21:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblCanton] ([Id], [Nombre], [fk_Id_Provincia], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (108, N'ICOECHEA', 1, 1, CAST(N'2023-03-08T08:21:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblCanton] ([Id], [Nombre], [fk_Id_Provincia], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (109, N'SANTA ANA', 1, 1, CAST(N'2023-03-08T08:21:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblCanton] ([Id], [Nombre], [fk_Id_Provincia], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (110, N'ALAJUELITA', 1, 1, CAST(N'2023-03-08T08:21:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblCanton] ([Id], [Nombre], [fk_Id_Provincia], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (111, N'VAZQUEZ DE CORONADO', 1, 1, CAST(N'2023-03-08T08:21:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblCanton] ([Id], [Nombre], [fk_Id_Provincia], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (112, N'ACOSTA', 1, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblCanton] ([Id], [Nombre], [fk_Id_Provincia], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (113, N'TIBAS', 1, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblCanton] ([Id], [Nombre], [fk_Id_Provincia], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (114, N'MORAVIA', 1, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblCanton] ([Id], [Nombre], [fk_Id_Provincia], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (115, N'MONTES DE OCA', 1, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblCanton] ([Id], [Nombre], [fk_Id_Provincia], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (116, N'TURRUBARES', 1, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblCanton] ([Id], [Nombre], [fk_Id_Provincia], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (117, N'DOTA', 1, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblCanton] ([Id], [Nombre], [fk_Id_Provincia], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (118, N'CURRIDABAT', 1, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblCanton] ([Id], [Nombre], [fk_Id_Provincia], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (119, N'PEREZ ZELEDON', 1, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblCanton] ([Id], [Nombre], [fk_Id_Provincia], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (120, N'LEON CORTES', 1, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblCanton] ([Id], [Nombre], [fk_Id_Provincia], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (201, N'ALAJUELA', 2, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblCanton] ([Id], [Nombre], [fk_Id_Provincia], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (202, N'SAN RAMON', 2, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblCanton] ([Id], [Nombre], [fk_Id_Provincia], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (203, N'GRECIA', 2, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblCanton] ([Id], [Nombre], [fk_Id_Provincia], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (204, N'SAN MATEO', 2, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblCanton] ([Id], [Nombre], [fk_Id_Provincia], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (205, N'ATENAS', 2, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblCanton] ([Id], [Nombre], [fk_Id_Provincia], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (206, N'NARANJO', 2, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblCanton] ([Id], [Nombre], [fk_Id_Provincia], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (207, N'PALMARES', 2, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblCanton] ([Id], [Nombre], [fk_Id_Provincia], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (208, N'POAS', 2, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblCanton] ([Id], [Nombre], [fk_Id_Provincia], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (209, N'OROTINA', 2, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblCanton] ([Id], [Nombre], [fk_Id_Provincia], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (210, N'SAN CARLOS', 2, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblCanton] ([Id], [Nombre], [fk_Id_Provincia], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (211, N'ALFARO RUIZ', 2, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblCanton] ([Id], [Nombre], [fk_Id_Provincia], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (212, N'VALVERDE VEGA', 2, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblCanton] ([Id], [Nombre], [fk_Id_Provincia], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (213, N'UPALA', 2, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblCanton] ([Id], [Nombre], [fk_Id_Provincia], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (214, N'LOS CHILES', 2, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblCanton] ([Id], [Nombre], [fk_Id_Provincia], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (215, N'GUATUSO', 2, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblCanton] ([Id], [Nombre], [fk_Id_Provincia], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (301, N'CARTA', 3, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblCanton] ([Id], [Nombre], [fk_Id_Provincia], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (302, N'PARAISO', 3, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblCanton] ([Id], [Nombre], [fk_Id_Provincia], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (303, N'LA UNION', 3, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblCanton] ([Id], [Nombre], [fk_Id_Provincia], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (304, N'JIMENEZ', 3, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblCanton] ([Id], [Nombre], [fk_Id_Provincia], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (305, N'TURRIALBA', 3, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblCanton] ([Id], [Nombre], [fk_Id_Provincia], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (306, N'ALVARADO', 3, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblCanton] ([Id], [Nombre], [fk_Id_Provincia], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (307, N'OREAMUNO', 3, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblCanton] ([Id], [Nombre], [fk_Id_Provincia], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (308, N'EL GUARCO', 3, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblCanton] ([Id], [Nombre], [fk_Id_Provincia], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (401, N'HEREDIA', 4, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblCanton] ([Id], [Nombre], [fk_Id_Provincia], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (402, N'BARVA', 4, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblCanton] ([Id], [Nombre], [fk_Id_Provincia], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (403, N'SANTO DOMIN', 4, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblCanton] ([Id], [Nombre], [fk_Id_Provincia], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (404, N'SANTA BARBARA', 4, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblCanton] ([Id], [Nombre], [fk_Id_Provincia], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (405, N'SAN RAFAEL', 4, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblCanton] ([Id], [Nombre], [fk_Id_Provincia], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (406, N'SAN ISIDRO', 4, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblCanton] ([Id], [Nombre], [fk_Id_Provincia], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (407, N'BELEN', 4, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblCanton] ([Id], [Nombre], [fk_Id_Provincia], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (408, N'FLORES', 4, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblCanton] ([Id], [Nombre], [fk_Id_Provincia], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (409, N'SAN PABLO', 4, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblCanton] ([Id], [Nombre], [fk_Id_Provincia], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (410, N'SARAPIQUI', 4, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblCanton] ([Id], [Nombre], [fk_Id_Provincia], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (501, N'LIBERIA', 5, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblCanton] ([Id], [Nombre], [fk_Id_Provincia], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (502, N'NICOYA', 5, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblCanton] ([Id], [Nombre], [fk_Id_Provincia], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (503, N'SANTA CRUZ', 5, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblCanton] ([Id], [Nombre], [fk_Id_Provincia], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (504, N'BAGACES', 5, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblCanton] ([Id], [Nombre], [fk_Id_Provincia], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (505, N'CARRILLO', 5, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblCanton] ([Id], [Nombre], [fk_Id_Provincia], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (506, N'CA#AS', 5, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblCanton] ([Id], [Nombre], [fk_Id_Provincia], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (507, N'ABANGARES', 5, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblCanton] ([Id], [Nombre], [fk_Id_Provincia], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (508, N'TILARAN', 5, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblCanton] ([Id], [Nombre], [fk_Id_Provincia], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (509, N'NANDAYURE', 5, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblCanton] ([Id], [Nombre], [fk_Id_Provincia], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (510, N'LA CRUZ', 5, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblCanton] ([Id], [Nombre], [fk_Id_Provincia], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (511, N'HOJANCHA', 5, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblCanton] ([Id], [Nombre], [fk_Id_Provincia], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (601, N'PUNTARENAS', 6, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblCanton] ([Id], [Nombre], [fk_Id_Provincia], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (602, N'ESPARZA', 6, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblCanton] ([Id], [Nombre], [fk_Id_Provincia], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (603, N'BUENOS AIRES', 6, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblCanton] ([Id], [Nombre], [fk_Id_Provincia], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (604, N'MONTES DE ORO', 6, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblCanton] ([Id], [Nombre], [fk_Id_Provincia], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (605, N'OSA', 6, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblCanton] ([Id], [Nombre], [fk_Id_Provincia], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (606, N'AGUIRRE', 6, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblCanton] ([Id], [Nombre], [fk_Id_Provincia], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (607, N'LFITO', 6, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblCanton] ([Id], [Nombre], [fk_Id_Provincia], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (608, N'COTO BRUS', 6, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblCanton] ([Id], [Nombre], [fk_Id_Provincia], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (609, N'PARRITA', 6, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblCanton] ([Id], [Nombre], [fk_Id_Provincia], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (610, N'CORREDORES', 6, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblCanton] ([Id], [Nombre], [fk_Id_Provincia], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (611, N'GARABITO', 6, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblCanton] ([Id], [Nombre], [fk_Id_Provincia], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (701, N'LIMON', 7, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblCanton] ([Id], [Nombre], [fk_Id_Provincia], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (702, N'POCOCI', 7, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblCanton] ([Id], [Nombre], [fk_Id_Provincia], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (703, N'SIQUIRRES', 7, 1, CAST(N'2023-03-08T08:25:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblCanton] ([Id], [Nombre], [fk_Id_Provincia], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (704, N'TALAMANCA', 7, 1, CAST(N'2023-03-08T08:25:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblCanton] ([Id], [Nombre], [fk_Id_Provincia], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (705, N'MATINA', 7, 1, CAST(N'2023-03-08T08:25:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblCanton] ([Id], [Nombre], [fk_Id_Provincia], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (706, N'GUACIMO', 7, 1, CAST(N'2023-03-08T08:25:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (10101, N'CARMEN', 101, 1, CAST(N'2023-03-08T08:21:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (10102, N'MERCED', 101, 1, CAST(N'2023-03-08T08:21:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (10103, N'HOSPITAL', 101, 1, CAST(N'2023-03-08T08:21:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (10104, N'CATEDRAL', 101, 1, CAST(N'2023-03-08T08:21:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (10105, N'ZAPOTE', 101, 1, CAST(N'2023-03-08T08:21:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (10106, N'SAN FRANCISCO DE DOS RIOS', 101, 1, CAST(N'2023-03-08T08:21:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (10107, N'URUCA', 101, 1, CAST(N'2023-03-08T08:21:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (10108, N'MATA REDONDA', 101, 1, CAST(N'2023-03-08T08:21:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (10109, N'PAVAS', 101, 1, CAST(N'2023-03-08T08:21:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (10110, N'HATILLO', 101, 1, CAST(N'2023-03-08T08:21:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (10111, N'SAN SEBASTIAN', 101, 1, CAST(N'2023-03-08T08:21:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (10201, N'ESCAZU', 102, 1, CAST(N'2023-03-08T08:21:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (10202, N'SAN ANTONIO', 102, 1, CAST(N'2023-03-08T08:21:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (10203, N'SAN RAFAEL', 102, 1, CAST(N'2023-03-08T08:21:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (10301, N'DESAMPARADOS', 103, 1, CAST(N'2023-03-08T08:21:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (10302, N'SAN MIGUEL', 103, 1, CAST(N'2023-03-08T08:21:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (10303, N'SAN JUAN DE DIOS', 103, 1, CAST(N'2023-03-08T08:21:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (10304, N'SAN RAFAEL ARRIBA', 103, 1, CAST(N'2023-03-08T08:21:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (10305, N'SAN ANTONIO', 103, 1, CAST(N'2023-03-08T08:21:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (10306, N'FRAILES', 103, 1, CAST(N'2023-03-08T08:21:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (10307, N'PATARRA', 103, 1, CAST(N'2023-03-08T08:21:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (10308, N'SAN CRISTOBAL', 103, 1, CAST(N'2023-03-08T08:21:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (10309, N'ROSARIO', 103, 1, CAST(N'2023-03-08T08:21:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (10310, N'DAMAS', 103, 1, CAST(N'2023-03-08T08:21:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (10311, N'SAN RAFAEL ABAJO', 103, 1, CAST(N'2023-03-08T08:21:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (10312, N'GRAVILIAS', 103, 1, CAST(N'2023-03-08T08:21:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (10313, N'LOS GUIDO', 103, 1, CAST(N'2023-03-08T08:21:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (10401, N'SANTIA', 104, 1, CAST(N'2023-03-08T08:21:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (10402, N'MERCEDES SUR', 104, 1, CAST(N'2023-03-08T08:21:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (10403, N'BARBACOAS', 104, 1, CAST(N'2023-03-08T08:21:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (10404, N'GRIFO ALTO', 104, 1, CAST(N'2023-03-08T08:21:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (10405, N'SAN RAFAEL', 104, 1, CAST(N'2023-03-08T08:21:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (10406, N'CANDELARITA', 104, 1, CAST(N'2023-03-08T08:21:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (10407, N'DESAMPARADITOS', 104, 1, CAST(N'2023-03-08T08:21:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (10408, N'SAN ANTONIO', 104, 1, CAST(N'2023-03-08T08:21:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (10409, N'CHIRES', 104, 1, CAST(N'2023-03-08T08:21:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (10501, N'SAN MARCOS', 105, 1, CAST(N'2023-03-08T08:21:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (10502, N'SAN LORENZO', 105, 1, CAST(N'2023-03-08T08:21:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (10503, N'SAN CARLOS', 105, 1, CAST(N'2023-03-08T08:21:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (10601, N'ASERRI', 106, 1, CAST(N'2023-03-08T08:21:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (10602, N'TARBACA', 106, 1, CAST(N'2023-03-08T08:21:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (10603, N'VUELTA DE JORCO', 106, 1, CAST(N'2023-03-08T08:21:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (10604, N'SAN GABRIEL', 106, 1, CAST(N'2023-03-08T08:21:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (10605, N'LEGUA', 106, 1, CAST(N'2023-03-08T08:21:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (10606, N'MONTERREY', 106, 1, CAST(N'2023-03-08T08:21:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (10607, N'SALITRILLOS', 106, 1, CAST(N'2023-03-08T08:21:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (10701, N'CIUDAD COLON', 107, 1, CAST(N'2023-03-08T08:21:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (10702, N'GUAYABO', 107, 1, CAST(N'2023-03-08T08:21:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (10703, N'TABARCIA', 107, 1, CAST(N'2023-03-08T08:21:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (10704, N'PIEDRAS NEGRAS', 107, 1, CAST(N'2023-03-08T08:21:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (10705, N'PICAGRES', 107, 1, CAST(N'2023-03-08T08:21:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (10801, N'GUADALUPE', 108, 1, CAST(N'2023-03-08T08:21:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (10802, N'SAN FRANCISCO', 108, 1, CAST(N'2023-03-08T08:21:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (10803, N'CALLE BLANCOS', 108, 1, CAST(N'2023-03-08T08:21:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (10804, N'MATA DE PLATANO', 108, 1, CAST(N'2023-03-08T08:21:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (10805, N'IPIS', 108, 1, CAST(N'2023-03-08T08:21:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (10806, N'RANCHO REDONDO', 108, 1, CAST(N'2023-03-08T08:21:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (10807, N'PURRAL', 108, 1, CAST(N'2023-03-08T08:21:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (10901, N'SANTA ANA', 109, 1, CAST(N'2023-03-08T08:21:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (10902, N'SALITRAL', 109, 1, CAST(N'2023-03-08T08:21:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (10903, N'POZOS', 109, 1, CAST(N'2023-03-08T08:21:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (10904, N'URUCA', 109, 1, CAST(N'2023-03-08T08:21:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (10905, N'PIEDADES', 109, 1, CAST(N'2023-03-08T08:21:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (10906, N'BRASIL', 109, 1, CAST(N'2023-03-08T08:21:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (11001, N'ALAJUELITA', 110, 1, CAST(N'2023-03-08T08:21:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (11002, N'SAN JOSECITO', 110, 1, CAST(N'2023-03-08T08:21:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (11003, N'SAN ANTONIO', 110, 1, CAST(N'2023-03-08T08:21:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (11004, N'CONCEPCION', 110, 1, CAST(N'2023-03-08T08:21:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (11005, N'SAN FELIPE', 110, 1, CAST(N'2023-03-08T08:21:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (11006, N'BRASIL', 110, 1, CAST(N'2023-03-08T08:21:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (11101, N'SAN ISIDRO', 111, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (11102, N'SAN RAFAEL', 111, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (11103, N'DULCE NOMBRE', 111, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (11104, N'PATALILLO', 111, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (11105, N'CASCAJAL', 111, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (11201, N'SAN IGNASIO', 112, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (11202, N'GUAITIL', 112, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (11203, N'PALMICHAL', 112, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (11204, N'CANGREJAL', 112, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (11205, N'SABANILLAS', 112, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (11301, N'SAN JUAN', 113, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (11302, N'CINCO ESQUINAS', 113, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (11303, N'ANSELMO LLORENTE', 113, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (11304, N'LEON 13', 113, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (11305, N'COLIMA', 113, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (11401, N'SAN VICENTE', 114, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (11402, N'SAN JERONIMO', 114, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (11403, N'LA TRINIDAD', 114, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (11501, N'SAN PEDRO', 115, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (11502, N'SABANILLA', 115, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (11503, N'MERCEDES', 115, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (11504, N'SAN RAFAEL', 115, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (11601, N'SAN PABLO', 116, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (11602, N'SAN PEDRO', 116, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (11603, N'SAN JUAN DE MATA', 116, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (11604, N'SAN LUIS', 116, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (11605, N'CARARA', 116, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (11701, N'SANTA MARIA', 117, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (11702, N'JARDIN', 117, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (11703, N'COPEY', 117, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (11801, N'CURRIDABAT', 118, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (11802, N'GRANADILLA', 118, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (11803, N'SANCHEZ', 118, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (11804, N'TIRRASES', 118, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (11901, N'SAN ISIDRO DEL GENERAL', 119, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (11902, N'GENERAL', 119, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (11903, N'DANIEL FLORES', 119, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (11904, N'RIVAS', 119, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (11905, N'SAN PEDRO', 119, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (11906, N'PLATANARES', 119, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (11907, N'PEJIBAYE', 119, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (11908, N'CAJON', 119, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (11909, N'BARU', 119, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (11910, N'RIO NUEVO', 119, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (11911, N'PARAMO', 119, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (12001, N'SAN PABLO', 120, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (12002, N'SAN ANDRES', 120, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (12003, N'LLANO BONITO', 120, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (12004, N'SAN ISIDRO', 120, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (12005, N'SANTA CRUZ', 120, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (12006, N'SAN ANTONIO', 120, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (20101, N'ALAJUELA', 201, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (20102, N'BARRIO SAN JOSE', 201, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (20103, N'CARRIZAL', 201, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (20104, N'SAN ANTONIO', 201, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (20105, N'GUACIMA', 201, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (20106, N'SAN ISIDRO', 201, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (20107, N'SABANILLA', 201, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (20108, N'SAN RAFAEL', 201, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (20109, N'RIO SEGUNDO', 201, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (20110, N'DESAMPARADOS', 201, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (20111, N'TURRUCARES', 201, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (20112, N'TAMBOR', 201, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (20113, N'GARITA', 201, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (20114, N'SARAPIQUI', 201, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (20201, N'SAN RAMON', 202, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (20202, N'SANTIA', 202, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (20203, N'SAN JUAN', 202, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (20204, N'PIEDADES NORTE', 202, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (20205, N'PIEDADES SUR', 202, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (20206, N'SAN RAFAEL', 202, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (20207, N'SAN ISIDRO', 202, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (20208, N'ANGELES', 202, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (20209, N'ALFARO', 202, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (20210, N'VOLIO', 202, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (20211, N'CONCEPCION', 202, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (20212, N'ZAPOTAL', 202, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (20213, N'PEÑAS BLANCAS', 202, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (20301, N'GRECIA', 203, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (20302, N'SAN ISIDRO', 203, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (20303, N'SAN JOSE', 203, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (20304, N'SAN ROQUE', 203, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (20305, N'TACARES', 203, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (20306, N'RIO CUARTO', 203, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (20307, N'PUENTE DE PIEDRA', 203, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (20308, N'BOLIVAR', 203, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (20401, N'SAN MATEO', 204, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (20402, N'DESMONTE', 204, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (20403, N'JESUS MARIA', 204, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (20501, N'ATENAS', 205, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (20502, N'JESUS', 205, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (20503, N'MERCEDES', 205, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (20504, N'SAN ISIDRO', 205, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (20505, N'CONCEPCION', 205, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (20506, N'SAN JOSE', 205, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (20507, N'SANTA EULALIA', 205, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (20601, N'NARANJO', 206, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (20602, N'SAN MIGUEL', 206, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (20603, N'SAN JOSE', 206, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (20604, N'CIRRI SURR', 206, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (20605, N'SAN JERONIMO', 206, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (20606, N'SAN JUAN', 206, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (20607, N'ROSARIO', 206, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (20701, N'PALMARES', 207, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (20702, N'ZARAZA', 207, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (20703, N'BUENOS AIRES', 207, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (20704, N'SANTIA', 207, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (20705, N'CANDELARIA', 207, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (20706, N'ESQUIPULAS', 207, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (20707, N'GRANJA', 207, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (20801, N'SAN PEDRO', 208, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (20802, N'SAN JUAN', 208, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (20803, N'SAN RAFAEL', 208, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (20804, N'CARRILLOS', 208, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (20805, N'SABANA REDONDA', 208, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (20901, N'OROTINA', 209, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (20902, N'MASTATE', 209, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (20903, N'HACIENDA VIEJA', 209, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (20904, N'COYOLAR', 209, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (20905, N'CEIBA', 209, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (21001, N'CIUDAD QUESADA', 210, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (21002, N'FLORENCIA', 210, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (21003, N'BUENA VISTA', 210, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (21004, N'AGUAS ZARCAS', 210, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (21005, N'VENECIA', 210, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (21006, N'PITAL', 210, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (21007, N'FORTUNA', 210, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (21008, N'TIGRA', 210, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (21009, N'PALMERA', 210, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (21010, N'VENADO', 210, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (21011, N'CUTRIS', 210, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (21012, N'MONTERREY', 210, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (21013, N'POCOSOL', 210, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (21101, N'ZARCERO', 211, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (21102, N'LAGUNA', 211, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (21103, N'TAPEZCO', 211, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (21104, N'GUADALUPE', 211, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (21105, N'PALMIRA', 211, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (21106, N'ZAPOTE', 211, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (21107, N'BRISA', 211, 1, CAST(N'2023-03-08T08:22:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (21201, N'SARCHI NORTE', 212, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (21202, N'SARCHI SUR', 212, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (21203, N'TORO AMARILLO', 212, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (21204, N'SAN PEDRO', 212, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (21205, N'RODRIGUEZ', 212, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (21301, N'AGUAS CLARAS', 213, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (21302, N'SAN JOSE O PIZOTE', 213, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (21303, N'BIJAGUA', 213, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (21304, N'DELICIAS', 213, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (21305, N'DOS RIOS', 213, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (21306, N'YOLILLAL', 213, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (21307, N'UPALA', 213, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (21401, N'LOS CHILES', 214, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (21402, N'CAÐO NEGRO', 214, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (21403, N'EL AMPARO', 214, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (21404, N'SAN JORGE', 214, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (21501, N'SAN RAFAEL', 215, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (21502, N'BUENA VISTA', 215, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (21503, N'COTE', 215, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (21504, N'KATIRA', 215, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (30101, N'ORIENTAL', 301, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (30102, N'OCCIDENTAL', 301, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (30103, N'CARMEN', 301, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (30104, N'SAN NICOLAS', 301, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (30105, N'AGUACALIENTE ( SAN FRANCISCO)', 301, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (30106, N'GUADALUPE O ARENILLA', 301, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (30107, N'CORRALILLO', 301, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (30108, N'TIERRA BLANCA', 301, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (30109, N'DULCE NOMBRE', 301, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (30110, N'LLANO GRANDE', 301, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (30111, N'QUEBRADILLA', 301, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (30201, N'PARAISO', 302, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (30202, N'SANTIA', 302, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (30203, N'OROSI', 302, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (30204, N'CACHI', 302, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (30301, N'TRES RIOS', 303, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (30302, N'SAN DIE', 303, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (30303, N'SAN JUAN', 303, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (30304, N'SAN RAFAEL', 303, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (30305, N'CONCEPCION', 303, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (30306, N'DULCE NOMBRE', 303, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (30307, N'SAN RAMON', 303, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (30308, N'RIO AZUL', 303, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (30401, N'JUAN VIÑAS', 304, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (30402, N'TUCURRIQUE', 304, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (30403, N'PEJIBAYE', 304, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (30501, N'TURRIALBA', 305, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (30502, N'LA SUIZA', 305, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (30503, N'PERALTA', 305, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (30504, N'SANTA CRUZ', 305, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (30505, N'SANTA TERESITA', 305, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (30506, N'PAVONES', 305, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (30507, N'TUIS', 305, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (30508, N'TAYUTIC', 305, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (30509, N'SANTA ROSA', 305, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (30510, N'TRES EQUIS', 305, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (30511, N'LA ISABEL', 305, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (30512, N'CHIRRIPO', 305, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (30601, N'PACAYAS', 306, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (30602, N'CERVANTES', 306, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (30603, N'CAPELLADES', 306, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (30701, N'SAN RAFAEL', 307, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (30702, N'COT', 307, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (30703, N'POTRERO CERRADO', 307, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (30704, N'CIPRESES', 307, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (30705, N'SANTA ROSA', 307, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (30801, N'TEJAR', 308, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (30802, N'SAN ISIDRO', 308, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (30803, N'TOBOSI', 308, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (30804, N'PATIO DE AGUA', 308, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (40101, N'HEREDIA', 401, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (40102, N'MERCEDES', 401, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (40103, N'SAN FRANCISCO', 401, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (40104, N'ULLOA', 401, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (40105, N'VARABLANCA', 401, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (40201, N'BARVA', 402, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (40202, N'SAN PEDRO', 402, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (40203, N'SAN PABLO', 402, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (40204, N'SAN ROQUE', 402, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (40205, N'SANTA LUCIA', 402, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (40206, N'SAN JOSE DE LA MONTAÑA', 402, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (40301, N'SANTO DOMIN', 403, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (40302, N'SAN VICENTE', 403, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (40303, N'SAN MIGUEL', 403, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (40304, N'PARACITO', 403, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (40305, N'SANTO TOMAS', 403, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (40306, N'SANTA ROSA', 403, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (40307, N'TURES', 403, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (40308, N'PARA', 403, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (40401, N'SANTA BARBARA', 404, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (40402, N'SAN PEDRO', 404, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (40403, N'SAN JUAN', 404, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (40404, N'JESUS', 404, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (40405, N'SANTO DOMIN', 404, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (40406, N'PURABA', 404, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (40501, N'SAN RAFAEL', 405, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (40502, N'SAN JOSECITO', 405, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (40503, N'SANTIA', 405, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (40504, N'ANGELES', 405, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (40505, N'CONCEPCION', 405, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (40601, N'SAN ISIDRO', 406, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (40602, N'SAN JOSE', 406, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (40603, N'CONCEPCION', 406, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (40701, N'SAN ANTONIO', 407, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (40702, N'RIVERA', 407, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (40703, N'ASUNCION', 407, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (40801, N'SAN JOAQUIN', 408, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (40802, N'BARRANTES', 408, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (40803, N'LLORENTE', 408, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (40901, N'SAN PABLO', 409, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (41001, N'PUERTO VIEJO', 410, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (41002, N'LA VIRGEN', 410, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (41003, N'HORQUETAS', 410, 1, CAST(N'2023-03-08T08:23:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (50101, N'LIBERIA', 501, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (50102, N'CAÑAS DULCES', 501, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (50103, N'MAYORGA', 501, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (50104, N'NACASCOLO', 501, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (50105, N'CURUBANDE', 501, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (50201, N'NICOYA', 502, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (50202, N'MANSION', 502, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (50203, N'SAN ANTONIO', 502, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (50204, N'QUEBRADA HONDA', 502, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (50205, N'SAMARA', 502, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (50206, N'NOSARA', 502, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (50207, N'BELEN DE NOSARITA', 502, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (50301, N'SANTA CRUZ', 503, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (50302, N'BOLSON', 503, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (50303, N'VEINTISIETE DE ABRIL', 503, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (50304, N'TEMPATE', 503, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (50305, N'CARTAGENA', 503, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (50306, N'CUAJINIQUIL', 503, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (50307, N'DIRIA', 503, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (50308, N'CABO VELAS', 503, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (50309, N'TAMARINDO', 503, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (50401, N'BAGACES', 504, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (50402, N'FORTUNA', 504, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (50403, N'MOTE', 504, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (50404, N'RIO NARANJO', 504, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (50501, N'FILADELFIA', 505, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (50502, N'PALMIRA', 505, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (50503, N'SARDINAL', 505, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (50504, N'BELEN', 505, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (50601, N'CAÑAS', 506, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (50602, N'PALMIRA', 506, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (50603, N'SAN MIGUEL', 506, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (50604, N'BEBEDERO', 506, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (50605, N'POROZAL', 506, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (50701, N'JUNTAS', 507, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (50702, N'SIERRA', 507, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (50703, N'SAN JUAN', 507, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (50704, N'COLORADO', 507, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (50801, N'TILARAN', 508, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (50802, N'QUEBRADA GRANDE', 508, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (50803, N'TRONADORA', 508, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (50804, N'SANTA ROSA', 508, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (50805, N'LIBANO', 508, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (50806, N'TIERRAS MORENAS', 508, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (50807, N'ARENAL', 508, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (50901, N'CARMONA', 509, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (50902, N'SANTA RITA', 509, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (50903, N'ZAPOTAL', 509, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (50904, N'SAN PABLO', 509, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (50905, N'PORVENIR', 509, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (50906, N'BEJUCO', 509, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (51001, N'LA CRUZ', 510, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (51002, N'SANTA CECILIA', 510, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (51003, N'GARITA', 510, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (51004, N'SANTA ELENA', 510, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (51101, N'HOJANCHA', 511, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (51102, N'MONTE ROMO', 511, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (51103, N'PUERTO CARRILLO', 511, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (51104, N'HUACAS', 511, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (60101, N'PUNTARENAS', 601, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (60102, N'PITAHAYA', 601, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (60103, N'CHOMES', 601, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (60104, N'LEPANTO', 601, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (60105, N'PAQUERA', 601, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (60106, N'MANZANILLO', 601, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (60107, N'GUACIMAL', 601, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (60108, N'BARRANCA', 601, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (60109, N'MONTE VERDE', 601, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (60111, N'COBANO', 601, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (60112, N'CHACARITA', 601, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (60113, N'CHIRA', 601, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (60114, N'ACAPULCO', 601, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (60115, N'EL ROBLE', 601, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (60116, N'ARANCIBIA', 601, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (60201, N'ESPIRITU SANTO', 602, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (60202, N'SAN JUAN GRANDE', 602, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (60203, N'MACACONA', 602, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (60204, N'SAN RAFAEL', 602, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (60205, N'SAN JERONIMO', 602, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (60301, N'BUENOS AIRES', 603, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (60302, N'VOLCAN', 603, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (60303, N'POTRERO GRANDE', 603, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (60304, N'BORUCA', 603, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (60305, N'PILAS', 603, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (60306, N'COLINAS', 603, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (60307, N'CHANGUENA', 603, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (60308, N'BIOLLEY', 603, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (60401, N'MIRAMAR', 604, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (60402, N'UNION', 604, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (60403, N'SAN ISIDRO', 604, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (60501, N'PUERTO CORTES', 605, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (60502, N'PALMAR', 605, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (60503, N'SIERPE', 605, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (60504, N'BAHIA BALLENA', 605, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (60505, N'PIEDRAS BLANCAS', 605, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (60601, N'QUEPOS', 606, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (60602, N'SAVEGRE', 606, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (60603, N'NARANJITO', 606, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (60701, N'LFITO', 607, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (60702, N'PUERTO JIMENEZ', 607, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (60703, N'GUAYCARA', 607, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (60704, N'PAVON', 607, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (60801, N'SAN VITO', 608, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (60802, N'SABALITO', 608, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (60803, N'AGUABUENA', 608, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (60804, N'LIMONCITO', 608, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (60805, N'PITTIER', 608, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (60901, N'PARRITA', 609, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (61001, N'CORREDOR', 610, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (61002, N'LA CUESTA', 610, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (61003, N'CANOAS', 610, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (61004, N'LAUREL', 610, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (61101, N'JACO', 611, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (61102, N'TARCOLES', 611, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (70101, N'LIMON', 701, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (70102, N'VALLE LA ESTRELLA', 701, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (70103, N'RIO BLANCO', 701, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (70104, N'MATAMA', 701, 1, CAST(N'2023-03-08T08:24:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (70201, N'GUAPILES', 702, 1, CAST(N'2023-03-08T08:25:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (70202, N'JIMENEZ', 702, 1, CAST(N'2023-03-08T08:25:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (70203, N'RITA', 702, 1, CAST(N'2023-03-08T08:25:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (70204, N'ROXANA', 702, 1, CAST(N'2023-03-08T08:25:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (70205, N'CARIARI', 702, 1, CAST(N'2023-03-08T08:25:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (70206, N'COLORADO', 702, 1, CAST(N'2023-03-08T08:25:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (70301, N'SIQUIRRES', 703, 1, CAST(N'2023-03-08T08:25:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (70302, N'PACUARITO', 703, 1, CAST(N'2023-03-08T08:25:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (70303, N'FLORIDA', 703, 1, CAST(N'2023-03-08T08:25:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (70304, N'GERMANIA', 703, 1, CAST(N'2023-03-08T08:25:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (70305, N'CAIRO', 703, 1, CAST(N'2023-03-08T08:25:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (70306, N'ALEGRIA', 703, 1, CAST(N'2023-03-08T08:25:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (70401, N'BRATSI', 704, 1, CAST(N'2023-03-08T08:25:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (70402, N'SIXAOLA', 704, 1, CAST(N'2023-03-08T08:25:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (70403, N'CAHUITA', 704, 1, CAST(N'2023-03-08T08:25:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (70404, N'TELIRE', 704, 1, CAST(N'2023-03-08T08:25:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (70501, N'MATINA', 705, 1, CAST(N'2023-03-08T08:25:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (70502, N'BATAN', 705, 1, CAST(N'2023-03-08T08:25:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (70503, N'CARRANDI', 705, 1, CAST(N'2023-03-08T08:25:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (70601, N'GUACIMO', 706, 1, CAST(N'2023-03-08T08:25:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (70602, N'MERCEDES', 706, 1, CAST(N'2023-03-08T08:25:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (70603, N'POCORA', 706, 1, CAST(N'2023-03-08T08:25:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (70604, N'RIO JIMENEZ', 706, 1, CAST(N'2023-03-08T08:25:00' AS SmallDateTime), NULL)

INSERT [dbo].[tblDistrito] ([Id], [Nombre], [fk_Id_Canton], [Activo], [FechaCreacion], [FechaModificacion]) VALUES (70605, N'DUACARI', 706, 1, CAST(N'2023-03-08T08:25:00' AS SmallDateTime), NULL)


END
GO

IF NOT EXISTS ( SELECT * FROM [dbo].[tblDiasHabilesEntregaPedidosInternos] where [Id] = 1)
BEGIN
SET IDENTITY_INSERT [dbo].[tblDiasHabilesEntregaPedidosInternos] ON 

INSERT [dbo].[tblDiasHabilesEntregaPedidosInternos] ([Id], [Dia], [NombreDia], [PermiteRemesas], [PermiteEntregasMismoDia], [EntregarLunes], [EntregarMartes], [EntregarMiercoles], [EntregarJueves], [EntregarViernes], [EntregarSabado], [EntregarDomin], [HoraDesde], [HoraHasta], [HoraLimiteMismoDia], [Codi], [FechaCreacion], [FechaModificacion]) VALUES (1, 1, N'Lunes', 1, 0, 0, 1, 1, 0, 0, 0, 0, CAST(N'08:00:00' AS Time), CAST(N'17:00:00' AS Time), NULL, N'BCAC7C60-881F-4FA9-BF27-2806FDDD70C9', CAST(N'2023-06-13T18:01:00' AS SmallDateTime), CAST(N'2023-06-22T10:55:00' AS SmallDateTime))

INSERT [dbo].[tblDiasHabilesEntregaPedidosInternos] ([Id], [Dia], [NombreDia], [PermiteRemesas], [PermiteEntregasMismoDia], [EntregarLunes], [EntregarMartes], [EntregarMiercoles], [EntregarJueves], [EntregarViernes], [EntregarSabado], [EntregarDomin], [HoraDesde], [HoraHasta], [HoraLimiteMismoDia], [Codi], [FechaCreacion], [FechaModificacion]) VALUES (2, 2, N'Martes', 1, 1, 0, 1, 1, 1, 0, 0, 0, CAST(N'06:00:00' AS Time), CAST(N'11:00:00' AS Time), CAST(N'11:00:00' AS Time), N'55488B1F-81C7-443E-A26B-13D6DCC7C88D', CAST(N'2023-06-13T18:01:00' AS SmallDateTime), CAST(N'2023-06-22T10:55:00' AS SmallDateTime))

INSERT [dbo].[tblDiasHabilesEntregaPedidosInternos] ([Id], [Dia], [NombreDia], [PermiteRemesas], [PermiteEntregasMismoDia], [EntregarLunes], [EntregarMartes], [EntregarMiercoles], [EntregarJueves], [EntregarViernes], [EntregarSabado], [EntregarDomin], [HoraDesde], [HoraHasta], [HoraLimiteMismoDia], [Codi], [FechaCreacion], [FechaModificacion]) VALUES (3, 3, N'Miercoles', 1, 0, 0, 0, 0, 0, 1, 0, 0, CAST(N'06:00:00' AS Time), CAST(N'17:59:00' AS Time), NULL, N'7E630CB8-77E9-44BE-A546-C7B69FBB07AC', CAST(N'2023-06-13T18:01:00' AS SmallDateTime), CAST(N'2023-06-22T10:55:00' AS SmallDateTime))

INSERT [dbo].[tblDiasHabilesEntregaPedidosInternos] ([Id], [Dia], [NombreDia], [PermiteRemesas], [PermiteEntregasMismoDia], [EntregarLunes], [EntregarMartes], [EntregarMiercoles], [EntregarJueves], [EntregarViernes], [EntregarSabado], [EntregarDomin], [HoraDesde], [HoraHasta], [HoraLimiteMismoDia], [Codi], [FechaCreacion], [FechaModificacion]) VALUES (4, 4, N'Jueves', 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, N'54F27E89-C884-4AFC-B103-E6E4CA232DFD', CAST(N'2023-06-13T18:01:00' AS SmallDateTime), CAST(N'2023-06-22T10:55:00' AS SmallDateTime))

INSERT [dbo].[tblDiasHabilesEntregaPedidosInternos] ([Id], [Dia], [NombreDia], [PermiteRemesas], [PermiteEntregasMismoDia], [EntregarLunes], [EntregarMartes], [EntregarMiercoles], [EntregarJueves], [EntregarViernes], [EntregarSabado], [EntregarDomin], [HoraDesde], [HoraHasta], [HoraLimiteMismoDia], [Codi], [FechaCreacion], [FechaModificacion]) VALUES (5, 5, N'Viernes', 1, 0, 0, 0, 0, 0, 0, 1, 1, CAST(N'01:00:00' AS Time), CAST(N'17:00:00' AS Time), NULL, N'2EAEA074-630D-48BB-B321-856A459B60C2', CAST(N'2023-06-13T18:01:00' AS SmallDateTime), CAST(N'2023-06-22T10:55:00' AS SmallDateTime))

INSERT [dbo].[tblDiasHabilesEntregaPedidosInternos] ([Id], [Dia], [NombreDia], [PermiteRemesas], [PermiteEntregasMismoDia], [EntregarLunes], [EntregarMartes], [EntregarMiercoles], [EntregarJueves], [EntregarViernes], [EntregarSabado], [EntregarDomin], [HoraDesde], [HoraHasta], [HoraLimiteMismoDia], [Codi], [FechaCreacion], [FechaModificacion]) VALUES (6, 6, N'Sábado', 1, 1, 1, 1, 0, 0, 0, 1, 0, CAST(N'09:00:00' AS Time), CAST(N'17:30:00' AS Time), CAST(N'17:00:00' AS Time), N'2BF01996-F4A6-4077-8241-ABE6F4D9285B', CAST(N'2023-06-13T18:01:00' AS SmallDateTime), CAST(N'2023-06-22T10:55:00' AS SmallDateTime))

INSERT [dbo].[tblDiasHabilesEntregaPedidosInternos] ([Id], [Dia], [NombreDia], [PermiteRemesas], [PermiteEntregasMismoDia], [EntregarLunes], [EntregarMartes], [EntregarMiercoles], [EntregarJueves], [EntregarViernes], [EntregarSabado], [EntregarDomin], [HoraDesde], [HoraHasta], [HoraLimiteMismoDia], [Codi], [FechaCreacion], [FechaModificacion]) VALUES (7, 7, N'Domin', 1, 0, 1, 1, 0, 0, 0, 0, 0, CAST(N'01:00:00' AS Time), CAST(N'17:50:00' AS Time), NULL, N'560A61AF-3C50-4E1D-A478-2A2C23FE6381', CAST(N'2023-06-13T18:01:00' AS SmallDateTime), CAST(N'2023-06-22T10:55:00' AS SmallDateTime))

SET IDENTITY_INSERT [dbo].[tblDiasHabilesEntregaPedidosInternos] OFF
END
GO

