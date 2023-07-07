CREATE PROCEDURE [dbo].[SP_HabilitarCuentaInterna_x_GrupoAgencias](@FkIdCuentaInterna INT, @FkIdGrupoAgencias INT, @ACTIVO BIT)
AS
BEGIN
	---
	BEGIN TRY
		---
		UPDATE tblCuentaInterna_x_GrupoAgencias SET Activo = @ACTIVO, FechaModificacion = CURRENT_TIMESTAMP 
		WHERE FkIdCuentaInterna = @FkIdCuentaInterna AND FkIdGrupoAgencias = @FkIdGrupoAgencias
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
										WHERE CGA.FkIdCuentaInterna = ISNULL(@FkIdCuentaInterna, CGA.FkIdCuentaInterna) 
										AND CGA.FkIdGrupoAgencias = ISNULL(@FkIdGrupoAgencias, CGA.FkIdGrupoAgencias) 
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
		SELECT	  CAST(0 AS BIT)											AS SUCCESS
				, ERROR_MESSAGE()											AS ERROR_MESSAGE_SP
				, ERROR_NUMBER()											AS ERROR_NUMBER_SP
				, 0															AS ROWS_AFFECTED
				, -1														AS ID
				, NULL														AS ROW

		--   
	END CATCH
	---
END