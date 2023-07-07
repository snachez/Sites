CREATE   PROCEDURE [dbo].[SP_SelectTipoCambio] (		  @ID		INT = NULL
													, @FECHA	NVARCHAR(10) = NULL
													, @ACTIVO	BIT = NULL
													, @NOMENCLATURA NVARCHAR(5) = NULL
											  )
AS
BEGIN
	---
	DECLARE @JSON_RESULT NVARCHAR(MAX)
	---
	SET @JSON_RESULT = (
	SELECT 
			  TC.Id								AS [Id]

			, D.Id								AS [DivisaCotizada.Id]
			, D.Nombre							AS [DivisaCotizada.Nombre]
			, D.Nomenclatura					AS [DivisaCotizada.Nomenclatura]
			, D.Simbolo							AS [DivisaCotizada.Simbolo]
			, D.Descripcion						AS [DivisaCotizada.Descripcion]
			, D.Activo							AS [DivisaCotizada.Activo]
			, D.FechaCreacion					AS [DivisaCotizada.FechaCreacion]
			, D.FechaModificacion				AS [DivisaCotizada.FechaModificacion]

			, TC.CompraColones					AS [CompraColones]
			, TC.VentaColones					AS [VentaColones]
			, TC.Activo							AS [Activo]
			, TC.FechaCreacion					AS [FechaCreacion]
			, TC.FechaModificacion				AS [FechaModificacion]

	FROM tblTipoCambio TC
	INNER JOIN tblDivisa D
	ON TC.fk_Id_DivisaCotizada									= D.Id
	WHERE 	ISNULL(@ID, TC.Id)									= TC.Id
	AND		ISNULL(CAST(@FECHA AS DATE), CAST(TC.FechaCreacion AS DATE))		= CAST(TC.FechaCreacion AS DATE)
	AND		ISNULL(@ACTIVO, TC.Activo)							= TC.Activo
	AND		ISNULL(@NOMENCLATURA, D.Nomenclatura)				= D.Nomenclatura
	FOR JSON PATH )
	---
	SELECT @JSON_RESULT AS TIPO_CAMBIO
	---
END