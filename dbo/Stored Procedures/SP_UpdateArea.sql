
---

CREATE   PROCEDURE SP_UpdateArea (@ID INT, @NOMBRE NVARCHAR(MAX) = NULL, @FK_ID_DEPARTAMENTO INT = NULL, @ACTIVO BIT = NULL)
AS
BEGIN
	---
	BEGIN TRY
		---
		UPDATE tblArea SET Nombre = ISNULL(@NOMBRE, Nombre), Fk_Id_Departamento = ISNULL(@FK_ID_DEPARTAMENTO, Fk_Id_Departamento), Activo = ISNULL(@ACTIVO, Activo) WHERE Id = @ID
		---
		DECLARE @ROW NVARCHAR(MAX) = (SELECT       A.Id							AS [Id]
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
		DECLARE @DEPARTAMENTO NVARCHAR(MAX)
		---
		IF @ERROR_MESSAGE LIKE '%t2_C1_Unique_Nombre_Area%' BEGIN 
			---
			SET @CONSTRAINT_NAME = 't2_C1_Unique_Nombre_Area'
			SET @DEPARTAMENTO = (SELECT Nombre FROM tblDepartamento WHERE Id = @FK_ID_DEPARTAMENTO)
			SET @NOMBRE = ISNULL(@NOMBRE, (SELECT Nombre FROM tblArea WHERE Id = @ID))
			SET @ERROR_MESSAGE = 'El nombre de área "' + @NOMBRE + '" ya existe asociada al departamento "' + @DEPARTAMENTO + '". Favor seleccionar otro nombre o cambie el departamento asociado'
			---
		END ELSE IF @ERROR_MESSAGE LIKE '%t2_C2_Foreign_Key_Departamento%' BEGIN 
			---
			SET @CONSTRAINT_NAME = 't2_C2_Foreign_Key_Departamento'
			SET @ERROR_MESSAGE = 'El departamento seleccionado no existe actualmente en base de datos'
			---
		END ELSE IF @ERROR_MESSAGE LIKE '%t2_C3_Asignacion_Departamento_Activo%' BEGIN 
			---
			SET @CONSTRAINT_NAME = 't2_C3_Asignacion_Departamento_Activo'
			SET @DEPARTAMENTO = (SELECT Nombre FROM tblDepartamento WHERE Id = @FK_ID_DEPARTAMENTO)
			SET @ERROR_MESSAGE = 'El departamento "' + @DEPARTAMENTO + '" se encuentra inactivo en base de datos. Favor seleccionar otro departamento que sea valido'
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