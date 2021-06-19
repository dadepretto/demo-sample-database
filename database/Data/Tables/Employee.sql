create table [Data].[Employee] (
    [EmployeeId]            uniqueidentifier    not null
        constraint [DF_Employee_EmployeeId] default (newid()),
    [FirstName]             nvarchar(64)        not null,
    [MiddleName]            nvarchar(64)        null,
    [LastName]              nvarchar(64)        null,
    [Email]                 nvarchar(512)       not null,
    [HiringDate]            date                not null,

    [_active]               bit                 not null
        constraint [DF_Employee__active] default (1),
    [_validFrom] datetime2(7) generated always as row start hidden not null,
    [_validTo] datetime2(7) generated always as row end hidden not null,
    period for system_time ([_validFrom], [_validTo]),

    constraint [PK_Employee]
        primary key clustered ([EmployeeId])
) with (
    data_compression = page,
    system_versioning = on (history_table = [History].[Employee])
);
go
