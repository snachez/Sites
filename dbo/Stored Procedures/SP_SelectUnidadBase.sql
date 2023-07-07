
CREATE   PROCEDURE [dbo].[SP_SelectUnidadBase] (	  @ID		INT = NULL
												, @NOMBRE	NVARCHAR(MAX) = NULL
												, @ACTIVO	BIT = NULL
											  )
AS
BEGIN
	---
	SELECT *
	FROM tblUnidadBase
	WHERE 	ISNULL(@ID, Id)				= Id
	AND		ISNULL(@NOMBRE, Nombre)		= Nombre
	AND		ISNULL(@ACTIVO, Activo)		= Activo
	---
END