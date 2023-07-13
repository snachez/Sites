
CREATE    PROCEDURE [dbo].[SP_Select_Tipo_Efectivo_X_Divisa] (	 
	@JSON_IN VARCHAR(MAX),
	@JSON_OUT  VARCHAR(MAX) OUTPUT 													
)
AS
BEGIN
	
 IF(@JSON_IN IS NOT NULL AND @JSON_IN != '')
  BEGIN

    SET @JSON_IN = REPLACE( @JSON_IN,'\','')

	 --DECLARACION DE VARIABLES PARA ACCEER A LAS PROPIEDADES Y VALORES QUE VIENEN DENTRO DEL JSON
    DECLARE @p_Id_Divisa INT
    DECLARE @p_Activo BIT

	--AUN NO ESTAN EN USO
	DECLARE @p_user_id INT 
	DECLARE @Action VARCHAR(1)

    --SETEANDO LOS VALORES DEL JSON
	SELECT @p_Id_Divisa = FK_ID_DIVISA FROM OPENJSON( @JSON_IN) WITH ( FK_ID_DIVISA INT )
	SELECT @p_Activo = ACTIVO FROM OPENJSON( @JSON_IN) WITH ( ACTIVO BIT )

	DECLARE @resp_JSON_Consolidada NVARCHAR(MAX)		
	DECLARE @ROW NVARCHAR(MAX)

	BEGIN TRY	

		--ACA SE PONEN LAS VALIDACIONES 
		 IF NOT EXISTS(SELECT 1 FROM tblDivisa_x_TipoEfectivo WHERE tblDivisa_x_TipoEfectivo.FkIdDivisa = @p_Id_Divisa )        
		 BEGIN   
				------------------------------ RESPUESTA A LA APP  ------------------------------------
				SELECT @resp_JSON_Consolidada = 
						(
							  SELECT	  @@ROWCOUNT																																AS ROWS_AFFECTED
							, CAST(0 AS BIT)																																		AS SUCCESS
							, CONCAT(ERROR_MESSAGE() ,'Error, El nombre de la divisa no existe, no se pudo obtener las presentaciones de efectivo, vinculadas a esta divisa !')     AS ERROR_MESSAGE_SP
							, ERROR_NUMBER()																																		AS ERROR_NUMBER_SP
							, NULL																																					AS ID
							, NULL																																					AS ROW 
							FOR JSON PATH, INCLUDE_NULL_VALUES
						)			
						
				SET @JSON_OUT = ( SELECT @resp_JSON_Consolidada  )	
				---------------------------------------------------------------------------------------

			GOTO FINALIZAR         
		 END  

	BEGIN TRANSACTION OBTENER
			   

				DECLARE @tbl_Temp_Divisa_X_Tipo_Efectivo TABLE   
				(  
				   --ID INT IDENTITY(1,1)
					 Id INT
					,Nombre VARCHAR(MAX)										
					,Activo BIT
					,FechaCreacion DATETIME
					,FechaModificacion DATETIME					
				) 

				INSERT INTO @tbl_Temp_Divisa_X_Tipo_Efectivo	 
					SELECT		
					 TE.Id                 
					,TE.Nombre								
					,TE.Activo				
					,TE.FechaCreacion		
					,TE.FechaModificacion	
			
					FROM tblDivisa_x_TipoEfectivo DXT
					INNER JOIN tblTipoEfectivo TE on DXT.FkIdTipoEfectivo = TE.Id	 
					WHERE DXT.FkIdDivisa = ISNULL( @p_Id_Divisa, DxT.FkIdDivisa)
					AND DXT.Activo = ISNULL( @p_Activo, DxT.Activo)

				SELECT @ROW = (SELECT * FROM @tbl_Temp_Divisa_X_Tipo_Efectivo FOR JSON PATH, INCLUDE_NULL_VALUES)

				------------------------------ RESPUESTA A LA APP  ------------------------------------
					SELECT @resp_JSON_Consolidada = 
						(
							  SELECT	  @@ROWCOUNT									AS ROWS_AFFECTED
							, CAST(1 AS BIT)											AS SUCCESS
							, 'Presentaciones del efectivo obtenidas con exito!'		AS ERROR_MESSAGE_SP
							, NULL														AS ERROR_NUMBER_SP
							, NULL														AS ID
							, @ROW														AS ROW 
							FOR JSON PATH, INCLUDE_NULL_VALUES
						)
									
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
							  SELECT	  @@ROWCOUNT																AS ROWS_AFFECTED
							, CAST(0 AS BIT)																		AS SUCCESS
							, CONCAT(ERROR_MESSAGE() ,'Error, al intentar obtener las presentaciones del efectivo') AS ERROR_MESSAGE_SP
							, ERROR_NUMBER()																		AS ERROR_NUMBER_SP
							, NULL																					AS ID
							, NULL																					AS ROW 
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
							, ERROR_NUMBER()													        AS ERROR_NUMBER_SP
							, NULL																	    AS ID
							, NULL																	    AS ROW 
							FOR JSON PATH, INCLUDE_NULL_VALUES
						)
						
						SET @JSON_OUT = ( SELECT @resp_JSON_Consolidada  )	
				---------------------------------------------------------------------------------------
	  
	  GOTO FINALIZAR 	 				
   END

   FINALIZAR:RETURN

  --DECLARE @Resultado AS NVARCHAR(MAX)
  --EXECUTE SP_Select_Tipo_Efectivo_X_Divisa @JSON_IN = '{"FK_ID_DIVISA":1,"ACTIVO":true}', @JSON_OUT = @Resultado OUTPUT
  --SELECT @Resultado

END