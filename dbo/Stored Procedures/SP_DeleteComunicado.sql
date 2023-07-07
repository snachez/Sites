
CREATE PROCEDURE [dbo].[SP_DeleteComunicado] (
                                                @Id NVARCHAR(36)
										     )
AS
BEGIN
	---
	BEGIN TRY
		---
		DECLARE @NEW_ID uniqueidentifier;
		DECLARE @SP_ERROR_MESSAGE_DB NVARCHAR(MAX) = '';
		DECLARE @SP_Error BIT = 0;
		SET DATEFORMAT 'YMD'
		---
		---
	    BEGIN
			---
			DELETE FROM tblComunicado WHERE Id=@Id;
			--UPDATE tblComunicado SET Activo = 0 WHERE Id = @Id;
			SET @NEW_ID = @Id;
			---
		END
		---
		SELECT	  @SP_Error													AS SP_Error
		        , @SP_ERROR_MESSAGE_DB										AS SP_ERROR_MESSAGE_DB 
				, @@ROWCOUNT												AS ROWS_AFFECTED
				, @NEW_ID													AS pk_Id
		---
	END TRY    
	BEGIN CATCH
		--
		SELECT	  CAST(1 AS BIT)											AS SP_Error
				, 'Error: error en el delete SP_DeleteComunicado'			AS SP_ERROR_MESSAGE_DB
				, 0															AS ROWS_AFFECTED
				, -1														AS pk_Id

		--   
	END CATCH
	---
END