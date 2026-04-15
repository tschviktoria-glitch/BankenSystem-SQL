USE BankenSystem;
GO

ALTER TABLE dbo.Kunden
ADD CONSTRAINT FK_Kunden_BerufID
FOREIGN KEY (BerufID)
REFERENCES dbo.Beruf(BerufID);
GO

ALTER TABLE dbo.Kunden
ADD CONSTRAINT FK_Kunden_Geschlecht
FOREIGN KEY (GeschlechtID)
REFERENCES dbo.Geschlecht(GeschlechtID);
GO