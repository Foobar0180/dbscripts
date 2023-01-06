CREATE TABLE dbo.Users
(
	Id INT IDENTITY(1,1) NOT NULL,

	CONSTRAINT [PK_Users] PRIMARY KEY (Id)
)

CREATE TABLE dbo.Contacts
(
	Id INT IDENTITY(1,1) NOT NULL,

	CONSTRAINT [PK_Contacts] PRIMARY KEY (Id)
)

CREATE TABLE dbo.PermissionSetLicenses
(
	Id INT IDENTITY(1,1) NOT NULL,

	CONSTRAINT [PK_PermissionSetLicenses] PRIMARY KEY (Id)
)

CREATE TABLE dbo.PermissionSets
(
	Id INT IDENTITY(1,1) NOT NULL,
	PermissionSetLicenseId INT NOT NULL,

	CONSTRAINT [PK_PermissionSets] PRIMARY KEY (Id),
	CONSTRAINT [FK_PermissionSets_PermissionSetLicenseId] FOREIGN KEY (PermissionSetLicenseId) REFERENCES dbo.Users(Id)
)

CREATE TABLE dbo.UserLicenses
(
	Id INT IDENTITY(1,1) NOT NULL,

	CONSTRAINT [PK_UserLicenses] PRIMARY KEY (Id)
)

CREATE TABLE dbo.Surveys
(
	Id INT IDENTITY(1,1) NOT NULL,
	Name NVARCHAR(50) NOT NULL,
	Description NVARCHAR(MAX) NULL,
	VersionId INT NOT NULL,
	VersionCount INT NOT NULL CONSTRAINT [DF_Surveys_VersionCount] DEFAULT (0),
	OwnerId INT NOT NULL,
	LastViewDate DATETIME NOT NULL,
	CreatedById INT NOT NULL,
	CreatedDate DATETIME NOT NULL,
	LastModifiedById INT NOT NULL,
	LastModifiedDate DATETIME NOT NULL,
	IsDeleted BIT NOT NULL CONSTRAINT [DF_Surveys_IsDeleted] DEFAULT (0),
	SystemModStamp TIMESTAMP NOT NULL,

	CONSTRAINT [PK_Surveys] PRIMARY KEY (Id),
	CONSTRAINT [FK_Surveys_VersionId] FOREIGN KEY (VersionId) REFERENCES dbo.SurveyVersions(Id),
	CONSTRAINT [FK_Surveys_OwnerId] FOREIGN KEY (OwnerId) REFERENCES dbo.Users(Id),
	CONSTRAINT [FK_Surveys_CreatedById] FOREIGN KEY (CreatedById) REFERENCES dbo.Users(Id),
	CONSTRAINT [FK_Surveys_LastModifiedById] FOREIGN KEY (LastModifiedById) REFERENCES dbo.Users(Id)
)

CREATE TABLE dbo.SurveyVersions
(
	Id INT IDENTITY(1,1) NOT NULL,
	SurveyId INT NOT NULL,
	CreatedById INT NOT NULL,
	CreatedDate DATETIME NOT NULL,
	LastModifiedById INT NOT NULL,
	LastModifiedDate DATETIME NOT NULL,
	IsDeleted BIT NOT NULL CONSTRAINT [DF_SurveyVersions] DEFAULT (0),
	SystemModStamp TIMESTAMP NOT NULL,

	CONSTRAINT [PK_SurveyVersions] PRIMARY KEY (Id),
	CONSTRAINT [FK_SurveyVersions_SurveyId] FOREIGN KEY (SurveyId) REFERENCES dbo.Surveys(Id),
	CONSTRAINT [FK_SurveyVersions_CreatedById] FOREIGN KEY (CreatedById) REFERENCES dbo.Users(Id),
	CONSTRAINT [FK_SurveyVersions_LastModifiedById] FOREIGN KEY (LastModifiedById) REFERENCES dbo.Users(Id)
)

CREATE TABLE dbo.SurveyPages
(
	Id INT IDENTITY(1,1) NOT NULL,
	CreatedById INT NOT NULL,
	CreatedDate DATETIME NOT NULL,
	LastModifiedById INT NOT NULL,
	LastModifiedDate DATETIME NOT NULL,
	IsDeleted BIT NOT NULL CONSTRAINT [DF_SurveyPages] DEFAULT (0),
	SystemModStamp TIMESTAMP NOT NULL,

	CONSTRAINT [PK_SurveyPages] PRIMARY KEY (Id),
	CONSTRAINT [FK_SurveyPages_CreatedById] FOREIGN KEY (CreatedById) REFERENCES dbo.Users(Id),
	CONSTRAINT [FK_SurveyPages_LastModifiedById] FOREIGN KEY (LastModifiedById) REFERENCES dbo.Users(Id)
)

CREATE TABLE dbo.SurveyQuestions
(
	Id INT IDENTITY(1,1) NOT NULL,
	CreatedById INT NOT NULL,
	CreatedDate DATETIME NOT NULL,
	LastModifiedById INT NOT NULL,
	LastModifiedDate DATETIME NOT NULL,
	IsDeleted BIT NOT NULL CONSTRAINT [DF_SurveyQuestions] DEFAULT (0),
	SystemModStamp TIMESTAMP NOT NULL,

	CONSTRAINT [PK_SurveyQuestions] PRIMARY KEY (Id),
	CONSTRAINT [FK_SurveyQuestions_CreatedById] FOREIGN KEY (CreatedById) REFERENCES dbo.Users(Id),
	CONSTRAINT [FK_SurveyQuestions_LastModifiedById] FOREIGN KEY (LastModifiedById) REFERENCES dbo.Users(Id)
)

CREATE TABLE dbo.SurveyQuestionChoices
(
	Id INT IDENTITY(1,1) NOT NULL,
	CreatedById INT NOT NULL,
	CreatedDate DATETIME NOT NULL,
	LastModifiedById INT NOT NULL,
	LastModifiedDate DATETIME NOT NULL,
	IsDeleted BIT NOT NULL CONSTRAINT [DF_SurveyQuestionChoices] DEFAULT (0),
	SystemModStamp TIMESTAMP NOT NULL,

	CONSTRAINT [PK_SurveyQuestionChoices] PRIMARY KEY (Id),
	CONSTRAINT [FK_SurveyQuestionChoices_CreatedById] FOREIGN KEY (CreatedById) REFERENCES dbo.Users(Id),
	CONSTRAINT [FK_SurveyQuestionChoices_LastModifiedById] FOREIGN KEY (LastModifiedById) REFERENCES dbo.Users(Id)
)

CREATE TABLE dbo.SurveyResponses
(
	Id INT IDENTITY(1,1) NOT NULL,
	SurveyId INT NOT NULL,
	CreatedById INT NOT NULL,
	CreatedDate DATETIME NOT NULL,
	LastModifiedById INT NOT NULL,
	LastModifiedDate DATETIME NOT NULL,
	IsDeleted BIT NOT NULL CONSTRAINT [DF_SurveyResponses] DEFAULT (0),
	SystemModStamp TIMESTAMP NOT NULL,

	CONSTRAINT [PK_SurveyResponses] PRIMARY KEY (Id),
	CONSTRAINT [FK_SurveyResponses_SurveyId] FOREIGN KEY (SurveyId) REFERENCES dbo.Surveys(Id),
	CONSTRAINT [FK_SurveyResponses_CreatedById] FOREIGN KEY (CreatedById) REFERENCES dbo.Users(Id),
	CONSTRAINT [FK_SurveyResponses_LastModifiedById] FOREIGN KEY (LastModifiedById) REFERENCES dbo.Users(Id)
)

CREATE TABLE dbo.SurveyInvitations
(
	Id INT IDENTITY(1,1) NOT NULL,
	SurveyId INT NOT NULL,
	CreatedById INT NOT NULL,
	CreatedDate DATETIME NOT NULL,
	LastModifiedById INT NOT NULL,
	LastModifiedDate DATETIME NOT NULL,
	IsDeleted BIT NOT NULL CONSTRAINT [DF_SurveyInvitations] DEFAULT (0),
	SystemModStamp TIMESTAMP NOT NULL,

	CONSTRAINT [PK_SurveyInvitations] PRIMARY KEY (Id),
	CONSTRAINT [FK_SurveyInvitations_SurveyId] FOREIGN KEY (SurveyId) REFERENCES dbo.Surveys(Id),
	CONSTRAINT [FK_SurveyInvitations_CreatedById] FOREIGN KEY (CreatedById) REFERENCES dbo.Users(Id),
	CONSTRAINT [FK_SurveyInvitations_LastModifiedById] FOREIGN KEY (LastModifiedById) REFERENCES dbo.Users(Id)
)

CREATE TABLE dbo.SurveyInvitationShares
(
	Id INT IDENTITY(1,1) NOT NULL,
	CreatedById INT NOT NULL,
	CreatedDate DATETIME NOT NULL,
	LastModifiedById INT NOT NULL,
	LastModifiedDate DATETIME NOT NULL,
	IsDeleted BIT NOT NULL CONSTRAINT [DF_SurveyInvitationShares] DEFAULT (0),
	SystemModStamp TIMESTAMP NOT NULL,

	CONSTRAINT [PK_SurveyInvitationShares] PRIMARY KEY (Id),
	CONSTRAINT [FK_SurveyInvitationShares_CreatedById] FOREIGN KEY (CreatedById) REFERENCES dbo.Users(Id),
	CONSTRAINT [FK_SurveyInvitationShares_LastModifiedById] FOREIGN KEY (LastModifiedById) REFERENCES dbo.Users(Id)
)

CREATE TABLE dbo.SurveyShares
(
	Id INT IDENTITY(1,1) NOT NULL,
	CreatedById INT NOT NULL,
	CreatedDate DATETIME NOT NULL,
	LastModifiedById INT NOT NULL,
	LastModifiedDate DATETIME NOT NULL,
	IsDeleted BIT NOT NULL CONSTRAINT [DF_SurveyShares] DEFAULT (0),
	SystemModStamp TIMESTAMP NOT NULL,

	CONSTRAINT [PK_SurveyShares] PRIMARY KEY (Id),
	CONSTRAINT [FK_SurveyShares_CreatedById] FOREIGN KEY (CreatedById) REFERENCES dbo.Users(Id),
	CONSTRAINT [FK_SurveyShares_LastModifiedById] FOREIGN KEY (LastModifiedById) REFERENCES dbo.Users(Id)
)

CREATE TABLE dbo.SurveyFeeds
(
	Id INT IDENTITY(1,1) NOT NULL,
	SurveyId INT NOT NULL,
	CreatedById INT NOT NULL,
	CreatedDate DATETIME NOT NULL,
	LastModifiedById INT NOT NULL,
	LastModifiedDate DATETIME NOT NULL,
	IsDeleted BIT NOT NULL CONSTRAINT [DF_SurveyFeeds] DEFAULT (0),
	SystemModStamp TIMESTAMP NOT NULL,

	CONSTRAINT [PK_SurveyFeeds] PRIMARY KEY (Id),
	CONSTRAINT [FK_SurveyFeeds_SurveyId] FOREIGN KEY (SurveyId) REFERENCES dbo.Surveys(Id),
	CONSTRAINT [FK_SurveyFeeds_CreatedById] FOREIGN KEY (CreatedById) REFERENCES dbo.Users(Id),
	CONSTRAINT [FK_SurveyFeeds_LastModifiedById] FOREIGN KEY (LastModifiedById) REFERENCES dbo.Users(Id)
)

CREATE TABLE dbo.SurveyEmailBrandingAssets
(
	Id INT IDENTITY(1,1) NOT NULL,
	CreatedById INT NOT NULL,
	CreatedDate DATETIME NOT NULL,
	LastModifiedById INT NOT NULL,
	LastModifiedDate DATETIME NOT NULL,
	IsDeleted BIT NOT NULL CONSTRAINT [DF_SurveyEmailBrandingAssets] DEFAULT (0),
	SystemModStamp TIMESTAMP NOT NULL,

	CONSTRAINT [PK_SurveyEmailBrandingAssets] PRIMARY KEY (Id),
	CONSTRAINT [FK_SurveyEmailBrandingAssets_CreatedById] FOREIGN KEY (CreatedById) REFERENCES dbo.Users(Id),
	CONSTRAINT [FK_SurveyEmailBrandingAssets_LastModifiedById] FOREIGN KEY (LastModifiedById) REFERENCES dbo.Users(Id)
)

CREATE TABLE dbo.SurveyEmailBrandings
(
	Id INT IDENTITY(1,1) NOT NULL,
	CreatedById INT NOT NULL,
	CreatedDate DATETIME NOT NULL,
	LastModifiedById INT NOT NULL,
	LastModifiedDate DATETIME NOT NULL,
	IsDeleted BIT NOT NULL CONSTRAINT [DF_SurveyEmailBrandings] DEFAULT (0),
	SystemModStamp TIMESTAMP NOT NULL,

	CONSTRAINT [PK_SurveyEmailBrandings] PRIMARY KEY (Id),
	CONSTRAINT [FK_SurveyEmailBrandings_CreatedById] FOREIGN KEY (CreatedById) REFERENCES dbo.Users(Id),
	CONSTRAINT [FK_SurveyEmailBrandings_LastModifiedById] FOREIGN KEY (LastModifiedById) REFERENCES dbo.Users(Id)
) 