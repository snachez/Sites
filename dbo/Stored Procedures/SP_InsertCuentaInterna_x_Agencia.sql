﻿CREATE   PROCEDURE [dbo].[SP_InsertCuentaInterna_x_Agencia](	  @FK_ID_CUENTA_INTERNA		INT
															, @FK_ID_AGENCIA			INT
														  )
AS
BEGIN
	---
	BEGIN TRY
		---
		INSERT INTO tblCuentaInterna_x_Agencia (FkIdCuentaInterna, FkIdAgencia) VALUES (@FK_ID_CUENTA_INTERNA, @FK_ID_AGENCIA)
		---
		DECLARE @ROW NVARCHAR(MAX) = (SELECT   CGA.Id						 AS [Id]
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

												, G.Id							 AS [Agencia.Id]
												, G.Nombre						 AS [Agencia.Nombre]
												, G.FkIdGrupoAgencia		     AS [Agencia.FkIdGrupoAgencia]
												, G.UsaCuentasGrupo		         AS [Agencia.UsaCuentasGrupo]
												, G.EnviaRemesas				 AS	[Agencia.EnviaRemesas]
												, G.SolicitaRemesas				 AS	[Agencia.SolicitaRemesas]
												, G.CodigoBranch				 AS	[Agencia.CodigoBranch]
												, G.CodigoProvincia				 AS	[Agencia.CodigoProvincia]
												, G.CodigoCanton				 AS	[Agencia.CodigoCanton]
												, G.CodigoDistrito				 AS	[Agencia.CodigoDistrito]
												, G.Direccion				     AS	[Agencia.Direccion]
												, G.Activo						 AS [Agencia.Activo]
												, G.FechaCreacion				 AS [Agencia.FechaCreacion]
												, G.FechaModificacion			 AS [Agencia.FechaModificacion]

										FROM tblCuentaInterna_x_Agencia CGA
										INNER JOIN tblAgenciaBancaria G
										ON CGA.FkIdAgencia = G.Id
										INNER JOIN tblCuentaInterna C
										ON CGA.FkIdCuentaInterna = C.Id
										INNER JOIN tblDivisa D
										ON C.FkIdDivisa = D.Id
										WHERE CGA.Id = ISNULL(SCOPE_IDENTITY(), -1)
										FOR JSON PATH)
		---
		SELECT	  @@ROWCOUNT												AS ROWS_AFFECTED
				, CAST(1 AS BIT)											AS SUCCESS
				, ''														AS ERROR_MESSAGE_SP
				, NULL														AS ERROR_NUMBER_SP
				, CONVERT(INT, ISNULL(SCOPE_IDENTITY(), -1))				AS ID
				, @ROW														AS ROW
		---
	END TRY    
	BEGIN CATCH
	    --
		DECLARE @ERROR_MESSAGE NVARCHAR(MAX) = ERROR_MESSAGE()
		--
		IF @ERROR_MESSAGE LIKE '%Unique_cuenta_x_grupo%' BEGIN 
			---
			SET @ERROR_MESSAGE = 'El numero de cuenta y la agencia ya se encuentran asociados'
			---
		END
		--
		SELECT	  CAST(0 AS BIT)											AS SUCCESS
				, @ERROR_MESSAGE											AS ERROR_MESSAGE_SP
				, ERROR_NUMBER()											AS ERROR_NUMBER_SP
				, 0															AS ROWS_AFFECTED
				, -1														AS ID
				, NULL														AS ROW

		--   
	END CATCH
	---
END
---