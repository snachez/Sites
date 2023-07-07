CREATE   PROCEDURE [dbo].[SP_SelectCliente] (	  @ID		INT = NULL
												, @IDS		INT = NULL
												, @NOMBRE	NVARCHAR(MAX) = NULL
												, @ACTIVO	BIT = NULL
												, @CIF		INT = NULL
										   )
AS
BEGIN
	---
	SELECT *
	FROM tblCliente
	WHERE 	ISNULL(@ID, Id)				= Id
	AND		ISNULL(@NOMBRE, Nombre)		= Nombre
	AND		ISNULL(@ACTIVO, Activo)		= Activo
	AND		ISNULL(@CIF, CIF)			= CIF
	---
END


EXEC SP_SelectCliente @CIF = 2035589