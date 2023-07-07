CREATE   FUNCTION [dbo].[FN_VALIDACION_CONTRAINT_CHANGE_ESTADO_tblDivisas](@REACTIVAR BIT, @Fk_Id_Divisa INT)
RETURNS BIT
AS
BEGIN
	--
	-- VALIDA SI EXISTEN RELACIONES ACTIVAS PARA DESACTIVAR UN TIPO EFECTIVO
	DECLARE @RESULT BIT = 0

	DECLARE @RELACION_UM INT
	DECLARE @RELACION_D INT
	--
	IF @REACTIVAR = 0 
	BEGIN

	    SET @RELACION_D = (Select count(*) from tblDenominaciones where IdDivisa = @Fk_Id_Divisa and Activo = 1) 
		SET @RELACION_UM = (Select count(*) from tblUnidadMedida UM
							INNER JOIN tblUnidadMedida_x_Divisa UMTE ON UMTE.Fk_Id_Unidad_Medida = UM.Id AND UMTE.Fk_Id_Divisa = @Fk_Id_Divisa
							WHERE UM.Activo = 1)
		IF(@RELACION_D > 0 OR @RELACION_UM > 0)
			BEGIN
				SET @RESULT = 1
			END
		
	END	
	ELSE
		BEGIN
			SET @RELACION_UM =(Select count(*) from tblTipoEfectivo TE
					INNER JOIN tblDivisa_x_TipoEfectivo UMTE ON UMTE.FkIdTipoEfectivo = TE.Id AND UMTE.FkIdDivisa = @Fk_Id_Divisa
					WHERE TE.Activo = 0)
			IF(@RELACION_UM > 0)
				BEGIN
					SET @RESULT = 1
				END			
		END
	--
    RETURN(@RESULT)
	--
END