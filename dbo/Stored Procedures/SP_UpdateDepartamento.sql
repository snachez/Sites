CREATE PROCEDURE [dbo].[SP_UpdateDepartamento](
	@JSON_IN VARCHAR(MAX) = NULL,
	@JSON_OUT VARCHAR(MAX) OUTPUT
)
AS
BEGIN
	SET @JSON_IN = REPLACE(@JSON_IN, '\', '')

	--DECLARACION DE TABLA PARA INSERTAR LOS REGISTROS
	DECLARE @p_Tbl_Temp_Departamento TABLE   
	(
		ID INT IDENTITY(1,1),
		Id_Departamento INT,
		Nombre_Departamento NVARCHAR(50),
		Activo BIT
	)

	--INSERTA CADA UNO DE LOS ITEMS EN LA TABLA (SETEANDO LOS VALORES DEL JSON)
	INSERT INTO @p_Tbl_Temp_Departamento	 
		SELECT 
			Id,
			Nombre,
			Activo
		FROM OPENJSON(@JSON_IN)
		WITH (departamento_DTO NVARCHAR(MAX) AS JSON)
		CROSS APPLY OPENJSON(departamento_DTO) 
		WITH 
		(
			Id INT,
			Nombre NVARCHAR(50),
			Activo BIT
		)

	--DECLARACION DE VARIABLES PARA RECORRER LA TABLA
	DECLARE @p_Id_Departamento_Cursor INT
	DECLARE @p_Nombre_Departamento_Cursor NVARCHAR(50)
	DECLARE @p_Activo_Cursor BIT
	DECLARE @p_Aux_Activo BIT

	DECLARE @p_1 NVARCHAR(MAX)
	DECLARE @p_2 NVARCHAR(MAX)
	DECLARE @ROW NVARCHAR(MAX)
	DECLARE @ROW_Asociados NVARCHAR(MAX) = 0
	DECLARE @ERROR_NUMBER_SP NVARCHAR(MAX) = NULL
	DECLARE @ID NVARCHAR(MAX) = CONVERT(INT, ISNULL(SCOPE_IDENTITY(), -1))
	DECLARE @ROW_ERROR NVARCHAR(MAX) = NULL

	IF (@JSON_IN IS NOT NULL OR @JSON_IN != '')
	BEGIN
		BEGIN TRY
			BEGIN TRANSACTION ACTUALIZAR

			------------------------------ RECORRIDO Y SETEO DE DATA DE LA TABLA ------------------------------------
			DECLARE @i INT = 1
			DECLARE @Contador INT = (SELECT COUNT(1) FROM @p_Tbl_Temp_Departamento)

			IF @Contador > 0
			BEGIN
				WHILE (@i <= (SELECT MAX(ID) FROM @p_Tbl_Temp_Departamento))
				BEGIN
					--OBTIENE UN ITEM
					SELECT 		
						@p_Id_Departamento_Cursor = Id_Departamento,
						@p_Nombre_Departamento_Cursor = Nombre_Departamento,
						@p_Activo_Cursor = Activo
					FROM @p_Tbl_Temp_Departamento 
					WHERE ID = @i

					SET @p_Aux_Activo = NULL
					SELECT @p_Aux_Activo = (SELECT A.Activo FROM tblDepartamento D INNER JOIN tblArea A ON A.Fk_Id_Departamento = D.Id WHERE D.Id = @p_Id_Departamento_Cursor AND A.Activo = 1)

					IF (@p_Aux_Activo IS NULL)
					BEGIN
						UPDATE tblDepartamento SET Nombre = @p_Nombre_Departamento_Cursor, Activo = @p_Activo_Cursor WHERE Id = @p_Id_Departamento_Cursor
						SET @ROW = (SELECT * FROM tblDepartamento WHERE Id = @p_Id_Departamento_Cursor FOR JSON PATH)												  
					END
					ELSE
					BEGIN
						SET @ROW_Asociados = @ROW_Asociados + 1;
					END

					SET @i = @i + 1
				END --FIN DEL CICLO

				------------------------------ RESPUESTA A LA APP ------------------------------------
				SELECT @p_1 = 
				(
					SELECT @@ROWCOUNT AS ROWS_AFFECTED,
					(
						CASE
							WHEN @ROW_Asociados > 0 THEN CAST(0 AS BIT)
							WHEN @ROW_Asociados = 0 THEN CAST(1 AS BIT)
						END
					) AS SUCCESS,
					(
						CASE 
							WHEN @ROW_Asociados = 0 THEN 'Se modifico con exito el departamento'
							WHEN @ROW_Asociados >= 1 THEN 'No puede desactivar un departamento con áreas, roles o usuarios asociados en estado activo'
						END
					) AS ERROR_MESSAGE_SP,
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
			DECLARE @ERROR_MESSAGE NVARCHAR(MAX) = ERROR_MESSAGE()

			IF @ERROR_MESSAGE LIKE '%t2_C1_Unique_Nombre_Departamento%'
			BEGIN 
				SET @ERROR_MESSAGE = 'Ya existe un departamento con los datos que indica'
			END
			ELSE
			BEGIN
				SET @ERROR_MESSAGE = 'Error, al intentar modificar el departamento'
			END

			SELECT @p_1 = 
			(
				SELECT @@ROWCOUNT AS ROWS_AFFECTED,
				CAST(0 AS BIT) AS SUCCESS,
				@ERROR_MESSAGE AS ERROR_MESSAGE_SP,
				@ERROR_NUMBER_SP AS ERROR_NUMBER_SP,
				@ID AS ID,
				@ROW_ERROR AS ROW
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
			'Error, se recibieron datos nulos' AS ERROR_MESSAGE_SP,
			@ERROR_NUMBER_SP AS ERROR_NUMBER_SP,
			@ID AS ID,
			@ROW_ERROR AS ROW
			FOR JSON PATH, INCLUDE_NULL_VALUES
		)

		SELECT @p_2 = (SELECT CAST(@p_1 AS NVARCHAR(MAX)))

		SET @JSON_OUT = (SELECT @p_2)

		GOTO FINALIZAR
	END

FINALIZAR:
	RETURN
END
