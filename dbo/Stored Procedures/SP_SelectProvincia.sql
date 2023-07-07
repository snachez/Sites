
CREATE PROCEDURE [dbo].[SP_SelectProvincia](@Nombre varchar(50) = NULL)
AS
BEGIN
	---
	;WITH DATA_INDEXED AS (SELECT [Id]
                                 ,[Nombre]
                                 ,[Activo]
                                 ,[FechaCreacion]
                                 ,[FechaModificacion]
                           FROM [tblProvincia]
						   WHERE [Nombre] = ISNULL(@Nombre, [Nombre]))
	SELECT * INTO #tmpTblDataResult FROM DATA_INDEXED
	---
	DECLARE @JSON_RESULT NVARCHAR(MAX) = (SELECT * FROM #tmpTblDataResult FOR JSON PATH)
	---
	DROP TABLE #tmpTblDataResult
	---
	SELECT @JSON_RESULT AS JSON_RESULT_SELECT
	---
END