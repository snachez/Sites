CREATE   PROCEDURE SP_InsertCuentaInterna(@NUMERO_CUENTA NVARCHAR(MAX), @FK_ID_DIVISA INT)
AS
BEGIN
	---
	BEGIN TRY
		---
		INSERT INTO tblCuentaInterna(NumeroCuenta, FkIdDivisa) VALUES(@NUMERO_CUENTA, @FK_ID_DIVISA)
		---
		DECLARE @NEW_ROW NVARCHAR(MAX) = (	SELECT   C.Id						AS [Id]
												   , C.NumeroCuenta				AS [NumeroCuenta]
												   , C.Codigo					AS [Codigo]
												   , C.FkIdDivisa				AS [FkIdDivisa]
												   , C.Activo					AS [Activo]
												   , C.FechaCreacion			AS [FechaCreacion]
												   , C.FechaModificacion		AS [FechaModificacion]
												   
												   , D.Id						AS [Divisa.Id]
												   , D.Nombre					AS [Divisa.Nombre]
												   , D.Nomenclatura				AS [Divisa.Nomenclatura]
												   , D.Simbolo					AS [Divisa.Simbolo]
												   , D.Descripcion				AS [Divisa.Descripcion]
												   , D.Activo					AS [Divisa.Activo]
												   , D.FechaCreacion			AS [Divisa.FechaCreacion]
												   , D.FechaModificacion		AS [Divisa.FechaModificacion]

											FROM tblCuentaInterna C
											INNER JOIN tblDivisa D
											ON C.FkIdDivisa = D.Id
											WHERE C.Id = ISNULL(SCOPE_IDENTITY(), -1) FOR JSON PATH)
		---
		SELECT	  @@ROWCOUNT												AS ROWS_AFFECTED
				, CAST(1 AS BIT)											AS SUCCESS
				, ''														AS ERROR_MESSAGE_SP
				, NULL														AS ERROR_NUMBER_SP
				, CONVERT(INT, ISNULL(SCOPE_IDENTITY(), -1))				AS ID
				, @NEW_ROW													AS ROW
		---
	END TRY    
	BEGIN CATCH
		--
		DECLARE @ERROR_MESSAGE NVARCHAR(MAX) = ERROR_MESSAGE()
		--
		IF @ERROR_MESSAGE LIKE '%Unique_numero_cuenta%' BEGIN 
			---
			SET @ERROR_MESSAGE = 'El numero de cuenta que intenta ingresar ya existe'
			---
		END
		--
		IF @ERROR_MESSAGE LIKE '%the value NULL%' BEGIN 
			---
			IF @ERROR_MESSAGE LIKE '%NumeroCuenta%' BEGIN 
				---
				SET @ERROR_MESSAGE = 'El numero de cuenta es requerido'
				---
			END
			---
			IF @ERROR_MESSAGE LIKE '%FkIdDivisa%' BEGIN 
				---
				SET @ERROR_MESSAGE = 'La divisa es requerida'
				---
			END
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