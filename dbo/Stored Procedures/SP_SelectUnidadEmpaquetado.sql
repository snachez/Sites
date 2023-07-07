



CREATE   PROCEDURE [dbo].[SP_SelectUnidadEmpaquetado] (		  @ID		INT = NULL
															, @NOMBRE	NVARCHAR(MAX) = NULL
															, @ACTIVO	BIT = NULL
													 )
AS
BEGIN
	---
	SELECT		  UE.Id						AS Id
				, UE.Nombre					AS Nombre
				, UE.Descripcion			AS Descripcion
				, UE.MaxUnidadesBase		AS MaxUnidadesBase
				, UE.OrdenJerarquia			AS OrdenJerarquia
				, UE.fk_Id_UnidadBase		AS fk_Id_UnidadBase
				, UE.Activo					AS Activo
				, UE.FechaCreacion			AS FechaCreacion
				, UE.FechaModificacion		AS FechaModificacion

				, U.Id						AS Id
				, U.Nombre					AS Nombre
				, U.Descripcion				AS Descripcion
				, U.Activo					AS Activo
				, U.FechaCreacion			AS FechaCreacion
				, U.FechaModificacion		AS FechaModificacion


	FROM tblUnidadEmpaquetado UE
	INNER JOIN tblUnidadBase U
	ON UE.fk_Id_UnidadBase = U.Id
	WHERE 	ISNULL(@ID, UE.Id)				= UE.Id
	AND		ISNULL(@NOMBRE, UE.Nombre)		= UE.Nombre
	AND		ISNULL(@ACTIVO, UE.Activo)		= UE.Activo
	ORDER BY OrdenJerarquia
	---
END