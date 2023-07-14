


CREATE   PROCEDURE [dbo].[SP_Select_Unidad_Medida](
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
	  DECLARE @p_Activo_Unidad_Medida BIT

	  --AUN NO ESTAN EN USO
	  DECLARE @p_user_id INT 
	  DECLARE @Action VARCHAR(1)

	  --SETEANDO LOS VALORES DEL JSON (TABLA PADRE UNIDADES DE MEDIDAS)
	  SELECT @p_Id_Unidad_Medida = Id FROM OPENJSON( @JSON_IN) WITH ( Id INT )
	  SELECT @p_Activo_Unidad_Medida = Activo FROM OPENJSON( @JSON_IN) WITH ( Activo BIT )

	  DECLARE @resp_JSON_Tbl_Divisa NVARCHAR(MAX)
	  DECLARE @Resp_JSON_Tbl_Tipo_Efectivo NVARCHAR(MAX)
	  DECLARE @resp_JSON_Consolidada NVARCHAR(MAX)		
	  DECLARE @ROW NVARCHAR(MAX)
	  DECLARE @ERROR_NUMBER_SP_Select_Unidad NVARCHAR(MAX) = ERROR_NUMBER()
      DECLARE @ID_ERROR_Select_Unidad NVARCHAR(MAX) = NULL
      DECLARE @ROW_ERROR_Select_Unidad NVARCHAR(MAX) = NULL

	  BEGIN TRY	
	 		
			--ACA SE PONEN LAS VALIDACIONES 
		 IF NOT EXISTS(SELECT 1 FROM tblUnidadMedida WHERE Id = @p_Id_Unidad_Medida)        
		 BEGIN   
				------------------------------ RESPUESTA A LA APP  ------------------------------------
				SELECT @resp_JSON_Consolidada = 
						(
							  SELECT	  @@ROWCOUNT												      AS ROWS_AFFECTED
							, CAST(0 AS BIT)														      AS SUCCESS
							, CONCAT(ERROR_MESSAGE() ,'Error, El nombre de la unidad no existe !')        AS ERROR_MESSAGE_SP
							, ERROR_NUMBER()													          AS ERROR_NUMBER_SP
							, NULL																	      AS ID
							, NULL																	      AS ROW 
							FOR JSON PATH, INCLUDE_NULL_VALUES
						)			
						
				SET @JSON_OUT = ( SELECT @resp_JSON_Consolidada  )	
				---------------------------------------------------------------------------------------

			GOTO FINALIZAR         
		 END  

		 BEGIN TRANSACTION OBTENER
								   

				SELECT @resp_JSON_Tbl_Divisa = 
				(
					SELECT
								
					tblDivisa.Id,
					tblDivisa.Nombre,
					tblDivisa.Nomenclatura,
					tblDivisa.Simbolo,		
					tblDivisa.Descripcion,
					tblDivisa.Activo,
					tblDivisa.FechaCreacion,
					tblDivisa.FechaModificacion

					FROM tblUnidadMedida_x_Divisa
					INNER JOIN tblDivisa on tblUnidadMedida_x_Divisa.Fk_Id_Divisa = tblDivisa.Id	 
					WHERE tblUnidadMedida_x_Divisa.Fk_Id_Unidad_Medida = @p_Id_Unidad_Medida

					FOR JSON AUTO
				)
				
				SELECT @Resp_JSON_Tbl_Tipo_Efectivo = 
				(
					SELECT
					
					tblTipoEfectivo.Id,
					tblTipoEfectivo.Nombre,								
					tblTipoEfectivo.Activo,
					tblTipoEfectivo.FechaCreacion,
					tblTipoEfectivo.FechaModificacion

					FROM tblUnidadMedida_x_TipoEfectivo
					INNER JOIN tblTipoEfectivo on tblUnidadMedida_x_TipoEfectivo.Fk_Id_Tipo_Efectivo = tblTipoEfectivo.Id	 
					WHERE tblUnidadMedida_x_TipoEfectivo.Fk_Id_Unidad_Medida = @p_Id_Unidad_Medida

					FOR JSON PATH, INCLUDE_NULL_VALUES
				)
			
				DECLARE @p_Tbl_Temp_Unidad_Medida TABLE   
				(  
				   --ID INT IDENTITY(1,1)
					 Id INT
					,Nombre VARCHAR(MAX)
					,Simbolo VARCHAR(MAX)
					,Cantidad_Unidades INT
					,Activo BIT
					,Fecha_Creacion DATETIME
					,Fecha_Modificacion DATETIME
					,Divisa NVARCHAR(MAX)
					,Presentaciones_Habilitadas NVARCHAR(MAX)
				) 

				INSERT INTO @p_Tbl_Temp_Unidad_Medida	 
					SELECT
						tblUnidadMedida.Id,
						tblUnidadMedida.Nombre,		
						tblUnidadMedida.Simbolo,							
						tblUnidadMedida.Cantidad_Unidades,
						tblUnidadMedida.Activo,
						tblUnidadMedida.Fecha_Creacion,
						tblUnidadMedida.Fecha_Modificacion,
						(SELECT @resp_JSON_Tbl_Divisa),--tblUnidadMedida.Divisa
						(SELECT @Resp_JSON_Tbl_Tipo_Efectivo)			--tblUnidadMedida.Presentaciones_Habilitadas										
					FROM tblUnidadMedida						
					WHERE tblUnidadMedida.Id = @p_Id_Unidad_Medida


				SELECT @ROW = (SELECT * FROM @p_Tbl_Temp_Unidad_Medida FOR JSON PATH, INCLUDE_NULL_VALUES)
					
				------------------------------ RESPUESTA A LA APP  ------------------------------------
					SELECT @resp_JSON_Consolidada = 
						(
							  SELECT	  @@ROWCOUNT									AS ROWS_AFFECTED
							, CAST(1 AS BIT)											AS SUCCESS
							, 'Unidad de medida obtenida con exito!'					AS ERROR_MESSAGE_SP
							, NULL														AS ERROR_NUMBER_SP
							, NULL														AS ID
							, @ROW														AS ROW 
							FOR JSON PATH, INCLUDE_NULL_VALUES
						)
					
					SET @resp_JSON_Consolidada = REPLACE( @resp_JSON_Consolidada,'\\\','\') --COMO EL JSON SE SERIALIZA EN 3 OCACIONES A CAUSA DE LA CLAUSULA: FOR JSON PATH, HAY QUE ELIMINARLES LOS \\\ A LAS TABLAS HIJOS
					SET @resp_JSON_Consolidada = REPLACE( @resp_JSON_Consolidada,':\"[{\',':[{\') --HAY QUE ELIMINAR LOS CARACTERES  \" CUANDO SE HABRE LAS LLAVES EN EL INICIO DE LAS CADENAS DE ARRAYS DE LAS TABLAS HIJOS
					SET @resp_JSON_Consolidada = REPLACE( @resp_JSON_Consolidada,'}]\"','}]') --Y TAMBIEN HAY QUE ELIMINAR LOS CARACTERES  \"  CUANDO SE CIERRA LAS LLAVES EN LAS CADENAS DE ARRAYS DE LAS TABLAS HIJOS
					
					SET @JSON_OUT = ( SELECT @resp_JSON_Consolidada  )	
				--------------------------------------------------------------------------------------------

				  --FINAL
				 IF @@TRANCOUNT > 0
				 BEGIN
				   COMMIT TRANSACTION OBTENER
				 END		

	   END TRY    
	   BEGIN CATCH

					
				   ------------------------------ RESPUESTA A LA APP  ------------------------------------
						SELECT @resp_JSON_Consolidada = 
						(
							  SELECT	  @@ROWCOUNT												    AS ROWS_AFFECTED
							, CAST(0 AS BIT)														    AS SUCCESS
							, CONCAT(ERROR_MESSAGE() ,'Error, al intentar obtener la unidad de medida') AS ERROR_MESSAGE_SP
							, @ERROR_NUMBER_SP_Select_Unidad											AS ERROR_NUMBER_SP
							, @ID_ERROR_Select_Unidad													AS ID
							, @ROW_ERROR_Select_Unidad													AS ROW 
							FOR JSON PATH, INCLUDE_NULL_VALUES
						)						
						
						SET @JSON_OUT = ( SELECT @resp_JSON_Consolidada  )	
				   ---------------------------------------------------------------------------------------


			   IF @@TRANCOUNT > 0
			   BEGIN
				  ROLLBACK TRANSACTION OBTENER								
			   END	

	   END CATCH
	   GOTO FINALIZAR 
	---
   END
   ELSE
   BEGIN 
				------------------------------ RESPUESTA A LA APP  ------------------------------------
						SELECT @resp_JSON_Consolidada = 
						(
							  SELECT	  @@ROWCOUNT												    AS ROWS_AFFECTED
							, CAST(0 AS BIT)														    AS SUCCESS
							, CONCAT(ERROR_MESSAGE() ,'Error, se resivio el JSON Vacio')                AS ERROR_MESSAGE_SP
							, @ERROR_NUMBER_SP_Select_Unidad											AS ERROR_NUMBER_SP
							, @ID_ERROR_Select_Unidad													AS ID
							, @ROW_ERROR_Select_Unidad													AS ROW 
							FOR JSON PATH, INCLUDE_NULL_VALUES
						)
						
						SET @JSON_OUT = ( SELECT @resp_JSON_Consolidada  )	

				---------------------------------------------------------------------------------------
	  
	  GOTO FINALIZAR 	 				
   END

   FINALIZAR:RETURN

  --DECLARE @Resultado AS NVARCHAR(MAX)
  --EXECUTE SP_Select_Unidad_Medida @JSON_IN = '{"Id":1,"Activo":true}', @JSON_OUT = @Resultado OUTPUT
  --SELECT @Resultado


END