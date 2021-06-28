create table [History].[OrderDetail] (
    [OrderDetailId]             uniqueidentifier    not null,
    [OrderId]                   uniqueidentifier    not null,
    [ProductId]                 uniqueidentifier    not null,
    [ProductPriceWhenAdded]     money               not null,
    [ProductVATWhenAdded]       numeric(7, 4)       not null,
    [Quantity]                  integer             not null,

    [_validFrom]                datetime2(7)        not null,
    [_validTo]                  datetime2(7)        not null
) with (data_compression = page);
go
