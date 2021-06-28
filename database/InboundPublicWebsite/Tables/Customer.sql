create table [InboundPublicWebsite].[Customer] (
    [FirstName]                 nvarchar(64)        not null,
    [MiddleName]                nvarchar(64)        null,
    [LastName]                  nvarchar(64)        null,
    [Email]                     nvarchar(512)       null,
    [Phone]                     nvarchar(32)        null,

    [_lastUpdate]               datetime2(0)        not null
        constraint [DF_Customer__lastUpdate] default (sysutcdatetime()),

    constraint [PK_Customer]
        primary key clustered ([Email])
) with (data_compression = page);
go
