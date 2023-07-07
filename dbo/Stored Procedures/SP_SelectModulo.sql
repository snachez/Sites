
CREATE   PROCEDURE [dbo].[SP_SelectModulo] (		  @ID						NVARCHAR(MAX)  =	NULL
												, @NOMBRE					NVARCHAR(MAX)  =	NULL
												, @ACTIVO					NVARCHAR(MAX)  =	NULL
										  )
AS
BEGIN
	---
										
	---

	DECLARE @JSONRESULT NVARCHAR(MAX) = (SELECT    A.Id		     				 AS [Id]
												 , A.Nombre					     AS [Nombre]
												 , A.Activo				    	 AS [Activo]
												 , A.FechaCreacion				 AS [FechaCreacion]
												 , A.FechaModificacion			 AS [FechaModificacion]
										FROM tblModulo A
										WHERE A.Id = ISNULL(@ID, A.Id)
										AND A.Nombre = ISNULL(@NOMBRE, A.Nombre)
										AND A.Activo = ISNULL(@ACTIVO, A.Activo)
										FOR JSON PATH)
	---
	SELECT @JSONRESULT AS Modulo_JSONRESULT
	---
	---
END