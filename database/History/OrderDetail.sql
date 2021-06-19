create table [History].[OrderDetail] (
    [OrderDetailId]     uniqueidentifier    not null,
    [ProductId]         uniqueidentifier    not null,
    [Price]             money               not null,
    [VAT]               integer             not null,
    [Quantity]          integer             not null,

    [_active]           bit                 not null,
    [_validFrom]        datetime2(7)        not null,
    [_validTo]          datetime2(7)        not null
) with (
    data_compression = page
);
go
