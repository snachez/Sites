
CREATE PROCEDURE [dbo].[SP_SelectTipoEfectivo](       @ID				NVARCHAR(MAX)  =	NULL 
													, @NOMBRE			NVARCHAR(MAX)  =	NULL											
													, @ACTIVO			NVARCHAR(MAX)  =	NULL 
													, @PAGE				INT			   =	1
													, @SIZE				INT			   =	10
													, @ORDEN            NVARCHAR(50)   =    NULL)
AS
BEGIN
    ---
	SET @PAGE = ISNULL(@PAGE, 1)
	SET @SIZE = ISNULL(@SIZE, 10)
	SELECT @ORDEN = (CASE WHEN @ORDEN = '' THEN 'Id asc' WHEN @ORDEN is null THEN 'Id asc' ELSE @ORDEN END);
	DECLARE @sql NVARCHAR(max);
	---
	SET @sql= '
    WITH DATA_INDEXED AS (SELECT  [Id]
                                 ,[Nombre]
								 ,[Activo]
								 ,[FechaCreacion]
								 ,[FechaModificacion]
								 , ROW_NUMBER() OVER(ORDER BY '+ @ORDEN + ') AS [INDEX]
						FROM [tblTipoEfectivo]					
						WHERE 
						Activo = '+ISNULL(@ACTIVO, 'Activo')+'
						AND Id = '+ISNULL(@ID, 'Id')+'						
						AND Nombre LIKE '+CONCAT('''%',ISNULL(@NOMBRE, ''),'%''')+')
						SELECT * INTO #tmpTblDataResult FROM DATA_INDEXED WHERE [INDEX] 
						BETWEEN '+ CONVERT(VARCHAR(12), (@PAGE) ) + ' AND ' + CONVERT(VARCHAR(12), ((@PAGE)+(@SIZE-1)))+ '
										---
	DECLARE @JSON_RESULT NVARCHAR(MAX) = (SELECT * FROM #tmpTblDataResult FOR JSON PATH)
	---
	DROP TABLE #tmpTblDataResult
	---
	SELECT @JSON_RESULT AS DENOMINACIONES_JSONRESULT'



		SELECT COUNT(*)
    FROM tblTipoEfectivo D
	WHERE 
	D.Activo = ISNULL(@ACTIVO, D.Activo)
	AND D.Id = ISNULL(@ID, D.Id)	
	AND D.Nombre LIKE CONCAT('%',ISNULL(@NOMBRE, D.Nombre),'%')

	EXECUTE (@sql);
END