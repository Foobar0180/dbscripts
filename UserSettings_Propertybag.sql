-- CREATE TABLE [dbo].[UserSettings]
-- (	
--     [Id] INT IDENTITY(1,1) NOT NULL,
--     [UserId] INT NOT NULL,
--     [Collection] INT NULL,
--     [Key] INT NOT NULL,
--     [Value] INT NOT NULL,
                    
--     CONSTRAINT [PK_UserSettings] PRIMARY KEY ([Id]),
--     CONSTRAINT [FK_UserSettings_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users](Id)
-- );

CREATE TABLE [dbo].[SettingsGroup]
(	
    [Id] INT IDENTITY(1,1) NOT NULL,
    [Name] NVARCHAR(250) NOT NULL,
                    
    CONSTRAINT [PK_SettingsGroup] PRIMARY KEY ([Id])
);

CREATE TABLE [dbo].[Settings]
(	
    [Id] INT IDENTITY(1,1) NOT NULL,
    [SettingsGroupId] INT NULL,
    [Description] NVARCHAR(250) NOT NULL,
    [IsConstrained] BIT NOT NULL CONSTRAINT [DF_Settings_IsConstrained] DEFAULT (0),
    [DataType] INT NOT NULL,
    [MinValue] NVARCHAR(10) NULL,
    [MaxValue] NVARCHAR(10) NULL,
                    
    CONSTRAINT [PK_Settings] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_Settings_SettingsGroupId] FOREIGN KEY ([SettingsGroupId]) REFERENCES [dbo].[SettingsGroup](Id)
);

CREATE TABLE [dbo].[AllowedSettingsValues]
(	
    [Id] INT IDENTITY(1,1) NOT NULL,
    [SettingsId] INT NOT NULL,
    [ItemValue] NVARCHAR(10) NOT NULL,
    [Caption] NVARCHAR(50) NOT NULL,
                    
    CONSTRAINT [PK_AllowedSettingsValues] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_AllowedSettingsValues_SettingsId] FOREIGN KEY ([SettingsId]) REFERENCES [dbo].[Settings](Id)
);

CREATE TABLE [dbo].[UserSettings]
(	
    [Id] INT IDENTITY(1,1) NOT NULL,
    [UserId] INT NOT NULL,
    [SettingsId] INT NOT NULL,
    [AllowedSettingsValuesId] INT NOT NULL,
    [UnconstrainedValue] NVARCHAR(10) NULL,
                    
    CONSTRAINT [PK_UserSettings] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_UserSettings_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[Users](Id),
    CONSTRAINT [FK_UserSettings_SettingsId] FOREIGN KEY ([SettingsId]) REFERENCES [dbo].[Settings](Id),
    CONSTRAINT [FK_UserSettings_AllowedSettingsValuesId] FOREIGN KEY ([AllowedSettingsValuesId]) REFERENCES [dbo].[AllowedSettingsValues](Id)
);