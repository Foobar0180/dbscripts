/* 
Descriptiom: ASPNET Identity Database Schema V1.0
Created By:  David Winchester
Last Update: 02 January, 2019
*/
USE [IdentityDb]
GO

CREATE USER [IdentitySystemUser] FOR LOGIN [IdentitySystemUser]
    WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_datareader] ADD MEMBER [IdentitySystemUser]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [IdentitySystemUser]
GO

PRINT 'Created database user.';

PRINT 'Installing ASPNET Identity SQL objects.';

-- Schema Versions --
CREATE TABLE [dbo].[SchemaVersions]
(	
	[Major] INT NOT NULL,	
	[Minor] INT NOT NULL,		
	[Patch] INT NOT NULL,	
	[Feature] NVARCHAR(250) NULL,
    [InstalledDateUtc] DATETIME NOT NULL,
	[IsCurrentVersion] BIT NOT NULL CONSTRAINT [DF_SchemaVersions_IsCurrentVersion] DEFAULT (0),	
	
	CONSTRAINT [PK_SchemaVersions] PRIMARY KEY CLUSTERED (Major, Minor, Patch)
)
PRINT 'Created table dbo.SchemaVersions';

DECLARE @CURRENT_SCHEMA_VERSION INT;
SELECT @CURRENT_SCHEMA_VERSION = [Major] FROM dbo.SchemaVersions;

-- Let us check to see if this is the first time this database is being created.

IF @CURRENT_SCHEMA_VERSION IS NULL
BEGIN
	    PRINT 'Installing schema version 1';

		-- Users table
		CREATE TABLE [dbo].[Users]
		(	
			[Id] INT IDENTITY(1,1) NOT NULL,
			[Username] NVARCHAR(250) NOT NULL,
			[Email] NVARCHAR(250) NULL,
			[IsEmailConfirmed] BIT NOT NULL CONSTRAINT [DF_Users_IsEmailConfirmed] DEFAULT (0), 
			[PasswordFormat] INT NOT NULL,
			[PasswordHash] NVARCHAR(MAX) NOT NULL,        
            [PasswordSalt] NVARCHAR(250) NOT NULL,
			[PasswordQuestion] NVARCHAR(250) NULL,
			[PasswordAnswer] NVARCHAR(250) NULL,
			[PasswordExpiresDateUtc] DATETIME NULL,
			[TwoFactorEnabled] BIT NOT NULL CONSTRAINT [DF_Users_TwoFactorEnabled] DEFAULT (0), 
			[IsApproved] BIT NOT NULL CONSTRAINT [DF_Users_IsApproved] DEFAULT (0),
			[IsLockedOut] BIT NOT NULL CONSTRAINT [DF_Users_IsLockedOut] DEFAULT (0),
			[LastLoginDateUtc] DATETIME NULL,
			[LastActivityDateUtc] DATETIME NOT NULL,
			[LastPasswordResetDateUtc] DATETIME NULL,
			[LastLockoutDateUtc] DATETIME NULL,
			[FailedPasswordAttemptCount] INT NOT NULL CONSTRAINT [DF_Users_FailedPasswordAttemptCount] DEFAULT (0),
			[FailedPasswordAttemptWindowStart] DATETIME NULL,
			[FailedPasswordAnswerAttemptCount] INT NOT NULL CONSTRAINT [DF_Users_FailedPasswordAnswerAttemptCount] DEFAULT (0),
			[FailedPasswordAnswerAttemptWindowStart] DATETIME NULL,
			[CreatedDateUtc] DATETIME NOT NULL,
			[LastModifiedDateUtc] DATETIME NOT NULL,
			[SystemModstamp] DATETIME NOT NULL,
			[IsDeleted] BIT NOT NULL CONSTRAINT [DF_Users_IsDeleted] DEFAULT (0),
							
			CONSTRAINT [PK_Users] PRIMARY KEY ([Id]) 
		);
		PRINT 'Created table dbo.Users';

        -- Password history table

        CREATE TABLE [dbo].[PasswordHistory]
		(
            [Id] INT IDENTITY(1,1) NOT NULL,
            [UserId] INT NOT NULL,
            [OldPasswordHash] NVARCHAR(MAX) NOT NULL,
            [CreatedDateUtc] DATETIME NOT NULL,
        				
			CONSTRAINT [PK_PasswordHistory] PRIMARY KEY ([Id]),
            CONSTRAINT [FK_PasswordHistory_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users](Id)
		);
		PRINT 'Created table dbo.PasswordHistory';

        -- Password resets table

		CREATE TABLE [dbo].[PasswordResets]
		(
			[Id] INT IDENTITY(1,1) NOT NULL,
            [UserId] INT NOT NULL,
            [ResetUrl] NVARCHAR(MAX) NOT NULL,
            [ExpirationDateUtc] DATETIME NOT NULL,
            [ActivatedDateUtc] DATETIME NULL,
			[CreatedDateUtc] DATETIME NOT NULL,
			
			CONSTRAINT [PK_PasswordResets] PRIMARY KEY ([Id]),
            CONSTRAINT [FK_PasswordResets_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users]([Id])
		);
		PRINT 'Created table dbo.PasswordResets';

        -- Roles table

		CREATE TABLE [dbo].[Roles]
		(
			[Id] INT IDENTITY(1,1) NOT NULL,
			[Name] NVARCHAR(250) NOT NULL,
			[DisplayName] NVARCHAR(250) NULL,
            [Description] NVARCHAR(1000) NULL,
			[IsEnabled] BIT NOT NULL CONSTRAINT [DF_Roles_IsEnabled] DEFAULT (0),
			
			CONSTRAINT [PK_Roles] PRIMARY KEY ([Id])
		);
		PRINT 'Created table dbo.Roles';

        -- Users in roles table

		CREATE TABLE [dbo].[UsersInRoles]
		(
			[UserId] INT NOT NULL,
	        [RoleId] INT NOT NULL,
			
			CONSTRAINT [PK_UsersInRoles] PRIMARY KEY CLUSTERED ([UserId], [RoleId]),
            CONSTRAINT [FK_UsersInRoles_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users]([Id]),
			CONSTRAINT [FK_UsersInRoles_RoleId] FOREIGN KEY ([RoleId]) REFERENCES [dbo].[Roles]([Id])
		);
		PRINT 'Created table dbo.UsersInRoles';

		-- Login history table

		CREATE TABLE [dbo].[LoginHistory]
		(	
			[Id] INT IDENTITY(1,1) NOT NULL,
			[LoginProvider] NVARCHAR(250) NOT NULL,
			[ProviderKey] NVARCHAR(250) NOT NULL,
			[UserId] INT NOT NULL,
			[LoggedInDateUtc] DATETIME NOT NULL,
			[LocationCoordinates] NVARCHAR(1000) NULL,
							
			CONSTRAINT [PK_LoginHistory] PRIMARY KEY ([Id]),
			CONSTRAINT [FK_LoginHistory_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users]([Id]),
		);
		PRINT 'Created table dbo.LoginHistory';

		-- Claims table

		CREATE TABLE [dbo].[UserClaims]
		(	
			[Id] INT IDENTITY(1,1) NOT NULL,
			[UserId] INT NOT NULL,
			[ClaimType] NVARCHAR(MAX) NULL,
			[ClaimValue] NVARCHAR(MAX) NULL, 
							
			CONSTRAINT [PK_UserClaims] PRIMARY KEY ([Id]),
			CONSTRAINT [FK_UserClaims_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users]([Id])
		);
		PRINT 'Created table dbo.UserClaims';

SET @CURRENT_SCHEMA_VERSION = 1;

END

-- ManageAuthProviders
-- ManageRoles
-- ManageTwoFactor
-- ManageUsers
-- ResetPasswords
-- ViewUsers
-- ViewReports
-- ViewRoles
