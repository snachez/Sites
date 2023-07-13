
CREATE PROCEDURE [dbo].[SP_Habilitar_Paises](
	@JSON_IN VARCHAR(MAX),
	@JSON_OUT VARCHAR(MAX) OUTPUT
)
AS
BEGIN
	SET @JSON_IN = REPLACE(@JSON_IN, '\', '')

	--DECLARACION DE TABLA PARA INSERTAR LOS REGISTROS
	DECLARE @p_Tbl_Temp_Paises TABLE   
	(  
		ID INT IDENTITY(1,1),
		Id_Pais INT,
		Activo BIT
	)  

	--INSERTA CADA UNO DE LOS ITEMS EN LA TABLA (SETEANDO LOS VALORES DEL JSON)
	INSERT INTO @p_Tbl_Temp_Paises 
	SELECT DISTINCT -- SE EMPLEA UN DISTINCT PARA EVITAR DUPLICADOS...
		ID,
		ACTIVO
	FROM OPENJSON(@JSON_IN)
	WITH (paises_DTO NVARCHAR(MAX) AS JSON)
	CROSS APPLY OPENJSON(paises_DTO) 
	WITH 
	(
		ID INT,
		ACTIVO BIT
	) 

	--DECLARACION DE VARIABLES PARA RECORRER LA TABLA
	DECLARE @p_Id_Paises_Cursor INT	
	DECLARE @p_Activo_Cursor BIT 
	DECLARE @p_Aux_Activo BIT	
 
	DECLARE @p_1 NVARCHAR(MAX)
	DECLARE @p_2 NVARCHAR(MAX)
	DECLARE @ROW NVARCHAR(MAX)

	IF (@JSON_IN IS NOT NULL OR @JSON_IN != '')
	BEGIN
		BEGIN TRY
			BEGIN TRANSACTION ACTUALIZAR

			------------------------------ RECORRIDO Y SETEO DE DATA DE LA TABLA ------------------------------------
			DECLARE @i INT = 1
			DECLARE @Contador INT = (SELECT COUNT(1) FROM @p_Tbl_Temp_Paises)

			IF @Contador > 0
			BEGIN
				WHILE (@i <= (SELECT MAX(ID) FROM @p_Tbl_Temp_Paises))
				BEGIN
					--OBTIENE UN ITEM
					SELECT 								
						@p_Id_Paises_Cursor = Id_Pais,
						@p_Activo_Cursor = Activo
					FROM @p_Tbl_Temp_Paises 
					WHERE ID = @i

					SET @p_Aux_Activo = NULL	
					SELECT @p_Aux_Activo = (SELECT Activo FROM tblPais WHERE Id = @p_Id_Paises_Cursor)	
					
					IF (@p_Aux_Activo = 1)
					BEGIN   
						UPDATE tblPais SET Activo = 0, FechaModificacion = CURRENT_TIMESTAMP WHERE Id = @p_Id_Paises_Cursor
						SET @ROW = (SELECT * FROM tblPais WHERE Id = @p_Id_Paises_Cursor FOR JSON PATH)												  
					END
					ELSE 
					BEGIN					      									
						UPDATE tblPais SET Activo = 1, FechaModificacion = CURRENT_TIMESTAMP WHERE Id = @p_Id_Paises_Cursor
						SET @ROW = (SELECT * FROM tblPais WHERE Id = @p_Id_Paises_Cursor FOR JSON PATH)		
					END

					SET @i = @i + 1
				END --FIN DEL CICLO

				------------------------------ RESPUESTA A LA APP ------------------------------------
				SELECT @p_1 = 
				(
					SELECT @@ROWCOUNT AS ROWS_AFFECTED,
					CAST(1 AS BIT) AS SUCCESS,
					'Estados de Paises actualizados con exito' AS ERROR_MESSAGE_SP,
					NULL AS ERROR_NUMBER_SP,
					CONVERT(INT, ISNULL(SCOPE_IDENTITY(), -1)) AS ID,
					@ROW AS ROW 
					FOR JSON PATH, INCLUDE_NULL_VALUES
				)

				SELECT @p_2 = (SELECT CAST(@p_1 AS NVARCHAR(MAX)))

				SET @JSON_OUT = (SELECT @p_2)
			END

			--------------------------------------------------------------------------------------------
			--FINAL
			IF @@TRANCOUNT > 0
			BEGIN
				COMMIT TRANSACTION ACTUALIZAR
			END
		END TRY

		BEGIN CATCH
			------------------------------ RESPUESTA A LA APP ------------------------------------
			SELECT @p_1 = 
			(
				SELECT @@ROWCOUNT AS ROWS_AFFECTED,
				CAST(0 AS BIT) AS SUCCESS,
				'Error, al intentar actualizar los estados de paises seleccionados' AS ERROR_MESSAGE_SP,
				NULL AS ERROR_NUMBER_SP,
				CONVERT(INT, ISNULL(SCOPE_IDENTITY(), -1)) AS ID,
				NULL AS ROW 
				FOR JSON PATH, INCLUDE_NULL_VALUES
			)

			SELECT @p_2 = (SELECT CAST(@p_1 AS NVARCHAR(MAX)))

			SET @JSON_OUT = (SELECT @p_2)

			--------------------------------------------------------------------------------------------
			IF @@TRANCOUNT > 0
			BEGIN
				ROLLBACK TRANSACTION ACTUALIZAR
			END
		END CATCH

		GOTO FINALIZAR
	END
	ELSE
	BEGIN
		SELECT @p_1 = 
		(
			SELECT @@ROWCOUNT AS ROWS_AFFECTED,
			CAST(0 AS BIT) AS SUCCESS,
			'Error, se recibieron datos null' AS ERROR_MESSAGE_SP,
			NULL AS ERROR_NUMBER_SP,
			CONVERT(INT, ISNULL(SCOPE_IDENTITY(), -1)) AS ID,
			NULL AS ROW 
			FOR JSON PATH, INCLUDE_NULL_VALUES
		)

		SELECT @p_2 = (SELECT CAST(@p_1 AS NVARCHAR(MAX)))

		SET @JSON_OUT = (SELECT @p_2)

		GOTO FINALIZAR
	END

FINALIZAR:
	RETURN

  --DECLARE @Resultado AS NVARCHAR(MAX)
  --EXECUTE SP_Habilitar_Paises @JSON_IN = '{\"paises_DTO\":[{\"Id\":1,\"Activo\":true}]}', @JSON_OUT = @Resultado OUTPUT
  --SELECT @Resultado

END