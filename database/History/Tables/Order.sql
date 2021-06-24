create table [History].[Order] (
    [OrderId]               uniqueidentifier    not null,
    [EmployeeId]            uniqueidentifier    null,
    [CustomerId]            uniqueidentifier    null,
    [OrderDate]             datetime2(0)        not null,

    [_validFrom]            datetime2(7)        not null,
    [_validTo]              datetime2(7)        not null
) with (
    data_compression = page
);
go
