-- User Profiles --
CREATE TABLE dbo.UserProfiles
(	
    UserProfileId INT IDENTITY(1,1) NOT NULL,
	UserId INT NOT NULL,
	FirstName NVARCHAR(50) NOT NULL,
	LastName NVARCHAR(50) NOT NULL,
	FullName AS (LTRIM(RTRIM(ISNULL(FirstName, '')) + ' ' + LastName)),
	ManagerId INT NULL,
	DelegatedApproverId INT NULL, 
	EmployeeNumber NVARCHAR(50) NULL, 
	CompanyName NVARCHAR(250) NULL,
	JobTitle NVARCHAR(50) NULL,
	Division NVARCHAR(50) NULL,
	Department NVARCHAR(50) NULL,
	AddressLine1 NVARCHAR(250) NULL,
	AddressLine2 NVARCHAR(250) NULL,
	CityTown NVARCHAR(250) NULL,
	StateCounty NVARCHAR(250) NULL,
	PostalCode NVARCHAR(15) NULL,
	CountryId INT NULL,
	Phone NVARCHAR(50) NULL,
	Extension NVARCHAR(15) NULL,
	MobilePhone NVARCHAR(50) NULL,
	Email NVARCHAR(250) NULL,
	EmailVerifiedOn DATETIME NULL,
	EmailVerificationCode UNIQUEIdENTIFIER NOT NULL,
	Fax NVARCHAR(50) NULL,
	Website NVARCHAR(250) NULL,
	AboutMe NVARCHAR(1000) NULL,
	Alias NVARCHAR(50) NULL,
	CommunityNickname NVARCHAR(250) NULL,
	IsSelfRegistered BIT NOT NULL,
	ReferralTypeId INT NULL,
	BadgeText NVARCHAR(250) NULL,
	BannerUrl NVARCHAR(500) NULL,
	ProfilePhotoUrl NVARCHAR(500) NULL,
	SmallBannerUrl NVARCHAR(500) NULL,
	SmallProfilePhotoUrl NVARCHAR(500) NULL,
	IsProfilePhotoEnabled BIT NOT NULL CONSTRAINT [DF_UserProfiles_IsProfilePhotoEnabled] DEFAULT (0),
	EmailEncodingKey NVARCHAR(MAX) NULL,
	SenderName NVARCHAR(250) NULL,
	SenderEmail NVARCHAR(250) NULL,
	Signature NVARCHAR(1000) NULL,
	OutOfOfficeMessage NVARCHAR(1000) NULL,
	ForecastEnabled BIT NOT NULL CONSTRAINT [DF_UserProfiles_ForecastEnabled] DEFAULT (0),
	NotifyOnAssignment BIT NOT NULL CONSTRAINT [DF_UserProfiles_NotifyOnAssignment] DEFAULT (1),
	NotificationsEnabled BIT NOT NULL CONSTRAINT [DF_UserProfiles_NotificationsEnabled] DEFAULT (0),
	MailMergeEnabled BIT NOT NULL CONSTRAINT [DF_UserProfiles_MailMergeEnabled] DEFAULT (0),
	ReceivesAdminInfoEmails BIT NOT NULL CONSTRAINT [DF_UserProfiles_ReceivesAdminInfoEmails] DEFAULT (0),
	ReceivesInfoEmails BIT NOT NULL CONSTRAINT [DF_UserProfiles_ReceivesInfoEmails] DEFAULT (0),	
	IsSuspended BIT NOT NULL CONSTRAINT [DF_UserProfiles_IsSuspended] DEFAULT (0),
	SuspendedReason NVARCHAR(1000) NULL,
	DefaultLanguageId INT NOT NULL,
	TrialExpiresAt DATETIME NULL,
	DefaultNotificationFrequency INT NOT NULL,
	CreatedById INT NOT NULL,
	CreatedAt DATETIME NOT NULL,
	LastModifiedById INT NULL,
	LastModifiedAt DATETIME NULL,

	CONSTRAINT [PK_UserProfiles] PRIMARY KEY (UserProfileId),
	CONSTRAINT [FK_UserProfiles_UserId] FOREIGN KEY (UserId) REFERENCES dbo.Users(UserId),
	CONSTRAINT [FK_UserProfiles_ManagerId] FOREIGN KEY (ManagerId) REFERENCES dbo.Users(UserId),
	CONSTRAINT [FK_UserProfiles_DelegatedApproverId] FOREIGN KEY (DelegatedApproverId) REFERENCES dbo.Users(UserId),
	CONSTRAINT [FK_UserProfiles_CountryId] FOREIGN KEY (CountryId) REFERENCES dbo.Countries(CountryId),
	CONSTRAINT [FK_UserProfiles_ReferralTypeId] FOREIGN KEY (ReferralTypeId) REFERENCES dbo.ReferralTypes(ReferralTypeId),
	CONSTRAINT [FK_UserProfiles_DefaultLanguageId] FOREIGN KEY (DefaultLanguageId) REFERENCES dbo.Languages(LanguageId),
	CONSTRAINT [FK_UserProfiles_CreatedById] FOREIGN KEY (CreatedById) REFERENCES dbo.Users(UserId),
	CONSTRAINT [FK_UserProfiles_LastModifiedById] FOREIGN KEY (LastModifiedById) REFERENCES dbo.Users(UserId),
	CONSTRAINT [CK_UserProfiles_ManagerId_UserId] CHECK (ManagerId <> UserId),
	CONSTRAINT [UQ_UserProfiles_Email] UNIQUE (Email)
)


-- User Preferences --
CREATE TABLE dbo.UserPreferences
(
	UserId INT NOT NULL, 
	Preference NVARCHAR(250) NULL, 
	Value NVARCHAR(MAX) NULL,

	CONSTRAINT [PK_UserPreferences] PRIMARY KEY CLUSTERED (UserId, Preference, Value),
	CONSTRAINT [FK_UserPreferences_UserId] FOREIGN KEY (UserId) REFERENCES dbo.Users(UserId)
)

-- User Share --
CREATE TABLE dbo.UserShares
(	
	UserShareId INT IDENTITY(1,1) NOT NULL,
	UserId INT NOT NULL,
	UserAccessLevel INT NOT NULL,  
	IsActive BIT NOT NULL CONSTRAINT [DF_UserShares_IsActive] DEFAULT (0),
	LastModifiedById INT NULL, 
	LastModifiedAt DATETIME NULL,

	CONSTRAINT [PK_UserShares] PRIMARY KEY (UserShareId),
	CONSTRAINT [FK_UserShares_UserId] FOREIGN KEY (UserId) REFERENCES dbo.Users(UserId),
	CONSTRAINT [FK_UserShares_LastModifiedById] FOREIGN KEY (LastModifiedById) REFERENCES dbo.Users(UserId)
)

-- User Permissions --
CREATE TABLE dbo.UserPermissions
(	
	UserPermissionId INT IDENTITY(1,1) NOT NULL,
	Permission NVARCHAR(250) NOT NULL,
	DataType NVARCHAR(50) NOT NULL,
	EnumValue INT NOT NULL,

	CONSTRAINT [PK_UserPermissions] PRIMARY KEY (UserPermissionId)
)

-- User User Permissions --
CREATE TABLE dbo.UserUserPermissions
(	
	UserId INT NOT NULL,
	UserPermissionId INT NOT NULL,

	CONSTRAINT [PK_UserUserPermissions] PRIMARY KEY CLUSTERED (UserId, PermissionId),
	CONSTRAINT [FK_UserUserPermissions_UserId] FOREIGN KEY (UserId) REFERENCES dbo.Users(UserId),
	CONSTRAINT [FK_UserUserPermissions_UserPermissionId] FOREIGN KEY (UserPermissionId) REFERENCES dbo.UserPermissions(UserPermissionId)
)

-- User Entity Access --
CREATE TABLE dbo.UserEntityAccess
(
	UserEntityAccessId INT IDENTITY(1,1) NOT NULL,
	UserId INT NOT NULL,
	EntityDefinitionId INT NOT NULL,
	CanActivate BIT NOT NULL CONSTRAINT [DF_UserEntityAccess_CanActivate] DEFAULT (0),
	CanCreate BIT NOT NULL CONSTRAINT [DF_UserEntityAccess_CanCreate] DEFAULT (0), 
	CanDelete BIT NOT NULL CONSTRAINT [DF_UserEntityAccess_CanDelete] DEFAULT (0), 
	CanEdit BIT NOT NULL CONSTRAINT [DF_UserEntityAccess_CanEdit] DEFAULT (0), 
	CanUpdate BIT NOT NULL CONSTRAINT [DF_UserEntityAccess_CanUpdate] DEFAULT (0), 
	CanMerge BIT NOT NULL CONSTRAINT [DF_UserEntityAccess_CanMerge] DEFAULT (0), 
	CanRead BIT NOT NULL CONSTRAINT [DF_UserEntityAccess_CanRead] DEFAULT (0), 
	IsUndeletable BIT NOT NULL CONSTRAINT [DF_UserEntityAccess_IsUndeletable] DEFAULT (0), 
	IsUpdatable BIT NOT NULL CONSTRAINT [DF_UserEntityAccess_IsUpdatable] DEFAULT (0), 

	CONSTRAINT [PK_UserEntityAccess] PRIMARY KEY (UserEntityAccessId),
	CONSTRAINT [FK_UserEntityAccess_UserId] FOREIGN KEY (UserId) REFERENCES dbo.Users(UserId)
)

-- User Record Access --
CREATE TABLE dbo.UserRecordAccess
(	
	UserRecordAccessId INT IDENTITY(1,1) NOT NULL,
	UserId INT NOT NULL,
	RecordId INT NOT NULL,
	MaxAccessLevel BIT NOT NULL CONSTRAINT [DF_UserRecordAccess_MaxAccessLevel] DEFAULT (0), 
	CanRead BIT NOT NULL CONSTRAINT [DF_UserRecordAccess_CanRead] DEFAULT (0), 
	CanEdit BIT NOT NULL CONSTRAINT [DF_UserRecordAccess_CanEdit] DEFAULT (0), 	
	CanDelete BIT NOT NULL CONSTRAINT [DF_UserRecordAccess_CanDelete] DEFAULT (0), 
	CanTransfer BIT NOT NULL CONSTRAINT [DF_UserRecordAccess_CanTransfer] DEFAULT (0), 

	CONSTRAINT [PK_UserRecordAccess] PRIMARY KEY (UserRecordAccessId),
	CONSTRAINT [FK_UserRecordAccess_UserId] FOREIGN KEY (UserId) REFERENCES dbo.Users(UserId)
)

-- User Field Access --
CREATE TABLE dbo.UserFieldAccess
(	
	UserFieldAccessId INT IDENTITY(1,1) NOT NULL,
	UserId INT NOT NULL,
	EntityDefinitionId INT NOT NULL,
	FieldDefinitionId INT NOT NULL,
	CanCreate BIT NOT NULL CONSTRAINT [DF_UserFieldAccess_CanCreate] DEFAULT (0), 
	CanRead BIT NOT NULL CONSTRAINT [DF_UserFieldAccess_CanRead] DEFAULT (0), 
	CanEdit BIT NOT NULL CONSTRAINT [DF_UserFieldAccess_CanEdit] DEFAULT (0), 
	CanDelete BIT NOT NULL CONSTRAINT [DF_UserFieldAccess_CanDelete] DEFAULT (0), 
	
	CONSTRAINT [PK_UserFieldAccess] PRIMARY KEY (UserFieldAccessId),
	CONSTRAINT [FK_UserFieldAccess_UserId] FOREIGN KEY (UserId) REFERENCES dbo.Users(UserId)
)

-- User Provisioning Requests --
CREATE TABLE dbo.UserProvisioningRequests
(	
	UserProvisioningRequestId INT IDENTITY(1,1) NOT NULL,
	UserId INT NOT NULL, 
	ApprovingManagerId INT NULL, 
	Name NVARCHAR(250) NOT NULL, 
	Operation INT NOT NULL,
	RetryCount INT NOT NULL CONSTRAINT [DF_UserProvisioningRequests_RetryCount] DEFAULT (0), 
	ScheduleDate DATETIME NULL, 
	State INT NOT NULL, 
	IsApproved BIT NOT NULL CONSTRAINT [DF_UserProvisioningRequests_IsApproved] DEFAULT (0), 
	CreatedById INT NOT NULL, 
	CreatedAt DATETIME NOT NULL, 
	LastModifiedById INT NOT NULL,
	LastModifiedAt DATETIME NULL,

	CONSTRAINT [PK_UserProvisioningRequests] PRIMARY KEY (UserProvisioningRequestId),
	CONSTRAINT [FK_UserProvisioningRequests_UserId] FOREIGN KEY (UserId) REFERENCES dbo.Users(UserId),
	CONSTRAINT [FK_UserProvisioningRequests_CreatedById] FOREIGN KEY (CreatedById) REFERENCES dbo.Users(UserId),
	CONSTRAINT [FK_UserProvisioningRequests_LastModifiedById] FOREIGN KEY (LastModifiedById) REFERENCES dbo.Users(UserId)
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

-- Organisations --
CREATE TABLE dbo.Organisations
(
	OrganisationId INT IDENTITY(1,1) NOT NULL,
	Name NVARCHAR(250) NOT NULL,
	Division NVARCHAR(250) NULL,
	AddressLine1 NVARCHAR(250) NULL,
	AddressLine2 NVARCHAR(250) NULL,
	CityTown NVARCHAR(250) NULL,
	StateCounty NVARCHAR(250) NULL,
	PostalCode NVARCHAR(15) NULL,
	CountryId INT NULL,
	Phone NVARCHAR(50) NULL,
	Email NVARCHAR(250) NULL,
	Fax NVARCHAR(50) NULL,
	Website NVARCHAR(250) NULL,	
	EmployeeCount INT NULL CONSTRAINT [DF_Organisations_EmployeeCount] DEFAULT (0),
	TrialExpiresAt DATETIME NULL,
	FiscalYearStartMonth INT NULL,
	DefaultLanguageId INT NOT NULL,
	DefaultCurrencyId INT NOT NULL,
	DefaultDateFormat NVARCHAR(250) NOT NULL,
	DefaultTimeFormat NVARCHAR(250) NOT NULL,
	UiTheme NVARCHAR(250) NULL,
	ReceivesAdminInfoEmails BIT NOT NULL CONSTRAINT [DF_Organisations_ReceivesAdminInfoEmails] DEFAULT (1),
	ReceivesInfoEmails BIT NOT NULL CONSTRAINT [DF_Organisations_ReceivesInfoEmails] DEFAULT (0),
	CaseAutoResponseEnabled BIT NOT NULL CONSTRAINT [DF_Organisations_CaseAutoResponse] DEFAULT (1),
	CommentsEnabled BIT NOT NULL CONSTRAINT [DF_Organisations_CommentsEnabled] DEFAULT (1),
	RatingsEnabled BIT NOT NULL CONSTRAINT [DF_Organisations_RatingsEnabled] DEFAULT (0),
	ForumsEnabled BIT NOT NULL CONSTRAINT [DF_Organisations_ForumsEnabled] DEFAULT (0),
	ActivityFeedsEnabled BIT NOT NULL CONSTRAINT [DF_Organisations_ActivityFeedsEnabled] DEFAULT (1),
	TerminateOldestSession BIT NOT NULL CONSTRAINT [DF_Organisations_TerminateOldestSession] DEFAULT (1),
	IsReadOnly BIT NOT NULL CONSTRAINT [DF_Organisations_IsReadOnly] DEFAULT (0),
	IsSandbox BIT NOT NULL CONSTRAINT [DF_Organisations_IsSandbox] DEFAULT (0),
	Latitude NVARCHAR(50) NULL,
	Longitude NVARCHAR(50) NULL,
	GeolocatedAccuracy INT NULL,
	CreatedAt DATETIME NOT NULL,
	CreatedById INT NOT NULL,		
	LastModifiedAt DATETIME NOT NULL,
	LastModifiedById INT NOT NULL,

	CONSTRAINT [PK_Organisations] PRIMARY KEY (OrganisationId),
	CONSTRAINT [FK_Organisations_CountryId] FOREIGN KEY (CountryId) REFERENCES dbo.Countries(CountryId),
	CONSTRAINT [FK_Organisations_DefaultLanguageId] FOREIGN KEY (DefaultLanguageId) REFERENCES dbo.Languages(LanguageId),
	CONSTRAINT [FK_Organisations_DefaultCurrencyId] FOREIGN KEY (DefaultCurrencyId) REFERENCES dbo.Currencies(CurrencyId),
	CONSTRAINT [FK_Organisations_CreatedById] FOREIGN KEY (CreatedById) REFERENCES dbo.Users(UserId),
	CONSTRAINT [FK_Organisations_LastModifiedById] FOREIGN KEY (LastModifiedById) REFERENCES dbo.Users(UserId)
)

-- Orgaisation Languages --
CREATE TABLE dbo.OrganisationLanguages
(	
	OrganisationId INT NOT NULL,
	LanguageId INT NOT NULL,
					
	CONSTRAINT [PK_OrganisationLanguages] PRIMARY KEY CLUSTERED (OrganisationId, LanguageId),
	CONSTRAINT [FK_OrganisationLanguages_OrganisationId] FOREIGN KEY (OrganisationId) REFERENCES dbo.Organisations(OrganisationId),
	CONSTRAINT [FK_OrganisationLanguages_LanguageId] FOREIGN KEY (LanguageId) REFERENCES dbo.Languages(LanguageId)
)

/* Pricing Plans --
If monthly login entitlement is set to 0, then the client is on an enterprise license. */
CREATE TABLE dbo.PricingPlans
(	
	PricingPlanId INT IDENTITY(1,1) NOT NULL,
	Name NVARCHAR(250) NOT NULL,
	LicenseDefinitionKey NVARCHAR(250) NOT NULL,
	MaximumNumberOfUsers INT NOT NULL,
	MonthlyLoginEntitlement INT NOT NULL,
	MonthlyCost DECIMAL NOT NULL,
	AnnualCost DECIMAL NOT NULL,
	IsRecurring BIT NOT NULL CONSTRAINT [DF_PricingPlans_IsRecurring] DEFAULT (1),
	ExpiresOffset INT NULL,
					
	CONSTRAINT [PK_PricingPlans] PRIMARY KEY (PricingPlanId)
)

-- User License --
CREATE TABLE dbo.UserLicenses
(	
	UserId INT NOT NULL,
	PricingPlanId INT NOT NULL,
	LicenseDefinitionKey NVARCHAR(MAX) NOT NULL,
	TotalLicenses INT NOT NULL CONSTRAINT [DF_UserLicenses_TotalLicenses] DEFAULT (0),
	UsedLicenses INT NOT NULL CONSTRAINT [DF_UserLicenses_UsedLicenses] DEFAULT (0),
	UsedLicensesLastUpdatedAt DATETIME NOT NULL,
	CreatedAt DATETIME NOT NULL,
	LastModifiedAt DATETIME NULL,

	CONSTRAINT [PK_UserLicenses] PRIMARY KEY CLUSTERED (UserId, PricingPlanId),
	CONSTRAINT [FK_UserLicenses_UserId] FOREIGN KEY (UserId) REFERENCES dbo.Users(UserId),
	CONSTRAINT [FK_UserLicenses_PricingPlanId] FOREIGN KEY (PricingPlanId) REFERENCES dbo.PricingPlans(PricingPlanId)
)

-- Fiscal Period Types --
CREATE TABLE dbo.FiscalPeriodTypes
(	
	FiscalPeriodTypeId INT IDENTITY(1,1) NOT NULL,
	Name NVARCHAR(250) NOT NULL, -- Month, Quarter, Week, or Year
	EnumValue INT NOT NULL,
					
	CONSTRAINT [PK_FiscalPeriodTypes] PRIMARY KEY (FiscalPeriodTypeId)
)

-- Fiscal Periods --
CREATE TABLE dbo.FiscalPeriods
(	
	FiscalPeriodId INT IDENTITY(1,1) NOT NULL,
	OrganisationId INT NOT NULL,	
	Number INT NULL,	
	StartsAt DATETIME NOT NULL,
	EndsAt DATETIME NOT NULL,
	IsForecastPeriod BIT NOT NULL CONSTRAINT [DF_FiscalPeriods_IsForecastPeriod] DEFAULT (0),	
	FiscalPeriodTypeId INT NOT NULL,
					
	CONSTRAINT [PK_FiscalPeriods] PRIMARY KEY (FiscalPeriodId),
	CONSTRAINT [FK_FiscalPeriods_OrganisationId] FOREIGN KEY (OrganisationId) REFERENCES dbo.Organisations(OrganisationId),
	CONSTRAINT [FK_FiscalPeriods_FiscalPeriodTypeId] FOREIGN KEY (FiscalPeriodTypeId) REFERENCES dbo.FiscalPeriodTypes(FiscalPeriodTypeId)
)

-- Fiscal Year Settings --
CREATE TABLE dbo.FiscalYearSettings 
(	
	FiscalYearSettingId INT IDENTITY(1,1) NOT NULL,
	FiscalPeriodId INT NOT NULL,
	Name NVARCHAR(250) NOT NULL,
	Description NVARCHAR(MAX) NULL,
	StartsAt DATETIME NOT NULL,
	EndsAt DATETIME NOT NULL,
	PeriodPrefix NVARCHAR(250) NULL,
	QuarterPrefix NVARCHAR(250) NULL,
	WeekStartDay INT NULL,
	IsStandardYear BIT NOT NULL CONSTRAINT [DF_FiscalYearSettings_IsStandardYear] DEFAULT (0),	
					
	CONSTRAINT [PK_FiscalYearSettings] PRIMARY KEY (FiscalYearSettingId),
	CONSTRAINT [FK_FiscalYearSettings_FiscalPeriodId] FOREIGN KEY (FiscalPeriodId) REFERENCES dbo.FiscalPeriods(FiscalPeriodId)
)

-- Frequencies --
CREATE TABLE dbo.Frequencies
(	
	FrequencyId INT IDENTITY(1,1) NOT NULL,
	Name NVARCHAR(250) NOT NULL,
	EnumValue INT NOT NULL,
					
	CONSTRAINT [PK_Frequencies] PRIMARY KEY (FrequencyId)
)

-- Brand Templates --
CREATE TABLE dbo.BrandTemplates
(	
	BrandTemplateId INT IDENTITY(1,1) NOT NULL,
	OrganisationId INT NOT NULL,
	Name NVARCHAR(250) NOT NULL,
	Description NVARCHAR(MAX) NULL,
	MarkUp NVARCHAR(MAX) NOT NULL, -- The contents of the letterhead, in HTML, including any logos
	IsActive INT NOT NULL CONSTRAINT [DF_BrandTemplates_IsActive] DEFAULT (0),
					
	CONSTRAINT [PK_BrandTemplates] PRIMARY KEY (BrandTemplateId),
	CONSTRAINT [FK_BrandTemplates_OrganisationId] FOREIGN KEY (OrganisationId) REFERENCES dbo.Organisations(OrganisationId)
)

/*
Re-order audit columns.
Add IsSystem column for system templates. Not overriden.
Add OrganisationId column.
Add EmailTemplateTypeId column. E.g. New contact added. Appointment confirmed.
*/

-- Email Templates --
CREATE TABLE dbo.EmailTemplates
(
	EmailTemplateId INT IDENTITY(1,1) NOT NULL,
	EntityTypeId INT NOT NULL,
	BrandTemplateId INT NULL, -- Letterhead for HTML EmailTemplate
	Name NVARCHAR(250) NOT NULL,
	Description NVARCHAR(MAX) NULL,
	Subject NVARCHAR(250) NULL,
	PlainTextBody NVARCHAR(MAX) NULL,
	HtmlBody NVARCHAR(MAX) NULL,
	Stylesheet NVARCHAR(MAX) NULL,
	SendTextOnly BIT NOT NULL CONSTRAINT [DF_EmailTemplates_SendTextOnly] DEFAULT (0),
	LastUsedAt DATETIME NULL,
	TimesUsed BIT NOT NULL CONSTRAINT [DF_EmailTemplates_TimesUsed] DEFAULT (0),
	CreatedAt DATETIME NOT NULL,
	CreatedById INT NOT NULL,
	LastModifiedAt DATETIME NOT NULL,
	LastModifiedById INT NOT NULL,
	IsDeleted INT NOT NULL CONSTRAINT [DF_EmailTemplatess_IsDeleted] DEFAULT (0),

	CONSTRAINT [PK_EmailTemplates] PRIMARY KEY (EmailTemplateId),
	CONSTRAINT [FK_EmailTemplates_EntityTypeId] FOREIGN KEY (EntityTypeId) REFERENCES dbo.EntityTypes(EntityTypeId),
	CONSTRAINT [FK_EmailTemplates_BrandTemplateId] FOREIGN KEY (BrandTemplateId) REFERENCES dbo.BrandTemplates(BrandTemplateId),
	CONSTRAINT [FK_EmailTemplates_CreatedById] FOREIGN KEY (CreatedById) REFERENCES dbo.Users(UserId),
	CONSTRAINT [FK_EmailTemplates_LastModifiedById] FOREIGN KEY (LastModifiedById) REFERENCES dbo.Users(UserId)
)

/*
Add deleted state columns and constraints.
Add MarkAsSpam column.
Add LastActivityAt column.
Add IsFlagged column.
*/

-- Groups --
CREATE TABLE dbo.Groups
(	
	GroupId INT IDENTITY(1,1) NOT NULL,
	OrganisationId INT NOT NULL,
	Name NVARCHAR(250) NOT NULL,
	Email NVARCHAR(250) NULL,
	SendEmailToAllMembers BIT NOT NULL CONSTRAINT [DF_Groups_SendEmailToMembers] DEFAULT (0),
	IsModerated BIT NOT NULL CONSTRAINT [DF_Groups_IsModerated] DEFAULT (0),	
	CommentsEnabled BIT NOT NULL CONSTRAINT [DF_Groups_CommentsEnabled] DEFAULT (0),
	RatingsEnabled BIT NOT NULL CONSTRAINT [DF_Groups_RatingsEnabled] DEFAULT (0),
	ForumsEnabled BIT NOT NULL CONSTRAINT [DF_Groups_ForumsEnabled] DEFAULT (0),
	ActivityFeedsEnabled BIT NOT NULL CONSTRAINT [DF_Groups_ActivityFeedsEnabled] DEFAULT (0),
	IsPublic BIT NOT NULL CONSTRAINT [DF_Groups_IsPublic] DEFAULT (1),	
	CreatedAt DATETIME NOT NULL,
	CreatedById INT NOT NULL,
	LastModifiedAt DATETIME NOT NULL,
	LastModifiedById INT NOT NULL,
	IsDeleted INT NOT NULL CONSTRAINT [DF_Groups_IsDeleted] DEFAULT (0),		
					
	CONSTRAINT [PK_Groups] PRIMARY KEY (GroupId),
	CONSTRAINT [FK_Groups_OrganisationId] FOREIGN KEY (OrganisationId) REFERENCES dbo.Organisations(OrganisationId),
	CONSTRAINT [FK_Groups_CreatedById] FOREIGN KEY (CreatedById) REFERENCES dbo.Users(UserId),
	CONSTRAINT [FK_Groups_LastModifiedById] FOREIGN KEY (LastModifiedById) REFERENCES dbo.Users(UserId)
)

-- User Groups --
CREATE TABLE dbo.UserGroups
(	
	UserId INT NOT NULL,
	GroupId INT NOT NULL,
	IsLeader BIT NOT NULL CONSTRAINT [DF_UserGroups_IsLeader] DEFAULT (0),
	IsAdministrator BIT NOT NULL CONSTRAINT [DF_UserGroups_IsAdministrator] DEFAULT (0),
	IsModerator BIT NOT NULL CONSTRAINT [DF_UserGroups_IsModerator] DEFAULT (0),
					
	CONSTRAINT [PK_UserGroups] PRIMARY KEY CLUSTERED (UserId, GroupId),
	CONSTRAINT [FK_UserGroups_UserId] FOREIGN KEY (UserId) REFERENCES dbo.Users(UserId),	
	CONSTRAINT [FK_UserGroups_GroupId] FOREIGN KEY (GroupId) REFERENCES dbo.Groups(GroupId)
)

-- Folder Types --
CREATE TABLE dbo.FolderTypes
(
	FolderTypeId INT IDENTITY(1,1) NOT NULL,
	Name NVARCHAR(250) NOT NULL,	

	CONSTRAINT [PK_FolderTypes] PRIMARY KEY (FolderTypeId)
)

-- Folders --
CREATE TABLE dbo.Folders
(
	FolderId INT IDENTITY(1,1) NOT NULL,
	ParentFolderId INT NOT NULL CONSTRAINT [DF_Folders_ParentFolderId] DEFAULT (0),
	FolderTypeId INT NOT NULL,
	OrganisationId INT NOT NULL,
	Name NVARCHAR(250) NOT NULL,	
	Description NVARCHAR(MAX) NULL,	
	IsPublic BIT NOT NULL CONSTRAINT [DF_Folders_IsPublic] DEFAULT (0),
	IsReadonly BIT NOT NULL CONSTRAINT [DF_Folders_IsReadonly] DEFAULT (0),
	OwnerId INT NOT NULL,
	CreatedAt DATETIME NOT NULL,
	CreatedById INT NOT NULL,
	LastModifiedAt DATETIME NOT NULL,
	LastModifiedById INT NOT NULL,
	IsDeleted INT NOT NULL CONSTRAINT [DF_Folders_IsDeleted] DEFAULT (0),

	CONSTRAINT [PK_Folders] PRIMARY KEY (FolderId),
	CONSTRAINT [FK_Folders_FolderTypeId] FOREIGN KEY (FolderTypeId) REFERENCES dbo.FolderTypes(FolderTypeId),
	CONSTRAINT [FK_Folders_OrganisationId] FOREIGN KEY (OrganisationId) REFERENCES dbo.Organisations(OrganisationId),
	CONSTRAINT [FK_Folders_OwnerId] FOREIGN KEY (OwnerId) REFERENCES dbo.Users(UserId),
	CONSTRAINT [FK_Folders_CreatedById] FOREIGN KEY (CreatedById) REFERENCES dbo.Users(UserId),
	CONSTRAINT [FK_Folders_LastModifiedById] FOREIGN KEY (LastModifiedById) REFERENCES dbo.Users(UserId)
)

-- Mime Types --
CREATE TABLE dbo.MimeTypes
(
	MimeTypeId INT IDENTITY(1,1) NOT NULL,
	Name NVARCHAR(250) NOT NULL,		

	CONSTRAINT [PK_MimeTypes] PRIMARY KEY (MimeTypeId)
)

-- Documents --
CREATE TABLE dbo.Documents
(
	DocumentId INT IDENTITY(1,1) NOT NULL,
	FolderId INT NOT NULL,
	Name NVARCHAR(250) NOT NULL,
	FileData VARBINARY(MAX) NULL,
	Description NVARCHAR(MAX) NULL,
	Keywords NVARCHAR(250) NULL,
	MimeTypeId INT NOT NULL,
	Size INT NULL,
	PathUrl NVARCHAR(500) NULL, -- If specified, do not specify the Body or Size.
	ForInternalUseOnly BIT NOT NULL CONSTRAINT [DF_Documents_ForInternalUseOnly] DEFAULT (0),
	IsPublic BIT NOT NULL CONSTRAINT [DF_Documents_IsPublic] DEFAULT (0),
	OwnerId INT NOT NULL,
	CreatedAt DATETIME NOT NULL,
	CreatedById INT NOT NULL,
	LastModifiedAt DATETIME NOT NULL,
	LastModifiedById INT NOT NULL,
	IsDeleted INT NOT NULL CONSTRAINT [DF_Documents_IsDeleted] DEFAULT (0),

	CONSTRAINT [PK_Documents] PRIMARY KEY (DocumentId),
	CONSTRAINT [FK_Documents_FolderId] FOREIGN KEY (FolderId) REFERENCES dbo.Folders(FolderId),
	CONSTRAINT [FK_Documents_MimeTypeId] FOREIGN KEY (MimeTypeId) REFERENCES dbo.MimeTypes(MimeTypeId),
	CONSTRAINT [FK_Documents_OwnerId] FOREIGN KEY (OwnerId) REFERENCES dbo.Users(UserId),
	CONSTRAINT [FK_Documents_CreatedById] FOREIGN KEY (CreatedById) REFERENCES dbo.Users(UserId),
	CONSTRAINT [FK_Documents_LastModifiedById] FOREIGN KEY (LastModifiedById) REFERENCES dbo.Users(UserId)
)

-- Document Tags --
CREATE TABLE dbo.DocumentTags
(	
	DocumentId INT NOT NULL,
	TagId INT NOT NULL,	
					
	CONSTRAINT [PK_DocumentTags] PRIMARY KEY CLUSTERED (DocumentId, TagId),
	CONSTRAINT [FK_DocumentTags_DocumentId] FOREIGN KEY (DocumentId) REFERENCES dbo.Documents(DocumentId),
	CONSTRAINT [FK_DocumentTags_TagId] FOREIGN KEY (TagId) REFERENCES dbo.Tags(TagId)
)

-- Mailbox Folders --
CREATE TABLE dbo.MailboxFolders
(
	MailboxFolderID INT IDENTITY(1,1) NOT NULL,
	Name NVARCHAR(250) NOT NULL,
	UnreadMessageCount INT NOT NULL CONSTRAINT [DF_MailboxFolders_UnreadMessageCount] DEFAULT (0),
	IsSystem BIT NOT NULL CONSTRAINT [DF_MailboxFolders_IsSystem] DEFAULT (0),
	OwnerID INT NOT NULL,
	CreatedAt DATETIME NOT NULL,
		
	CONSTRAINT [PK_MailboxFolders] PRIMARY KEY (MailboxFolderID),
	CONSTRAINT [FK_MailboxFolders_OwnerID] FOREIGN KEY (OwnerID) REFERENCES dbo.[Users](UserID)
)

-- Private Messages --
CREATE TABLE dbo.[Messages]
(
	MessageId INT IDENTITY(1,1) NOT NULL,
	ParentMessageId INT NOT NULL CONSTRAINT [DF_Messages_ParentMessageId] DEFAULT (0),
	FromId INT NOT NULL,
	Subject NVARCHAR(250) NULL,
	Importance INT NOT NULL,
	PlainTextBody NVARCHAR(MAX) NOT NULL,
	HtmlBody NVARCHAR(MAX) NOT NULL,
	IsFlagged BIT NOT NULL CONSTRAINT [DF_Messages_IsFlagged] DEFAULT (0),	
	ReadCount INT NOT NULL CONSTRAINT [DF_Messages_ReadCount] DEFAULT (0),	
	SentAt DATETIME NULL,
	CreatedAt DATETIME NOT NULL,
	
	CONSTRAINT [PK_Messages] PRIMARY KEY (MessageId),
	CONSTRAINT [FK_Messages_FromId] FOREIGN KEY (FromId) REFERENCES dbo.Users(UserId)
)

-- Recipient Types --
CREATE TABLE dbo.RecipientTypes
(	
	RecipientTypeId INT NOT NULL,
	Name NVARCHAR(250) NOT NULL,
					
	CONSTRAINT [PK_RecipientTypes] PRIMARY KEY (RecipientTypeId)
)

-- Message Recipients --
CREATE TABLE dbo.MessageRecipients
(
	MessageRecipientID INT IDENTITY(1,1) NOT NULL,
	MessageID INT NOT NULL,
	RecipientTypeID INT NOT NULL,
	RecipientID INT NOT NULL,
	MailboxFolderID INT NOT NULL,
	IsRead BIT NOT NULL CONSTRAINT [DF_MessageRecipients_IsRead] DEFAULT (0),	
		
	CONSTRAINT [PK_MessageRecipients] PRIMARY KEY (MessageRecipientID),
	CONSTRAINT [FK_MessageRecipients_MessageID] FOREIGN KEY (MessageID) REFERENCES dbo.[Messages](MessageID),
	CONSTRAINT [FK_MessageRecipients_RecipientTypeID] FOREIGN KEY (RecipientTypeID) REFERENCES dbo.RecipientTypes(RecipientTypeID),
	CONSTRAINT [FK_MessageRecipients_RecipientID] FOREIGN KEY (RecipientID) REFERENCES dbo.[Users](UserID),
	CONSTRAINT [FK_MessageRecipients_MailboxFolderID] FOREIGN KEY (MailboxFolderID) REFERENCES dbo.MailboxFolders(MailboxFolderID)
)

-- Activity Types --
CREATE TABLE dbo.ActivityTypes
(	
	ActivityTypeID INT NOT NULL,
	Name NVARCHAR(250) NOT NULL,
	Template NVARCHAR(MAX) NOT NULL,	
						
	CONSTRAINT [PK_ActivityTypes] PRIMARY KEY (ActivityTypeID)
)

-- Activity Feeds --
CREATE TABLE dbo.ActivityFeeds
(
	FeedPostId INT IDENTITY(1,1) NOT NULL,
	EntityTypeId INT NOT NULL,
	EntityId INT NOT NULL,
	ActivityTypeID INT NOT NULL,
	OrganisationId INT NOT NULL,
	Body NVARCHAR(250) NOT NULL,
	CommentCount INT NOT NULL CONSTRAINT [DF_ActivityFeeds_CommentCount] DEFAULT (0),
	LikeCount INT NOT NULL CONSTRAINT [DF_ActivityFeeds_LikeCount] DEFAULT (0),
	LinkUrl NVARCHAR(500) NULL,
	FileName NVARCHAR(250) NULL,
	FileData VARBINARY(MAX) NULL,
	FileDescription NVARCHAR(MAX) NULL,
	MimeTypeId INT NULL,
	Size INT NULL,
	CreatedAt DATETIME NOT NULL,
	CreatedById INT NOT NULL,
	LastModifiedAt DATETIME NOT NULL,
	LastModifiedById INT NOT NULL,		
	IsDeleted INT NOT NULL CONSTRAINT [DF_ActivityFeeds_IsDeleted] DEFAULT (0),

	CONSTRAINT [PK_ActivityFeeds] PRIMARY KEY (FeedPostId),
	CONSTRAINT [FK_ActivityFeeds_EntityTypeId] FOREIGN KEY (EntityTypeId) REFERENCES dbo.EntityTypes(EntityTypeId),
	CONSTRAINT [FK_ActivityFeeds_ActivityTypeID] FOREIGN KEY (ActivityTypeID) REFERENCES dbo.ActivityTypes(ActivityTypeID),
	CONSTRAINT [FK_ActivityFeeds_OrganisationId] FOREIGN KEY (OrganisationId) REFERENCES dbo.Organisations(OrganisationId),
	CONSTRAINT [FK_ActivityFeeds_MimeTypeId] FOREIGN KEY (MimeTypeId) REFERENCES dbo.MimeTypes(MimeTypeId),
	CONSTRAINT [FK_ActivityFeeds_CreatedById] FOREIGN KEY (CreatedById) REFERENCES dbo.Users(UserId),
	CONSTRAINT [FK_ActivityFeeds_LastModifiedById] FOREIGN KEY (LastModifiedById) REFERENCES dbo.Users(UserId)
)

-- Likes --
CREATE TABLE dbo.Likes
(
	FeedPostId INT NOT NULL,
	UserId INT NOT NULL,
	CreatedAt DATETIME NOT NULL,

	CONSTRAINT [PK_Likes] PRIMARY KEY CLUSTERED (FeedPostId, UserId),	
	CONSTRAINT [FK_Likes_UserId] FOREIGN KEY (UserId) REFERENCES dbo.Users(UserId)
)

-- Notes --
CREATE TABLE dbo.Notes
(
	NoteId INT IDENTITY(1,1) NOT NULL,
	EntityTypeId INT NOT NULL,
	EntityId INT NOT NULL,	
	OrganisationId INT NOT NULL,
	Body NVARCHAR(MAX) NOT NULL,	
	IsPublic BIT NOT NULL CONSTRAINT [DF_Note_IsPublic] DEFAULT (0),
	OwnerId INT NOT NULL,
	CreatedAt DATETIME NOT NULL,
	CreatedById INT NOT NULL,
	LastModifiedAt DATETIME NOT NULL,
	LastModifiedById INT NOT NULL,
	IsDeleted INT NOT NULL CONSTRAINT [DF_Note_IsDeleted] DEFAULT (0),			

	CONSTRAINT [PK_Notes] PRIMARY KEY (NoteId),
	CONSTRAINT [FK_Notes_EntityTypeId] FOREIGN KEY (EntityTypeId) REFERENCES dbo.EntityTypes(EntityTypeId),
	CONSTRAINT [FK_Notes_OrganisationId] FOREIGN KEY (OrganisationId) REFERENCES dbo.Organisations(OrganisationId),
	CONSTRAINT [FK_Notes_OwnerId] FOREIGN KEY (OwnerId) REFERENCES dbo.Users(UserId),
	CONSTRAINT [FK_Notes_CreatedById] FOREIGN KEY (CreatedById) REFERENCES dbo.Users(UserId),
	CONSTRAINT [FK_Notes_LastModifiedById] FOREIGN KEY (LastModifiedById) REFERENCES dbo.Users(UserId)
)

-- Campaign Types --
CREATE TABLE dbo.CampaignTypes
(
	CampaignTypeId INT IDENTITY(1,1) NOT NULL,
	OrganisationId INT NULL,
	Name NVARCHAR(250) NOT NULL,
	
	CONSTRAINT [PK_CampaignTypes] PRIMARY KEY (CampaignTypeId),
	CONSTRAINT [FK_CampaignTypes_OrganisationId] FOREIGN KEY (OrganisationId) REFERENCES dbo.Organisations(OrganisationId)
)

-- Campaign Statuses --
CREATE TABLE dbo.CampaignStatuses
(
	CampaignStatusId INT IDENTITY(1,1) NOT NULL,
	OrganisationId INT NULL,
	Name NVARCHAR(250) NOT NULL,
	IsDefault BIT NOT NULL CONSTRAINT [DF_CampaignStatuses_IsDefault] DEFAULT (0),
	
	CONSTRAINT [PK_CampaignStatuses] PRIMARY KEY (CampaignStatusId),
	CONSTRAINT [FK_CampaignStatuses_OrganisationId] FOREIGN KEY (OrganisationId) REFERENCES dbo.Organisations(OrganisationId)
)

-- Campaign Templates --
CREATE TABLE dbo.CampaignTemplates
(
	CampaignTemplateId INT IDENTITY(1,1) NOT NULL,
	OrganisationId INT NOT NULL,
	Name NVARCHAR(250) NOT NULL,
	Objective NVARCHAR(MAX) NULL,
	Description NVARCHAR(MAX) NULL,
	CampaignTypeId INT NOT NULL,
	ProposedStartOn DATETIME NULL,
	ActualStartOn DATETIME NULL,
	ProposedEndOn DATETIME NULL,
	ActualEndOn DATETIME NULL,
	EstimatedCost DECIMAL(10,2) NULL ,
	ActualCost DECIMAL(10,2) NULL,
	EstimatedRevenue DECIMAL(10,2) NULL,
	ActualRevenue DECIMAL(10,2) NULL,
	MiscellaneousCost DECIMAL(10,2) NULL,
	TotalCost DECIMAL(10,2) NULL,
	CurrencyId INT NULL,
	CampaignStatusId INT NOT NULL,
	EstimatedResponseCount INT NOT NULL CONSTRAINT [DF_CampaignTemplates_EstimatedResponseCount] DEFAULT (0),
	IsSystem BIT NOT NULL CONSTRAINT [DF_CampaignTemplates_IsSystem] DEFAULT (0),
	OwnerId INT NOT NULL,				
	CreatedAt DATETIME NOT NULL,
	CreatedById INT NOT NULL,
	LastModifiedAt DATETIME NOT NULL,
	LastModifiedById INT NOT NULL,
	IsDeleted INT NOT NULL CONSTRAINT [DF_CampaignTemplates_IsDeleted] DEFAULT (0),
	
	CONSTRAINT [PK_CampaignTemplates] PRIMARY KEY (CampaignTemplateId),
	CONSTRAINT [FK_CampaignTemplates_OrganisationId] FOREIGN KEY (OrganisationId) REFERENCES dbo.Organisations(OrganisationId),
	CONSTRAINT [FK_CampaignTemplates_CampaignTypeId] FOREIGN KEY (CampaignTypeId) REFERENCES dbo.CampaignTypes(CampaignTypeId),
	CONSTRAINT [FK_CampaignTemplates_CurrencyId] FOREIGN KEY (CurrencyId) REFERENCES dbo.Currencies(CurrencyId),
	CONSTRAINT [FK_CampaignTemplates_CampaignStatusId] FOREIGN KEY (CampaignStatusId) REFERENCES dbo.CampaignStatuses(CampaignStatusId),
	CONSTRAINT [FK_CampaignTemplates_OwnerId] FOREIGN KEY (OwnerId) REFERENCES dbo.Users(UserId),
	CONSTRAINT [FK_CampaignTemplates_CreatedById] FOREIGN KEY (CreatedById) REFERENCES dbo.Users(UserId),
	CONSTRAINT [FK_CampaignTemplates_LastModifiedById] FOREIGN KEY (LastModifiedById) REFERENCES dbo.Users(UserId)
)

-- Campaigns --
CREATE TABLE dbo.Campaigns
(
	CampaignId INT IDENTITY(1,1) NOT NULL,
	CampaignTemplateId INT NULL,
	OrganisationId INT NOT NULL,	
	Name NVARCHAR(250) NOT NULL,
	Objective NVARCHAR(MAX) NULL,
	Description NVARCHAR(MAX) NULL,
	CampaignTypeId INT NOT NULL,
	ProposedStartOn DATETIME NULL,
	ActualStartOn DATETIME NULL,
	ProposedEndOn DATETIME NULL,
	ActualEndOn DATETIME NULL,
	EstimatedCost DECIMAL(10,2) NULL,
	ActualCost DECIMAL(10,2) NULL,
	EstimatedRevenue DECIMAL(10,2) NULL,
	ActualRevenue DECIMAL(10,2) NULL,
	MiscellaneousCost DECIMAL(10,2) NULL,
	TotalCost DECIMAL(10,2) NULL,
	CurrencyId INT NULL,
	CampaignStatusId INT NOT NULL,
	IsRecurring BIT NOT NULL CONSTRAINT [DF_Campaigns_IsRecurring] DEFAULT (0),
	ContactCount INT NOT NULL CONSTRAINT [DF_Campaigns_ContactCount] DEFAULT (0),
	ConvertedLeadCount INT NOT NULL CONSTRAINT [DF_Campaigns_ConvertedLeadCount] DEFAULT (0),
	LeadCount INT NOT NULL CONSTRAINT [DF_Campaigns_LeadCount] DEFAULT (0),
	OpportunityCount INT NOT NULL CONSTRAINT [DF_Campaigns_OpportunityCount] DEFAULT (0),
	EstimatedResponseCount INT NOT NULL CONSTRAINT [DF_Campaigns_EstimatedResponseCount] DEFAULT (0),
	ActualResponseCount INT NOT NULL CONSTRAINT [DF_Campaigns_ActualResponseCount] DEFAULT (0),
	WonOpportunityCount INT NOT NULL CONSTRAINT [DF_Campaigns_WonOpportunityCount] DEFAULT (0),
	NewsletterCount INT NOT NULL CONSTRAINT [DF_Campaigns_NewsletterCount] DEFAULT (0),
	PageImpressionCount INT NOT NULL CONSTRAINT [DF_Campaigns_PageImpressionCount] DEFAULT (0),
	ClickThroughCount INT NOT NULL CONSTRAINT [DF_Campaigns_ClickThroughCount] DEFAULT (0),
	InvalidEmailCount INT NOT NULL CONSTRAINT [DF_Campaigns_InvalidEmailCount] DEFAULT (0),
	OwnerId INT NOT NULL,				
	CreatedAt DATETIME NOT NULL,
	CreatedById INT NOT NULL,
	LastModifiedAt DATETIME NOT NULL,
	LastModifiedById INT NOT NULL,
	IsDeleted INT NOT NULL CONSTRAINT [DF_Campaigns_IsDeleted] DEFAULT (0),
	
	CONSTRAINT [PK_Campaigns] PRIMARY KEY (CampaignId),
	CONSTRAINT [FK_Campaigns_CampaignTemplateId] FOREIGN KEY (CampaignTemplateId) REFERENCES dbo.CampaignTemplates(CampaignTemplateId),
	CONSTRAINT [FK_Campaigns_OrganisationId] FOREIGN KEY (OrganisationId) REFERENCES dbo.Organisations(OrganisationId),
	CONSTRAINT [FK_Campaigns_CampaignTypeId] FOREIGN KEY (CampaignTypeId) REFERENCES dbo.CampaignTypes(CampaignTypeId),
	CONSTRAINT [FK_Campaigns_CurrencyId] FOREIGN KEY (CurrencyId) REFERENCES dbo.Currencies(CurrencyId),
	CONSTRAINT [FK_Campaigns_CampaignStatusId] FOREIGN KEY (CampaignStatusId) REFERENCES dbo.CampaignStatuses(CampaignStatusId),
	CONSTRAINT [FK_Campaigns_OwnerId] FOREIGN KEY (OwnerId) REFERENCES dbo.Users(UserId),
	CONSTRAINT [FK_Campaigns_CreatedById] FOREIGN KEY (CreatedById) REFERENCES dbo.Users(UserId),
	CONSTRAINT [FK_Campaigns_LastModifiedById] FOREIGN KEY (LastModifiedById) REFERENCES dbo.Users(UserId)
)

-- Campaign Tags --
CREATE TABLE dbo.CampaignTags
(	
	CampaignId INT NOT NULL,
	TagId INT NOT NULL,	
					
	CONSTRAINT [PK_CampaignTags] PRIMARY KEY CLUSTERED (CampaignId, TagId),
	CONSTRAINT [FK_CampaignTags_CampaignId] FOREIGN KEY (CampaignId) REFERENCES dbo.Campaigns(CampaignId),
	CONSTRAINT [FK_CampaignTags_TagId] FOREIGN KEY (TagId) REFERENCES dbo.Tags(TagId)
)

-- Campaign History --
CREATE TABLE dbo.CampaignHistory
(
	CampaignHistoryId INT IDENTITY(1,1) NOT NULL,
	CampaignId INT NOT NULL,
	FieldName NVARCHAR(250) NOT NULL,
	NewValue NVARCHAR(MAX) NOT NULL,
	OldValue NVARCHAR(MAX) NOT NULL,
	LastModifiedAt DATETIME NOT NULL,
	LastModifiedById INT NOT NULL,

	CONSTRAINT [PK_CampaignHistory] PRIMARY KEY (CampaignHistoryId),
	CONSTRAINT [FK_CampaignHistory_CampaignId] FOREIGN KEY (CampaignId) REFERENCES dbo.Campaigns(CampaignId),
	CONSTRAINT [FK_CampaignHistory_LastModifiedById] FOREIGN KEY (LastModifiedById) REFERENCES dbo.Users(UserId)
)

-- Lead Sources --
CREATE TABLE dbo.LeadSources
(	
	LeadSourceId INT NOT NULL,
	OrganisationId INT NULL,	
	Name NVARCHAR(250) NOT NULL,
					
	CONSTRAINT [PK_LeadSources] PRIMARY KEY (LeadSourceId),
	CONSTRAINT [FK_LeadSources_OrganisationId] FOREIGN KEY (OrganisationId) REFERENCES dbo.Organisations(OrganisationId)
)

-- Lead Statuses --
CREATE TABLE dbo.LeadStatuses
(	
	LeadStatusId INT NOT NULL,	
	OrganisationId INT NULL,
	Name NVARCHAR(250) NOT NULL,
	IsDefault BIT NOT NULL CONSTRAINT [DF_LeadStatuses_IsDefault] DEFAULT (0),
	IsConverted BIT NOT NULL CONSTRAINT [DF_LeadStatuses_IsConverted] DEFAULT (0),
					
	CONSTRAINT [PK_LeadStatuses] PRIMARY KEY (LeadStatusId),
	CONSTRAINT [FK_LeadStatuses_OrganisationId] FOREIGN KEY (OrganisationId) REFERENCES dbo.Organisations(OrganisationId)
)

-- Industries --
CREATE TABLE dbo.Industries
(	
	IndustryId INT IDENTITY(1,1) NOT NULL,
	OrganisationId INT NULL,	
	Name NVARCHAR(250) NOT NULL,
					
	CONSTRAINT [PK_Industries] PRIMARY KEY (IndustryId),
	CONSTRAINT [FK_Industries_OrganisationId] FOREIGN KEY (OrganisationId) REFERENCES dbo.Organisations(OrganisationId)
)

-- Leads --
CREATE TABLE dbo.Leads
(	
	LeadId INT NOT NULL,
	OrganisationId INT NOT NULL,	
	Title NVARCHAR(50) NULL,
	FirstName NVARCHAR(50) NULL,
	LastName NVARCHAR(50) NOT NULL,
	OrganisationName NVARCHAR(250) NULL,
	JobTitle NVARCHAR(50) NULL,
	WorkPhone NVARCHAR(50) NULL,
	HomePhone NVARCHAR(50) NULL,
	MobilePhone NVARCHAR(50) NULL,
	Fax NVARCHAR(50) NULL,
	Website NVARCHAR(250) NULL,	
	Email NVARCHAR(250) NULL,
	EmailBouncedReason NVARCHAR(MAX) NULL,
	EmailBouncedOn DATETIME NULL,
	DoNotPhone BIT NOT NULL CONSTRAINT [DF_Leads_DoNotPhone] DEFAULT (0),
	DoNotFax BIT NOT NULL CONSTRAINT [DF_Leads_DoNotFax] DEFAULT (0),
	DoNotEmail BIT NOT NULL CONSTRAINT [DF_Leads_DoNotEmail] DEFAULT (0),
	DoNotBulkEmail BIT NOT NULL CONSTRAINT [DF_Leads_DoNotBulkEmail] DEFAULT (0),
	DoNotMail BIT NOT NULL CONSTRAINT [DF_Leads_DoNotMail] DEFAULT (0),
	AddressLine1 NVARCHAR(250) NULL,
	AddressLine2 NVARCHAR(250) NULL,
	CityTown NVARCHAR(250) NULL,
	StateCounty NVARCHAR(250) NULL,
	PostalCode NVARCHAR(15) NULL,
	CountryId INT NULL,
	Rating INT NULL,
	LeadSourceId INT NULL,
	IndustryId INT NULL,
	EmployeeCount INT NULL,
	AnnualRevenue DECIMAL(10,2) NULL,
	CurrencyId INT NULL,
	LeadStatusId INT NULL,
	Description NVARCHAR(MAX) NULL,
	CampaignId INT NULL, -- The source campaign Id for the lead
	LastIncludedOn DATETIME NULL, -- The last date the Leads was included in a Marketing Campaigns
	IsConverted BIT NOT NULL CONSTRAINT [DF_Leads_IsConverted] DEFAULT (0),
	ConvertedAccountId INT NULL,
	ConvertedContactId INT NULL,
	ConvertedOpportunityId INT NULL,
	PreferredDay INT NULL,
	PreferredTime INT NULL,
	PreferredUserId INT NULL,
	IsUnreadByOwnerId BIT NOT NULL CONSTRAINT [DF_Leads_IsUnreadByOwnerId] DEFAULT (0),
	OwnerId INT NOT NULL,
	CreatedAt DATETIME NOT NULL,
	CreatedById INT NOT NULL,
	LastModifiedAt DATETIME NOT NULL,
	LastModifiedById INT NOT NULL,
	IsDeleted INT NOT NULL CONSTRAINT [DF_Leads_IsDeleted] DEFAULT (0),
					
	CONSTRAINT [PK_Leads] PRIMARY KEY (LeadId),
	CONSTRAINT [FK_Leads_OrganisationId] FOREIGN KEY (OrganisationId) REFERENCES dbo.Organisations(OrganisationId),
	CONSTRAINT [FK_Leads_CountryId] FOREIGN KEY (CountryId) REFERENCES dbo.Countries(CountryId),
	CONSTRAINT [FK_Leads_LeadsSourceId] FOREIGN KEY (LeadSourceId) REFERENCES dbo.LeadSources(LeadSourceId),
	CONSTRAINT [FK_Leads_IndustryId] FOREIGN KEY (IndustryId) REFERENCES dbo.Industries(IndustryId),
	CONSTRAINT [FK_Leads_CurrencyId] FOREIGN KEY (CurrencyId) REFERENCES dbo.Currencies(CurrencyId),
	CONSTRAINT [FK_Leads_LeadStatusId] FOREIGN KEY (LeadStatusId) REFERENCES dbo.LeadStatuses(LeadStatusId),
	CONSTRAINT [FK_Leads_CampaignId] FOREIGN KEY (CampaignId) REFERENCES dbo.Campaigns(CampaignId),
	CONSTRAINT [FK_Leads_PreferredUserId] FOREIGN KEY (PreferredUserId) REFERENCES dbo.Users(UserId),
	CONSTRAINT [FK_Leads_OwnerId] FOREIGN KEY (OwnerId) REFERENCES dbo.Users(UserId),
	CONSTRAINT [FK_Leads_CreatedById] FOREIGN KEY (CreatedById) REFERENCES dbo.Users(UserId),
	CONSTRAINT [FK_Leads_LastModifiedById] FOREIGN KEY (LastModifiedById) REFERENCES dbo.Users(UserId)
)

-- Lead Tags --
CREATE TABLE dbo.LeadTags
(	
	LeadId INT NOT NULL,
	TagId INT NOT NULL,	
					
	CONSTRAINT [PK_LeadTags] PRIMARY KEY CLUSTERED (LeadId, TagId),
	CONSTRAINT [FK_LeadTags_LeadId] FOREIGN KEY (LeadId) REFERENCES dbo.Leads(LeadId),
	CONSTRAINT [FK_LeadTags_TagId] FOREIGN KEY (TagId) REFERENCES dbo.Tags(TagId)
)

-- Lead History --
CREATE TABLE dbo.LeadHistory
(
	LeadHistoryId INT IDENTITY(1,1) NOT NULL,
	LeadId INT NOT NULL,
	FieldName NVARCHAR(250) NOT NULL,
	NewValue NVARCHAR(MAX) NOT NULL,
	OldValue NVARCHAR(MAX) NOT NULL,
	LastModifiedAt DATETIME NOT NULL,
	LastModifiedById INT NOT NULL,

	CONSTRAINT [PK_LeadHistory] PRIMARY KEY (LeadHistoryId),
	CONSTRAINT [FK_LeadHistory_LeadId] FOREIGN KEY (LeadId) REFERENCES dbo.Leads(LeadId),
	CONSTRAINT [FK_LeadHistory_LastModifiedById] FOREIGN KEY (LastModifiedById) REFERENCES dbo.Users(UserId)
)

-- Lead Shares --
CREATE TABLE dbo.LeadShares
(	
	LeadId INT NOT NULL,
	UserId INT NOT NULL,	
					
	CONSTRAINT [PK_LeadShares] PRIMARY KEY CLUSTERED (LeadId, UserId),
	CONSTRAINT [FK_LeadShares_LeadId] FOREIGN KEY (LeadId) REFERENCES dbo.Leads(LeadId),
	CONSTRAINT [FK_LeadShares_UserId] FOREIGN KEY (UserId) REFERENCES dbo.Users(UserId)
)

-- Account Types --
CREATE TABLE dbo.AccountTypes
(
	AccountTypeId INT IDENTITY(1,1) NOT NULL,
	Name NVARCHAR(250) NOT NULL,

	CONSTRAINT [PK_AccountTypes] PRIMARY KEY (AccountTypeId)
)

-- Preferred Contact Methods --
CREATE TABLE dbo.PreferredContactMethods
(
	PreferredContactMethodId INT IDENTITY(1,1) NOT NULL,
	Name NVARCHAR(250) NOT NULL,

	CONSTRAINT [PK_PreferredContactMethods] PRIMARY KEY (PreferredContactMethodId)
)

-- Territories --
CREATE TABLE dbo.Territories  
(
	TerritoryId INT IDENTITY(1,1) NOT NULL,
	OrganisationId INT NOT NULL,
	Name NVARCHAR(250) NOT NULL,
	Description NVARCHAR(MAX) NULL,
	ForecastManagerId INT NULL,
		
	CONSTRAINT [PK_Territories] PRIMARY KEY (TerritoryId),
	CONSTRAINT [FK_Territories_OrganisationId] FOREIGN KEY (OrganisationId) REFERENCES dbo.Organisations(OrganisationId),
	CONSTRAINT [FK_Territories_ForecastManagerId] FOREIGN KEY (ForecastManagerId) REFERENCES dbo.Users(UserId)
)

-- Accounts --
CREATE TABLE dbo.Accounts
(
	AccountId INT IDENTITY(1,1) NOT NULL,
	OrganisationId INT NOT NULL,
	Name NVARCHAR(250) NOT NULL,
	AccountTypeId INT NULL,
	ParentId INT NOT NULL CONSTRAINT [DF_Accounts_ParentId] DEFAULT (0),
	AccountNumber NVARCHAR(250) NULL,
	Phone NVARCHAR(50) NULL,
	Fax NVARCHAR(50) NULL,
	Website NVARCHAR(250) NULL,	
	Email NVARCHAR(250) NULL,
	DoNotPhone BIT NOT NULL CONSTRAINT [DF_Accounts_DoNotPhone] DEFAULT (0),
	DoNotFax BIT NOT NULL CONSTRAINT [DF_Accounts_DoNotFax] DEFAULT (0),
	DoNotEmail BIT NOT NULL CONSTRAINT [DF_Accounts_DoNotEmail] DEFAULT (0),
	DoNotBulkEmail BIT NOT NULL CONSTRAINT [DF_Accounts_DoNotBulkEmail] DEFAULT (0),
	DoNotMail BIT NOT NULL CONSTRAINT [DF_Accounts_DoNotMail] DEFAULT (0),
	PreferredContactMethodId INT NULL,		
	BillingAddressLine1 NVARCHAR(250) NULL,
	BillingAddressLine2 NVARCHAR(250) NULL,
	BillingCityTown NVARCHAR(250) NULL,
	BillingStateCounty NVARCHAR(250) NULL,
	BillingZipPostcode NVARCHAR(15) NULL,
	BillingCountryId INT NULL,
	ShippingAddressLine1 NVARCHAR(250) NULL,
	ShippingAddressLine2 NVARCHAR(250) NULL,
	ShippingCityTown NVARCHAR(250) NULL,
	ShippingStateCounty NVARCHAR(250) NULL,
	ShippingZipPostcode NVARCHAR(15) NULL,
	ShippingCountryId INT NULL,
	TerritoryId INT NULL,
	IndustryId INT NULL,
	EmployeeCount INT NULL,
	AnnualRevenue INT NULL,
	CurrencyId INT NULL,
	OnCreditHold BIT NOT NULL CONSTRAINT [DF_Accounts_OnCreditHold] DEFAULT (0),
	Description NVARCHAR(MAX) NULL,
	IsPersonAccount BIT NOT NULL CONSTRAINT [DF_Accounts_IsPersonAccount] DEFAULT (0),
	IsPreferredCustomer BIT NOT NULL CONSTRAINT [DF_Accounts_IsPreferredCustomer] DEFAULT (0),
	LeadId INT NULL, -- Originating lead
	PreferredDay INT NULL,
	PreferredTime INT NULL,
	PreferredUserId INT NULL,
	OwnerId INT NOT NULL,
	CreatedAt DATETIME NOT NULL,
	CreatedById INT NOT NULL,
	LastModifiedAt DATETIME NOT NULL,
	LastModifiedById INT NOT NULL,
	IsDeleted INT NOT NULL CONSTRAINT [DF_Accounts_IsDeleted] DEFAULT (0),

	CONSTRAINT [PK_Accounts] PRIMARY KEY (AccountId),
	CONSTRAINT [FK_Accounts_OrganisationId] FOREIGN KEY (OrganisationId) REFERENCES dbo.Organisations(OrganisationId),
	CONSTRAINT [FK_Accounts_AccountTypeId] FOREIGN KEY (AccountTypeId) REFERENCES dbo.AccountTypes(AccountTypeId),
	CONSTRAINT [FK_Accounts_PreferredContactMethodId] FOREIGN KEY (PreferredContactMethodId) REFERENCES dbo.PreferredContactMethods(PreferredContactMethodId),
	CONSTRAINT [FK_Accounts_BillingCountryId] FOREIGN KEY (BillingCountryId) REFERENCES dbo.Countries(CountryId),
	CONSTRAINT [FK_Accounts_ShippingCountryId] FOREIGN KEY (ShippingCountryId) REFERENCES dbo.Countries(CountryId),
	CONSTRAINT [FK_Accounts_TerritoryId] FOREIGN KEY (TerritoryId) REFERENCES dbo.Territories(TerritoryId),	
	CONSTRAINT [FK_Accounts_IndustryId] FOREIGN KEY (IndustryId) REFERENCES dbo.Industries(IndustryId),
	CONSTRAINT [FK_Accounts_CurrencyId] FOREIGN KEY (CurrencyId) REFERENCES dbo.Currencies(CurrencyId),
	CONSTRAINT [FK_Accounts_LeadId] FOREIGN KEY (LeadId) REFERENCES dbo.Leads(LeadId),
	CONSTRAINT [FK_Accounts_PreferredUserId] FOREIGN KEY (PreferredUserId) REFERENCES dbo.Users(UserId),
	CONSTRAINT [FK_Accounts_OwnerId] FOREIGN KEY (OwnerId) REFERENCES dbo.Users(UserId),
	CONSTRAINT [FK_Accounts_CreatedById] FOREIGN KEY (CreatedById) REFERENCES dbo.Users(UserId),
	CONSTRAINT [FK_Accounts_LastModifiedById] FOREIGN KEY (LastModifiedById) REFERENCES dbo.Users(UserId)
)

-- Account Tags --
CREATE TABLE dbo.AccountTags
(	
	AccountId INT NOT NULL,
	TagId INT NOT NULL,	
					
	CONSTRAINT [PK_AccountTags] PRIMARY KEY CLUSTERED (AccountId, TagId),
	CONSTRAINT [FK_AccountTags_AccountId] FOREIGN KEY (AccountId) REFERENCES dbo.Accounts(AccountId),
	CONSTRAINT [FK_AccountTags_TagId] FOREIGN KEY (TagId) REFERENCES dbo.Tags(TagId)
)

-- Account History --
CREATE TABLE dbo.AccountHistory
(
	AccountHistoryId INT IDENTITY(1,1) NOT NULL,
	AccountId INT NOT NULL,
	FieldName NVARCHAR(250) NOT NULL,
	NewValue NVARCHAR(MAX) NOT NULL,
	OldValue NVARCHAR(MAX) NOT NULL,
	LastModifiedAt DATETIME NOT NULL,
	LastModifiedById INT NOT NULL,

	CONSTRAINT [PK_AccountHistory] PRIMARY KEY (AccountHistoryId),
	CONSTRAINT [FK_AccountHistory_AccountId] FOREIGN KEY (AccountId) REFERENCES dbo.Accounts(AccountId),
	CONSTRAINT [FK_AccountHistory_LastModifiedById] FOREIGN KEY (LastModifiedById) REFERENCES dbo.Users(UserId)
)

-- Account Shares --
CREATE TABLE dbo.AccountShares
(
	AccountId INT NOT NULL,
	UserId INT NOT NULL, 

	CONSTRAINT [PK_AccountShares] PRIMARY KEY CLUSTERED (AccountId, UserId),
	CONSTRAINT [FK_AccountShares_AccountId] FOREIGN KEY (AccountId) REFERENCES dbo.Accounts(AccountId),
	CONSTRAINT [FK_AccountShares_UserId] FOREIGN KEY (UserId) REFERENCES dbo.Users(UserId)
)

-- Partner Roles --
CREATE TABLE dbo.PartnerRoles
(
	PartnerRoleId INT IDENTITY(1,1) NOT NULL,
	OrganisationId INT NOT NULL,
	Name NVARCHAR(250) NOT NULL,		

	CONSTRAINT [PK_PartnerRoles] PRIMARY KEY (PartnerRoleId),
	CONSTRAINT [FK_PartnerRoles_OrganisationId] FOREIGN KEY (OrganisationId) REFERENCES dbo.Organisations(OrganisationId)
)

-- Connection Status --
CREATE TABLE dbo.ConnectionStatuses
(
	ConnectionStatusId INT IDENTITY(1,1) NOT NULL,
	Name NVARCHAR(250) NOT NULL,		

	CONSTRAINT [PK_ConnectionStatuses] PRIMARY KEY (ConnectionStatusId)
)

-- Partners  --
CREATE TABLE dbo.Partners 
(
	PartnerId INT IDENTITY(1,1) NOT NULL,
	FromAccountId INT NOT NULL,
	ToAccountId INT NOT NULL,
	PartnerRoleId INT NULL,
	StartOn DATETIME NOT NULL,
	EndOn DATETIME NULL,
	ConnectionStatusId INT NOT NULL,
	CreatedAt DATETIME NOT NULL,
	CreatedById INT NOT NULL,
	LastModifiedAt DATETIME NOT NULL,
	LastModifiedById INT NOT NULL,
	IsDeleted INT NOT NULL CONSTRAINT [DF_Partners_IsDeleted] DEFAULT (0), 

	CONSTRAINT [PK_Partners] PRIMARY KEY (PartnerId),
	CONSTRAINT [FK_Partners_FromAccountId] FOREIGN KEY (FromAccountId) REFERENCES dbo.Accounts(AccountId),
	CONSTRAINT [FK_Partners_ToAccountId] FOREIGN KEY (ToAccountId) REFERENCES dbo.Accounts(AccountId),
	CONSTRAINT [FK_Partners_PartnerRoleId] FOREIGN KEY (PartnerRoleId) REFERENCES dbo.PartnerRoles(PartnerRoleId),
	CONSTRAINT [FK_Partners_CreatedById] FOREIGN KEY (CreatedById) REFERENCES dbo.Users(UserId),
	CONSTRAINT [FK_Partners_LastModifiedById] FOREIGN KEY (LastModifiedById) REFERENCES dbo.Users(UserId),
	CONSTRAINT [FK_Partners_ConnectionStatusId] FOREIGN KEY (ConnectionStatusId) REFERENCES dbo.ConnectionStatuses(ConnectionStatusId)
)

-- Marital Statuses --
CREATE TABLE dbo.MaritalStatuses
(
	MaritalStatusId INT IDENTITY(1,1) NOT NULL,
	Name NVARCHAR(50) NOT NULL,
	
	CONSTRAINT [PK_MaritalStatuses] PRIMARY KEY (MaritalStatusId)
)

-- Contacts --
CREATE TABLE dbo.Contacts
(
	ContactId INT IDENTITY(1,1) NOT NULL,
	OrganisationId INT NOT NULL,
	Title NVARCHAR(50) NULL,
	FirstName NVARCHAR(50) NULL,
	MiddleName NVARCHAR(50) NULL,
	LastName NVARCHAR(50) NOT NULL,
	Suffix NVARCHAR(50) NULL,
	Initials NVARCHAR(10) NULL,
	Salutation NVARCHAR(30) NULL,
	DateOfBirth DATETIME NULL,
	Gender nchar(1) NULL,
	MaritalStatusId INT NULL,
	HomePhone NVARCHAR(50) NULL,
	WorkPhone NVARCHAR(50) NULL,
	OtherPhone NVARCHAR(50) NULL,
	MobilePhone NVARCHAR(50) NULL,
	Fax NVARCHAR(50) NULL,
	Pager NVARCHAR(50) NULL,
	Website NVARCHAR(250) NULL,	
	Email NVARCHAR(250) NULL,		
	MailingAddressLine1 NVARCHAR(250) NULL,
	MailingAddressLine2 NVARCHAR(250) NULL,
	MailingCityTown NVARCHAR(250) NULL,
	MailingStateCounty NVARCHAR(250) NULL,
	MailingZipPostcode NVARCHAR(15) NULL,
	MailingCountryId INT NULL,
	OtherAddressLine1 NVARCHAR(250) NULL,
	OtherAddressLine2 NVARCHAR(250) NULL,
	OtherCityTown NVARCHAR(250) NULL,
	OtherStateCounty NVARCHAR(250) NULL,
	OtherZipPostcode NVARCHAR(15) NULL,
	OtherCountryId INT NULL,
	JobTitle NVARCHAR(50) NULL,
	ReportsToId INT NOT NULL CONSTRAINT [DF_Contacts_ReportsToId] DEFAULT (0),
	AssistantName NVARCHAR(250) NULL,	
	AssistantPhone NVARCHAR(50) NULL,	
	DoNotPhone BIT NOT NULL CONSTRAINT [DF_Contacts_DoNotPhone] DEFAULT (0),
	DoNotFax BIT NOT NULL CONSTRAINT [DF_Contacts_DoNotFax] DEFAULT (0),
	DoNotEmail BIT NOT NULL CONSTRAINT [DF_Contacts_DoNotEmail] DEFAULT (0),
	DoNotBulkEmail BIT NOT NULL CONSTRAINT [DF_Contacts_DoNotBulkEmail] DEFAULT (0),
	DoNotMail BIT NOT NULL CONSTRAINT [DF_Contacts_DoNotMail] DEFAULT (0),
	PreferredContactMethodId INT NULL,
	Description NVARCHAR(MAX) NULL,
	StayInTouchRequestDate DATETIME NULL,
	LeadId INT NULL, -- Originating lead
	PreferredDay INT NULL,
	PreferredTime INT NULL,
	PreferredUserId INT NULL,
	OwnerId INT NOT NULL,
	CreatedAt DATETIME NOT NULL,
	CreatedById INT NOT NULL,
	LastModifiedAt DATETIME NOT NULL,
	LastModifiedById INT NOT NULL,
	IsDeleted INT NOT NULL CONSTRAINT [DF_Contacts_IsDeleted] DEFAULT (0),

	CONSTRAINT [PK_Contacts] PRIMARY KEY (ContactId),
	CONSTRAINT [FK_Contacts_OrganisationId] FOREIGN KEY (OrganisationId) REFERENCES dbo.Organisations(OrganisationId),
	CONSTRAINT [FK_Contacts_MaritalStatusId] FOREIGN KEY (MaritalStatusId) REFERENCES dbo.MaritalStatuses(MaritalStatusId),
	CONSTRAINT [FK_Contacts_MailingCountryId] FOREIGN KEY (MailingCountryId) REFERENCES dbo.Countries(CountryId),
	CONSTRAINT [FK_Contacts_OtherCountryId] FOREIGN KEY (OtherCountryId) REFERENCES dbo.Countries(CountryId),
	CONSTRAINT [FK_Contacts_PreferredContactMethodId] FOREIGN KEY (PreferredContactMethodId) REFERENCES dbo.PreferredContactMethods(PreferredContactMethodId),
	CONSTRAINT [FK_Contacts_LeadId] FOREIGN KEY (LeadId) REFERENCES dbo.Leads(LeadId),
	CONSTRAINT [FK_Contacts_PreferredUserId] FOREIGN KEY (PreferredUserId) REFERENCES dbo.Users(UserId),
	CONSTRAINT [FK_Contacts_OwnerId] FOREIGN KEY (OwnerId) REFERENCES dbo.Users(UserId),
	CONSTRAINT [FK_Contacts_CreatedById] FOREIGN KEY (CreatedById) REFERENCES dbo.Users(UserId),
	CONSTRAINT [FK_Contacts_LastModifiedById] FOREIGN KEY (LastModifiedById) REFERENCES dbo.Users(UserId)
)

-- Contact Tages --
CREATE TABLE dbo.ContactTags
(	
	ContactId INT NOT NULL,
	TagId INT NOT NULL,	
					
	CONSTRAINT [PK_ContactTags] PRIMARY KEY CLUSTERED (ContactId, TagId),
	CONSTRAINT [FK_ContactTags_ContactId] FOREIGN KEY (ContactId) REFERENCES dbo.Contacts(ContactId),
	CONSTRAINT [FK_ContactTags_TagId] FOREIGN KEY (TagId) REFERENCES dbo.Tags(TagId)
)

-- Contact History --
CREATE TABLE dbo.ContactHistory
(
	ContactHistoryId INT IDENTITY(1,1) NOT NULL,
	ContactId INT NOT NULL,
	FieldName NVARCHAR(250) NOT NULL,
	NewValue NVARCHAR(MAX) NOT NULL,
	OldValue NVARCHAR(MAX) NOT NULL,
	LastModifiedAt DATETIME NOT NULL,
	LastModifiedById INT NOT NULL,

	CONSTRAINT [PK_ContactHistory] PRIMARY KEY (ContactHistoryId),
	CONSTRAINT [FK_ContactHistory_ContactId] FOREIGN KEY (ContactId) REFERENCES dbo.Contacts(ContactId),
	CONSTRAINT [FK_ContactHistory_LastModifiedById] FOREIGN KEY (LastModifiedById) REFERENCES dbo.Users(UserId)
)

-- Contact Shares --
CREATE TABLE dbo.ContactShares
(
	ContactId INT NOT NULL,	
	UserId INT NOT NULL,	

	CONSTRAINT [PK_ContactShares] PRIMARY KEY CLUSTERED (ContactId, UserId),
	CONSTRAINT [FK_ContactShares_ContactId] FOREIGN KEY (ContactId) REFERENCES dbo.Contacts(ContactId),
	CONSTRAINT [FK_ContactShares_UserId] FOREIGN KEY (UserId) REFERENCES dbo.Users(UserId)
)

-- Contact Roles --
CREATE TABLE dbo.ContactRoles
(
	ContactRoleId INT IDENTITY(1,1) NOT NULL,
	OrganisationId INT NULL,
	Name NVARCHAR(50) NOT NULL,
	
	CONSTRAINT [PK_ContactRoles] PRIMARY KEY (ContactRoleId),
	CONSTRAINT [FK_ContactRoles_OrganisationId] FOREIGN KEY (OrganisationId) REFERENCES dbo.Organisations(OrganisationId)
)

-- Account Contacts --
CREATE TABLE dbo.AccountContacts
(
	AccountId INT NOT NULL,
	ContactId INT NOT NULL,
	ContactRoleId INT NOT NULL,
	IsPrimary BIT NOT NULL CONSTRAINT [DF_AccountContacts_IsPrimary] DEFAULT (0),	

	CONSTRAINT [PK_AccountContacts] PRIMARY KEY CLUSTERED (AccountId, ContactId),
	CONSTRAINT [FK_AccountContacts_AccountId] FOREIGN KEY (AccountId) REFERENCES dbo.Accounts(AccountId),
	CONSTRAINT [FK_AccountContacts_ContactId] FOREIGN KEY (ContactId) REFERENCES dbo.Contacts(ContactId),
	CONSTRAINT [FK_AccountContacts_ContactRoleId] FOREIGN KEY (ContactRoleId) REFERENCES dbo.ContactRoles(ContactRoleId)
)

-- Target Lists --
CREATE TABLE dbo.TargetLists
(
	TargetListId INT IDENTITY(1,1) NOT NULL,
	OrganisationId INT NOT NULL,
	Name NVARCHAR(250) NOT NULL,
	AllowDuplicateEmails BIT NOT NULL CONSTRAINT [DF_TargetLists_AllowDuplicateEmails] DEFAULT (0),
	AutoSendLastCampaigns BIT NOT NULL CONSTRAINT [DF_TargetLists_AutoSendLastCampaigns] DEFAULT (1),
	CaptchaForSubscriptionEnabled BIT NOT NULL CONSTRAINT [DF_TargetLists_EnableCaptchaForSubscription] DEFAULT (0),
	RequiresName BIT NOT NULL CONSTRAINT [DF_TargetLists_RequiresName] DEFAULT (1),
	SendJoinOptOutNotifications BIT NOT NULL CONSTRAINT [DF_TargetLists_SendJoinOptOutNotifications] DEFAULT (1),
	JoinNotificationEmail NVARCHAR(MAX) NULL,
	OptOutNotificationEmail NVARCHAR(MAX) NULL,
	SendConfirmationEmail BIT NOT NULL CONSTRAINT [DF_TargetLists_SendConfirmationEmail] DEFAULT (1),
	ConfirmationRedirectUrl NVARCHAR(500) NULL,
	EnableOptOut BIT NOT NULL CONSTRAINT [DF_TargetLists_EnableOptOut] DEFAULT (0),
	AskForReason BIT NOT NULL CONSTRAINT [DF_TargetLists_AskForReason] DEFAULT (0),
	RemoveFromAllTargetListss BIT NOT NULL CONSTRAINT [DF_TargetLists_RemoveFromAllTargetListss] DEFAULT (0),
	OptOutUrl NVARCHAR(500) NULL,
	OptOutRedirectUrl NVARCHAR(500) NULL,
	SubscriberCount INT NOT NULL CONSTRAINT [DF_TargetLists_SubscriberCount] DEFAULT (0),
	UnsubscribedCount INT NOT NULL CONSTRAINT [DF_TargetLists_UnsubscribedCount] DEFAULT (0),
	OwnerId INT NOT NULL,
	CreatedAt DATETIME NOT NULL,
	CreatedById INT NOT NULL,
	LastModifiedAt DATETIME NOT NULL,
	LastModifiedById INT NOT NULL,
	IsDeleted INT NOT NULL CONSTRAINT [DF_TargetLists_IsDeleted] DEFAULT (0),

	CONSTRAINT [PK_TargetLists] PRIMARY KEY (TargetListId),
	CONSTRAINT [FK_TargetLists_OrganisationId] FOREIGN KEY (OrganisationId) REFERENCES dbo.Organisations(OrganisationId),
	CONSTRAINT [FK_TargetLists_OwnerId] FOREIGN KEY (OwnerId) REFERENCES dbo.Users(UserId),
	CONSTRAINT [FK_TargetLists_CreatedById] FOREIGN KEY (CreatedById) REFERENCES dbo.Users(UserId),
	CONSTRAINT [FK_TargetLists_LastModifiedById] FOREIGN KEY (LastModifiedById) REFERENCES dbo.Users(UserId)
)

-- Optout Reasons --
CREATE TABLE dbo.OptOutReasons
(	
	OptOutReasonId INT IDENTITY(1,1) NOT NULL,
	OrganisationId INT NULL,
	Name NVARCHAR(250) NOT NULL,		
					
	CONSTRAINT [PK_OptOutReasons] PRIMARY KEY (OptOutReasonId),
	CONSTRAINT [FK_OptOutReasons_OrganisationId] FOREIGN KEY (OrganisationId) REFERENCES dbo.Organisations(OrganisationId)
)

-- Target List Members  --
CREATE TABLE dbo.TargetListMembers
(
	TargetListMemberId INT IDENTITY(1,1) NOT NULL,
	TargetListId INT NOT NULL,
	ContactId INT NULL,
	LeadId INT NULL,
	OptedOutDate DATETIME NULL,
	OptOutReasonId INT NULL,
	OptOutOther NVARCHAR(MAX) NULL,
	IsActiveMember BIT NOT NULL CONSTRAINT [DF_TargetListMembers_IsActiveMember] DEFAULT (0),

	CONSTRAINT [PK_TargetListMembers] PRIMARY KEY CLUSTERED (TargetListMemberId),
	CONSTRAINT [FK_TargetListMembers_TargetListId] FOREIGN KEY (TargetListId) REFERENCES dbo.TargetLists(TargetListId),
	CONSTRAINT [FK_TargetListMembers_ContactId] FOREIGN KEY (ContactId) REFERENCES dbo.Contacts(ContactId),
	CONSTRAINT [FK_TargetListMembers_LeadId] FOREIGN KEY (LeadId) REFERENCES dbo.Leads(LeadId),
	CONSTRAINT [FK_TargetListMembers_OptOutReasonId] FOREIGN KEY (OptOutReasonId) REFERENCES dbo.OptOutReasons(OptOutReasonId)
)

-- Newsletters --
CREATE TABLE dbo.Newsletters
(
	NewsletterId INT IDENTITY(1,1) NOT NULL,
	OrganisationId INT NOT NULL,
	Name NVARCHAR(250) NOT NULL,
	EmailTemplateId INT NULL,
	Subject NVARCHAR(250) NULL,
	FromEmail NVARCHAR(250) NULL,
	FromName NVARCHAR(250) NULL,
	ReplyToEmail NVARCHAR(250) NULL,
	ReplyToName NVARCHAR(250) NULL,
	PlainTextBody NVARCHAR(MAX) NOT NULL,
	HtmlBody NVARCHAR(MAX) NOT NULL,
	IsBeingSent BIT NOT NULL CONSTRAINT [DF_Newsletters_IsBeingSent] DEFAULT (0),
	TestEmails NVARCHAR(MAX) NULL,
	DeliveredOn DATETIME NOT NULL,
	TimezoneOffset INT NOT NULL CONSTRAINT [DF_Newsletters_TimezoneOffset] DEFAULT (0),
	FailedMessage NVARCHAR(MAX) NULL,
	ConfirmationEmails NVARCHAR(MAX) NULL,
	ShowInArchive BIT NOT NULL CONSTRAINT [DF_Newsletters_ShowInArchive] DEFAULT (1),
	OwnerId INT NOT NULL,		
	CreatedAt DATETIME NOT NULL,
	CreatedById INT NOT NULL,
	LastModifiedAt DATETIME NOT NULL,
	LastModifiedById INT NOT NULL,
	IsDeleted INT NOT NULL CONSTRAINT [DF_Newsletters_IsDeleted] DEFAULT (0),

	CONSTRAINT [PK_Newsletters] PRIMARY KEY (NewsletterId),
	CONSTRAINT [FK_Newsletters_OrganisationId] FOREIGN KEY (OrganisationId) REFERENCES dbo.Organisations(OrganisationId),
	CONSTRAINT [FK_Newsletters_EmailTemplateId] FOREIGN KEY (EmailTemplateId) REFERENCES dbo.EmailTemplates(EmailTemplateId),
	CONSTRAINT [FK_Newsletters_OwnerId] FOREIGN KEY (OwnerId) REFERENCES dbo.Users(UserId),
	CONSTRAINT [FK_Newsletters_CreatedById] FOREIGN KEY (CreatedById) REFERENCES dbo.Users(UserId),
	CONSTRAINT [FK_Newsletters_LastModifiedById] FOREIGN KEY (LastModifiedById) REFERENCES dbo.Users(UserId)
)

-- Campaing Target Lists  --
CREATE TABLE dbo.CampaignTargetLists
(
	CampaignId INT IDENTITY(1,1) NOT NULL,
	TargetListId INT NOT NULL,

	CONSTRAINT [PK_CampaignTargetLists] PRIMARY KEY CLUSTERED (CampaignId, TargetListId),
	CONSTRAINT [FK_CampaignTargetLists_CampaignId] FOREIGN KEY (CampaignId) REFERENCES dbo.Campaigns(CampaignId),
	CONSTRAINT [FK_CampaignTargetLists_TargetListId] FOREIGN KEY (TargetListId) REFERENCES dbo.TargetLists(TargetListId)
)

-- Campaign Newsletters  --
CREATE TABLE dbo.CampaignNewsletters
(
	CampaignId INT IDENTITY(1,1) NOT NULL,
	NewsletterId INT NOT NULL,

	CONSTRAINT [PK_CampaignNewsletters] PRIMARY KEY CLUSTERED (CampaignId, NewsletterId),
	CONSTRAINT [FK_CampaignNewsletters_CampaignId] FOREIGN KEY (CampaignId) REFERENCES dbo.Campaigns(CampaignId),
	CONSTRAINT [FK_CampaignNewsletters_NewsletterId] FOREIGN KEY (NewsletterId) REFERENCES dbo.Newsletters(NewsletterId)
)

-------------------------------------------------------
-- Products
-------------------------------------------------------

-- Pricing Models --
CREATE TABLE dbo.PricingModels
(	
	PricingModelId INT NOT NULL,
	OrganisationId INT NULL,
	Name NVARCHAR(250) NOT NULL,		
					
	CONSTRAINT [PK_PricingModels] PRIMARY KEY (PricingModelId),
	CONSTRAINT [FK_PricingModels_OrganisationId] FOREIGN KEY (OrganisationId) REFERENCES dbo.Organisations(OrganisationId)
)

-- Price Books --
CREATE TABLE dbo.PriceBooks
(
	PriceBookId INT IDENTITY(1,1) NOT NULL,
	OrganisationId INT NOT NULL,
	Name NVARCHAR(250) NOT NULL,
	Description NVARCHAR(MAX) NULL,
	PricingModelId INT NOT NULL,
	StartRange DECIMAL(10,2) NOT NULL,
	EndRange DECIMAL(10,2) NOT NULL,
	Discount DECIMAL(10,2) NOT NULL,
	OwnerId INT NOT NULL,		
	CreatedAt DATETIME NOT NULL,
	CreatedById INT NOT NULL,
	LastModifiedAt DATETIME NOT NULL,
	LastModifiedById INT NOT NULL,
	IsDeleted INT NOT NULL CONSTRAINT [DF_PriceBooks_IsDeleted] DEFAULT (0),
	
	CONSTRAINT [PK_PriceBooks] PRIMARY KEY (PriceBookId),
	CONSTRAINT [FK_PriceBooks_OrganisationId] FOREIGN KEY (OrganisationId) REFERENCES dbo.Organisations(OrganisationId),
	CONSTRAINT [FK_PriceBooks_PricingModelId] FOREIGN KEY (PricingModelId) REFERENCES dbo.PricingModels(PricingModelId),
	CONSTRAINT [FK_PriceBooks_OwnerId] FOREIGN KEY (OwnerId) REFERENCES dbo.Users(UserId),
	CONSTRAINT [FK_PriceBooks_CreatedById] FOREIGN KEY (CreatedById) REFERENCES dbo.Users(UserId),
	CONSTRAINT [FK_PriceBooks_LastModifiedById] FOREIGN KEY (LastModifiedById) REFERENCES dbo.Users(UserId)
)

-- Product Types --
CREATE TABLE dbo.ProductTypes
(
	ProductTypeId INT IDENTITY(1,1) NOT NULL,
	OrganisationId INT NULL,
	Name NVARCHAR(50) NOT NULL,
	
	CONSTRAINT [PK_ProductTypes] PRIMARY KEY (ProductTypeId),
	CONSTRAINT [FK_ProductTypes_OrganisationId] FOREIGN KEY (OrganisationId) REFERENCES dbo.Organisations(OrganisationId)
)

-- Vendors --
CREATE TABLE dbo.Vendors
(
	VendorId INT IDENTITY(1,1) NOT NULL,
	OrganisationId INT NOT NULL,
	Name NVARCHAR(250) NOT NULL,
	IndustryId INT NOT NULL,
	AddressLine1 NVARCHAR(250) NULL,
	AddressLine2 NVARCHAR(250) NULL,
	CityTown NVARCHAR(250) NULL,
	StateCounty NVARCHAR(250) NULL,
	PostalCode NVARCHAR(15) NULL,
	CountryId INT NULL,
	Phone NVARCHAR(50) NULL,
	Fax NVARCHAR(250) NULL,
	Email NVARCHAR(250) NULL,	
	OwnerId INT NOT NULL,
	CreatedAt DATETIME NOT NULL,
	CreatedById INT NOT NULL,
	LastModifiedAt DATETIME NOT NULL,
	LastModifiedById INT NOT NULL,
	IsDeleted INT NOT NULL CONSTRAINT [DF_Vendors_IsDeleted] DEFAULT (0),

	CONSTRAINT [PK_Vendors] PRIMARY KEY (VendorId),
	CONSTRAINT [FK_Vendors_OrganisationId] FOREIGN KEY (OrganisationId) REFERENCES dbo.Organisations(OrganisationId),
	CONSTRAINT [FK_Vendors_IndustryId] FOREIGN KEY (IndustryId) REFERENCES dbo.Industries(IndustryId),
	CONSTRAINT [FK_Vendors_OwnerId] FOREIGN KEY (OwnerId) REFERENCES dbo.Users(UserId),
	CONSTRAINT [FK_Vendors_CreatedById] FOREIGN KEY (CreatedById) REFERENCES dbo.Users(UserId),
	CONSTRAINT [FK_Vendors_LastModifiedById] FOREIGN KEY (LastModifiedById) REFERENCES dbo.Users(UserId)
)

-- Products --
CREATE TABLE dbo.Products
(
	ProductId INT IDENTITY(1,1) NOT NULL,
	OrganisationId INT NOT NULL,
	Name NVARCHAR(250) NOT NULL,
	Description NVARCHAR(MAX) NULL,
	ProductNumber NVARCHAR(250) NOT NULL,
	ProductTypeId INT NOT NULL,
	StandardPrice DECIMAL(10,2) NULL,
	CurrentPrice DECIMAL(10,2) NULL,
	UnitsInStock INT NULL,
	UnitsOnOrder INT NULL,
	ReorderLevel INT NULL,
	VendorId INT NULL,
	VendorPartNumber NVARCHAR(250) NULL,
	StockWeight DECIMAL(10,2) NULL,
	StockVolume DECIMAL(10,2) NULL,
	IsTaxable BIT NOT NULL CONSTRAINT [DF_Products_IsTaxable] DEFAULT (0),	
	IsSuspended BIT NOT NULL CONSTRAINT [DF_Products_IsSuspended] DEFAULT (0),	
	OwnerId INT NOT NULL,		
	CreatedAt DATETIME NOT NULL,
	CreatedById INT NOT NULL,
	LastModifiedAt DATETIME NOT NULL,
	LastModifiedById INT NOT NULL,
	IsDeleted INT NOT NULL CONSTRAINT [DF_Products_IsDeleted] DEFAULT (0),	
	
	CONSTRAINT [PK_Products] PRIMARY KEY (ProductId),
	CONSTRAINT [FK_Products_OrganisationId] FOREIGN KEY (OrganisationId) REFERENCES dbo.Organisations(OrganisationId),
	CONSTRAINT [FK_Products_ProductTypeId] FOREIGN KEY (ProductTypeId) REFERENCES dbo.ProductTypes(ProductTypeId),
	CONSTRAINT [FK_Products_VendorId] FOREIGN KEY (VendorId) REFERENCES dbo.Vendors(VendorId),
	CONSTRAINT [FK_Products_OwnerId] FOREIGN KEY (OwnerId) REFERENCES dbo.Users(UserId),
	CONSTRAINT [FK_Products_CreatedById] FOREIGN KEY (CreatedById) REFERENCES dbo.Users(UserId),
	CONSTRAINT [FK_Products_LastModifiedById] FOREIGN KEY (LastModifiedById) REFERENCES dbo.Users(UserId)
)

-- Price Book Items --
CREATE TABLE dbo.PriceBookItems
(
	PriceBookId INT NOT NULL,
	ProductId INT NOT NULL,
	CurrencyId INT NOT NULL,
	UnitPrice INT NOT NULL,
	UseStandardPrice BIT NOT NULL CONSTRAINT [DF_PriceBooksItem_UseStandardPrice] DEFAULT (0),
	
	CONSTRAINT [PK_PriceBookItems] PRIMARY KEY CLUSTERED (PriceBookId, ProductId),
	CONSTRAINT [FK_PriceBookItems_PriceBookId] FOREIGN KEY (PriceBookId) REFERENCES dbo.PriceBooks(PriceBookId),
	CONSTRAINT [FK_PriceBookItems_ProductId] FOREIGN KEY (ProductId) REFERENCES dbo.Products(ProductId),
	CONSTRAINT [FK_PriceBookItems_CurrencyId] FOREIGN KEY (CurrencyId) REFERENCES dbo.Currencies(CurrencyId)
)

-- Contract Statuses --
CREATE TABLE dbo.ContractStatuses
(
	ContractStatusId INT IDENTITY(1,1) NOT NULL,
	OrganisationId INT NULL,
	Name NVARCHAR(50) NOT NULL,
	IsDefault BIT NOT NULL CONSTRAINT [DF_ContractStatuses_IsDefault] DEFAULT (0),
	
	CONSTRAINT [PK_ContractStatuses] PRIMARY KEY (ContractStatusId),
	CONSTRAINT [FK_ContractStatuses_OrganisationId] FOREIGN KEY (OrganisationId) REFERENCES dbo.Organisations(OrganisationId)
)

-- Contracts --
CREATE TABLE dbo.Contracts
(
	ContractId INT IDENTITY(1,1) NOT NULL,
	OrganisationId INT NOT NULL,
	AccountId INT NOT NULL,
	Name NVARCHAR(250) NOT NULL,
	Description NVARCHAR(MAX) NULL,
	PriceBookId INT NULL,
	ContractStatusId INT NOT NULL,
	ActivatedOn DATETIME NULL,
	ActivatedById INT NULL,
	ContractNumber NVARCHAR(250) NOT NULL,
	ContractTerm INT NULL,
	Discount INT NULL,
	Tax DECIMAL(10,2) NULL,	
	TotalPrice DECIMAL(10,2) NULL,
	CustomerSignedOn DATETIME NULL,
	CustomerSignedById INT NULL,
	StartOn DATETIME NULL,
	EndOn DATETIME NULL,
	LastActivityOn DATETIME NULL,
	LastApprovedOn DATETIME NULL,
	SpecialTerms NVARCHAR(MAX) NULL,
	OwnerExpirationNotice NVARCHAR(MAX) NULL,
	LineItemCount INT NOT NULL CONSTRAINT [DF_Contracts_LineItemCount] DEFAULT (0),
	IsServiceContract BIT NOT NULL CONSTRAINT [DF_Contracts_IsServiceContract] DEFAULT (0),
	OwnerId INT NOT NULL,
	CreatedAt DATETIME NOT NULL,
	CreatedById INT NOT NULL,
	LastModifiedAt DATETIME NOT NULL,
	LastModifiedById INT NOT NULL,
	IsDeleted INT NOT NULL CONSTRAINT [DF_Contracts_IsDeleted] DEFAULT (0),

	CONSTRAINT [PK_Contracts] PRIMARY KEY (ContractId),
	CONSTRAINT [FK_Contracts_OrganisationId] FOREIGN KEY (OrganisationId) REFERENCES dbo.Organisations(OrganisationId),
	CONSTRAINT [FK_Contracts_AccountId] FOREIGN KEY (AccountId) REFERENCES dbo.Accounts(AccountId),	
	CONSTRAINT [FK_Contracts_PriceBookId] FOREIGN KEY (PriceBookId) REFERENCES dbo.PriceBooks(PriceBookId),	
	CONSTRAINT [FK_Contracts_ContractStatusId] FOREIGN KEY (ContractStatusId) REFERENCES dbo.ContractStatuses(ContractStatusId),	
	CONSTRAINT [FK_Contracts_ActivatedById] FOREIGN KEY (ActivatedById) REFERENCES dbo.Users(UserId),
	CONSTRAINT [FK_Contracts_CustomerSignedById] FOREIGN KEY (CustomerSignedById) REFERENCES dbo.Users(UserId),
	CONSTRAINT [FK_Contracts_OwnerId] FOREIGN KEY (OwnerId) REFERENCES dbo.Users(UserId),
	CONSTRAINT [FK_Contracts_CreatedById] FOREIGN KEY (CreatedById) REFERENCES dbo.Users(UserId),
	CONSTRAINT [FK_Contracts_LastModifiedById] FOREIGN KEY (LastModifiedById) REFERENCES dbo.Users(UserId)
)

-- Approvals --
CREATE TABLE dbo.Approvals
(
	ApprovalId INT IDENTITY(1,1) NOT NULL,
	ContractId INT NOT NULL,
	ContractStatusId INT NOT NULL,
	RequestComment NVARCHAR(MAX) NULL,
	ApproveComment NVARCHAR(MAX) NULL,
	OwnerId INT NOT NULL,
	IsDeleted INT NOT NULL CONSTRAINT [DF_Approvals_IsDeleted] DEFAULT (0),
	
	CONSTRAINT [PK_Approvals] PRIMARY KEY (ApprovalId),
	CONSTRAINT [FK_Approvals_ContractId] FOREIGN KEY (ContractId) REFERENCES dbo.Contracts(ContractId),	
	CONSTRAINT [FK_Approvals_ContractStatusId] FOREIGN KEY (ContractStatusId) REFERENCES dbo.ContractStatuses(ContractStatusId),	
	CONSTRAINT [FK_Approvals_OwnerId] FOREIGN KEY (OwnerId) REFERENCES dbo.Users(UserId)
)

-- Contract Contacts --
CREATE TABLE dbo.ContractContacts
(
	ContractId INT NOT NULL,
	ContactId INT NOT NULL,
	ContactRoleId INT NOT NULL,
	IsPrimary BIT NOT NULL CONSTRAINT [DF_ContractContacts_IsPrimary] DEFAULT (0),

	CONSTRAINT [PK_ContractContacts] PRIMARY KEY CLUSTERED (ContractId, ContactId),
	CONSTRAINT [FK_ContractContacts_ContractId] FOREIGN KEY (ContractId) REFERENCES dbo.Contracts(ContractId),
	CONSTRAINT [FK_ContractContacts_ContactId] FOREIGN KEY (ContactId) REFERENCES dbo.Contacts(ContactId),
	CONSTRAINT [FK_ContractContacts_ContactRoleId] FOREIGN KEY (ContactRoleId) REFERENCES dbo.ContactRoles(ContactRoleId)
)

-- Contract Tags --
CREATE TABLE dbo.ContractTags
(	
	ContractId INT NOT NULL,
	TagId INT NOT NULL,	
					
	CONSTRAINT [PK_ContractTags] PRIMARY KEY CLUSTERED (ContractId, TagId),
	CONSTRAINT [FK_ContractTags_ContractId] FOREIGN KEY (ContractId) REFERENCES dbo.Contracts(ContractId),
	CONSTRAINT [FK_ContractTags_TagId] FOREIGN KEY (TagId) REFERENCES dbo.Tags(TagId)
)

-- Contract History --
CREATE TABLE dbo.ContractHistory
(
	ContractHistoryId INT IDENTITY(1,1) NOT NULL,
	ContractId INT NOT NULL,
	FieldName NVARCHAR(250) NOT NULL,
	NewValue NVARCHAR(MAX) NOT NULL,
	OldValue NVARCHAR(MAX) NOT NULL,
	LastModifiedAt DATETIME NOT NULL,
	LastModifiedById INT NOT NULL,

	CONSTRAINT [PK_ContractHistory] PRIMARY KEY (ContractHistoryId),
	CONSTRAINT [FK_ContractHistory_ContractId] FOREIGN KEY (ContractId) REFERENCES dbo.Contracts(ContractId),
	CONSTRAINT [FK_ContractHistory_LastModifiedById] FOREIGN KEY (LastModifiedById) REFERENCES dbo.Users(UserId)
)

-- Opportunity Types --
CREATE TABLE dbo.OpportunityTypes
(
	OpportunityTypeId INT IDENTITY(1,1) NOT NULL,
	OrganisationId INT NULL,
	Name NVARCHAR(250) NOT NULL,
	
	CONSTRAINT [PK_OpportunityTypes] PRIMARY KEY (OpportunityTypeId),
	CONSTRAINT [FK_OpportunityTypes_OrganisationId] FOREIGN KEY (OrganisationId) REFERENCES dbo.Organisations(OrganisationId)
)

-- Sales Stage --
CREATE TABLE dbo.SalesStages
(
	SalesStageId INT IDENTITY(1,1) NOT NULL,
	OrganisationId INT NOT NULL,
	Name NVARCHAR(250) NOT NULL,
	DefaultProbability INT NOT NULL,
	IsDefault BIT NOT NULL CONSTRAINT [DF_SalesStages_IsDefault] DEFAULT (0),
	IsWon BIT NOT NULL CONSTRAINT [DF_SalesStages_IsWon] DEFAULT (0),	
		
	CONSTRAINT [PK_SalesStages] PRIMARY KEY (SalesStageId),
	CONSTRAINT [FK_SalesStages_OrganisationId] FOREIGN KEY (OrganisationId) REFERENCES dbo.Organisations(OrganisationId)
)

-- Opportunities --
CREATE TABLE dbo.Opportunities
(
	OpportunityId INT IDENTITY(1,1) NOT NULL,
	OrganisationId INT NOT NULL,
	Name NVARCHAR(250) NOT NULL,
	Description NVARCHAR(MAX) NULL,
	AccountId INT NOT NULL,
	OpportunityTypeId INT NULL,
	SalesStageId INT NOT NULL,
	TerritoryId INT NULL,
	Probability INT NULL,
	Rating INT NULL,
	LeadId INT NULL, -- The originating lead
	CampaignId INT NULL, -- The source campaign
	NextStep NVARCHAR(MAX) NULL,
	EstimatedRevenue DECIMAL(10,2) NULL,
	IsSystemCalculated BIT NOT NULL CONSTRAINT [DF_Opportunities_IsSystemCalculated] DEFAULT (1),			
	PriceBookId INT NULL,
	CurrencyId INT NOT NULL,
	ShippingAmount DECIMAL(10,2) NULL,
	Discount INT NULL,
	Tax DECIMAL(10,2) NOT NULL,
	SubTotal DECIMAL(10,2) NOT NULL,	
	TotalAmount DECIMAL(10,2) NOT NULL,		
	TotalOpportunitiesQuantity INT NULL,		
	FiscalPeriodId INT NULL,		
	EstimatedCloseOn DATETIME NULL,
	IsClosed BIT NOT NULL CONSTRAINT [DF_Opportunities_IsClosed] DEFAULT (0),	
	IsWon BIT NOT NULL CONSTRAINT [DF_Opportunities_IsWon] DEFAULT (0),
	LastActivityOn DATETIME NULL,
	OwnerId INT NOT NULL,
	CreatedAt DATETIME NOT NULL,
	CreatedById INT NOT NULL,
	LastModifiedAt DATETIME NOT NULL,
	LastModifiedById INT NOT NULL,
	IsDeleted INT NOT NULL CONSTRAINT [DF_Opportunities_IsDeleted] DEFAULT (0),		

	CONSTRAINT [PK_Opportunities] PRIMARY KEY (OpportunityId),
	CONSTRAINT [FK_Opportunities_OrganisationId] FOREIGN KEY (OrganisationId) REFERENCES dbo.Organisations(OrganisationId),
	CONSTRAINT [FK_Opportunities_AccountId] FOREIGN KEY (AccountId) REFERENCES dbo.Accounts(AccountId),
	CONSTRAINT [FK_Opportunities_OpportunityTypeId] FOREIGN KEY (OpportunityTypeId) REFERENCES dbo.OpportunityTypes(OpportunityTypeId),
	CONSTRAINT [FK_Opportunities_SalesStageId] FOREIGN KEY (SalesStageId) REFERENCES dbo.SalesStages(SalesStageId),
	CONSTRAINT [FK_Opportunities_TerritoryId] FOREIGN KEY (TerritoryId) REFERENCES dbo.Territories(TerritoryId),
	CONSTRAINT [FK_Opportunities_LeadId] FOREIGN KEY (LeadId) REFERENCES dbo.Leads(LeadId),		
	CONSTRAINT [FK_Opportunities_CampaignId] FOREIGN KEY (CampaignId) REFERENCES dbo.Campaigns(CampaignId),		
	CONSTRAINT [FK_Opportunities_PriceBookId] FOREIGN KEY (PriceBookId) REFERENCES dbo.PriceBooks(PriceBookId),
	CONSTRAINT [FK_Opportunities_CurrencyId] FOREIGN KEY (CurrencyId) REFERENCES dbo.Currencies(CurrencyId),		
	CONSTRAINT [FK_Opportunities_FiscalPeriodId] FOREIGN KEY (FiscalPeriodId) REFERENCES dbo.FiscalPeriods(FiscalPeriodId),		
	CONSTRAINT [FK_Opportunities_OwnerId] FOREIGN KEY (OwnerId) REFERENCES dbo.Users(UserId),
	CONSTRAINT [FK_Opportunities_CreatedById] FOREIGN KEY (CreatedById) REFERENCES dbo.Users(UserId),
	CONSTRAINT [FK_Opportunities_LastModifiedById] FOREIGN KEY (LastModifiedById) REFERENCES dbo.Users(UserId)
)

-- Opportunity Items --
CREATE TABLE dbo.OpportunityItems
(
	OpportunityId INT NOT NULL,
	PriceBookItemId INT NOT NULL,
	PricePerUnit DECIMAL(10,2) NOT NULL,
	Quantity INT NOT NULL,
	Discount INT NULL,
	Tax DECIMAL(10,2) NOT NULL,	
	LineTotal DECIMAL(10,2) NOT NULL,
	PartnerId INT NULL,
	HasPaymentSchedules BIT NOT NULL CONSTRAINT [DF_OpportunityItems_HasPaymentSchedules] DEFAULT (0),
	
	CONSTRAINT [PK_OpportunityItems] PRIMARY KEY CLUSTERED (OpportunityId, PriceBookItemId),
	CONSTRAINT [FK_OpportunityItems_OpportunityId] FOREIGN KEY (OpportunityId) REFERENCES dbo.Opportunities(OpportunityId),
	CONSTRAINT [FK_OpportunityItems_PartnerId] FOREIGN KEY (PartnerId) REFERENCES dbo.Partners(PartnerId)
)

-- Opportunity Contacts --
CREATE TABLE dbo.OpportunityContacts
(
	OpportunityId INT NOT NULL,
	ContactId INT NOT NULL,
	ContactRoleId INT NULL,
	IsPrimary BIT NOT NULL CONSTRAINT [DF_OpportunityContacts_IsPrimary] DEFAULT (0), 

	CONSTRAINT [PK_OpportunityContacts] PRIMARY KEY CLUSTERED (OpportunityId, ContactId),
	CONSTRAINT [FK_OpportunityContacts_OpportunityId] FOREIGN KEY (OpportunityId) REFERENCES dbo.Opportunities(OpportunityId),
	CONSTRAINT [FK_OpportunityContacts_ContactId] FOREIGN KEY (ContactId) REFERENCES dbo.Contacts(ContactId),
	CONSTRAINT [FK_OpportunityContacts_ContactRoleId] FOREIGN KEY (ContactRoleId) REFERENCES dbo.ContactRoles(ContactRoleId)
)

-- Opportunity Shares --
CREATE TABLE dbo.OpportunityShares
(
	OpportunityId INT NOT NULL,	
	UserId INT NOT NULL,	

	CONSTRAINT [PK_OpportunityShares] PRIMARY KEY CLUSTERED (OpportunityId, UserId),
	CONSTRAINT [FK_OpportunityShares_OpportunityId] FOREIGN KEY (OpportunityId) REFERENCES dbo.Opportunities(OpportunityId),
	CONSTRAINT [FK_OpportunityShares_UserId] FOREIGN KEY (UserId) REFERENCES dbo.Users(UserId)
)

-- Quote Statuses --
CREATE TABLE dbo.QuoteStatuses
(
	QuoteStatusId INT IDENTITY(1,1) NOT NULL,
	OrganisationId INT NULL,
	Name NVARCHAR(250) NOT NULL,
	IsDefault BIT NOT NULL CONSTRAINT [DF_QuoteStatuses_IsDefault] DEFAULT (0),
	
	CONSTRAINT [PK_QuoteStatuses] PRIMARY KEY (QuoteStatusId),
	CONSTRAINT [FK_QuoteStatuses_OrganisationId] FOREIGN KEY (OrganisationId) REFERENCES dbo.Organisations(OrganisationId)
)

-- Shipping Methods --
CREATE TABLE dbo.ShippingMethods
(
	ShippingMethodId INT IDENTITY(1,1) NOT NULL,
	OrganisationId INT NULL,
	Name NVARCHAR(250) NOT NULL,
	
	CONSTRAINT [PK_ShippingMethods] PRIMARY KEY (ShippingMethodId),
	CONSTRAINT [FK_ShippingMethods_OrganisationId] FOREIGN KEY (OrganisationId) REFERENCES dbo.Organisations(OrganisationId)	
)

-- Quotes --
CREATE TABLE dbo.Quotes
(
	QuoteId INT IDENTITY(1,1) NOT NULL,
	OrganisationId INT NOT NULL,
	Name NVARCHAR(250) NOT NULL,
	Description NVARCHAR(MAX) NULL,
	QuoteNumber NVARCHAR(250) NOT NULL,
	QuoteStatusId INT NOT NULL,
	ContactId INT NULL,
	PriceBookId INT NULL,
	ExpiresAt DATETIME NULL,
	IsSyncedWithOpportunities BIT NOT NULL CONSTRAINT [DF_Quotes_IsSyncedWithOpportunities] DEFAULT (0),
	OpportunityId INT NULL,
	CampaignId INT NULL,
	QuoteToName NVARCHAR(250) NULL, 
	QuoteToAddressLine1 NVARCHAR(250) NULL,
	QuoteToAddressLine2 NVARCHAR(250) NULL,
	QuoteToCityTown NVARCHAR(250) NULL,
	QuoteToStateCounty NVARCHAR(250) NULL,
	QuoteToZipPostcode NVARCHAR(15) NULL,
	QuoteToCountryId INT NULL,
	QuoteToPhone NVARCHAR(50) NULL,
	QuoteToFax NVARCHAR(250) NULL,
	BillingName NVARCHAR(250) NOT NULL,
	BillingAddressLine1 NVARCHAR(250) NOT NULL,
	BillingAddressLine2 NVARCHAR(250) NULL,
	BillingCityTown NVARCHAR(250) NULL,
	BillingStateCounty NVARCHAR(250) NULL,
	BillingZipPostcode NVARCHAR(15) NOT NULL,
	BillingCountryId INT NOT NULL,
	BillingPhone NVARCHAR(50) NULL,
	BillingFax NVARCHAR(250) NULL,
	ShippingName NVARCHAR(250) NOT NULL,
	ShippingAddressLine1 NVARCHAR(250) NOT NULL,
	ShippingAddressLine2 NVARCHAR(250) NULL,
	ShippingCityTown NVARCHAR(250) NULL,
	ShippingStateCounty NVARCHAR(250) NULL,
	ShippingZipPostcode NVARCHAR(15) NULL,
	ShippingCountryId INT NOT NULL,
	ShippingPhone NVARCHAR(50) NULL,
	ShippingFax NVARCHAR(250) NULL,
	ShippingMethodId INT NULL,
	RequestedDeliveryDate DATETIME NULL,		
	CurrencyId INT NOT NULL,
	ExchangeRate DECIMAL(10,2) NOT NULL,
	ShippingAmount DECIMAL(10,2) NULL,
	Discount INT NULL,
	Tax DECIMAL(10,2) NOT NULL,
	SubTotal DECIMAL(10,2) NOT NULL,	
	TotalAmount DECIMAL(10,2) NOT NULL,
	LineItemCount INT NOT NULL CONSTRAINT [DF_Quotes_LineItemCount] DEFAULT (0),		
	OwnerId INT NOT NULL,		
	CreatedAt DATETIME NOT NULL,
	CreatedById INT NOT NULL,
	LastModifiedAt DATETIME NOT NULL,
	LastModifiedById INT NOT NULL,
	IsDeleted INT NOT NULL CONSTRAINT [DF_Quotes_IsDeleted] DEFAULT (0),

	CONSTRAINT [PK_Quotes] PRIMARY KEY (QuoteId),
	CONSTRAINT [FK_Quotes_OrganisationId] FOREIGN KEY (OrganisationId) REFERENCES dbo.Organisations(OrganisationId),	
	CONSTRAINT [FK_Quotes_QuoteStatusId] FOREIGN KEY (QuoteStatusId) REFERENCES dbo.QuoteStatuses(QuoteStatusId),
	CONSTRAINT [FK_Quotes_ContactId] FOREIGN KEY (ContactId) REFERENCES dbo.Contacts(ContactId),
	CONSTRAINT [FK_Quotes_PriceBookId] FOREIGN KEY (PriceBookId) REFERENCES dbo.PriceBooks(PriceBookId),
	CONSTRAINT [FK_Quotes_OpportunityId] FOREIGN KEY (OpportunityId) REFERENCES dbo.Opportunities(OpportunityId),
	CONSTRAINT [FK_Quotes_CampaignId] FOREIGN KEY (CampaignId) REFERENCES dbo.Campaigns(CampaignId),
	CONSTRAINT [FK_Quotes_QuoteToCountryId] FOREIGN KEY (QuoteToCountryId) REFERENCES dbo.Countries(CountryId),
	CONSTRAINT [FK_Quotes_BillingCountryId] FOREIGN KEY (BillingCountryId) REFERENCES dbo.Countries(CountryId),
	CONSTRAINT [FK_Quotes_ShippingCountryId] FOREIGN KEY (ShippingCountryId) REFERENCES dbo.Countries(CountryId),
	CONSTRAINT [FK_Quotes_ShippingMethodId] FOREIGN KEY (ShippingMethodId) REFERENCES dbo.ShippingMethods(ShippingMethodId),
	CONSTRAINT [FK_Quotes_CurrencyId] FOREIGN KEY (CurrencyId) REFERENCES dbo.Currencies(CurrencyId),
	CONSTRAINT [FK_Quotes_CreatedById] FOREIGN KEY (CreatedById) REFERENCES dbo.Users(UserId),
	CONSTRAINT [FK_Quotes_LastModifiedById] FOREIGN KEY (LastModifiedById) REFERENCES dbo.Users(UserId)
)

-- Quote Items --
CREATE TABLE dbo.QuoteItems
(
	QuoteId INT NOT NULL,
	PriceBookItemId INT NOT NULL,
	PricePerUnit DECIMAL(10,2) NOT NULL,
	Quantity INT NOT NULL,
	Discount INT NULL,
	Tax DECIMAL(10,2) NOT NULL,	
	LineTotal DECIMAL(10,2) NOT NULL,
	HasPaymentSchedules BIT NOT NULL CONSTRAINT [DF_QuoteItems_HasPaymentSchedules] DEFAULT (0),
	
	CONSTRAINT [PK_QuoteItems] PRIMARY KEY CLUSTERED (QuoteId, PriceBookItemId),
	CONSTRAINT [FK_QuoteItems_QuoteId] FOREIGN KEY (QuoteId) REFERENCES dbo.Quotes(QuoteId)
)

-- Quote Documents --
CREATE TABLE dbo.QuoteDocuments
(
	QuoteDocumentId INT IDENTITY(1,1) NOT NULL,
	Name NVARCHAR(250) NOT NULL,
	QuoteId INT NOT NULL,
	CurrencyId INT NOT NULL,
	TotalPrice DECIMAL(10,2) NULL,
	Discount INT NULL,
	Document VARBINARY(MAX) NOT NULL,
	
	CONSTRAINT [PK_QuoteDocuments] PRIMARY KEY (QuoteDocumentId),
	CONSTRAINT [FK_QuoteDocuments_QuoteId] FOREIGN KEY (QuoteId) REFERENCES dbo.Quotes(QuoteId),
	CONSTRAINT [FK_QuoteDocuments_CurrencyId] FOREIGN KEY (CurrencyId) REFERENCES dbo.Currencies(CurrencyId)
)

-- Opportunity Quotes --
CREATE TABLE dbo.OpportunityQuotes
(
	OpportunityId INT NOT NULL,	
	QuoteId INT NOT NULL,	

	CONSTRAINT [PK_OpportunityQuotes] PRIMARY KEY CLUSTERED (OpportunityId, QuoteId),
	CONSTRAINT [FK_OpportunityQuotes_OpportunityId] FOREIGN KEY (OpportunityId) REFERENCES dbo.Opportunities(OpportunityId),
	CONSTRAINT [FK_OpportunityQuotes_QuoteId] FOREIGN KEY (QuoteId) REFERENCES dbo.Quotes(QuoteId)
)

-- Opportunity Splits --
CREATE TABLE dbo.OpportunitySplits
(
	OpportunityId INT NOT NULL,	
	OwnerId INT NOT NULL,
	CurrencyId INT NULL,
	SplitAmount DECIMAL(10,2) NOT NULL,
	Percentage INT NOT NULL,
	IsDeleted INT NOT NULL CONSTRAINT [DF_OpportunitySplits_IsDeleted] DEFAULT (0), 

	CONSTRAINT [PK_OpportunitySplits] PRIMARY KEY CLUSTERED (OpportunityId, OwnerId),
	CONSTRAINT [FK_OpportunitySplits_OpportunityId] FOREIGN KEY (OpportunityId) REFERENCES dbo.Opportunities(OpportunityId),
	CONSTRAINT [FK_OpportunitySplits_OwnerId] FOREIGN KEY (OwnerId) REFERENCES dbo.Users(UserId)
)

-- Competitors --
CREATE TABLE dbo.Competitors
(
	CompetitorId INT IDENTITY(1,1) NOT NULL,
	OpportunityId INT NULL,
	Name NVARCHAR(250) NOT NULL,
	Website NVARCHAR(250) NULL,
	KeyProduct NVARCHAR(250) NULL,
	CurrencyId INT NULL,
	ReportedRevenue INT NULL,
	Overview NVARCHAR(MAX) NULL,		
	Strengths NVARCHAR(MAX) NULL,		
	Weaknesses NVARCHAR(MAX) NULL,	
	Threat NVARCHAR(MAX) NULL,	
	OwnerId INT NOT NULL,		
	CreatedAt DATETIME NOT NULL,
	CreatedById INT NOT NULL,
	LastModifiedAt DATETIME NOT NULL,
	LastModifiedById INT NOT NULL,	
	IsDeleted INT NOT NULL CONSTRAINT [DF_Competitors_IsDeleted] DEFAULT (0),	

	CONSTRAINT [PK_Competitors] PRIMARY KEY (CompetitorId),
	CONSTRAINT [FK_Competitors_OpportunityId] FOREIGN KEY (OpportunityId) REFERENCES dbo.Opportunities(OpportunityId),
	CONSTRAINT [FK_Competitors_CurrencyId] FOREIGN KEY (CurrencyId) REFERENCES dbo.Currencies(CurrencyId),
	CONSTRAINT [FK_Competitors_OwnerId] FOREIGN KEY (OwnerId) REFERENCES dbo.Users(UserId),
	CONSTRAINT [FK_Competitors_CreatedById] FOREIGN KEY (CreatedById) REFERENCES dbo.Users(UserId),
	CONSTRAINT [FK_Competitors_LastModifiedById] FOREIGN KEY (LastModifiedById) REFERENCES dbo.Users(UserId)
)

-- Opportunity Tags --
CREATE TABLE dbo.OpportunityTags
(	
	OpportunityId INT NOT NULL,
	TagId INT NOT NULL,	
					
	CONSTRAINT [PK_OpportunityTags] PRIMARY KEY CLUSTERED (OpportunityId, TagId),
	CONSTRAINT [FK_OpportunityTags_OpportunityId] FOREIGN KEY (OpportunityId) REFERENCES dbo.Opportunities(OpportunityId),
	CONSTRAINT [FK_OpportunityTags_TagId] FOREIGN KEY (TagId) REFERENCES dbo.Tags(TagId)
)

-- Opportunity History --
CREATE TABLE dbo.OpportunityHistory
(
	OpportunityId INT NOT NULL,
	SalesStageId INT NOT NULL,
	Probability INT NULL,		
	Amount DECIMAL(10,2) NULL,
	EstimatedRevenue DECIMAL(10,2) NULL,
	ClosedOn DATETIME NULL,
	LastModifiedAt DATETIME NOT NULL,
	LastModifiedById INT NOT NULL,

	CONSTRAINT [PK_OpportunityHistory] PRIMARY KEY CLUSTERED (OpportunityId, SalesStageId),
	CONSTRAINT [FK_OpportunityHistory_OpportunityId] FOREIGN KEY (OpportunityId) REFERENCES dbo.Opportunities(OpportunityId),
	CONSTRAINT [FK_OpportunityHistory_SalesStageId] FOREIGN KEY (SalesStageId) REFERENCES dbo.SalesStages(SalesStageId),
	CONSTRAINT [FK_OpportunityHistory_LastModifiedById] FOREIGN KEY (LastModifiedById) REFERENCES dbo.Users(UserId)
)

-- Big Deal Alerts --
CREATE TABLE dbo.BigDealAlerts
(
	BigDealAlertId INT IDENTITY(1,1) NOT NULL,
	OrganisationId INT NOT NULL,
	Name NVARCHAR(250) NOT NULL,
	TriggerAtProbability INT NOT NULL,
	TriggerAtAmount INT NOT NULL,
	EmailTemplateId INT NULL,
	Subject NVARCHAR(250) NULL,
	FromEmail NVARCHAR(250) NULL,
	FromName NVARCHAR(250) NULL,
	NotifyEmails NVARCHAR(MAX) NOT NULL,
	NotifyCcEmails NVARCHAR(MAX) NULL,
	NotifyBCcEmails NVARCHAR(MAX) NULL,
	PlainTextBody NVARCHAR(MAX) NOT NULL,
	HtmlBody NVARCHAR(MAX) NOT NULL,
	NotifyOpportunityOwner BIT NULL,	
	CreatedAt DATETIME NOT NULL,
	CreatedById INT NOT NULL,
	LastModifiedAt DATETIME NOT NULL,
	LastModifiedById INT NOT NULL,
	IsDeleted INT NOT NULL CONSTRAINT [DF_BigDealAlerts_IsDeleted] DEFAULT (0),		

	CONSTRAINT [PK_BigDealAlerts] PRIMARY KEY (BigDealAlertId),
	CONSTRAINT [FK_BigDealAlerts_OrganisationId] FOREIGN KEY (OrganisationId) REFERENCES dbo.Organisations(OrganisationId),
	CONSTRAINT [FK_BigDealAlerts_CreatedById] FOREIGN KEY (CreatedById) REFERENCES dbo.Users(UserId),
	CONSTRAINT [FK_BigDealAlerts_LastModifiedById] FOREIGN KEY (LastModifiedById) REFERENCES dbo.Users(UserId)
)

-- Shipping Statuses --
CREATE TABLE dbo.ShippingStatuses
(
	ShippingStatusId INT IDENTITY(1,1) NOT NULL,
	OrganisationId INT NULL,
	Name NVARCHAR(250) NOT NULL,
	
	CONSTRAINT [PK_ShippingStatuses] PRIMARY KEY (ShippingStatusId),
	CONSTRAINT [FK_ShippingStatuses_OrganisationId] FOREIGN KEY (OrganisationId) REFERENCES dbo.Organisations(OrganisationId)
)

-- Payment Methods --
CREATE TABLE dbo.PaymentMethods
(
	PaymentMethodId INT IDENTITY(1,1) NOT NULL,
	OrganisationId INT NULL,
	Name NVARCHAR(250) NOT NULL,
	
	CONSTRAINT [PK_PaymentMethods] PRIMARY KEY (PaymentMethodId),
	CONSTRAINT [FK_PaymentMethods_OrganisationId] FOREIGN KEY (OrganisationId) REFERENCES dbo.Organisations(OrganisationId)
)

-- Payment Statuses --
CREATE TABLE dbo.PaymentStatuses
(
	PaymentStatusId INT IDENTITY(1,1) NOT NULL,
	OrganisationId INT NULL,
	Name NVARCHAR(250) NOT NULL,
	
	CONSTRAINT [PK_PaymentStatuses] PRIMARY KEY (PaymentStatusId),
	CONSTRAINT [FK_PaymentStatuses_OrganisationId] FOREIGN KEY (OrganisationId) REFERENCES dbo.Organisations(OrganisationId)
)

-- Orders --
CREATE TABLE dbo.Orders
(
	OrderId INT IDENTITY(1,1) NOT NULL,
	AccountId INT NOT NULL,
	OrderNumber NVARCHAR(250) NOT NULL,
	PONumber NVARCHAR(250) NULL,
	PriorityId INT NULL,
	BillingName NVARCHAR(250) NOT NULL,
	BillingAddressLine1 NVARCHAR(250) NOT NULL,
	BillingAddressLine2 NVARCHAR(250) NULL,
	BillingCityTown NVARCHAR(250) NULL,
	BillingStateCounty NVARCHAR(250) NULL,
	BillingZipPostcode NVARCHAR(15) NOT NULL,
	BillingCountryId INT NOT NULL,
	BillingPhone NVARCHAR(50) NULL,
	BillingFax NVARCHAR(250) NULL,
	ShippingName NVARCHAR(250) NOT NULL,
	ShippingAddressLine1 NVARCHAR(250) NOT NULL,
	ShippingAddressLine2 NVARCHAR(250) NULL,
	ShippingCityTown NVARCHAR(250) NULL,
	ShippingStateCounty NVARCHAR(250) NULL,
	ShippingZipPostcode NVARCHAR(15) NOT NULL,
	ShippingCountryId INT NOT NULL,
	ShippingPhone NVARCHAR(50) NULL,
	ShippingFax NVARCHAR(250) NULL,
	ShippingMethodId INT NOT NULL,
	ShippingStatusId INT NOT NULL,
	ShippingTrackingNumber NVARCHAR(250) NULL,
	WillPickup BIT NOT NULL CONSTRAINT [DF_Orders_WillPickup] DEFAULT (0),
	IsPriceLocked BIT NOT NULL CONSTRAINT [DF_Orders_IsPriceLocked] DEFAULT (0),
	PaymentMethodId INT NOT NULL,
	PaymentStatusId INT NOT NULL,
	CurrencyId INT NOT NULL,
	ExchangeRate DECIMAL(10,2) NOT NULL,
	ShippingAmount DECIMAL(10,2) NULL,
	Discount INT NULL,
	Tax DECIMAL(10,2) NOT NULL,
	SubTotal DECIMAL(10,2) NOT NULL,	
	TotalAmount DECIMAL(10,2) NOT NULL,		
	TotalPaidToDate DECIMAL(10,2) NULL,
	LineItemCount INT NOT NULL CONSTRAINT [DF_Orders_LineItemCount] DEFAULT (0),
	OwnerId INT NOT NULL,
	CreatedAt DATETIME NOT NULL,
	CreatedById INT NOT NULL,
	LastModifiedAt DATETIME NOT NULL,
	LastModifiedById INT NOT NULL,
	IsDeleted INT NOT NULL CONSTRAINT [DF_Orders_IsDeleted] DEFAULT (0),	

	CONSTRAINT [PK_Orders] PRIMARY KEY (OrderId),
	CONSTRAINT [FK_Orders_AccountId] FOREIGN KEY (AccountId) REFERENCES dbo.Accounts(AccountId),
	CONSTRAINT [FK_Orders_PriorityId] FOREIGN KEY (PriorityId) REFERENCES dbo.Priorities(PriorityId),
	CONSTRAINT [FK_Orders_BillingCountryId] FOREIGN KEY (BillingCountryId) REFERENCES dbo.Countries(CountryId),
	CONSTRAINT [FK_Orders_ShippingCountryId] FOREIGN KEY (ShippingCountryId) REFERENCES dbo.Countries(CountryId),
	CONSTRAINT [FK_Orders_ShippingMethodId] FOREIGN KEY (ShippingMethodId) REFERENCES dbo.ShippingMethods(ShippingMethodId),
	CONSTRAINT [FK_Orders_ShippingStatusId] FOREIGN KEY (ShippingStatusId) REFERENCES dbo.ShippingStatuses(ShippingStatusId),
	CONSTRAINT [FK_Orders_PaymentMethodId] FOREIGN KEY (PaymentMethodId) REFERENCES dbo.PaymentMethods(PaymentMethodId),
	CONSTRAINT [FK_Orders_PaymentStatusId] FOREIGN KEY (PaymentStatusId) REFERENCES dbo.PaymentStatuses(PaymentStatusId),
	CONSTRAINT [FK_Orders_CurrencyId] FOREIGN KEY (CurrencyId) REFERENCES dbo.Currencies(CurrencyId),
	CONSTRAINT [FK_Orders_OwnerId] FOREIGN KEY (OwnerId) REFERENCES dbo.Users(UserId),
	CONSTRAINT [FK_Orders_CreatedById] FOREIGN KEY (CreatedById) REFERENCES dbo.Users(UserId),
	CONSTRAINT [FK_Orders_LastModifiedById] FOREIGN KEY (LastModifiedById) REFERENCES dbo.Users(UserId)
)

-- Order Items --
CREATE TABLE dbo.OrderItems
(
	OrderId INT NOT NULL,
	ProductId INT NOT NULL,
	Description NVARCHAR(MAX) NULL,
	PricePerUnit DECIMAL(10,2) NOT NULL,
	Quantity INT NOT NULL,
	Discount INT NULL,
	Tax DECIMAL(10,2) NOT NULL,	
	LineTotal DECIMAL(10,2) NOT NULL,
	DeliveredOn DATETIME NULL,	
	HasPaymentSchedules BIT NOT NULL CONSTRAINT [DF_Orders_HasPaymentSchedules] DEFAULT (0),

	CONSTRAINT [PK_OrderItems] PRIMARY KEY CLUSTERED (OrderId, ProductId),
	CONSTRAINT [FK_OrderItems_OrderId] FOREIGN KEY (OrderId) REFERENCES dbo.Orders(OrderId),
	CONSTRAINT [FK_OrderItems_ProductId] FOREIGN KEY (ProductId) REFERENCES dbo.Products(ProductId)
)

-- Payment Schedules --
CREATE TABLE dbo.PaymentSchedules
(
	PaymentScheduleId INT IDENTITY(1,1) NOT NULL,
	OrderId INT NOT NULL,
	NumberOfPayments INT NOT NULL CONSTRAINT [DF_PaymentSchedules_NumberOfPayments] DEFAULT (0),
	FrequencyId INT NOT NULL,
	FirstPaymentDueOn DATETIME NOT NULL,
	OwnerId INT NOT NULL,
	CreatedAt DATETIME NOT NULL,
	CreatedById INT NOT NULL,
	LastModifiedAt DATETIME NOT NULL,
	LastModifiedById INT NOT NULL,
	IsDeleted INT NOT NULL CONSTRAINT [DF_PaymentSchedules_IsDeleted] DEFAULT (0),	

	CONSTRAINT [PK_PaymentSchedules] PRIMARY KEY (PaymentScheduleId),
	CONSTRAINT [FK_PaymentSchedules_OrderId] FOREIGN KEY (OrderId) REFERENCES dbo.Orders(OrderId),
	CONSTRAINT [FK_PaymentSchedules_OwnerId] FOREIGN KEY (OwnerId) REFERENCES dbo.Users(UserId),
	CONSTRAINT [FK_PaymentSchedules_CreatedById] FOREIGN KEY (CreatedById) REFERENCES dbo.Users(UserId),
	CONSTRAINT [FK_PaymentSchedules_LastModifiedById] FOREIGN KEY (LastModifiedById) REFERENCES dbo.Users(UserId)
)

-- Warranties --
CREATE TABLE dbo.Warranties
(
	WarrantyId INT IDENTITY(1,1) NOT NULL,
	OrganisationId INT NULL,
	Name NVARCHAR(250) NOT NULL,
	ExpirationTerm INT NOT NULL,						

	CONSTRAINT [PK_Warranties] PRIMARY KEY (WarrantyId),
	CONSTRAINT [FK_Warranties_OrganisationId] FOREIGN KEY (OrganisationId) REFERENCES dbo.Organisations(OrganisationId)
)

-- Asset Types --
CREATE TABLE dbo.AssetTypes
(
	AssetsTypeId INT IDENTITY(1,1) NOT NULL,
	OrganisationId INT NULL,
	Name NVARCHAR(250) NOT NULL,

	CONSTRAINT [PK_AssetTypes] PRIMARY KEY (AssetsTypeId),
	CONSTRAINT [FK_AssetTypes_OrganisationId] FOREIGN KEY (OrganisationId) REFERENCES dbo.Organisations(OrganisationId)
)

-- Models --
CREATE TABLE dbo.Models
(
	ModelId INT IDENTITY(1,1) NOT NULL,
	OrganisationId INT NOT NULL,
	Name NVARCHAR(250) NOT NULL,
	VendorId INT NOT NULL,
	AssetsTypeId INT NOT NULL,
	IsDiscontinued BIT NOT NULL CONSTRAINT [DF_Models_IsDiscontinued] DEFAULT (0), 

	CONSTRAINT [PK_Models] PRIMARY KEY (ModelId),
	CONSTRAINT [FK_Models_OrganisationId] FOREIGN KEY (OrganisationId) REFERENCES dbo.Organisations(OrganisationId),
	CONSTRAINT [FK_Models_VendorId] FOREIGN KEY (VendorId) REFERENCES dbo.Vendors(VendorId),
	CONSTRAINT [FK_Models_AssetsTypeId] FOREIGN KEY (AssetsTypeId) REFERENCES dbo.AssetsTypes(AssetsTypeId)
)

-- Asset Statuses --
CREATE TABLE dbo.AssetStatuses
(
	AssetStatusId INT IDENTITY(1,1) NOT NULL,
	OrganisationId INT NULL,
	Name NVARCHAR(250) NOT NULL,	
	IsRetired BIT NOT NULL CONSTRAINT [DF_AssetStatuses_IsRetired] DEFAULT (0),

	CONSTRAINT [PK_AssetStatuses] PRIMARY KEY (AssetStatusId),
	CONSTRAINT [FK_AssetStatuses_OrganisationId] FOREIGN KEY (OrganisationId) REFERENCES dbo.Organisations(OrganisationId)
)

-- Assets --
CREATE TABLE dbo.Assets
(
	AssetId INT IDENTITY(1,1) NOT NULL,
	OrganisationId INT NOT NULL,
	AccountId INT NULL,
	ContactId INT NULL,
	Name NVARCHAR(250) NOT NULL,
	Description NVARCHAR(MAX) NULL,
	ModelId INT NULL,
	WarrantyId INT NULL,
	AssetStatusId INT NULL,
	Quantity INT NULL,
	IsCompetitorProducts BIT NOT NULL CONSTRAINT [DF_Assets_IsCompetitorProducts] DEFAULT (0),
	CurrencyId INT NULL,
	PurchasePrice DECIMAL(10,2) NULL,
	PurchasedOn DATETIME NULL,
	InstalledOn DATETIME NULL,
	UsageEndedOn DATETIME NULL,
	IPAddress NVARCHAR(15) NULL,
	SerialNumber NVARCHAR(250) NULL,
	LastMaintainedOn DATETIME NULL,
	Location NVARCHAR(250) NULL,
	VersionNumber NVARCHAR(250) NULL,
	NumberOfLicenses INT NULL,
	TotalInstalled INT NULL,
	OwnerId INT NOT NULL,
	CreatedAt DATETIME NOT NULL,
	CreatedById INT NOT NULL,
	LastModifiedAt DATETIME NOT NULL,
	LastModifiedById INT NOT NULL,
	IsDeleted INT NOT NULL CONSTRAINT [DF_Assets_IsDeleted] DEFAULT (0),	

	CONSTRAINT [PK_Assets] PRIMARY KEY (AssetId),	
	CONSTRAINT [FK_Assets_OrganisationId] FOREIGN KEY (OrganisationId) REFERENCES dbo.Organisations(OrganisationId),
	CONSTRAINT [FK_Assets_AccountId] FOREIGN KEY (AccountId) REFERENCES dbo.Accounts(AccountId),
	CONSTRAINT [FK_Assets_ContactId] FOREIGN KEY (ContactId) REFERENCES dbo.Contacts(ContactId),
	CONSTRAINT [FK_Assets_ModelId] FOREIGN KEY (ModelId) REFERENCES dbo.Models(ModelId),
	CONSTRAINT [FK_Assets_WarrantyId] FOREIGN KEY (WarrantyId) REFERENCES dbo.Warranties(WarrantyId),
	CONSTRAINT [FK_Assets_AssetStatusId] FOREIGN KEY (AssetStatusId) REFERENCES dbo.AssetStatuses(AssetStatusId),
	CONSTRAINT [FK_Assets_OwnerId] FOREIGN KEY (OwnerId) REFERENCES dbo.Users(UserId),
	CONSTRAINT [FK_Assets_CreatedById] FOREIGN KEY (CreatedById) REFERENCES dbo.Users(UserId),
	CONSTRAINT [FK_Assets_LastModifiedById] FOREIGN KEY (LastModifiedById) REFERENCES dbo.Users(UserId)
)

-- Asset Tags --
CREATE TABLE dbo.AssetTags
(	
	AssetId INT NOT NULL,
	TagId INT NOT NULL,	
					
	CONSTRAINT [PK_AssetTags] PRIMARY KEY CLUSTERED (AssetId, TagId),
	CONSTRAINT [FK_AssetTags_AssetId] FOREIGN KEY (AssetId) REFERENCES dbo.Assets(AssetId),
	CONSTRAINT [FK_AssetTags_TagId] FOREIGN KEY (TagId) REFERENCES dbo.Tags(TagId)
)

-- Asset History --
CREATE TABLE dbo.AssetHistory
(
	AssetHistoryId INT IDENTITY(1,1) NOT NULL,
	AssetId INT NOT NULL,
	FieldName NVARCHAR(250) NOT NULL,
	NewValue NVARCHAR(MAX) NOT NULL,
	OldValue NVARCHAR(MAX) NOT NULL,
	LastModifiedAt DATETIME NOT NULL,
	LastModifiedById INT NOT NULL,

	CONSTRAINT [PK_AssetHistory] PRIMARY KEY (AssetHistoryId),
	CONSTRAINT [FK_AssetHistory_AssetId] FOREIGN KEY (AssetId) REFERENCES dbo.Assets(AssetId),
	CONSTRAINT [FK_AssetHistory_LastModifiedById] FOREIGN KEY (LastModifiedById) REFERENCES dbo.Users(UserId)
)

-- Article Categories --
CREATE TABLE dbo.KnowledgeArticleCategories
(
	KnowledgeArticleCategoryId INT IDENTITY(1,1) NOT NULL,
	ParentCategoryId INT NOT NULL CONSTRAINT [DF_KnowledgeArticleCategories_ParentCategoryId] DEFAULT (0),
	OrganisationId INT NOT NULL,
	Name NVARCHAR(250) NOT NULL,	

	CONSTRAINT [PK_KnowledgeArticleCategories] PRIMARY KEY (KnowledgeArticleCategoryId),
	CONSTRAINT [FK_KnowledgeArticleCategories_OrganisationId] FOREIGN KEY (OrganisationId) REFERENCES dbo.Organisations(OrganisationId)
)

-- Articles --
CREATE TABLE dbo.KnowledgeArticles
(	
	KnowledgeArticleId INT IDENTITY(1,1) NOT NULL,
	OrganisationId INT NOT NULL,
	CaseAssociationCount INT NOT NULL CONSTRAINT [DF_KnowledgeArticles_CaseAssociationCount] DEFAULT (0),
	ArchivedDate DATETIME NULL,	
	ArchivedById INT NULL,
					
	CONSTRAINT [PK_KnowledgeArticles] PRIMARY KEY (KnowledgeArticleId),
	CONSTRAINT [FK_KnowledgeArticles_OrganisationId] FOREIGN KEY (OrganisationId) REFERENCES dbo.Organisations(OrganisationId),
	CONSTRAINT [FK_KnowledgeArticles_ArchivedById] FOREIGN KEY (ArchivedById) REFERENCES dbo.Users(UserId)
)

-- Article Versions --
CREATE TABLE dbo.KnowledgeArticleVersions
(
	KnowledgeArticleVersionId INT IDENTITY(1,1) NOT NULL,
	KnowledgeArticleId INT NOT NULL,
	KnowledgeArticleCategoryId INT NULL,
	LanguageId INT NOT NULL,
	Title NVARCHAR(250) NOT NULL,
	Abstract NVARCHAR(1000) NULL,
	Body NVARCHAR(MAX) NOT NULL,
	CommentCount INT NOT NULL CONSTRAINT [DF_Articles_CommentCount] DEFAULT (0),
	ViewCount INT NOT NULL CONSTRAINT [DF_Articles_ViewCount] DEFAULT (0),
	PublishedOn DATETIME NULL,
	IsPublished BIT NOT NULL CONSTRAINT [DF_Articles_IsPublished] DEFAULT (0), 	
	IsCurrentVersion BIT NOT NULL CONSTRAINT [DF_Articles_IsCurrentVersion] DEFAULT (0),
	IsOutOfDate BIT NOT NULL CONSTRAINT [DF_Articles_IsOutOfDate] DEFAULT (0),
	VersionNumber INT NOT NULL,
	OwnerId INT NOT NULL,	
	CreatedAt DATETIME NOT NULL,
	CreatedById INT NOT NULL,
	LastModifiedAt DATETIME NOT NULL,
	LastModifiedById INT NOT NULL,
	IsDeleted INT NOT NULL CONSTRAINT [DF_Articles_IsDeleted] DEFAULT (0),

	CONSTRAINT [PK_KnowledgeArticleVersions] PRIMARY KEY (KnowledgeArticleVersionId),
	CONSTRAINT [FK_KnowledgeArticleVersions_KnowledgeArticleId] FOREIGN KEY (KnowledgeArticleId) REFERENCES dbo.KnowledgeArticles(KnowledgeArticleId),
	CONSTRAINT [FK_KnowledgeArticleVersions_KnowledgeArticleCategoryId] FOREIGN KEY (KnowledgeArticleCategoryId) REFERENCES dbo.KnowledgeArticleCategories(KnowledgeArticleCategoryId),
	CONSTRAINT [FK_KnowledgeArticleVersions_LanguageId] FOREIGN KEY (LanguageId) REFERENCES dbo.Languages(LanguageId),
	CONSTRAINT [FK_KnowledgeArticleVersions_OwnerId] FOREIGN KEY (OwnerId) REFERENCES dbo.Users(UserId),
	CONSTRAINT [FK_KnowledgeArticleVersions_CreatedById] FOREIGN KEY (CreatedById) REFERENCES dbo.Users(UserId),
	CONSTRAINT [FK_KnowledgeArticleVersions_LastModifiedById] FOREIGN KEY (LastModifiedById) REFERENCES dbo.Users(UserId)
)

-- Article View Statistics --
CREATE TABLE dbo.KnowledgeArticleViewStats
(
	KnowledgeArticleId INT NOT NULL,
	UserId INT NOT NULL,
	CreatedAt DATETIME NOT NULL,

	CONSTRAINT [PK_KnowledgeArticleViewStats] PRIMARY KEY CLUSTERED (KnowledgeArticleId, UserId),
	CONSTRAINT [FK_KnowledgeArticleViewStats_KnowledgeArticleId] FOREIGN KEY (KnowledgeArticleId) REFERENCES dbo.KnowledgeArticles(KnowledgeArticleId),
	CONSTRAINT [FK_KnowledgeArticleViewStats_UserId] FOREIGN KEY (UserId) REFERENCES dbo.Users(UserId)
)

-- Article Vote Statistics --
CREATE TABLE dbo.KnowledgeArticleVoteStats
(
	KnowledgeArticleId INT NOT NULL,
	UserId INT NOT NULL,
	CreatedAt DATETIME NOT NULL,

	CONSTRAINT [PK_KnowledgeArticleVoteStats] PRIMARY KEY CLUSTERED (KnowledgeArticleId, UserId),
	CONSTRAINT [FK_KnowledgeArticleVoteStats_KnowledgeArticleId] FOREIGN KEY (KnowledgeArticleId) REFERENCES dbo.KnowledgeArticles(KnowledgeArticleId),
	CONSTRAINT [FK_KnowledgeArticleVoteStats_UserId] FOREIGN KEY (UserId) REFERENCES dbo.Users(UserId)
)

-- Case Types --
CREATE TABLE dbo.CaseTypes
(
	CaseTypeId INT IDENTITY(1,1) NOT NULL,
	ParentCaseTypeId BIT NOT NULL CONSTRAINT [DF_CaseTypes_ParentCaseTypeId] DEFAULT (0),
	OrganisationId INT NULL,
	Name NVARCHAR(250) NOT NULL,
	DefaultPriorityId INT NOT NULL,		
	
	CONSTRAINT [PK_CaseTypes] PRIMARY KEY (CaseTypeId),
	CONSTRAINT [FK_CaseTypes_DefaultPriorityId] FOREIGN KEY (DefaultPriorityId) REFERENCES dbo.Priorities(PriorityId),
	CONSTRAINT [FK_CaseTypes_OrganisationId] FOREIGN KEY (OrganisationId) REFERENCES dbo.Organisations(OrganisationId)
)

-- Case Statuses --
CREATE TABLE dbo.CaseStatuses
(
	CaseStatusId INT IDENTITY(1,1) NOT NULL,
	OrganisationId INT NULL,
	Name NVARCHAR(250) NOT NULL,	
	IsDefault BIT NOT NULL CONSTRAINT [DF_CaseStatuses_IsDefault] DEFAULT (0),
	IsClosed BIT NOT NULL CONSTRAINT [DF_CaseStatuses_IsClosed] DEFAULT (0),
	EnableAlerts BIT NOT NULL CONSTRAINT [DF_CaseStatuses_EnableAlerts] DEFAULT (0),
	SendAlertNotifications BIT NOT NULL CONSTRAINT [DF_CaseStatuses_SendAlertNotifications] DEFAULT (0),
	CountTime BIT NOT NULL CONSTRAINT [DF_CaseStatuses_CountTime] DEFAULT (0),
	ShowInCalendar BIT NOT NULL CONSTRAINT [DF_CaseStatuses_ShowInCalendar] DEFAULT (0),
	ConfirmCaseClose BIT NOT NULL CONSTRAINT [DF_CaseStatuses_ConfirmCaseClose] DEFAULT (0),

	CONSTRAINT [PK_CaseStatuses] PRIMARY KEY (CaseStatusId),
	CONSTRAINT [FK_CaseStatuses_OrganisationId] FOREIGN KEY (OrganisationId) REFERENCES dbo.Organisations(OrganisationId)
)

-- Case Priorities --
CREATE TABLE dbo.CasePriorities
(
	CasePriorityId INT IDENTITY(1,1) NOT NULL,
	Name NVARCHAR(250) NOT NULL,
	IsHighPriority BIT NOT NULL CONSTRAINT [DF_CasePriorities_IsHighPriority] DEFAULT (0),
	DefaultDueDate INT NULL,
	DefaultDueDateFrequencyId INT NULL,
	ReminderInterval INT NULL,	
	ReminderFrequencyId INT NULL,
	EscalateAlertLevel BIT NOT NULL CONSTRAINT [DF_CasePriorities_EscalateAlertLevel] DEFAULT (0),

	CONSTRAINT [PK_CasePriorities] PRIMARY KEY (CasePriorityId),
	CONSTRAINT [FK_CasePriorities_DefaultDueDateFrequencyId] FOREIGN KEY (DefaultDueDateFrequencyId) REFERENCES dbo.Frequencies(FrequencyId),
	CONSTRAINT [FK_CasePriorities_ReminderFrequencyId] FOREIGN KEY (ReminderFrequencyId) REFERENCES dbo.Frequencies(FrequencyId)
)	

-- Cases --
CREATE TABLE dbo.Cases
(
	CaseId INT IDENTITY(1,1) NOT NULL,
	OrganisationId INT NOT NULL,
	AccountId INT NOT NULL,
	ContactId INT NULL,
	ParentCaseId INT NOT NULL CONSTRAINT [DF_Cases_ParentCaseId] DEFAULT (0),	
	CaseTypeId INT NOT NULL,
	CaseNumber NVARCHAR(250) NOT NULL,
	Title NVARCHAR(250) NOT NULL,
	Description NVARCHAR(MAX) NULL,
	CaseStatusId INT NULL,
	CasePriorityId INT NULL,	
	AlertLevel INT NOT NULL CONSTRAINT [DF_Cases_AlertLevel] DEFAULT (0),
	StartOn DATETIME NULL,
	EndOn DATETIME NULL,
	DueOn DATETIME NULL,
	ClosedOn DATETIME NULL,
	IsClosed BIT NOT NULL CONSTRAINT [DF_Cases_IsClosed] DEFAULT (0),		
	IsClosedOnCreate BIT NOT NULL CONSTRAINT [DF_Cases_IsClosedOnCreate] DEFAULT (0),		
	IsEscalated BIT NOT NULL CONSTRAINT [DF_Cases_IsEscalated] DEFAULT (0),		
	IsSpam BIT NOT NULL CONSTRAINT [DF_Cases_IsSpam] DEFAULT (0),		
	IsFlagged BIT NOT NULL CONSTRAINT [DF_Cases_IsFlagged] DEFAULT (0),		
	EnableTimeTracking BIT NOT NULL CONSTRAINT [DF_Cases_EnableTimeTracking] DEFAULT (0),		
	OriginId INT NOT NULL,
	RaisedViaEmail BIT NOT NULL CONSTRAINT [DF_Cases_RaisedViaEmail] DEFAULT (0),
	HasCommentsUnreadByOwnerId BIT NOT NULL CONSTRAINT [DF_Cases_HasCommentsUnreadByOwnerId] DEFAULT (0),	
	AssetId INT NOT NULL,
	SuppliedCompanyName NVARCHAR(250) NULL,
	SuppliedContactName NVARCHAR(250) NOT NULL,
	SuppliedEmail NVARCHAR(250) NOT NULL,
	SuppliedPhone NVARCHAR(50) NOT NULL,			
	OwnerId INT NOT NULL,
	CreatedAt DATETIME NOT NULL,
	CreatedById INT NOT NULL,
	LastModifiedAt DATETIME NOT NULL,
	LastModifiedById INT NOT NULL,
	IsDeleted INT NOT NULL CONSTRAINT [DF_Cases_IsDeleted] DEFAULT (0),		

	CONSTRAINT [PK_Cases] PRIMARY KEY (CaseId),
	CONSTRAINT [FK_Cases_OrganisationId] FOREIGN KEY (OrganisationId) REFERENCES dbo.Organisations(OrganisationId),
	CONSTRAINT [FK_Cases_AccountId] FOREIGN KEY (AccountId) REFERENCES dbo.Accounts(AccountId),
	CONSTRAINT [FK_Cases_ContactId] FOREIGN KEY (ContactId) REFERENCES dbo.Contacts(ContactId),
	CONSTRAINT [FK_Cases_CaseTypeId] FOREIGN KEY (CaseTypeId) REFERENCES dbo.CaseTypes(CaseTypeId),
	CONSTRAINT [FK_Cases_CaseStatusId] FOREIGN KEY (CaseStatusId) REFERENCES dbo.CaseStatuses(CaseStatusId),
	CONSTRAINT [FK_Cases_CasePriorityId] FOREIGN KEY (CasePriorityId) REFERENCES dbo.CasePriorities(CasePriorityId),
	CONSTRAINT [FK_Cases_AssetId] FOREIGN KEY (AssetId) REFERENCES dbo.Assets(AssetId),
	CONSTRAINT [FK_Cases_OriginId] FOREIGN KEY (OriginId) REFERENCES dbo.Origins(OriginId),
	CONSTRAINT [FK_Cases_OwnerId] FOREIGN KEY (OwnerId) REFERENCES dbo.Users(UserId),
	CONSTRAINT [FK_Cases_CreatedById] FOREIGN KEY (CreatedById) REFERENCES dbo.Users(UserId),
	CONSTRAINT [FK_Cases_LastModifiedById] FOREIGN KEY (LastModifiedById) REFERENCES dbo.Users(UserId)
)

-- Case Settings --
CREATE TABLE dbo.CaseSettings
(
	CaseSettingId INT NOT NULL,
	OrganisationId INT NOT NULL,

	CONSTRAINT [PK_CaseSettings] PRIMARY KEY (CaseId, ArticleId),
	CONSTRAINT [FK_CaseSettings_CaseId] FOREIGN KEY (CaseId) REFERENCES dbo.Cases(CaseId),
	CONSTRAINT [FK_CaseSettings_OrganisationId] FOREIGN KEY (OrganisationId) REFERENCES dbo.Organisations(OrganisationId)
)

-- Case Articles --
CREATE TABLE dbo.CaseArticles
(
	CaseId INT NOT NULL,
	ArticleId INT NOT NULL,

	CONSTRAINT [PK_CaseArticles] PRIMARY KEY CLUSTERED (CaseId, ArticleId),
	CONSTRAINT [FK_CaseArticles_CaseId] FOREIGN KEY (CaseId) REFERENCES dbo.Cases(CaseId),
	CONSTRAINT [FK_CaseArticles_ArticleId] FOREIGN KEY (ArticleId) REFERENCES dbo.Articles(ArticleId)
)

-- Case Tags --
CREATE TABLE dbo.CaseTags
(	
	CaseId INT NOT NULL,
	TagId INT NOT NULL,	
					
	CONSTRAINT [PK_CaseTags] PRIMARY KEY CLUSTERED (CaseId, TagId),
	CONSTRAINT [FK_CaseTags_CaseId] FOREIGN KEY (CaseId) REFERENCES dbo.Cases(CaseId),
	CONSTRAINT [FK_CaseTags_TagId] FOREIGN KEY (TagId) REFERENCES dbo.Tags(TagId)
)

-- Case History --
CREATE TABLE dbo.CaseHistory
(
	CaseHistoryId INT IDENTITY(1,1) NOT NULL,
	CaseId INT NOT NULL,
	FieldName NVARCHAR(250) NOT NULL,
	NewValue NVARCHAR(MAX) NOT NULL,
	OldValue NVARCHAR(MAX) NOT NULL,
	LastModifiedAt DATETIME NOT NULL,
	LastModifiedById INT NOT NULL,

	CONSTRAINT [PK_CaseHistory] PRIMARY KEY (CaseHistoryId),
	CONSTRAINT [FK_CaseHistory_CaseId] FOREIGN KEY (CaseId) REFERENCES dbo.Cases(CaseId),
	CONSTRAINT [FK_CaseHistory_LastModifiedById] FOREIGN KEY (LastModifiedById) REFERENCES dbo.Users(UserId)
)

-- Business Hours --
CREATE TABLE dbo.BusinessHours
(
	BusinessHoursId INT IDENTITY(1,1) NOT NULL,
	OrganisationId INT NOT NULL,
	Name NVARCHAR(250) NOT NULL,
	TimeZoneOffSet INT NOT NULL,
	MondayStartTime NVARCHAR(10) NOT NULL,
	MondayEndTime NVARCHAR(10) NOT NULL,
	TuesdayStartTime NVARCHAR(10) NOT NULL,
	TuesdayEndTime NVARCHAR(10) NOT NULL,
	WednesdayStartTime NVARCHAR(10) NOT NULL,
	WednesdayEndTime NVARCHAR(10) NOT NULL,
	ThursdayStartTime NVARCHAR(10) NOT NULL,
	ThursdayEndTime NVARCHAR(10) NOT NULL,
	FridayStartTime NVARCHAR(10) NOT NULL,
	FridayEndTime NVARCHAR(10) NOT NULL,
	SaturdayStartTime NVARCHAR(10) NOT NULL,
	SaturdayEndTime NVARCHAR(10) NOT NULL,
	SundayStartTime NVARCHAR(10) NOT NULL,
	SundayEndTime NVARCHAR(10) NOT NULL,
	IsDeleted INT NOT NULL CONSTRAINT [DF_BusinessHours_IsDeleted] DEFAULT (0),

	CONSTRAINT [PK_BusinessHours] PRIMARY KEY (BusinessHoursId),
	CONSTRAINT [FK_BusinessHours_OrganisationId] FOREIGN KEY (OrganisationId) REFERENCES dbo.Organisations(OrganisationId)
)

-- Holiday Calendar --
CREATE TABLE dbo.Holidays
(
	HolidayId INT IDENTITY(1,1) NOT NULL,
	OrganisationId INT NOT NULL,
	Name NVARCHAR(250) NOT NULL,
	ActivityOn DATETIME NOT NULL,
	StartTimeInMinutes INT NULL,
	EndTimeInMinutes INT NULL,
	IsAllDay BIT NOT NULL CONSTRAINT [DF_Holidays_IsAllDay] DEFAULT (0),
	IsRecurrence BIT NOT NULL CONSTRAINT [DF_Holidays_IsRecurrence] DEFAULT (0),
	RecurrenceStartOn DATETIME NOT NULL,
	RecurrenceEndDate DATETIME NOT NULL,	
	RecurrenceDayOfWeek INT NULL,
	RecurrenceDayOfMonth INT NULL,
	RecurrenceMonthOfYear INT NULL, 
	RecurrenceInterval INT NULL,
	RecurrenceFrequencyId INT NULL,
	IsDeleted INT NOT NULL CONSTRAINT [DF_Holidays_IsDeleted] DEFAULT (0),

	CONSTRAINT [PK_Holidays] PRIMARY KEY (HolidayId),
	CONSTRAINT [FK_Holidays_OrganisationId] FOREIGN KEY (OrganisationId) REFERENCES dbo.Organisations(OrganisationId),
	CONSTRAINT [FK_Holidays_RecurrenceFrequencyId] FOREIGN KEY (RecurrenceFrequencyId) REFERENCES dbo.Frequencies(FrequencyId)
)

-- Entitlement Types --
CREATE TABLE dbo.EntitlementTypes
(
	EntitlementTypeId INT IDENTITY(1,1) NOT NULL,
	OrganisationId INT NULL,
	Name NVARCHAR(250) NOT NULL,	
	
	CONSTRAINT [PK_EntitlementTypes] PRIMARY KEY (EntitlementTypeId),
	CONSTRAINT [FK_EntitlementTypes_OrganisationId] FOREIGN KEY (OrganisationId) REFERENCES dbo.Organisations(OrganisationId)
)

-- Entitlement Templates -- 
CREATE TABLE dbo.EntitlementTemplates
(
	EntitlementTemplateId INT IDENTITY(1,1) NOT NULL,
	OrganisationId INT NOT NULL,
	Name NVARCHAR(250) NOT NULL,
	BusinessHoursId INT NULL,
	CasesPerEntitlement INT NOT NULL CONSTRAINT [DF_EntitlementTemplates_CasesPerEntitlement] DEFAULT (0),
	IsPerIncident BIT NOT NULL CONSTRAINT [DF_EntitlementTemplates_IsPerIncident] DEFAULT (0),
	EntitlementTypeId INT NULL,
	OwnerId INT NOT NULL,
	CreatedAt DATETIME NOT NULL,
	CreatedById INT NOT NULL,
	LastModifiedAt DATETIME NOT NULL,
	LastModifiedById INT NOT NULL,
	IsDeleted INT NOT NULL CONSTRAINT [DF_EntitlementTemplates_IsDeleted] DEFAULT (0),	

	CONSTRAINT [PK_EntitlementTemplates] PRIMARY KEY (EntitlementTemplateId),
	CONSTRAINT [FK_EntitlementTemplates_OrganisationId] FOREIGN KEY (OrganisationId) REFERENCES dbo.Organisations(OrganisationId),
	CONSTRAINT [FK_EntitlementTemplates_BusinessHoursId] FOREIGN KEY (BusinessHoursId) REFERENCES dbo.BusinessHours(BusinessHoursId),
	CONSTRAINT [FK_EntitlementTemplates_EntitlementTypeId] FOREIGN KEY (EntitlementTypeId) REFERENCES dbo.EntitlementTypes(EntitlementTypeId),
	CONSTRAINT [FK_EntitlementTemplates_OwnerId] FOREIGN KEY (OwnerId) REFERENCES dbo.Users(UserId),	
	CONSTRAINT [FK_EntitlementTemplates_CreatedById] FOREIGN KEY (CreatedById) REFERENCES dbo.Users(UserId),
	CONSTRAINT [FK_EntitlementTemplates_LastModifiedById] FOREIGN KEY (LastModifiedById) REFERENCES dbo.Users(UserId)
)

-- Entitlements --
CREATE TABLE dbo.Entitlements
(
	EntitlementId INT IDENTITY(1,1) NOT NULL,
	OrganisationId INT NOT NULL,
	AccountId INT NOT NULL,
	AssetId INT NULL,
	BusinessHoursId INT NULL,
	Name NVARCHAR(250) NOT NULL,
	ContractId INT NULL,
	CasesPerEntitlement INT NOT NULL CONSTRAINT [DF_Entitlements_CasesPerEntitlement] DEFAULT (0),
	IsPerIncident BIT NOT NULL CONSTRAINT [DF_Entitlements_IsPerIncident] DEFAULT (0),
	RemainingCaseCount INT NULL,
	StartOn DATETIME NULL,
	EndOn DATETIME NULL,
	EntitlementTypeId INT NULL,
	OwnerId INT NOT NULL,
	CreatedAt DATETIME NOT NULL,
	CreatedById INT NOT NULL,
	LastModifiedAt DATETIME NOT NULL,
	LastModifiedById INT NOT NULL,
	IsDeleted INT NOT NULL CONSTRAINT [DF_Entitlements_IsDeleted] DEFAULT (0),		

	CONSTRAINT [PK_Entitlements] PRIMARY KEY (EntitlementId),
	CONSTRAINT [FK_Entitlements_OrganisationId] FOREIGN KEY (OrganisationId) REFERENCES dbo.Organisations(OrganisationId),
	CONSTRAINT [FK_Entitlements_AccountId] FOREIGN KEY (AccountId) REFERENCES dbo.Accounts(AccountId),
	CONSTRAINT [FK_Entitlements_AssetId] FOREIGN KEY (AssetId) REFERENCES dbo.Assets(AssetId),
	CONSTRAINT [FK_Entitlements_BusinessHoursId] FOREIGN KEY (BusinessHoursId) REFERENCES dbo.BusinessHours(BusinessHoursId),
	CONSTRAINT [FK_Entitlements_ContractId] FOREIGN KEY (ContractId) REFERENCES dbo.Contracts(ContractId),
	CONSTRAINT [FK_Entitlements_EntitlementTypeId] FOREIGN KEY (EntitlementTypeId) REFERENCES dbo.EntitlementTypes(EntitlementTypeId),
	CONSTRAINT [FK_Entitlements_OwnerId] FOREIGN KEY (OwnerId) REFERENCES dbo.Users(UserId),	
	CONSTRAINT [FK_Entitlements_CreatedById] FOREIGN KEY (CreatedById) REFERENCES dbo.Users(UserId),
	CONSTRAINT [FK_Entitlements_LastModifiedById] FOREIGN KEY (LastModifiedById) REFERENCES dbo.Users(UserId)
)

-- Entitlement History --
CREATE TABLE dbo.EntitlementHistory
(
	EntitlementHistoryId INT IDENTITY(1,1) NOT NULL,
	EntitlementId INT NOT NULL,
	FieldName NVARCHAR(250) NOT NULL,
	NewValue NVARCHAR(MAX) NOT NULL,
	OldValue NVARCHAR(MAX) NOT NULL,
	LastModifiedAt DATETIME NOT NULL,
	LastModifiedById INT NOT NULL,

	CONSTRAINT [PK_EntitlementHistory] PRIMARY KEY (EntitlementHistoryId),
	CONSTRAINT [FK_EntitlementHistory_EntitlementId] FOREIGN KEY (EntitlementId) REFERENCES dbo.Entitlements(EntitlementId),
	CONSTRAINT [FK_EntitlementHistory_LastModifiedById] FOREIGN KEY (LastModifiedById) REFERENCES dbo.Users(UserId)
)

-- Solutions --
CREATE TABLE dbo.Solutions
(
	SolutionId INT IDENTITY(1,1) NOT NULL,
	OrganisationId INT NOT NULL,
	Name NVARCHAR(250) NOT NULL,
	IsOutOfDate BIT NOT NULL CONSTRAINT [DF_Solutions_IsOutOfDate] DEFAULT (0),
	IsReviewed BIT NOT NULL CONSTRAINT [DF_Solutions_IsReviewed] DEFAULT (0),
	IsInKnowledgeBase BIT NOT NULL CONSTRAINT [DF_Solutions_IsInKnowledgeBase] DEFAULT (0),
	KnowledgeArticleId INT NULL,
	SolutionNumber NVARCHAR(250) NOT NULL,
	CreatedAt DATETIME NOT NULL,
	CreatedById INT NOT NULL,
	LastModifiedAt DATETIME NOT NULL,
	LastModifiedById INT NOT NULL,
	IsDeleted INT NOT NULL CONSTRAINT [DF_Solutions_IsDeleted] DEFAULT (0),
	
	CONSTRAINT [PK_Solutions] PRIMARY KEY (SolutionId),
	CONSTRAINT [FK_Solutions_OrganisationId] FOREIGN KEY (OrganisationId) REFERENCES dbo.Organisations(OrganisationId),
	CONSTRAINT [FK_Solutions_KnowledgeArticleId] FOREIGN KEY (KnowledgeArticleId) REFERENCES dbo.KnowledgeArticles(KnowledgeArticleId),
	CONSTRAINT [FK_Solutions_CreatedById] FOREIGN KEY (CreatedById) REFERENCES dbo.Users(UserId),
	CONSTRAINT [FK_Solutions_LastModifiedById] FOREIGN KEY (LastModifiedById) REFERENCES dbo.Users(UserId)
)

-- Solution Tags --
CREATE TABLE dbo.SolutionTags
(	
	SolutionId INT NOT NULL,
	TagId INT NOT NULL,	
					
	CONSTRAINT [PK_SolutionTags] PRIMARY KEY CLUSTERED (SolutionId, TagId),
	CONSTRAINT [FK_SolutionTags_SolutionId] FOREIGN KEY (SolutionId) REFERENCES dbo.Solutions(SolutionId),
	CONSTRAINT [FK_SolutionTags_TagId] FOREIGN KEY (TagId) REFERENCES dbo.Tags(TagId)
)

-- Solution History --
CREATE TABLE dbo.SolutionHistory
(
	SolutionHistoryId INT IDENTITY(1,1) NOT NULL,
	SolutionId INT NOT NULL,
	FieldName NVARCHAR(250) NOT NULL,
	NewValue NVARCHAR(MAX) NOT NULL,
	OldValue NVARCHAR(MAX) NOT NULL,
	LastModifiedAt DATETIME NOT NULL,
	LastModifiedById INT NOT NULL,

	CONSTRAINT [PK_SolutionHistory] PRIMARY KEY (SolutionHistoryId),
	CONSTRAINT [FK_SolutionHistory_SolutionId] FOREIGN KEY (SolutionId) REFERENCES dbo.Solutions(SolutionId),
	CONSTRAINT [FK_SolutionHistory_LastModifiedById] FOREIGN KEY (LastModifiedById) REFERENCES dbo.Users(UserId)
)

-- Events --
CREATE TABLE dbo.Events
(
	EventId INT IDENTITY(1,1) NOT NULL,
	OrganisationId INT NOT NULL,	
	Name NVARCHAR(250) NOT NULL,
	Description NVARCHAR(MAX) NULL,
	StartOn DATETIME NOT NULL,
	EndOn DATETIME NOT NULL,
	IsGroupEvent BIT NOT NULL CONSTRAINT [DF_Events_IsGroupEvent] DEFAULT (0), -- True = Invitees, False = No Invitees
	DurationInMinutes INT NULL,	
	IsAllDay BIT NOT NULL CONSTRAINT [DF_Events_IsAllDay] DEFAULT (0),
	Location NVARCHAR(250) NULL,
	ShowTimeAs INT NULL,
	IsReminderSet BIT NOT NULL CONSTRAINT [DF_Events_IsReminderSet] DEFAULT (0),
	IsVisibleInSelfService BIT NOT NULL CONSTRAINT [DF_Events_IsVisibleInSelfService] DEFAULT (0),
	IsArchived BIT NOT NULL CONSTRAINT [DF_Events_IsArchived] DEFAULT (0),
	IsRecurrence BIT NOT NULL CONSTRAINT [DF_Events_IsRecurrence] DEFAULT (0),
	RecurrenceStartOn DATETIME NOT NULL,
	RecurrenceEndOn DATETIME NOT NULL,	
	RecurrenceDayOfWeek INT NULL,
	RecurrenceDayOfMonth INT NULL,
	RecurrenceMonthOfYear INT NULL, 
	RecurrenceInterval INT NULL,
	RecurrenceFrequencyId int NULL,
	CreatedAt DATETIME NOT NULL,
	CreatedById INT NOT NULL,
	LastModifiedAt DATETIME NOT NULL,
	LastModifiedById INT NOT NULL,
	IsDeleted INT NOT NULL CONSTRAINT [DF_Events_IsDeleted] DEFAULT (0),
	
	CONSTRAINT [PK_Event] PRIMARY KEY (EventId),
	CONSTRAINT [FK_Events_OrganisationId] FOREIGN KEY (OrganisationId) REFERENCES dbo.Organisations(OrganisationId),
	CONSTRAINT [FK_Events_RecurrenceFrequencyId] FOREIGN KEY (RecurrenceFrequencyId) REFERENCES dbo.Frequencies(FrequencyId),
	CONSTRAINT [FK_Events_CreatedById] FOREIGN KEY (CreatedById) REFERENCES dbo.Users(UserId),
	CONSTRAINT [FK_Events_LastModifiedById] FOREIGN KEY (LastModifiedById) REFERENCES dbo.Users(UserId)
)

-- Event Invitations --
CREATE TABLE dbo.EventInvitations
(
	EventId INT NOT NULL,
	FromId INT NOT NULL,
	ToEmail nvarchar(250) NOT NULL,
	Message NVARCHAR(MAX) NULL,
	
	CONSTRAINT [PK_EventInvitations] PRIMARY KEY CLUSTERED (EventId, FromId),
	CONSTRAINT [FK_EventInvitations_EventId] FOREIGN KEY (EventId) REFERENCES dbo.Events(EventId),
	CONSTRAINT [FK_EventInvitations_FromId] FOREIGN KEY (FromId) REFERENCES dbo.Users(UserId)
)

-- Event Member Statuses --
CREATE TABLE dbo.EventMemberStatuses
(
	EventMemberStatusId INT IDENTITY(1,1) NOT NULL,
	Name NVARCHAR(50) NOT NULL,
	IsDefault BIT NOT NULL CONSTRAINT [DF_EventStatuses_IsDefault] DEFAULT (0),
	HasResponded BIT NOT NULL CONSTRAINT [DF_EventStatuses_HasResponded] DEFAULT (0),

	CONSTRAINT [PK_EventMemberStatuses] PRIMARY KEY (EventMemberStatusId)
)

-- Event Members --
CREATE TABLE dbo.EventMembers
(
	EventId INT NOT NULL,
	EntityTypeId INT NOT NULL, -- Can only be User, Contacts or Leads entity types.
	EntityId INT NOT NULL,
	EventMemberStatusId INT NOT NULL,
	RespondedOn DATETIME NULL,
	Response NVARCHAR(MAX) NULL,
	IsDeleted INT NOT NULL CONSTRAINT [DF_EventMembers_IsDeleted] DEFAULT (0),	
	
	CONSTRAINT [PK_EventMembers] PRIMARY KEY CLUSTERED (EventId, EntityTypeId, EntityId),
	CONSTRAINT [FK_EventMembers_EntityTypeId] FOREIGN KEY (EntityTypeId) REFERENCES dbo.EntityTypes(EntityTypeId),
	CONSTRAINT [FK_EventMembers_EventMemberStatusId] FOREIGN KEY (EventMemberStatusId) REFERENCES dbo.EventMemberStatuses(EventMemberStatusId)
)

-- Event Tags --
CREATE TABLE dbo.EventTags
(	
	EventId INT NOT NULL,
	TagId INT NOT NULL,	
					
	CONSTRAINT [PK_EventTags] PRIMARY KEY CLUSTERED (EventId, TagId),
	CONSTRAINT [FK_EventTags_EventId] FOREIGN KEY (EventId) REFERENCES dbo.Events(EventId),
	CONSTRAINT [FK_EventTags_TagId] FOREIGN KEY (TagId) REFERENCES dbo.Tags(TagId)
)

-- Event History --
CREATE TABLE dbo.EventHistory
(
	EventHistoryId INT IDENTITY(1,1) NOT NULL,
	EventId INT NOT NULL,
	FieldName NVARCHAR(250) NOT NULL,
	NewValue NVARCHAR(MAX) NOT NULL,
	OldValue NVARCHAR(MAX) NOT NULL,
	LastModifiedAt DATETIME NOT NULL,
	LastModifiedById INT NOT NULL,

	CONSTRAINT [PK_EventHistory] PRIMARY KEY (EventHistoryId),
	CONSTRAINT [FK_EventHistory_EventId] FOREIGN KEY (EventId) REFERENCES dbo.Events(EventId),
	CONSTRAINT [FK_EventHistory_LastModifiedById] FOREIGN KEY (LastModifiedById) REFERENCES dbo.Users(UserId)
)

-- TaskTypes --
CREATE TABLE dbo.TaskTypes
(
	TaskTypeId INT IDENTITY(1,1) NOT NULL,
	Name NVARCHAR(250) NOT NULL,		

	CONSTRAINT [PK_TaskTypes] PRIMARY KEY (TaskTypeId)
)

-- Task Statuses --
CREATE TABLE dbo.TaskStatuses
(
	TaskStatusId INT IDENTITY(1,1) NOT NULL,
	Name NVARCHAR(250) NOT NULL,	
	IsDefault BIT NOT NULL CONSTRAINT [DF_TaskStatuses_IsDefault] DEFAULT (0),
	IsClosed BIT NOT NULL CONSTRAINT [DF_TaskStatuses_IsClosed] DEFAULT (0),

	CONSTRAINT [PK_TaskStatuses] PRIMARY KEY (TaskStatusId)
)

-- Tasks --
CREATE TABLE dbo.Tasks
(
	TaskId INT IDENTITY(1,1) NOT NULL,
	EntityTypeId INT NOT NULL,
	EntityId INT NOT NULL,	
	ParentId INT NOT NULL CONSTRAINT [DF_Tasks_ParentId] DEFAULT (0),		
	Title NVARCHAR(250) NOT NULL,
	TaskTypeId INT NULL,
	Description NVARCHAR(MAX) NULL,
	StartOn DATETIME NULL,
	EndOn DATETIME NULL,		
	DueOn DATETIME NULL, -- Note: This field cannot be set for a Tasks that is recurring.
	ClosedOn DATETIME NULL,						
	Duration INT NULL,
	EffortHours INT NULL,
	EffortMinutes INT NULL,
	TaskStatusId INT NOT NULL,
	PriorityId INT NOT NULL,
	CurrentProgress INT NOT NULL CONSTRAINT [DF_Tasks_CurrentProgress] DEFAULT (0),	 
	IsMileStone BIT NOT NULL CONSTRAINT [DF_Tasks_IsMileStone] DEFAULT (0),	 
	IsClosed BIT NOT NULL CONSTRAINT [DF_Tasks_IsClosed] DEFAULT (0),
	IsRecurrence BIT NOT NULL CONSTRAINT [DF_Tasks_IsRecurrence] DEFAULT (0),
	RecurrenceStartOn DATETIME NOT NULL,
	RecurrenceEndOn DATETIME NOT NULL,	
	RecurrenceDayOfWeek INT NULL,
	RecurrenceDayOfMonth INT NULL,
	RecurrenceMonthOfYear INT NULL, 
	RecurrenceInterval INT NULL,
	RecurrenceFrequencyId int NULL,
	OwnerId INT NOT NULL,
	CreatedAt DATETIME NOT NULL,
	CreatedById INT NOT NULL,
	LastModifiedAt DATETIME NOT NULL,
	LastModifiedById INT NOT NULL,
	IsDeleted INT NOT NULL CONSTRAINT [DF_Tasks_IsDeleted] DEFAULT (0),	

	CONSTRAINT [PK_Task] PRIMARY KEY (TaskId),
	CONSTRAINT [FK_Tasks_EntityTypeId] FOREIGN KEY (EntityTypeId) REFERENCES dbo.EntityTypes(EntityTypeId),
	CONSTRAINT [FK_Tasks_TaskTypeId] FOREIGN KEY (TaskTypeId) REFERENCES dbo.TaskTypes(TaskTypeId),
	CONSTRAINT [FK_Tasks_TaskStatusId] FOREIGN KEY (TaskStatusId) REFERENCES dbo.TaskStatuses(TaskStatusId),
	CONSTRAINT [FK_Tasks_PriorityId] FOREIGN KEY (PriorityId) REFERENCES dbo.Priorities(PriorityId),
	CONSTRAINT [FK_Tasks_RecurrenceFrequencyId] FOREIGN KEY (RecurrenceFrequencyId) REFERENCES dbo.Frequencies(FrequencyId),
	CONSTRAINT [FK_Tasks_OwnerId] FOREIGN KEY (OwnerId) REFERENCES dbo.Users(UserId),
	CONSTRAINT [FK_Tasks_CreatedById] FOREIGN KEY (CreatedById) REFERENCES dbo.Users(UserId),
	CONSTRAINT [FK_Tasks_LastModifiedById] FOREIGN KEY (LastModifiedById) REFERENCES dbo.Users(UserId)
)

-- Task Tags --
CREATE TABLE dbo.TaskTags
(	
	TaskId INT NOT NULL,
	TagId INT NOT NULL,	
					
	CONSTRAINT [PK_TaskTags] PRIMARY KEY CLUSTERED (TaskId, TagId),
	CONSTRAINT [FK_TaskTags_TaskId] FOREIGN KEY (TaskId) REFERENCES dbo.Tasks(TaskId),
	CONSTRAINT [FK_TaskTags_TagId] FOREIGN KEY (TagId) REFERENCES dbo.Tags(TagId)
)

-- Task History --
CREATE TABLE dbo.TaskHistory
(
	TaskHistoryId INT IDENTITY(1,1) NOT NULL,
	TaskId INT NOT NULL,
	FieldName NVARCHAR(250) NOT NULL,
	NewValue NVARCHAR(MAX) NOT NULL,
	OldValue NVARCHAR(MAX) NOT NULL,
	LastModifiedAt DATETIME NOT NULL,
	LastModifiedById INT NOT NULL,

	CONSTRAINT [PK_TaskHistory] PRIMARY KEY (TaskHistoryId),
	CONSTRAINT [FK_TaskHistory_TaskId] FOREIGN KEY (TaskId) REFERENCES dbo.Tasks(TaskId),
	CONSTRAINT [FK_TaskHistory_LastModifiedById] FOREIGN KEY (LastModifiedById) REFERENCES dbo.Users(UserId)
)

-- Activity Reminders --
CREATE TABLE dbo.ActivityReminders
(
	ActivityReminderId INT IDENTITY(1,1) NOT NULL,
	TaskId INT NULL,
	EventId INT NULL,
	NextReminderOn DATETIME NULL,
	LastSentDate DATETIME NULL,
	
	CONSTRAINT [PK_ActivityReminders] PRIMARY KEY (ActivityReminderId),
	CONSTRAINT [FK_ActivityReminders_TaskId] FOREIGN KEY (TaskId) REFERENCES dbo.Tasks(TaskId),
	CONSTRAINT [FK_ActivityReminders_EventId] FOREIGN KEY (EventId) REFERENCES dbo.Events(EventId)
)

-- Idea Categories --
CREATE TABLE dbo.IdeaCategories
(
	IdeaCategoryId INT IDENTITY(1,1) NOT NULL,
	Name NVARCHAR(250) NOT NULL,		

	CONSTRAINT [PK_IdeaCategories] PRIMARY KEY (IdeaCategoryId)
)

-- Ideas --
CREATE TABLE dbo.Ideas
(
	IdeaId INT IDENTITY(1,1) NOT NULL,
	IdeaCategoryId int NULL,
	Title NVARCHAR(250) NOT NULL,
	Body NVARCHAR(MAX) NULL,
	CommentCount INT NOT NULL CONSTRAINT [DF_Ideas_CommentCount] DEFAULT (0),
	VoteCount INT NOT NULL CONSTRAINT [DF_Ideas_VoteCount] DEFAULT (0),
	TotalRating INT NOT NULL CONSTRAINT [DF_Ideas_TotalRating] DEFAULT (0),
	IsAccepted BIT NOT NULL CONSTRAINT [DF_Ideas_IsAccepted] DEFAULT (0),
	ImplementedOn DATETIME NULL,
	IsClosed INT NOT NULL CONSTRAINT [DF_Ideas_IsClosed] DEFAULT (0),
	OwnerId INT NOT NULL,
	CreatedAt DATETIME NOT NULL,
	CreatedById INT NOT NULL,
	LastModifiedAt DATETIME NOT NULL,
	LastModifiedById INT NOT NULL,
	IsDeleted INT NOT NULL CONSTRAINT [DF_Ideas_IsDeleted] DEFAULT (0),

	CONSTRAINT [PK_Ideas] PRIMARY KEY (IdeaId),
	CONSTRAINT [FK_Ideas_IdeaCategoryId] FOREIGN KEY (IdeaCategoryId) REFERENCES dbo.IdeaCategories(IdeaCategoryId),
	CONSTRAINT [FK_Ideas_OwnerId] FOREIGN KEY (OwnerId) REFERENCES dbo.Users(UserId),
	CONSTRAINT [FK_Ideas_CreatedById] FOREIGN KEY (CreatedById) REFERENCES dbo.Users(UserId),
	CONSTRAINT [FK_Ideas_LastModifiedById] FOREIGN KEY (LastModifiedById) REFERENCES dbo.Users(UserId)
)

-- Projects --
CREATE TABLE dbo.Projects
(
	ProjectId INT IDENTITY(1,1) NOT NULL,
	Name NVARCHAR(250) NOT NULL,
	Description NVARCHAR(MAX) NULL,
	StartOn DATETIME NOT NULL,
	EndOn DATETIME NOT NULL,
	PriorityId INT NULL,
	AccountId INT NULL,
	IdeaId INT NULL,
	EnableTimeTracking BIT NOT NULL CONSTRAINT [DF_Projects_EnableTimeTracking] DEFAULT (0),
	IsPublic BIT NOT NULL CONSTRAINT [DF_Projects_IsPublic] DEFAULT (0),
	OwnerId INT NOT NULL,
	CreatedAt DATETIME NOT NULL,
	CreatedById INT NOT NULL,
	LastModifiedAt DATETIME NOT NULL,
	LastModifiedById INT NOT NULL,
	IsDeleted INT NOT NULL CONSTRAINT [DF_Projects_IsDeleted] DEFAULT (0),

	CONSTRAINT [PK_Project] PRIMARY KEY (ProjectId),
	CONSTRAINT [FK_Projects_PriorityId] FOREIGN KEY (PriorityId) REFERENCES dbo.Priorities(PriorityId),
	CONSTRAINT [FK_Projects_AccountId] FOREIGN KEY (AccountId) REFERENCES dbo.Accounts(AccountId),
	CONSTRAINT [FK_Projects_IdeaId] FOREIGN KEY (IdeaId) REFERENCES dbo.Ideas(IdeaId),
	CONSTRAINT [FK_Projects_OwnerId] FOREIGN KEY (OwnerId) REFERENCES dbo.Users(UserId),
	CONSTRAINT [FK_Projects_CreatedById] FOREIGN KEY (CreatedById) REFERENCES dbo.Users(UserId),
	CONSTRAINT [FK_Projects_LastModifiedById] FOREIGN KEY (LastModifiedById) REFERENCES dbo.Users(UserId)
)

-- SkillTypes --
CREATE TABLE dbo.SkillTypes
(	
	SkillTypeId INT IDENTITY(1,1) NOT NULL,	
	Name NVARCHAR(250) NOT NULL,
					
	CONSTRAINT [PK_SkillTypes] PRIMARY KEY (SkillTypeId)
)

-- Skill Levels --
CREATE TABLE dbo.SkillLevels
(	
	SkillLevelId INT IDENTITY(1,1) NOT NULL,	
	Name NVARCHAR(250) NOT NULL,
					
	CONSTRAINT [PK_SkillLevels] PRIMARY KEY (SkillLevelId)
)

-- Resources --
CREATE TABLE dbo.Resources
(
	ResourceId INT IDENTITY(1,1) NOT NULL,
	UserId INT NULL,
	ContactId INT NULL,
	SkillTypeId INT  NOT NULL,
	SkillLevelId INT NOT NULL,
	Description NVARCHAR(MAX) NULL,
	IsCapitalAsset BIT NOT NULL CONSTRAINT [DF_Resources_IsCapitalAsset] DEFAULT (0),
	
	CONSTRAINT [PK_Resources] PRIMARY KEY (ResourceId),
	CONSTRAINT [FK_Resources_UserId] FOREIGN KEY (UserId) REFERENCES dbo.Users(UserId),
	CONSTRAINT [FK_Resources_ContactId] FOREIGN KEY (ContactId) REFERENCES dbo.Contacts(ContactId),
	CONSTRAINT [FK_Resources_SkillTypeId] FOREIGN KEY (SkillTypeId) REFERENCES dbo.SkillTypes(SkillTypeId),
	CONSTRAINT [FK_Resources_SkillLevelId] FOREIGN KEY (SkillLevelId) REFERENCES dbo.SkillLevels(SkillLevelId)
)

-- Project Resources --
CREATE TABLE dbo.ProjectResources
(	
	ProjectId INT NOT NULL,
	ResourceId INT NOT NULL,
	ActualCostPerHour DECIMAL(10,2) NULL,
	BillingCostPerHour DECIMAL(10,2) NULL,
	ActualOvertimePerHour DECIMAL(10,2) NULL,
	BillingOvertimePerHour DECIMAL(10,2) NULL,
	ActualCostPerUse DECIMAL(10,2) NULL,
	BillingCostPerUse DECIMAL(10,2) NULL,
	ActualCostPerDay DECIMAL(10,2) NULL,
	BillingCostPerDay DECIMAL(10,2) NULL,
					
	CONSTRAINT [PK_ProjectResources] PRIMARY KEY CLUSTERED (ProjectId, ResourceId),
	CONSTRAINT [FK_ProjectResources_ProjectId] FOREIGN KEY (ProjectId) REFERENCES dbo.Projects(ProjectId),
	CONSTRAINT [FK_ProjectResources_ResourceId] FOREIGN KEY (ResourceId) REFERENCES dbo.Resources(ResourceId)
)

-- Project Contacts --
CREATE TABLE dbo.ProjectContacts
(
	ProjectId INT NOT NULL,
	ContactId INT NOT NULL,
	ContactRoleId INT NOT NULL,
	IsPrimary BIT NOT NULL CONSTRAINT [DF_ProjectContacts_IsPrimary] DEFAULT (0),	

	CONSTRAINT [PK_ProjectContacts] PRIMARY KEY CLUSTERED (ProjectId, ContactId),
	CONSTRAINT [FK_ProjectContacts_AccountId] FOREIGN KEY (ProjectId) REFERENCES dbo.Projects(ProjectId),
	CONSTRAINT [FK_ProjectContacts_ContactId] FOREIGN KEY (ContactId) REFERENCES dbo.Contacts(ContactId),
	CONSTRAINT [FK_ProjectContacts_ContactRoleId] FOREIGN KEY (ContactRoleId) REFERENCES dbo.ContactRoles(ContactRoleId)
)

-- Project Teams --
CREATE TABLE dbo.ProjectTeams
(	
	ProjectId INT NOT NULL,	
	TeamId INT NOT NULL,
					
	CONSTRAINT [PK_ProjectTeams] PRIMARY KEY CLUSTERED (ProjectId, TeamId),
	CONSTRAINT [FK_ProjectTeams_ProjectId] FOREIGN KEY (ProjectId) REFERENCES dbo.Projects(ProjectId),
	CONSTRAINT [FK_ProjectTeams_TeamId] FOREIGN KEY (TeamId) REFERENCES dbo.Teams(TeamId)
)

-- Project Tags --
CREATE TABLE dbo.ProjectTags
(	
	ProjectId INT NOT NULL,
	TagId INT NOT NULL,	
					
	CONSTRAINT [PK_ProjectTags] PRIMARY KEY CLUSTERED (ProjectId, TagId),
	CONSTRAINT [FK_ProjectTags_ProjectId] FOREIGN KEY (ProjectId) REFERENCES dbo.Projects(ProjectId),
	CONSTRAINT [FK_ProjectTags_TagId] FOREIGN KEY (TagId) REFERENCES dbo.Tags(TagId)
)

-- Project History --
CREATE TABLE dbo.ProjectHistory
(
	ProjectHistoryId INT IDENTITY(1,1) NOT NULL,
	ProjectId INT NOT NULL,
	FieldName NVARCHAR(250) NOT NULL,
	NewValue NVARCHAR(MAX) NOT NULL,
	OldValue NVARCHAR(MAX) NOT NULL,
	LastModifiedAt DATETIME NOT NULL,
	LastModifiedById INT NOT NULL,

	CONSTRAINT [PK_ProjectHistory] PRIMARY KEY (ProjectHistoryId),
	CONSTRAINT [FK_ProjectHistory_ProjectId] FOREIGN KEY (ProjectId) REFERENCES dbo.Projects(ProjectId),
	CONSTRAINT [FK_ProjectHistory_LastModifiedById] FOREIGN KEY (LastModifiedById) REFERENCES dbo.Users(UserId)
)

-- Timesheets --
CREATE TABLE dbo.Timesheets
(
	TimesheetId INT IDENTITY(1,1) NOT NULL,	
	TaskId INT NOT NULL,
	Description NVARCHAR(MAX) NULL,
	StartOn DATETIME NULL,
	EndOn DATETIME NULL,
	IsOvertime BIT NOT NULL CONSTRAINT [DF_Timesheets_IsOvertime] DEFAULT (0),
	EffortHours INT NULL,
	EffortMinutes INT NULL,
	TravelTime INT NULL,
	BillableHours INT NOT NULL,
	IsBillable BIT NOT NULL CONSTRAINT [DF_Timesheets_IsBillable] DEFAULT (0),
	ExcludeFromInvoice BIT NOT NULL CONSTRAINT [DF_Timesheets_ExcludeFromInvoice] DEFAULT (0),
	ResourceId INT NULL,
	OwnerId INT NOT NULL,
	CreatedAt DATETIME NOT NULL,
	CreatedById INT NOT NULL,
	LastModifiedAt DATETIME NOT NULL,
	LastModifiedById INT NOT NULL,
	IsDeleted INT NOT NULL CONSTRAINT [DF_Timesheets_IsDeleted] DEFAULT (0),

	CONSTRAINT [PK_Timesheets] PRIMARY KEY (TimesheetId),
	CONSTRAINT [FK_Timesheets_TaskId] FOREIGN KEY (TaskId) REFERENCES dbo.Tasks(TaskId),
	CONSTRAINT [FK_Timesheets_ResourceId] FOREIGN KEY (ResourceId) REFERENCES dbo.Resources(ResourceId),
	CONSTRAINT [FK_Timesheets_OwnerId] FOREIGN KEY (OwnerId) REFERENCES dbo.Users(UserId),
	CONSTRAINT [FK_Timesheets_CreatedById] FOREIGN KEY (CreatedById) REFERENCES dbo.Users(UserId),
	CONSTRAINT [FK_Timesheets_LastModifiedById] FOREIGN KEY (LastModifiedById) REFERENCES dbo.Users(UserId)
)

-- Expense Types --
CREATE TABLE dbo.ExpenseTypes
(
	ExpenseTypeId INT IDENTITY(1,1) NOT NULL,
	OrganisationId INT NULL,
	Name NVARCHAR(250) NOT NULL,

	CONSTRAINT [PK_ExpenseTypes] PRIMARY KEY (ExpenseTypeId),
	CONSTRAINT [FK_ExpenseTypes_OrganisationId] FOREIGN KEY (OrganisationId) REFERENCES dbo.Organisations(OrganisationId)
)

-- Expense Statuses --
CREATE TABLE dbo.ExpenseStatuses
(
	ExpenseStatusId INT IDENTITY(1,1) NOT NULL,
	Name NVARCHAR(250) NOT NULL,

	CONSTRAINT [PK_ExpenseStatuses] PRIMARY KEY (ExpenseStatusId)
)

-- Expenses --
CREATE TABLE dbo.Expenses
(
	ExpenseId INT IDENTITY(1,1) NOT NULL,
	UserId INT NOT NULL,
	ProjectId INT NULL,
	AccountId INT NULL,
	Title NVARCHAR(250) NOT NULL,
	Description NVARCHAR(MAX) NULL,
	ApprovedTotal DECIMAL(10,2) NOT NULL,
	CashAdvance DECIMAL(10,2) NULL,
	AmountDue DECIMAL(10,2) NOT NULL,
	CurrencyId INT NOT NULL,
	MarkupPercentage INT NULL,
	ExpenseStatusId INT NULL,
	SubmittedOn DATETIME NULL,
	SubmittedById INT NULL,
	ApprovedOn DATETIME NULL,
	ApprovedById INT NULL,
	PaidOn DATETIME NULL,
	CreatedAt DATETIME NOT NULL,
	CreatedById INT NOT NULL,
	LastModifiedAt DATETIME NOT NULL,
	LastModifiedById INT NOT NULL,
	IsDeleted INT NOT NULL CONSTRAINT [DF_Expenses_IsDeleted] DEFAULT (0),		

	CONSTRAINT [PK_Expenses] PRIMARY KEY (ExpenseId),
	CONSTRAINT [FK_Expenses_UserId] FOREIGN KEY (UserId) REFERENCES dbo.Users(UserId),
	CONSTRAINT [FK_Expenses_ProjectId] FOREIGN KEY (ProjectId) REFERENCES dbo.Projects(ProjectId),
	CONSTRAINT [FK_Expenses_AccountId] FOREIGN KEY (AccountId) REFERENCES dbo.Accounts(AccountId),
	CONSTRAINT [FK_Expenses_CurrencyId] FOREIGN KEY (CurrencyId) REFERENCES dbo.Currencies(CurrencyId),
	CONSTRAINT [FK_Expenses_ExpenseStatusId] FOREIGN KEY (ExpenseStatusId) REFERENCES dbo.ExpenseStatuses(ExpenseStatusId),
	CONSTRAINT [FK_Expenses_SubmittedById] FOREIGN KEY (SubmittedById) REFERENCES dbo.Users(UserId),
	CONSTRAINT [FK_Expenses_ApprovedById] FOREIGN KEY (ApprovedById) REFERENCES dbo.Users(UserId),
	CONSTRAINT [FK_Expenses_CreatedById] FOREIGN KEY (CreatedById) REFERENCES dbo.Users(UserId),
	CONSTRAINT [FK_Expenses_LastModifiedById] FOREIGN KEY (LastModifiedById) REFERENCES dbo.Users(UserId)
)

-- Expense Items --
CREATE TABLE dbo.ExpenseItems
(
	ExpenseId INT NOT NULL,
	ExpenseTypeId INT NOT NULL,
	Name NVARCHAR(250),
	Cost DECIMAL(10,2) NOT NULL,
	ExpenseOn DATETIME NOT NULL,
	ExlcudeFromInvoice BIT NOT NULL CONSTRAINT [DF_ExpenseItems_ExlcudeFromInvoice] DEFAULT (0),
	IsApproved BIT NOT NULL CONSTRAINT [DF_ExpenseItems_IsApproved] DEFAULT (0),	

	CONSTRAINT [PK_ExpenseItems] PRIMARY KEY CLUSTERED (ExpenseId, ExpenseTypeId),
	CONSTRAINT [FK_ExpenseItems_ExpenseId] FOREIGN KEY (ExpenseId) REFERENCES dbo.Expenses(ExpenseId),
	CONSTRAINT [FK_ExpenseItems_ExpenseTypeId] FOREIGN KEY (ExpenseTypeId) REFERENCES dbo.ExpenseTypes(ExpenseTypeId)
)

-- Bug Types --
CREATE TABLE dbo.BugTypes
(
	BugTypeId INT IDENTITY(1,1) NOT NULL,
	OrganisationId INT NULL,
	Name NVARCHAR(250) NOT NULL,		

	CONSTRAINT [PK_BugTypes] PRIMARY KEY (BugTypeId),
	CONSTRAINT [FK_BugTypes_OrganisationId] FOREIGN KEY (OrganisationId) REFERENCES dbo.Organisations(OrganisationId)
)

-- Bug Statuses --
CREATE TABLE dbo.BugStatuses
(
	BugStatusId INT IDENTITY(1,1) NOT NULL,
	Name NVARCHAR(250) NOT NULL,
	IsDefault BIT NOT NULL CONSTRAINT [DF_BugStatuses_IsDefault] DEFAULT (0),	

	CONSTRAINT [PK_BugStatuses] PRIMARY KEY (BugStatusId)
)

-- Bug --
CREATE TABLE dbo.Bug
(
	BugId INT IDENTITY(1,1) NOT NULL,
	BugTypeId INT NULL,
	Title NVARCHAR(250) NOT NULL,
	Description NVARCHAR(MAX) NULL,
	PriorityId INT NULL,
	BugStatusId INT NOT NULL,
	OriginId INT NOT NULL,
	CaseId INT NULL,
	StartOn DATETIME NULL,
	EndOn DATETIME NULL,
	DueOn DATETIME NULL,
	Duration INT NULL,
	EffortHours INT NULL,
	EffortMinutes INT NULL,
	FoundInVersion INT NULL,
	FixedInVersion INT NULL,
	CanReproduce BIT NOT NULL CONSTRAINT [DF_Bug_CanReproduce] DEFAULT (0),
	IsFlagged BIT NOT NULL CONSTRAINT [DF_Bug_IsFlagged] DEFAULT (0),
	IsResolved BIT NOT NULL CONSTRAINT [DF_Bug_IsResolved] DEFAULT (0),
	ResolvedOn DATETIME NULL,
	ResolvedById INT NULL,
	OwnerId INT NOT NULL,
	CreatedAt DATETIME NOT NULL,
	CreatedById INT NOT NULL,
	LastModifiedAt DATETIME NOT NULL,
	LastModifiedById INT NOT NULL,
	IsDeleted INT NOT NULL CONSTRAINT [DF_Bug_IsDeleted] DEFAULT (0),
	
	CONSTRAINT [PK_Bug] PRIMARY KEY (BugId),
	CONSTRAINT [FK_Bug_BugTypeId] FOREIGN KEY (BugTypeId) REFERENCES dbo.BugTypes(BugTypeId),
	CONSTRAINT [FK_Bug_PriorityId] FOREIGN KEY (PriorityId) REFERENCES dbo.Priorities(PriorityId),	
	CONSTRAINT [FK_Bug_BugStatusId] FOREIGN KEY (BugStatusId) REFERENCES dbo.BugStatuses(BugStatusId),
	CONSTRAINT [FK_Bug_OriginId] FOREIGN KEY (OriginId) REFERENCES dbo.Origins(OriginId),
	CONSTRAINT [FK_Bug_CaseId] FOREIGN KEY (CaseId) REFERENCES dbo.Cases(CaseId),
	CONSTRAINT [FK_Bug_ResolvedById] FOREIGN KEY (ResolvedById) REFERENCES dbo.Users(UserId),
	CONSTRAINT [FK_Bug_OwnerId] FOREIGN KEY (OwnerId) REFERENCES dbo.Users(UserId),
	CONSTRAINT [FK_Bug_CreatedById] FOREIGN KEY (CreatedById) REFERENCES dbo.Users(UserId),
	CONSTRAINT [FK_Bug_LastModifiedById] FOREIGN KEY (LastModifiedById) REFERENCES dbo.Users(UserId)
)

-- Bug Tags --
CREATE TABLE dbo.BugTags
(	
	BugId INT NOT NULL,
	TagId INT NOT NULL,	
					
	CONSTRAINT [PK_BugTags] PRIMARY KEY CLUSTERED (BugId, TagId),
	CONSTRAINT [FK_BugTags_BugId] FOREIGN KEY (BugId) REFERENCES dbo.Bug(BugId),
	CONSTRAINT [FK_BugTags_TagId] FOREIGN KEY (TagId) REFERENCES dbo.Tags(TagId)
)

-- Bug History --
CREATE TABLE dbo.BugHistory
(
	BugHistoryId INT IDENTITY(1,1) NOT NULL,
	BugId INT NOT NULL,
	FieldName NVARCHAR(250) NOT NULL,
	NewValue NVARCHAR(MAX) NOT NULL,
	OldValue NVARCHAR(MAX) NOT NULL,
	LastModifiedAt DATETIME NOT NULL,
	LastModifiedById INT NOT NULL,

	CONSTRAINT [PK_BugHistory] PRIMARY KEY (BugHistoryId),
	CONSTRAINT [FK_BugHistory_BugId] FOREIGN KEY (BugId) REFERENCES dbo.Bug(BugId),
	CONSTRAINT [FK_BugHistory_LastModifiedById] FOREIGN KEY (LastModifiedById) REFERENCES dbo.Users(UserId)
)

-- Email Statuses --
CREATE TABLE dbo.EmailStatuses
(
	EmailStatusId INT IDENTITY(1,1) NOT NULL,
	Name NVARCHAR(250) NOT NULL,

	CONSTRAINT [PK_EmailStatuses] PRIMARY KEY (EmailStatusId)
)

-- Email Messages --
CREATE TABLE dbo.EmailMessages
(
	EmailMessageId INT IDENTITY(1,1) NOT NULL,
	OrganisationId INT NOT NULL,
	EntityTypeId INT NOT NULL,
	EntityId INT NOT NULL,
	Subject NVARCHAR(250) NULL,
	FromAddress NVARCHAR(250) NOT NULL,
	FromName NVARCHAR(250) NULL,
	ToAddress NVARCHAR(MAX) NULL,
	CcAddresses NVARCHAR(MAX) NULL,
	BccAddresses NVARCHAR(MAX) NULL,
	PriorityId INT NULL,
	PlainTextBody NVARCHAR(MAX) NULL,
	HtmlBody NVARCHAR(MAX) NULL,
	SendTextOnly BIT NOT NULL CONSTRAINT [DF_EmailMessages_SendTextOnly] DEFAULT (0),
	HasAttachment BIT NOT NULL CONSTRAINT [DF_EmailMessages_HasAttachment] DEFAULT (0), 
	IsIncoming BIT NOT NULL CONSTRAINT [DF_EmailMessages_IsIncoming] DEFAULT (0), 
	IsWorkflowCreated BIT NOT NULL CONSTRAINT [DF_EmailMessages_IsWorkflowCreated] DEFAULT (0), 
	EmailStatusId INT NOT NULL,
	SentOn DATETIME NOT NULL,
	ActualStartOn DATETIME NOT NULL,
	ActualEndOn DATETIME NULL,
	CreatedById INT NOT NULL,
	CreatedAt DATETIME NOT NULL,
	LastModifiedById INT NOT NULL,
	LastModifiedAt DATETIME NOT NULL,
	IsDeleted INT NOT NULL CONSTRAINT [DF_EmailMessages_IsDeleted] DEFAULT (0),

	CONSTRAINT [PK_EmailMessages] PRIMARY KEY (EmailMessageId),
	CONSTRAINT [FK_EmailMessages_OrganisationId] FOREIGN KEY (OrganisationId) REFERENCES dbo.Organisations(OrganisationId),
	CONSTRAINT [FK_EmailMessages_EntityTypeId] FOREIGN KEY (EntityTypeId) REFERENCES dbo.EntityTypes(EntityTypeId),
	CONSTRAINT [FK_EmailMessages_PriorityId] FOREIGN KEY (PriorityId) REFERENCES dbo.Priorities(PriorityId),
	CONSTRAINT [FK_EmailMessages_EmailStatusId] FOREIGN KEY (EmailStatusId) REFERENCES dbo.EmailStatuses(EmailStatusId),
	CONSTRAINT [FK_EmailMessages_CreatedById] FOREIGN KEY (CreatedById) REFERENCES dbo.Users(UserId),
	CONSTRAINT [FK_EmailMessages_LastModifiedById] FOREIGN KEY (LastModifiedById) REFERENCES dbo.Users(UserId)
)

-- Event Log Types --
CREATE TABLE dbo.EventLogTypes
(	
	EventLogTypeId INT IDENTITY(1,1) NOT NULL,
	Name NVARCHAR(250) NOT NULL,	
					
	CONSTRAINT [PK_EventLogTypes] PRIMARY KEY (EventLogTypeId)
)

-- Event Logs --
CREATE TABLE dbo.EventLogs
(	
	EventLogId INT IDENTITY(1,1) NOT NULL,
	EventLogTypeId INT NOT NULL,
	Message NVARCHAR(MAX) NOT NULL,
	AccountId INT NULL,
	LoggedAt DATETIME NOT NULL,	
	LoggedById INT NOT NULL,
					
	CONSTRAINT [PK_EventLogs] PRIMARY KEY (EventLogId),
	CONSTRAINT [FK_EventLogs_EventLogTypeId] FOREIGN KEY (EventLogTypeId) REFERENCES dbo.EventLogTypes(EventLogTypeId),
	CONSTRAINT [FK_EventLogs_AccountId] FOREIGN KEY (AccountId) REFERENCES dbo.Accounts(AccountId),
	CONSTRAINT [FK_EventLogs_LoggedById] FOREIGN KEY (LoggedById) REFERENCES dbo.Users(UserId)
)

-- Entity History --
CREATE TABLE dbo.EntityHistory
(	
	EntityHistoryId INT IDENTITY(1,1) NOT NULL,
	EventLogId INT NOT NULL,
	FieldName NVARCHAR(250) NOT NULL,
	OriginalValue NVARCHAR(250) NOT NULL,
	NewValue NVARCHAR(250) NOT NULL,	
					
	CONSTRAINT [PK_EntityHistory] PRIMARY KEY (EntityHistoryId),
	CONSTRAINT [FK_EntityHistory_EventLogId] FOREIGN KEY (EventLogId) REFERENCES dbo.EventLogs(EventLogId)
)

-- Errors --
CREATE TABLE dbo.ErrorLogs
(
	ErrorLogId INT IDENTITY(1,1) NOT NULL,
	LoggedAt DATETIME NOT NULL,
	Message NVARCHAR(MAX) NOT NULL,
	Source NVARCHAR(250) NOT NULL,
	TargetSite NVARCHAR(250) NOT NULL,
	StackTrace NVARCHAR(MAX) NOT NULL,
	ServerName NVARCHAR(250) NOT NULL,
	RequestUrl NVARCHAR(500) NOT NULL,
	Browser NVARCHAR(250) NOT NULL,
	IPAddress NVARCHAR(15) NOT NULL,
	IsAuthenticated BIT NOT NULL,	
	UserName NVARCHAR(250) NOT NULL,

	CONSTRAINT [PK_ErrorLogs] PRIMARY KEY (ErrorLogId)
)