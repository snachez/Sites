
CREATE PROCEDURE [dbo].[SP_SelectCanton](@IdProvincia INT = NULL, @Nombre varchar(50) = NULL)
AS
BEGIN
	---
	;WITH DATA_INDEXED AS (SELECT [Id]
								 ,[Nombre]
								 ,[fk_Id_Provincia]
								 ,[Activo]
								 ,[FechaCreacion]
								 ,[FechaModificacion]
						   FROM [tblCanton] 
						   WHERE [fk_Id_Provincia] = ISNULL(@IdProvincia, [fk_Id_Provincia]) AND
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