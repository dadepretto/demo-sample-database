create table [History].[Employee] (
    [EmployeeId]        uniqueidentifier    not null,
    [FirstName]         nvarchar(64)        not null,
    [MiddleName]        nvarchar(64)        null,
    [LastName]          nvarchar(64)        null,
    [Email]             nvarchar(512)       not null,
    [HiringDate]        date                not null,

    [_active]           bit                 not null,
    [_validFrom]        datetime2(7)        not null,
    [_validTo]          datetime2(7)        not null
) with (
    data_compression = page
);
go
