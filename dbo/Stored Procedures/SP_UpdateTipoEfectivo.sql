CREATE PROCEDURE [dbo].[SP_UpdateTipoEfectivo] 
(
@ID INT,
@NOMBRE NVARCHAR(MAX),
@ACTIVO BIT
)
AS
BEGIN
	---
	BEGIN TRY
		---
		UPDATE tblTipoEfectivo SET 
		Nombre = @NOMBRE,
		Activo = @ACTIVO, 
		FechaModificacion = CURRENT_TIMESTAMP 
		WHERE Id = @ID
		---
		DECLARE @ROW NVARCHAR(MAX) = (SELECT * FROM tblTipoEfectivo WHERE Id = @ID FOR JSON PATH)
		---
		SELECT	  @@ROWCOUNT												AS ROWS_AFFECTED
				, CAST(1 AS BIT)											AS SUCCESS
				, 'Se modifico satisfactoriamente el tipo de efectivo!'    			AS ERROR_MESSAGE_SP
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