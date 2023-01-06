CREATE TABLE [dbo].[Users]
(
    [Id] INT IDENTITY(1,1) NOT NULL,
    [UserName] NVARCHAR(100) NOT NULL,
    [ProfileName] NVARCHAR(100) NULL,
    [ProfilePictureUrl] NVARCHAR(500) NULL,
    [Website] NVARCHAR(100) NULL,
    [Bio] NVARCHAR(150) NULL,
    [EmailAddress] NVARCHAR(100) NULL,
    [IsEmailVerified] BIT NOT NULL CONSTRAINT [DF_Users_IsEmailVerified] DEFAULT (0),
    [PhoneNumber] NVARCHAR(100) NULL,
    [Gender]INT NOT NULL CONSTRAINT [DF_Users_Gender] DEFAULT (0),
    [CommentKeywords] NVARCHAR(MAX) NULL,
    [IncludeInRecommendations] BIT NOT NULL CONSTRAINT [DF_Users_IncludeInRecommendations] DEFAULT (1),
    [IsBusinessAccount] BIT NOT NULL CONSTRAINT [DF_Users_IsBusinessAccount] DEFAULT (0),
    [FollowsCount] INT NOT NULL CONSTRAINT [DF_Users_FollowsCount] DEFAULT (0),
    [FollowersCount] INT NOT NULL CONSTRAINT [DF_Users_FollowersCount] DEFAULT (0),
    [MediaCount] INT NOT NULL CONSTRAINT [DF_Users_MediaCount] DEFAULT (0),
    [IsActive] BIT NOT NULL CONSTRAINT [DF_Users_IsActive] DEFAULT (1),
    [LastLoginDateUtc] DATETIME NULL,
    [SignedUpDateUtc] DATETIME NOT NULL,

    CONSTRAINT [PK_Users] PRIMARY KEY ([Id]) 
);

CREATE TABLE [dbo].[LoginHistory]
(	
    [Id] INT IDENTITY(1,1) NOT NULL,
    [UserId] INT NOT NULL,
    [LocationCoordinates] NVARCHAR(100) NULL,
    [LastLoginDateUtc] DATETIME NOT NULL,
                    
    CONSTRAINT [PK_LoginHistory] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_LoginHistory_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users]([Id]),
);

CREATE TABLE [dbo].[EmailNotificationSettings]
(
    [Id] INT IDENTITY(1,1) NOT NULL,
    [UserId] INT NOT NULL,
    [FeedbackEmails] BIT NOT NULL CONSTRAINT [DF_EmailNotificationSettings_FeedbackEmails] DEFAULT (1),
    [ReminderEmails] BIT NOT NULL CONSTRAINT [DF_EmailNotificationSettings_ReminderEmails] DEFAULT (1),
    [ProductAnnouncementEmails] BIT NOT NULL CONSTRAINT [DF_EmailNotificationSettings_ProductEmails] DEFAULT (1),
    [NewsEmails] BIT NOT NULL CONSTRAINT [DF_EmailNotificationSettings_NewsEmails] DEFAULT (1), 
    [SupportRequestEmails] BIT NOT NULL CONSTRAINT [DF_EmailNotificationSettings_SupportRequestEmails] DEFAULT (1),
    [LastModifiedDateUtc] DATETIME NOT NULL,

    CONSTRAINT [PK_EmailNotificationSettings] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_EmailNotificationSettings_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users](Id)
);

CREATE TABLE [dbo].[PushNotificationSettings]
(
    [Id] INT IDENTITY(1,1) NOT NULL,
    [UserId] INT NOT NULL,
    [Likes] BIT NOT NULL CONSTRAINT [DF_PushNotificationSettings_Likes] DEFAULT (1),              
    [LikesAndCommentsOnPhotosOfYou] BIT NOT NULL CONSTRAINT [DF_PushNotificationSettings_LikesAndCommentsOnPhotosOfYou] DEFAULT (1),
    [Comments] BIT NOT NULL CONSTRAINT [DF_PushNotificationSettings_Comments] DEFAULT (1),
    [CommentLikes] BIT NOT NULL CONSTRAINT [DF_PushNotificationSettings_CommentLikes] DEFAULT (1),
    [PostsAndStories] BIT NOT NULL CONSTRAINT [DF_PushNotificationSettings_PostsAndStories] DEFAULT (1),
    [NewFollowers] BIT NOT NULL CONSTRAINT [DF_PushNotificationSettings_NewFollowers] DEFAULT (1),
    [AcceptedFollowRequests] BIT NOT NULL CONSTRAINT [DF_PushNotificationSettings_AcceptedFollowRequests] DEFAULT (1),
    [AccountSuggestions] BIT NOT NULL CONSTRAINT [DF_PushNotificationSettings_AccountSuggestions] DEFAULT (1),
    [MessageRequests] BIT NOT NULL CONSTRAINT [DF_PushNotificationSettings_MessageRequests] DEFAULT (1),
    [Messages] BIT NOT NULL CONSTRAINT [DF_PushNotificationSettings_Messages] DEFAULT (1),
    [GroupRequests] BIT NOT NULL CONSTRAINT [DF_PushNotificationSettings_GroupRequests] DEFAULT (1),
    [VideoChats] BIT NOT NULL CONSTRAINT [DF_PushNotificationSettings_VideoChats] DEFAULT (1),
    [Rooms] BIT NOT NULL CONSTRAINT [DF_PushNotificationSettings_Rooms] DEFAULT (1),
    [LiveVideos] BIT NOT NULL CONSTRAINT [DF_PushNotificationSettings_LiveVideos] DEFAULT (1),
    [RecentlyUploadedReels] BIT NOT NULL CONSTRAINT [DF_PushNotificationSettings_RecentlyUploadedReelss] DEFAULT (1),
    [MostWatchedReels] BIT NOT NULL CONSTRAINT [DF_PushNotificationSettings_MostWatchedReels] DEFAULT (1),
    [Fundraisers] BIT NOT NULL CONSTRAINT [DF_PushNotificationSettings_Fundraisers] DEFAULT (1),
    [FundraisersByOthers] BIT NOT NULL CONSTRAINT [DF_PushNotificationSettings_FundraisersByOthers] DEFAULT (1),
    [Reminders] BIT NOT NULL CONSTRAINT [DF_PushNotificationSettings_Reminders] DEFAULT (1),
    [ProductAnnouncements] BIT NOT NULL CONSTRAINT [DF_PushNotificationSettings_ProductAnnouncements] DEFAULT (1),
    [SupportRequests] BIT NOT NULL CONSTRAINT [DF_PushNotificationSettings_SupportRequests] DEFAULT (1),
    [UnrecognisedLogins] BIT NOT NULL CONSTRAINT [DF_PushNotificationSettings_UnrecognisedLogins] DEFAULT (1),
    [LastModifiedDateUtc] DATETIME NOT NULL,

    CONSTRAINT [PK_PushNotificationSettings] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_PushNotificationSettings_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users](Id)
);

CREATE TABLE [dbo].[PrivacySettings]
(
    [Id] INT IDENTITY(1,1) NOT NULL,
    [UserId] INT NOT NULL,
    [IsPrivateAccount] BIT NOT NULL CONSTRAINT [DF_PrivacySettings_IsPrivateAccount] DEFAULT (0),
    [ShowActivityStatus] BIT NOT NULL CONSTRAINT [DF_PrivacySettings_ShowActivityStatust] DEFAULT (1),
    [Sharing] BIT NOT NULL CONSTRAINT [DF_PrivacySettings_Sharing] DEFAULT (1),
    [Comments] BIT NOT NULL CONSTRAINT [DF_PrivacySettings_Comments] DEFAULT (1),
    [HideCommentsWithKeywords] BIT NOT NULL CONSTRAINT [DF_PrivacySettings_HideCommentsWithKeywords] DEFAULT (0),
    [OthersCanPostPhotosOfYou] BIT NOT NULL CONSTRAINT [DF_PrivacySettings_OthersCanPostPhotosOfYou] DEFAULT (0),
    [EssentialCookies] BIT NOT NULL CONSTRAINT [DF_PrivacySettings_EssentialCookies] DEFAULT (0),
    [AtMentions] BIT NOT NULL CONSTRAINT [DF_PrivacySettings_AtMentions] DEFAULT (1),
    [PostsCanBeUsedByOthers] BIT NOT NULL CONSTRAINT [DF_PrivacySettings_PostsCanBeUsedByOthers] DEFAULT (1),
    [HideLikeAndViewCount] BIT NOT NULL CONSTRAINT [DF_PrivacySettings_HideLikeAndViewCount] DEFAULT (0),
    [Tags] BIT NOT NULL CONSTRAINT [DF_PrivacySettings_Tags] DEFAULT (1),
    [PostFeatureRequests] BIT NOT NULL CONSTRAINT [DF_PrivacySettings_PostFeatureRequests] DEFAULT (1),
    [Messages] BIT NOT NULL CONSTRAINT [DF_PrivacySettings_Messages] DEFAULT (1),
    [GroupInvites] BIT NOT NULL CONSTRAINT [DF_PrivacySettings_GroupInvites] DEFAULT (1),
    [LastModifiedDateUtc] DATETIME NOT NULL,

    CONSTRAINT [PK_PrivacySettings] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_PrivacySettings_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users](Id)
);

CREATE TABLE [dbo].[Followers]
(
    [UserId] INT NOT NULL,
    [FollowerId] INT NOT NULL,
    
    CONSTRAINT [PK_Followers]  PRIMARY KEY CLUSTERED ([UserId], [FollowerId]),
    CONSTRAINT [FK_Followers_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users](Id),
    CONSTRAINT [FK_Followers_FollowerId] FOREIGN KEY ([FollowerId]) REFERENCES [dbo].[Users](Id)
);

CREATE TABLE [dbo].[Blocked]
(
    [UserId] INT NOT NULL,
    [BlockedId] INT NOT NULL,
    
    CONSTRAINT [PK_Blocked]  PRIMARY KEY CLUSTERED ([UserId], [BlockedId]),
    CONSTRAINT [FK_Blocked_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users](Id),
    CONSTRAINT [FK_Blocked_BlockedId] FOREIGN KEY ([BlockedId]) REFERENCES [dbo].[Users](Id)
);

CREATE TABLE [dbo].[SupervisedAccounts]
(
    [UserId] INT NOT NULL,
    [SupervisedId] INT NOT NULL,
    
    CONSTRAINT [PK_SupervisedAccounts]  PRIMARY KEY CLUSTERED ([UserId], [SupervisedId]),
    CONSTRAINT [FK_SupervisedAccounts_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users](Id),
    CONSTRAINT [FK_SupervisedAccounts_SupervisedId] FOREIGN KEY ([SupervisedId]) REFERENCES [dbo].[Users](Id)
);

CREATE TABLE [dbo].[Posts]
(	
    [Id] INT IDENTITY(1,1) NOT NULL,
    [UserId] INT NOT NULL,
    [Status] INT NOT NULL CONSTRAINT [DF_Posts_Status] DEFAULT (1),
    [StatusCode] NVARCHAR(10) NULL,
    [PublishedDateUtc] DATETIME NULL,
                    
    CONSTRAINT [PK_Posts] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_Posts_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users](Id)
);

CREATE TABLE [dbo].[Media]
(	
    [Id] INT IDENTITY(1,1) NOT NULL,
    [UserId] INT NOT NULL,
    [PostId] INT NOT NULL,
    [MediaType] INT NOT NULL, 
    [MediaUrl] NVARCHAR(500) NOT NULL,
    [PermaLink] NVARCHAR(500) NULL,
    [ShortCode] NVARCHAR(100) NULL,
    [Caption] NVARCHAR(2000) NULL,
    [ThumbnailUrl] NVARCHAR(500) NULL,
    [IsPublished] BIT NOT NULL CONSTRAINT [DF_Media_IsPublished] DEFAULT (1),
    [IsCommentsEnabled] INT NOT NULL CONSTRAINT [DF_Media_IsCommentsEnabled] DEFAULT (1),
    [ViewCount] INT NOT NULL CONSTRAINT [DF_Media_ViewCount] DEFAULT (1),
    [CommentCount] INT NOT NULL CONSTRAINT [DF_Media_CommentCount] DEFAULT (0),
    [LikeCount] INT NOT NULL CONSTRAINT [DF_Media_LikeCount] DEFAULT (0),
    [LocationCoordinates] NVARCHAR(100) NULL,
    [CreatedDateUtc] DATETIME NOT NULL,
 
    CONSTRAINT [PK_Media] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_Media_PostId] FOREIGN KEY ([PostId]) REFERENCES [dbo].[Posts]([Id]),
    CONSTRAINT [FK_Media_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users]([Id])
);

CREATE TABLE [dbo].[MediaLikes]
(	
    [Id] INT IDENTITY(1,1) NOT NULL,
    [MediaId] INT NOT NULL,
    [UserId] INT NOT NULL,
    [LikedDateUtc] DATETIME NOT NULL,

    CONSTRAINT [PK_MediaLikes] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_MediaLikes_MediaId] FOREIGN KEY ([MediaId]) REFERENCES [dbo].[Media](Id),
    CONSTRAINT [FK_MediaLikes_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users](Id)
);

CREATE TABLE [dbo].[Tags]
(	
    [Id] INT IDENTITY(1,1) NOT NULL,
    [Name] NVARCHAR(100) NOT NULL,
                    
    CONSTRAINT [PK_Tags] PRIMARY KEY ([Id])
);

CREATE TABLE [dbo].[MediaTags]
(
    [MediaId] INT NOT NULL,
    [TagId] INT NOT NULL,
    
    CONSTRAINT [PK_MediaTags]  PRIMARY KEY CLUSTERED ([MediaId], [TagId]),
    CONSTRAINT [FK_MediaTags_MediaId] FOREIGN KEY ([MediaId]) REFERENCES [dbo].[Media](Id),
    CONSTRAINT [FK_MediaTags_TagId] FOREIGN KEY ([TagId]) REFERENCES [dbo].[Tags](Id)
);

CREATE TABLE [dbo].[Comments]
(	
    [Id] INT IDENTITY(1,1) NOT NULL,
    [ParentCommentId] INT NULL,
    [MediaId] INT NOT NULL,
    [UserId] INT NOT NULL,
    [Message] NVARCHAR(2000) NOT NULL,
    [IsHidden] INT NOT NULL CONSTRAINT [DF_Comments_IsHidden] DEFAULT (0),
    [LikeCount] INT NOT NULL CONSTRAINT [DF_Comments_LikeCount] DEFAULT (0),
    [CreatedDateUtc] DATETIME NOT NULL,
                    
    CONSTRAINT [PK_Comments] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_Comments_MediaId] FOREIGN KEY ([MediaId]) REFERENCES [dbo].[Media]([Id]),
    CONSTRAINT [FK_Comments_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users]([Id])
);

CREATE TABLE [dbo].[CommentLikes]
(	
    [Id] INT IDENTITY(1,1) NOT NULL,
    [CommentId] INT NOT NULL,
    [UserId] INT NOT NULL,
    [LikedDateUtc] DATETIME NOT NULL,

    CONSTRAINT [PK_CommentLikes] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_CommentLikes_CommentId] FOREIGN KEY ([CommentId]) REFERENCES [dbo].[Comments](Id),
    CONSTRAINT [FK_CommentLikes_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users](Id)
);