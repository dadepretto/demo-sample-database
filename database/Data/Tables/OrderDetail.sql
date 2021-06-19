create table [Data].[OrderDetail] (
    [OrderDetailId]         uniqueidentifier    not null
        constraint [DF_OrderDetail_OrderDetailId] default (newid()),
    [ProductId]             uniqueidentifier    not null,
    [ProductPriceWhenAdded] money               not null,
    [ProductVATWhenAdded]   integer             not null,
    [Quantity]              integer             not null,

    [_validFrom] datetime2(7) generated always as row start hidden not null,
    [_validTo] datetime2(7) generated always as row end hidden not null,
    period for system_time ([_validFrom], [_validTo]),

    constraint [PK_OrderDetail]
        primary key clustered ([OrderDetailId]),
    constraint [FK_OrderDetail_Product]
        foreign key ([ProductId])
            references [Data].[Product]([ProductId])
) with (
    data_compression = page,
    system_versioning = on (history_table = [History].[OrderDetail])
);
go
