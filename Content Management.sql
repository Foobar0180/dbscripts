/* 
Descriptiom: Blog Database Schema V1.0
Created By:  David Winchester
Last Update: 02 February, 2011
*/

-------------------------------------------------------
-- SYSTEM 
-------------------------------------------------------

-- DATABASE VERSIONS --
CREATE TABLE dbo.Versions
(	
	Major INT NOT NULL,	
	Minor INT NOT NULL,		
	Patch INT NOT NULL,	
	Feature NVARCHAR(250) NOT NULL,
	IsCurrentVersion BIT NOT NULL CONSTRAINT [DF_Versions_IsCurrentVersion] DEFAULT (0),	
	
	CONSTRAINT [PK_Versions] PRIMARY KEY CLUSTERED (Major, Minor, Patch)
)

-- APPLICATION SETTINGS --
CREATE TABLE dbo.AppSettings
(	
	KeyName NVARCHAR(250) NOT NULL,
	Value NVARCHAR(250) NOT NULL,
	Description NVARCHAR(MAX) NULL,
	ModifiedOn DATETIME NOT NULL,
					
	CONSTRAINT [PK_AppSettings] PRIMARY KEY CLUSTERED (KeyName, Value)
)

-------------------------------------------------------
-- SECURITY 
-------------------------------------------------------

-- USERS --
CREATE TABLE dbo.Users
(	
	UserID INT IDENTITY(1,1) NOT NULL,
	UserName NVARCHAR(250) NOT NULL,
	Password NVARCHAR(250) NOT NULL,
	PasswordFormat INT NOT NULL,
	PasswordSalt NVARCHAR(250) NOT NULL,
	PasswordExpirationOn DATETIME NULL,
	PasswordQuestion NVARCHAR(250) NULL,
	PasswordAnswer NVARCHAR(250) NULL,
	IsApproved BIT NOT NULL CONSTRAINT [DF_Users_IsApproved] DEFAULT (0), 
	IsLockedOut BIT NOT NULL CONSTRAINT [DF_Users_IsLockedOut] DEFAULT (0),
	LastLoginOn DATETIME NULL,
	LastActivityOn DATETIME NOT NULL,
	LastPasswordChangedOn DATETIME NOT NULL,
	LastLockoutOn DATETIME NULL,
	FailedPasswordAttemptCount INT NOT NULL CONSTRAINT [DF_Users_FailedPasswordAttemptCount] DEFAULT (0),
	FailedPasswordAttemptWindowStart DATETIME NULL,
	FailedPasswordAnswerAttemptCount INT NOT NULL CONSTRAINT [DF_Users_FailedPasswordAnswerAttemptCount] DEFAULT (0),
	FailedPasswordAnswerAttemptWindowStart DATETIME NULL,
	CreatedOn DATETIME NOT NULL,
	IsDeleted INT NOT NULL CONSTRAINT [DF_Users_IsDeleted] DEFAULT (0),
					
	CONSTRAINT [PK_Users] PRIMARY KEY (UserID),
	CONSTRAINT [UQ_Users_UserName] UNIQUE (UserName)
)

-- LOGIN HISTORY --
CREATE TABLE dbo.LoginHistory
(	
	LoginHistoryID INT IDENTITY(1,1) NOT NULL,
	UserID INT NOT NULL,
	SourceIPAddress NVARCHAR(15) NOT NULL,
	LoginUrl NVARCHAR(250) NOT NULL,
	LoggedInOn DATETIME NOT NULL,	
					
	CONSTRAINT [PK_LoginHistory] PRIMARY KEY (LoginHistoryID),
	CONSTRAINT [FK_LoginHistory_UserID] FOREIGN KEY (UserID) REFERENCES dbo.Users(UserID)
)

-- ROLES --
CREATE TABLE dbo.Roles
(	
	RoleID INT IDENTITY(1,1) NOT NULL,
	Name NVARCHAR(250) NOT NULL,	
					
	CONSTRAINT [PK_Roles] PRIMARY KEY (RoleID)
)

-- USER IN ROLES --
CREATE TABLE dbo.UsersInRoles
(	
	UserID INT NOT NULL,
	RoleID INT NOT NULL,
					
	CONSTRAINT [PK_UsersInRoles] PRIMARY KEY CLUSTERED (UserID, RoleID),
	CONSTRAINT [FK_UsersInRoles_UserID] FOREIGN KEY (UserID) REFERENCES dbo.Users(UserID),
	CONSTRAINT [FK_UsersInRoles_RoleID] FOREIGN KEY (RoleID) REFERENCES dbo.Roles(RoleID)
)

-------------------------------------------------------
-- CMS 
-------------------------------------------------------

-- PAGES --
CREATE TABLE dbo.Pages
(
	PageID INT IDENTITY(1,1) NOT NULL,
	Title NVARCHAR(250) NOT NULL,
	Keywords NVARCHAR(MAX) NULL,
	Description NVARCHAR(MAX) NULL,
	Content NVARCHAR(MAX) NULL,
	IsPublished BIT NOT NULL CONSTRAINT [DF_Pages_IsPublished] DEFAULT (0),
	ParentPageID INT NOT NULL CONSTRAINT [DF_Pages_ParentPageID] DEFAULT (0),
	ShowInNavigation BIT NOT NULL CONSTRAINT [DF_Pages_ShowInNavigation] DEFAULT (0),
	FriendlyUrl NVARCHAR(250) NULL,
	CreatedOn DATETIME NOT NULL,
	CreatedByID INT NOT NULL,
	ModifiedOn DATETIME NOT NULL,
	ModifiedByID INT NOT NULL,
	IsDeleted BIT NOT NULL CONSTRAINT [DF_Pages_IsDeleted] DEFAULT (0),
	
	CONSTRAINT [PK_Pages] PRIMARY KEY (PageID),
	CONSTRAINT [FK_Pages_CreatedByID] FOREIGN KEY (CreatedByID) REFERENCES dbo.Users(UserID),
	CONSTRAINT [FK_Pages_ModifiedByID] FOREIGN KEY (ModifiedByID) REFERENCES dbo.Users(UserID)
)

-- PAGE HISTORY --
CREATE TABLE dbo.PageHistory
(
	PageHistoryID INT IDENTITY(1,1) NOT NULL,
	PageID INT NOT NULL,
	Content NVARCHAR(MAX) NOT NULL,
	Comment NVARCHAR(MAX) NULL,
	VersionNumber INT NOT NULL,
	IsPublishedVersion BIT NOT NULL CONSTRAINT [DF_PageHistory_IsPublishedVersion] DEFAULT (0),
	IsLocked BIT NOT NULL CONSTRAINT [DF_PageHistory_IsLocked] DEFAULT (0),
	ModifiedByID INT NOT NULL,
	ModifiedOn DATETIME NOT NULL,
	
	CONSTRAINT [PK_PageHistory] PRIMARY KEY (PageHistoryID),
	CONSTRAINT [FK_PageHistory_PageID] FOREIGN KEY (PageID) REFERENCES dbo.Pages(PageID),
	CONSTRAINT [FK_PageHistory_ModifiedByID] FOREIGN KEY (ModifiedByID) REFERENCES dbo.Users(UserID)
)

-- POSTS --
CREATE TABLE dbo.Posts
(	
	PostID INT IDENTITY(1,1) NOT NULL,
	Title NVARCHAR(250) NOT NULL,
	Excerpt NVARCHAR(2000) NULL,
	Body NVARCHAR(MAX) NOT NULL,
	FriendlyUrl NVARCHAR(250) NULL,
	IsPublished BIT NOT NULL CONSTRAINT [DF_Posts_IsPublished] DEFAULT (0),
	EnableComments BIT NOT NULL CONSTRAINT [DF_Posts_CommentsEnabled] DEFAULT (0),
	TotalViews INT NOT NULL CONSTRAINT [DF_Posts_TotalViews] DEFAULT (0),
	Votes INT NOT NULL CONSTRAINT [DF_Posts_Votes] DEFAULT (0),
	Rating INT NOT NULL CONSTRAINT [DF_Posts_Rating] DEFAULT (0),						
	CreatedOn DATETIME NOT NULL,
	CreatedByID INT NOT NULL,
	ModifiedOn DATETIME NOT NULL,
	ModifiedByID INT NOT NULL,
	IsDeleted BIT NOT NULL CONSTRAINT [DF_Posts_IsDeleted] DEFAULT (0),
					
	CONSTRAINT [PK_Posts] PRIMARY KEY (PostID),
	CONSTRAINT [FK_Posts_CreatedByID] FOREIGN KEY (CreatedByID) REFERENCES dbo.Users(UserID),
	CONSTRAINT [FK_Posts_ModifiedByID] FOREIGN KEY (ModifiedByID) REFERENCES dbo.Users(UserID)
)

-- COMMENTS --
CREATE TABLE dbo.Comments
(
	CommentID INT IDENTITY(1,1) NOT NULL,
	PostID INT NOT NULL,
	Author NVARCHAR(250) NOT NULL,
	Email NVARCHAR(250) NULL,
	Website NVARCHAR(250) NULL,
	IPAddress NVARCHAR(15) NOT NULL,
	Body NVARCHAR(MAX) NOT NULL,
	IsSpam BIT NOT NULL CONSTRAINT [DF_Comments_IsSpam] DEFAULT (0),
	IsApproved BIT NOT NULL CONSTRAINT [DF_Comments_IsApproved] DEFAULT (0),
	ApprovedByID INT NULL,
	ApprovedOn DATETIME NULL,
	IsTrackBack BIT NOT NULL CONSTRAINT [DF_Comments_IsTrackBack] DEFAULT (0),
	CreatedOn DATETIME NOT NULL,		
	ModifiedOn DATETIME NULL,		
	ModifiedByID NVARCHAR(250) NULL,
	IsDeleted BIT NOT NULL CONSTRAINT [DF_Comments_IsDeleted] DEFAULT (0),
							
	CONSTRAINT [PK_Comments] PRIMARY KEY (CommentID),
	CONSTRAINT [FK_Comments_PostID] FOREIGN KEY (PostID) REFERENCES dbo.Posts(PostID)
)

-- TAXONOMY --
CREATE TABLE dbo.Taxonomies
(	
	TaxonomyID INT IDENTITY(1,1) NOT NULL,
	Name NVARCHAR(250) NOT NULL,
	Description NVARCHAR(MAX) NULL,
	DateModified DATETIME NOT NULL,
					
	CONSTRAINT [PK_Taxonomy] PRIMARY KEY (TaxonomyID),
)

-- TAXON --
CREATE TABLE dbo.Taxa
(	
	TaxonID INT IDENTITY(1,1) NOT NULL,
	Name NVARCHAR(250) NOT NULL,
	Description NVARCHAR(MAX) NULL,
	TaxonomyID INT NOT NULL,
	ParentTaxonID INT NULL,
	FriendlyUrl NVARCHAR(250) NULL,
	ShowInNavigation INT NOT NULL CONSTRAINT [DF_Taxa_ShowInNavigation] DEFAULT (1),
	RenderAsLink INT NOT NULL CONSTRAINT [DF_Taxa_RenderAsLink] DEFAULT (1),
	MarkedItems INT NOT NULL CONSTRAINT [DF_Taxa_MarkedItems] DEFAULT (0),
	DateModified DATETIME NOT NULL,
					
	CONSTRAINT [PK_Taxa] PRIMARY KEY (TaxonID),
	CONSTRAINT [FK_Taxa_TaxonomyID] FOREIGN KEY (TaxonomyID) REFERENCES dbo.Taxonomies(TaxonomyID)
)

-- BAD WORDS --
CREATE TABLE dbo.BadWords
(	
	BadWordID INT IDENTITY(1,1) NOT NULL,
	StringToFilter NVARCHAR(250) NOT NULL,
	ReplaceWith NVARCHAR(250) NOT NULL,
					
	CONSTRAINT [PK_BadWords] PRIMARY KEY (BadWordID)
)

-------------------------------------------------------
-- AWARDS 
-------------------------------------------------------

-- RANKS --
CREATE TABLE dbo.Ranks
(	
	RankID INT IDENTITY(1,1) NOT NULL,
	Name NVARCHAR(250) NOT NULL,
	MinPoints INT NOT NULL,
	InsigniaImageUrl NVARCHAR(250) NULL,
	DisplayOrder INT NOT NULL CONSTRAINT [DF_Ranks_DisplayOrder] DEFAULT (0),
					
	CONSTRAINT [PK_Ranks] PRIMARY KEY (RankID)
)

-- MEDALS --
CREATE TABLE dbo.Medals
(	
	MedalID INT IDENTITY(1,1) NOT NULL,
	Name NVARCHAR(250) NOT NULL,
	Description NVARCHAR(max) NOT NULL,
	MedalImageUrl NVARCHAR(250) NOT NULL,
	RibbonImageUrl NVARCHAR(250) NULL,
	DisplayOrder INT NOT NULL CONSTRAINT [DF_Medals_DisplayOrder] DEFAULT (0),
							
	CONSTRAINT [PK_Medals] PRIMARY KEY (MedalID)
)

-- USER MEDALS --
CREATE TABLE dbo.UserMedals
(	
	UserID INT NOT NULL,
	MedalID INT NOT NULL,
	Citation NVARCHAR(max) NOT NULL,
	IsVisible BIT NOT NULL CONSTRAINT [DF_UserMedals_IsVisible] DEFAULT (1),
	OnlyRibbon BIT NOT NULL CONSTRAINT [DF_UserMedals_OnlyRibbon] DEFAULT (0),
	DisplayOrder BIT NOT NULL CONSTRAINT [DF_UserMedals_DisplayOrder] DEFAULT (0),
	AwardedOn DATETIME NOT NULL,  
					
	CONSTRAINT [PK_UserMedals] PRIMARY KEY CLUSTERED (UserID, MedalID),
	CONSTRAINT [FK_UserMedals_UserID] FOREIGN KEY (UserID) REFERENCES dbo.Users(UserID),
	CONSTRAINT [FK_UserMedals_MedalID] FOREIGN KEY (MedalID) REFERENCES dbo.Medals(MedalID)
)

-------------------------------------------------------
-- FRIENDSHIPS 
-------------------------------------------------------

--  INVITATIONS --
CREATE TABLE dbo.Invitations
(	
	InvitationID INT IDENTITY(1,1) NOT NULL,
	SentByID INT NOT NULL,
	ToEmail NVARCHAR(250) NOT NULL,
	Message NVARCHAR(MAX) NULL,
	InvitationKey UNIQUEIDENTIFIER NOT NULL,
	ValidUntil DATETIME NULL,
	BecameID INT NULL,
	CreatedOn DATETIME NOT NULL,
					
	CONSTRAINT [PK_Invitations] PRIMARY KEY (InvitationID),
	CONSTRAINT [FK_Invitations_SentByID] FOREIGN KEY (SentByID) REFERENCES dbo.Users(UserID),
	CONSTRAINT [FK_Invitations_BecameID] FOREIGN KEY (BecameID) REFERENCES dbo.Users(UserID)
)

-- FRIENDSHIPS --
CREATE TABLE dbo.Friendships
(
	FromID INT NOT NULL,
	ToID INT NOT NULL,
	RequestMessage NVARCHAR(MAX) NULL,
	IsAccepted BIT NOT NULL CONSTRAINT [DF_Friendship_IsAccepted] DEFAULT (0),
	AcceptedOn DATETIME NULL,
							
	CONSTRAINT [PK_Friendships] PRIMARY KEY CLUSTERED (FromID, ToID),
	CONSTRAINT [FK_Friendships_FromID] FOREIGN KEY (FromID) REFERENCES dbo.Users(UserID),
	CONSTRAINT [FK_Friendships_ToID] FOREIGN KEY (ToID) REFERENCES dbo.Users(UserID)
)

-- FRIEND LISTS --
CREATE TABLE dbo.FriendLists
(
	FriendListID INT IDENTITY(1,1) NOT NULL,
	Name NVARCHAR(250) NOT NULL,
	OwnerID INT NOT NULL,
					
	CONSTRAINT [PK_FriendLists] PRIMARY KEY (FriendListID),
	CONSTRAINT [FK_FriendLists_OwnerID] FOREIGN KEY (OwnerID) REFERENCES dbo.Users(UserID)
)

-- FRIEND LIST MEMBERS --
CREATE TABLE dbo.FriendListMembers
(
	FriendListID INT NOT NULL,
	UserID INT NOT NULL,
	ShowInActivityFeed BIT NOT NULL CONSTRAINT [DF_FriendListMember_ShowInActivityFeed] DEFAULT (1),
					
	CONSTRAINT [PK_FriendListMembers] PRIMARY KEY CLUSTERED (FriendListID, UserID),
	CONSTRAINT [FK_FriendListMembers_FriendListID] FOREIGN KEY (FriendListID) REFERENCES dbo.FriendList(FriendListID),
	CONSTRAINT [FK_FriendListMembers_UserID] FOREIGN KEY (UserID) REFERENCES dbo.Users(UserID)
)

-- FOLLOWERS --
CREATE TABLE dbo.Followers
(
	UserID INT NOT NULL,
	FollowerID INT NOT NULL,
					
	CONSTRAINT [PK_Followers] PRIMARY KEY CLUSTERED (UserID, FollowerID),
	CONSTRAINT [FK_Followers_UserID] FOREIGN KEY (UserID) REFERENCES dbo.Users(UserID),
	CONSTRAINT [FK_Followers_FollowerID] FOREIGN KEY (FollowerID) REFERENCES dbo.Users(UserID)
)

-- IGNORED USERS --
CREATE TABLE dbo.IgnoredUsers
(
	UserID INT NOT NULL,
	IgnoreID INT NOT NULL,
					
	CONSTRAINT [PK_IgnoredUsers] PRIMARY KEY CLUSTERED (UserID, IgnoreID),
	CONSTRAINT [FK_IgnoredUsers_UserID] FOREIGN KEY (UserID) REFERENCES dbo.Users(UserID),
	CONSTRAINT [FK_IgnoredUsers_IgnoreID] FOREIGN KEY (IgnoreID) REFERENCES dbo.Users(UserID)
)