
CREATE   PROCEDURE [dbo].[SP_SelectColaborador] (	  @USER_ACTIVE_DIRECTORY NVARCHAR(MAX) = NULL
													, @ACTIVO	BIT = NULL
											   )
AS
BEGIN
	---
	SELECT *
	FROM tblColaborador
	WHERE	ISNULL(@ACTIVO, Activo)		= Activo
	AND		ISNULL(@USER_ACTIVE_DIRECTORY, UserActiveDirectory)	= UserActiveDirectory
	---
END