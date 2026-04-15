USE BankenSystem;
GO

ALTER TABLE dbo.Kunden
ADD CONSTRAINT CHK_Kunden_Einkommen
CHECK (Jahreseinkommen > 0);
GO

ALTER TABLE dbo.Kunden
ADD CONSTRAINT CHK_Kunden_GebDatum
CHECK (GeburtsDatum <= DATEADD(YEAR,-18,GETDATE()));
GO

ALTER TABLE dbo.Kunden
ADD CONSTRAINT CHK_Kunden_Bonitaetsscore
CHECK (Bonitaetsscore BETWEEN 1 AND 100);
GO