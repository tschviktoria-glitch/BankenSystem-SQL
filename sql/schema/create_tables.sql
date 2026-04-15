USE BankenSystem;
GO

-- Tabelle Beruf
CREATE TABLE [dbo].[Beruf](
    [BerufID] INT IDENTITY(1,1) NOT NULL,
    [Beruf] NVARCHAR(50) NOT NULL,
    CONSTRAINT PK_BerufID PRIMARY KEY CLUSTERED (BerufID ASC)
);
GO

-- Tabelle Geschlecht
CREATE TABLE [dbo].[Geschlecht](
    [GeschlechtID] INT IDENTITY(1,1) NOT NULL,
    [Geschlecht] NVARCHAR(50) NOT NULL,
    CONSTRAINT PK_Geschlecht PRIMARY KEY CLUSTERED (GeschlechtID ASC)
);
GO

-- Tabelle Kunden
CREATE TABLE [dbo].[Kunden](
    [KundenID] INT IDENTITY(1,1) NOT NULL,
    [BerufID] INT NOT NULL,
    [GeschlechtID] INT NOT NULL,
    [Vorname] NVARCHAR(50) NOT NULL,
    [Nachname] NVARCHAR(50) NOT NULL,
    [GeburtsDatum] DATE NOT NULL,
    [Email] VARCHAR(100) NOT NULL,
    [Telefon] VARCHAR(15) NOT NULL,
    [Stadt] VARCHAR(60) NOT NULL,
    [Postleitzahl] CHAR(5) NOT NULL,
    [Jahreseinkommen] DECIMAL(14,2) NOT NULL,
    [Bonitaetsscore] SMALLINT NOT NULL,
    [Beitrittsdatum] DATE NOT NULL,

    CONSTRAINT PK_Kunden PRIMARY KEY CLUSTERED (KundenID ASC),

    CONSTRAINT UQ_Kunden_Email UNIQUE NONCLUSTERED (Email ASC),
    CONSTRAINT UQ_Kunden_Telefon UNIQUE NONCLUSTERED (Telefon ASC)
);
GO