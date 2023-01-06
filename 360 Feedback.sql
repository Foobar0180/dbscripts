-- Schema Versions --
CREATE TABLE dbo.SchemaVersions
(	
	Major INT NOT NULL,	
	Minor INT NOT NULL,		
	Patch INT NOT NULL,	
	Feature NVARCHAR(250) NOT NULL,
    InstalledAt DATETIME NOT NULL,
	IsCurrentVersion BIT NOT NULL CONSTRAINT [DF_SchemaVersions_IsCurrentVersion] DEFAULT (0),	
	
	CONSTRAINT [PK_SchemaVersions] PRIMARY KEY CLUSTERED (Major, Minor, Patch)
)

-- Application Settings --
CREATE TABLE dbo.AppSettings
(	
	Environment NVARCHAR(250) NOT NULL,
	KeyName NVARCHAR(250) NOT NULL,
	Value NVARCHAR(250) NOT NULL,
	Description NVARCHAR(MAX) NULL,
	LastModifiedAt DATETIME NOT NULL,
					
	CONSTRAINT [PK_AppSettings] PRIMARY KEY CLUSTERED (Environment, KeyName, Value)
)


-- Users --
CREATE TABLE dbo.Users
(	
	UserId INT IDENTITY(1,1) NOT NULL,
	Username NVARCHAR(250) NOT NULL,
	Password NVARCHAR(250) NOT NULL,
	PasswordFormat INT NOT NULL,
	PasswordSalt NVARCHAR(250) NOT NULL,
	PasswordExpiresAt DATETIME NULL,
	ResetPasswordSentAt DATETIME NULL,
	PasswordQuestion NVARCHAR(250) NULL,
	PasswordAnswer NVARCHAR(250) NULL,
	IsApproved BIT NOT NULL CONSTRAINT [DF_Users_IsApproved] DEFAULT (0), 
	IsLockedOut BIT NOT NULL CONSTRAINT [DF_Users_IsLockedOut] DEFAULT (0),
	LastLoginAt DATETIME NULL,
	LastActivityAt DATETIME NOT NULL,
	LastPasswordChangedAt DATETIME NOT NULL,
	LastLockoutAt DATETIME NULL,
	FailedPasswordAttemptCount INT NOT NULL CONSTRAINT [DF_Users_FailedPasswordAttemptCount] DEFAULT (0),
	FailedPasswordAttemptWindowStart DATETIME NULL,
	FailedPasswordAnswerAttemptCount INT NOT NULL CONSTRAINT [DF_Users_FailedPasswordAnswerAttemptCount] DEFAULT (0),
	FailedPasswordAnswerAttemptWindowStart DATETIME NULL,
	CreatedAt DATETIME NOT NULL,
	DeletedAt DATETIME NULL,
	DeletedById INT NULL,
	DeletedState INT NOT NULL CONSTRAINT [DF_Users_DeletedState] DEFAULT (0),
	IsDeleted AS (CASE WHEN DeletedState > 0 THEN 1 ELSE 0 END),
					
	CONSTRAINT [PK_Users] PRIMARY KEY (UserId) 
)

-- Roles --
CREATE TABLE dbo.Roles
(	
	RoleId INT IDENTITY(1,1) NOT NULL,
	Name NVARCHAR(250) NOT NULL,	
					
	CONSTRAINT [PK_Roles] PRIMARY KEY (RoleId)
)

-- Users In Roles --
CREATE TABLE dbo.UsersInRoles
(	
	UserId INT NOT NULL,
	RoleId INT NOT NULL,
					
	CONSTRAINT [PK_UsersInRoles] PRIMARY KEY CLUSTERED (UserId, RoleId),
	CONSTRAINT [FK_UsersInRoles_UserId] FOREIGN KEY (UserId) REFERENCES dbo.Users(UserId),
	CONSTRAINT [FK_UsersInRoles_RoleId] FOREIGN KEY (RoleId) REFERENCES dbo.Roles(RoleId)
)
	
-- Countries --
CREATE TABLE dbo.Countries
(	
	CountryId INT IDENTITY(1,1) NOT NULL,
	Name NVARCHAR(250) NOT NULL,
	DisplayOrder INT NOT NULL CONSTRAINT [DF_Countries_DisplayOrder] DEFAULT (0),
	
	CONSTRAINT [PK_Countries] PRIMARY KEY (CountryId)
)

-- Accounts --
CREATE TABLE dbo.Accounts
(
	AccountId INT IDENTITY(1,1) NOT NULL,
	Name NVARCHAR(250) NOT NULL,
	AccountNumber NVARCHAR(250) NULL,
	AddressLine1 NVARCHAR(250) NULL,
	AddressLine2 NVARCHAR(250) NULL,
	CityTown NVARCHAR(250) NULL,
	StateCounty NVARCHAR(250) NULL,
	ZipPostcode NVARCHAR(250) NULL,
	CountryId INT NULL,
	Phone NVARCHAR(250) NULL,
	Fax NVARCHAR(250) NULL,
	Website NVARCHAR(250) NULL,		
	Theme NVARCHAR(250) NULL,
	DefaultCulture NVARCHAR(50) NOT NULL,
	DomainPrefix NVARCHAR(250) NULL,
	Package INT NOT NULL,
	SingleSignEnabled BIT NOT NULL CONSTRAINT [DF_Accounts_SingleSignSingleSignEnabled] DEFAULT (0),
	ExpiresAt DATETIME NULL,
	IsSuspended BIT NOT NULL CONSTRAINT [DF_Accounts_IsSuspended] DEFAULT (0),
	SuspendedReason NVARCHAR(MAX) NULL,
	CreatedAt DATETIME NOT NULL,
	CreatedById INT NOT NULL,		
	ModifiedAt DATETIME NOT NULL,
	ModifiedById INT NOT NULL,
	DeletedAt DATETIME NULL,
	DeletedById INT NULL,
	DeletedState INT NOT NULL CONSTRAINT [DF_Accounts_DeletedState] DEFAULT (0),
	IsDeleted AS (CASE WHEN DeletedState > 0 THEN 1 ELSE 0 END),
	
	CONSTRAINT [PK_Accounts] PRIMARY KEY (AccountId),
	CONSTRAINT [FK_Accounts_CreatedById] FOREIGN KEY (CreatedById) REFERENCES dbo.Users(UserId),
	CONSTRAINT [FK_Accounts_ModifiedById] FOREIGN KEY (ModifiedById) REFERENCES dbo.Users(UserId),
	CONSTRAINT [FK_Accounts_DeletedById] FOREIGN KEY (DeletedById) REFERENCES dbo.Users(UserId)
)

-- Account Shares --
CREATE TABLE dbo.AccountShares
(	
	AccountId INT NOT NULL,
	UserId INT NOT NULL,
	LastActivityAt DATETIME NULL,
	IsHidden BIT NOT NULL CONSTRAINT [DF_AccountShare_IsHidden] DEFAULT (0),
	SharedAt DATETIME NOT NULL,
	SharedById INT NOT NULL,
					
	CONSTRAINT [PK_AccountShares] PRIMARY KEY CLUSTERED (AccountId, UserId),
	CONSTRAINT [FK_AccountShares_AccountId] FOREIGN KEY (AccountId) REFERENCES dbo.Accounts(AccountId),
	CONSTRAINT [FK_AccountShares_UserId] FOREIGN KEY (UserId) REFERENCES dbo.Users(UserId),
	CONSTRAINT [FK_AccountShares_SharedById] FOREIGN KEY (SharedById) REFERENCES dbo.Users(UserId)
)

-- Genders --
CREATE TABLE dbo.Genders
(	
	GenderId INT IDENTITY(1,1) NOT NULL,
	Name NVARCHAR(250) NOT NULL,
					
	CONSTRAINT [PK_Genders] PRIMARY KEY (GenderId)
)

-- Functions --
CREATE TABLE dbo.Functions
(	
	FunctionId INT IDENTITY(1,1) NOT NULL,
	AccountId INT NOT NULL,
	Name NVARCHAR(250) NOT NULL,
					
	CONSTRAINT [PK_Functions] PRIMARY KEY (FunctionId),
	CONSTRAINT [FK_Functions_AccountId] FOREIGN KEY (AccountId) REFERENCES dbo.Accounts(AccountId)
)

-- Locations --
CREATE TABLE dbo.Locations
(	
	LocationId INT IDENTITY(1,1) NOT NULL,
	AccountId INT NOT NULL,
	Name NVARCHAR(250) NOT NULL,
	AddressLine1 NVARCHAR(250) NULL,
	AddressLine2 NVARCHAR(250) NULL,
	CityTown NVARCHAR(250) NULL,
	StateCounty NVARCHAR(250) NULL,
	ZipPostcode NVARCHAR(250) NULL,
	CountryId INT NULL,
	Longitude DECIMAL(10,6) NULL,
	Latitude DECIMAL(10,6) NULL,
	IsGeocoded AS CASE WHEN Longitude IS NOT NULL AND Latitude IS NOT NULL THEN (1) ELSE (0) END,
					
	CONSTRAINT [PK_Locations] PRIMARY KEY (LocationId),
	CONSTRAINT [FK_Locations_AccountId] FOREIGN KEY (AccountId) REFERENCES dbo.Accounts(AccountId),
	CONSTRAINT [FK_Locations_CountryId] FOREIGN KEY (CountryId) REFERENCES dbo.Countries(CountryId),
	CONSTRAINT [CK_Locations_IsGeocoded] CHECK (Longitude IS NULL AND Latitude IS NULL OR Longitude IS NOT NULL AND Latitude IS NOT NULL)
)

-- Organisations --
CREATE TABLE dbo.Organisations
(	
	OrganisationId INT IDENTITY(1,1) NOT NULL,
	AccountId INT NOT NULL,
	Name NVARCHAR(250) NOT NULL,
					
	CONSTRAINT [PK_Organisations] PRIMARY KEY (OrganisationId),
	CONSTRAINT [FK_Organisations_AccountId] FOREIGN KEY (AccountId) REFERENCES dbo.Accounts(AccountId)
)

-- People --
CREATE TABLE dbo.People
(
	PersonId INT IDENTITY(1,1) NOT NULL,
	AccountId INT NOT NULL,
	UserId INT NOT NULL,
	FirstName NVARCHAR(250) NOT NULL,
	LastName NVARCHAR(250) NOT NULL,
	FullName AS (LTRIM(RTRIM(FirstName) + ' ' + LastName)),
	Initials NVARCHAR(10) NULL,
	GenderId INT NULL,
	DateOfBirth DATETIME NULL,
	HiredAt DATETIME NULL,
	JoinedAt DATETIME NULL,
	JobTitle NVARCHAR(250) NULL,
	Email NVARCHAR(250) NOT NULL,
	ManagerId INT NULL,
	FunctionId INT NULL,
	LocationId INT NULL,
	OrganisationId INT NULL,
	IsExternal BIT NOT NULL CONSTRAINT [DF_People_IsExternal] DEFAULT (0),
	IsFeedbackOnly BIT NOT NULL CONSTRAINT [DF_People_IsFeedbackOnly] DEFAULT (0),
	CreatedAt DATETIME NOT NULL,
	CreatedById INT NOT NULL,		
	ModifiedAt DATETIME NOT NULL,
	ModifiedById INT NOT NULL,
	DeletedAt DATETIME NULL,
	DeletedById INT NULL,
	DeletedState INT NOT NULL CONSTRAINT [DF_People_DeletedState] DEFAULT (0),	
	IsDeleted AS (CASE WHEN DeletedState > 0 THEN 1 ELSE 0 END),
	
	CONSTRAINT [PK_People] PRIMARY KEY (PersonId),
	CONSTRAINT [FK_People_AccountId] FOREIGN KEY (AccountId) REFERENCES dbo.Accounts(AccountId),
	CONSTRAINT [FK_People_UserId] FOREIGN KEY (UserId) REFERENCES dbo.Users(UserId),
	CONSTRAINT [FK_People_GenderId] FOREIGN KEY (GenderId) REFERENCES dbo.Genders(GenderId),
	CONSTRAINT [FK_People_FunctionId] FOREIGN KEY (FunctionId) REFERENCES dbo.Functions(FunctionId),
	CONSTRAINT [FK_People_LocationId] FOREIGN KEY (LocationId) REFERENCES dbo.Locations(LocationId),
	CONSTRAINT [FK_People_OrganisationId] FOREIGN KEY (OrganisationId) REFERENCES dbo.Organisations(OrganisationId),
	CONSTRAINT [FK_People_CreatedById] FOREIGN KEY (CreatedById) REFERENCES dbo.Users(UserId),
	CONSTRAINT [FK_People_ModifiedById] FOREIGN KEY (ModifiedById) REFERENCES dbo.Users(UserId),
	CONSTRAINT [FK_People_DeletedById] FOREIGN KEY (DeletedById) REFERENCES dbo.Users(UserId),
	CONSTRAINT [CK_People_DateOfBirth] CHECK (DateOfBirth < GETDATE()),
	CONSTRAINT [CK_People_JoinedAt_HiredAt] CHECK (JoinedAt < HiredAt),	
	CONSTRAINT [CK_People_ManagerId_PersonId] CHECK (ManagerId <> PersonId),
	CONSTRAINT [UQ_People_Email] UNIQUE (Email)
)

-------------------------------------------------------
-- Surveys
-------------------------------------------------------

-- Scalars --
CREATE TABLE dbo.Scalars
(		
	ScalarId INT IDENTITY(1,1) NOT NULL,
	AccountId INT NULL,
	Name NVARCHAR(MAX) NOT NULL,
	Mode INT NOT NULL,		
	MinValue INT NOT NULL,		
	MaxValue INT NOT NULL,		
	
	CONSTRAINT [PK_Scalars] PRIMARY KEY (ScalarId),
	CONSTRAINT [FK_Scalars_AccountId] FOREIGN KEY (AccountId) REFERENCES dbo.Accounts(AccountId),
	CONSTRAINT [CK_Scalars_MinValue_MaxValue] CHECK (MinValue <= MaxValue)
)

-- Scalar Values --
CREATE TABLE dbo.ScalarValues
(		
	ScalarValueId INT IDENTITY(1,1) NOT NULL,
	ScalarId INT NOT NULL,
	Text NVARCHAR(250) NOT NULL,
	Value INT NOT NULL,
	
	CONSTRAINT [PK_ScalarValues] PRIMARY KEY (ScalarValueId),
	CONSTRAINT [FK_ScalarValues_ScalarId] FOREIGN KEY (ScalarId) REFERENCES dbo.Scalars(ScalarId)
)

-- Surveys --
CREATE TABLE dbo.Surveys
(	
	SurveyId INT IDENTITY(1,1) NOT NULL,
	AccountId INT NOT NULL,
	Name NVARCHAR(250) NOT NULL,
	DisplayName NVARCHAR(250) NOT NULL,
	ShowProgressBar BIT NOT NULL CONSTRAINT [DF_Surveys_ShowProgressBar] DEFAULT (1),
	ShowSectionNumbers BIT NOT NULL CONSTRAINT [DF_Surveys_ShowSectionNumbers] DEFAULT (1),
	ShowQuestionNumbers BIT NOT NULL CONSTRAINT [DF_Surveys_ShowQuestionNumbers] DEFAULT (1),
	RandomiseSections BIT NOT NULL CONSTRAINT [DF_Surveys_RandomiseSections] DEFAULT (0),	
	RandomiseQuestionGroups BIT NOT NULL CONSTRAINT [DF_Surveys_RandomiseQuestionGroups] DEFAULT (0),
	RandomiseQuestions BIT NOT NULL CONSTRAINT [DF_Surveys_RandomiseQuestions] DEFAULT (0),
	PermaLinkUrl NVARCHAR(1000) NOT NULL,	
	ScalarId INT NULL,
	ImportanceScalarId INT NULL,	
	IsSystem BIT NOT NULL CONSTRAINT [DF_Surveys_IsSystem] DEFAULT (0),		
	CreatedAt DATETIME NOT NULL,
	CreatedById INT NOT NULL,		
	ModifiedAt DATETIME NOT NULL,
	ModifiedById INT NOT NULL,
	DeletedAt DATETIME NULL,
	DeletedById INT NULL,
	DeletedState INT NOT NULL CONSTRAINT [DF_Surveys_DeletedState] DEFAULT (0),
	IsDeleted AS (CASE WHEN DeletedState > 0 THEN 1 ELSE 0 END),
					
	CONSTRAINT [PK_Surveys] PRIMARY KEY (SurveyId),
	CONSTRAINT [FK_Surveys_AccountId] FOREIGN KEY (AccountId) REFERENCES dbo.Accounts(AccountId),
	CONSTRAINT [FK_Surveys_ScalarId] FOREIGN KEY (ScalarId) REFERENCES dbo.Scalars(ScalarId),	
	CONSTRAINT [FK_Surveys_ImportanceScalarId] FOREIGN KEY (ImportanceScalarId) REFERENCES dbo.Scalars(ScalarId),	
	CONSTRAINT [FK_Surveys_CreatedById] FOREIGN KEY (CreatedById) REFERENCES dbo.Users(UserId),
	CONSTRAINT [FK_Surveys_ModifiedById] FOREIGN KEY (ModifiedById) REFERENCES dbo.Users(UserId),
	CONSTRAINT [FK_Surveys_DeletedById] FOREIGN KEY (DeletedById) REFERENCES dbo.Users(UserId)
)	

-- Sections --	
CREATE TABLE dbo.Sections
(
	SectionId INT IDENTITY(1,1) NOT NULL,
	SurveyId INT NOT NULL,
	Name NVARCHAR(250) NOT NULL,
	Description NVARCHAR(MAX) NULL,
	DisplayOrder INT NOT NULL,
	
	CONSTRAINT [PK_Sections] PRIMARY KEY (SectionId),
	CONSTRAINT [FK_Sections_SurveyId] FOREIGN KEY (SurveyId) REFERENCES dbo.Surveys(SurveyId)
)
	
-- Question Groups --
CREATE TABLE dbo.QuestionGroups
(
	QuestionGroupId INT IDENTITY(1,1) NOT NULL,
	SectionId INT NOT NULL,
	Name NVARCHAR(250) NOT NULL,
	Description NVARCHAR(MAX) NULL,
	DisplayOrder INT NOT NULL,	
	
	CONSTRAINT [PK_QuestionGroups] PRIMARY KEY (QuestionGroupId),
	CONSTRAINT [FK_QuestionGroups_SectionId] FOREIGN KEY (SectionId) REFERENCES dbo.Sections(SectionId)
)
		
-- Questions --
CREATE TABLE dbo.Questions
(
	QuestionId INT IDENTITY(1,1) NOT NULL,
	QuestionGroupId INT NOT NULL,
	Text NVARCHAR(MAX) NOT NULL,
	HelpText NVARCHAR(MAX) NULL,
	DisplayOrder INT NOT NULL CONSTRAINT [DF_Questions_DisplayOrder] DEFAULT (0),
	
	CONSTRAINT [PK_Questions] PRIMARY KEY (QuestionId),
	CONSTRAINT [FK_Questions_QuestionGroupId] FOREIGN KEY (QuestionGroupId) REFERENCES dbo.QuestionGroups(QuestionGroupId)
)

-- Projects -- 	
CREATE TABLE dbo.Rounds
(	
	RoundId INT IDENTITY(1,1) NOT NULL,
	AccountId INT NOT NULL,
	Name NVARCHAR(250) NOT NULL,
	Description NVARCHAR(MAX) NULL,
	StartAt DATETIME NULL,
	EndAt DATETIME NULL,
	StartMessage NVARCHAR(MAX) NULL,
	CompleteMessage NVARCHAR(MAX) NULL,
	AllowEditResponses BIT NOT NULL CONSTRAINT [DF_Rounds_AllowEditResponses] DEFAULT (1),
	AllowAnonymous BIT NOT NULL CONSTRAINT [DF_Rounds_AllowAnonymous] DEFAULT (0),
	RedirectOnComplete BIT NOT NULL CONSTRAINT [DF_Rounds_RedirectOnComplete] DEFAULT (0),
	RedirectUrl NVARCHAR(250) NULL,	
	EmailDisplayName NVARCHAR(250) NOT NULL,
	EmailAddress NVARCHAR(250) NOT NULL,
	ManagerToAgreeRespondents BIT NOT NULL CONSTRAINT [DF_Rounds_ManagerToAgreeRespondents] DEFAULT (0),
	SurveyId INT NOT NULL,
	PreSurveyId INT NULL,
	PostSurveyId INT NULL,
	RegistrationCount INT NOT NULL CONSTRAINT [DF_Rounds_RegistrationCount] DEFAULT (0),
	RespondentCount INT NOT NULL CONSTRAINT [DF_Rounds_RespondentCount] DEFAULT (0),
	CompletedCount INT NOT NULL CONSTRAINT [DF_Rounds_CompletedCount] DEFAULT (0),
	CreatedAt DATETIME NOT NULL,
	CreatedById INT NOT NULL,		
	ModifiedAt DATETIME NOT NULL,
	ModifiedById INT NOT NULL,
	DeletedAt DATETIME NULL,
	DeletedById INT NULL,
	DeletedState INT NOT NULL CONSTRAINT [DF_Rounds_DeletedState] DEFAULT (0),
	IsDeleted AS (CASE WHEN DeletedState > 0 THEN 1 ELSE 0 END),
					
	CONSTRAINT [PK_Rounds] PRIMARY KEY (RoundId),
	CONSTRAINT [FK_Rounds_AccountId] FOREIGN KEY (AccountId) REFERENCES dbo.Accounts(AccountId),
	CONSTRAINT [FK_Rounds_SurveyId] FOREIGN KEY (SurveyId) REFERENCES dbo.Surveys(SurveyId),
	CONSTRAINT [FK_Rounds_PreSurveyId] FOREIGN KEY (PreSurveyId) REFERENCES dbo.Surveys(SurveyId),
	CONSTRAINT [FK_Rounds_PostSurveyId] FOREIGN KEY (PostSurveyId) REFERENCES dbo.Surveys(SurveyId),
	CONSTRAINT [FK_Rounds_CreatedById] FOREIGN KEY (CreatedById) REFERENCES dbo.Users(UserId),
	CONSTRAINT [FK_Rounds_ModifiedById] FOREIGN KEY (ModifiedById) REFERENCES dbo.Users(UserId),
	CONSTRAINT [FK_Rounds_DeletedById] FOREIGN KEY (DeletedById) REFERENCES dbo.Users(UserId)
)

-- Relationships --
CREATE TABLE dbo.Relationships
(
	RelationshipId INT IDENTITY(1,1) NOT NULL,
	RoundId INT NOT NULL,
	Name NVARCHAR(250) NOT NULL,
	IsCombining BIT NOT NULL CONSTRAINT [DF_Relationships_IsCombining] DEFAULT (0),
	CombineCount INT NOT NULL,
	MinCount INT NOT NULL,
	MaxCount INT NOT NULL,
	IsSelf BIT NOT NULL CONSTRAINT [DF_Relationships_IsSelf] DEFAULT (0),
	DisplayOrder INT NOT NULL,
	
	CONSTRAINT [PK_Relationships] PRIMARY KEY (RelationshipId),
	CONSTRAINT [FK_RelationshipId_RoundId] FOREIGN KEY (RoundId) REFERENCES dbo.Rounds(RoundId)
)

-- Round Emails --
CREATE TABLE dbo.RoundEmails
(
	RoundId INT NOT NULL,
	RelationshipId INT NOT NULL,
	Subject NVARCHAR(250) NOT NULL,
	Body NVARCHAR(MAX) NOT NULL,
	IsReminder BIT NOT NULL CONSTRAINT [DF_RoundEmails_IsReminder] DEFAULT (0),
	IsAccepted BIT NOT NULL CONSTRAINT [DF_RoundEmails_IsAccepted] DEFAULT (0),
	AcceptedAt DATETIME NULL,
	AcceptedById INT NULL,
	
	CONSTRAINT [PK_RoundEmails] PRIMARY KEY CLUSTERED (RoundId, RelationshipId),
	CONSTRAINT [FK_RoundEmails_RoundId] FOREIGN KEY (RoundId) REFERENCES dbo.Rounds(RoundId),
	CONSTRAINT [FK_RoundEmails_RelationshipId] FOREIGN KEY (RelationshipId) REFERENCES dbo.Relationships(RelationshipId),
	CONSTRAINT [FK_RoundEmails_AcceptedById] FOREIGN KEY (AcceptedById) REFERENCES dbo.Users(UserId)
)
	
-- Registrations --
CREATE TABLE dbo.Registrations
(
	RegistrationId INT IDENTITY(1,1) NOT NULL,
	RoundId INT NOT NULL,
	PersonId INT NOT NULL,
	Deadline DATETIME NULL,
	IsDeadlineEnforced BIT NOT NULL CONSTRAINT [DF_Registrations_IsDeadlineEnforced] DEFAULT (0),
	CanRegisterRespondents BIT NOT NULL CONSTRAINT [DF_Registrations_CanRegisterRespondents] DEFAULT (0),
	CanDownloadReport BIT NOT NULL CONSTRAINT [DF_Registrations_CanDownloadReport] DEFAULT (0),
	RespondentsAgreedAt DATETIME NULL,
	RespondentsAgreeById INT NULL,
	InitialLoginAt DATETIME NULL,
	LastLoggedInAt DATETIME NULL,
	InitialEmailAt DATETIME NULL,
	LastEmailedAt DATETIME NULL,
	CompletedAt DATETIME NULL,
	IsReportReleased BIT NOT NULL CONSTRAINT [DF_Registrations_IsReportReleased] DEFAULT (0),
	IsReportAvailable BIT NOT NULL CONSTRAINT [DF_Registrations_IsReportAvailable] DEFAULT (0),
	ReportDownloadedAt DATETIME NULL,
	ReportDownloadedById INT NULL,
	RegisteredAt DATETIME NOT NULL,	
	RegisteredById INT NOT NULL,
	DeletedAt DATETIME NULL,
	DeletedById INT NULL,
	DeletedState INT NOT NULL CONSTRAINT [DF_Registrations_DeletedState] DEFAULT (0),
	IsDeleted AS (CASE WHEN DeletedState > 0 THEN 1 ELSE 0 END),
		
	CONSTRAINT [PK_Registrations] PRIMARY KEY (RegistrationId),
	CONSTRAINT [FK_Registrations_RoundId] FOREIGN KEY (RoundId) REFERENCES dbo.Rounds(RoundId),
	CONSTRAINT [FK_Registrations_PersonId] FOREIGN KEY (PersonId) REFERENCES dbo.People(PersonId),
	CONSTRAINT [FK_Registrations_RegisteredById] FOREIGN KEY (RegisteredById) REFERENCES dbo.Users(UserId),
	CONSTRAINT [FK_Registrations_DeletedById] FOREIGN KEY (DeletedById) REFERENCES dbo.Users(UserId)
)

-- Respondent Categories --
CREATE TABLE dbo.RespondentCategories
(
	RespondentCategoryId INT IDENTITY(1,1) NOT NULL,
	RoundId INT NOT NULL,
	Name NVARCHAR(250) NOT NULL,
	
	CONSTRAINT [PK_RespondentCategories] PRIMARY KEY (RespondentCategoryId),
	CONSTRAINT [FK_RespondentCategories_RoundId] FOREIGN KEY (RoundId) REFERENCES dbo.Rounds(RoundId)
)

-- Respondents --
CREATE TABLE dbo.Respondents
(
	RegistrationId INT NOT NULL,
	PersonId INT NOT NULL,
	RelationshipId INT NOT NULL,
	InitialLoginAt DATETIME NULL,
	LastLoggedInAt DATETIME NULL,
	InitialEmailAt DATETIME NULL,
	LastEmailedAt DATETIME NULL,
	CompletedAt DATETIME NULL,
	IsExcluded BIT NOT NULL CONSTRAINT [DF_Respondents_IsExcluded] DEFAULT (0),
	IsDeclined BIT NOT NULL CONSTRAINT [DF_Respondents_IsDeclined] DEFAULT (0),
	
	CONSTRAINT [PK_Respondents] PRIMARY KEY CLUSTERED (RegistrationId, PersonId),
	CONSTRAINT [FK_Respondents_RegistrationId] FOREIGN KEY (RegistrationId) REFERENCES dbo.Registrations(RegistrationId),
	CONSTRAINT [FK_Respondents_PersonId] FOREIGN KEY (PersonId) REFERENCES dbo.People(PersonId),
	CONSTRAINT [FK_Respondents_RelationshipId] FOREIGN KEY (RelationshipId) REFERENCES dbo.Relationships(RelationshipId)
)

-- Answers --
CREATE TABLE dbo.Answers
(
	AnswerId INT IDENTITY(1,1) NOT NULL,
	RegistrationId INT NOT NULL,
	RespondentId INT NOT NULL,
	QuestionId INT NOT NULL,
	ScalarResponse INT NULL,
	ImportanceScalarResponse INT NULL,
	TextResponse NVARCHAR(MAX) NULL,
	
	CONSTRAINT [PK_Answers] PRIMARY KEY CLUSTERED (AnswerId),
	CONSTRAINT [FK_Answers_RegistrationId] FOREIGN KEY (RegistrationId) REFERENCES dbo.Registrations(RegistrationId),
	CONSTRAINT [FK_Answers_RespondentId] FOREIGN KEY (RegistrationId, RespondentId) REFERENCES dbo.Respondents(RegistrationId, PersonId),
	CONSTRAINT [FK_Answers_QuestionId] FOREIGN KEY (QuestionId) REFERENCES dbo.Questions(QuestionId),
	CONSTRAINT [UQ_Answers_RegistrationId_RespondentId_QuestionId] UNIQUE (RegistrationId, RespondentId, QuestionId)
)


--/*

--ACCOUNT SETTINGS
-----------------------------------
--Period Start Month
--Period End Month


--GENDERS
-----------------------------------
--Female
--Male


--AGE RANGES
-----------------------------------
--Under 20
--20 - 30
--30 - 40
--40 - 50
--50 - 60
--60 - 70
--Over 70


--PROFICIENCY
-----------------------------------
--None
--Basic
--Intermediate
--Advanced
--Expert


--EXPERIENCE
-----------------------------------
--Less than 1 Year
--2 - 3 Years
--3 - 5 Years
--5 - 10 Years
--More than 10 Years


--INTEREST LEVELS
-----------------------------------
--Low
--Medium
--High


--SURVEY TYPES
-----------------------------------
--Multi-rater (360)
--Web Survey


--STAGES
-----------------------------------
--Goal Setting
--Appraisal
--Period Review


--OBJECTIVE TYPES
-----------------------------------
--Manager Goal
--Company Goal


--INTERIM REVIEW TYPES
-----------------------------------
--Monthly
--Quarterly
--Mid-Cycle
--Special


--DEVELOPMENT PLANS TYPES
-----------------------------------
--Reading
--At the job
--Certificate
--Course
--Assignment
--Course
--Assessment
--Atline
--Off-site
--Other


--DEVELOPMENT PLANS STATUSES
-----------------------------------
--Required
--Planned
--In Progress
--Complete
--Cancelled


--Setting (1)
--	1.) View Job Description	
--	2.) Create Goals
--	3.) View Competencies and Behaviours
--	4.) Save and Print Goals (Optional)
--	5.) Sign off stage

--Appraise (2)
--	1.) View Job Description
--	2.) Provide 360� Feedback 
--	3.) Appraise Goals
--	4.) Appraise Competencies and Behaviours
--	5.) Save and Print Goals (Optional)
--	6.) Period Review
--	7.) Save and Print Period Review (Optional)
--	8.) Sign off stage

--Review (3)
--	1.) View Period Review
--	2.) View 360� Feedback Report
--	3.) Save and Print Period Review (Optional)
--	4.) Development Plan
--	5.) Save and Print Development Plan (Optional)
--	6.) Complete and create new Period

--*/