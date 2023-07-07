

CREATE   PROCEDURE [dbo].[SP_SelectTransportadora] (		  @ID		INT = NULL
														, @NOMBRE	NVARCHAR(MAX) = NULL
														, @ACTIVO	BIT = NULL
												  )
AS
BEGIN
	---
	SELECT *
	FROM tblTransportadora
	WHERE 	ISNULL(@ID, Id)				= Id
	AND		ISNULL(@NOMBRE, Nombre)		= Nombre
	AND		ISNULL(@ACTIVO, Activo)		= Activo
	---
END