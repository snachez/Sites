
CREATE   PROCEDURE [dbo].[SP_HabilitarTipoEfectivo](@ID INT, @ACTIVO BIT)
AS
BEGIN
	---
	BEGIN TRY
		---

		DECLARE @VALIDATE BIT = 0
		DECLARE @ROW_Asociados INT = 0

		SET @VALIDATE = (SELECT [dbo].FN_VALIDACION_CONTRAINT_DESACTIVAR_tblTipoEfectivo(@ACTIVO,@ID))

		IF(@VALIDATE = 0)
		BEGIN
			UPDATE tblTipoEfectivo SET Activo = @ACTIVO, FechaModificacion = CURRENT_TIMESTAMP WHERE Id = @ID
		END
		ELSE
		BEGIN
			 SET @ROW_Asociados = @ROW_Asociados + 1;
		END


		
		
		---
		DECLARE @ROW NVARCHAR(MAX) 

		IF(@ROW_Asociados = 0)
		BEGIN		
		SET @ROW  = (SELECT * FROM tblTipoEfectivo WHERE Id = @ID FOR JSON PATH)
		END
		ELSE
		BEGIN
		SET @ROW = 'Esta Presentación  tiene denominaciones, divisas o unidades de medida activas relacionadas, debe desactivar todas los valores relacionados antes de  desactivar esta presentación'
		END
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