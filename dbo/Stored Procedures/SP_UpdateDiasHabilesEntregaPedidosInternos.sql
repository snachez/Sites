
CREATE   PROCEDURE SP_UpdateDiasHabilesEntregaPedidosInternos(
  @DIA											INT
, @PERMITE_REMESAS								BIT
, @ENTREGAS_MISMO_DIA							BIT
, @ENTREGAS_LUNES								BIT
, @ENTREGAS_MARTES								BIT
, @ENTREGAS_MIERCOLES							BIT
, @ENTREGAS_JUEVES								BIT
, @ENTREGAS_VIERNES								BIT
, @ENTREGAS_SABADO								BIT
, @ENTREGAS_DOMINGO								BIT
, @HORA_DESDE									TIME
, @HORA_HASTA									TIME
, @HORA_LIMITE_MISMO_DIA						TIME
)
AS
BEGIN
	---
	BEGIN TRY
		---
		DECLARE @ROW NVARCHAR(MAX) = (SELECT * FROM tblDiasHabilesEntregaPedidosInternos WHERE Dia = @DIA FOR JSON PATH)
		---
		UPDATE tblDiasHabilesEntregaPedidosInternos SET
		  PermiteRemesas					=		@PERMITE_REMESAS
		, PermiteEntregasMismoDia			=		IIF(@PERMITE_REMESAS = 1, @ENTREGAS_MISMO_DIA, 0)
		, EntregarLunes						=		IIF(@PERMITE_REMESAS = 1, IIF(@ENTREGAS_MISMO_DIA = 1 AND @DIA = 1, 1, IIF(@ENTREGAS_MISMO_DIA = 0 AND @DIA = 1 AND @ENTREGAS_LUNES = 1, 0, @ENTREGAS_LUNES)), 0)
		, EntregarMartes					=		IIF(@PERMITE_REMESAS = 1, IIF(@ENTREGAS_MISMO_DIA = 1 AND @DIA = 2, 1, IIF(@ENTREGAS_MISMO_DIA = 0 AND @DIA = 2 AND @ENTREGAS_MARTES = 1, 0, @ENTREGAS_MARTES)), 0)
		, EntregarMiercoles					=		IIF(@PERMITE_REMESAS = 1, IIF(@ENTREGAS_MISMO_DIA = 1 AND @DIA = 3, 1, IIF(@ENTREGAS_MISMO_DIA = 0 AND @DIA = 3 AND @ENTREGAS_MIERCOLES = 1, 0, @ENTREGAS_MIERCOLES)), 0)
		, EntregarJueves					=		IIF(@PERMITE_REMESAS = 1, IIF(@ENTREGAS_MISMO_DIA = 1 AND @DIA = 4, 1, IIF(@ENTREGAS_MISMO_DIA = 0 AND @DIA = 4 AND @ENTREGAS_JUEVES = 1, 0, @ENTREGAS_JUEVES)), 0)
		, EntregarViernes					=		IIF(@PERMITE_REMESAS = 1, IIF(@ENTREGAS_MISMO_DIA = 1 AND @DIA = 5, 1, IIF(@ENTREGAS_MISMO_DIA = 0 AND @DIA = 5 AND @ENTREGAS_VIERNES = 1, 0, @ENTREGAS_VIERNES)), 0)
		, EntregarSabado					=		IIF(@PERMITE_REMESAS = 1, IIF(@ENTREGAS_MISMO_DIA = 1 AND @DIA = 6, 1, IIF(@ENTREGAS_MISMO_DIA = 0 AND @DIA = 6 AND @ENTREGAS_SABADO = 1, 0, @ENTREGAS_SABADO)), 0)
		, EntregarDomingo					=		IIF(@PERMITE_REMESAS = 1, IIF(@ENTREGAS_MISMO_DIA = 1 AND @DIA = 7, 1, IIF(@ENTREGAS_MISMO_DIA = 0 AND @DIA = 7 AND @ENTREGAS_DOMINGO = 1, 0, @ENTREGAS_DOMINGO)), 0)
		, HoraDesde							=		IIF(@PERMITE_REMESAS = 1, @HORA_DESDE, NULL)
		, HoraHasta							=		IIF(@PERMITE_REMESAS = 1, @HORA_HASTA, NULL)
		, HoraLimiteMismoDia				=		IIF(@PERMITE_REMESAS = 1 AND @ENTREGAS_MISMO_DIA = 1, @HORA_LIMITE_MISMO_DIA, NULL)
		, FechaModificacion					=		CURRENT_TIMESTAMP
		WHERE Dia = @DIA
		---
		SELECT	  @@ROWCOUNT												AS ROWS_AFFECTED
				, CAST(1 AS BIT)											AS SUCCESS
				, ''														AS ERROR_MESSAGE_SP
				, ''														AS CONSTRAINT_TRIGGER_NAME
				, NULL														AS ERROR_NUMBER_SP
				, CONVERT(INT, ISNULL(SCOPE_IDENTITY(), -1))				AS ID
				, @ROW														AS ROW
		---
	END TRY    
	BEGIN CATCH
		---
		DECLARE @ERROR_MESSAGE NVARCHAR(MAX) = ERROR_MESSAGE()
		---
		DECLARE @CONSTRAINT_NAME NVARCHAR(MAX) = ''
		---
		DECLARE @NOMBRE_DIA NVARCHAR(MAX) = (SELECT NombreDia FROM tblDiasHabilesEntregaPedidosInternos WHERE Dia = @DIA)
		--
		IF @ERROR_MESSAGE LIKE '%tbl001_C3_Check_Hora_Desde_Hasta_Not_Null%' BEGIN 
			---
			SET @CONSTRAINT_NAME = 'Check_Hora_Desde_Hasta_Not_Null'
			SET @ERROR_MESSAGE = 'Al seleccionar el día ' + @NOMBRE_DIA + ' como dia hábil para tramitar pedidos internos, debe seleccionar la hora desde/hasta'
			---
		END
		--
		ELSE IF @ERROR_MESSAGE LIKE '%tbl001_C4_Check_Rango_Hora_Desde_Hasta_Valido%' BEGIN 
			---
			SET @CONSTRAINT_NAME = 'Check_Rango_Hora_Desde_Hasta_Valido'
			SET @ERROR_MESSAGE = CONCAT('Para el dia ', @NOMBRE_DIA,', la hora desde(', CONVERT(char(5), @HORA_DESDE, 108), ') debe ser menor o igual que la hora hasta(', CONVERT(char(5), @HORA_HASTA, 108), ')')
			---
		END
		--
		ELSE IF @ERROR_MESSAGE LIKE '%tbl001_C5_Check_Al_Menos_Un_DiaEntrega_Requerido_Distinto_Al_De_Entregas_Mismo_Dia%' BEGIN 
			---
			SET @CONSTRAINT_NAME = 'Check_Al_Menos_Un_DiaEntrega_Requerido'
			SET @ERROR_MESSAGE = (SELECT CASE 
												WHEN @DIA = 1 AND @ENTREGAS_LUNES = 1		THEN 'Al pemitir remesas para el día ' + @NOMBRE_DIA + ' y ser el único día de entrega. Debe seleccionar al menos un día extra'
												WHEN @DIA = 2 AND @ENTREGAS_MARTES = 1		THEN 'Al pemitir remesas para el día ' + @NOMBRE_DIA + ' y ser el único día de entrega. Debe seleccionar al menos un día extra'
												WHEN @DIA = 3 AND @ENTREGAS_MIERCOLES = 1	THEN 'Al pemitir remesas para el día ' + @NOMBRE_DIA + ' y ser el único día de entrega. Debe seleccionar al menos un día extra'
												WHEN @DIA = 4 AND @ENTREGAS_JUEVES = 1		THEN 'Al pemitir remesas para el día ' + @NOMBRE_DIA + ' y ser el único día de entrega. Debe seleccionar al menos un día extra'
												WHEN @DIA = 5 AND @ENTREGAS_VIERNES = 1		THEN 'Al pemitir remesas para el día ' + @NOMBRE_DIA + ' y ser el único día de entrega. Debe seleccionar al menos un día extra'
												WHEN @DIA = 6 AND @ENTREGAS_SABADO = 1		THEN 'Al pemitir remesas para el día ' + @NOMBRE_DIA + ' y ser el único día de entrega. Debe seleccionar al menos un día extra'
												WHEN @DIA = 7 AND @ENTREGAS_DOMINGO = 1		THEN 'Al pemitir remesas para el día ' + @NOMBRE_DIA + ' y ser el único día de entrega. Debe seleccionar al menos un día extra'
												ELSE 'Al habilitar el día ' + @NOMBRE_DIA + ' para tramitar pedidos, debe seleccionar al menos un día de entrega'
										 END)
			---
		END
		--
		ELSE IF @ERROR_MESSAGE LIKE '%tbl001_C7_Check_Hora_Limite_Mismo_Dia_Requerido%' BEGIN 
			---
			SET @CONSTRAINT_NAME = 'Check_Hora_Limite_Mismo_Dia_Requerido'
			SET @ERROR_MESSAGE = 'La hora limite mismo día es requerida cuando se habilita las entregas para el mismo día(' + @NOMBRE_DIA + ')'
			---
		END
		--
		ELSE IF @ERROR_MESSAGE LIKE '%tbl001_C8_Check_Hora_Limite_Mismo_Dia_Valida%' BEGIN 
			---
			SET @CONSTRAINT_NAME = 'Check_Hora_Limite_Mismo_Dia_Valida'
			SET @ERROR_MESSAGE = CONCAT('La hora limite mismo día(', CONVERT(char(5), @HORA_LIMITE_MISMO_DIA, 108), ') debe estár entre el rango seleccionado. Hora desde(', CONVERT(char(5), @HORA_DESDE, 108), ') y hora hasta(', CONVERT(char(5), @HORA_HASTA, 108), ') para el día ', @NOMBRE_DIA)
			---
		END ELSE IF @ERROR_MESSAGE LIKE '%tbl001_C6_Check_Regla_De_Los_Dos_Dias%' BEGIN
			---
			SET @CONSTRAINT_NAME = 'Check_Regla_De_Los_Dos_Dias'
			SET @ERROR_MESSAGE = 'Obligatorio seleccionar un día de entrega más como respaldo. Note que esto ocurre al marcar unicamente el día imediato al ' + @NOMBRE_DIA + ' para entregas. Tome en concideración que ' + @NOMBRE_DIA + ' no cuenta como día de respaldo'
			---
		END
		--
		SELECT	  CAST(0 AS BIT)											AS SUCCESS
				, @ERROR_MESSAGE											AS ERROR_MESSAGE_SP
				, @CONSTRAINT_NAME											AS CONSTRAINT_TRIGGER_NAME
				, ERROR_NUMBER()											AS ERROR_NUMBER_SP
				, 0															AS ROWS_AFFECTED
				, -1														AS ID
				, @ROW														AS ROW

		--
	END CATCH
	---
END