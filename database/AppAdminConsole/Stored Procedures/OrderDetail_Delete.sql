create procedure [AppAdminConsole].[OrderDetail_Delete](
    @OrderDetailId uniqueidentifier
)
as
begin
    set xact_abort, nocount on;
    set transaction isolation level serializable;

    begin transaction;
    begin try
        delete from [Data].[OrderDetail]
        output
            [deleted].[OrderDetailId]           as [OrderDetailId],
            [deleted].[OrderId]                 as [OrderId],
            [deleted].[ProductId]               as [ProductId],
            [deleted].[ProductPriceWhenAdded]   as [ProductPriceWhenAdded],
            [deleted].[ProductVATWhenAdded]     as [ProductVATWhenAdded],
            [deleted].[Quantity]                as [Quantity]
        where [OrderDetailId] = @OrderDetailId;

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
