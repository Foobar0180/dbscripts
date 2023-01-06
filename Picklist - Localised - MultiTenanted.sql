CREATE TABLE dbo.Organisations
(
	OrganisationID INT IDENTITY(1,1) NOT NULL,
	Name NVARCHAR(250) NOT NULL,
	
	CONSTRAINT [PK_Organisations] PRIMARY KEY (OrganisationID)
)

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
	OrganisationID INT NULL,
	PicklistID INT NOT NULL,
	DefaultText NVARCHAR(50) NOT NULL,
	IsDefault BIT NOT NULL CONSTRAINT [DF_PicklistOptions_IsDefault] DEFAULT (0),
	DisplayOrder INT NOT NULL CONSTRAINT [DF_PicklistOptions_DisplayOrder] DEFAULT (0),

	CONSTRAINT [PK_PicklistOptions] PRIMARY KEY (PicklistOptionID),
	CONSTRAINT [FK_PicklistOptions_OrganisationID] FOREIGN KEY (OrganisationID) REFERENCES dbo.Organisations(OrganisationID),
	CONSTRAINT [FK_PicklistOptions_PicklistID] FOREIGN KEY (PicklistID) REFERENCES dbo.Picklists(PicklistID)
)

CREATE TABLE dbo.PicklistOptions_Locale
(
	PicklistOptionID INT NOT NULL,
	LanguageID INT NOT NULL,
	Text NVARCHAR(50) NOT NULL,

	CONSTRAINT [PK_PicklistOptions_Locale] PRIMARY KEY CLUSTERED (PicklistOptionID, LanguageID),
	CONSTRAINT [FK_PicklistOptions_Locale_PicklistOptionID] FOREIGN KEY (PicklistOptionID) REFERENCES dbo.PicklistOptions(PicklistOptionID),
	CONSTRAINT [FK_PicklistOptions_Locale_LanguageID] FOREIGN KEY (LanguageID) REFERENCES dbo.Languages(LanguageID)
)

INSERT INTO dbo.Organisations (Name) VALUES ('Kallidus')
INSERT INTO dbo.Organisations (Name) VALUES ('Intraventure')

INSERT INTO dbo.Languages (Name, CultureCode) VALUES ('English', 'en_GB')
INSERT INTO dbo.Languages (Name, CultureCode) VALUES ('French', 'fr')
INSERT INTO dbo.Languages (Name, CultureCode) VALUES ('German', 'ge')
INSERT INTO dbo.Languages (Name, CultureCode) VALUES ('Spanish', 'es')
INSERT INTO dbo.Languages (Name, CultureCode) VALUES ('Italian', 'it')

INSERT INTO dbo.Entities (Name) VALUES ('Leads')

INSERT INTO dbo.Picklists (EntityID, Name) VALUES (1, 'Lead Source')
INSERT INTO dbo.Picklists (EntityID, Name) VALUES (1, 'Lead Statues')

INSERT INTO dbo.PicklistOptions (PicklistID, DefaultText, IsDefault, DisplayOrder) VALUES (1, 'Advertisement', 1, 1)
INSERT INTO dbo.PicklistOptions (PicklistID, DefaultText, IsDefault, DisplayOrder) VALUES (1, 'Partner', 0, 2)
INSERT INTO dbo.PicklistOptions (PicklistID, DefaultText, IsDefault, DisplayOrder) VALUES (1, 'Word of Mouth', 0, 3)
INSERT INTO dbo.PicklistOptions (PicklistID, DefaultText, IsDefault, DisplayOrder) VALUES (1, 'Employee Referral', 0, 4)
INSERT INTO dbo.PicklistOptions (PicklistID, DefaultText, IsDefault, DisplayOrder) VALUES (1, 'External Referral', 0, 5)
INSERT INTO dbo.PicklistOptions (PicklistID, DefaultText, IsDefault, DisplayOrder) VALUES (1, 'Public Relations', 0, 6)
INSERT INTO dbo.PicklistOptions (PicklistID, DefaultText, IsDefault, DisplayOrder) VALUES (1, 'Web', 0, 7)
INSERT INTO dbo.PicklistOptions (PicklistID, DefaultText, IsDefault, DisplayOrder) VALUES (1, 'Other', 0, 8)
INSERT INTO dbo.PicklistOptions (PicklistID, DefaultText, IsDefault, DisplayOrder) VALUES (1, 'Trade Show', 0, 9)
INSERT INTO dbo.PicklistOptions (PicklistID, DefaultText, IsDefault, DisplayOrder) VALUES (1, 'Seminar - Internal', 0, 10)
INSERT INTO dbo.PicklistOptions (PicklistID, DefaultText, IsDefault, DisplayOrder) VALUES (1, 'Seminar - Partner' ,0, 11)
INSERT INTO dbo.PicklistOptions (OrganisationID, PicklistID, DefaultText, IsDefault, DisplayOrder) VALUES (1, 1, 'Existing Customer' , 0, 12)

INSERT INTO dbo.PicklistOptions (PicklistID, DefaultText, IsDefault, DisplayOrder) VALUES (2, 'Contacted', 1, 1)
INSERT INTO dbo.PicklistOptions (PicklistID, DefaultText, IsDefault, DisplayOrder) VALUES (2, 'Open', 0, 2)
INSERT INTO dbo.PicklistOptions (PicklistID, DefaultText, IsDefault, DisplayOrder) VALUES (2, 'Qualified', 0, 3)
INSERT INTO dbo.PicklistOptions (PicklistID, DefaultText, IsDefault, DisplayOrder) VALUES (2, 'Unqualified', 0, 4)

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
INSERT INTO dbo.PicklistOptions_Locale (PicklistOptionID, LanguageID, Text) VALUES (12, 1, 'Existing Customer')

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
INSERT INTO dbo.PicklistOptions_Locale (PicklistOptionID, LanguageID, Text) VALUES (12, 2, 'Client Existant')

INSERT INTO dbo.PicklistOptions_Locale (PicklistOptionID, LanguageID, Text) VALUES (13, 1, 'Contacted')
INSERT INTO dbo.PicklistOptions_Locale (PicklistOptionID, LanguageID, Text) VALUES (14, 1, 'Open')
INSERT INTO dbo.PicklistOptions_Locale (PicklistOptionID, LanguageID, Text) VALUES (15, 1, 'Qualified')
INSERT INTO dbo.PicklistOptions_Locale (PicklistOptionID, LanguageID, Text) VALUES (16, 1, 'Unqualified')

INSERT INTO dbo.PicklistOptions_Locale (PicklistOptionID, LanguageID, Text) VALUES (13, 2, 'Contacté')
INSERT INTO dbo.PicklistOptions_Locale (PicklistOptionID, LanguageID, Text) VALUES (14, 2, 'Ouvrez')
INSERT INTO dbo.PicklistOptions_Locale (PicklistOptionID, LanguageID, Text) VALUES (15, 2, 'Qualifiés')
INSERT INTO dbo.PicklistOptions_Locale (PicklistOptionID, LanguageID, Text) VALUES (16, 2, 'Sans réserve')




DECLARE @LanguageID INT = 1,
		@PicklistID INT = 1,
		@EntityID INT = 1,
		@OrganisationID INT = 1
SELECT 
	Id = COALESCE(pl.PicklistOptionID, po.PicklistOptionID), 
	Text = COALESCE(pl.Text, po.DefaultText)
FROM 
	PicklistOptions AS po
LEFT OUTER JOIN
	PicklistOptions_Locale AS pl ON pl.PicklistOptionID = po.PicklistOptionID
INNER JOIN
	Picklists AS p ON p.PicklistID = po.PicklistID
WHERE 
	pl.LanguageID = @LanguageID -- 1 = en_GB, 2 = French 
	AND p.PicklistID = @PicklistID -- Lead Source
	AND p.EntityID = @EntityID -- Leads
UNION ALL	
SELECT PicklistOptionID, DefaultText 
FROM PicklistOptions
WHERE PicklistOptionID NOT IN (SELECT PicklistOptionID 
							   FROM PicklistOptions_Locale 
							   WHERE LanguageID = @LanguageID)
ORDER BY Id
