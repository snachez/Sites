

CREATE PROCEDURE [dbo].[SP_SelectGrupoAgencia] (         @SEARCH					NVARCHAR(MAX)  =	NULL
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
	SELECT @ORDEN = (CASE WHEN @ORDEN = '' THEN 'G.Id asc' WHEN @ORDEN is null THEN 'G.Id asc' ELSE @ORDEN END);

	--DECLARACION DE VARIABLES 
	DECLARE @sql NVARCHAR(max);

	--------------------------------- DATOS Y CANTIDAD DE DATA DE LA TABLA  ------------------------------------
	SET @sql= '
    DECLARE @SEARCH NVARCHAR(MAX) = ''' + @SEARCH + ''';
	DECLARE @CONCAT NVARCHAR(MAX) = '+CONCAT('''%',ISNULL(@SEARCH, ''),'%''')+';

	--------------------------------- CANTIDAD DE DATA DE LA TABLA  ------------------------------------
    SELECT SUM(TotalGruposAgencias)
    FROM (
    SELECT COUNT(DISTINCT G.Nombre) AS TotalGruposAgencias
                        FROM tblGrupoAgencia G
                        LEFT JOIN tblAgenciaBancaria A 
						ON A.FkIdGrupoAgencia = G.Id AND A.Activo = 1
                        LEFT JOIN tblCuentaInterna_x_GrupoAgencias CG 
						ON CG.FkIdGrupoAgencias = G.Id
						LEFT JOIN tblCuentaInterna CI
                        ON CI.Id = CG.FkIdCuentaInterna
						WHERE
						G.Activo = (CASE 
                                    WHEN @SEARCH = ''Activo'' THEN 1
                                    WHEN @SEARCH = ''Inactivo'' THEN 0 END)
						OR G.Id LIKE @CONCAT
						OR G.Nombre LIKE @CONCAT
    ) AS Subconsulta;

    --------------------------------- DATOS DE LA TABLA  ------------------------------------
    WITH DATA_INDEXED AS (SELECT
        G.Activo,
        G.Id,
        G.Nombre,
		 STUFF((SELECT '', '' + A.Nombre
                  FROM tblAgenciaBancaria A
                  WHERE A.FkIdGrupoAgencia = G.Id AND A.Activo = 1
				  FOR XML PATH ('''')
				), 1, 2, ''''
			) AS AgenciasActivas,
        0 AS UsuariosVinculados,
		 STUFF((SELECT '', '' + CONVERT(varchar, D.Nomenclatura +'' ''+ CI.NumeroCuenta)
                  FROM tblCuentaInterna_x_GrupoAgencias CG
                  LEFT JOIN tblCuentaInterna CI
                    ON CI.Id = CG.FkIdCuentaInterna
			      INNER JOIN tblDivisa D
			        ON D.Id = CI.FkIdDivisa
                  WHERE CG.FkIdGrupoAgencias = G.Id
			        AND CG.Activo = 1
				  FOR XML PATH ('''')
				), 1, 2, ''''
			) AS Cuentas,
        G.EnviaRemesas,
        G.SolicitaRemesas,
        (
            SELECT DISTINCT
                CI.Id,
                CI.NumeroCuenta,
                CI.Codigo,
                CI.Activo,
                CI.FechaCreacion,
                CI.FechaModificacion,
				D.Id                    [Divisa.Id],
                D.Activo                [Divisa.Activo],
                D.Nombre                [Divisa.Nombre],
                D.Nomenclatura          [Divisa.Nomenclatura],
                D.Descripcion           [Divisa.Descripcion]
            FROM tblCuentaInterna_x_GrupoAgencias CG
            LEFT JOIN tblCuentaInterna CI
                ON CI.Id = CG.FkIdCuentaInterna
			INNER JOIN tblDivisa D
			    ON D.Id = CI.FkIdDivisa
            WHERE CG.FkIdGrupoAgencias = G.Id
			    AND CG.Activo = 1
            FOR JSON PATH
        ) AS CuentaInterna,
        ROW_NUMBER() OVER(ORDER BY '+ @ORDEN +' ) AS [INDEX]
    FROM tblGrupoAgencia G
	WHERE
		 G.Activo = (CASE 
                     WHEN @SEARCH = ''Activo'' THEN 1
                     WHEN @SEARCH = ''Inactivo'' THEN 0 END)
				     OR G.Id LIKE @CONCAT
					 OR G.Nombre LIKE @CONCAT)
						SELECT * INTO #tmpTblDataResult FROM DATA_INDEXED WHERE [INDEX] 
						BETWEEN '+ CONVERT(VARCHAR(12), (@PAGE) ) + ' AND ' + CONVERT(VARCHAR(12), ((@PAGE)+(@SIZE-1)))+ '
										---
	DECLARE @JSON_RESULT NVARCHAR(MAX) = (SELECT * FROM #tmpTblDataResult ORDER BY '+REPLACE(''+ @ORDEN +'', 'G.', '')+' FOR JSON PATH)
	---
	SET @JSON_RESULT = REPLACE( @JSON_RESULT,''\'','''') --COMO EL JSON SE SERIALIZA EN 3 OCACIONES A CAUSA DE LA CLAUSULA: FOR JSON PATH, HAY QUE ELIMINARLES LOS \\\ A LAS TABLAS HIJOS
	SET @JSON_RESULT = REPLACE( @JSON_RESULT,'':"[{'','':[{'') --HAY QUE ELIMINAR LOS CARACTERES  \" CUANDO SE HABRE LAS LLAVES EN EL INICIO DE LAS CADENAS DE ARRAYS DE LAS TABLAS HIJOS
	SET @JSON_RESULT = REPLACE( @JSON_RESULT,''}]"'',''}]'') --Y TAMBIEN HAY QUE ELIMINAR LOS CARACTERES  \"  CUANDO SE CIERRA LAS LLAVES EN LAS CADENAS DE ARRAYS DE LAS TABLAS HIJOS

	DROP TABLE #tmpTblDataResult
	---
	SELECT @JSON_RESULT AS DATA_JSONRESULT;'

	EXECUTE (@sql);
END