CREATE   PROCEDURE [dbo].[SP_SelectCuentasInternas_x_GrupoAgencias](    
																		  @ID						NVARCHAR(MAX)  =	NULL
																		, @FK_ID_GRUPO				NVARCHAR(MAX)  =	NULL
																		, @FK_ID_CUENTA				NVARCHAR(MAX)  =	NULL
																		, @CODIGO_GRUPO_CUENTA		NVARCHAR(MAX)  =	NULL
																		, @CODIGO_GRUPO				NVARCHAR(MAX)  =	NULL
																		, @CODIGO_CUENTA			NVARCHAR(MAX)  =	NULL
																		, @ACTIVO					NVARCHAR(MAX)  =	NULL
																  )
AS
BEGIN
	---
	;WITH DATA_INDEXED AS (				SELECT   CGA.Id						 AS [Id]
												--, CGA.FkIdCuentaInterna			 AS [FkIdCuentaInterna]
												--, CGA.FkIdGrupoAgencias			 AS [FkIdGrupoAgencias]
												, CGA.Codigo					 AS [Codigo]
												, CGA.Activo					 AS [Activo]
												, CGA.FechaCreacion				 AS [FechaCreacion]
												, CGA.FechaModificacion			 AS [FechaModificacion]

												, C.Id							 AS [CuentaInterna.Id]
												, C.NumeroCuenta				 AS [CuentaInterna.NumeroCuenta]
												, C.Codigo						 AS [CuentaInterna.Codigo]
												--, C.FkIdDivisa					 AS [CuentaInterna.FkIdDivisa]
												, C.Activo						 AS [CuentaInterna.Activo]
												, C.FechaCreacion				 AS [CuentaInterna.FechaCreacion]
												, C.FechaModificacion			 AS [CuentaInterna.FechaModificacion]

												, D.Id							 AS [CuentaInterna.Divisa.Id]
												, D.Nombre						 AS [CuentaInterna.Divisa.Nombre]
												, D.Nomenclatura				 AS [CuentaInterna.Divisa.Nomenclatura]
												, D.Simbolo						 AS [CuentaInterna.Divisa.Simbolo]
												, D.Descripcion					 AS [CuentaInterna.Divisa.Descripcion]
												, D.Activo						 AS [CuentaInterna.Divisa.Activo]
												, D.FechaCreacion				 AS [CuentaInterna.Divisa.FechaCreacion]
												, D.FechaModificacion			 AS [CuentaInterna.Divisa.FechaModificacion]

												, G.Id							 AS [GrupoAgencia.Id]
												, G.Nombre						 AS [GrupoAgencia.Nombre]
												, G.Codigo						 AS [GrupoAgencia.Codigo]
												, G.EnviaRemesas				 AS [GrupoAgencia.EnviaRemesas]
												, G.SolicitaRemesas				 AS [GrupoAgencia.SolicitaRemesas]
												, G.Activo						 AS [GrupoAgencia.Activo]
												, G.FechaCreacion				 AS [GrupoAgencia.FechaCreacion]
												, G.FechaModificacion			 AS [GrupoAgencia.FechaModificacion]

												, ROW_NUMBER() OVER(ORDER BY G.Id) AS [INDEX]

										FROM tblCuentaInterna_x_GrupoAgencias CGA
										INNER JOIN tblGrupoAgencia G
										ON CGA.FkIdGrupoAgencias = G.Id
										INNER JOIN tblCuentaInterna C
										ON CGA.FkIdCuentaInterna = C.Id
										INNER JOIN tblDivisa D
										ON C.FkIdDivisa = D.Id
										WHERE CGA.Id = ISNULL(@ID, CGA.Id) 
										AND CGA.FkIdGrupoAgencias = ISNULL(@FK_ID_GRUPO, CGA.FkIdGrupoAgencias)
										AND CGA.FkIdCuentaInterna = ISNULL(@FK_ID_CUENTA, CGA.FkIdCuentaInterna)
										AND CGA.Codigo = ISNULL(@CODIGO_GRUPO_CUENTA, CGA.Codigo)
										AND C.Codigo = ISNULL(@CODIGO_CUENTA, C.Codigo)
										AND G.Codigo = ISNULL(@CODIGO_GRUPO, G.Codigo)
										AND CGA.Activo = ISNULL(@ACTIVO, CGA.Activo))
	SELECT * INTO #tmpTblDataResult FROM DATA_INDEXED;
	---
	DECLARE @JSON_RESULT NVARCHAR(MAX) = (SELECT * FROM #tmpTblDataResult FOR JSON PATH)
	---
	DROP TABLE #tmpTblDataResult
	---
	SELECT @JSON_RESULT AS JSON_GRUPO_AGENCIAS
	---
END