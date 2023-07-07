
CREATE   PROCEDURE SP_SelectArea (	  @ID						NVARCHAR(MAX)  =	NULL
											, @NOMBRE					NVARCHAR(MAX)  =	NULL
											, @SEARCHING				NVARCHAR(MAX)  =	NULL
											, @CODIGO					NVARCHAR(MAX)  =	NULL
											, @ACTIVO					BIT			   =	NULL
											, @PAGE						INT			   =	1
											, @SIZE						INT			   =	10
										)
AS
BEGIN
	---
	SET @PAGE = ISNULL(@PAGE, 1)
	SET @SIZE = ISNULL(@SIZE, 10)
	---
	;WITH DATA_INDEXED AS (				SELECT     A.Id							AS [Id]
												 , A.Nombre						AS [Nombre]
												 , A.Codigo						AS [Codigo]
												 , A.Activo						AS [Activo]
												 , A.FechaCreacion				AS [FechaCreacion]
												 , A.FechaModificacion			AS [FechaModificacion]

												 , D.Id							AS [Departamento.Id]
												 , D.Nombre						AS [Departamento.Nombre]
												 , D.Activo						AS [Departamento.Activo]
												 , D.FechaCreacion				AS [Departamento.FechaCreacion]
												 , D.FechaModificacion			AS [Departamento.FechaModificacion]

												, ROW_NUMBER() OVER(ORDER BY A.Id) AS [INDEX]

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
	SELECT * INTO #tmpTblDataResult FROM DATA_INDEXED WHERE [INDEX] BETWEEN ((@PAGE * @SIZE)-(@SIZE-1)) AND (@PAGE * @SIZE)
	---
	DECLARE @JSON_RESULT NVARCHAR(MAX) = (SELECT * FROM #tmpTblDataResult 

	FOR JSON PATH)
	---
	DROP TABLE #tmpTblDataResult
	---
	SELECT COUNT(*) AS TotalRecords, @PAGE AS Page, @SIZE AS SizePage FROM tblArea WHERE Activo = ISNULL(@ACTIVO, Activo)
	---
	SELECT @JSON_RESULT AS JSON_RESULT_SELECT
	---
END