CREATE TABLE dbo.Entities
(
	EntityID INT IDENTITY(1,1) NOT NULL,
	Name NVARCHAR(250) NOT NULL,
	
	CONSTRAINT [PK_Entities] PRIMARY KEY (EntityID)
)

CREATE TABLE dbo.Languages
(
	LanguageID INT IDENTITY(1,1) NOT NULL,
	Name NVARCHAR(250) NOT NULL,
	CultureCode NVARCHAR(10) NOT NULL,
	
	CONSTRAINT [PK_Languages] PRIMARY KEY (LanguageID)
)

CREATE TABLE dbo.Picklists
(
	PicklistID INT IDENTITY(1,1) NOT NULL,
	EntityID INT NOT NULL,
	Name NVARCHAR(250) NOT NULL,
	
	CONSTRAINT [PK_Picklists] PRIMARY KEY (PicklistID),
	CONSTRAINT [FK_Picklists_EntityID] FOREIGN KEY (EntityID) REFERENCES dbo.Entities(EntityID)
)

CREATE TABLE dbo.PicklistOptions
(
	PicklistOptionID INT IDENTITY(1,1) NOT NULL,
	PicklistID INT NOT NULL,
	IsDefault BIT NOT NULL CONSTRAINT [DF_PicklistOptions_IsDefault] DEFAULT (0),
	DisplayOrder INT NOT NULL CONSTRAINT [DF_PicklistOptions_DisplayOrder] DEFAULT (0),

	CONSTRAINT [PK_PicklistOptions] PRIMARY KEY (PicklistOptionID),
	CONSTRAINT [FK_PicklistOptions_PicklistID] FOREIGN KEY (PicklistID) REFERENCES dbo.Picklists(PicklistID)
)

CREATE TABLE dbo.PicklistOptions_Locale
(
	PicklistOptionID INT NOT NULL,
	LanguageID INT NOT NULL,
	Value NVARCHAR(50) NULL,
	Text NVARCHAR(250) NOT NULL,

	CONSTRAINT [PK_PicklistOptions_Locale] PRIMARY KEY CLUSTERED (PicklistOptionID, LanguageID),
	CONSTRAINT [FK_PicklistOptions_Locale_PicklistOptionID] FOREIGN KEY (PicklistOptionID) REFERENCES dbo.PicklistOptions(PicklistOptionID),
	CONSTRAINT [FK_PicklistOptions_Locale_LanguageID] FOREIGN KEY (LanguageID) REFERENCES dbo.Languages(LanguageID)
)

INSERT INTO dbo.Languages (Name, CultureCode) VALUES ('English', 'en_GB')
INSERT INTO dbo.Languages (Name, CultureCode) VALUES ('French', 'fr')
INSERT INTO dbo.Languages (Name, CultureCode) VALUES ('German', 'ge')
INSERT INTO dbo.Languages (Name, CultureCode) VALUES ('Spanish', 'es')
INSERT INTO dbo.Languages (Name, CultureCode) VALUES ('Italian', 'it')

INSERT INTO dbo.Entities (Name) VALUES ('Leads')

INSERT INTO dbo.Picklists (EntityID, Name) VALUES (1, 'Lead Source')
INSERT INTO dbo.Picklists (EntityID, Name) VALUES (1, 'Lead Statues')

INSERT INTO dbo.PicklistOptions (PicklistID, IsDefault, DisplayOrder) VALUES (1, 1, 1)
INSERT INTO dbo.PicklistOptions (PicklistID, IsDefault, DisplayOrder) VALUES (1, 0, 2)
INSERT INTO dbo.PicklistOptions (PicklistID, IsDefault, DisplayOrder) VALUES (1, 0, 3)
INSERT INTO dbo.PicklistOptions (PicklistID, IsDefault, DisplayOrder) VALUES (1, 0, 4)
INSERT INTO dbo.PicklistOptions (PicklistID, IsDefault, DisplayOrder) VALUES (1, 0, 5)
INSERT INTO dbo.PicklistOptions (PicklistID, IsDefault, DisplayOrder) VALUES (1, 0, 6)
INSERT INTO dbo.PicklistOptions (PicklistID, IsDefault, DisplayOrder) VALUES (1, 0, 7)
INSERT INTO dbo.PicklistOptions (PicklistID, IsDefault, DisplayOrder) VALUES (1, 0, 8)
INSERT INTO dbo.PicklistOptions (PicklistID, IsDefault, DisplayOrder) VALUES (1, 0, 9)
INSERT INTO dbo.PicklistOptions (PicklistID, IsDefault, DisplayOrder) VALUES (1, 0, 10)
INSERT INTO dbo.PicklistOptions (PicklistID, IsDefault, DisplayOrder) VALUES (1, 1, 1)
INSERT INTO dbo.PicklistOptions (PicklistID, IsDefault, DisplayOrder) VALUES (2, 0, 2)
INSERT INTO dbo.PicklistOptions (PicklistID, IsDefault, DisplayOrder) VALUES (2, 0, 3)
INSERT INTO dbo.PicklistOptions (PicklistID, IsDefault, DisplayOrder) VALUES (2, 0, 4)
INSERT INTO dbo.PicklistOptions (PicklistID, IsDefault, DisplayOrder) VALUES (2, 0, 5)

INSERT INTO dbo.PicklistOptions_Locale (PicklistOptionID, LanguageID, Text) VALUES (1, 1, 'Advertisement')
INSERT INTO dbo.PicklistOptions_Locale (PicklistOptionID, LanguageID, Text) VALUES (2, 1, 'Partner')
INSERT INTO dbo.PicklistOptions_Locale (PicklistOptionID, LanguageID, Text) VALUES (3, 1, 'Word of Mouth')
INSERT INTO dbo.PicklistOptions_Locale (PicklistOptionID, LanguageID, Text) VALUES (4, 1, 'Employee Referral')
INSERT INTO dbo.PicklistOptions_Locale (PicklistOptionID, LanguageID, Text) VALUES (5, 1, 'External Referral')
INSERT INTO dbo.PicklistOptions_Locale (PicklistOptionID, LanguageID, Text) VALUES (6, 1, 'Public Relations')
INSERT INTO dbo.PicklistOptions_Locale (PicklistOptionID, LanguageID, Text) VALUES (7, 1, 'Web')
INSERT INTO dbo.PicklistOptions_Locale (PicklistOptionID, LanguageID, Text) VALUES (8, 1, 'Other')
INSERT INTO dbo.PicklistOptions_Locale (PicklistOptionID, LanguageID, Text) VALUES (9, 1, 'Trade Show')
INSERT INTO dbo.PicklistOptions_Locale (PicklistOptionID, LanguageID, Text) VALUES (10, 1, 'Seminar - Internal')
INSERT INTO dbo.PicklistOptions_Locale (PicklistOptionID, LanguageID, Text) VALUES (11, 1, 'Seminar - Partner')

INSERT INTO dbo.PicklistOptions_Locale (PicklistOptionID, LanguageID, Text) VALUES (1, 2, 'Publicité')
INSERT INTO dbo.PicklistOptions_Locale (PicklistOptionID, LanguageID, Text) VALUES (2, 2, 'Partenaire')
INSERT INTO dbo.PicklistOptions_Locale (PicklistOptionID, LanguageID, Text) VALUES (3, 2, 'Bouche à Oreille')
INSERT INTO dbo.PicklistOptions_Locale (PicklistOptionID, LanguageID, Text) VALUES (4, 2, 'Référence d''un Employé')
INSERT INTO dbo.PicklistOptions_Locale (PicklistOptionID, LanguageID, Text) VALUES (5, 2, 'Renvoi Externe')
INSERT INTO dbo.PicklistOptions_Locale (PicklistOptionID, LanguageID, Text) VALUES (6, 2, 'Public Relations')
INSERT INTO dbo.PicklistOptions_Locale (PicklistOptionID, LanguageID, Text) VALUES (7, 2, 'Web')
INSERT INTO dbo.PicklistOptions_Locale (PicklistOptionID, LanguageID, Text) VALUES (8, 2, 'Autres')
INSERT INTO dbo.PicklistOptions_Locale (PicklistOptionID, LanguageID, Text) VALUES (9, 2, 'Salon')
INSERT INTO dbo.PicklistOptions_Locale (PicklistOptionID, LanguageID, Text) VALUES (10, 2, 'Séminaire - Interne')
INSERT INTO dbo.PicklistOptions_Locale (PicklistOptionID, LanguageID, Text) VALUES (11, 2, 'Séminaire - Partenaire')

INSERT INTO dbo.PicklistOptions_Locale (PicklistOptionID, LanguageID, Text) VALUES (12, 1, 'Contacted')
INSERT INTO dbo.PicklistOptions_Locale (PicklistOptionID, LanguageID, Text) VALUES (13, 1, 'Open')
INSERT INTO dbo.PicklistOptions_Locale (PicklistOptionID, LanguageID, Text) VALUES (14, 1, 'Qualified')
INSERT INTO dbo.PicklistOptions_Locale (PicklistOptionID, LanguageID, Text) VALUES (15, 1, 'Unqualified')

INSERT INTO dbo.PicklistOptions_Locale (PicklistOptionID, LanguageID, Text) VALUES (12, 2, 'Contacté')
INSERT INTO dbo.PicklistOptions_Locale (PicklistOptionID, LanguageID, Text) VALUES (13, 2, 'Ouvrez')
INSERT INTO dbo.PicklistOptions_Locale (PicklistOptionID, LanguageID, Text) VALUES (14, 2, 'Qualifiés')
INSERT INTO dbo.PicklistOptions_Locale (PicklistOptionID, LanguageID, Text) VALUES (15, 2, 'Sans réserve')

SELECT pl.Text 
FROM PicklistOptions_Locale pl
INNER JOIN PicklistOptions po ON po.PicklistOptionID = pl.PicklistOptionID
INNER JOIN Picklists p ON p.PicklistID = po.PicklistID
INNER JOIN Languages l ON l.LanguageID = pl.LanguageID
WHERE l.CultureCode = 'en_GB' AND p.PicklistID = 1 AND p.EntityID = 1