USE BankenSystem;
GO

CREATE NONCLUSTERED INDEX IX_Kunden_Nachname
ON dbo.Kunden(Nachname ASC);
GO

CREATE NONCLUSTERED INDEX IX_Kunden_Vorname
ON dbo.Kunden(Vorname ASC);
GO