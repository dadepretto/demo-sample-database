create table [Outbound].[OrderDetail] (
    [OrderDetailId]             uniqueidentifier    not null
        constraint [DF_OrderDetail_OrderDetailId] default (newid()),
    [OrderId]                   uniqueidentifier    not null,
    [ProductId]                 uniqueidentifier    not null,
    [ProductPriceWhenAdded]     money               not null,
    [ProductVATWhenAdded]       numeric(7, 4)       not null,
    [ProductPriceWhenExported]  money               not null,
    [ProductVATWhenExported]    numeric(7, 4)       not null,
    [Quantity]                  integer             not null,

    [_lastUpdate]               datetime2(0)        not null
        constraint [DF_OrderDetail__lastUpdate] default (sysutcdatetime()),

    constraint [PK_OrderDetail]
        primary key clustered ([OrderDetailId])
) with (data_compression = page);
go
