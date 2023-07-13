CREATE PROCEDURE [dbo].[SP_SelectAgenciaBancaria] (	  @SEARCH			NVARCHAR(MAX)  =	NULL
													, @PAGE				INT			   =	1
													, @SIZE				INT			   =	10
													, @ORDEN            NVARCHAR(50)   =    NULL
												)
AS
BEGIN
	 ---
	SET @PAGE = ISNULL(@PAGE, 1)
	SET @SIZE = ISNULL(@SIZE, 10)
	SET @SEARCH = ISNULL(@SEARCH, '')
	SELECT @ORDEN = (CASE WHEN @ORDEN = '' THEN 'A.Id asc' WHEN @ORDEN is null THEN 'A.Id asc' ELSE @ORDEN END);

	--DECLARACION DE VARIABLES 
	DECLARE @sql NVARCHAR(max);

	--------------------------------- DATOS Y CANTIDAD DE DATA DE LA TABLA  ------------------------------------
	SET @sql= '
    DECLARE @SEARCH NVARCHAR(MAX) = ''' + @SEARCH + ''';
	DECLARE @CONCAT NVARCHAR(MAX) = '+CONCAT('''%',ISNULL(@SEARCH, ''),'%''')+';

	--------------------------------- CANTIDAD DE DATA DE LA TABLA  ------------------------------------
    SELECT SUM(TotalAgencias)
    FROM (
    SELECT COUNT(DISTINCT A.Nombre) AS TotalAgencias
						FROM tblAgenciaBancaria A
						INNER JOIN tblGrupoAgencia G
						ON A.FkIdGrupoAgencia = G.Id
                        LEFT JOIN tblCuentaInterna_x_Agencia CA 
						ON CA.FkIdAgencia = G.Id
						LEFT JOIN tblCuentaInterna CI
                        ON CI.Id = CA.FkIdCuentaInterna
						WHERE A.Activo = (CASE 
                                          WHEN @SEARCH = ''Activo'' THEN 1
                                          WHEN @SEARCH = ''Inactivo'' THEN 0 END)
						OR A.CodigoBranch LIKE @CONCAT
						OR A.Id LIKE @CONCAT
						OR A.Nombre LIKE @CONCAT
    ) AS Subconsulta;

    --------------------------------- DATOS DE LA TABLA  -----------------------------------------------
    WITH DATA_INDEXED AS (SELECT  A.Id					  AS	[Id]
								, A.Nombre				  AS	[Nombre]
								, A.FkIdGrupoAgencia	  AS	[FkIdGrupoAgencia]
								, A.UsaCuentasGrupo		  AS	[UsaCuentasGrupo]
								, A.EnviaRemesas		  AS	[EnviaRemesas]
								, A.SolicitaRemesas		  AS	[SolicitaRemesas]
								, A.CodigoBranch		  AS	[CodigoBranch]
								, P.Nombre		          AS	[CodigoProvincia]
								, C.Nombre		          AS	[CodigoCanton]
								, D.Nombre		          AS	[CodigoDistrito]
								, A.Direccion			  AS	[Direccion]
								, A.Activo				  AS	[Activo]
						        , STUFF((
								         SELECT '', '' + CONVERT(varchar, D.Nomenclatura +'' ''+ CI.NumeroCuenta)
										 FROM tblCuentaInterna_x_Agencia CA
										 LEFT JOIN tblCuentaInterna CI
											ON CI.Id = CA.FkIdCuentaInterna
										 INNER JOIN tblDivisa D
											ON D.Id = CI.FkIdDivisa
										 WHERE CA.FkIdAgencia = A.Id
											AND CA.Activo = 1
										 FOR XML PATH ('''')
										), 1, 2, ''''
										)                 AS Cuentas
								, (
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
								   FROM tblCuentaInterna_x_Agencia CA
								   LEFT JOIN tblCuentaInterna CI
									ON CI.Id = CA.FkIdCuentaInterna
								   INNER JOIN tblDivisa D
			                        ON D.Id = CI.FkIdDivisa
								   WHERE CA.FkIdAgencia = A.Id
								   AND CA.Activo = 1
								   FOR JSON PATH
								) AS CuentaInterna
								, ROW_NUMBER() OVER(ORDER BY '+ @ORDEN + ') AS [INDEX]
						FROM tblAgenciaBancaria A
						INNER JOIN tblGrupoAgencia G
						ON A.FkIdGrupoAgencia = G.Id
						INNER JOIN tblProvincia P
						ON A.CodigoProvincia = P.Id
						INNER JOIN tblCanton C
						ON A.CodigoCanton = C.Id
						INNER JOIN tblDistrito D
						ON A.CodigoDistrito = D.Id
						WHERE A.Activo = (CASE 
                                          WHEN @SEARCH = ''Activo'' THEN 1
                                          WHEN @SEARCH = ''Inactivo'' THEN 0 END)
						OR A.CodigoBranch LIKE @CONCAT
						OR A.Id LIKE @CONCAT
						OR A.Nombre LIKE @CONCAT)
						SELECT * INTO #tmpTblDataResult FROM DATA_INDEXED WHERE [INDEX] 
						BETWEEN '+ CONVERT(VARCHAR(12), (@PAGE) ) + ' AND ' + CONVERT(VARCHAR(12), ((@PAGE)+(@SIZE-1)))+ '
										---
	DECLARE @JSON_RESULT NVARCHAR(MAX) = (SELECT * FROM #tmpTblDataResult  ORDER BY '+REPLACE(''+ @ORDEN +'', 'A.', '')+' FOR JSON PATH)
	---
    SET @JSON_RESULT = REPLACE( @JSON_RESULT,''\'','''') --COMO EL JSON SE SERIALIZA EN 3 OCACIONES A CAUSA DE LA CLAUSULA: FOR JSON PATH, HAY QUE ELIMINARLES LOS \\\ A LAS TABLAS HIJOS
	SET @JSON_RESULT = REPLACE( @JSON_RESULT,'':"[{'','':[{'') --HAY QUE ELIMINAR LOS CARACTERES  \" CUANDO SE HABRE LAS LLAVES EN EL INICIO DE LAS CADENAS DE ARRAYS DE LAS TABLAS HIJOS
	SET @JSON_RESULT = REPLACE( @JSON_RESULT,''}]"'',''}]'') --Y TAMBIEN HAY QUE ELIMINAR LOS CARACTERES  \"  CUANDO SE CIERRA LAS LLAVES EN LAS CADENAS DE ARRAYS DE LAS TABLAS HIJOS

	DROP TABLE #tmpTblDataResult
	---
	SELECT @JSON_RESULT AS AGENCIAS_BANCARIAS_JSONRESULT'

	EXECUTE (@sql);

END