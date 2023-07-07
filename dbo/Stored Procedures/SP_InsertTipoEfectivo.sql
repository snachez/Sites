CREATE   PROCEDURE [dbo].[SP_InsertTipoEfectivo] (@NOMBRE NVARCHAR(MAX), @ACTIVO BIT)
AS
BEGIN
	---
	BEGIN TRY
		---
		INSERT INTO tblTipoEfectivo(Nombre, Activo) VALUES(@NOMBRE, @ACTIVO)
		---
		DECLARE @ROW NVARCHAR(MAX) = (SELECT * FROM tblTipoEfectivo WHERE Id = ISNULL(SCOPE_IDENTITY(), -1) FOR JSON PATH)
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
		IF @ERROR_MESSAGE LIKE '%Unique_Nombre_TipoEfectivo%' BEGIN 
			---
			SET @ERROR_MESSAGE = 'El nombre del Tipo de Efectivo que intenta ingresar ya existe'
			---
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