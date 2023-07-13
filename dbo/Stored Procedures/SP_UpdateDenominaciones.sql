CREATE PROCEDURE [dbo].[SP_UpdateDenominaciones] 
(
@ID INT, 
@VALORNOMINAL decimal(18,2),
@NOMBRE NVARCHAR(MAX), 
@DIVISA INT,
@BMO NVARCHAR(MAX),
@IMAGEN VARCHAR(MAX),
@ACTIVO BIT
)
AS
BEGIN
	---
	BEGIN TRY
		---

	DECLARE @ROW NVARCHAR(MAX)
	DECLARE @MESSAGE NVARCHAR(MAX)

				UPDATE tblDenominaciones SET 
				Nombre = @NOMBRE,
				ValorNominal = @VALORNOMINAL,
				IdDivisa = @DIVISA,
				BMO = @BMO,
				Imagen = @IMAGEN,
				Activo = @ACTIVO, 
				FechaModificacion = CURRENT_TIMESTAMP 
				WHERE Id = @ID

				SET @MESSAGE = 'Se modifico satisfactoriamente la denominacion!'

		---
		SET @ROW  = (SELECT * FROM tblDenominaciones WHERE Id = @ID FOR JSON PATH)
		---
		SELECT	  @@ROWCOUNT												AS ROWS_AFFECTED
				, CAST(1 AS BIT)											AS SUCCESS
				, @MESSAGE   												AS ERROR_MESSAGE_SP
				, NULL														AS ERROR_NUMBER_SP
				, CONVERT(INT, ISNULL(SCOPE_IDENTITY(), -1))				AS ID
				, @ROW														AS ROW
		---
	END TRY    
	BEGIN CATCH
		--
		DECLARE @ERROR_MESSAGE NVARCHAR(MAX) = ERROR_MESSAGE()
		--
		IF @ERROR_MESSAGE LIKE '%UNIQUE_NOMINAL_DIVISA_BMO%' BEGIN 
			---
			SET @ERROR_MESSAGE = 'La combinacion de Valor Nominal, el tipo de Divisa y la presentacion ya existen'
			---
	    END	
		IF @ERROR_MESSAGE LIKE '%Contrains_Validate_Relaciones_Denominaciones%' BEGIN 
			---
		  SET @ERROR_MESSAGE = 'Está tratando de activar la denominación con un valor inactivo o invalido'
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