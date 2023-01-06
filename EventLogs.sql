-- Event log table

CREATE TABLE dbo.EventLogs
(
    Id INT IDENTITY(1,1) NOT NULL,
    [Level] NVARCHAR(10) NOT NULL,
    EventType NVARCHAR(50) NOT NULL,	 
    CorrelationId UNIQUEIDENTIFIER NOT NULL,
    [Message] NVARCHAR(MAX) NOT NULL,
    Source NVARCHAR(500) NOT NULL,
    StackTrace NVARCHAR(MAX) NULL,
    RequestUrl NVARCHAR(1000) NULL,
    [Application] NVARCHAR(50) NOT NULL,
    Browser NVARCHAR(50) NULL, 
    Platform NVARCHAR(50) NULL, 
    SourceIpAddress NVARCHAR(15) NULL,
    IsAuthenticated BIT NOT NULL CONSTRAINT [DF_EventLogs_IsAuthenticated] DEFAULT (0),
    LoggedAt DATETIME NOT NULL,

    CONSTRAINT [PK_EventLogs] PRIMARY KEY (Id),
    CONSTRAINT [FK_EventLogs_CreatedById] FOREIGN KEY (CreatedById) REFERENCES dbo.Users(Id)
);
PRINT 'Created table dbo.EventLogs';

-- Field history table

CREATE TABLE dbo.FieldHistory
(	
    Id INT IDENTITY(1,1) NOT NULL,
    EntityId INT NOT NULL,
    EventLogId INT NOT NULL,
    FieldName NVARCHAR(50) NOT NULL,
    OriginalValue NVARCHAR(1000) NOT NULL,
    NewValue NVARCHAR(1000) NOT NULL,	
                    
    CONSTRAINT [PK_FieldHistory] PRIMARY KEY (Id),
    CONSTRAINT [FK_FieldHistory_EntityId] FOREIGN KEY (EntityId) REFERENCES dbo.Entities(Id),
    CONSTRAINT [FK_FieldHistory_EventLogId] FOREIGN KEY (LogId) REFERENCES dbo.EventLogs(Id)
);
PRINT 'Created table dbo.FieldHistory';