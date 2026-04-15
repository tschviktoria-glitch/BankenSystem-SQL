USE [BankenSystem];
GO

-- =============================================
-- Trigger: trg_UpdateKrediteNachZahlung
-- Fires: AFTER INSERT on Kreditrueckzahlungen
-- Updates: Kredite.RestSaldo
--          Kredite.KreditStatusID (if fully paid)
-- =============================================
CREATE OR ALTER TRIGGER dbo.trg_UpdateKrediteNachZahlung
ON [dbo].[Kreditrueckzahlungen]
AFTER INSERT
AS BEGIN
    SET NOCOUNT ON;

    -- ── Step 1: Update RestSaldo ──────────────────
    -- Reduce RestSaldo by Tilgungsanteil
    -- from the newly inserted row
    -- INSERTED is a special table that holds
    -- the new row just inserted
    UPDATE [dbo].[Kredite]
    SET    [RestSaldo] = [RestSaldo] - i.[Tilgungsanteil]
    FROM   [dbo].[Kredite]      k
    JOIN   inserted   i ON k.[KreditID] = i.[KreditID];

    -- ── Step 2: Check if fully paid ──────────────
    -- If RestSaldo reached 0 or below
    -- mark loan as Vollständig zurückgezahlt
    UPDATE [dbo].[Kredite]
    SET    [RestSaldo]      = 0,
           [KreditStatusID] = 6  -- Vollständig zurückgezahlt
    FROM   [dbo].[Kredite]      k
    JOIN   inserted   i ON k.[KreditID] = i.[KreditID]
    WHERE  k.[RestSaldo] <= 0;

END;
GO