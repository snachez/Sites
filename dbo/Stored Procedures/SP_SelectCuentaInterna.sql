CREATE   PROCEDURE [dbo].[SP_SelectCuentaInterna](    
													  @ID				INT			   =	NULL
													, @NUMERO_CUENTA	NVARCHAR(MAX)  =	NULL
													, @CODIGO			NVARCHAR(MAX)  =	NULL
													, @ACTIVO			BIT			   =	NULL
												)
AS
BEGIN
---
		---
	DECLARE @NEW_ROW NVARCHAR(MAX) = (SELECT				  CI.Id						AS [Id]
												, CI.NumeroCuenta			AS [NumeroCuenta]
												, CI.Codigo					AS [Codigo]
												, CI.FkIdDivisa				AS [FkIdDivisa]
												, CI.Activo					AS [Activo]
												, CI.FechaCreacion			AS [FechaCreacion]
												, CI.FechaModificacion		AS [FechaModificacion]
												, DV.Id						AS [Divisa.Id]
												, DV.Nombre					AS [Divisa.Nombre]
												, DV.Nomenclatura			AS [Divisa.Nomenclatura]
												, DV.Simbolo				AS [Divisa.Simbolo]
												, DV.Descripcion			AS [Divisa.Descripcion]
												, DV.Activo					AS [Divisa.Activo]
												, DV.FechaCreacion			AS [Divisa.FechaCreacion]
												, DV.FechaModificacion		AS [Divisa.FechaModificacion]
												FROM tblCuentaInterna CI
												INNER JOIN tblDivisa DV
												ON CI.FkIdDivisa = DV.Id
												WHERE CI.Id = ISNULL(@ID, CI.Id)
												AND Codigo = ISNULL(@CODIGO, Codigo)
												AND CI.NumeroCuenta = ISNULL(@NUMERO_CUENTA, CI.NumeroCuenta)
												AND CI.Activo = ISNULL(@ACTIVO, CI.Activo)FOR JSON PATH)

	---
	if(ISNULL(@NEW_ROW, 'NULL') != 'NULL')
	BEGIN
		SELECT	  @@ROWCOUNT												AS ROWS_AFFECTED
				, CAST(1 AS BIT)											AS SUCCESS
				, 'Ya existe la cuenta'										AS ERROR_MESSAGE_SP
				, NULL														AS ERROR_NUMBER_SP
				, CONVERT(INT, ISNULL(SCOPE_IDENTITY(), -1))				AS ID
				, @NEW_ROW													AS ROW
		---
		END
	else
	BEGIN
	     SELECT	  @@ROWCOUNT												AS ROWS_AFFECTED
				, CAST(0 AS BIT)											AS SUCCESS
				, ''										                AS ERROR_MESSAGE_SP
				, NULL														AS ERROR_NUMBER_SP
				, CONVERT(INT, ISNULL(SCOPE_IDENTITY(), -1))				AS ID
				, @NEW_ROW													AS ROW
				END
	---
END