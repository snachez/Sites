
CREATE PROCEDURE [dbo].[SP_UpdateHabilitarBanner] (
                                                @Activo int
											  , @FechaModificacion NVARCHAR(36)
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
			UPDATE tblHabilitarBanner SET Activo = @Activo, FechaModificacion = @FechaModificacion;
			SET @NEW_ID = 'CDBAADCC-A24F-47EB-AF27-8E000591C682';
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
				, 'Error: error en el update SP_UpdateHabilitarBanner'			AS SP_ERROR_MESSAGE_DB
				, 0															AS ROWS_AFFECTED
				, -1														AS pk_Id

		--   
	END CATCH
	---
END