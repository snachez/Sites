CREATE  PROCEDURE [dbo].[SP_HabilitarDenominaciones_x_Modulo](@ID INT, @ACTIVO BIT)
AS
BEGIN
	---
	BEGIN TRY
		---
		UPDATE tblDenominaciones_x_Modulo SET Activo = @ACTIVO, FechaModificacion = CURRENT_TIMESTAMP 
		WHERE FkIdDenominaciones = @ID
		---
		DECLARE @ROW NVARCHAR(MAX) = (SELECT   DxA.Id AS [Id]												
											
												, DxA.FechaCreacion				 AS [FechaCreacion]
												, DxA.FechaModificacion			 AS [FechaModificacion]

												, D.Id							 AS [Denominaciones.Id]
												, D.Nombre						 AS [Denominaciones.Nombre]
												, D.ValorNominal				 AS [Denominaciones.ValorNominal]
												, D.IdDivisa					 AS [Denominaciones.IdDivisa]												
												, D.BMO							 AS [Denominaciones.BMO]
												, D.Imagen						 AS [Denominaciones.Imagen]
												, D.Activo						 AS [Denominaciones.Activo]
												, D.FechaCreacion				 AS [Denominaciones.FechaCreacion]
												, D.FechaModificacion			 AS [Denominaciones.FechaModificacion]

												, A.Id							 AS [Modulo.Id]
												, A.Nombre						 AS [Modulo.Nombre]
												, A.FechaCreacion				 AS [Modulo.FechaCreacion]
												, A.FechaModificacion			 AS [Modulo.FechaModificacion]

												

										FROM tblDenominaciones_x_Modulo DxA
										INNER JOIN tblDenominaciones D
										ON DxA.FkIdDenominaciones = D.Id
										INNER JOIN tblModulo A
										ON DxA.FkIdModulo = A.Id								
										WHERE DxA.Id = ISNULL(SCOPE_IDENTITY(), -1)
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
---