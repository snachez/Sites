CREATE   PROCEDURE [dbo].[SP_InsertAgenciaBancaria](	  @NOMBRE					NVARCHAR(MAX)
													, @FK_ID_GRUPO_AGENCIA		INT
													, @USA_CUENTAS_GRUPO		BIT
													, @ENVIA_REMESAS			BIT
													, @SOLICITA_REMESAS			BIT
													, @CODIGO_BRANCH			NVARCHAR(MAX)
													, @CODIGO_PROVINCIA			NVARCHAR(MAX)
													, @CODIGO_CANTON			NVARCHAR(MAX)
													, @CODIGO_DISTRITO			NVARCHAR(MAX)
													, @DIRECCION				NVARCHAR(MAX)
												  )
AS
BEGIN
	---
	BEGIN TRY
		---
		INSERT INTO tblAgenciaBancaria		(		 
												  Nombre
												, FkIdGrupoAgencia
												, UsaCuentasGrupo
												, EnviaRemesas
												, SolicitaRemesas
												, CodigoBranch
												, CodigoProvincia
												, CodigoCanton
												, CodigoDistrito
												, Direccion
											) 

											VALUES

											(
												  @NOMBRE				
												, @FK_ID_GRUPO_AGENCIA	
												, @USA_CUENTAS_GRUPO	
												, @ENVIA_REMESAS		
												, @SOLICITA_REMESAS		
												, @CODIGO_BRANCH		
												, @CODIGO_PROVINCIA		
												, @CODIGO_CANTON		
												, @CODIGO_DISTRITO		
												, @DIRECCION			
											)
			---
		DECLARE @ROW NVARCHAR(MAX) = (SELECT * FROM tblAgenciaBancaria WHERE Id = ISNULL(SCOPE_IDENTITY(), -1) FOR JSON PATH)
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
		--
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