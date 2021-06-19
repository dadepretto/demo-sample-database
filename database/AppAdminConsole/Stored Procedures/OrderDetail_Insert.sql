create procedure [AppAdminConsole].[OrderDetail_Insert](
    @OrderDetailId uniqueidentifier = null output,
    @OrderId uniqueidentifier,
    @ProductId uniqueidentifier,
    @ProductPriceWhenAdded money = null output,
    @ProductVATWhenAdded numeric(7, 4) = null output,
    @Quantity integer
)
as
begin
    set xact_abort, nocount on;
    set transaction isolation level serializable;

    begin transaction;
    begin try
        if @ProductId is null
        begin
            set @OrderDetailId = newid();
        end;

        select
            @ProductPriceWhenAdded = isnull(@ProductPriceWhenAdded, [Price]),
            @ProductVATWhenAdded = isnull(@ProductVATWhenAdded, [VAT])
        from [Data].[Product]
        where [ProductId] = @ProductId;

        insert into [Data].[OrderDetail] (
            [OrderDetailId],
            [OrderId],
            [ProductId],
            [ProductPriceWhenAdded],
            [ProductVATWhenAdded],
            [Quantity]
        )
        output
            [inserted].[OrderDetailId]          as [OrderDetailId],
            [inserted].[OrderId]                as [OrderId],
            [inserted].[ProductId]              as [ProductId],
            [inserted].[ProductPriceWhenAdded]  as [ProductPriceWhenAdded],
            [inserted].[ProductVATWhenAdded]    as [ProductVATWhenAdded],
            [inserted].[Quantity]               as [Quantity]
        values (
            @OrderDetailId,
            @OrderId,
            @ProductId,
            @ProductPriceWhenAdded,
            @ProductVATWhenAdded,
            @Quantity
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
