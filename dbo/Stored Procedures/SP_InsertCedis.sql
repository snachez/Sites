CREATE PROCEDURE [dbo].[SP_InsertCedis](
	@JSON_IN VARCHAR(MAX) = NULL,
	@JSON_OUT  VARCHAR(MAX) OUTPUT 
)
AS
BEGIN

	SET @JSON_IN = REPLACE( @JSON_IN,'\','')

	--DECLARACION DE TABLA PARA INSERTAR LOS REGISTROS
	DECLARE @p_Tbl_Temp_Cedis TABLE   
     (  
	  ID INT IDENTITY(1,1)
	 ,Nombre NVARCHAR(50)	 
	 ,Fk_Id_Pais INT
	 ,Activo BIT
    )  

	--INSERTA CADA UNO DE LOS ITEMS EN LA TABLA (SETEANDO LOS VALORES DEL JSON)
	INSERT INTO @p_Tbl_Temp_Cedis 
	SELECT 
		  Nombre
		 ,Fk_Id_Pais
		 ,Activo
	FROM OPENJSON (@JSON_IN)
	WITH (cedis_DTO NVARCHAR(MAX) AS JSON)
	CROSS APPLY OPENJSON (cedis_DTO) 
	WITH 
	(
	  Nombre NVARCHAR(50)
	  ,Fk_Id_Pais INT
	 ,Activo BIT
	) 

  --DECLARACION DE VARIABLES PARA RECORRER LA TABLA
  DECLARE @p_Nombre_Cedis_Cursor NVARCHAR(50)
  DECLARE @p_Fk_Id_Pais_Cursor INT
  DECLARE @p_Activo_Cursor BIT 
  DECLARE @p_Aux_Activo BIT	

 
  DECLARE @p_1 NVARCHAR(MAX)
  DECLARE @p_2 NVARCHAR(MAX)
  DECLARE @ROW NVARCHAR(MAX)

  DECLARE @NewCedisCodigo_Cedis VARCHAR(25);
  DECLARE @PreFix VARCHAR(10) = 'CEDI-';
  DECLARE @Id INT;

  IF(@JSON_IN IS NOT NULL OR @JSON_IN != '')
  BEGIN
	 BEGIN TRY		
		 BEGIN TRANSACTION ACTUALIZAR
				
				------------------------------ RECORRIDO Y SETEO DE DATA DE LA TABLA  ------------------------------------
				
					DECLARE @i INT = 1
					DECLARE @Contador INT = (SELECT COUNT(1) FROM @p_Tbl_Temp_Cedis)

					IF @Contador > 0 WHILE (@i <= (SELECT MAX(ID) FROM @p_Tbl_Temp_Cedis))
					BEGIN			
 
					 SELECT @Id = ISNULL(MAX(Id_Cedis),0) + 1 FROM tblCedis
					 SELECT @NewCedisCodigo_Cedis = @PreFix + RIGHT('0000' + CAST(@Id AS VARCHAR(4)), 4)

						--OBTIENE UN ITEM
						SELECT 								
						 @p_Nombre_Cedis_Cursor = Nombre 	
						,@p_Fk_Id_Pais_Cursor = Fk_Id_Pais
						,@p_Activo_Cursor = Activo								
						FROM @p_Tbl_Temp_Cedis
						WHERE ID = @i
								
								INSERT INTO tblCedis(Nombre, Fk_Id_Pais, Activo, Codigo_Cedis) VALUES(@p_Nombre_Cedis_Cursor,@p_Fk_Id_Pais_Cursor, @p_Activo_Cursor, @NewCedisCodigo_Cedis)
								SET @ROW = (SELECT * FROM tblCedis WHERE Nombre = @p_Nombre_Cedis_Cursor FOR JSON PATH)												  
																		
						 SET @i = @i + 1
					END --FIN DEL CICLO

					------------------------------ RESPUESTA A LA APP  ------------------------------------
						SELECT @p_1 = 
						(
							  SELECT	  @@ROWCOUNT									AS ROWS_AFFECTED
							, CAST(1 AS BIT)											AS SUCCESS
							, 'Se registro con exito el cedis'	                AS ERROR_MESSAGE_SP
							, NULL														AS ERROR_NUMBER_SP
							, CONVERT(INT, ISNULL(SCOPE_IDENTITY(), -1))				AS ID
							, @ROW														AS ROW 
							FOR JSON PATH, INCLUDE_NULL_VALUES
						)

						SELECT @p_2 = 
						( 
							SELECT CAST(@p_1 AS NVARCHAR(MAX)) 
						)

						
						SET @JSON_OUT = ( SELECT @p_2  )	
				   --------------------------------------------------------------------------------------------

				  --FINAL
				 IF @@TRANCOUNT > 0
				 BEGIN
				   COMMIT TRANSACTION ACTUALIZAR
				 END		

	  END TRY    
	  BEGIN CATCH

				   ------------------------------ RESPUESTA A LA APP  ------------------------------------
				   --
		           DECLARE @ERROR_MESSAGE NVARCHAR(MAX) = ERROR_MESSAGE()
		           --
		           IF ERROR_MESSAGE() LIKE '%Unique_Nombre_Cedis%' BEGIN 
			       ---
			       SET @ERROR_MESSAGE = 'Ya existe un cedis con los datos que indica'
				   ---
		           END
				   --
		           IF ERROR_MESSAGE() LIKE '%tblCedis_C4_Asignacion_Pais_Activo%' BEGIN 
			       ---
			       SET @ERROR_MESSAGE = 'No puede ingresar datos inactivos al cedis'
				   ---
		           END
				   --
		           IF ERROR_MESSAGE() LIKE '%Unique_Codigo_Cedis%' BEGIN 
			       ---
			       SET @ERROR_MESSAGE = 'Ya existe un cedis con los datos que indica'
				   ---
		           END
				   --
				   ELSE BEGIN
				   ---
			       SET @ERROR_MESSAGE =  'Error, al intentar registrar el cedis'
			       ---
		           END
		           --
						SELECT @p_1 = 
						(
							  SELECT	  @@ROWCOUNT												AS ROWS_AFFECTED
							, CAST(0 AS BIT)														AS SUCCESS
							, @ERROR_MESSAGE                                                     	AS ERROR_MESSAGE_SP
							, NULL																	AS ERROR_NUMBER_SP
							, CONVERT(INT, ISNULL(SCOPE_IDENTITY(), -1))							AS ID
							, NULL																	AS ROW 
							FOR JSON PATH, INCLUDE_NULL_VALUES
						)

						SELECT @p_2 = 
						( 
							SELECT CAST(@p_1 AS NVARCHAR(MAX)) 
						)
						
						SET @JSON_OUT = ( SELECT @p_2  )	
				   --------------------------------------------------------------------------------------------


			   IF @@TRANCOUNT > 0
			   BEGIN
				  ROLLBACK TRANSACTION ACTUALIZAR								
			   END	

	  END CATCH
	  GOTO FINALIZAR 
	---
  END
  ELSE
  BEGIN 
	 
						SELECT @p_1 = 
						(
							  SELECT	  @@ROWCOUNT												AS ROWS_AFFECTED
							, CAST(0 AS BIT)														AS SUCCESS
							, 'Error, se resivieron datos nulos'										AS ERROR_MESSAGE_SP
							, NULL																	AS ERROR_NUMBER_SP
							, CONVERT(INT, ISNULL(SCOPE_IDENTITY(), -1))							AS ID
							, NULL																	AS ROW 
							FOR JSON PATH, INCLUDE_NULL_VALUES
						)

						SELECT @p_2 = 
						( 
							SELECT CAST(@p_1 AS NVARCHAR(MAX)) 
						)
						
						SET @JSON_OUT = ( SELECT @p_2  )	
	  GOTO FINALIZAR 	 				
  END

  FINALIZAR:RETURN


  --DECLARE @Resultado AS NVARCHAR(MAX)
  --EXECUTE SP_InsertCedis @JSON_IN = '{\"cedis_DTO\":[{\"Nombre\":"Conta",\"Fk_Id_Pais\":1,\"Activo\":true}]}', @JSON_OUT = @Resultado OUTPUT
  --SELECT @Resultado

END
---