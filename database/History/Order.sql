create table [History].[Order] (
    [OrderId]           uniqueidentifier    not null,
    [EmployeeId]        uniqueidentifier    null,
    [CustomerId]        uniqueidentifier    not null,
    [OrderDate]         datetime2(0)        not null,

    [_active]           bit                 not null,
    [_validFrom]        datetime2(7)        not null,
    [_validTo]          datetime2(7)        not null
) with (
    data_compression = page
);
go
