

CREATE PROCEDURE [dbo].[SP_SelectCedis] (	     @SEARCH					NVARCHAR(MAX)  =	NULL
												, @PAGE						INT			   =	NULL
												, @SIZE						INT			   =	NULL
												, @ORDEN                    NVARCHAR(50)   =    NULL
										  )
AS
BEGIN
    ------ VALIDACION DE DATA
	SET @PAGE = ISNULL(@PAGE, 1)
	SET @SIZE = ISNULL(@SIZE, 10)
	SET @SEARCH = ISNULL(@SEARCH, '')
	SELECT @ORDEN = (CASE WHEN @ORDEN = '' THEN 'Id asc' WHEN @ORDEN is null THEN 'Id asc' ELSE @ORDEN END);

	--DECLARACION DE VARIABLES 
	DECLARE @sql NVARCHAR(max);

	--------------------------------- DATOS Y CANTIDAD DE DATA DE LA TABLA  ------------------------------------
    SET @sql= '
    DECLARE @SEARCH NVARCHAR(MAX) = ''' + @SEARCH + ''';
	DECLARE @CONCAT NVARCHAR(MAX) = '+CONCAT('''%',ISNULL(@SEARCH, ''),'%''')+';

	--------------------------------- CANTIDAD DE DATA DE LA TABLA  ------------------------------------
    SELECT COUNT(*)
    FROM [tblCedis] C
	INNER JOIN [tblPais]   P
	ON P.Id = C.Fk_Id_Pais
	WHERE 
	C.Activo = (CASE 
            WHEN @SEARCH = ''Activo'' THEN 1
            WHEN @SEARCH = ''Inactivo'' THEN 0 END)
	OR C.Id_Cedis LIKE @CONCAT	
	OR C.Nombre LIKE @CONCAT
	OR C.Codigo_Cedis LIKE @CONCAT	
	OR P.Nombre LIKE @CONCAT
	OR P.Codigo LIKE @CONCAT;

    --------------------------------- DATOS DE LA TABLA  ------------------------------------
    WITH DATA_INDEXED AS (SELECT  C.[Id_Cedis]
	                             ,C.[Activo]  
                                 ,C.[Nombre]
								 ,C.[Codigo_Cedis]
								 ,P.[Nombre] AS Nombre_Pais
                                 ,P.[Codigo] AS Codigo_Pais
								 , ROW_NUMBER() OVER(ORDER BY '+ @ORDEN + ') AS [INDEX]
						FROM [tblCedis] C
	                    INNER JOIN [tblPais] P
	                    ON P.[Id] = C.[Fk_Id_Pais]					
						WHERE 
						C.Activo = (CASE 
									WHEN @SEARCH = ''Activo'' THEN 1
									WHEN @SEARCH = ''Inactivo'' THEN 0 END)
						OR C.Id_Cedis LIKE @CONCAT	
						OR C.Nombre LIKE @CONCAT
						OR C.Codigo_Cedis LIKE @CONCAT	
						OR P.Nombre LIKE @CONCAT
						OR P.Codigo LIKE @CONCAT)
						SELECT * INTO #tmpTblDataResult FROM DATA_INDEXED WHERE [INDEX] 
						BETWEEN '+ CONVERT(VARCHAR(12), (@PAGE) ) + ' AND ' + CONVERT(VARCHAR(12), ((@PAGE)+(@SIZE-1)))+ '
										---
	DECLARE @JSON_RESULT NVARCHAR(MAX) = (SELECT * FROM #tmpTblDataResult FOR JSON PATH)
	---
	DROP TABLE #tmpTblDataResult
	---
	SELECT @JSON_RESULT AS DATA_JSONRESULT;'

	EXECUTE (@sql);
END