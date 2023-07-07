
CREATE   PROCEDURE [dbo].[SP_Select_Unidades_Medidas] (	 
																  @ID				NVARCHAR(MAX)  =	NULL 
																, @SEARCH			NVARCHAR(MAX)  =	NULL											
																, @ACTIVO			NVARCHAR(MAX)  =	NULL 
																, @PAGE				INT			   =	1
																, @SIZE				INT			   =	10
																, @ORDEN            NVARCHAR(50)   =    NULL
															)
AS
BEGIN
	
	--EXECUTE SP_Select_Unidades_Medidas @ID = null, @SEARCH = '', @ACTIVO = null,  @PAGE = 1 , @SIZE = 100, @ORDEN = 'Id asc'

	SET @PAGE = ISNULL(@PAGE, 1)
	SET @SIZE = ISNULL(@SIZE, 10)
	
	SELECT @ORDEN = (
		  CASE 
		  WHEN @ORDEN = '' THEN 
			'U.Id asc' 
		  WHEN @ORDEN is null THEN 
		    'U.Id asc'
		  WHEN @ORDEN  = 'Cantidad Unidades desc' THEN 
		    'U.Cantidad_Unidades desc' 
		  WHEN @ORDEN  = 'Cantidad Unidades asc' THEN 
		    'U.Cantidad_Unidades asc'
		  ELSE 
			@ORDEN
		  END
		  );
	SELECT @SEARCH = (CASE WHEN @SEARCH is null THEN '' ELSE @SEARCH END);
	
	DECLARE @sql NVARCHAR(max);
	---
	SET @sql= '
	DECLARE @SEARCH NVARCHAR(MAX) = ''' + @SEARCH + ''';
	DECLARE @CONCAT NVARCHAR(MAX) = '+CONCAT('''%',ISNULL(@SEARCH, ''),'%''')+';

    WITH DATA_INDEXED AS (
						SELECT  
								  U.Id								AS	[Id]
								, U.Nombre							AS	[Nombre]
								, U.Simbolo							AS	[Simbolo]										
								, U.Cantidad_Unidades				AS	[Cantidad_Unidades]	
								, U.Activo							AS	[Activo]			
								, U.Fecha_Creacion					AS	[Fecha_Creacion]
								, U.Fecha_Modificacion				AS	[Fecha_Modificacion]
								, U.Divisa							AS	[Divisa]
								, U.Presentaciones_Habilitadas		AS	[Presentaciones_Habilitadas]
								, ROW_NUMBER() OVER(ORDER BY '+ @ORDEN + ') AS [INDEX]
						FROM tblUnidadMedida U
												
						WHERE 
						U.Activo = (CASE 
                                  WHEN @SEARCH  = ''Activo'' THEN 1
                                  WHEN @SEARCH = ''Inactivo'' THEN 0 END)
						OR U.Id LIKE @CONCAT	
						OR U.Nombre LIKE @CONCAT
						OR U.Simbolo LIKE @CONCAT
						OR U.Cantidad_Unidades LIKE @CONCAT
						OR U.Divisa LIKE @CONCAT
						OR U.Presentaciones_Habilitadas LIKE @CONCAT)
						SELECT * INTO #tmpTblDataResult FROM DATA_INDEXED WHERE [INDEX] 
						BETWEEN '+ CONVERT(VARCHAR(12), (@PAGE) ) + ' AND ' + CONVERT(VARCHAR(12), ((@PAGE)+(@SIZE-1)))+ '
										---
	DECLARE @JSON_RESULT NVARCHAR(MAX) = (SELECT * FROM #tmpTblDataResult FOR JSON PATH)
	---
	DROP TABLE #tmpTblDataResult
	---
	SELECT @JSON_RESULT AS UNIDADES_MEDIDAS_JSONRESULT'
	--
	SELECT COUNT(*)
    FROM tblUnidadMedida U
		
	WHERE 
	U.Activo = (CASE 
            WHEN @SEARCH = 'Activo' THEN 1
            WHEN @SEARCH = 'Inactivo' THEN 0 END)
	OR U.Id LIKE CONCAT('%',ISNULL(@SEARCH, U.Id),'%')	
	OR U.Nombre LIKE CONCAT('%',ISNULL(@SEARCH, U.Nombre),'%')	
	OR U.Simbolo LIKE CONCAT('%',ISNULL(@SEARCH, U.Simbolo),'%')
	OR U.Cantidad_Unidades LIKE CONCAT('%',ISNULL(@SEARCH, U.Cantidad_Unidades),'%')
	OR U.Divisa LIKE CONCAT('%',ISNULL(@SEARCH, U.Divisa),'%')
	OR U.Presentaciones_Habilitadas LIKE CONCAT('%',ISNULL(@SEARCH, U.Divisa),'%');
	---
	EXECUTE (@sql);

END