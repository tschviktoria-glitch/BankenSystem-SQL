USE [BankenSystem];
GO

-- View: vw_ManagementReport
-- Purpose: Shows total loans given and how much is paid back

CREATE OR ALTER VIEW dbo.vw_ManagementBericht
AS
SELECT
    Kredite.[KreditID],
    Kunden.[Vorname] + N' ' + Kunden.[Nachname]   AS [Kunde],
    KreditTyp.[KreditTyp] AS [Kredittyp],
    KreditStatus.[KreditStatus] AS [Status],
    -- How much was given
    Kredite.[NettoBetrag] AS [Gegeben],
    -- How much is paid back
    Kredite.[NettoBetrag] - Kredite.[RestSaldo] AS [Zurückgezahlt],
    -- How much is still outstanding
    Kredite.[RestSaldo]  AS [Noch Offen],
    -- How many installments paid
    COUNT(r.[RueckzahlungID]) AS [Raten bezahlt],
    -- How many installments remaining
    Kredite.[LaufzeitMonate] - COUNT(r.[RueckzahlungID])AS [Raten offen],
    -- Total interest earned by bank
    SUM(r.[Zinsanteil])  AS [Zinseinnahmen],
    -- Loan dates
    Kredite.[Auszahlungsdatum] AS [Ausgezahlt am],
    Kredite.[Faelligkeitsdatum] AS [Faellig am]
   FROM [dbo].[Kredite] Kredite
  JOIN [dbo].[KreditTyp] KreditTyp  ON Kredite.[KreditTypID] = KreditTyp.[KreditTypID]
  JOIN [dbo].[KreditStatus]  KreditStatus  ON Kredite.[KreditStatusID] = KreditStatus.[KreditStatusID]
  JOIN [dbo].[Kunden_Kredite] Kunden_Kredite  ON Kredite.[KreditID] = Kunden_Kredite.[KreditID] AND Kunden_Kredite.[RolleKDID] = 1                           
  JOIN [dbo].[Kunden] Kunden  ON Kunden_Kredite.[KundenID] = Kunden.[KundenID]
  LEFT JOIN [dbo].[Kreditrueckzahlungen] r  ON Kredite.[KreditID]= r.[KreditID]
  GROUP BY
    Kredite.[KreditID],
    Kunden.[Vorname],
    Kunden.[Nachname],
    KreditTyp.[KreditTyp],
    KreditStatus.[KreditStatus],
    Kredite.[NettoBetrag],
    Kredite.[RestSaldo],
    Kredite.[LaufzeitMonate],
    Kredite.[Auszahlungsdatum],
    Kredite.[Faelligkeitsdatum]
