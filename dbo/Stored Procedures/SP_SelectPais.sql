

CREATE PROCEDURE [dbo].[SP_SelectPais] (			 @SEARCH					NVARCHAR(MAX)  =	NULL
												, @PAGE						INT			   =	NULL
												, @SIZE						INT			   =	NULL
												, @ORDEN                    NVARCHAR(50)   =    NULL
										  )
AS
BEGIN

	

    ---
	SET @PAGE = ISNULL(@PAGE, 1)
	SET @SIZE = ISNULL(@SIZE, 10)
	SELECT @ORDEN = (CASE WHEN @ORDEN = '' THEN 'Id asc' WHEN @ORDEN is null THEN 'Id asc' ELSE @ORDEN END);
	SELECT @SEARCH = (CASE WHEN @SEARCH is null THEN '' ELSE @SEARCH END);
	DECLARE @sql NVARCHAR(max);
	---
	SET @sql= '
	DECLARE @SEARCH NVARCHAR(MAX) = ''' + @SEARCH + ''';
    WITH DATA_INDEXED AS (SELECT  *
								 , ROW_NUMBER() OVER(ORDER BY '+ @ORDEN + ') AS [INDEX]
						FROM [tblPais]	
						WHERE
						Activo = (CASE 
                                  WHEN @SEARCH  = ''Activo'' THEN 1
                                  WHEN @SEARCH = ''Inactivo'' THEN 0 END)
						OR Id LIKE '+CONCAT('''%',ISNULL(@SEARCH, ''),'%''')+'						
						OR Nombre LIKE '+CONCAT('''%',ISNULL(@SEARCH, ''),'%''')+'
						OR Codigo LIKE '+CONCAT('''%',ISNULL(@SEARCH, ''),'%''')+')
						SELECT * INTO #tmpTblDataResult FROM DATA_INDEXED WHERE [INDEX] 
						BETWEEN '+ CONVERT(VARCHAR(12), (@PAGE) ) + ' AND ' + CONVERT(VARCHAR(12), ((@PAGE)+(@SIZE-1)))+ '
										---
	DECLARE @JSON_RESULT NVARCHAR(MAX) = (SELECT * FROM #tmpTblDataResult FOR JSON PATH)
	---
	DROP TABLE #tmpTblDataResult
	---
	SELECT @JSON_RESULT AS PAISES_JSONRESULT'

	SELECT COUNT(*)
    FROM [tblPais] 
	wHERE
	Activo = (CASE 
            WHEN @SEARCH = 'Activo' THEN 1
            WHEN @SEARCH = 'Inactivo' THEN 0 END)
	OR Id LIKE CONCAT('%',ISNULL(@SEARCH, Id),'%')	
	OR Nombre LIKE CONCAT('%',ISNULL(@SEARCH, Nombre),'%')
	OR Codigo LIKE CONCAT('%',ISNULL(@SEARCH, Codigo),'%');	


	EXECUTE (@sql);
END