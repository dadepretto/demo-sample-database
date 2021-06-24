create procedure [AppCustomerPortal].[OrderDetail_Insert](
    @OrderDetailId uniqueidentifier = null output,
    @OrderId uniqueidentifier,
    @ProductId uniqueidentifier,
    @Quantity integer,
    @CustomerId uniqueidentifier
)
as
begin
    set xact_abort, nocount on;
    set transaction isolation level serializable;

    begin transaction;
    begin try
        if @OrderDetailId is null
        begin
            set @OrderDetailId = newid();
        end;

        with
            [Order] as (
                select *
                from [Data].[Order]
                where [OrderId] = @OrderId
                    and [CustomerId] = @CustomerId
            ),
            [Product] as (
                select *
                from [Data].[Product]
                where [ProductId] = @ProductId
            )
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
        select
            @OrderDetailId,
            [O].[OrderId],
            [P].[ProductId],
            [P].[Price],
            [P].[VAT],
            @Quantity
        from [Order] as [O]
            cross join [Product] as [P];

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
