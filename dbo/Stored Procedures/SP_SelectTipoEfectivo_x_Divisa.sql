



CREATE PROCEDURE [dbo].[SP_SelectTipoEfectivo_x_Divisa](    
																		  @NOMBRE_TIPOEFECTIVO			NVARCHAR(150)  =	NULL
																		, @FK_ID_DIVISA			        INT  =	NULL
																		, @ACTIVO						BIT  =	NULL
																	)
AS
BEGIN
	---
		--EXECUTE SP_SelectTipoEfectivo_x_Divisa @NOMBRE_TIPOEFECTIVO = null,  @FK_ID_DIVISA = 34, @ACTIVO = 1
								
	---
	DECLARE @JSONRESULT NVARCHAR(MAX) = (SELECT     DxT.FkIdTipoEfectivo		AS [Id]											
												  , DxT.NombreTipoEfectivo		AS [Nombre]			

								
										FROM tblDivisa_x_TipoEfectivo DxT	
										WHERE 											
										DxT.Activo = ISNULL(@ACTIVO, DxT.Activo)
										AND DxT.FkIdDivisa = ISNULL(@FK_ID_DIVISA, DxT.FkIdDivisa)
										AND DxT.NombreTipoEfectivo = ISNULL(@NOMBRE_TIPOEFECTIVO, DxT.NombreTipoEfectivo)
										FOR JSON PATH,INCLUDE_NULL_VALUES)
	---
	SELECT @JSONRESULT AS TIPOEFECTIVO_X_DIVISAS_JSONRESULT
	---
END