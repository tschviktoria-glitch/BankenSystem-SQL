USE [BankenSystem]
GO

/****** Object:  StoredProcedure [dbo].[sp_BackupBankenSystem]    Script Date: 09.04.2026 11:04:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



--Zweck: Diese gespeicherte Prozedur dient zur Automatisierung der vollständigen Datensicherung (Full Backup) der Datenbank BankenSystem.
--Flexibilität: Durch den Parameter @BackupFolderPath kann der Benutzer den Speicherort dynamisch festlegen, ohne den Code der Prozedur ändern zu müssen.
--Dateibenennung: Um Überschreibungen zu vermeiden, generiert die Prozedur automatisch einen eindeutigen Dateinamen, der das aktuelle Datum и время включает (BankenSystem_Backup_20260408_143005.bak).
--Sicherheit: Die Option WITH FORMAT erstellt einen neuen Mediensatz, um sicherzustellen, dass das Backup sauber geschrieben wird.


CREATE PROCEDURE [dbo].[sp_BackupBankenSystem]
    @BackupFolderPath NVARCHAR(500) -- Parameter für den Zielordner
AS
BEGIN
    SET NOCOUNT ON;

    -- Deklaration der Variablen für den Dateinamen und den vollständigen Pfad
    DECLARE @BackupFileName NVARCHAR(255);
    DECLARE @FullBackupPath NVARCHAR(1000);
    DECLARE @Timestamp NVARCHAR(20);

    -- Erstellung eines Zeitstempels (Format: YYYYMMDD_HHMMSS)
    SET @Timestamp = REPLACE(REPLACE(REPLACE(CONVERT(NVARCHAR, GETDATE(), 120), '-', ''), ' ', '_'), ':', '');

    -- Definition des Dateinamens
    SET @BackupFileName = 'BankenSystem_Backup_' + @Timestamp + '.bak';

    -- Sicherstellen, dass der Pfad mit einem Backslash endet
    IF RIGHT(@BackupFolderPath, 1) <> '\'
    BEGIN
        SET @BackupFolderPath = @BackupFolderPath + '\';
    END

    -- Vollständiger Pfad zur Sicherungsdatei
    SET @FullBackupPath = @BackupFolderPath + @BackupFileName;

    -- Ausführung des Backup-Befehls
    -- Beschreibung: Vollständige Datensicherung der Datenbank BankenSystem
    BACKUP DATABASE [BankenSystem]
    TO DISK = @FullBackupPath
    WITH FORMAT, 
         MEDIANAME = 'BankenSystemBackup', 
         NAME = 'Full Backup of BankenSystem',
         STATS = 10; -- Fortschrittsanzeige alle 10%

    -- Erfolgsmeldung ausgeben
    PRINT 'Die Sicherung wurde erfolgreich unter folgendem Pfad erstellt: ' + @FullBackupPath;
END;
GO


