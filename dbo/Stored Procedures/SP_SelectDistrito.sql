﻿
CREATE PROCEDURE [dbo].[SP_SelectDistrito](@IdCanton INT = NULL, @Nombre varchar(50) = NULL)
AS
BEGIN
	---
	;WITH DATA_INDEXED AS (SELECT [Id]
								 ,[Nombre]
								 ,[fk_Id_Canton]
							     ,[Activo]
								 ,[FechaCreacion]
								 ,[FechaModificacion]
						   FROM [tblDistrito] 
						   WHERE [fk_Id_Canton] = ISNULL(@IdCanton, [fk_Id_Canton]) AND
						   [Nombre] = ISNULL(@Nombre, [Nombre]))
	SELECT * INTO #tmpTblDataResult FROM DATA_INDEXED
	---
	DECLARE @JSON_RESULT NVARCHAR(MAX) = (SELECT * FROM #tmpTblDataResult FOR JSON PATH)
	---
	DROP TABLE #tmpTblDataResult
	---
	SELECT @JSON_RESULT AS JSON_RESULT_SELECT
	---
END