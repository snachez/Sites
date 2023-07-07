
CREATE PROCEDURE [dbo].[SP_InsertComunicado] (		  
											    @Id NVARCHAR(36)
										      , @FkTipoComunicado NVARCHAR(36)
											  , @FKColaborador int
											  , @Mensaje NVARCHAR(500)
											  , @Activo int
											  , @FechaCreacion NVARCHAR(36)
										     )
AS
BEGIN
	---
	BEGIN TRY
		---
		DECLARE @EXISTE_COMUNICADO BIT = 0;
		DECLARE @MAXIMO_COMUNICADO INT = 0;
		DECLARE @NEW_ID uniqueidentifier;
		DECLARE @SP_ERROR_MESSAGE_DB NVARCHAR(MAX) = '';
		DECLARE @SP_Error BIT = 0;
		DECLARE @HabilitarBanner NVARCHAR(36) = 'cdbaadcc-a24f-47eb-af27-8e000591c682';
		SET DATEFORMAT 'YMD'
		---
		SELECT @EXISTE_COMUNICADO = 1 FROM [tblComunicado] WHERE Mensaje = @Mensaje AND Activo = 1
		SELECT @MAXIMO_COMUNICADO = COUNT(*) FROM [tblComunicado] WHERE Activo = 1
		---
		IF @EXISTE_COMUNICADO = 1 BEGIN
			---
			SET @SP_Error = 1;
			SET @SP_ERROR_MESSAGE_DB = 'El comunicado que intenta ingresar existe actualmente';
			---
		END 
		ELSE IF @MAXIMO_COMUNICADO = 7 BEGIN
		    ---
			SET @SP_Error = 1;
			SET @SP_ERROR_MESSAGE_DB = 'Ya alcanzaste el máximo de comunicados';
			---
		END ELSE BEGIN
			---
			INSERT INTO [tblComunicado]
			(Id, FkTipoComunicado, FKColaborador, Mensaje, FKHabilitarBanner, Activo, FechaCreacion) 
			VALUES(@Id, @FkTipoComunicado, @FKColaborador ,@Mensaje, @HabilitarBanner, @Activo, @FechaCreacion);
            SET @NEW_ID = @Id;
			SET @SP_ERROR_MESSAGE_DB = 'Se creó la notificación';		
			---
		END
		---
		SELECT	  @SP_Error													AS SP_Error
		        , @SP_ERROR_MESSAGE_DB										AS SP_ERROR_MESSAGE_DB 
				, @@ROWCOUNT												AS ROWS_AFFECTED
				, @NEW_ID													AS pk_Id
		---
	END TRY    
	BEGIN CATCH
		--
		SELECT	  CAST(1 AS BIT)											AS SP_Error
				, 'Error: error en el insert SP_InsertComunicado'			AS SP_ERROR_MESSAGE_DB
				, 0															AS ROWS_AFFECTED
				, @Id														AS pk_Id

		--   
	END CATCH
	---
END