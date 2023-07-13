
CREATE PROCEDURE [dbo].[SP_Habilitar_Unidades_Medidas](
	@JSON_IN VARCHAR(MAX),
	@JSON_OUT VARCHAR(MAX) OUTPUT
)
AS
BEGIN
	SET @JSON_IN = REPLACE(@JSON_IN, '\', '')

	--DECLARACION DE TABLA PARA INSERTAR LOS REGISTROS
	DECLARE @p_Tbl_Temp_Unidad_Medidas TABLE   
	(  
		ID INT IDENTITY(1,1),
		Id_Unidad_Medida INT,
		Activo BIT
	)  

	--INSERTA CADA UNO DE LOS ITEMS EN LA TABLA (SETEANDO LOS VALORES DEL JSON)
	INSERT INTO @p_Tbl_Temp_Unidad_Medidas	 
	SELECT 
		Id,
		Activo
	FROM OPENJSON (@JSON_IN)
	WITH (unidades_Medidas_DTO NVARCHAR(MAX) AS JSON)
	CROSS APPLY OPENJSON (unidades_Medidas_DTO) 
	WITH 
	(
		Id INT,
		Activo BIT
	) 

	--DECLARACION DE VARIABLES PARA RECORRER LA TABLA
	DECLARE @p_Id_Unidad_Medida_Cursor INT	
	DECLARE @p_Activo_Cursor BIT 
	DECLARE @p_Aux_Activo BIT	
 
	DECLARE @p_1 NVARCHAR(MAX)
	DECLARE @p_2 NVARCHAR(MAX)
	DECLARE @ROW NVARCHAR(MAX)
    DECLARE @ERROR_NUMBER_SP_Unidad_Medidas NVARCHAR(MAX) = NULL
	DECLARE @ID_ERROR_Unidad_Medidas NVARCHAR(MAX) = CONVERT(INT, ISNULL(SCOPE_IDENTITY(), -1))
	DECLARE @ROW_ERROR_Unidad_Medidas NVARCHAR(MAX) = NULL

	IF (@JSON_IN IS NOT NULL OR @JSON_IN != '')
	BEGIN
		BEGIN TRY
			BEGIN TRANSACTION ACTUALIZAR

			------------------------------ RECORRIDO Y SETEO DE DATA DE LA TABLA ------------------------------------
			DECLARE @i INT = 1
			DECLARE @Contador INT = (SELECT COUNT(1) FROM @p_Tbl_Temp_Unidad_Medidas)

			IF @Contador > 0
			BEGIN
				WHILE (@i <= (SELECT MAX(ID) FROM @p_Tbl_Temp_Unidad_Medidas))
				BEGIN
					--OBTIENE UN ITEM
					SELECT 								
						@p_Id_Unidad_Medida_Cursor = Id_Unidad_Medida,
						@p_Activo_Cursor = Activo
					FROM @p_Tbl_Temp_Unidad_Medidas 
					WHERE ID = @i

					SET @p_Aux_Activo = NULL	
					SELECT @p_Aux_Activo = (SELECT Activo FROM tblUnidadMedida WHERE Id = @p_Id_Unidad_Medida_Cursor)	
					
					IF (@p_Aux_Activo = 1)
					BEGIN   
						UPDATE tblUnidadMedida SET Activo = 0, Fecha_Modificacion = CURRENT_TIMESTAMP WHERE Id = @p_Id_Unidad_Medida_Cursor
						SET @ROW = (SELECT * FROM tblUnidadMedida WHERE Id = @p_Id_Unidad_Medida_Cursor FOR JSON PATH)												  
					END
					ELSE 
					BEGIN					      									
						UPDATE tblUnidadMedida SET Activo = 1, Fecha_Modificacion = CURRENT_TIMESTAMP WHERE Id = @p_Id_Unidad_Medida_Cursor
						SET @ROW = (SELECT * FROM tblUnidadMedida WHERE Id = @p_Id_Unidad_Medida_Cursor FOR JSON PATH)		
					END

					SET @i = @i + 1
				END --FIN DEL CICLO

				------------------------------ RESPUESTA A LA APP ------------------------------------
				SELECT @p_1 = 
				(
					SELECT @@ROWCOUNT AS ROWS_AFFECTED,
					CAST(1 AS BIT) AS SUCCESS,
					'Estados de unidades de medidas actualizadas con exito' AS ERROR_MESSAGE_SP,
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
				'Error, al intentar actualizar los estados de medidas seleccionados' AS ERROR_MESSAGE_SP,
				@ERROR_NUMBER_SP_Unidad_Medidas AS ERROR_NUMBER_SP,
				@ID_ERROR_Unidad_Medidas AS ID,
				@ROW_ERROR_Unidad_Medidas AS ROW
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
			@ERROR_NUMBER_SP_Unidad_Medidas AS ERROR_NUMBER_SP,
			@ID_ERROR_Unidad_Medidas AS ID,
			@ROW_ERROR_Unidad_Medidas AS ROW
			FOR JSON PATH, INCLUDE_NULL_VALUES
		)

		SELECT @p_2 = (SELECT CAST(@p_1 AS NVARCHAR(MAX)))

		SET @JSON_OUT = (SELECT @p_2)

		GOTO FINALIZAR
	END

FINALIZAR:
	RETURN

  --DECLARE @Resultado AS NVARCHAR(MAX)
  --EXECUTE SP_Habilitar_Unidades_Medidas @JSON_IN = '{\"unidades_Medidas_DTO\":[{\"Id\":1,\"Activo\":true},{\"Id\":2,\"Activo\":true},{\"Id\":3,\"Activo\":true},{\"Id\":4,\"Activo\":true},{\"Id\":5,\"Activo\":true}]}', @JSON_OUT = @Resultado OUTPUT
  --SELECT @Resultado

END