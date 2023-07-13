CREATE   FUNCTION [dbo].[FN_VALIDACION_CONTRAINT_CHANGE_ESTADO_tblDenominaciones](@REACTIVAR BIT, @Fk_Id_Denominacion INT)
RETURNS BIT
AS
BEGIN
	--
	-- VALIDA SI EXISTEN RELACIONES ACTIVAS PARA DESACTIVAR UN TIPO EFECTIVO
	DECLARE @RESULT BIT = 0


	DECLARE @RELACION_TE INT
	DECLARE @RELACION_D INT
	--
	IF @REACTIVAR = 1
	BEGIN
	    SET @RELACION_D = (select Count(*) from tblDivisa Dv
							inner join tblDenominaciones D on Dv.Id = D.IdDivisa
							where Dv.Activo = 0 and D.Id = @Fk_Id_Denominacion ) 
		SET @RELACION_TE = (select Count(*) from tblTipoEfectivo TE
							inner join tblDenominaciones D on TE.Id = D.BMO
							where TE.Activo = 0 and D.Id = @Fk_Id_Denominacion)
		IF(@RELACION_D > 0 OR @RELACION_TE > 0)
			BEGIN
				SET @RESULT = 1
			END
		
	END	

	--
    RETURN(@RESULT)
	--
END