:setvar DatabaseName "Sites.Global"

Use [$(DatabaseName)];
GO

PRINT N'Inicio de reversiones en [Sites.Global]';

SELECT GETDATE() AS TimeOfQuery;

PRINT N'Fin de reversiones en [Sites.Global]';
GO