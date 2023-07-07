



CREATE   PROCEDURE [dbo].[SP_DeleteCliente] (@ID NVARCHAR(MAX))
AS
BEGIN
	---
	BEGIN TRY
		---
		UPDATE tblCliente SET Activo = 0 WHERE Id = @ID
		---
		SELECT	  @@ROWCOUNT												AS ROWS_AFFECTED
				, ''														AS SP_Error
				, ''														AS SP_ERROR_MESSAGE_DB 
				, @ID														AS pk_Id
		---
	END TRY    
	BEGIN CATCH
		--
		SELECT	  CAST(1 AS BIT)											AS SP_Error
				, 'Error: error en el insert SP_DeleteCliente'			AS SP_ERROR_MESSAGE_DB
				, 0															AS ROWS_AFFECTED
				, -1														AS pk_Id

		--   
	END CATCH
	---
END