create procedure [AppAdminConsole].[OrderDetail_Update](
    @OrderDetailId uniqueidentifier,
    @OrderId uniqueidentifier = null,
    @UpdateOrderId bit = 0,
    @ProductId uniqueidentifier = null,
    @UpdateProductId bit = 0,
    @ProductPriceWhenAdded money = null,
    @UpdateProductPriceWhenAdded bit = 0,
    @ProductVATWhenAdded numeric(7, 4) = null,
    @UpdateProductVATWhenAdded bit = 0,
    @Quantity integer = null,
    @UpdateQuantity bit = 0
)
as
begin
    set xact_abort, nocount on;
    set transaction isolation level serializable;

    begin transaction;
    begin try
        update [Data].[OrderDetail]
        set
            [OrderId] = case @UpdateOrderId
                when 1 then @OrderId
                else [OrderId]
            end,
            [ProductId] = case @UpdateProductId
                when 1 then @ProductId
                else [ProductId]
            end,
            [ProductPriceWhenAdded] = case @UpdateProductPriceWhenAdded
                when 1 then @ProductPriceWhenAdded
                else [ProductPriceWhenAdded]
            end,
            [ProductVATWhenAdded] = case @UpdateProductVATWhenAdded
                when 1 then @ProductVATWhenAdded
                else [ProductVATWhenAdded]
            end,
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
