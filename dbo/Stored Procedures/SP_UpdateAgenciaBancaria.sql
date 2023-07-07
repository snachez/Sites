CREATE PROCEDURE [dbo].[SP_UpdateAgenciaBancaria] (@ID INT, @NOMBRE NVARCHAR(300), @USA_CUENTAS_GRUPO BIT, @ENVIAR_REMESAS BIT, 
@SOLICITAR_REMESAS BIT, @CODIGO_BRANCH NVARCHAR(30), @CODIGO_PROVINCIA INT, @CODIGO_CANTON INT, @CODIGO_DISTRITO INT, @DIRECCION NVARCHAR(450), @ACTIVO BIT)
AS
BEGIN
	---
	BEGIN TRY
		---
		UPDATE tblAgenciaBancaria SET Nombre = @NOMBRE, UsaCuentasGrupo = @USA_CUENTAS_GRUPO, EnviaRemesas = @ENVIAR_REMESAS, SolicitaRemesas = @SOLICITAR_REMESAS,
		CodigoBranch = @CODIGO_BRANCH, CodigoProvincia = @CODIGO_PROVINCIA, CodigoCanton = @CODIGO_CANTON, CodigoDistrito = @CODIGO_DISTRITO, Direccion = @DIRECCION,
		Activo = @ACTIVO, FechaModificacion = CURRENT_TIMESTAMP WHERE Id = @ID
		---
		DECLARE @ROW NVARCHAR(MAX) = (SELECT * FROM tblAgenciaBancaria WHERE Id = @ID FOR JSON PATH)
		---
		SELECT	  @@ROWCOUNT												AS ROWS_AFFECTED
				, CAST(1 AS BIT)											AS SUCCESS
				, 'Se modifico satisfactoriamente la agencia!'    			AS ERROR_MESSAGE_SP
				, NULL														AS ERROR_NUMBER_SP
				, CONVERT(INT, ISNULL(SCOPE_IDENTITY(), -1))				AS ID
				, @ROW														AS ROW
		---
	END TRY    
	BEGIN CATCH
		--
		DECLARE @ERROR_MESSAGE NVARCHAR(MAX) = ERROR_MESSAGE()
		--
		IF @ERROR_MESSAGE LIKE '%Unique_Codigo_Branch%' BEGIN 
			---
			SET @ERROR_MESSAGE = 'El branch de la agencia ya existe'
			---
	    END
		ELSE IF @ERROR_MESSAGE LIKE '%Unique_Codigo_Agencia%' BEGIN 
			---
			SET @ERROR_MESSAGE = 'El nombre de la agencia ya existe'
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