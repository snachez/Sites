CREATE   PROCEDURE [dbo].[SP_InsertGrupoAgencia] (@NOMBRE NVARCHAR(MAX), @ENVIAR_REMESAS BIT, @SOLICITAR_REMESAS BIT, @ACTIVO BIT)
AS
BEGIN
	---
	BEGIN TRY
		---
		INSERT INTO tblGrupoAgencia(Nombre, EnviaRemesas, SolicitaRemesas, Activo) VALUES(@NOMBRE, @ENVIAR_REMESAS, @SOLICITAR_REMESAS, @ACTIVO)
		---
		DECLARE @ROW NVARCHAR(MAX) = (SELECT * FROM tblGrupoAgencia WHERE Id = ISNULL(SCOPE_IDENTITY(), -1) FOR JSON PATH)
		---
		SELECT	  @@ROWCOUNT												AS ROWS_AFFECTED
				, CAST(1 AS BIT)											AS SUCCESS
				, 'Se registro satisfactoriamente el grupo!'				AS ERROR_MESSAGE_SP
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