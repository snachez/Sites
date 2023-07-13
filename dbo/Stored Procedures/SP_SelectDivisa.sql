

CREATE PROCEDURE [dbo].[SP_SelectDivisa] (         @SEARCH					NVARCHAR(MAX)  =	NULL
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
	SELECT @ORDEN = (CASE WHEN @ORDEN = '' THEN 'D.Id asc' WHEN @ORDEN is null THEN 'D.Id asc' ELSE @ORDEN END);

	--DECLARACION DE VARIABLES 
	DECLARE @sql NVARCHAR(max);

	--------------------------------- DATOS Y CANTIDAD DE DATA DE LA TABLA  ------------------------------------
	SET @sql= '
    DECLARE @SEARCH NVARCHAR(MAX) = ''' + @SEARCH + ''';
	DECLARE @CONCAT NVARCHAR(MAX) = '+CONCAT('''%',ISNULL(@SEARCH, ''),'%''')+';

	--------------------------------- CANTIDAD DE DATA DE LA TABLA  ------------------------------------
    SELECT SUM(TotalDivisas)
    FROM (
    SELECT COUNT(DISTINCT d.Nombre) AS TotalDivisas
    FROM tblDivisa D
    INNER JOIN tblDivisa_x_TipoEfectivo DT ON D.Id = DT.FkIdDivisa
    INNER JOIN tblTipoEfectivo TE ON DT.FkIdTipoEfectivo = TE.Id
    WHERE D.Activo = (CASE 
            WHEN @SEARCH = ''Activo'' THEN 1
            WHEN @SEARCH = ''Inactivo'' THEN 0 END)
		  OR D.Id LIKE @CONCAT
		  OR D.Nombre LIKE @CONCAT
		  OR D.Nomenclatura LIKE @CONCAT
		  OR D.Descripcion LIKE @CONCAT
    GROUP BY d.Nombre
    ) AS Subconsulta;

    --------------------------------- DATOS DE LA TABLA  ------------------------------------
    WITH DATA_INDEXED AS (SELECT D.Id, 
	                             D.Activo, 
								 D.Nombre, 
								 D.Nomenclatura, 
								 D.Descripcion, 
								 STUFF((
											    SELECT '', '' + T.Nombre
												FROM tblDivisa_x_TipoEfectivo DTI 
												INNER JOIN tblTipoEfectivo T 
												ON DTI.FkIdTipoEfectivo = T.Id
												WHERE DTI.Activo = 1
												AND D.Id = DTI.FkIdDivisa
												FOR XML PATH ('''')
											 ), 1, 2, ''''
											) AS TipoEfectivo,
								 STUFF((SELECT '', '' + convert(varchar(max), T.Id, 120)
                                        FROM tblDivisa_x_TipoEfectivo DTI 
												INNER JOIN tblTipoEfectivo T 
												ON DTI.FkIdTipoEfectivo = T.Id
												WHERE DTI.Activo = 1
												AND D.Id = DTI.FkIdDivisa
												FOR XML PATH ('''')
											), 1, 2, ''''
									     ) AS TipoEfectivo_Id
								, ROW_NUMBER() OVER(ORDER BY '+ @ORDEN + ') AS [INDEX]
						FROM tblDivisa D
                        INNER JOIN tblDivisa_x_TipoEfectivo DT 
						ON D.Id = DT.FkIdDivisa
                        INNER JOIN tblTipoEfectivo TE 
						ON DT.FkIdTipoEfectivo = TE.Id
						AND DT.Activo = 1
						WHERE
						D.Activo = (CASE 
                                    WHEN @SEARCH = ''Activo'' THEN 1
                                    WHEN @SEARCH = ''Inactivo'' THEN 0 END)
						OR D.Id LIKE @CONCAT
						OR D.Nombre LIKE @CONCAT
					    OR D.Nomenclatura LIKE @CONCAT
						OR D.Descripcion LIKE @CONCAT
						GROUP BY D.Nombre, D.Id, D.Activo, D.Nomenclatura, D.Descripcion )
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