
CREATE PROCEDURE [dbo].[SP_HabilitarCedis](@JSON_IN VARCHAR(MAX) = NULL,
	                                             @JSON_OUT  VARCHAR(MAX) OUTPUT )
AS
BEGIN
	
	SET @JSON_IN = REPLACE( @JSON_IN,'\','')

	--DECLARACION DE TABLA PARA INSERTAR LOS REGISTROS
	DECLARE @p_Tbl_Temp_Cedis TABLE   
     (  
	  ID INT IDENTITY(1,1)
	 ,Id_Cedis INT
	 ,Activo BIT
    )  

	--INSERTA CADA UNO DE LOS ITEMS EN LA TABLA (SETEANDO LOS VALORES DEL JSON)
	INSERT INTO @p_Tbl_Temp_Cedis	 
	SELECT DISTINCT -- SE EMPLEA UN DISTINCT PARA EVITAR DUPLICADOS...
		  Id_Cedis	
		 ,Activo
	FROM OPENJSON (@JSON_IN)
	WITH (cedis_DTO NVARCHAR(MAX) AS JSON)
	CROSS APPLY OPENJSON (cedis_DTO) 
	WITH 
	(
	  Id_Cedis INT	 
	 ,Activo BIT
	) 

  --DECLARACION DE VARIABLES PARA RECORRER LA TABLA
  DECLARE @p_Id_Cedis_Cursor INT	
  DECLARE @p_Activo_Cursor BIT 
  DECLARE @p_Aux_Activo BIT	
 
  DECLARE @p_1 NVARCHAR(MAX)
  DECLARE @p_2 NVARCHAR(MAX)
  DECLARE @ROW NVARCHAR(MAX)
  DECLARE @ERROR_NUMBER_SP_HabilitarCedis NVARCHAR(MAX) = NULL
  DECLARE @ID_ERROR_HabilitarCedis NVARCHAR(MAX) = CONVERT(INT, ISNULL(SCOPE_IDENTITY(), -1))
  DECLARE @ROW_ERROR_HabilitarCedis NVARCHAR(MAX) = NULL

  IF(@JSON_IN IS NOT NULL OR @JSON_IN != '')
  BEGIN
	 BEGIN TRY		
		 BEGIN TRANSACTION ACTUALIZAR
				
				------------------------------ RECORRIDO Y SETEO DE DATA DE LA TABLA  ------------------------------------
				
					DECLARE @i INT = 1
					DECLARE @Contador INT = (SELECT COUNT(1) FROM @p_Tbl_Temp_Cedis)

					IF @Contador > 0 WHILE (@i <= (SELECT MAX(ID) FROM @p_Tbl_Temp_Cedis))
					BEGIN

						--OBTIENE UN ITEM
						SELECT 								
						 @p_Id_Cedis_Cursor = Id_Cedis 
						,@p_Activo_Cursor = Activo								
						FROM @p_Tbl_Temp_Cedis 
						WHERE ID = @i
								
						SET @p_Aux_Activo = NULL	
						SELECT @p_Aux_Activo = (SELECT Activo FROM tblCedis WHERE Id_Cedis = @p_Id_Cedis_Cursor)	
						--SELECT @Aux_1_Existe 
						
						   IF(@p_Aux_Activo = 1)
						   BEGIN   

								UPDATE tblCedis SET Activo = 0, FechaModificacion = CURRENT_TIMESTAMP WHERE Id_Cedis = @p_Id_Cedis_Cursor
								SET @ROW = (SELECT * FROM tblCedis WHERE Id_Cedis = @p_Id_Cedis_Cursor FOR JSON PATH);
								
						   END
						   ELSE 
						   BEGIN					      									
																		
								UPDATE tblCedis SET Activo = 1, FechaModificacion = CURRENT_TIMESTAMP WHERE Id_Cedis = @p_Id_Cedis_Cursor
								SET @ROW = (SELECT * FROM tblCedis WHERE Id_Cedis = @p_Id_Cedis_Cursor FOR JSON PATH)		

						   END
			    															
						 SET @i = @i + 1
					END --FIN DEL CICLO

					------------------------------ RESPUESTA A LA APP  ------------------------------------
						SELECT @p_1 = 
						(
							  SELECT	  @@ROWCOUNT									                          AS ROWS_AFFECTED
							,  CAST(1 AS BIT)										                              AS SUCCESS
							, 'Estados de Cedis actualizados con exito'                                           AS ERROR_MESSAGE_SP
							, NULL														                          AS ERROR_NUMBER_SP
							, CONVERT(INT, ISNULL(SCOPE_IDENTITY(), -1))				                          AS ID
							, @ROW																				  AS ROW 
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
				   IF ERROR_MESSAGE() LIKE '%tblCedis_C4_Reactivacion_Valida%' BEGIN 
			       ---
			       SET @ERROR_MESSAGE = 'Uno o más de los registros que intenta cambiar de estado poseen valores inactivos o erróneos'
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
							, @ERROR_MESSAGE	                                                    AS ERROR_MESSAGE_SP
							, @ERROR_NUMBER_SP_HabilitarCedis										AS ERROR_NUMBER_SP
							, @ID_ERROR_HabilitarCedis							                    AS ID
							, @ROW_ERROR_HabilitarCedis												AS ROW 
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
							, 'Error, se resivieron datos null'										AS ERROR_MESSAGE_SP
							, @ERROR_NUMBER_SP_HabilitarCedis										AS ERROR_NUMBER_SP
							, @ID_ERROR_HabilitarCedis							                    AS ID
							, @ROW_ERROR_HabilitarCedis												AS ROW 
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
END
---

 --DECLARE @Resultado AS NVARCHAR(MAX)
  --EXECUTE SP_HabilitarCedis @JSON_IN = '{\"cedis_DTO\":[{\"Id\":1,\"Activo\":true}]}', @JSON_OUT = @Resultado OUTPUT
  --SELECT @Resultado