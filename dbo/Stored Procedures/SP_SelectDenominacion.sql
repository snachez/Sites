CREATE   PROCEDURE [dbo].[SP_SelectDenominacion](	  @ID		INT = NULL
															, @NOMBRE	NVARCHAR(MAX) = NULL
															, @VALOR	INT = NULL
															, @DIVISA	INT = NULL
															, @DIVISA_NOMENCLATURA NVARCHAR(MAX) = NULL
															, @ACTIVO	BIT = NULL
													   )
		AS
BEGIN
	---
	SELECT	  D.Id						 AS D_Id
			, D.Nombre					 AS D_Nombre
			, D.Descripcion				 AS D_Descripcion
			, D.Valor					 AS D_Valor
			, D.fk_Id_Divisa			 AS D_Divisa
			, D.EsBillete				 AS D_EsBillete
			, D.Activo					 AS D_Activo
			, D.FechaCreacion			 AS D_FechaCreacion
			, D.FechaModificacion		 AS D_FechaModificacion
			, M.Id						 AS M_Id
			, M.Nombre					 AS M_Nombre
			, M.Descripcion				 AS M_Descripcion
			, M.Nomenclatura			 AS M_Nomenclatura
			, M.Simbolo					 AS M_Simbolo
			, M.Activo					 AS M_Activo
			, M.FechaCreacion			 AS M_FechaCreacion
			, M.FechaModificacion		 AS M_FechaModificacion
	FROM tblDenominacion D
	INNER JOIN tblDivisa M
	ON D.fk_Id_Divisa = M.Id
	WHERE	ISNULL(@NOMBRE, D.Nombre)	= D.Nombre
	AND		ISNULL(@ID, D.Id)			= D.Id
	AND		ISNULL(@VALOR, D.Valor)		= D.Valor	
	AND		ISNULL(@DIVISA, D.fk_Id_Divisa)	= D.fk_Id_Divisa
	AND		ISNULL(@ACTIVO, D.Activo)	= D.Activo
	AND		ISNULL(@DIVISA_NOMENCLATURA, M.Nomenclatura)	= M.Nomenclatura
	---
END