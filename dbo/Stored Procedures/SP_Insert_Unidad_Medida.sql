


CREATE   PROCEDURE [dbo].[SP_Insert_Unidad_Medida](
	@JSON_IN VARCHAR(MAX),
	@JSON_OUT  VARCHAR(MAX) OUTPUT 
)
AS
BEGIN

  IF(@JSON_IN IS NOT NULL AND @JSON_IN != '')
  BEGIN

	  SET @JSON_IN = REPLACE( @JSON_IN,'\','')

	  --DECLARACION DE VARIABLES PARA ACCEER A LAS PROPIEDADES Y VALORES QUE VIENEN DENTRO DEL JSON
	  DECLARE @p_Nombre_Insert_Unidad_Medida VARCHAR(MAX) 
	  DECLARE @p_Simbolo_Insert_Unidad_Medida VARCHAR(MAX)
	  DECLARE @p_Cantidad_Insert_Unidad_Medida INT
	  DECLARE @p_Activo_Insert_Unidad_Medida BIT

	  --AUN NO ESTAN EN USO
	  DECLARE @p_user_id INT 
	  DECLARE @Action VARCHAR(1)

	  --SETEANDO LOS VALORES DEL JSON (TABLA PADRE UNIDADES DE MEDIDAS)
	  SELECT @p_Nombre_Insert_Unidad_Medida = Nombre FROM OPENJSON( @JSON_IN) WITH ( Nombre VARCHAR(MAX) )
	  SELECT @p_Simbolo_Insert_Unidad_Medida = Simbolo FROM OPENJSON( @JSON_IN) WITH ( Simbolo VARCHAR(MAX) )
	  SELECT @p_Cantidad_Insert_Unidad_Medida = Cantidad_Unidades FROM OPENJSON( @JSON_IN) WITH ( Cantidad_Unidades INT )
	  SELECT @p_Activo_Insert_Unidad_Medida = Activo FROM OPENJSON( @JSON_IN) WITH ( Activo BIT )

	  --------------------------- DECLARACION DE TABLA PARA INSERTAR LOS REGISTROS DE DIVISAS (TABLA HIJO) ----------------------------------------
	  DECLARE @p_Tbl_Temp_Divisa TABLE   
	  (  
		  ID INT IDENTITY(1,1)
		 ,Id_Divisa INT
		 ,Nombre VARCHAR(MAX)	 
	  )  

		--INSERTA CADA UNO DE LOS ITEMS DE LA DIVISA
		INSERT INTO @p_Tbl_Temp_Divisa	 
		SELECT 
			   Id
			  ,Nombre		  
		FROM OPENJSON (@JSON_IN)
		WITH (Divisa NVARCHAR(MAX) AS JSON)
		CROSS APPLY OPENJSON (Divisa) 
		WITH 
		(
		   Id INT
		  ,Nombre VARCHAR(MAX)
		) 

	  --------------------------- DECLARACION DE TABLA PARA INSERTAR LOS REGISTROS DE PRESENTACIONES HABILITADAS (TABLA HIJO) ----------------------------------------
	  DECLARE @p_Tbl_Temp_Presentaciones_Habilitadas TABLE   
	  (  
		  ID INT IDENTITY(1,1)
		 ,Id_Efectivo INT
		 ,Nombre VARCHAR(MAX)	 
	  )  

	  --INSERTA CADA UNO DE LOS ITEMS DE LA DIVISA
		INSERT INTO @p_Tbl_Temp_Presentaciones_Habilitadas	 
		SELECT 
			   Id
			  ,Nombre		  
		FROM OPENJSON (@JSON_IN)
		WITH (Presentaciones_Habilitadas NVARCHAR(MAX) AS JSON)
		CROSS APPLY OPENJSON (Presentaciones_Habilitadas) 
		WITH 
		(
		   Id INT
		  ,Nombre VARCHAR(MAX)
		) 

	  --DECLARACION DE VARIABLES PARA RECORRER LA TABLA TEMPORAL DIVISAS
	  DECLARE @p_Id_Divisa_Iterador INT
	  DECLARE @p_Nombre_Divisa_Iterador VARCHAR(MAX)
	  --DECLARACION DE VARIABLES PARA RECORRER LA TABLA TEMPORAL PRESENTACIONES HABILITADAS
	  DECLARE @p_Id_Efectivo_Iterador INT
	  DECLARE @p_Nombre_Efectivo_Iterador VARCHAR(MAX)


	  --VARIABLES PARA DAR RESPUESTA
	  DECLARE @Id_Unidad_Medida_Insertada INT
	  DECLARE @Id_Unidad_Medida_Por_Divisa_Insertada INT
	  DECLARE @p_Resultados_Nombres_Concatenados VARCHAR(MAX)

	  DECLARE @Resp_1 NVARCHAR(MAX)
	  DECLARE @Resp_2 NVARCHAR(MAX)
	  DECLARE @ROW NVARCHAR(MAX)

	  BEGIN TRY	
	 
		--ACA SE PONEN LAS VALIDACIONES 
		 IF EXISTS(SELECT 1 FROM tblUnidadMedida WHERE Nombre = @p_Nombre_Insert_Unidad_Medida)        
		 BEGIN   
				------------------------------ RESPUESTA A LA APP  ------------------------------------
				SELECT @Resp_1 = 
						(
							  SELECT	  @@ROWCOUNT												      AS ROWS_AFFECTED
							, CAST(0 AS BIT)														      AS SUCCESS
							, CONCAT(ERROR_MESSAGE() ,'Error, El nombre de la unidad de medida ya existe')AS ERROR_MESSAGE_SP
							, ERROR_NUMBER()													          AS ERROR_NUMBER_SP
							, NULL																	      AS ID
							, NULL																	      AS ROW 
							FOR JSON PATH, INCLUDE_NULL_VALUES
						)

				SELECT @Resp_2 = 
						( 
							SELECT CAST(@Resp_1 AS NVARCHAR(MAX)) 
						)
						
				SET @JSON_OUT = ( SELECT @Resp_2  )	
				---------------------------------------------------------------------------------------

			GOTO FINALIZAR         
		 END  

		 IF EXISTS(SELECT 1 FROM tblUnidadMedida WHERE Simbolo = @p_Simbolo_Insert_Unidad_Medida)        
		 BEGIN   
				------------------------------ RESPUESTA A LA APP  ------------------------------------
				SELECT @Resp_1 = 
						(
							  SELECT	  @@ROWCOUNT												       AS ROWS_AFFECTED
							, CAST(0 AS BIT)														       AS SUCCESS
							, CONCAT(ERROR_MESSAGE() ,'Error, El simbolo de la unidad de medida ya existe')AS ERROR_MESSAGE_SP
							, ERROR_NUMBER()													           AS ERROR_NUMBER_SP
							, NULL																	       AS ID
							, NULL																	       AS ROW 
							FOR JSON PATH, INCLUDE_NULL_VALUES
						)

				SELECT @Resp_2 = 
						( 
							SELECT CAST(@Resp_1 AS NVARCHAR(MAX)) 
						)
						
				SET @JSON_OUT = ( SELECT @Resp_2  )	
				---------------------------------------------------------------------------------------

			GOTO FINALIZAR         
		 END  


		 BEGIN TRANSACTION INSERTAR
								   
					--INSERTA EN LA TABLA UNIDADES DE MEDIDAS
					INSERT INTO dbo.[tblUnidadMedida] (			[Nombre],					[Simbolo],			[Cantidad_Unidades],			[Activo],				[Fecha_Creacion] )
											    VALUES(	@p_Nombre_Insert_Unidad_Medida,	@p_Simbolo_Insert_Unidad_Medida,	@p_Cantidad_Insert_Unidad_Medida,		@p_Activo_Insert_Unidad_Medida,		GETDATE()    )

					SELECT @Id_Unidad_Medida_Insertada = CONVERT(INT, ISNULL(SCOPE_IDENTITY(), -1))

					IF(@Id_Unidad_Medida_Insertada IS NOT NULL)
					BEGIN   
				   		
						------------------------------ INICIO DEL RECORRIDO Y SETEO DE DATA DE LA TABLA TEMPORAL DIVISA  ------------------------------------

						DECLARE @i INT = 1
						DECLARE @Contador INT = (SELECT COUNT(1) FROM  @p_Tbl_Temp_Divisa)

						IF @Contador > 0 WHILE (@i <= (SELECT MAX(ID) FROM @p_Tbl_Temp_Divisa))
						BEGIN

							--OBTIENE UN ITEM
							SELECT 								
							 @p_Id_Divisa_Iterador = Id_Divisa
							,@p_Nombre_Divisa_Iterador = Nombre									
							FROM @p_Tbl_Temp_Divisa 
							WHERE ID = @i
								
							--INSERTA EN LA TABLA tblUnidadMedida_x_Divisa
							INSERT INTO dbo.[tblUnidadMedida_x_Divisa] (    [Fk_Id_Unidad_Medida],          [Fk_Id_Divisa],     [Activo],    [Fecha_Creacion]   )
																VALUES (  @Id_Unidad_Medida_Insertada,    @p_Id_Divisa_Iterador,    1,          GETDATE()       )
			    				
							UPDATE tblUnidadMedida SET Divisa = @p_Nombre_Divisa_Iterador WHERE Id = @Id_Unidad_Medida_Insertada

							SELECT @Id_Unidad_Medida_Por_Divisa_Insertada = CONVERT(INT, ISNULL(SCOPE_IDENTITY(), -1)) 
							
							SET @i = @i + 1
						END --FIN DEL CICLO
														
					END

					------------------------------ FIN DEL RECORRIDO Y SETEO DE DATA DE LA TABLA TEMPORAL DIVISA  ------------------------------------

					IF(@Id_Unidad_Medida_Por_Divisa_Insertada IS NOT NULL)
					BEGIN   

						------------------------------ INICIO DEL RECORRIDO Y SETEO DE DATA DE LA TABLA TEMPORAL PRESENTACIONES DEL EFECTIVO  ------------------------------------

						DECLARE @iter INT = 1
						DECLARE @Conta INT = (SELECT COUNT(1) FROM  @p_Tbl_Temp_Presentaciones_Habilitadas	 )

						IF @Conta > 0 WHILE (@iter <= (SELECT MAX(ID) FROM @p_Tbl_Temp_Presentaciones_Habilitadas	 ))
						BEGIN

							--OBTIENE UN ITEM
							SELECT 								
							 @p_Id_Efectivo_Iterador = Id_Efectivo
							,@p_Nombre_Efectivo_Iterador = Nombre									
							FROM @p_Tbl_Temp_Presentaciones_Habilitadas 
							WHERE ID = @iter
						
							--INSERTA EN LA TABLA tblUnidadMedida_x_Divisa
							INSERT INTO dbo.[tblUnidadMedida_x_TipoEfectivo] (    [Fk_Id_Unidad_Medida],          [Fk_Id_Tipo_Efectivo],     [Activo],    [Fecha_Creacion]   )
																      VALUES (  @Id_Unidad_Medida_Insertada,      @p_Id_Efectivo_Iterador,       1,          GETDATE()       )
			    											
							SET @iter = @iter + 1
						END --FIN DEL CICLO

						--SE CONSOLIDA LOS NOMBRES DE LAS PRESENTACIONES DEL EFECTIVO SELECCIONADOS
						SELECT @p_Resultados_Nombres_Concatenados =  COALESCE(@p_Resultados_Nombres_Concatenados + ', ', '') +  CONVERT(VARCHAR(MAX), Nombre)
						FROM tblTipoEfectivo
						WHERE Id IN ( SELECT Id_Efectivo from @p_Tbl_Temp_Presentaciones_Habilitadas     )
						ORDER BY Nombre

						UPDATE tblUnidadMedida SET Presentaciones_Habilitadas = @p_Resultados_Nombres_Concatenados WHERE Id = @Id_Unidad_Medida_Insertada

					END

											
					SELECT @ROW = (SELECT * FROM tblUnidadMedida WHERE Id = @Id_Unidad_Medida_Insertada FOR JSON PATH, INCLUDE_NULL_VALUES)
					
					------------------------------ RESPUESTA A LA APP  ------------------------------------
						SELECT @Resp_1 = 
						(
							  SELECT	  @@ROWCOUNT									AS ROWS_AFFECTED
							, CAST(1 AS BIT)											AS SUCCESS
							, 'Unidad de medida insertada con exito!'					AS ERROR_MESSAGE_SP
							, NULL														AS ERROR_NUMBER_SP
							, @Id_Unidad_Medida_Insertada								AS ID
							, @ROW														AS ROW 
							FOR JSON PATH, INCLUDE_NULL_VALUES
						)

						SELECT @Resp_2 = 
						( 
							SELECT CAST(@Resp_1 AS NVARCHAR(MAX)) 
						)
						
						SET @JSON_OUT = ( SELECT @Resp_2  )	
				    ---------------------------------------------------------------------------------------

				  --FINAL
				 IF @@TRANCOUNT > 0
				 BEGIN
				   COMMIT TRANSACTION INSERTAR
				 END		

	  END TRY    
	  BEGIN CATCH

					
				   ------------------------------ RESPUESTA A LA APP  ------------------------------------
						SELECT @Resp_1 = 
						(
							  SELECT	  @@ROWCOUNT												    AS ROWS_AFFECTED
							, CAST(0 AS BIT)														    AS SUCCESS
							, CONCAT(ERROR_MESSAGE() ,'Error, al intentar insertar la unidad de medida')AS ERROR_MESSAGE_SP
							, ERROR_NUMBER()													        AS ERROR_NUMBER_SP
							, NULL																	    AS ID
							, NULL																	    AS ROW 
							FOR JSON PATH, INCLUDE_NULL_VALUES
						)

						SELECT @Resp_2 = 
						( 
							SELECT CAST(@Resp_1 AS NVARCHAR(MAX)) 
						)
						
						SET @JSON_OUT = ( SELECT @Resp_2  )	
				   -----------------------------------------------------------------------------------------


			   IF @@TRANCOUNT > 0
			   BEGIN
				  ROLLBACK TRANSACTION INSERTAR								
			   END	

	  END CATCH
	  GOTO FINALIZAR 
	---
  END
  ELSE
  BEGIN 
				 ------------------------------ RESPUESTA A LA APP  ------------------------------------
						SELECT @Resp_1 = 
						(
							  SELECT	  @@ROWCOUNT												    AS ROWS_AFFECTED
							, CAST(0 AS BIT)														    AS SUCCESS
							, CONCAT(ERROR_MESSAGE() ,'Error, se resivio el JSON Vacio')                AS ERROR_MESSAGE_SP
							, ERROR_NUMBER()													        AS ERROR_NUMBER_SP
							, NULL																	    AS ID
							, NULL																	    AS ROW 
							FOR JSON PATH, INCLUDE_NULL_VALUES
						)

						SELECT @Resp_2 = 
						( 
							SELECT CAST(@Resp_1 AS NVARCHAR(MAX)) 
						)
						
						SET @JSON_OUT = ( SELECT @Resp_2  )	
				----------------------------------------------------------------------------------------
	  
	  GOTO FINALIZAR 	 				
  END

  FINALIZAR:RETURN

  --DECLARE @Resultado AS NVARCHAR(MAX)
  --EXECUTE SP_Insert_Unidad_Medida @JSON_IN = '{\"Id\":null,\"Nombre\":\"prueba 1\",\"Simbolo\":\"p1\",\"Cantidad_Unidades\":10,\"Activo\":true,\"Fecha_Creacion\":null,\"Fecha_Modificacion\":null,\"Divisa\":[{\"Id\":31,\"Nombre\":\"prueba 13\",\"Nomenclatura\":\"aa\",\"Simbolo\":null,\"Descripcion\":\"prueba 13\",\"Activo\":true,\"FechaCreacion\":null,\"FechaModificacion\":null}],\"Presentaciones_Habilitadas\":[{\"Id\":1,\"Nombre\":\"Billetes\",\"Activo\":null,\"FechaCreacion\":null,\"FechaModificacion\":null},{\"Id\":2,\"Nombre\":\"Moneda\",\"Activo\":null,\"FechaCreacion\":null,\"FechaModificacion\":null},{\"Id\":3,\"Nombre\":\"Cheque\",\"Activo\":null,\"FechaCreacion\":null,\"FechaModificacion\":null}]}', @JSON_OUT = @Resultado OUTPUT
  --SELECT @Resultado

END
---