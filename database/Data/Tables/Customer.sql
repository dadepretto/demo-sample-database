create table [Data].[Customer] (
    [CustomerId]        uniqueidentifier    not null
        constraint [DF_Customer_CustomerId] default (newid()),
    [FirstName]         nvarchar(64)        not null,
    [MiddleName]        nvarchar(64)        null,
    [LastName]          nvarchar(64)        null,
    [Email]             nvarchar(512)       null,
    [Phone]             nvarchar(32)        null,

    [_active]           bit                 not null
        constraint [DF_Customer__active] default (1),
    [_validFrom] datetime2(7) generated always as row start hidden not null,
    [_validTo] datetime2(7) generated always as row end hidden not null,
    period for system_time ([_validFrom], [_validTo]),

    constraint [PK_Customer]
        primary key clustered ([CustomerId])
) with (
    data_compression = page,
    system_versioning = on (history_table = [History].[Customer])
);
go
