DECLARE @SysAdminId INT;
DECLARE @SeedDate DATETIME;

SET @SeedDate = GETUTCDATE()

INSERT INTO [dbo].[Users] ([UserName], [ProfileName], [ProfilePictureUrl], [Website], [Bio], [EmailAddress], [IsEmailVerified], [PhoneNumber], [Gender], [CommentKeywords], [IncludeInRecommendations], [IsBusinessAccount], [FollowsCount], [FollowersCount], [MediaCount], [IsActive], [LastLoginDateUtc], [SignedUpDateUtc]) VALUES ('Sysadmin', NULL, NULL, NULL, NULL, 'sysadmin@finstagram.com', 1, NULL, 0, NULL, 0, 0, 0, 0, 0, 1, NULL, @SeedDate)

SELECT @SysAdminId = [Id] FROM [dbo].[Users] WHERE [UserName] = 'Sysadmin' -- Should be 1.

INSERT INTO [dbo].[Entities] ([Name]) VALUES ('Users')
INSERT INTO [dbo].[Entities] ([Name]) VALUES ('Posts')
INSERT INTO [dbo].[Entities] ([Name]) VALUES ('Media')
INSERT INTO [dbo].[Entities] ([Name]) VALUES ('Comments')