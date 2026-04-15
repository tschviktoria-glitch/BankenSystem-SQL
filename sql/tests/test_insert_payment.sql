
select * from [dbo].[Kredite]  --where KreditID=1
select * from [dbo].[Kreditrueckzahlungen] -- where KreditID=1

Update [dbo].[Kredite] 
SET RestSaldo=NettoBetrag

DELETE FROM Kreditrueckzahlungen;
DBCC CHECKIDENT('Kreditrueckzahlungen', RESEED,0)



-- View to enter data into proc
Select * from [dbo].[vw_ZahlungEintragenInfo]


-- Test 1: Test First Month payment for KreditID 1
-- Test 2: Test to execute for Same date again

-- Do mention about resaldo=nettobetrag

select * from [dbo].[Kredite]  where KreditID=1
select * from [dbo].[Kreditrueckzahlungen] where KreditID=1

DECLARE @Msg NVARCHAR(500);
PRINT '---Test 1: First payment---';
EXEC dbo.sp_ZahlungEintragen
    @KreditID      = 1,
    @MonatsRate    = 455.35,
    @Zahlungsdatum = '2021-05-01',
    @Meldung       = @Msg OUTPUT;
PRINT @Msg

Select dbo.fn_BerechneZinsanteil(20000.00, 4.5) AS [Zinsanteil]
Select dbo.fn_BerechneTilgungsanteil(455.35, 75.00) AS [Tilgungsanteil]

--- Trigger test

Select  20000.00 -380.35 -- 19619.65



-- Test 3: Month 2 , should succeed
select * from [dbo].[Kredite]  where KreditID=1
select * from [dbo].[Kreditrueckzahlungen] where KreditID=1

DECLARE @Msg NVARCHAR(500);
PRINT '   Test 3: Month 2 payment   ';
EXEC dbo.sp_ZahlungEintragen
    @KreditID      = 1,
    @MonatsRate    = 455.35,
    @Zahlungsdatum = '2021-06-02',
    @Meldung       = @Msg OUTPUT;
PRINT @Msg


select * from [dbo].[Kredite]  where KreditID=1
select * from [dbo].[Kreditrueckzahlungen] where KreditID=1

---- Test NUll datum
DECLARE @Msg NVARCHAR(500);
PRINT '  Test 4: Month given as NULL  ';
EXEC dbo.sp_ZahlungEintragen
    @KreditID      = 1,
    @MonatsRate    = 455.35,
    @Zahlungsdatum  = NULL,
    @Meldung       = @Msg OUTPUT;
PRINT @Msg;
PRINT '';


-- Test 4: Month 3 pays MORE than EMI

DECLARE @Msg NVARCHAR(500);
PRINT ' Test 4: Month 3 pays more  ';
EXEC dbo.sp_ZahlungEintragen
    @KreditID      = 1,
    @MonatsRate    = 600.00,
    @Zahlungsdatum = '2021-07-01',
    @Meldung       = @Msg OUTPUT;
PRINT @Msg;
PRINT '';

-- Test 5: Month 4 pays LESS than EMI
PRINT '   Test 5: Month 4 pays less   ';
DECLARE @Msg NVARCHAR(500);
EXEC dbo.sp_ZahlungEintragen
    @KreditID      = 1,
    @MonatsRate    = 400.00,
    @Zahlungsdatum = '2021-08-01',
    @Meldung       = @Msg OUTPUT;
PRINT @Msg;
PRINT '';
    
  -------------------------------

-- KreditID 2 , Felix Schulz (Studienkredit)
DECLARE @Msg NVARCHAR(500);
PRINT '   KreditID 2: Felix Schulz   ';
EXEC dbo.sp_ZahlungEintragen
    @KreditID      = 2,
    @MonatsRate    = 288.74,
    @Zahlungsdatum = '2022-07-01',
    @Meldung       = @Msg OUTPUT;
PRINT @Msg;

DECLARE @Msg NVARCHAR(500);
EXEC dbo.sp_ZahlungEintragen
    @KreditID      = 2,
    @MonatsRate    = 288.74,
    @Zahlungsdatum = '2022-08-01',
    @Meldung       = @Msg OUTPUT;
PRINT @Msg;

DECLARE @Msg NVARCHAR(500);
EXEC dbo.sp_ZahlungEintragen
    @KreditID      = 2,
    @MonatsRate    = 288.74,
    @Zahlungsdatum = '2022-09-01',
    @Meldung       = @Msg OUTPUT;
PRINT @Msg;


-- KreditID 3 → Maria Bauer (Kleinkredit)
-- fully repaid loan, few payments
DECLARE @Msg NVARCHAR(500);
PRINT '  KreditID 3: Maria Bauer  ';
EXEC dbo.sp_ZahlungEintragen
    @KreditID      = 3,
    @MonatsRate    = 222.54,
    @Zahlungsdatum = '2022-03-01',
    @Meldung       = @Msg OUTPUT;
PRINT @Msg;

DECLARE @Msg NVARCHAR(500);
EXEC dbo.sp_ZahlungEintragen
    @KreditID      = 3,
    @MonatsRate    = 222.54,
    @Zahlungsdatum = '2022-04-01',
    @Meldung       = @Msg OUTPUT;
PRINT @Msg;

EXEC dbo.sp_ZahlungEintragen
    @KreditID      = 3,
    @MonatsRate    = 222.54,
    @Zahlungsdatum = '2022-05-01',
    @Meldung       = @Msg OUTPUT;
PRINT @Msg;

-- ─────────────────────────────────────────────
-- KreditID 4 → Jonas Wolf (Immobilienkredit)
-- mortgage, large amount
-- ─────────────────────────────────────────────
PRINT '   KreditID 4: Jonas Wolf   ';

EXEC dbo.sp_ZahlungEintragen
    @KreditID      = 4,
    @MonatsRate    = 1595.73,
    @Zahlungsdatum = '2018-12-01',
    @Meldung       = @Msg OUTPUT;
PRINT @Msg;

EXEC dbo.sp_ZahlungEintragen
    @KreditID      = 4,
    @MonatsRate    = 1595.73,
    @Zahlungsdatum = '2019-01-01',
    @Meldung       = @Msg OUTPUT;
PRINT @Msg;

EXEC dbo.sp_ZahlungEintragen
    @KreditID      = 4,
    @MonatsRate    = 1595.73,
    @Zahlungsdatum = '2019-02-01',
    @Meldung       = @Msg OUTPUT;
PRINT @Msg;

-- ─────────────────────────────────────────────
-- KreditID 6 → Tobias Schwarz (Autokredit)
-- ─────────────────────────────────────────────
PRINT '  KreditID 6: Tobias Schwarz   ';

EXEC dbo.sp_ZahlungEintragen
    @KreditID      = 6,
    @MonatsRate    = 414.64,
    @Zahlungsdatum = '2020-04-01',
    @Meldung       = @Msg OUTPUT;
PRINT @Msg;

EXEC dbo.sp_ZahlungEintragen
    @KreditID      = 6,
    @MonatsRate    = 414.64,
    @Zahlungsdatum = '2020-05-01',
    @Meldung       = @Msg OUTPUT;
PRINT @Msg;

EXEC dbo.sp_ZahlungEintragen
    @KreditID      = 6,
    @MonatsRate    = 414.64,
    @Zahlungsdatum = '2020-06-01',
    @Meldung       = @Msg OUTPUT;
PRINT @Msg;


-- KreditID 7 → Lena Klein (Modernisierungskredit)

PRINT ' KreditID 7: Lena Klein ===';

EXEC dbo.sp_ZahlungEintragen
    @KreditID      = 7,
    @MonatsRate    = 497.83,
    @Zahlungsdatum = '2021-11-01',
    @Meldung       = @Msg OUTPUT;
PRINT @Msg;

EXEC dbo.sp_ZahlungEintragen
    @KreditID      = 7,
    @MonatsRate    = 497.83,
    @Zahlungsdatum = '2021-12-01',
    @Meldung       = @Msg OUTPUT;
PRINT @Msg;

EXEC dbo.sp_ZahlungEintragen
    @KreditID      = 7,
    @MonatsRate    = 497.83,
    @Zahlungsdatum = '2022-01-01',
    @Meldung       = @Msg OUTPUT;
PRINT @Msg;

-- ─────────────────────────────────────────────
-- KreditID 5 → Zimmermann (In Bearbeitung)
-- KreditID 8 → Werner (Unterlagen fehlen)
-- These should FAIL - not disbursed yet
-- ─────────────────────────────────────────────
PRINT '   KreditID 5: Zimmermann - should fail  ';
EXEC dbo.sp_ZahlungEintragen
    @KreditID      = 5,
    @MonatsRate    = 371.64,
    @Zahlungsdatum = '2023-06-01',
    @Meldung       = @Msg OUTPUT;
PRINT @Msg;

PRINT '  KreditID 8: Werner - should fail   ';
EXEC dbo.sp_ZahlungEintragen
    @KreditID      = 8,
    @MonatsRate    = 346.49,
    @Zahlungsdatum = '2023-03-01',
    @Meldung       = @Msg OUTPUT;
PRINT @Msg;
GO
