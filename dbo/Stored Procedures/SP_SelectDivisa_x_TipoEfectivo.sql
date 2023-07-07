CREATE PROCEDURE [dbo].[SP_SelectDivisa_x_TipoEfectivo](    
																		  @ID							INT  =	NULL
																		, @FK_ID_DIVISA			        INT  =	NULL
																		, @FK_ID_TIPOEFECTIVO			INT  =	NULL
																		, @ACTIVO						BIT  =	NULL
																	)
AS
BEGIN
	---
										
	---

	DECLARE @JSONRESULT NVARCHAR(MAX) = (SELECT     DxT.Id						AS [Id]											
												  , DxT.Activo					AS [Activo]
												  , DxT.FechaCreacion			AS [FechaCreacion]
												  , DxT.FechaModificacion		AS [FechaModificacion]

												  , DI.Id						AS [Divisa.Id]
												  , DI.Nombre					AS [Divisa.Nombre]
												  , DI.Nomenclatura			    AS [Divisa.Nomenclatura]
												  , DI.Simbolo					AS [Divisa.Simbolo]
												  , DI.Descripcion				AS [Divisa.Descripcion]
												  , DI.Activo					AS [Divisa.Activo]
												  , DI.FechaCreacion			AS [Divisa.FechaCreacion]
												  , DI.FechaModificacion		AS [Divisa.FechaModificacion]

												  ,TE.[Id]					        AS [TipoEfectivo.Id]
												  ,TE.[Nombre]                     AS [TipoEfectivo.Nombre]
												  ,TE.[Activo]                     AS [TipoEfectivo.Activo]
												  ,TE.[FechaCreacion]              AS [TipoEfectivo.FechaCreacion]
												  ,TE.[FechaModificacion]          AS [TipoEfectivo.FechaModificacion]
								
										FROM tblDivisa_x_TipoEfectivo DxT
										INNER JOIN tblDivisa DI
										ON DxT.FkIdDivisa = DI.Id
										INNER JOIN tblTipoEfectivo TE
										ON DxT.FkIdTipoEfectivo = TE.Id
										WHERE DxT.Id = ISNULL(@ID, DxT.Id)		
										AND DxT.Activo = ISNULL(@ACTIVO, DxT.Activo)
										AND DxT.FkIdDivisa = ISNULL(@FK_ID_DIVISA, DxT.FkIdDivisa)
										AND DxT.FkIdTipoEfectivo = ISNULL(@FK_ID_TIPOEFECTIVO, DxT.FkIdTipoEfectivo)
										FOR JSON PATH)
	---
	SELECT @JSONRESULT AS DENOMINACIONES_X_AREAS_JSONRESULT
	---
END