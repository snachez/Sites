

CREATE   PROCEDURE [dbo].[SP_InsertCliente] (		  
													  @NOMBRE           NVARCHAR(MAX)
													, @CIF				NVARCHAR(MAX)
										   )
AS
BEGIN
	---
	BEGIN TRY
		---
		DECLARE @EXISTE_CIF BIT = 0
		DECLARE @NEW_ID INT = -1
		DECLARE @SP_ERROR_MESSAGE_DB NVARCHAR(MAX) = ''
		DECLARE @SP_Error BIT = 0
		---
		SELECT @EXISTE_CIF = 1 FROM tblCliente WHERE CIF = @CIF AND Activo = 1
		---
		IF @EXISTE_CIF = 1 BEGIN
			---
			SET @SP_Error = 1
			SET @SP_ERROR_MESSAGE_DB = 'El CIF que intenta ingresar existe actualmente'
			---
		END ELSE BEGIN
			---
			INSERT INTO tblCliente(Nombre, CIF) VALUES(@NOMBRE, @CIF)
			SET @NEW_ID = CONVERT(INT, ISNULL(SCOPE_IDENTITY(), -1))
			---
		END
		---
		SELECT	  @@ROWCOUNT												AS ROWS_AFFECTED
				, @SP_Error													AS SP_Error
				, @SP_ERROR_MESSAGE_DB										AS SP_ERROR_MESSAGE_DB 
				, @NEW_ID													AS pk_Id
		---
	END TRY    
	BEGIN CATCH
		--
		SELECT	  CAST(1 AS BIT)											AS SP_Error
				, 'Error: error en el insert SP_InsertCliente'				AS SP_ERROR_MESSAGE_DB
				, 0															AS ROWS_AFFECTED
				, -1														AS pk_Id

		--   
	END CATCH
	---
END