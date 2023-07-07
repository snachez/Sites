CREATE PROCEDURE [dbo].[SP_SelectAgenciaBancaria] (	  @ID				NVARCHAR(MAX)  =	NULL
													, @ID_GRUPO			NVARCHAR(MAX)  =	NULL
													, @BRANCH_AGENCIA	NVARCHAR(MAX)  =	NULL
													, @NOMBRE			NVARCHAR(MAX)  =	NULL
													, @ACTIVO			NVARCHAR(MAX)  =	NULL
													, @PAGE				INT			   =	1
													, @SIZE				INT			   =	10
													, @ORDEN            NVARCHAR(50)   =    NULL
												)
AS
BEGIN
	 ---
	SET @PAGE = ISNULL(@PAGE, 1)
	SET @SIZE = ISNULL(@SIZE, 10)
	SELECT @ORDEN = (CASE WHEN @ORDEN = '' THEN 'A.Id asc' WHEN @ORDEN is null THEN 'A.Id asc' ELSE @ORDEN END);
	DECLARE @sql NVARCHAR(max);
	---
	SET @sql= '
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
								, A.FechaCreacion		  AS	[FechaCreacion]
								, A.FechaModificacion	  AS	[FechaModificacion]
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
						WHERE A.CodigoBranch = '+ISNULL(@BRANCH_AGENCIA, 'A.CodigoBranch')+'
						AND A.Activo = '+ISNULL(@ACTIVO, 'A.Activo')+'
						AND A.Id = '+ISNULL(@ID, 'A.Id')+'
						AND G.Id = '+ISNULL(@ID_GRUPO, 'G.Id')+'
						AND A.Nombre LIKE '+CONCAT('''%',ISNULL(@NOMBRE, 'A.Nombre'),'%''')+')
						SELECT * INTO #tmpTblDataResult FROM DATA_INDEXED WHERE [INDEX] 
						BETWEEN '+ CONVERT(VARCHAR(12), (@PAGE) ) + ' AND ' + CONVERT(VARCHAR(12), ((@PAGE)+(@SIZE-1)))+ '
										---
	DECLARE @JSON_RESULT NVARCHAR(MAX) = (SELECT * FROM #tmpTblDataResult FOR JSON PATH)
	---
	DROP TABLE #tmpTblDataResult
	---
	SELECT @JSON_RESULT AS AGENCIAS_BANCARIAS_JSONRESULT'

	SELECT COUNT(*) 
    FROM tblAgenciaBancaria A
	INNER JOIN tblGrupoAgencia G
	ON A.FkIdGrupoAgencia = G.Id
	WHERE A.CodigoBranch = ISNULL(@BRANCH_AGENCIA, A.CodigoBranch)
	AND A.Activo = ISNULL(@ACTIVO, A.Activo)
	AND A.Id = ISNULL(@ID, A.Id)
	AND G.Id = ISNULL(@ID_GRUPO, G.Id)
	AND A.Nombre LIKE CONCAT('%',ISNULL(@NOMBRE, A.Nombre),'%')
	---
	EXECUTE (@sql);

END