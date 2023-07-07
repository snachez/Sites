CREATE PROCEDURE [dbo].[SP_UpdateDivisa] 
(
@ID     INT,
@NOMBRE NVARCHAR(MAX), 
@NOMENCLATURA	NVARCHAR(MAX),
@DESCRIPCION	NVARCHAR(MAX)
)
AS
BEGIN
	---
	BEGIN TRY
		---
		UPDATE tblDivisa SET 
		Nombre = @NOMBRE,
		Nomenclatura = @NOMENCLATURA,
		Descripcion = @DESCRIPCION, 
		FechaModificacion = CURRENT_TIMESTAMP 
		WHERE Id = @ID
		---
		DECLARE @ROW NVARCHAR(MAX) = (SELECT * FROM tblDivisa WHERE Id = @ID FOR JSON PATH)
		---
		SELECT	  @@ROWCOUNT												AS ROWS_AFFECTED
				, CAST(1 AS BIT)											AS SUCCESS
				, 'Se modifico satisfactoriamente la divisa!'    			AS ERROR_MESSAGE_SP
				, NULL														AS ERROR_NUMBER_SP
				, CONVERT(INT, ISNULL(SCOPE_IDENTITY(), -1))				AS ID
				, @ROW														AS ROW
		---
	END TRY    
	BEGIN CATCH
		--
		DECLARE @ERROR_MESSAGE NVARCHAR(MAX) = ERROR_MESSAGE()
		--
		IF @ERROR_MESSAGE LIKE '%Unique_Nombre_Divisa%' BEGIN 
			---
			SET @ERROR_MESSAGE = 'El nombre de la divisa ya existe'
			---
	    END	
		IF @ERROR_MESSAGE LIKE '%Unique_Nomenclatura_Divisa%' BEGIN 
			---
			SET @ERROR_MESSAGE = 'El simbolo de la divisa ya existe'
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