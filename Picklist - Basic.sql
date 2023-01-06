CREATE TABLE dbo.Entities
(
	EntityID INT IDENTITY(1,1) NOT NULL,
	Name NVARCHAR(250) NOT NULL
	
	CONSTRAINT [PK_Entities] PRIMARY KEY (EntityID)
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
	PicklistID INT NOT NULL,
	Text NVARCHAR(250) NOT NULL,
	IsDefault BIT NOT NULL CONSTRAINT [DF_PicklistOptions_IsDefault] DEFAULT (0),
	DisplayOrder INT NOT NULL CONSTRAINT [DF_PicklistOptions_DisplayOrder] DEFAULT (0),
	
	CONSTRAINT [PK_PicklistOptions] PRIMARY KEY CLUSTERED (PicklistID, Text),
	CONSTRAINT [FK_PicklistOptions_PicklistID] FOREIGN KEY (PicklistID) REFERENCES dbo.Picklists(PicklistID)
)

SELECT 
	Text 
FROM 
	dbo.PicklistOptions o
INNER JOIN 
	Picklists p ON p.PicklistID = o.PicklistID
WHERE 
	p.PicklistID = 4