:setvar DatabaseName "Sites.Global"

Use [$(DatabaseName)];
GO

PRINT N'*****************************************';
PRINT N'Inicio de reversiones en [Sites.Global]';
PRINT N'*****************************************';

SELECT GETDATE() AS TimeOfQuery;

PRINT N'*****************************************';
PRINT N'Fin de reversiones en [Sites.Global]';
PRINT N'*****************************************';
GO