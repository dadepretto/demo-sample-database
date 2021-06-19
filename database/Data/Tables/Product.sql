create table [Data].[Product] (
    [ProductId]             uniqueidentifier    not null
        constraint [DF_Product_ProductId] default (newid()),
    [Code]                  nvarchar(32)        not null,
    [Name]                  nvarchar(64)        not null,
    [Description]           nvarchar(max)       null,
    [Price]                 money               not null,
    [VAT]                   integer             not null,

    [_validFrom] datetime2(7) generated always as row start hidden not null,
    [_validTo] datetime2(7) generated always as row end hidden not null,
    period for system_time ([_validFrom], [_validTo]),

    constraint [PK_Product]
        primary key clustered ([ProductId]),
    constraint [CK_Product_Price_isPositive]
        check ([Price] >= 0),
    constraint [CK_Product_VAT_isPositive]
        check ([VAT] >= 0)
) with (
    data_compression = page,
    system_versioning = on (history_table = [History].[Product])
);
go
