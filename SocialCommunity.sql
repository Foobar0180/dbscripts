/* 
Descriptiom: Social Community Database Schema V1.0
Created By:  David Winchester
Last Update: 09 September, 2010
*/

-- Schema Versions --
CREATE TABLE dbo.SchemaVersions
(
	Major INT NOT NULL,		
	Minor INT NOT NULL,		
	Patch INT NOT NULL,		
	InstalledAt DATETIME NOT NULL,
		
	CONSTRAINT [PK_SchemaVersions] PRIMARY KEY CLUSTERED (Major, Minor, Patch)
)

-- Modules --
CREATE TABLE dbo.Modules
(
	ModuleID INT IDENTITY(1,1) NOT NULL,
	Name NVARCHAR(250) NOT NULL,
	Description NVARCHAR(MAX) NULL,
		
	CONSTRAINT [PK_Modules] PRIMARY KEY (ModuleID)
)

-- Languages --
CREATE TABLE dbo.Languages
(	
	LanguageID INT IDENTITY(1,1) NOT NULL,
	Name NVARCHAR(250) NOT NULL,
	CultureCode NVARCHAR(10) NOT NULL,
						
	CONSTRAINT [PK_Languages] PRIMARY KEY (LanguageID)
)

-- Errors --
CREATE TABLE dbo.ErrorLogs
(
	ErrorLogID INT IDENTITY(1,1) NOT NULL,
	LoggedAt DATETIME NOT NULL,
	Message NVARCHAR(MAX) NOT NULL,
	Source NVARCHAR(250) NOT NULL,
	TargetSite NVARCHAR(250) NOT NULL,
	StackTrace NVARCHAR(MAX) NOT NULL,
	ServerName NVARCHAR(250) NOT NULL,
	RequestUrl NVARCHAR(250) NOT NULL,
	Browser NVARCHAR(250) NOT NULL,
	IPAddress NVARCHAR(15) NOT NULL,
	IsAuthenticated BIT NOT NULL,	
	UserName NVARCHAR(250) NOT NULL,

	CONSTRAINT [PK_ErrorLogs] PRIMARY KEY (ErrorLogID)
)

-- Roles --
CREATE TABLE dbo.[Roles]
(	
	RoleID INT IDENTITY(1,1) NOT NULL,
	Name NVARCHAR(250) NOT NULL,
						
	CONSTRAINT [PK_Roles] PRIMARY KEY (RoleID)
)

-- Users --
CREATE TABLE dbo.[Users]
(	
	UserID INT IDENTITY(1,1) NOT NULL,
	UserName NVARCHAR(250) NOT NULL,
	Email NVARCHAR(250) NOT NULL,
	Comment NVARCHAR(MAX) NULL,
	Password NVARCHAR(250) NOT NULL,
	PasswordQuestion NVARCHAR(250) NULL,
	PasswordAnswer NVARCHAR(250) NULL,
	IsApproved BIT NOT NULL CONSTRAINT [DF_Users_IsApproved] DEFAULT (0), 
	IsLockedOut BIT NOT NULL CONSTRAINT [DF_Users_IsLockedOut] DEFAULT (0),
	CreatedAt DATETIME NOT NULL, 
	LastActivityAt DATETIME NOT NULL,
	LastLoginAt DATETIME NOT NULL,
	LastPasswordChangedAt DATETIME NOT NULL,
	LastLockoutAt DATETIME NOT NULL,
	FailedPasswordAttemptCount INT NOT NULL CONSTRAINT [DF_Users_FailedPasswordAttemptCount] DEFAULT (0),
	FailedPasswordAttemptWindowStart DATETIME NOT NULL,
	FailedPasswordAnswerAttemptCount INT NOT NULL CONSTRAINT [DF_Users_FailedPasswordAnswerAttemptCount] DEFAULT (0),
	FailedPasswordAnswerAttemptWindowStart DATETIME NOT NULL,
		
	CONSTRAINT [PK_Users] PRIMARY KEY (UserID)
)

-- Users In Roles --
CREATE TABLE dbo.UsersInRoles
(	
	UserID INT NOT NULL,
	RoleID INT NOT NULL,
						
	CONSTRAINT [PK_UsersInRoles] PRIMARY KEY CLUSTERED (UserID, RoleID),
	CONSTRAINT [FK_UsersInRoles_UserID] FOREIGN KEY (UserID) REFERENCES dbo.[Users](UserID),
	CONSTRAINT [FK_UsersInRoles_RoleID] FOREIGN KEY (RoleID) REFERENCES dbo.Roles(RoleID)
)

-- Profiles --
CREATE TABLE dbo.Profiles
(	
	UserID INT NOT NULL,
	KeyName NVARCHAR(250) NOT NULL,
	BinaryValue varbinary(max) NULL,
	XmlValue NVARCHAR(MAX) NULL,
	ModifiedAt DATETIME NOT NULL,		
						
	CONSTRAINT [PK_Profiles] PRIMARY KEY (UserID),
	CONSTRAINT [FK_Profiles_UserID] FOREIGN KEY (UserID) REFERENCES dbo.[Users](UserID)
)

-- Permissions --
CREATE TABLE dbo.[Permissions]
(	
	PermissionID INT IDENTITY(1,1) NOT NULL,
	RoleID INT NOT NULL,
	ModuleID INT NOT NULL,
	CanView BIT NOT NULL CONSTRAINT [DF_Permissions_CanView] DEFAULT (0),
	CanCreate BIT NOT NULL CONSTRAINT [DF_Permissions_CanCreate] DEFAULT (0),
	CanEdit BIT NOT NULL CONSTRAINT [DF_Permissions_CanEdit] DEFAULT (0),
	CanDelete BIT NOT NULL CONSTRAINT [DF_Permissions_CanDelete] DEFAULT (0),
	CanChangePermission BIT NOT NULL CONSTRAINT [DF_Permissions_CanChangePermission] DEFAULT (0),
						
	CONSTRAINT [PK_Permissions] PRIMARY KEY (PermissionID),
	CONSTRAINT [FK_Permissions_RoleID] FOREIGN KEY (RoleID) REFERENCES dbo.Roles(RoleID),
	CONSTRAINT [FK_Permissions_ModuleID] FOREIGN KEY (ModuleID) REFERENCES dbo.Modules(ModuleID)
)

-- Workflows --
CREATE TABLE dbo.Workflows
(	
	WorkflowID INT IDENTITY(1,1) NOT NULL,
	Name NVARCHAR(250) NOT NULL,
						
	CONSTRAINT [PK_Workflows] PRIMARY KEY (WorkflowID)
)

-- Workflow Steps --
CREATE TABLE dbo.WorkflowSteps
(	
	WorkflowStepID INT IDENTITY(1,1) NOT NULL,
	WorkflowID INT NOT NULL,
	Name NVARCHAR(250) NOT NULL,
	Ordinal INT NOT NULL CONSTRAINT [DF_WorkflowSteps_Ordinal] DEFAULT (0),
						
	CONSTRAINT [PK_WorkflowStepID] PRIMARY KEY (WorkflowStepID),
	CONSTRAINT [FK_WorkflowSteps_WorkflowID] FOREIGN KEY (WorkflowID) REFERENCES dbo.Workflows(WorkflowID)
)

-- Workflow Step Roles --
CREATE TABLE dbo.WorkflowStepRoles
(	
	WorkflowStepID INT NOT NULL,
	RoleID INT NOT NULL,
						
	CONSTRAINT [PK_WorkflowStepRoles] PRIMARY KEY CLUSTERED (WorkflowStepID, RoleID),
	CONSTRAINT [FK_WorkflowStepRoles_WorkflowStepID] FOREIGN KEY (WorkflowStepID) REFERENCES dbo.WorkflowSteps(WorkflowStepID),
	CONSTRAINT [FK_WorkflowStepRoles_RoleID] FOREIGN KEY (RoleID) REFERENCES dbo.Roles(RoleID)
)

-- Publish Statuses --
CREATE TABLE dbo.PublishStatuses
(	
	PublishStatusID INT IDENTITY(1,1) NOT NULL,
	Name NVARCHAR(250) NOT NULL,
	IconImageUrl NVARCHAR(250) NULL,
						
	CONSTRAINT [PK_PublishStatuses] PRIMARY KEY (PublishStatusID)
)

-- Page Templates --
CREATE TABLE dbo.PageTemplates
(
	PageTemplateID INT IDENTITY(1,1) NOT NULL,
	Name NVARCHAR(250) NOT NULL,
	Title NVARCHAR(250) NULL,
	Description NVARCHAR(MAX) NULL,
	Keywords NVARCHAR(250) NULL,
	BufferOutput BIT NOT NULL CONSTRAINT [DF_PageTemplates_BufferOutput] DEFAULT (0),
	CacheOutput BIT NOT NULL CONSTRAINT [DF_PageTemplates_CacheOutput] DEFAULT (0),
	CacheDuration INT NOT NULL CONSTRAINT [DF_PageTemplates_CacheDuration] DEFAULT (0),
	SlidingExpiration BIT NOT NULL CONSTRAINT [DF_PageTemplates_SlidingExpiration] DEFAULT (0),
	CultureCode NVARCHAR(10) NOT NULL,
	ErrorPage NVARCHAR(250) NULL,
	EventValidationEnabled BIT NOT NULL CONSTRAINT [DF_PageTemplates_EventValidationEnabled] DEFAULT (0),
	IncludeScriptManager BIT NOT NULL CONSTRAINT [DF_PageTemplates_IncludeScriptManager] DEFAULT (0),
	MaintainScrollPosition BIT NOT NULL CONSTRAINT [DF_PageTemplates_MaintainScrollPosition] DEFAULT (0),
	MasterPage NVARCHAR(250) NULL,
	RequiresHttps BIT NOT NULL CONSTRAINT [DF_PageTemplates_RequiresHttps] DEFAULT (0),
	ResponseEncoding NVARCHAR(250) NULL,
	SessionStateEnabled BIT NOT NULL CONSTRAINT [DF_PageTemplates_SessionStateEnabled] DEFAULT (0),
	IsNavigable BIT NOT NULL CONSTRAINT [DF_PageTemplates_IsNavigable] DEFAULT (1),
	ShowInNavigation BIT NOT NULL CONSTRAINT [DF_PageTemplates_ShowInNavigation] DEFAULT (1),
	ThemingEnabled BIT NOT NULL CONSTRAINT [DF_PageTemplates_ThemingEnabled] DEFAULT (1),
	Theme NVARCHAR(250) NULL,
	ValidateRequest BIT NOT NULL CONSTRAINT [DF_PageTemplates_ValidateRequest] DEFAULT (1),
	ViewStateEnabled BIT NOT NULL CONSTRAINT [DF_PageTemplates_ViewStateEnabled] DEFAULT (1),		
	VersionNumber INT NOT NULL CONSTRAINT [DF_PageTemplates_VersionNumber] DEFAULT (1),	
	Ordinal INT NOT NULL CONSTRAINT [DF_PageTemplates_Ordinal] DEFAULT (0),
	LockedByID INT NULL,
	ModifiedAt DATETIME NOT NULL,
		
	CONSTRAINT [PK_PageTemplates] PRIMARY KEY (PageTemplateID),
	CONSTRAINT [FK_PageTemplates_LockedByID] FOREIGN KEY (LockedByID) REFERENCES dbo.[Users](UserID)
)

-- Pages --
CREATE TABLE dbo.Pages
(
	PageID INT IDENTITY(1,1) NOT NULL,
	Name NVARCHAR(250) NOT NULL,
	ParentPageID INT NOT NULL CONSTRAINT [DF_Pages_ParentPageID] DEFAULT (0),
	PageTemplateID INT NULL,						
	CultureCode NVARCHAR(10) NOT NULL,
	Title NVARCHAR(250) NULL,
	Description NVARCHAR(MAX) NULL,
	Keywords NVARCHAR(250) NULL,
	PublishAt DATETIME NULL,
	ExpiresAt DATETIME NULL,
	BufferOutput BIT NOT NULL CONSTRAINT [DF_Pages_BufferOutput] DEFAULT (0),
	CacheOutput BIT NOT NULL CONSTRAINT [DF_Pages_CacheOutput] DEFAULT (0),
	CacheDuration INT NOT NULL CONSTRAINT [DF_Pages_CacheDuration] DEFAULT (0),
	SlidingExpiration BIT NOT NULL CONSTRAINT [DF_Pages_SlidingExpiration] DEFAULT (0),
	ErrorPage NVARCHAR(250) NULL,
	EventValidationEnabled BIT NOT NULL CONSTRAINT [DF_Pages_EventValidationEnabled] DEFAULT (0),
	IncludeScriptManager BIT NOT NULL CONSTRAINT [DF_Pages_IncludeScriptManager] DEFAULT (0),
	MaintainScrollPosition BIT NOT NULL CONSTRAINT [DF_Pages_MaintainScrollPosition] DEFAULT (0),
	MasterPage NVARCHAR(250) NULL,
	RequiresHttps BIT NOT NULL CONSTRAINT [DF_Pages_RequiresHttps] DEFAULT (0),
	ResponseEncoding NVARCHAR(250) NULL,
	SessionStateEnabled BIT NOT NULL CONSTRAINT [DF_Pages_SessionStateEnabled] DEFAULT (0),
	IsNavigable BIT NOT NULL CONSTRAINT [DF_Pages_IsNavigable] DEFAULT (1),
	ShowInNavigation BIT NOT NULL CONSTRAINT [DF_Pages_ShowInNavigation] DEFAULT (1),
	ThemingEnabled BIT NOT NULL CONSTRAINT [DF_Pages_ThemingEnabled] DEFAULT (1),
	Theme NVARCHAR(250) NULL,
	Trace BIT NOT NULL CONSTRAINT [DF_Pages_Trace] DEFAULT (0),
	TraceMode INT NOT NULL CONSTRAINT [DF_Pages_TraceMode] DEFAULT (0),
	ValidateRequest BIT NOT NULL CONSTRAINT [DF_Pages_ValidateRequest] DEFAULT (1),
	ViewStateEnabled BIT NOT NULL CONSTRAINT [DF_Pages_ViewStateEnabled] DEFAULT (1),
	VersionNumber INT NOT NULL,
	PublishStatusID INT NOT NULL,
	WorkflowEnabled BIT NOT NULL CONSTRAINT [DF_Pages_WorkflowEnabled] DEFAULT (1),
	WorkflowStepID INT NULL,
	Ordinal INT NOT NULL CONSTRAINT [DF_Pages_Ordinal] DEFAULT (0),
	IsVisible BIT NOT NULL CONSTRAINT [DF_Pages_IsVisible] DEFAULT (1),
		
	CONSTRAINT [PK_Pages] PRIMARY KEY (PageID),
	CONSTRAINT [FK_Pages_PageTemplateID] FOREIGN KEY (PageTemplateID) REFERENCES dbo.PageTemplates(PageTemplateID),
	CONSTRAINT [FK_Pages_PublishStatusID] FOREIGN KEY (PublishStatusID) REFERENCES dbo.PublishStatuses(PublishStatusID),
	CONSTRAINT [FK_Pages_WorkflowStepID] FOREIGN KEY (WorkflowStepID) REFERENCES dbo.WorkflowSteps(WorkflowStepID)
)

-- Page Attributes --
CREATE TABLE dbo.PageAttributes
(
	PageID INT NOT NULL,
	KeyName NVARCHAR(250) NOT NULL,
	Value NVARCHAR(250) NOT NULL,
		
	CONSTRAINT [PK_PageAttributes] PRIMARY KEY CLUSTERED (PageID, KeyName),
	CONSTRAINT [FK_PageAttributes_PageID] FOREIGN KEY (PageID) REFERENCES dbo.Pages(PageID)
)

-- VersionHistory --
CREATE TABLE dbo.VersionHistory
(
	VersionHistoryID INT IDENTITY(1,1) NOT NULL,
	PageID INT NOT NULL,
	ContentText NVARCHAR(MAX) NOT NULL,
	Comment NVARCHAR(MAX) NULL,
	VersionNumber INT NOT NULL,
	IsPublishedVersion BIT NOT NULL CONSTRAINT [DF_VersionHistory_IsPublishedVersion] DEFAULT (0),
	IsLocked BIT NOT NULL CONSTRAINT [DF_VersionHistory_IsLocked] DEFAULT (0),
	ModifiedByID INT NOT NULL,
	ModifiedAt DATETIME NOT NULL,
		
	CONSTRAINT [PK_VersionHistory] PRIMARY KEY (VersionHistoryID),
	CONSTRAINT [FK_VersionHistory_PageID] FOREIGN KEY (PageID) REFERENCES dbo.Pages(PageID),
	CONSTRAINT [FK_VersionHistory_ModifiedByID] FOREIGN KEY (ModifiedByID) REFERENCES dbo.[Users](UserID)
)

-- Workflow History --
CREATE TABLE dbo.WorkflowHistory
(	
	WorkflowHistoryID INT IDENTITY(1,1) NOT NULL,
	VersionHistoryID INT NOT NULL,
	WorkflowStepID INT NOT NULL,
	Comment NVARCHAR(MAX) NULL,
	WasRejected BIT CONSTRAINT [DF_WorkflowHistory_WasRejected] DEFAULT (0),
	ApprovedByID INT NULL,
	ApprovedAt DATETIME NULL,
						
	CONSTRAINT [PK_WorkflowHistory] PRIMARY KEY (WorkflowHistoryID),
	CONSTRAINT [FK_WorkflowHistory_VersionHistoryID] FOREIGN KEY (VersionHistoryID) REFERENCES dbo.VersionHistory(VersionHistoryID),
	CONSTRAINT [FK_WorkflowHistory_WorkflowStepID] FOREIGN KEY (WorkflowStepID) REFERENCES dbo.WorkflowSteps(WorkflowStepID),
	CONSTRAINT [FK_WorkflowHistory_ApprovedByID] FOREIGN KEY (ApprovedByID) REFERENCES dbo.[Users](UserID)
)

-------------------------------------------------------
-- Localization
-------------------------------------------------------

-- Resources --
CREATE TABLE dbo.Resources
(
	LocationPath NVARCHAR(250) NOT NULL,
	CultureCode NVARCHAR(10) NOT NULL,
	KeyName NVARCHAR(250) NOT NULL,
	Value NVARCHAR(250) NOT NULL,		
		
	CONSTRAINT [PK_Resources] PRIMARY KEY CLUSTERED (LocationPath, CultureCode, KeyName)
)

-------------------------------------------------------
-- Awards 
-------------------------------------------------------

-- Ranks --
CREATE TABLE dbo.[Ranks]
(	
	RankID INT NOT NULL,
	Name NVARCHAR(250) NOT NULL,
	MinPoints INT NOT NULL,
	InsigniaImageUrl NVARCHAR(250) NULL,
	Ordinal INT NOT NULL CONSTRAINT [DF_Ranks_Ordinal] DEFAULT (0),
						
	CONSTRAINT [PK_Ranks] PRIMARY KEY (RankID)
)

-- Medal --
CREATE TABLE dbo.Medals
(	
	MedalID INT NOT NULL,
	Name NVARCHAR(250) NOT NULL,
	Description NVARCHAR(MAX) NOT NULL,
	MedalImageURL NVARCHAR(250) NOT NULL,
	RibbonImageUrl NVARCHAR(250) NULL,
	Ordinal INT NOT NULL CONSTRAINT [DF_Medals_Ordinal] DEFAULT (0),
	    						
	CONSTRAINT [PK_Medals] PRIMARY KEY (MedalID)
)

-- User Medals --
CREATE TABLE dbo.UserMedals
(	
	UserID INT NOT NULL,
	MedalID INT NOT NULL,
	Citation NVARCHAR(MAX) NOT NULL,
	IsVisible BIT NOT NULL CONSTRAINT [DF_UserMedals_IsVisible] DEFAULT (1),
	OnlyRibbon BIT NOT NULL CONSTRAINT [DF_UserMedals_OnlyRibbon] DEFAULT (0),
	Ordinal BIT NOT NULL CONSTRAINT [DF_UserMedals_Ordinal] DEFAULT (0),
	AwardedAt DATETIME NOT NULL,  
						
	CONSTRAINT [PK_UserMedals] PRIMARY KEY CLUSTERED (UserID, MedalID),
	CONSTRAINT [FK_UserMedals_UserID] FOREIGN KEY (UserID) REFERENCES dbo.[Users](UserID),
	CONSTRAINT [FK_UserMedals_MedalID] FOREIGN KEY (MedalID) REFERENCES dbo.Medals(MedalID)
)

-------------------------------------------------------
-- Friendships 
-------------------------------------------------------

--  Invitations --
CREATE TABLE dbo.Invitations
(	
	InvitationID INT NOT NULL,
	SentByID INT NOT NULL,
	ToEmail NVARCHAR(250) NOT NULL,
	InvitationKey UNIQUEIDENTIFIER NOT NULL,
	CreatedAt DATETIME NOT NULL,
	ValidUntil DATETIME NULL,
	Message NVARCHAR(MAX) NULL,
	BecameID INT NULL,
						
	CONSTRAINT [PK_Invitations] PRIMARY KEY (InvitationID),
	CONSTRAINT [FK_Invitations_SentByID] FOREIGN KEY (SentByID) REFERENCES dbo.[Users](UserID),
	CONSTRAINT [FK_Invitations_BecameID] FOREIGN KEY (BecameID) REFERENCES dbo.[Users](UserID)
)

-- Friend  Requests --
CREATE TABLE dbo.Friendships
(
	FriendshipID INT IDENTITY(1,1) NOT NULL,
	FromID INT NOT NULL,
	ToID INT NOT NULL,
	IsAccepted BIT NOT NULL CONSTRAINT [DF_Friendships_IsAccepted] DEFAULT (0),
	RequestMessage NVARCHAR(MAX) NULL,
	CreatedAt DATETIME NOT NULL,
	ModifiedAt DATETIME NOT NULL,
								
	CONSTRAINT [PK_Friendships] PRIMARY KEY (FriendshipID),
	CONSTRAINT [FK_Friendships_FromID] FOREIGN KEY (FromID) REFERENCES dbo.[Users](UserID),
	CONSTRAINT [FK_Friendships_ToID] FOREIGN KEY (ToID) REFERENCES dbo.[Users](UserID)
)

-- Friend Lists --
CREATE TABLE dbo.FriendLists
(
	FriendListID INT IDENTITY(1,1) NOT NULL,
	Name NVARCHAR(250) NOT NULL,
	OwnerID INT NOT NULL,
						
	CONSTRAINT [PK_FriendLists] PRIMARY KEY (FriendListID),
	CONSTRAINT [FK_FriendLists_OwnerID] FOREIGN KEY (OwnerID) REFERENCES dbo.[Users](UserID),
)

CREATE TABLE dbo.FriendListMembers
(
	FriendListID INT NOT NULL,
	UserID INT NOT NULL,
						
	CONSTRAINT [PK_FriendListMembers] PRIMARY KEY CLUSTERED (FriendListID, UserID),
	CONSTRAINT [FK_FriendListMembers_FriendListID] FOREIGN KEY (FriendListID) REFERENCES dbo.FriendLists(FriendListID),
	CONSTRAINT [FK_FriendListMembers_UserID] FOREIGN KEY (UserID) REFERENCES dbo.[Users](UserID),
)

-- Followers --
CREATE TABLE dbo.Followers
(
	UserID INT NOT NULL,
	FollowerID INT NOT NULL,
	CreatedAt DATETIME NOT NULL,
						
	CONSTRAINT [PK_Followers] PRIMARY KEY CLUSTERED (UserID, FollowerID),
	CONSTRAINT [FK_Followers_UserID] FOREIGN KEY (UserID) REFERENCES dbo.[Users](UserID),
	CONSTRAINT [FK_Followers_FollowerID] FOREIGN KEY (FollowerID) REFERENCES dbo.[Users](UserID)
)


-- Ignored Users --
CREATE TABLE dbo.IgnoreUsers
(
	UserID INT NOT NULL,
	IgnoreID INT NOT NULL,
						
	CONSTRAINT [PK_IgnoreUsers] PRIMARY KEY CLUSTERED (UserID, IgnoreID),
	CONSTRAINT [FK_IgnoreUsers_UserID] FOREIGN KEY (UserID) REFERENCES dbo.[Users](UserID),
	CONSTRAINT [FK_IgnoreUsers_IgnoreID] FOREIGN KEY (IgnoreID) REFERENCES dbo.[Users](UserID)
)

-------------------------------------------------------
-- Messaging 
-------------------------------------------------------

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

-- Messages --
CREATE TABLE dbo.[Messages]
(
	MessageID INT IDENTITY(1,1) NOT NULL,
	ParentMessageId INT NOT NULL CONSTRAINT [DF_Messages_ParentMessageId] DEFAULT (0),
	FromID INT NOT NULL,
	Subject NVARCHAR(250) NOT NULL,
	Importance INT NOT NULL,
	PlainTextBody NVARCHAR(MAX) NOT NULL,
	HtmlBody NVARCHAR(MAX) NOT NULL,
	IsFlagged BIT NOT NULL CONSTRAINT [DF_Messages_IsFlagged] DEFAULT (0),	
	CreatedAt DATETIME NOT NULL,
		
	CONSTRAINT [PK_Messages] PRIMARY KEY (MessageID),
	CONSTRAINT [FK_Messages_FromID] FOREIGN KEY (FromID) REFERENCES dbo.[Users](UserID)
)

-- Recipient Types --
CREATE TABLE dbo.RecipientTypes
(	
	RecipientTypeID INT NOT NULL,
	Name NVARCHAR(250) NOT NULL,
						
	CONSTRAINT [PK_RecipientTypes] PRIMARY KEY (RecipientTypeID)
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

-------------------------------------------------------
-- Community Blogs 
-------------------------------------------------------

-- Blogs --
CREATE TABLE dbo.Blogs
(	
	BlogID INT IDENTITY(1,1) NOT NULL,
	Title NVARCHAR(250) NOT NULL,
	Description NVARCHAR(MAX) NULL,	
	CultureCode NVARCHAR(10) NOT NULL,
	PostCount BIT NOT NULL CONSTRAINT [DF_Blogs_PostCount] DEFAULT (0),
	ShowFullPost BIT NOT NULL,
	WordsInExcerpt INT NOT NULL,
	PostPageSize INT NOT NULL,
	PostDateFormat NVARCHAR(10) NOT NULL,
	PostTimeFormat NVARCHAR(10) NOT NULL,
	AutoPublishNewPosts BIT NOT NULL,
	PostSortOrder NVARCHAR(250) NOT NULL,
	CommentsEnabled BIT NOT NULL CONSTRAINT [DF_Blogs_CommentsEnabled] DEFAULT (0),
	AllowAnonymous BIT NOT NULL,
	ModerateComments BIT NOT NULL,		
	EmailAuthor BIT NOT NULL,
	RequiresNameAndEmail BIT NOT NULL,
	CloseCommentsDaysOld INT NOT NULL,
	CommentsPageSize INT NOT NULL, 
	CommentsSortOrder NVARCHAR(250) NOT NULL,
	CaptchaEnabled BIT NOT NULL CONSTRAINT [DF_Blogs_CaptchaEnabled] DEFAULT (0),
	TrackbacksEnabled BIT NOT NULL CONSTRAINT [DF_Blogs_TrackbacksEnabled] DEFAULT (0),
	RatingsEnabled BIT NOT NULL CONSTRAINT [DF_Blogs_RatingsEnabled] DEFAULT (0),		
	SharingEnabled BIT NOT NULL CONSTRAINT [DF_Blogs_SharingEnabled] DEFAULT (0),		
	Privacy INT NOT NULL,
	UserID INT NOT NULL,
	CreatedAt DATETIME NOT NULL,
	LastPostAt DATETIME NOT NULL,
						
	CONSTRAINT [PK_Blogs] PRIMARY KEY (BlogID),
	CONSTRAINT [FK_Blogs_UserID] FOREIGN KEY (UserID) REFERENCES dbo.[Users](UserID)
)

CREATE TABLE dbo.BlogPosts
(	
	BlogPostID INT IDENTITY(1,1) NOT NULL,
	BlogID INT NOT NULL,
	Title NVARCHAR(250) NOT NULL,
	Excerpt NVARCHAR(250) NOT NULL,
	Body NVARCHAR(MAX) NOT NULL,
	PermaLink NVARCHAR(250) NOT NULL,
	CommentCount INT NOT NULL CONSTRAINT [DF_BlogPosts_CommentCount] DEFAULT (0),
	TrackbackCount INT NOT NULL CONSTRAINT [DF_BlogPosts_TrackbackCount] DEFAULT (0),
	ViewCount INT NOT NULL CONSTRAINT [DF_BlogPosts_ViewCount] DEFAULT (0),
	VoteCount INT NOT NULL CONSTRAINT [DF_BlogPosts_VoteCount] DEFAULT (0),
	TotalRating INT NOT NULL CONSTRAINT [DF_BlogPosts_TotalRating] DEFAULT (0),		
	CreatedAt DATETIME NOT NULL,
						
	CONSTRAINT [PK_BlogPosts] PRIMARY KEY (BlogPostID),
	CONSTRAINT [FK_BlogPosts_BlogID] FOREIGN KEY (BlogID) REFERENCES dbo.Blogs(BlogID)
)

-------------------------------------------------------
-- Forums 
-------------------------------------------------------

-- Forum --
CREATE TABLE dbo.Forums
(
	ForumID INT IDENTITY(1,1) NOT NULL,
	Name NVARCHAR(250) NOT NULL,
	Description NVARCHAR(MAX) NULL,
	ParentForumID INT NOT NULL CONSTRAINT [DF_Forums_ParentForumID] DEFAULT (0),
	ThreadCount INT NOT NULL CONSTRAINT [DF_Forums_ThreadCount] DEFAULT (0),
	PostCount INT NOT NULL CONSTRAINT [DF_Forums_PostCount] DEFAULT (0),
	ModerateThreads BIT NOT NULL CONSTRAINT [DF_Forums_ModerateThreads] DEFAULT (0),
	ModeratePosts BIT NOT NULL CONSTRAINT [DF_Forums_ModeratePosts] DEFAULT (0),
	PendingPostCount INT NOT NULL CONSTRAINT [DF_Forums_PendingPostCount] DEFAULT (0),
	ForumPassword NVARCHAR(250) NULL,
	ApplyPasswordToChildren BIT NOT NULL CONSTRAINT [DF_Forums_ApplyPasswordToChildren] DEFAULT (0),
	IsSearchable BIT NOT NULL CONSTRAINT [DF_Forums_IsSearchable] DEFAULT (1),
	ThreadTrackingEnabled BIT NOT NULL CONSTRAINT [DF_Forums_ThreadTrackingEnabled] DEFAULT (0),
	ThreadRatingsEnabled BIT NOT NULL CONSTRAINT [DF_Forums_ThreadRatingsEnabled] DEFAULT (0),
	PostStatisticsEnabled BIT NOT NULL CONSTRAINT [DF_Forums_PostStatisticsEnabled] DEFAULT (0),
	PostPointsEnabled BIT NOT NULL CONSTRAINT [DF_Forums_PostPointsEnabled] DEFAULT (0),
	DenyAnonymous BIT NOT NULL CONSTRAINT [DF_Forums_DenyAnonymous] DEFAULT (0),
	IsVisible BIT NOT NULL CONSTRAINT [DF_Forums_IsVisible] DEFAULT (1),
	CreatedByID INT NOT NULL,
	ModifiedAt DATETIME NOT NULL,
		
	CONSTRAINT [PK_Forums] PRIMARY KEY (ForumID),
	CONSTRAINT [FK_Forums_CreatedByID] FOREIGN KEY (CreatedByID) REFERENCES dbo.[Users](UserID)
)

-- Posts --
CREATE TABLE dbo.Posts
(
	PostID INT IDENTITY(1,1) NOT NULL,
	ForumID INT NOT NULL,
	ParentPostID INT NOT NULL,
	Subject NVARCHAR(250) NOT NULL,
	Body NVARCHAR(MAX) NOT NULL,
	ReplyCount INT NOT NULL CONSTRAINT [DF_Posts_ReplyCount] DEFAULT (0),
	ViewCount INT NOT NULL CONSTRAINT [DF_Posts_ViewCount] DEFAULT (0),
	VoteCount BIT NOT NULL CONSTRAINT [DF_Posts_VoteCount] DEFAULT (0),
	TotalRating INT NOT NULL CONSTRAINT [DF_Posts_TotalRating] DEFAULT (0),
	IsResolved BIT NOT NULL CONSTRAINT [DF_Posts_IsResolved] DEFAULT (0),
	IsAnswer BIT NOT NULL CONSTRAINT [DF_Posts_IsAnswer] DEFAULT (0),
	IsSticky BIT NOT NULL CONSTRAINT [DF_Posts_IsSticky] DEFAULT (0),
	IsLocked BIT NOT NULL CONSTRAINT [DF_Posts_IsLocked] DEFAULT (0),
	IsApproved BIT NOT NULL CONSTRAINT [DF_Posts_IsApproved] DEFAULT (0),
	CreatedAt DATETIME NOT NULL,
	CreatedByID INT NOT NULL,
	ModifiedByID INT NOT NULL,
	ModifiedAt DATETIME NOT NULL,
	LastReplyAt DATETIME NULL,
	LastReplyByID INT NULL,
		
	CONSTRAINT [PK_Posts] PRIMARY KEY (PostID),
	CONSTRAINT [FK_Posts_ForumID] FOREIGN KEY (ForumID) REFERENCES dbo.Forums(ForumID),
	CONSTRAINT [FK_Posts_CreatedByID] FOREIGN KEY (CreatedByID) REFERENCES dbo.[Users](UserID),
	CONSTRAINT [FK_Posts_ModifiedByID] FOREIGN KEY (ModifiedByID) REFERENCES dbo.[Users](UserID),
	CONSTRAINT [FK_Posts_LastReplyByID] FOREIGN KEY (LastReplyByID) REFERENCES dbo.[Users](UserID)
)

-- Tracked Forums --
CREATE TABLE dbo.TrackedForums
(
	ForumID INT NOT NULL,
	UserID INT NOT NULL,
		
	CONSTRAINT [PK_TrackedForums] PRIMARY KEY CLUSTERED (ForumID, UserID),
	CONSTRAINT [FK_TrackedForums_ForumID] FOREIGN KEY (ForumID) REFERENCES dbo.Forums(ForumID),
	CONSTRAINT [FK_TrackedForums_UserID] FOREIGN KEY (UserID) REFERENCES dbo.[Users](UserID)
)

-- Tracked Posts --
CREATE TABLE dbo.TrackedPosts
(
	PostID INT NOT NULL,
	UserID INT NOT NULL,
		
	CONSTRAINT [PK_TrackedPosts] PRIMARY KEY CLUSTERED (PostID, UserID),
	CONSTRAINT [FK_TrackedPosts_PostID] FOREIGN KEY (PostID) REFERENCES dbo.Posts(PostID),
	CONSTRAINT [FK_TrackedPosts_UserID] FOREIGN KEY (UserID) REFERENCES dbo.[Users](UserID)
)

-- Favorite Forums --
CREATE TABLE dbo.FavoriteForums
(
	ForumID INT NOT NULL,		
	UserID INT NOT NULL,
		
	CONSTRAINT [PK_FavoriteForums] PRIMARY KEY CLUSTERED (ForumID, UserID),
	CONSTRAINT [FK_FavoriteForums_ForumID] FOREIGN KEY (ForumID) REFERENCES dbo.Forums(ForumID),
	CONSTRAINT [FK_FavoriteForums_UserID] FOREIGN KEY (UserID) REFERENCES dbo.[Users](UserID)
)

-- Favorite Posts --
CREATE TABLE dbo.FavoritePosts
(
	PostID INT NOT NULL,		
	UserID INT NOT NULL,
		
	CONSTRAINT [PK_FavoritePosts] PRIMARY KEY CLUSTERED (PostID, UserID),
	CONSTRAINT [FK_FavoritePosts_PostID] FOREIGN KEY (PostID) REFERENCES dbo.Posts(PostID),
	CONSTRAINT [FK_FavoritePosts_UserID] FOREIGN KEY (UserID) REFERENCES dbo.[Users](UserID)
)

-- Forum Moderators --
CREATE TABLE dbo.ForumModerators
(
	ForumID INT NOT NULL,
	UserID INT NOT NULL,
						
	CONSTRAINT [PK_ForumModerators] PRIMARY KEY CLUSTERED (ForumID, UserID),
	CONSTRAINT [FK_ForumModerators_ForumID] FOREIGN KEY (ForumID) REFERENCES dbo.Forums(ForumID),
	CONSTRAINT [FK_ForumModerators_UserID] FOREIGN KEY (UserID) REFERENCES dbo.[Users](UserID)
)

-------------------------------------------------------
-- Media Gallery Module
-------------------------------------------------------

-- Album --
CREATE TABLE dbo.Albums
(
	AlbumID INT IDENTITY(1,1) NOT NULL,
	CoverPhotoID INT NOT NULL CONSTRAINT [DF_Albums_CoverPhotoID] DEFAULT (0),
	Name NVARCHAR(250) NOT NULL,
	Description NVARCHAR(MAX) NULL,
	Location NVARCHAR(250) NULL,
	CultureCode NVARCHAR(10) NOT NULL,
	PhotoCount INT NOT NULL CONSTRAINT [DF_Albums_PhotoCount] DEFAULT (0),
	SlideshowTimer INT NOT NULL CONSTRAINT [DF_Albums_SlideshowTimer] DEFAULT (0),
	ResizeOnUpload BIT NOT NULL CONSTRAINT [DF_Albums_ResizeOnUpload] DEFAULT (0),
	MaxImageWidth INT NULL,	
	MaxImageHeight INT NULL,					
	CommentsEnabled BIT NOT NULL CONSTRAINT [DF_Albums_CommentsEnabled] DEFAULT (0),
	AllowAnonymous BIT NOT NULL,
	ModerateComments BIT NOT NULL,		
	EmailAuthor BIT NOT NULL,
	RequiresNameAndEmail BIT NOT NULL,
	CloseCommentsDaysOld INT NOT NULL,
	CommentsPageSize INT NOT NULL, 
	CommentsSortOrder NVARCHAR(250) NOT NULL,
	UseCaptcha BIT NOT NULL,
	RatingsEnabled BIT NOT NULL CONSTRAINT [DF_Albums_RatingsEnabled] DEFAULT (0),		
	SharingEnabled BIT NOT NULL CONSTRAINT [DF_Albums_SharingEnabled] DEFAULT (0),						
	Privacy INT NOT NULL,
	UserID INT NOT NULL,
	CreatedAt DATETIME NOT NULL,
	ModifiedAt DATETIME NOT NULL,
		
	CONSTRAINT [PK_Albums] PRIMARY KEY (AlbumID),
	CONSTRAINT [FK_Albums_UserID] FOREIGN KEY (UserID) REFERENCES dbo.[Users](UserID)
)

-- Photos --
CREATE TABLE dbo.Photos
(
	PhotoID INT IDENTITY(1,1) NOT NULL,
	AlbumID INT NULL,
	Name UNIQUEIDENTIFIER NOT NULL,
	PhysicalFileName NVARCHAR(250) NOT NULL,
	AlternateText NVARCHAR(250) NULL,
	Caption NVARCHAR(MAX) NULL,
	Description NVARCHAR(MAX) NULL,
	PermaLink NVARCHAR(250) NOT NULL,
	ImageWidth INT NULL,
	ImageHeight INT NULL,
	DownloadsEnabled INT NOT NULL CONSTRAINT [DF_Photos_DownloadsEnabled] DEFAULT (1),
	CommentCount INT NOT NULL CONSTRAINT [DF_Photos_CommentCount] DEFAULT (0),
	ViewCount INT NOT NULL CONSTRAINT [DF_Photos_ViewCount] DEFAULT (0),
	VoteCount INT NOT NULL CONSTRAINT [DF_Photos_VoteCount] DEFAULT (0),
	TotalRating INT NOT NULL CONSTRAINT [DF_Photos_TotalRating] DEFAULT (0),	
	ExcludeFromAlbum BIT NOT NULL CONSTRAINT [DF_Photos_ExcludeFromAlbum] DEFAULT (0),
	UserID INT NOT NULL,
	UploadedAt DATETIME NOT NULL,
	ModifiedAt DATETIME NOT NULL,
		
	CONSTRAINT [PK_Photos] PRIMARY KEY (PhotoID),
	CONSTRAINT [FK_Photos_AlbumID] FOREIGN KEY (AlbumID) REFERENCES dbo.Albums(AlbumID),
	CONSTRAINT [FK_Photos_UserID] FOREIGN KEY (UserID) REFERENCES dbo.[Users](UserID)
)	

-------------------------------------------------------
-- Calendar 
-------------------------------------------------------

-- Events --
CREATE TABLE dbo.Events
(
	EventID INT IDENTITY(1,1) NOT NULL,
	Name NVARCHAR(250) NOT NULL,
	TagLine NVARCHAR(1000) NULL,
	Description NVARCHAR(MAX) NULL,
	StartTime DATETIME NOT NULL,
	EndTime DATETIME NOT NULL,	
	RecurringRule NVARCHAR(1024) NULL,
	CreatedByID INT NOT NULL,
	ModifiedAt DATETIME NOT NULL,
	ThumbnailImageUrl NVARCHAR(250) NULL,
	Venue NVARCHAR(250) NULL,
	Location NVARCHAR(250) NULL,
	ContactName NVARCHAR(250) NULL,
	ContactTelephone NVARCHAR(50) NULL,
	ContactCell NVARCHAR(50) NULL,
	ContactEmail NVARCHAR(250) NULL,
	ContactWebsite NVARCHAR(250) NULL,
	Price money NOT NULL CONSTRAINT [DF_Events_Price] DEFAULT (0),	
	CommentsEnabled BIT NOT NULL CONSTRAINT [DF_Events_CommentsEnabled] DEFAULT (0),
	AllowAnonymous BIT NOT NULL,
	ModerateComments BIT NOT NULL,		
	EmailAuthor BIT NOT NULL,
	RequiresNameAndEmail BIT NOT NULL,
	CloseCommentsDaysOld INT NOT NULL,
	CommentsPageSize INT NOT NULL, 
	CommentsSortOrder NVARCHAR(250) NOT NULL,
	UseCaptcha BIT NOT NULL,
	RatingsEnabled BIT NOT NULL CONSTRAINT [DF_Events_RatingsEnabled] DEFAULT (0),		
	SharingEnabled BIT NOT NULL CONSTRAINT [DF_Events_SharingEnabled] DEFAULT (0),				
	CommentCount INT NOT NULL CONSTRAINT [DF_Events_CommentCount] DEFAULT (0),
	ViewCount INT NOT NULL CONSTRAINT [DF_Events_ViewCount] DEFAULT (0),
	VoteCount INT NOT NULL CONSTRAINT [DF_Events_VoteCount] DEFAULT (0),
	TotalRating INT NOT NULL CONSTRAINT [DF_Events_TotalRating] DEFAULT (0),					
	AllowRegistration BIT NOT NULL CONSTRAINT [DF_Events_AllowRegistration] DEFAULT (1),
	RegistrationClosesAt  DATETIME NULL,
	EmailJoinLeave BIT NOT NULL CONSTRAINT [DF_Events_EmailJoinLeave] DEFAULT (1),
	GuestCount INT NOT NULL CONSTRAINT [DF_Events_GuestCount] DEFAULT (0),
	MaxCapacity INT NOT NULL CONSTRAINT [DF_Events_MaxCapacity] DEFAULT (0),
	HideNotAttending BIT NOT NULL CONSTRAINT [DF_Events_HideNotAttending] DEFAULT (0),			
	CanBringGuests BIT NOT NULL CONSTRAINT [DF_Events_CanBringGuests] DEFAULT (0),
	MaxNumberOfGuests INT NOT NULL CONSTRAINT [DF_Events_MaxNumberOfGuests] DEFAULT (0),				
	IsFeatured BIT NOT NULL CONSTRAINT [DF_Events_IsFeatured] DEFAULT (0),
	IsCancelled BIT NOT NULL CONSTRAINT [DF_Events_IsCancelled] DEFAULT (0),						
	CancellationReason NVARCHAR(MAX) NULL,
	Privacy INT NOT NULL,
		
	CONSTRAINT [PK_Events] PRIMARY KEY (EventID),
	CONSTRAINT [FK_Events_CreatedByID] FOREIGN KEY (CreatedByID) REFERENCES dbo.[Users](UserID)
)

-- RSVP Statuses --
CREATE TABLE dbo.RsvpStatuses
(
	RsvpStatusID INT NOT NULL,
	Name NVARCHAR(50) NOT NULL,
		
	CONSTRAINT [PK_RsvpStatuses] PRIMARY KEY (RsvpStatusID)
)

-- Event Members --
CREATE TABLE dbo.EventMembers
(
	EventID INT NOT NULL,
	UserID INT NOT NULL,
	RsvpStatusID INT NOT NULL,
	RepliedAt DATETIME NOT NULL,
		
	CONSTRAINT [PK_EventMembers] PRIMARY KEY CLUSTERED (EventID, UserID),
	CONSTRAINT [FK_EventMembers_EventID] FOREIGN KEY (EventID) REFERENCES dbo.[Events](EventID),
	CONSTRAINT [FK_EventMembers_UserID] FOREIGN KEY (UserID) REFERENCES dbo.[Users](UserID),
	CONSTRAINT [FK_EventMembers_RsvpStatusID] FOREIGN KEY (RsvpStatusID) REFERENCES dbo.RsvpStatuses(RsvpStatusID)
)

-------------------------------------------------------
-- Groups 
-------------------------------------------------------

-- Membership Types --
CREATE TABLE dbo.MembershipTypes
(
	MembershipTypeID INT IDENTITY(1,1) NOT NULL,
	Name NVARCHAR(250) NOT NULL,

	CONSTRAINT [PK_MembershipTypes] PRIMARY KEY (MembershipTypeID)
)

-- Groups --
CREATE TABLE dbo.[Groups]
(
	GroupID INT IDENTITY(1,1) NOT NULL,
	Name NVARCHAR(250) NOT NULL,
	Description NVARCHAR(MAX) NOT NULL,
	RecentNews NVARCHAR(MAX) NULL,
	HeaderImageUrl NVARCHAR(250) NULL,
	ApproveMembers BIT NOT NULL CONSTRAINT [DF_Groups_ApproveMembers] DEFAULT (1),
	Email NVARCHAR(250) NULL,
	MemberCount BIT NOT NULL CONSTRAINT [DF_Groups_MemberCount] DEFAULT (0),
	SendJoinLeaveNotification BIT NOT NULL CONSTRAINT [DF_Groups_SendJoinLeaveNotification] DEFAULT (1),
	SendWaitingForApprovalNotification BIT NOT NULL CONSTRAINT [DF_Groups_SendWaitingForApprovalNotification] DEFAULT (1),
	EventsEnabled BIT NOT NULL CONSTRAINT [DF_Groups_EventsEnabled] DEFAULT (1),
	ShowRelatedEvents BIT NOT NULL CONSTRAINT [DF_Groups_ShowRelatedEvents] DEFAULT (1),
	GalleryEnabled BIT NOT NULL CONSTRAINT [DF_Groups_GalleryEnabled] DEFAULT (1),
	ForumEnabled BIT NOT NULL CONSTRAINT [DF_Groups_ForumEnabled] DEFAULT (0),	
	CommentsEnabled BIT NOT NULL CONSTRAINT [DF_Groups_CommentsEnabled] DEFAULT (0),
	AllowAnonymous BIT NOT NULL,
	ModerateComments BIT NOT NULL,		
	EmailAuthor BIT NOT NULL,
	RequiresNameAndEmail BIT NOT NULL,
	CloseCommentsDaysOld INT NOT NULL,
	CommentsPageSize INT NOT NULL, 
	CommentsSortOrder NVARCHAR(250) NOT NULL,
	UseCaptcha BIT NOT NULL,		
	Privacy INT NOT NULL,
	OwnerID INT NOT NULL,
	ModifiedAt DATETIME NOT NULL,
		
	CONSTRAINT [PK_Groups] PRIMARY KEY (GroupID),
	CONSTRAINT [FK_Groups_OwnerID] FOREIGN KEY (OwnerID) REFERENCES dbo.[Users](UserID)
)

-- Group Members --
CREATE TABLE dbo.GroupMembers
(
	GroupMemberID INT IDENTITY(1,1) NOT NULL,
	GroupID INT NOT NULL,
	UserID INT NOT NULL,
	InvitedByID INT NULL,
	MembershipTypeID INT NOT NULL,
	JoinedAt DATETIME NOT NULL,
	ApprovedByID INT NULL,
	ApprovedAt DATETIME NULL,
	RejectedAt DATETIME NULL,		
		
	CONSTRAINT [PK_GroupMembers] PRIMARY KEY (GroupMemberID),
	CONSTRAINT [FK_GroupMembers_GroupID] FOREIGN KEY (GroupID) REFERENCES dbo.[Groups](GroupID),
	CONSTRAINT [FK_GroupMembers_UserID] FOREIGN KEY (UserID) REFERENCES dbo.[Users](UserID),
	CONSTRAINT [FK_GroupMembers_InvitedByID] FOREIGN KEY (InvitedByID) REFERENCES dbo.[Users](UserID),
	CONSTRAINT [FK_GroupMembers_MembershipTypeID] FOREIGN KEY (MembershipTypeID) REFERENCES dbo.MembershipTypes(MembershipTypeID),
	CONSTRAINT [FK_GroupMembers_ApprovedByID] FOREIGN KEY (ApprovedByID) REFERENCES dbo.[Users](UserID)
)

-- Group Forums --
CREATE TABLE dbo.GroupForums
(
	GroupID INT NOT NULL,
	ForumID INT NOT NULL,
		
	CONSTRAINT [PK_GroupForums] PRIMARY KEY CLUSTERED (GroupID, ForumID),
	CONSTRAINT [FK_GroupForums_GroupID] FOREIGN KEY (GroupID) REFERENCES dbo.[Groups](GroupID),
	CONSTRAINT [FK_GroupForums_ForumID] FOREIGN KEY (ForumID) REFERENCES dbo.Forums(ForumID)
)

-------------------------------------------------------
-- Status / Activity Messages
-------------------------------------------------------

-- Status Update Messages --
CREATE TABLE dbo.StatusUpdates
(	
	StatusUpdateID INT NOT NULL,
	OwnerID INT NOT NULL,
	Message NVARCHAR(250) NOT NULL,
	CreatedAt DATETIME NOT NULL,
						
	CONSTRAINT [PK_StatusUpdates] PRIMARY KEY (StatusUpdateID),
	CONSTRAINT [FK_StatusUpdates_OwnerID] FOREIGN KEY (OwnerID) REFERENCES dbo.[Users](UserID)
)

-- Activity Types --
CREATE TABLE dbo.ActivityTypes
(	
	ActivityTypeID INT NOT NULL,
	Name NVARCHAR(250) NOT NULL,
	Template NVARCHAR(MAX) NOT NULL,	
						
	CONSTRAINT [PK_ActivityTypes] PRIMARY KEY (ActivityTypeID)
)

-- Activity Message --
CREATE TABLE dbo.ActivityFeeds
(
	ActivityFeedID INT IDENTITY(1,1) NOT NULL,		
	OwnerID INT NOT NULL,		
	Message NVARCHAR(MAX) NOT NULL,
	ActivityTypeID INT NOT NULL,
	GroupID INT NULL,
	IsVisible BIT NOT NULL CONSTRAINT [DF_ActivityFeeds_IsVisible] DEFAULT (1),
	CommentCount INT NOT NULL CONSTRAINT [DF_ActivityFeeds_CommentCount] DEFAULT (0),
	CreatedAt DATETIME NOT NULL,
			
	CONSTRAINT [PK_ActivityFeeds] PRIMARY KEY (ActivityFeedID),
	CONSTRAINT [FK_ActivityFeeds_OwnerID] FOREIGN KEY (OwnerID) REFERENCES dbo.[Users](UserID),
	CONSTRAINT [FK_ActivityFeeds_ActivityTypeID] FOREIGN KEY (ActivityTypeID) REFERENCES dbo.ActivityTypes(ActivityTypeID),
	CONSTRAINT [FK_ActivityFeeds_GroupID] FOREIGN KEY (GroupID) REFERENCES dbo.[Groups](GroupID)
)

-------------------------------------------------------
-- Polls 
-------------------------------------------------------

-- Polls --
CREATE TABLE dbo.Polls
(
	PollID INT IDENTITY(1,1) NOT NULL,
	Question NVARCHAR(250) NOT NULL,
	MultipleChoice BIT NOT NULL,
	RandomizeAnswers BIT NOT NULL CONSTRAINT [DF_Polsl_RandomizeAnswers] DEFAULT (0),
	OtherAnswer BIT NOT NULL CONSTRAINT [DF_Polls_OtherAnswer] DEFAULT (0),
	DefaultFirstChoice BIT NOT NULL CONSTRAINT [DF_Polls_DefaultFirstChoice] DEFAULT (0),
	BlockRepeatVotersByCookie BIT NOT NULL CONSTRAINT [DF_Polls_BlockRepeatVotersByCookie] DEFAULT (1),
	BlockRepeatExpiration INT NOT NULL CONSTRAINT [DF_Polls_BlockRepeatExpiration] DEFAULT (0),
	ShowResults BIT NOT NULL CONSTRAINT [DF_Polls_ShowResults] DEFAULT (1),		
	IsCurrent BIT NOT NULL CONSTRAINT [DF_Polls_IsCurrent] DEFAULT (0),
	ResponseMessage NVARCHAR(250) NULL,
	ResponseCount BIT NOT NULL CONSTRAINT [DF_Polls_ResponseCount] DEFAULT (0),	
	ClosePoll BIT NOT NULL CONSTRAINT [DF_Polls_ClosePoll] DEFAULT (0),
	CloseAt DATETIME NULL,
	OwnerID INT NOT NULL,
	ModifiedAt DATETIME NOT NULL,
		
	CONSTRAINT [PK_Polls] PRIMARY KEY (PollID),
	CONSTRAINT [FK_Polls_OwnerID] FOREIGN KEY (OwnerID) REFERENCES dbo.[Users](UserID)
) 

-- Poll Options --
CREATE TABLE dbo.PollOptions
(
	PollOptionID INT IDENTITY(1,1) NOT NULL,
	PollID INT NOT NULL,
	Answer NVARCHAR(250) NOT NULL,
	VoteCount INT NOT NULL CONSTRAINT [DF_PollOptions_VoteCount] DEFAULT (0),
		
	CONSTRAINT [PK_PollOptions] PRIMARY KEY (PollOptionID),
	CONSTRAINT [FK_PollOptions_PollID] FOREIGN KEY (PollID) REFERENCES dbo.Polls(PollID)
)

-------------------------------------------------------
-- Newsletters
-------------------------------------------------------

-- Newsletter Templates --
CREATE TABLE dbo.NewsletterTemplates
	(
		NewsletterTemplateID INT IDENTITY(1,1) NOT NULL,
		Name NVARCHAR(250) NOT NULL,
		Subject NVARCHAR(250) NOT NULL,
		Body NVARCHAR(MAX) NOT NULL,
		CssStylesheet NVARCHAR(MAX) NULL,
		ModifiedAt DATETIME NOT NULL,

		CONSTRAINT [PK_NewsletterTemplates] PRIMARY KEY (NewsletterTemplateID)	
	)

-- Mailing Lists --
CREATE TABLE dbo.MailingLists
	(
		MailingListID INT IDENTITY(1,1) NOT NULL,
		Name NVARCHAR(250) NOT NULL,
		SendJoinLeaveNotification BIT NOT NULL CONSTRAINT [DF_MailingLists_SendJoinLeaveNotification] DEFAULT (1),
		ConfirmOptIn INT NOT NULL CONSTRAINT [DF_MailingLists_ConfirmOptIn] DEFAULT (1),
		SubscriberCount INT NOT NULL CONSTRAINT [DF_MailingLists_SubscriberCount] DEFAULT (0),
		UnsubscribeCount INT NOT NULL CONSTRAINT [DF_MailingLists_UnsubscribeCount] DEFAULT (0),
		NewsletterCount INT NOT NULL CONSTRAINT [DF_MailingLists_NewsletterCount] DEFAULT (0),
		UnsubscribeUrl NVARCHAR(250) NOT NULL,
		ModifiedAt DATETIME NOT NULL,

		CONSTRAINT [PK_MailingLists] PRIMARY KEY (MailingListID)
	)

-- Subscribers --
CREATE TABLE dbo.Subscribers
(
	SubscriberID INT IDENTITY(1,1) NOT NULL,
	FirstName NVARCHAR(250) NULL,
	LastName NVARCHAR(250) NULL,
	Email NVARCHAR(250) NOT NULL,
	IsRegisteredUser BIT NOT NULL,
	IsConfirmed BIT NOT NULL CONSTRAINT [DF_Subscribers_IsConfirmed] DEFAULT (0),
	IsSuppressed BIT NOT NULL CONSTRAINT [DF_Subscribers_IsSuppressed] DEFAULT (0),
	ModifiedAt DATETIME NOT NULL,

	CONSTRAINT [PK_Subscribers] PRIMARY KEY (SubscriberID)
)

-- Subscriber Mail Lists --
CREATE TABLE dbo.SubscriberMailingLists
(
	SubscriberID INT NOT NULL,
	MailingListID INT NOT NULL,
	SubscribedAt DATETIME NOT NULL,

	CONSTRAINT [PK_SubscriberMailingLists] PRIMARY KEY CLUSTERED (SubscriberID, MailingListID),
	CONSTRAINT [FK_SubscriberMailingLists_SubscriberID] FOREIGN KEY (SubscriberID) REFERENCES dbo.Subscribers(SubscriberID),
	CONSTRAINT [FK_SubscriberMailingLists_MailingListID] FOREIGN KEY (MailingListID) REFERENCES dbo.MailingLists(MailingListID)
)

-- Newsletters --
CREATE TABLE dbo.Newsletters
(
	NewsletterID INT IDENTITY(1,1) NOT NULL,
	Name NVARCHAR(250) NOT NULL,
	Subject NVARCHAR(250) NOT NULL,
	FromEmail NVARCHAR(250) NULL,
	FromName NVARCHAR(250) NULL,
	ReplyToEmail NVARCHAR(250) NULL,
	ReplyToName NVARCHAR(250) NULL,
	PlainTextBody NVARCHAR(MAX) NOT NULL,
	HtmlBody NVARCHAR(MAX) NOT NULL,
	PublishStatusID INT NOT NULL,
	IsBeingSent BIT NOT NULL CONSTRAINT [DF_Newsletters_IsBeingSent] DEFAULT (0),
	TestEmails NVARCHAR(MAX) NULL,
	DeliveryDate DATETIME NOT NULL,
	TimezoneOffset INT NOT NULL CONSTRAINT [DF_Newsletters_TimezoneOffset] DEFAULT (0),
	FailedMessage NVARCHAR(MAX) NULL,
	ConfirmationEmails NVARCHAR(MAX) NULL,
	ShowInArchive BIT NOT NULL CONSTRAINT [DF_Newsletters_ShowInArchive] DEFAULT (1),
	CreatedByID INT NOT NULL,
	CreatedAt DATETIME NOT NULL,
	ModifiedByID INT NOT NULL,
	ModifiedAt DATETIME NOT NULL,

	CONSTRAINT [PK_Newsletters] PRIMARY KEY (NewsletterID),
	CONSTRAINT [FK_Newsletters_PublishStatusID] FOREIGN KEY (PublishStatusID) REFERENCES dbo.PublishStatuses(PublishStatusID),
	CONSTRAINT [FK_Newsletters_CreatedByID] FOREIGN KEY (CreatedByID) REFERENCES dbo.[Users](UserID),
	CONSTRAINT [FK_Newsletters_ModifiedByID] FOREIGN KEY (ModifiedByID) REFERENCES dbo.[Users](UserID)	
)

-- Newsletter Mailing Lists --
CREATE TABLE dbo.NewsletterMailingLists
(
	NewsletterID INT NOT NULL,
	MailingListID INT NOT NULL,

	CONSTRAINT [PK_NewsletterList] PRIMARY KEY CLUSTERED (NewsletterID, MailingListID),
	CONSTRAINT [FK_NewsletterList_NewsletterID] FOREIGN KEY (NewsletterID) REFERENCES dbo.Newsletters(NewsletterID),
	CONSTRAINT [FK_NewsletterList_MailingListID] FOREIGN KEY (MailingListID) REFERENCES dbo.MailingLists(MailingListID)
)

-- Progress State  --
CREATE TABLE dbo.ProgressStates
(
	ProgressStateID INT IDENTITY(1,1) NOT NULL,
	NewsletterID INT NOT NULL,
	EmailsSentCount INT NOT NULL CONSTRAINT [DF_ProgressStates_EmailsSentCount] DEFAULT (0),
	CreatedAt DATETIME NOT NULL,
	CompletedAt DATETIME NULL,

	CONSTRAINT [PK_ProgressStates] PRIMARY KEY (ProgressStateID),
	CONSTRAINT [FK_ProgressStates_NewsletterID] FOREIGN KEY (NewsletterID) REFERENCES dbo.Newsletters(NewsletterID)
)

-- Failed Emails --
CREATE TABLE dbo.FailedEmails
(
	FailedEmailID INT IDENTITY(1,1) NOT NULL,
	ProgressStateID INT NOT NULL,
	Message NVARCHAR(MAX) NOT NULL,
	FailedAt DATETIME NOT NULL,
	
	CONSTRAINT [PK_FailedEmails] PRIMARY KEY (FailedEmailID),
	CONSTRAINT [FK_FailedEmails_ProgressStateID] FOREIGN KEY (ProgressStateID) REFERENCES dbo.ProgressStates(ProgressStateID)
)

-------------------------------------------------------
-- Taxonomy, Ratings and Comments 
-------------------------------------------------------

-- Taxonomy: Classification
-- Taxon: An item or a group of items, which the taxonomist identifies as a separate unit. If the web site 
--        has a large infrastructure of all kinds of medias � images, documents, videos, articles, then a Taxon 
--        of graphics can be defined, which will categorize (or classify) all the images.
-- Taxa: The plural of Taxon. 

-- Flat Taxonomies: (Taxa have equal weight)
-- Hierarchical Taxonomies: Categories (Hierarchical Taxonomy is a structure in which the taxons are organized hierarchically. Each Taxon could have one parent Taxon and unlimited number of child Taxa.)

-- Taxonomy --
CREATE TABLE dbo.Taxonomies
(	
	TaxonomyID INT IDENTITY(1,1) NOT NULL,
	ModuleID INT NOT NULL,
	Name NVARCHAR(250) NOT NULL,
	OwnerID INT NOT NULL,
	ModifiedAt DATETIME NOT NULL,
						
	CONSTRAINT [PK_Taxonomies] PRIMARY KEY (TaxonomyID),
	CONSTRAINT [FK_Taxonomies_ModuleID] FOREIGN KEY (ModuleID) REFERENCES dbo.Modules(ModuleID),
	CONSTRAINT [FK_Taxonomies_OwnerID] FOREIGN KEY (OwnerID) REFERENCES dbo.[Users](UserID)
)

-- Taxa --
CREATE TABLE dbo.Taxa
(	
	TaxonID INT IDENTITY(1,1) NOT NULL,
	Name NVARCHAR(250) NOT NULL,
	Description NVARCHAR(MAX) NULL,
	ParentTaxonID INT NOT NULL CONSTRAINT [DF_Taxa_ParentTaxonID] DEFAULT (0),
	TaxonomyID INT NOT NULL,
	ShowInNavigation INT NOT NULL CONSTRAINT [DF_Taxa_ShowInNavigation] DEFAULT (1),
	RenderAsLink INT NOT NULL CONSTRAINT [DF_Taxa_RenderAsLink] DEFAULT (1),
	Ordinal INT NOT NULL CONSTRAINT [DF_Taxa_Ordinal] DEFAULT (0),
	ModifiedAt DATETIME NOT NULL,
						
	CONSTRAINT [PK_Taxa] PRIMARY KEY (TaxonID),
	CONSTRAINT [FK_Taxa_TaxonomyID] FOREIGN KEY (TaxonomyID) REFERENCES dbo.Taxonomies(TaxonomyID)
)

-- Ratings --
CREATE TABLE dbo.Ratings
(
	ModuleID INT NOT NULL,
	ContentID INT NOT NULL,
	UserID INT NOT NULL,
	Score INT NOT NULL,
	RatedAt DATETIME NOT NULL,
						
	CONSTRAINT [PK_Ratings] PRIMARY KEY CLUSTERED (ModuleID, ContentID, UserID),
	CONSTRAINT [FK_Ratings_ModuleID] FOREIGN KEY (ModuleID) REFERENCES dbo.Modules(ModuleID),
	CONSTRAINT [FK_Ratings_UserID] FOREIGN KEY (UserID) REFERENCES dbo.[Users](UserID)
)

-- Likes --
CREATE TABLE dbo.[Likes]
(
	ModuleID INT NOT NULL,
	ContentID INT NOT NULL,
	UserID INT NOT NULL,
						
	CONSTRAINT [PK_Likes] PRIMARY KEY CLUSTERED (ModuleID, ContentID, UserID),
	CONSTRAINT [FK_Likes_ModuleID] FOREIGN KEY (ModuleID) REFERENCES dbo.Modules(ModuleID),
	CONSTRAINT [FK_Likes_UserID] FOREIGN KEY (UserID) REFERENCES dbo.[Users](UserID)
)

-- Comments --
CREATE TABLE dbo.Comments
(
	CommentID INT IDENTITY(1,1) NOT NULL,
	ModuleID INT NOT NULL,
	ContentID INT NOT NULL,
	Author NVARCHAR(250) NOT NULL,
	Email NVARCHAR(250) NULL,
	Website NVARCHAR(250) NULL,
	IPAddress NVARCHAR(15) NOT NULL,
	Body NVARCHAR(MAX) NOT NULL,
	Karma INT NOT NULL CONSTRAINT [DF_Comments_Karma] DEFAULT (0),
	SpamScore INT NOT NULL CONSTRAINT [DF_Comments_SpamScore] DEFAULT (0),
	IsVisible BIT NOT NULL CONSTRAINT [DF_Comments_IsVisible] DEFAULT (1),		
	CreatedByID INT NULL,
	CreatedAt DATETIME NOT NULL,
	ModifiedByID INT NULL,
	ModifiedAt DATETIME NOT NULL,
								
	CONSTRAINT [PK_Comments] PRIMARY KEY (CommentID),
	CONSTRAINT [FK_Comments_ModuleID] FOREIGN KEY (ModuleID) REFERENCES dbo.Modules(ModuleID),
	CONSTRAINT [FK_Comments_CreatedByID] FOREIGN KEY (CreatedByID) REFERENCES dbo.[Users](UserID),
	CONSTRAINT [FK_Comments_ModifiedByID] FOREIGN KEY (ModifiedByID) REFERENCES dbo.[Users](UserID)
)

-- Read Comments --
CREATE TABLE dbo.ReadComments
(
	CommentID INT NOT NULL,
	UserID INT NOT NULL,
								
	CONSTRAINT [PK_ReadComments] PRIMARY KEY CLUSTERED (CommentID, UserID),
	CONSTRAINT [FK_ReadComments_CommentID] FOREIGN KEY (CommentID) REFERENCES dbo.Comments(CommentID),
	CONSTRAINT [FK_ReadComments_UserID] FOREIGN KEY (UserID) REFERENCES dbo.[Users](UserID),
)

-------------------------------------------------------
-- Banned IPs, Content Filters and Gags 
-------------------------------------------------------

-- Banned IP Addresses --
CREATE TABLE dbo.BannedIPs
(	
	BannedIPID INT IDENTITY(1,1) NOT NULL,
	IPAddress NVARCHAR(15) NOT NULL,
	Reason NVARCHAR(1000) NULL,
	AllowOverride BIT NOT NULL CONSTRAINT [DF_BannedIPs_AllowOverride] DEFAULT (0),
	IsActive BIT NOT NULL CONSTRAINT [DF_BannedIPs_IsActive] DEFAULT (1),
	CreatedByID INT NOT NULL,
	CreatedAt DATETIME NOT NULL,
	ModifiedByID INT NOT NULL,
	ModifiedAt DATETIME NOT NULL,
						
	CONSTRAINT [PK_BannedIPs] PRIMARY KEY (BannedIPID),
	CONSTRAINT [FK_BannedIPs_CreatedByID] FOREIGN KEY (CreatedByID) REFERENCES dbo.[Users](UserID),
	CONSTRAINT [FK_BannedIPs_ModifiedByID] FOREIGN KEY (ModifiedByID) REFERENCES dbo.[Users](UserID)
)

-- Gagged Users --
CREATE TABLE dbo.GaggedUsers
(	
	GagID INT IDENTITY(1,1) NOT NULL,
	GaggedUserID INT NOT NULL,
	Reason NVARCHAR(MAX) NULL,
	FromDate DATETIME NOT NULL,
	UntilDate DATETIME NULL,
	CreatedByID INT NOT NULL,
	CreatedAt DATETIME NOT NULL,
	ModifiedByID INT NOT NULL,
	ModifiedAt DATETIME NOT NULL,
						
	CONSTRAINT [PK_GaggedUsers] PRIMARY KEY (GagID),
	CONSTRAINT [FK_GaggedUsers_GaggedUserID] FOREIGN KEY (GaggedUserID) REFERENCES dbo.[Users](UserID),
	CONSTRAINT [FK_GaggedUsers_CreatedByID] FOREIGN KEY (CreatedByID) REFERENCES dbo.[Users](UserID),
	CONSTRAINT [FK_GaggedUsers_ModifiedByID] FOREIGN KEY (ModifiedByID) REFERENCES dbo.[Users](UserID)
)

-- Content Filter --
CREATE TABLE dbo.ContentFilters
(	
	ContentFilterID INT IDENTITY(1,1) NOT NULL,
	StringToFilter NVARCHAR(250) NOT NULL,
	ReplaceWith NVARCHAR(250) NOT NULL,
	ModifiedAt DATETIME NOT NULL,
						
	CONSTRAINT [PK_ContentFilters] PRIMARY KEY (ContentFilterID)
)