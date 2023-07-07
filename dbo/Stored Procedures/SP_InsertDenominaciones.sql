CREATE   PROCEDURE [dbo].[SP_InsertDenominaciones] 
(
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
		INSERT INTO tblDenominaciones(ValorNominal, Nombre, IdDivisa,BMO,Imagen, Activo) 
		VALUES(@VALORNOMINAL,@NOMBRE,@DIVISA,@BMO,@IMAGEN,@ACTIVO)
		---
		DECLARE @ROW NVARCHAR(MAX) = (SELECT * FROM tblDenominaciones WHERE Id = ISNULL(SCOPE_IDENTITY(), -1) FOR JSON PATH)
		---
		SELECT	  @@ROWCOUNT												AS ROWS_AFFECTED
				, CAST(1 AS BIT)											AS SUCCESS
				, 'Se registro satisfactoriamente la denominacion!'				AS ERROR_MESSAGE_SP
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