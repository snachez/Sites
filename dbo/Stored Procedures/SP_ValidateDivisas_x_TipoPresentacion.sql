﻿CREATE PROCEDURE [dbo].[SP_ValidateDivisas_x_TipoPresentacion](   
                                                                          @FK_ID_DIVISA			NVARCHAR(MAX)  =	NULL,
																		  @ACTIVO					NVARCHAR(MAX)  =	NULL
																	)
AS
BEGIN
	---
										
	---

	DECLARE @NEW_ROW NVARCHAR(MAX) = ( SELECT     DTE.FkIdDivisa		 AS [FkIdDivisa]
												, TE.ID			 AS [FkIdTipoEfectivo]
												, DTE.Activo					 AS [Activo]



										FROM tblDivisa_x_TipoEfectivo DTE
										INNER JOIN tblTipoEfectivo TE
										ON DTE.FkIdTipoEfectivo = te.Id											
										WHERE DTE.FkIdDivisa = ISNULL(@FK_ID_DIVISA, DTE.FkIdDivisa)	and
										TE.Activo = @ACTIVO
										FOR JSON PATH)
	---
	if(ISNULL(@NEW_ROW, 'NULL') != 'NULL')
	BEGIN
		SELECT	  @@ROWCOUNT												AS ROWS_AFFECTED
				, CAST(0 AS BIT)											AS SUCCESS
				, 'Está tratando de activar la divisa con un valor inactivo o invalido'			AS ERROR_MESSAGE_SP
				, NULL														AS ERROR_NUMBER_SP
				, CONVERT(INT, ISNULL(SCOPE_IDENTITY(), -1))				AS ID
				, @NEW_ROW													AS ROW
		---
		END
	else
	BEGIN
	     SELECT	  @@ROWCOUNT												AS ROWS_AFFECTED
				, CAST(1 AS BIT)											AS SUCCESS
				, ''										                AS ERROR_MESSAGE_SP
				, NULL														AS ERROR_NUMBER_SP
				, CONVERT(INT, ISNULL(SCOPE_IDENTITY(), -1))				AS ID
				, @NEW_ROW													AS ROW
				END
	---
END