CREATE   PROCEDURE SP_SelectCuentaInterna_x_AgenciaBancaria(    
																		  @ID						NVARCHAR(MAX)  =	NULL
																		, @FK_ID_AGENCIA			NVARCHAR(MAX)  =	NULL
																		, @FK_ID_CUENTA				NVARCHAR(MAX)  =	NULL
																		, @CODIGO_AGENCIA_CUENTA	NVARCHAR(MAX)  =	NULL
																		, @BRANCH_AGENCIA			NVARCHAR(MAX)  =	NULL
																		, @CODIGO_CUENTA			NVARCHAR(MAX)  =	NULL
																		, @ACTIVO					NVARCHAR(MAX)  =	NULL
																	)
AS
BEGIN
	---
										
	---

	DECLARE @JSONRESULT NVARCHAR(MAX) = (SELECT     CA.Id						 AS [Id]
												 --, CA.FkIdCuentaInterna			 AS [FkIdCuentaInterna]
												 --, CA.FkIdAgencia				 AS [FkIdAgencia]
												 , CA.Codigo					 AS [Codigo]
												 , CA.Activo					 AS [Activo]
												 , CA.FechaCreacion				 AS [FechaCreacion]
												 , CA.FechaModificacion			 AS [FechaModificacion]



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

												, A.Id							 AS [Agencia.Id]
												, A.Nombre						 AS [Agencia.Nombre]
												, A.FkIdGrupoAgencia			 AS [Agencia.FkIdGrupoAgencia]
												, A.UsaCuentasGrupo				 AS [Agencia.UsaCuentasGrupo]
												, A.EnviaRemesas				 AS [Agencia.EnviaRemesas]
												, A.SolicitaRemesas				 AS [Agencia.SolicitaRemesas]
												, A.CodigoBranch				 AS [Agencia.CodigoBranch]
												, A.CodigoProvincia				 AS [Agencia.CodigoProvincia]
												, A.CodigoCanton				 AS [Agencia.CodigoCanton]
												, A.CodigoDistrito				 AS [Agencia.CodigoDistrito]
												, A.Direccion					 AS [Agencia.Direccion]
												, A.Activo						 AS [Agencia.Activo]
												, A.FechaCreacion				 AS [Agencia.FechaCreacion]
												, A.FechaModificacion			 AS [Agencia.FechaModificacion]

										FROM tblCuentaInterna_x_Agencia CA
										INNER JOIN tblAgenciaBancaria A
										ON CA.FkIdAgencia = A.Id
										INNER JOIN tblCuentaInterna C
										ON CA.FkIdCuentaInterna = C.Id
										INNER JOIN tblDivisa D
										ON C.FkIdDivisa = D.Id
										WHERE CA.Id = ISNULL(@ID, CA.Id)
										AND CA.FkIdAgencia = ISNULL(@FK_ID_AGENCIA, CA.FkIdAgencia)
										AND CA.FkIdCuentaInterna = ISNULL(@FK_ID_CUENTA, CA.FkIdCuentaInterna)
										AND CA.Codigo = ISNULL(@CODIGO_AGENCIA_CUENTA, CA.Codigo)
										AND C.Codigo = ISNULL(@CODIGO_CUENTA, C.Codigo)
										AND A.CodigoBranch = ISNULL(@BRANCH_AGENCIA, A.CodigoBranch)
										AND CA.Activo = ISNULL(@ACTIVO, CA.Activo)
										FOR JSON PATH)
	---
	SELECT @JSONRESULT AS CUENTAS_INTERNAS_X_ANGECIAS_BANCARIAS_JSONRESULT
	---
END