create procedure [AppCustomerPortal].[OrderDetail_Update](
    @OrderDetailId uniqueidentifier,
    @Quantity integer = null,
    @UpdateQuantity bit = 0,
    @CustomerId uniqueidentifier
)
as
declare
    @ProductPriceWhenAdded money,
    @ProductVATWhenAdded numeric(7, 4)
begin
    set xact_abort, nocount on;
    set transaction isolation level serializable;

    begin transaction;
    begin try
        update [Data].[OrderDetail]
        set
            [Quantity] = case @UpdateQuantity
                when 1 then @Quantity
                else [Quantity]
            end
        output
            [inserted].[OrderDetailId]          as [OrderDetailId],
            [inserted].[OrderId]                as [OrderId],
            [inserted].[ProductId]              as [ProductId],
            [inserted].[ProductPriceWhenAdded]  as [ProductPriceWhenAdded],
            [inserted].[ProductVATWhenAdded]    as [ProductVATWhenAdded],
            [inserted].[Quantity]               as [Quantity]
        where [OrderDetailId] = @OrderDetailId
            and [OrderId] in (
                select [OrderId]
                from [Data].[Order] as [O]
                where [O].[CustomerId] = @CustomerId
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
