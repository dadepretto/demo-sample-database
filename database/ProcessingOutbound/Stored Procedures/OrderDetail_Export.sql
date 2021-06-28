create procedure [ProcessingOutbound].[OrderDetail_Export]
as
declare
    @lastExport datetime2(0)
begin
    set xact_abort, nocount on;
    set transaction isolation level serializable;

    begin transaction;
    begin try
        set @lastExport = (
            select max([_lastUpdate])
            from [Outbound].[Order]
        );

        insert into [Outbound].[OrderDetail] (
            [OrderDetailId],
            [OrderId],
            [ProductId],
            [ProductPriceWhenAdded],
            [ProductVATWhenAdded],
            [ProductPriceWhenExported],
            [ProductVATWhenExported],
            [Quantity],
            [_lastUpdate]
        )
        select
            [DOD].[OrderDetailId]               as [OrderDetailId],
            [DOD].[OrderId]                     as [OrderId],
            [DOD].[ProductId]                   as [ProductId],
            [DOD].[ProductPriceWhenAdded]       as [ProductPriceWhenAdded],
            [DOD].[ProductVATWhenAdded]         as [ProductVATWhenAdded],
            [DP].[Price]                        as [ProductPriceWhenExported],
            [DP].[VAT]                          as [ProductVATWhenExported],
            [DOD].[Quantity]                    as [Quantity]
        from [Data].[OrderDetail] as [DOD]
            inner join [Data].[Product] as [DP]
                on [DOD].[ProductId] = [DP].[ProductId]
        where not exists (
            select *
            from [Outbound].[OrderDetail] as [OOD]
            where [OOD].[OrderDetailId] = [DOD].[OrderDetailId]
        );

        update [OOD]
        set
            [OOD].[OrderDetailId] = [DOD].[OrderDetailId],
            [OOD].[OrderId] = [DOD].[OrderId],
            [OOD].[ProductId] = [DOD].[ProductId],
            [OOD].[ProductPriceWhenAdded] = [DOD].[ProductPriceWhenAdded],
            [OOD].[ProductVATWhenAdded] = [DOD].[ProductVATWhenAdded],
            [OOD].[ProductPriceWhenExported] = [DP].[Price],
            [OOD].[ProductVATWhenExported] = [DP].[VAT],
            [OOD].[Quantity] = [DOD].[Quantity],
            [OOD].[_lastUpdate] = sysutcdatetime()
        from [Outbound].[OrderDetail] as [OOD]
            inner join [Data].[OrderDetail] as [DOD]
                on [OOD].[OrderDetailId] = [DOD].[OrderDetailId]
                    and [OOD].[_lastUpdate] <= [DOD].[_validFrom]
            inner join [Data].[Product] as [DP]
                on [DOD].[ProductId] = [DP].[ProductId];

        update [OOD]
        set [OOD].[ProductPriceWhenExported] = [DP].[Price],
            [OOD].[ProductVATWhenExported] = [DP].[VAT],
            [OOD].[_lastUpdate] = sysutcdatetime()
        from [Outbound].[OrderDetail] as [OOD]
            inner join [Data].[Product] as [DP]
                on [OOD].[EmployeeId] = [DP].[EmployeeId]
                    and [OOD].[_lastUpdate] <= [DP].[_validFrom];

        delete from [Outbound].[OrderDetail]
        where [OrderId] not in (
            select [OrderDetailId]
            from [Data].[OrderDetail]
        );

        commit transaction;
    end try
    begin catch
        if @@trancount > 0
        begin
            rollback transaction;
        end;

        throw;
    end catch
end;
go
