USE BankenSystem
GO

-- Test: Speichern der Datenbank unter dem angegebenen Pfad
EXEC sp_BackupBankenSystem
@BackupFolderPath = N'C:\SQL-Kurs\ProjektBankenSystem\';