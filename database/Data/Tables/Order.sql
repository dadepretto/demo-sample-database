create table [Data].[Order] (
    [OrderId]               uniqueidentifier    not null
        constraint [DF_Order_OrderId] default (newid()),
    [EmployeeId]            uniqueidentifier    null,
    [CustomerId]            uniqueidentifier    null,
    [OrderDate]             datetime2(0)        not null
        constraint [DF_Order_OrderDate] default (sysutcdatetime()),

    [_active]               bit                 not null
        constraint [DF_Order__active] default (1),
    [_validFrom] datetime2(7) generated always as row start hidden not null,
    [_validTo] datetime2(7) generated always as row end hidden not null,
    period for system_time ([_validFrom], [_validTo]),

    constraint [PK_Order]
        primary key clustered ([OrderId]),
    constraint [FK_Order_Employee]
        foreign key ([EmployeeId])
            references [Data].[Employee]([EmployeeId])
                on update cascade
                on delete set null,
    constraint [FK_Order_Customer]
        foreign key ([CustomerId])
            references [Data].[Customer]([CustomerId])
                on update cascade
                on delete set null,
) with (
    data_compression = page,
    system_versioning = on (history_table = [History].[Order])
);
go
