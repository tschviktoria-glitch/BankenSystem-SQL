USE [BankenSystem]
GO

/****** Object:  UserDefinedFunction [dbo].[fn_ManagementBericht]    Script Date: 10.04.2026 10:33:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- This function returns all loans for a given customer
-- Gibt alle Kredite eines bestimmten Kunden zurück
CREATE     FUNCTION [dbo].[fn_ManagementBericht]
(
    @kundenID INT
)
RETURNS TABLE
AS
RETURN
(
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
      WHERE Kunden.KundenID=@KundenID
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

);
GO


