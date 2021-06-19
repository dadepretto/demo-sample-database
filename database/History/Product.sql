create table [History].[Product] (
    [ProductId]         uniqueidentifier    not null,
    [Code]              nvarchar(32)        not null,
    [Name]              nvarchar(64)        not null,
    [Description]       nvarchar(max)       null,
    [Price]             money               not null,
    [VAT]               integer             not null,

    [_active]           bit                 not null,
    [_validFrom]        datetime2(7)        not null,
    [_validTo]          datetime2(7)        not null
) with (
    data_compression = page
);
go
