
CREATE   PROCEDURE SP_SelectArea (	  @ID						NVARCHAR(MAX)  =	NULL
											, @NOMBRE					NVARCHAR(MAX)  =	NULL
											, @SEARCHING				NVARCHAR(MAX)  =	NULL
											, @CODIGO					NVARCHAR(MAX)  =	NULL
											, @ACTIVO					BIT			   =	NULL
											, @PAGE						INT			   =	1
											, @SIZE						INT			   =	10
											, @ORDER_BY					NVARCHAR(30)   =	1
										)
AS
BEGIN
	---
	SET @PAGE = ISNULL(@PAGE, 1)
	SET @SIZE = ISNULL(@SIZE, 10)
	---
	DECLARE @TOTAL_RECORDS INT = 0
	---
	;WITH DATA_INDEXED AS (				SELECT     A.Id							AS [Id]
												 , A.Nombre						AS [Nombre]
												 --, A.Fk_Id_Departamento			AS [Fk_Id_Departamento]
												 , A.Codigo						AS [Codigo]
												 , A.Activo						AS [Activo]
												 , A.FechaCreacion				AS [FechaCreacion]
												 , A.FechaModificacion			AS [FechaModificacion]

												 , D.Id							AS [Departamento.Id]
												 , D.Nombre						AS [Departamento.Nombre]
												 , D.Activo						AS [Departamento.Activo]
												 , D.FechaCreacion				AS [Departamento.FechaCreacion]
												 , D.FechaModificacion			AS [Departamento.FechaModificacion]

												--, ROW_NUMBER() OVER(ORDER BY A.Id) AS [INDEX]

												, CASE 
														WHEN @ORDER_BY = -1 THEN ROW_NUMBER() OVER(ORDER BY A.Id DESC)
														WHEN @ORDER_BY =  1 THEN ROW_NUMBER() OVER(ORDER BY A.Id)

														WHEN @ORDER_BY = -2 THEN ROW_NUMBER() OVER(ORDER BY A.Activo DESC)
														WHEN @ORDER_BY =  2 THEN ROW_NUMBER() OVER(ORDER BY A.Activo)

														WHEN @ORDER_BY = -3 THEN ROW_NUMBER() OVER(ORDER BY A.Nombre DESC)
														WHEN @ORDER_BY =  3 THEN ROW_NUMBER() OVER(ORDER BY A.Nombre)														

														WHEN @ORDER_BY = -4 THEN ROW_NUMBER() OVER(ORDER BY D.Nombre DESC)
														WHEN @ORDER_BY =  4 THEN ROW_NUMBER() OVER(ORDER BY D.Nombre)

														ELSE ROW_NUMBER() OVER(ORDER BY A.Id)
														END
												AS [INDEX]


										FROM tblArea A
										INNER JOIN tblDepartamento D
										ON A.Fk_Id_Departamento = D.Id
										WHERE A.Id = ISNULL(@ID, A.Id)
										AND A.Codigo = ISNULL(@CODIGO, A.Codigo)
										AND A.Activo = ISNULL(@ACTIVO, A.Activo)
										AND (
											   A.Nombre LIKE CONCAT('%', ISNULL(@SEARCHING, A.Nombre), '%')
											OR D.Nombre LIKE CONCAT('%', ISNULL(@SEARCHING, D.Nombre), '%') 
											OR A.Id LIKE CONCAT('%', ISNULL(@SEARCHING, A.Id), '%') 
										)
									)
	SELECT * INTO #tmpTblDataResult FROM DATA_INDEXED ORDER BY [INDEX]
	---
	DECLARE @JSON_RESULT NVARCHAR(MAX) = (SELECT * FROM #tmpTblDataResult WHERE [INDEX] BETWEEN ((@PAGE * @SIZE)-(@SIZE-1)) AND (@PAGE * @SIZE)
	ORDER BY [INDEX]
	FOR JSON PATH)
	---
	SET @TOTAL_RECORDS = (SELECT COUNT(*) FROM #tmpTblDataResult)
	---
	SELECT @TOTAL_RECORDS AS TotalRecords, @PAGE AS Page, @SIZE AS SizePage --FROM tblArea WHERE Activo = ISNULL(@ACTIVO, Activo)
	---
	SELECT @JSON_RESULT AS JSON_RESULT_SELECT
	---
	SELECT * FROM #tmpTblDataResult WHERE [INDEX] BETWEEN ((@PAGE * @SIZE)-(@SIZE-1)) AND (@PAGE * @SIZE)
	ORDER BY [INDEX]
	---
	DROP TABLE #tmpTblDataResult
	---
END