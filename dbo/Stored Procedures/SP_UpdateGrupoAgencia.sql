﻿CREATE PROCEDURE [dbo].[SP_UpdateGrupoAgencia] (@ID INT, @NOMBRE NVARCHAR(300), @ENVIAR_REMESAS BIT, @SOLICITAR_REMESAS BIT,  @ACTIVO BIT)
AS
BEGIN
	---
	BEGIN TRY
		---
		UPDATE tblGrupoAgencia SET Nombre = @NOMBRE, EnviaRemesas = @ENVIAR_REMESAS, SolicitaRemesas = @SOLICITAR_REMESAS, Activo = @ACTIVO, FechaModificacion = CURRENT_TIMESTAMP WHERE Id = @ID
		---
		DECLARE @ROW NVARCHAR(MAX) = (SELECT * FROM tblGrupoAgencia WHERE Id = @ID FOR JSON PATH)
		---
		SELECT	  @@ROWCOUNT												AS ROWS_AFFECTED
				, CAST(1 AS BIT)											AS SUCCESS
				, 'Se modifico satisfactoriamente el grupo!'    			AS ERROR_MESSAGE_SP
				, NULL														AS ERROR_NUMBER_SP
				, CONVERT(INT, ISNULL(SCOPE_IDENTITY(), -1))				AS ID
				, @ROW														AS ROW
		---
	END TRY    
	BEGIN CATCH
		--
		DECLARE @ERROR_MESSAGE NVARCHAR(MAX) = ERROR_MESSAGE()
		--
		IF @ERROR_MESSAGE LIKE '%Unique_Nombre_Grupo_Agencia%' BEGIN 
			---
			SET @ERROR_MESSAGE = 'El nombre del grupo que intenta ingresar ya existe'
			---
		END
		--
		SELECT	  0															AS ROWS_AFFECTED
		        , CAST(0 AS BIT)											AS SUCCESS
				, @ERROR_MESSAGE											AS ERROR_MESSAGE_SP
				, ERROR_NUMBER()											AS ERROR_NUMBER_SP
				, -1														AS ID
				, NULL														AS ROW

		--   
	END CATCH
	---
END
---