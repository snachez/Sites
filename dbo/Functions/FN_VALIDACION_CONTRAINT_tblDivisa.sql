﻿CREATE   FUNCTION [dbo].[FN_VALIDACION_CONTRAINT_tblDivisa](@Fk_Id_Divisa INT)
RETURNS BIT
AS
BEGIN
	--VALIDA SI LA DIVISA ESTA ACTIVA
	RETURN (SELECT Activo FROM tblDivisa WHERE Id = @Fk_Id_Divisa)
	--
END