USE [BankenSystem]
GO

/****** Object:  View [dbo].[vw_ZahlungEintragenInfo]    Script Date: 09.04.2026 12:12:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- Diese Ansicht zeigt, was im usp_zahlungEintragen-Verfahren einzugeben ist.
CREATE   OR ALTER  VIEW [dbo].[vw_ZahlungEintragenInfo]
AS
SELECT
Kredite.KreditID,
Kunden.Vorname + ' ' + Kunden.Nachname As Kunden_Name,
KreditTyp.KreditTyp,
Kredite.NettoBetrag,
Kredite.MonatsRate, -- monatliche EMI-Rate 
Kredite.Auszahlungsdatum As OriginalAuszahlungsdatum,
Kredite.LaufzeitMonate As TotalKrediteLaufzeit,
DATEADD(MONTH,COUNT(Kreditrueckzahlungen.RueckzahlungID)+1,Kredite.Auszahlungsdatum) AS NaechsteZahlungsdatum, ---- Next due date = loan start + (months paid + 1) 
COUNT(Kreditrueckzahlungen.RueckzahlungID) AS Bereits_bezahlt, -- No. of rows for a particular KrediteID as how many times as the customer paid emi.
Kredite.RestSaldo As Aktuelle_Restschuld
FROM dbo.Kunden Kunden
Inner Join dbo.Kunden_Kredite Kunden_Kredite
On Kunden.KundenID=Kunden_Kredite.KundenID  AND Kunden_Kredite.RolleKDID= 1
Inner Join dbo.Kredite Kredite
On Kunden_Kredite.KreditID=Kredite.KreditID
Inner Join dbo.KreditTyp KreditTyp
On KreditTyp.KreditTypID=Kredite.KreditTypID
Inner Join dbo.KreditStatus KreditStatus
On KreditStatus.KreditStatusID=Kredite.KreditStatusID
Left Outer Join dbo.Kreditrueckzahlungen Kreditrueckzahlungen
On Kreditrueckzahlungen.KreditID=Kredite.KreditID
Group by 
Kredite.KreditID,
Kunden.Vorname , Kunden.Nachname,
KreditTyp.KreditTyp,
Kredite.NettoBetrag,
Kredite.MonatsRate,
Kredite.LaufzeitMonate,
Kredite.Auszahlungsdatum,
Kredite.RestSaldo,
KreditStatus.KreditStatus
GO

-- Test
--Select * from [dbo].[vw_ZahlungEintragenInfo]
