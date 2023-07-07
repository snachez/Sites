CREATE   PROCEDURE [dbo].[SP_SelectDenominaciones_x_Modulo](    
																		  @ID							INT  =	NULL
																		, @FK_ID_DENOMINACIONES			INT  =	NULL
																		, @FK_ID_Modulo					INT  =	NULL
																		, @ACTIVO						BIT  =	NULL
																	)
AS
BEGIN
	---
										
	---

	DECLARE @JSONRESULT NVARCHAR(MAX) = (SELECT     DxA.Id						AS [Id]											
												  , DxA.Activo					AS [Activo]
												  , DxA.FechaCreacion			AS [FechaCreacion]
												  , DxA.FechaModificacion		AS [FechaModificacion]

												  , D.Id						AS [Denominaciones.Id]
												  , D.Nombre					AS [Denominaciones.Nombre]
												  , D.ValorNominal				AS [Denominaciones.ValorNominal]
												  , D.BMO    				    AS [Denominaciones.BMO]
												  , D.IdDivisa					AS [Denominaciones.IdDivisa]
												  , D.Imagen					AS [Denominaciones.Imagen]																						
												  , D.Activo					AS [Denominaciones.Activo]
												  , D.FechaCreacion				AS [Denominaciones.FechaCreacion]
												  , D.FechaModificacion			AS [Denominaciones.FechaModificacion]

												  , DI.Id						AS [Divisa.Id]
												  , DI.Nombre					AS [Divisa.Nombre]
												  , DI.Nomenclatura			    AS [Divisa.Nomenclatura]
												  , DI.Simbolo					AS [Divisa.Simbolo]
												  , DI.Descripcion				AS [Divisa.Descripcion]
												  , DI.Activo					AS [Divisa.Activo]
												  , DI.FechaCreacion			AS [Divisa.FechaCreacion]
												  , DI.FechaModificacion		AS [Divisa.FechaModificacion]

												  , A.Id						AS [Modulo.Id]
												  , A.Nombre					AS [Modulo.Nombre]												  
												  , A.FechaCreacion				AS [Modulo.FechaCreacion]
												  , A.FechaModificacion			AS [Modulo.FechaModificacion]

								                  , TE.Id						AS [TipoEfectivo.Id]
												  , TE.Nombre					AS [TipoEfectivo.Nombre]	
												  , TE.Activo					AS [TipoEfectivo.Activo]
												  , TE.FechaCreacion		    AS [TipoEfectivo.FechaCreacion]
												  , TE.FechaModificacion		AS [TipoEfectivo.FechaModificacion]

										FROM tblDenominaciones_x_Modulo DxA
										INNER JOIN tblDenominaciones D
										ON DxA.FkIdDenominaciones = D.Id
										INNER JOIN tblModulo A
										ON DxA.FkIdModulo = A.Id		
										INNER JOIN tblDivisa DI
										ON D.IdDivisa = DI.Id
										INNER JOIN tblTipoEfectivo TE
										ON D.BMO = TE.Id
										WHERE DxA.Id = ISNULL(@ID, DxA.Id)		
										AND DxA.Activo = ISNULL(@ACTIVO, DxA.Activo)
										AND DxA.FkIdModulo = ISNULL(@FK_ID_Modulo, DxA.FkIdModulo)
										AND DxA.FkIdDenominaciones = ISNULL(@FK_ID_DENOMINACIONES, DxA.FkIdDenominaciones)
										FOR JSON PATH)
	---
	SELECT @JSONRESULT AS DENOMINACIONES_X_Modulo_JSONRESULT
	---
END