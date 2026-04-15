USE [BankenSystem]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- Erstellt oder aktualisiert die View
CREATE OR ALTER VIEW View_KreditRueckzahlungSummary
AS

SELECT 

-- Kundeninformationen (vollständiger Name)
Kunden.Vorname + N' ' + Kunden.Nachname AS Kunden_Name,
Kredite.KreditID,
Kredite.NettoBetrag AS Kreditlimit,

-- Summe der Tilgungsanteile (zurückgezahlter Hauptbetrag)
SUM(Kreditrueckzahlungen.Tilgungsanteil) AS Summe_Tilgung,

-- Summe der Zinsanteile
SUM(Kreditrueckzahlungen.Zinsanteil) AS Summe_Zinsen,

-- Anzahl der geleisteten Zahlungen
COUNT(Kreditrueckzahlungen.RueckzahlungID) AS Anzahl_Zahlungen,

Kredite.RestSaldo

FROM Kunden

-- Verknüpfung der Kunden mit ihren Krediten über die Zuordnungstabelle
LEFT JOIN Kunden_Kredite 
    ON Kunden.KundenID = Kunden_Kredite.KundenID

-- FULL OUTER JOIN stellt sicher, dass alle Kunden UND alle Kredite angezeigt werden,
-- auch wenn keine direkte Beziehung vorhanden ist
FULL OUTER JOIN Kredite 
    ON Kunden_Kredite.KreditID = Kredite.KreditID

-- Verknüpfung mit Rückzahlungen zur Berechnung von Summen und Anzahl
LEFT JOIN Kreditrueckzahlungen 
    ON Kredite.KreditID = Kreditrueckzahlungen.KreditID

-- Gruppierung für Aggregatfunktionen
GROUP BY 
    Kunden.Vorname, 
    Kunden.Nachname, 
    Kredite.KreditID, 
    Kredite.NettoBetrag,
    Kredite.RestSaldo

-- Filter:
-- zeigt nur Kredite mit positivem Betrag oder vorhandenen Rückzahlungen
HAVING 
    Kredite.NettoBetrag > 0 
    OR SUM(Kreditrueckzahlungen.Tilgungsanteil) IS NOT NULL

GO

-- Test der View (optional)
-- SELECT * FROM [dbo].[View_KreditRueckzahlungSummary]