USE [BankenSystem];
GO

DECLARE @Msg NVARCHAR(500);

SELECT  * FROM Kredite 
WHERE KreditID = 2; 

SELECT  * FROM Kreditrueckzahlungen
WHERE KreditID = 2;
 
DECLARE @Msg NVARCHAR(500);
-- ─────────────────────────────────────────────
-- Test 1: 
-- Der eingezahlte Betrag ist höher als die aktuellen Schulden
-- ─────────────────────────────────────────────
PRINT '=== Test 1: Der eingezahlte Betrag ist höher als die aktuellen Schulden ===';
EXEC dbo.sp_SondertilgungAusfuehren
    @KreditID = 2 ,         --  Kredit-ID
    @Sonderzahlung = 20000  --  Sondertilgungsbetrag
PRINT @Msg;
PRINT '';


DECLARE @Msg NVARCHAR(500);
-- ─────────────────────────────────────────────
-- Test 2: 
-- Rückzahlung eines Teils des Darlehenskapitals
-- ─────────────────────────────────────────────
PRINT '=== Test 2: Rückzahlung eines Teils des Darlehenskapitals ===';
EXEC dbo.sp_SondertilgungAusfuehren
    @KreditID = 2 ,         --  Kredit-ID
    @Sonderzahlung = 5000  --  Sondertilgungsbetrag
PRINT @Msg;
PRINT '';

DECLARE @Msg NVARCHAR(500);
-- ─────────────────────────────────────────────
-- Test 3: 
-- Vorzeitige Rückzahlung eines Darlehens
-- ─────────────────────────────────────────────
PRINT '=== Test 3: Vorzeitige Rückzahlung eines Darlehens ===';
EXEC dbo.sp_SondertilgungAusfuehren
    @KreditID = 2 ,         --  Kredit-ID
    @Sonderzahlung = 10000  --  Sondertilgungsbetrag
PRINT @Msg;
PRINT '';