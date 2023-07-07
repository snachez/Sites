﻿CREATE   PROCEDURE SP_InsertCuentaInterna_x_GrupoAgenciasMultiple(@CUENTAS_X_GRUPO_JSON NVARCHAR(MAX))
AS
BEGIN
	---
	/*
	----------------
	NOTA IMPORTANTE:
	----------------
	-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
	- EL FORMATO ESPERADO PARA LA CADENA JSON(@CUENTAS_X_GRUPO_JSON) ES '[{"FkIdGrupoAgencias": 1,"FkIdCuentaInterna": 5},{"FkIdGrupoAgencias": 1,"FkIdCuentaInterna": 3}]
	-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
	*/
	---
	BEGIN TRY
		---
		DECLARE @OUT_NEW_IDs TABLE(NEW_ID INT)
		---
		INSERT INTO tblCuentaInterna_x_GrupoAgencias(FkIdGrupoAgencias, FkIdCuentaInterna)
		OUTPUT inserted.Id AS NEW_ID INTO @OUT_NEW_IDs -- DEVUELVE CADA UNO DE LOS IDs CREADOS POR CADA INSERT Y LOS ALMACENA EN LA TABLA [ @OUT_NEW_IDs ]
		SELECT DISTINCT J.FkIdGrupoAgencias, J.FkIdCuentaInterna -- SE EMPLEA UN DISTINCT PARA EVITAR DUPLICADOS...
		FROM  
		OPENJSON(@CUENTAS_X_GRUPO_JSON)
		WITH (	  FkIdGrupoAgencias INT '$.FkIdGrupoAgencias'
				, FkIdCuentaInterna INT '$.FkIdCuentaInterna') AS J
		LEFT JOIN tblCuentaInterna_x_GrupoAgencias CGA --- EL LEFT JOIN EN CONJUNTO CON LA CLAUSULA WHERE ME PERMITE DESCARTAR REGISTROS QUE YA FUERON INSERTADOS PREVIAMENTE...
		ON J.FkIdCuentaInterna = CGA.FkIdCuentaInterna
		AND J.FkIdGrupoAgencias = CGA.FkIdGrupoAgencias
		WHERE CGA.FkIdCuentaInterna IS NULL AND CGA.FkIdGrupoAgencias IS NULL -- ESTO PERMITE FILTRAR EL RESULTADO POR LOS ELEMENTOS QUE VERDADERAMENTE NO EXISTEN EN LA TABLA Y SE PUEDEN INSERTAR...
		--- REGISTROS EXISTENTES
		DECLARE @REGISTROS_DUPLICADOS NVARCHAR(MAX) = (SELECT		  DISTINCT CI.NumeroCuenta
																	, GA.Nombre AS NombreGrupo
																	, 'El numero de cuenta y el grupo ya se encuentran asociados' AS ERROR_MESSAGE_SP
															FROM  
															OPENJSON(@CUENTAS_X_GRUPO_JSON)
															WITH (	  FkIdGrupoAgencias INT '$.FkIdGrupoAgencias'
																	, FkIdCuentaInterna INT '$.FkIdCuentaInterna') AS J
															INNER JOIN tblCuentaInterna_x_GrupoAgencias CGA 
															ON J.FkIdCuentaInterna = CGA.FkIdCuentaInterna
															AND J.FkIdGrupoAgencias = CGA.FkIdGrupoAgencias 
															INNER JOIN tblCuentaInterna CI
															ON CGA.FkIdCuentaInterna = CI.Id
															INNER JOIN tblGrupoAgencia GA
															ON CGA.FkIdGrupoAgencias = GA.Id
															FOR JSON PATH)
		---
		DECLARE @RESULTADOS_INSERT NVARCHAR(MAX) = (	
														SELECT		CGA.Id								 AS [FkIdGrupoAgencias]
																	, CGA.Codigo					 AS [Codigo]
																	, CGA.Activo					 AS [Activo]
																	, CGA.FechaCreacion				 AS [FechaCreacion]
																	, CGA.FechaModificacion			 AS [FechaModificacion]

																	, C.Id							 AS [CuentaInterna.Id]
																	, C.NumeroCuenta				 AS [CuentaInterna.NumeroCuenta]
																	, C.Codigo							 AS [CuentaInterna.FkIdDivisa]
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
																	, G.EnviaRemesas				 AS	[GrupoAgencia.EnviaRemesas]
																	, G.SolicitaRemesas				 AS	[GrupoAgencia.SolicitaRemesas]
																	, G.Activo						 AS [GrupoAgencia.Activo]
																	, G.FechaCreacion				 AS [GrupoAgencia.FechaCreacion]
																	, G.FechaModificacion			 AS [GrupoAgencia.FechaModificacion]

															FROM tblCuentaInterna_x_GrupoAgencias CGA
															INNER JOIN tblGrupoAgencia G
															ON CGA.FkIdGrupoAgencias = G.Id
															INNER JOIN tblCuentaInterna C
															ON CGA.FkIdCuentaInterna = C.Id
															INNER JOIN tblDivisa D
															ON C.FkIdDivisa = D.Id
															WHERE CGA.Id IN (SELECT NEW_ID FROM @OUT_NEW_IDs)
															FOR JSON PATH
													)
		---
		DECLARE @ROW NVARCHAR(MAX) = (SELECT * FROM tblCuentaInterna_x_GrupoAgencias WHERE Id = ISNULL(SCOPE_IDENTITY(), -1) FOR JSON PATH)
		---
		DECLARE @ROWS_AFFECTED INT = (SELECT COUNT(*) FROM @OUT_NEW_IDs)
		---
		SELECT	  @ROWS_AFFECTED											AS ROWS_AFFECTED
				, CAST(1 AS BIT)											AS SUCCESS
				, @REGISTROS_DUPLICADOS										AS ERROR_MESSAGE_SP
				, NULL														AS ERROR_NUMBER_SP
				, NULL														AS ID
				, @RESULTADOS_INSERT										AS ROW
		---
	END TRY    
	BEGIN CATCH
		--
		DECLARE @ERROR_MESSAGE NVARCHAR(MAX) = ERROR_MESSAGE()
		--
		IF @ERROR_MESSAGE LIKE '%Unique_cuenta_x_grupo%' BEGIN 
			---
			SET @ERROR_MESSAGE = 'El numero de cuenta y el grupo ya se encuentran asociados'
			---
		END
		--
		SELECT	  0															AS ROWS_AFFECTED
				, CAST(0 AS BIT)											AS SUCCESS
				, @ERROR_MESSAGE											AS ERROR_MESSAGE_SP
				, ERROR_NUMBER()											AS ERROR_NUMBER_SP
				, -1														AS ID
				, NULL														AS ROW

		--   
	END CATCH
	---
END
---