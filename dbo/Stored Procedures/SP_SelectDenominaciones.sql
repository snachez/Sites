

CREATE PROCEDURE [dbo].[SP_SelectDenominaciones] (         @SEARCH					NVARCHAR(MAX)  =	NULL
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
    SELECT SUM(TotalDenominaciones)
    FROM (
    SELECT COUNT(DISTINCT D.Nombre) AS TotalDenominaciones
                        FROM tblDenominaciones D
                        LEFT JOIN tblDenominaciones_x_Modulo DM 
						ON D.Id = DM.FkIdDenominaciones
						AND DM.Activo = 1
                        LEFT JOIN tblModulo M 
						ON DM.FkIdModulo = M.Id
						INNER JOIN tblDivisa DI 
						ON D.IdDivisa = DI.Id
						INNER JOIN tblTipoEfectivo TI
						ON D.BMO = TI.Id
						WHERE
						D.Activo = (CASE 
                                    WHEN @SEARCH = ''Activo'' THEN 1
                                    WHEN @SEARCH = ''Inactivo'' THEN 0 END)
						OR D.Id LIKE @CONCAT
						OR D.Nombre LIKE @CONCAT
					    OR D.ValorNominal LIKE @CONCAT
						OR DI.Nomenclatura LIKE @CONCAT
						OR TI.Nombre LIKE @CONCAT
						GROUP BY D.Nombre
    ) AS Subconsulta;

    --------------------------------- DATOS DE LA TABLA  ------------------------------------
    WITH DATA_INDEXED AS (SELECT D.Id, 
	                             D.Activo, 
								 CONVERT(varchar, D.ValorNominal) + ''<br/>''+ D.Nombre AS ValorNominalFormat, 
								 D.ValorNominal,
								 D.Nombre                                               AS NombreDenominacion,
								 DI.Nomenclatura, 
								 D.IdDivisa, 
								 TI.Nombre                                              AS NombreTipoEfectivo,
								 D.BMO,
								 STUFF((SELECT ''<br/>'' + CONVERT(varchar, MO.Id) +''-''+ MO.Nombre
                                                FROM tblDenominaciones_x_Modulo DMO 
                                                LEFT JOIN tblModulo MO 
						                        ON DMO.FkIdModulo = MO.Id
												WHERE DMO.Activo = 1
												AND D.Id = DMO.FkIdDenominaciones
												FOR XML PATH ('''')
											), 1, 2, ''''
									     ) AS Modulo,
								 STUFF((SELECT '', '' + convert(varchar(max), MO.Id, 120)
                                                FROM tblDenominaciones_x_Modulo DMO 
                                                LEFT JOIN tblModulo MO 
						                        ON DMO.FkIdModulo = MO.Id
												WHERE DMO.Activo = 1
												AND D.Id = DMO.FkIdDenominaciones
												FOR XML PATH ('''')
											), 1, 2, ''''
									     ) AS Modulo_Id,
								 D.Imagen, 
								 ROW_NUMBER() OVER(ORDER BY  '+ @ORDEN + ' ) AS [INDEX]
						FROM tblDenominaciones D
                        LEFT JOIN tblDenominaciones_x_Modulo DM 
						ON D.Id = DM.FkIdDenominaciones
						AND DM.Activo = 1
                        LEFT JOIN tblModulo M 
						ON DM.FkIdModulo = M.Id
						INNER JOIN tblDivisa DI 
						ON D.IdDivisa = DI.Id
						INNER JOIN tblTipoEfectivo TI
						ON D.BMO = TI.Id
						WHERE
						D.Activo = (CASE 
                                    WHEN @SEARCH = ''Activo'' THEN 1
                                    WHEN @SEARCH = ''Inactivo'' THEN 0 END)
						OR D.Id LIKE @CONCAT
						OR D.Nombre LIKE @CONCAT
					    OR D.ValorNominal LIKE @CONCAT
						OR DI.Nomenclatura LIKE @CONCAT
						OR TI.Nombre LIKE @CONCAT
						GROUP BY D.Nombre, D.Id, D.Activo, D.ValorNominal, 
						D.IdDivisa, DI.Nomenclatura, TI.Nombre, D.BMO, D.Imagen )
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