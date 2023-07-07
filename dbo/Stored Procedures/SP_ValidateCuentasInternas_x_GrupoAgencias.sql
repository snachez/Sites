CREATE PROCEDURE [dbo].[SP_ValidateCuentasInternas_x_GrupoAgencias](    
																		  @FK_ID_GRUPO				NVARCHAR(MAX)  =	NULL
																		, @NUMERO_CUENTA					NVARCHAR(MAX)  =	NULL
																  )
AS
BEGIN
	--
	
	DECLARE @NEW_ROW NVARCHAR(MAX) = (  SELECT   CGA.Id				         AS [Id]
												, CGA.FkIdCuentaInterna			 AS [FkIdCuentaInterna]
												, CGA.FkIdGrupoAgencias			 AS [FkIdGrupoAgencias]
												, CGA.Activo					 AS [Activo]
												, C.NumeroCuenta				 AS [CuentaInterna.NumeroCuenta]

										FROM tblCuentaInterna_x_GrupoAgencias CGA
										INNER JOIN tblGrupoAgencia G
										ON CGA.FkIdGrupoAgencias = G.Id
										INNER JOIN tblCuentaInterna C
										ON CGA.FkIdCuentaInterna = C.Id
										INNER JOIN tblDivisa D
										ON C.FkIdDivisa = D.Id
										WHERE CGA.FkIdGrupoAgencias = ISNULL(@FK_ID_GRUPO, CGA.FkIdGrupoAgencias)
										AND C.NumeroCuenta = ISNULL(@NUMERO_CUENTA, C.Codigo)FOR JSON PATH)

	---
	if(ISNULL(@NEW_ROW, 'NULL') != 'NULL')
	BEGIN
		SELECT	  @@ROWCOUNT												AS ROWS_AFFECTED
				, CAST(1 AS BIT)											AS SUCCESS
				, 'Existe la cuenta en el grupo'										AS ERROR_MESSAGE_SP
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