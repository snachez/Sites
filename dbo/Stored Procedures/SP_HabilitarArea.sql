

CREATE   PROCEDURE SP_HabilitarArea(@ID INT, @ACTIVO BIT)
AS
BEGIN
	---
	BEGIN TRY
		---
		UPDATE tblArea SET Activo = @ACTIVO, FechaModificacion = CURRENT_TIMESTAMP WHERE Id = @ID
		---
		DECLARE @ROW NVARCHAR(MAX) = (SELECT     A.Id							AS [Id]
												 , A.Nombre						AS [Nombre]
												 --, A.Fk_Id_Departamento			AS [Fk_Id_Departamento]
												 , A.Codigo						AS [Codigo]
												 , A.Activo						AS [Activo]
												 , A.FechaCreacion				AS [FechaCreacion]
												 , A.FechaModificacion			AS [FechaModificacion]

												 , D.Id							AS [Departamento.Id]
												 , D.Nombre						AS [Departamento.Nombre]
												 , D.Activo						AS [Departamento.Activo]
												 , D.FechaCreacion				AS [Departamento.FechaCreacion]
												 , D.FechaModificacion			AS [Departamento.FechaModificacion]

										FROM tblArea A
										INNER JOIN tblDepartamento D
										ON A.Fk_Id_Departamento = D.Id WHERE A.Id = @ID FOR JSON PATH)
		---
		SELECT	  @@ROWCOUNT												AS ROWS_AFFECTED
				, CAST(1 AS BIT)											AS SUCCESS
				, ''														AS ERROR_MESSAGE_SP
				, NULL														AS ERROR_NUMBER_SP
				, CONVERT(INT, ISNULL(SCOPE_IDENTITY(), -1))				AS ID
				, @ROW														AS ROW
		---
	END TRY    
	BEGIN CATCH
		--
		DECLARE @ERROR_MESSAGE NVARCHAR(MAX) = ERROR_MESSAGE()
		---
		DECLARE @CONSTRAINT_NAME NVARCHAR(MAX) = ''
		---
		IF @ERROR_MESSAGE LIKE '%t2_C4_Reactivacion_Valida%' BEGIN 
			---
			SET @CONSTRAINT_NAME = 't2_C4_Reactivacion_Valida'
			DECLARE @DEPARTAMENTO NVARCHAR(MAX) = ''
			DECLARE @AREA NVARCHAR(MAX) = ''
			(SELECT @DEPARTAMENTO = D.Nombre, @AREA = A.Nombre FROM tblArea A INNER JOIN tblDepartamento D ON A.Fk_Id_Departamento = D.Id WHERE A.Id = @ID)
			SET @ERROR_MESSAGE = 'El departamento "' + @DEPARTAMENTO + '" se encuentra inactivo en base de datos. Por tanto no se podrá habilitar el área "' + @AREA + '"'
			---
		END
		---
		SELECT	  CAST(0 AS BIT)											AS SUCCESS
				, @ERROR_MESSAGE											AS ERROR_MESSAGE_SP
				, @CONSTRAINT_NAME											AS CONSTRAINT_TRIGGER_NAME
				, ERROR_NUMBER()											AS ERROR_NUMBER_SP
				, 0															AS ROWS_AFFECTED
				, -1														AS ID
				, NULL														AS ROW

		--   
	END CATCH
	---
END
---