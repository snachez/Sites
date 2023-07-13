
CREATE   PROCEDURE [dbo].[SP_HabilitarTipoEfectivo](@ID INT, @ACTIVO BIT)
AS
BEGIN
	---
	BEGIN TRY
		---
			UPDATE tblTipoEfectivo SET Activo = @ACTIVO, FechaModificacion = CURRENT_TIMESTAMP WHERE Id = @ID

		---
		DECLARE @ROW NVARCHAR(MAX) 
		
		SET @ROW  = (SELECT * FROM tblTipoEfectivo WHERE Id = @ID FOR JSON PATH)	

		---
		SELECT	  @@ROWCOUNT												AS ROWS_AFFECTED
				, CAST(1 AS BIT)											AS SUCCESS
				, ''														AS ERROR_MESSAGE_SP
				, NULL														AS ERROR_NUMBER_SP
				, CONVERT(INT, ISNULL(SCOPE_IDENTITY(), -1))				AS ID
				, @ROW														AS ROW
		---
	END TRY    
	BEGIN CATCH
		--	
		DECLARE @ERROR_MESSAGE NVARCHAR(MAX) = ERROR_MESSAGE()
				IF ERROR_MESSAGE() LIKE '%Constrains_Validate_Relaciones_TipoEfectivo%' BEGIN 
			       ---
			       SET @ERROR_MESSAGE = 'Esta Presentación  tiene denominaciones, divisas o unidades de medida activas relacionadas, debe desactivar todas los valores relacionados antes de  desactivar esta presentación'
				   ---
		           END	
	
		SELECT	  CAST(0 AS BIT)											AS SUCCESS
				, @ERROR_MESSAGE											AS ERROR_MESSAGE_SP
				, ERROR_NUMBER()											AS ERROR_NUMBER_SP
				, 0															AS ROWS_AFFECTED
				, -1														AS ID
				, NULL														AS ROW

		--   
	END CATCH
	---
END
---