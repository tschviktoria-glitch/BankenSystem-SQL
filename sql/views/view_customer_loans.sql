USE [BankenSystem]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- Erstellt oder aktualisiert die View zur Anzeige von Kunden und deren Krediten
CREATE OR ALTER VIEW [dbo].[vw_Kunden_Kredite] AS

-- Hauptabfrage
SELECT 
    -- Verkettet Vorname und Nachname zu einem vollständigen Namen
    Kunden.Vorname + N' ' + Kunden.Nachname AS Kunden_Name, 

    -- Typ des Kredits (z.B. Konsumkredit, Immobilienkredit)
    dbo.KreditTyp.KreditTyp, 

    -- Rolle des Kunden im Kredit (z.B. Kreditnehmer, Bürge)
    dbo.RolleKD.RolleKD, 

    -- Beruf des Kunden
    dbo.Beruf.Beruf, 

    -- Nettobetrag des Kredits
    dbo.Kredite.NettoBetrag, 

    -- Fälligkeitsdatum des Kredits
    dbo.Kredite.Faelligkeitsdatum, 

    -- Verbleibender Restsaldo
    dbo.Kredite.RestSaldo

-- Verknüpfung der Tabelle Beruf mit Kunden (1:n Beziehung)
FROM dbo.Beruf 
INNER JOIN dbo.Kunden 
    ON dbo.Beruf.BerufID = dbo.Kunden.BerufID 

-- Verknüpfung der Kredite über die Zwischentabelle (Many-to-Many Beziehung)
INNER JOIN dbo.Kredite 
INNER JOIN dbo.Kunden_Kredite 
    ON dbo.Kredite.KreditID = dbo.Kunden_Kredite.KreditID 
    ON dbo.Kunden.KundenID = dbo.Kunden_Kredite.KundenID 

-- Verknüpfung des Kredittyps
INNER JOIN dbo.KreditTyp 
    ON dbo.Kredite.KreditTypID = dbo.KreditTyp.KreditTypID 

-- Verknüpfung der Kundenrolle
INNER JOIN dbo.RolleKD 
    ON dbo.Kunden_Kredite.RolleKDID = dbo.RolleKD.RolleKDID

GO

-- Test der View (optional ausführen)
-- SELECT * FROM [dbo].[vw_Kunden_Kredite]