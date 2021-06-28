create table [Outbound].[Order] (
    [OrderId]                   uniqueidentifier    not null
        constraint [DF_Order_OrderId] default (newid()),
    [EmployeeId]                uniqueidentifier    null,
    [EmployeeFirstName]         nvarchar(64)        null,
    [EmployeeMiddleName]        nvarchar(64)        null,
    [EmployeeLastName]          nvarchar(64)        null,
    [CustomerId]                uniqueidentifier    null,
    [CustomerFirstName]         nvarchar(64)        null,
    [CustomerMiddleName]        nvarchar(64)        null,
    [CustomerLastName]          nvarchar(64)        null,
    [CustomerEmail]             nvarchar(512)       null,
    [OrderDate]                 datetime2(0)        not null
        constraint [DF_Order_OrderDate] default (sysutcdatetime()),

    [_lastUpdate]               datetime2(0)        not null
        constraint [DF_Order__lastUpdate] default (sysutcdatetime()),

    constraint [PK_Order]
        primary key clustered ([OrderId])
) with (data_compression = page);
go
