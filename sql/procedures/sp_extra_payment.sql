USE [BankenSystem]
GO

/****** Object:  StoredProcedure [dbo].[sp_SondertilgungAusfuehren]    Script Date: 08.04.2026 14:59:18 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_SondertilgungAusfuehren]
    @KreditID INT,              --  Kredit-ID
    @Sonderzahlung DECIMAL(18,2) --  Sondertilgungsbetrag
AS
BEGIN
    SET NOCOUNT ON;

    --  Variablen für die Prüfung
    DECLARE @AktuellerSaldo DECIMAL(18,2);

    BEGIN TRY
        -- 1. Aktuellen Restaldo abrufen
        SELECT @AktuellerSaldo = RestSaldo 
        FROM Kredite 
        WHERE KreditID = @KreditID;

        -- 2. Validierung: Sondertilgung darf den Restaldo nicht überschreiten
        IF (@Sonderzahlung > @AktuellerSaldo)
        BEGIN
            RAISERROR('Betrag überschreitet Restschuld.', 16, 1);
            RETURN;
        END

        BEGIN TRANSACTION;

        -- 3. Zahlung als "Sondertilgung des Kapitals" erfassen
        INSERT INTO Kreditrueckzahlungen (
            KreditID, 
            ZahlungsstatusID, 
            Zahlungsdatum, 
            Tilgungsanteil, -- Gesamter Betrag fließt in die Tilgung
            Zinsanteil      -- Keine Zinsen für diese Zahlung
        )
        VALUES (
            @KreditID, 
            5,              -- Status: Ausgezahlt
            GETDATE(), 
            @Sonderzahlung, 
            0.00
        );

        -- 4. Restaldo in der Hauptkredittabelle aktualisieren
        UPDATE Kredite
        SET RestSaldo = RestSaldo - @Sonderzahlung
        WHERE KreditID = @KreditID;

        COMMIT TRANSACTION;

        PRINT 'Sondertilgung erfolgreich durchgeführt.';

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        
        --  Fehlerbehandlung
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        PRINT 'Fehler bei der Tilgung: ' + @ErrorMessage;
    END CATCH
END;
GO


