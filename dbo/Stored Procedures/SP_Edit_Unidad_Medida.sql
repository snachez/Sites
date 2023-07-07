


CREATE   PROCEDURE [dbo].[SP_Edit_Unidad_Medida](
	@JSON_IN VARCHAR(MAX),
	@JSON_OUT  VARCHAR(MAX) OUTPUT 
)
AS
BEGIN

  IF(@JSON_IN IS NOT NULL AND @JSON_IN != '')
  BEGIN

	  SET @JSON_IN = REPLACE( @JSON_IN,'\','')

	  --DECLARACION DE VARIABLES PARA ACCEER A LAS PROPIEDADES Y VALORES QUE VIENEN DENTRO DEL JSON
	  DECLARE @p_Id_Unidad_Medida INT
	  DECLARE @p_Nombre_Unidad_Medida VARCHAR(MAX) 
	  DECLARE @p_Simbolo_Unidad_Medida VARCHAR(MAX)
	  DECLARE @p_Cantidad_Unidades INT
	  DECLARE @p_Activo_Unidad_Medida BIT

	  --AUN NO ESTAN EN USO
	  DECLARE @p_user_id INT 
	  DECLARE @Action VARCHAR(1)

	  --SETEANDO LOS VALORES DEL JSON (TABLA PADRE UNIDADES DE MEDIDAS)
	  SELECT @p_Id_Unidad_Medida = Id FROM OPENJSON( @JSON_IN) WITH ( Id INT )
	  SELECT @p_Nombre_Unidad_Medida = Nombre FROM OPENJSON( @JSON_IN) WITH ( Nombre VARCHAR(MAX) )
	  SELECT @p_Simbolo_Unidad_Medida = Simbolo FROM OPENJSON( @JSON_IN) WITH ( Simbolo VARCHAR(MAX) )
	  SELECT @p_Cantidad_Unidades = Cantidad_Unidades FROM OPENJSON( @JSON_IN) WITH ( Cantidad_Unidades INT )
	  SELECT @p_Activo_Unidad_Medida = Activo FROM OPENJSON( @JSON_IN) WITH ( Activo BIT )

	  --------------------------- DECLARACION DE TABLA PARA EDITAR LOS REGISTROS DE DIVISAS (TABLA HIJO) ----------------------------------------
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

	  --------------------------- DECLARACION DE TABLA PARA EDITAR LOS REGISTROS DE PRESENTACIONES HABILITADAS (TABLA HIJO) ----------------------------------------
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
	  DECLARE @Id_Unidad_Medida_Por_Divisa_Editada INT
	  DECLARE @p_Resultados_Nombres_Concatenados VARCHAR(MAX)

	  DECLARE @p_1 NVARCHAR(MAX)
	  DECLARE @p_2 NVARCHAR(MAX)
	  DECLARE @ROW NVARCHAR(MAX)

	  --DECLARACION DE VARIABLES PARA APLICAR VALIDACIONES ANTES DE EDITAR
	  DECLARE @Nombre_Unidad_Medida_Original VARCHAR(MAX)
	  DECLARE @Simbolo_Unidad_Medida_Original VARCHAR(MAX)
	  DECLARE @CONTINUAR_TRANSACCION INT

	  BEGIN TRY		 
		-------------------------- ACA SE PONEN LAS VALIDACIONES ----------------------------------------------- 
		
		----------------------------------- 1 VALIDACION -------------------------------------------------------
		SET @Nombre_Unidad_Medida_Original = (SELECT Nombre FROM tblUnidadMedida WHERE Id = @p_Id_Unidad_Medida)
		
		IF(@Nombre_Unidad_Medida_Original = @p_Nombre_Unidad_Medida )
		BEGIN 
			--PRINT 'Nombre iguales, permitir seguir' 		
			SET @CONTINUAR_TRANSACCION = 1
		END
		ELSE
		BEGIN 
	
			 IF EXISTS(SELECT 1 FROM tblUnidadMedida WHERE Nombre = @p_Nombre_Unidad_Medida)        
			 BEGIN   				 
					------------------------------ RESPUESTA A LA APP  ------------------------------------
					--PRINT 'Nombre lo tiene otro registro , hacer roolback'
					SELECT @p_1 = 
								(
									  SELECT	  @@ROWCOUNT												      AS ROWS_AFFECTED
									, CAST(0 AS BIT)														      AS SUCCESS
									, CONCAT(ERROR_MESSAGE() ,'Error, El nombre de la unidad de medida ya existe')AS ERROR_MESSAGE_SP
									, ERROR_NUMBER()													          AS ERROR_NUMBER_SP
									, NULL																	      AS ID
									, NULL																	      AS ROW 
									FOR JSON PATH, INCLUDE_NULL_VALUES
								)

					SELECT @p_2 = 
								( 
									SELECT CAST(@p_1 AS NVARCHAR(MAX)) 
								)
					
					SET @JSON_OUT = ( SELECT @p_2  )	

					GOTO FINALIZAR  
					---------------------------------------------------------------------------------------
			 END 
			 BEGIN 
				--PRINT 'Nombre completamente nuevo, permitir seguir' 
				SET @CONTINUAR_TRANSACCION = 1
			 END

		END

		----------------------------------- 2 VALIDACION -------------------------------------------------------
		SET @Simbolo_Unidad_Medida_Original = (SELECT Simbolo FROM tblUnidadMedida WHERE Id = @p_Id_Unidad_Medida)
		
		IF(@Simbolo_Unidad_Medida_Original = @p_Simbolo_Unidad_Medida)
		BEGIN 
			--PRINT 'Simbolo iguales, permitir seguir' 		
			SET @CONTINUAR_TRANSACCION = 1
		END
		ELSE
		BEGIN 
	
			 IF EXISTS(SELECT 1 FROM tblUnidadMedida WHERE Simbolo = @p_Simbolo_Unidad_Medida)        
			 BEGIN   				 
			    ------------------------------ RESPUESTA A LA APP  ------------------------------------
					--PRINT 'Simbolo lo tiene otro registro , hacer rollback'
					SELECT @p_1 = 
								(
									  SELECT	  @@ROWCOUNT												       AS ROWS_AFFECTED
									, CAST(0 AS BIT)														       AS SUCCESS
									, CONCAT(ERROR_MESSAGE() ,'Error, El Simbolo de la unidad de medida ya existe')AS ERROR_MESSAGE_SP
									, ERROR_NUMBER()													           AS ERROR_NUMBER_SP
									, NULL																	       AS ID
									, NULL																	       AS ROW 
									FOR JSON PATH, INCLUDE_NULL_VALUES
								)

					SELECT @p_2 = 
								( 
									SELECT CAST(@p_1 AS NVARCHAR(MAX)) 
								)
					
					SET @JSON_OUT = ( SELECT @p_2  )	

					GOTO FINALIZAR  
				---------------------------------------------------------------------------------------
			 END 
			 BEGIN 
				--PRINT 'Simbolo completamente nuevo, permitir seguir' 
				SET @CONTINUAR_TRANSACCION = 1
			 END

		END

			BEGIN TRANSACTION EDITAR
						
				IF(@CONTINUAR_TRANSACCION = 1)
				BEGIN 

					-----EDITA EN LA TABLA UNIDADES DE MEDIDAS------
				
					UPDATE tblUnidadMedida SET Nombre = @p_Nombre_Unidad_Medida, Simbolo = @p_Simbolo_Unidad_Medida, Cantidad_Unidades = @p_Cantidad_Unidades, Activo = @p_Activo_Unidad_Medida, Fecha_Modificacion = GETDATE()
					WHERE tblUnidadMedida.Id = @p_Id_Unidad_Medida

					IF(@p_Id_Unidad_Medida IS NOT NULL)
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
							
							--EDITA EN LA TABLA tblUnidadMedida_x_Divisa
				   		
							UPDATE tblUnidadMedida_x_Divisa SET Fk_Id_Unidad_Medida = @p_Id_Unidad_Medida, Fk_Id_Divisa = @p_Id_Divisa_Iterador, Activo = 1, Fecha_Modificacion = GETDATE()
							WHERE tblUnidadMedida_x_Divisa.Fk_Id_Unidad_Medida = @p_Id_Unidad_Medida	

							UPDATE tblUnidadMedida SET Divisa = @p_Nombre_Divisa_Iterador WHERE tblUnidadMedida.Id = @p_Id_Unidad_Medida

							SELECT @Id_Unidad_Medida_Por_Divisa_Editada = (SELECT Id FROM tblUnidadMedida_x_Divisa WHERE tblUnidadMedida_x_Divisa.Fk_Id_Unidad_Medida = @p_Id_Unidad_Medida     )
						
							SET @i = @i + 1
						END --FIN DEL CICLO
													
					END

					------------------------------ FIN DEL RECORRIDO Y SETEO DE DATA DE LA TABLA TEMPORAL DIVISA  ------------------------------------

					IF(@Id_Unidad_Medida_Por_Divisa_Editada IS NOT NULL)
					BEGIN   

						------------------------------ INICIO DEL RECORRIDO Y SETEO DE DATA DE LA TABLA TEMPORAL PRESENTACIONES DEL EFECTIVO  ------------------------------------
						--ELIMINE LOS QUE YA ESTABAN 
						DELETE FROM tblUnidadMedida_x_TipoEfectivo WHERE Fk_Id_Unidad_Medida = @p_Id_Unidad_Medida						

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
																		  VALUES (     @p_Id_Unidad_Medida,            @p_Id_Efectivo_Iterador,       1,          GETDATE()       )			    												

								SET @iter = @iter + 1
							END --FIN DEL CICLO

						--SE CONSOLIDA LOS NOMBRES DE LAS PRESENTACIONES DEL EFECTIVO SELECCIONADOS
						SELECT @p_Resultados_Nombres_Concatenados =  COALESCE(@p_Resultados_Nombres_Concatenados + ', ', '') +  CONVERT(VARCHAR(MAX), Nombre)
						FROM tblTipoEfectivo
						WHERE Id IN ( SELECT Id_Efectivo from @p_Tbl_Temp_Presentaciones_Habilitadas     )
						ORDER BY Nombre

						UPDATE tblUnidadMedida SET Presentaciones_Habilitadas = @p_Resultados_Nombres_Concatenados WHERE Id = @p_Id_Unidad_Medida

					END

										
					SELECT @ROW = (SELECT * FROM tblUnidadMedida WHERE Id = @p_Id_Unidad_Medida FOR JSON PATH, INCLUDE_NULL_VALUES)
				
					------------------------------ RESPUESTA A LA APP  ------------------------------------
						SELECT @p_1 = 
							(
								  SELECT	  @@ROWCOUNT									AS ROWS_AFFECTED
								, CAST(1 AS BIT)											AS SUCCESS
								, 'Unidad de medida editada con exito!'					AS ERROR_MESSAGE_SP
								, NULL														AS ERROR_NUMBER_SP
								, @p_Id_Unidad_Medida							            AS ID
								, @ROW														AS ROW 
								FOR JSON PATH, INCLUDE_NULL_VALUES
							)

						SELECT @p_2 = 
							( 
								SELECT CAST(@p_1 AS NVARCHAR(MAX)) 
							)
					
						SET @JSON_OUT = ( SELECT @p_2  )	
					---------------------------------------------------------------------------------------

					 --FINAL
					IF @@TRANCOUNT > 0
					BEGIN
					  COMMIT TRANSACTION EDITAR
					END		

				END					

	  END TRY    
	  BEGIN CATCH
					
				   ------------------------------ RESPUESTA A LA APP  ------------------------------------
						SELECT @p_1 = 
						(
							  SELECT	  @@ROWCOUNT												    AS ROWS_AFFECTED
							, CAST(0 AS BIT)														    AS SUCCESS
							, CONCAT(ERROR_MESSAGE() ,'Error, al intentar editar la unidad de medida')  AS ERROR_MESSAGE_SP
							, ERROR_NUMBER()													        AS ERROR_NUMBER_SP
							, NULL																	    AS ID
							, NULL																	    AS ROW 
							FOR JSON PATH, INCLUDE_NULL_VALUES
						)

						SELECT @p_2 = 
						( 
							SELECT CAST(@p_1 AS NVARCHAR(MAX)) 
						)
						
						SET @JSON_OUT = ( SELECT @p_2  )	
				   -----------------------------------------------------------------------------------------

			   IF @@TRANCOUNT > 0
			   BEGIN
				  ROLLBACK TRANSACTION EDITAR								
			   END	

	  END CATCH
	  GOTO FINALIZAR 
	---
  END
  ELSE
  BEGIN 
				 ------------------------------ RESPUESTA A LA APP  ------------------------------------
						SELECT @p_1 = 
						(
							  SELECT	  @@ROWCOUNT												    AS ROWS_AFFECTED
							, CAST(0 AS BIT)														    AS SUCCESS
							, CONCAT(ERROR_MESSAGE() ,'Error, se resivio el JSON Vacio')                AS ERROR_MESSAGE_SP
							, ERROR_NUMBER()													        AS ERROR_NUMBER_SP
							, NULL																	    AS ID
							, NULL																	    AS ROW 
							FOR JSON PATH, INCLUDE_NULL_VALUES
						)

						SELECT @p_2 = 
						( 
							SELECT CAST(@p_1 AS NVARCHAR(MAX)) 
						)
						
						SET @JSON_OUT = ( SELECT @p_2  )	
				----------------------------------------------------------------------------------------
	  
	  GOTO FINALIZAR 	 				
  END

  FINALIZAR:RETURN

  --DECLARE @Resultado AS NVARCHAR(MAX)
  --EXECUTE SP_Edit_Unidad_Medida @JSON_IN = '{\"Id\":3,\"Nombre\":\"prueba 3\",\"Simbolo\":\"p3\",\"Cantidad_Unidades\":30,\"Activo\":true,\"Fecha_Creacion\":null,\"Fecha_Modificacion\":null,\"Divisa\":[{\"Id\":33,\"Nombre\":\"Prueba 15\",\"Nomenclatura\":\"q\",\"Simbolo\":null,\"Descripcion\":\"prueba 15\",\"Activo\":true,\"FechaCreacion\":null,\"FechaModificacion\":null}],\"Presentaciones_Habilitadas\":[{\"Id\":19,\"Nombre\":\"prueba 1\",\"Activo\":null,\"FechaCreacion\":null,\"FechaModificacion\":null},{\"Id\":20,\"Nombre\":\"prueba 2\",\"Activo\":null,\"FechaCreacion\":null,\"FechaModificacion\":null},{\"Id\":21,\"Nombre\":\"prueba 3\",\"Activo\":null,\"FechaCreacion\":null,\"FechaModificacion\":null}]}', @JSON_OUT = @Resultado OUTPUT
  --SELECT @Resultado

END
---