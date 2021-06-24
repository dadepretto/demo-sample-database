create procedure [AppCustomerPortal].[OrderDetail_List] (
    @CustomerId uniqueidentifier
)
as
begin
    set xact_abort, nocount on;
    set transaction isolation level serializable;

    begin transaction;
    begin try
        select
            [OD].[OrderDetailId]                as [OrderDetailId],
            [OD].[ProductId]                    as [ProductId],
            [P].[Code]                          as [ProductCode],
            [P].[Name]                          as [ProductName],
            [P].[Description]                   as [ProductDescription],
            [P].[Price]                         as [ProductPriceCurrent],
            [P].[VAT]                           as [ProductVATCurrent],
            [OD].[ProductPriceWhenAdded]        as [ProductPriceWhenAdded],
            [OD].[ProductVATWhenAdded]          as [VAT],
            [OD].[Quantity]                     as [Quantity]
        from [Data].[OrderDetail] as [OD]
            inner join [Data].[Product] as [P]
                on [OD].[ProductId] = [P].[ProductId]
            inner join [Data].[Order] as [O]
                on [OD].[OrderId] = [O].[OrderId]
        where [O].[CustomerId] = @CustomerId;

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
