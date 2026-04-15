-- Reset for clean test
--DELETE FROM [dbo].[Kreditrueckzahlungen]
--WHERE [KreditID] = 1;

DELETE FROM Kreditrueckzahlungen;
DBCC CHECKIDENT('Kreditrueckzahlungen', RESEED,0)

select * from [dbo].[Kredite] where KreditTypID=1
select * from [dbo].[Kreditrueckzahlungen] 


UPDATE [dbo].[Kredite]
SET    [RestSaldo]      = [NettoBetrag],
       [KreditStatusID] = 5
WHERE  [KreditID] = 1;

-- Check starting point
SELECT [KreditID], [KreditStatusID],[RestSaldo],Auszahlungsdatum,MonatsRate
FROM [dbo].[Kredite]
WHERE [KreditID] = 1;
-- Expected: RestSaldo = 20000.00, StatusID = 5
-------------------

DECLARE @Msg NVARCHAR(500);
-- Payment 1: trigger should reduce RestSaldo
PRINT '=== Payment 1 ===';
EXEC dbo.usp_ZahlungEintragen
    @KreditID      = 1,
    @MonatsRate    = 455.35 ,
    @Zahlungsdatum = '2021-05-01',
    @Meldung       = @Msg OUTPUT;
PRINT @Msg;

SELECT [RestSaldo] FROM [dbo].[Kredite] WHERE [KreditID] = 1;
-- Expected: 20000.00 - 380.35 = 19619.65


-- Payment 2
DECLARE @Msg NVARCHAR(500);
PRINT '=== Payment 2 ===';
EXEC dbo.usp_ZahlungEintragen
    @KreditID      = 1,
    @MonatsRate    = 455.35,
    @Zahlungsdatum = '2021-06-01',
    @Meldung       = @Msg OUTPUT;
PRINT @Msg;

SELECT [RestSaldo] FROM [dbo].[Kredite] WHERE [KreditID] = 1;
-- Expected: 19619.65 - 381.78 = 19237.87

-- Payment 3: pay MORE than EMI
DECLARE @Msg NVARCHAR(500);
PRINT '=== Payment 3: pays more ===';
EXEC dbo.usp_ZahlungEintragen
    @KreditID      = 1,
    @MonatsRate    = 600.00,
    @Zahlungsdatum = '2021-07-01',
    @Meldung       = @Msg OUTPUT;
PRINT @Msg;

SELECT [RestSaldo] FROM [dbo].[Kredite] WHERE [KreditID] = 1;
-- Expected: 19237.87 - 527.86 = 18710.01

-- Payment 4: pay LESS than EMI
DECLARE @Msg NVARCHAR(500);
PRINT '=== Payment 4: pays less ===';
EXEC dbo.usp_ZahlungEintragen
    @KreditID      = 1,
    @MonatsRate    = 300.00,
    @Zahlungsdatum = '2021-08-05',
    @Meldung       = @Msg OUTPUT;
PRINT @Msg;

SELECT [RestSaldo] FROM [dbo].[Kredite] WHERE [KreditID] = 1;
-- Expected: 18710.01 - 229.86 = 18480.15
GO

---- For pay full scenario we have  [sp_EarlyPrincipalRepayment]

EXEC [dbo].[sp_EarlyPrincipalRepayment]
      @KreditID    =  1,
    @Sonderzahlung =18480.71