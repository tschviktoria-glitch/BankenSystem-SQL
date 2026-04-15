USE [BankenSystem]
GO

/****** Object:  StoredProcedure [dbo].[sp_ZahlungEintragen]    Script Date: 09.04.2026 14:05:10 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- This procedure Inserts data into Kreditrueckzahlungen table

CREATE     PROCEDURE [dbo].[sp_ZahlungEintragen]
    @KreditID       INT,
    @MonatsRate     DECIMAL(12,2),
    @Zahlungsdatum  NVARCHAR(20) = NULL,
    @Meldung        NVARCHAR(500) OUTPUT
AS BEGIN
    SET NOCOUNT ON;

    -- ── Handle NULL or empty date → use today ────
    DECLARE @ZahlungsdatumDate  DATE;

    IF @Zahlungsdatum IS NULL
    OR LTRIM(RTRIM(@Zahlungsdatum)) = ''
        SET @ZahlungsdatumDate = CAST(GETDATE() AS DATE);
    ELSE
        SET @ZahlungsdatumDate = CAST(@Zahlungsdatum AS DATE);

    -- ── Loan data variables ───────────────────────
    DECLARE @NettoBetrag       DECIMAL(12,2);
    DECLARE @Zinssatz          DECIMAL(5,2);
    DECLARE @LaufzeitMonate    INT;
    DECLARE @MonatsRateDB      DECIMAL(12,2);
    DECLARE @Auszahlungsdatum  DATE;
    DECLARE @KreditEnddatum    DATE;

    -- ── Calculation variables ─────────────────────
    DECLARE @Restschuld        DECIMAL(12,2);
    DECLARE @Zinsanteil        DECIMAL(12,2);
    DECLARE @Tilgungsanteil    DECIMAL(12,2);
    DECLARE @MonatsDatum       DATE;
    DECLARE @LoopMonat         INT;
    DECLARE @ZahlungsstatusID  INT;
    DECLARE @NaechsterMonat    INT;
    DECLARE @NextDueDate       DATE;

    SET @LoopMonat = 1;

    -- ── Step 1: Load loan data ───────────────────
    SELECT
        @NettoBetrag      = [NettoBetrag],
        @Zinssatz         = [Zinssatz],
        @LaufzeitMonate   = [LaufzeitMonate],
        @MonatsRateDB     = [MonatsRate],
        @Auszahlungsdatum = [Auszahlungsdatum],
        @KreditEnddatum   = [Faelligkeitsdatum]
    FROM [dbo].[Kredite]
    WHERE [KreditID] = @KreditID;

    -- ── Validation 1: loan exists? ───────────────
    IF @@ROWCOUNT = 0
    BEGIN
        SET @Meldung = N'FEHLER: KreditID '
                     + CAST(@KreditID AS NVARCHAR)
                     + N' nicht gefunden.';
        RETURN;
    END;

    -- ── Validation 2: payment after loan end? ────
    IF @ZahlungsdatumDate > @KreditEnddatum
    BEGIN
        SET @Meldung =
            N'FEHLER: Zahlungsdatum '
            + CONVERT(NVARCHAR, @ZahlungsdatumDate, 104)
            + N' liegt nach dem Kredit-Enddatum '
            + CONVERT(NVARCHAR, @KreditEnddatum, 104)
            + N'. Zahlung nicht möglich.';
        RETURN;
    END;

    -- ── Validation 3: date already paid? ─────────
    IF EXISTS (
        SELECT 1
        FROM   [dbo].[Kreditrueckzahlungen]
        WHERE  [KreditID]      = @KreditID
        AND    [Zahlungsdatum] = @ZahlungsdatumDate
    )
    BEGIN
        SELECT @NextDueDate = DATEADD(
                                  MONTH,
                                  COUNT(*) + 1,
                                  @Auszahlungsdatum)
        FROM   [dbo].[Kreditrueckzahlungen]
        WHERE  [KreditID] = @KreditID;

        SET @Meldung =
            N'INFO: Zahlung für '
            + CONVERT(NVARCHAR, @ZahlungsdatumDate, 104)
            + N' wurde bereits gebucht. '
            + N'Nächste Rate fällig am: '
            + CONVERT(NVARCHAR, @NextDueDate, 104);
        RETURN;
    END;

    -- ── Step 2: Find next unpaid month ───────────
    -- COUNT existing rows + 1 = next month number
    SELECT @NaechsterMonat = COUNT(*) + 1
    FROM   [dbo].[Kreditrueckzahlungen]
    WHERE  [KreditID] = @KreditID;

    -- ── Validation 4: loan fully paid? ───────────
    IF @NaechsterMonat > @LaufzeitMonate
    BEGIN
        SET @Meldung = N'INFO: Kredit '
                     + CAST(@KreditID AS NVARCHAR)
                     + N' ist bereits vollständig '
                     + N'zurückgezahlt.';
        RETURN;
    END;

    -- ── Step 3: Calculate monthly due date ───────
    SET @MonatsDatum = DATEADD(
                           MONTH,
                           @NaechsterMonat,
                           @Auszahlungsdatum);

    -- ── Step 4: Replay previous months ───────────
    -- to find correct remaining balance
    SET @Restschuld = @NettoBetrag;

    WHILE @LoopMonat < @NaechsterMonat
    BEGIN
        SET @Zinsanteil     = dbo.fn_BerechneZinsanteil(
                                  @Restschuld, @Zinssatz);
        SET @Tilgungsanteil = dbo.fn_BerechneTilgungsanteil(
                                  @MonatsRateDB, @Zinsanteil);
        SET @Restschuld     = @Restschuld - @Tilgungsanteil;
        SET @LoopMonat      = @LoopMonat + 1;
    END;

    -- ── Step 5: Calculate this month split ───────
    SET @Zinsanteil     = dbo.fn_BerechneZinsanteil(
                              @Restschuld, @Zinssatz);
    SET @Tilgungsanteil = @MonatsRate - @Zinsanteil;

    -- ── Step 6: Determine payment status ─────────
    IF @MonatsRate >= @MonatsRateDB
        SET @ZahlungsstatusID = 3;   -- Vollständig bezahlt
    ELSE
        SET @ZahlungsstatusID = 2;   -- Teilweise bezahlt

    -- ── Step 7: Insert ONE payment row ───────────
    INSERT INTO [dbo].[Kreditrueckzahlungen]
        ([KreditID],
         [ZahlungsstatusID],
         [FaelligkeitsdatumImMonat],
         [Zahlungsdatum],
         [RateFaellig],
         [Tilgungsanteil],
         [Zinsanteil])
    VALUES
        (@KreditID,
         @ZahlungsstatusID,
         @MonatsDatum,
         @ZahlungsdatumDate,
         @MonatsRate,
         @Tilgungsanteil,
         @Zinsanteil);

    -- ── Step 8: Return message ────────────────────
    SET @Meldung =
        N'ERFOLG: Rate '    + CAST(@NaechsterMonat AS NVARCHAR)
        + N' für KreditID ' + CAST(@KreditID AS NVARCHAR)
        + N' eingetragen.'
        + N' | Fällig: '    + CONVERT(NVARCHAR,
                                  @MonatsDatum, 104)
        + N' | Gezahlt am: '+ CONVERT(NVARCHAR,
                                  @ZahlungsdatumDate, 104)
        + N' | Erwartet: €' + CAST(@MonatsRateDB AS NVARCHAR)
        + N' | Gezahlt: €'  + CAST(@MonatsRate AS NVARCHAR)
        + N' | Zinsen: €'   + CAST(@Zinsanteil AS NVARCHAR)
        + N' | Tilgung: €'  + CAST(@Tilgungsanteil AS NVARCHAR)
        + N' | Status: '    +
          CASE WHEN @ZahlungsstatusID = 3
               THEN N'Vollständig bezahlt'
               ELSE N'Teilweise bezahlt' END;
END;
GO


