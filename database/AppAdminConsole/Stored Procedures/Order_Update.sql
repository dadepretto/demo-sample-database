create procedure [AppAdminConsole].[Order_Update](
    @OrderId uniqueidentifier,
    @EmployeeId uniqueidentifier = null,
    @UpdateEmployeeId bit = 0,
    @CustomerId uniqueidentifier = null,
    @UpdateCustomerId bit = 0,
    @OrderDate datetime2(0) = null,
    @UpdateOrderDate bit = 0
)
as
begin
    set xact_abort, nocount on;
    set transaction isolation level serializable;

    begin transaction;
    begin try
        update [Data].[Order]
        set
            [EmployeeId] = case @UpdateEmployeeId
                when 1 then @EmployeeId
                else [EmployeeId]
            end,
            [CustomerId] = case @UpdateCustomerId
                when 1 then @CustomerId
                else [CustomerId]
            end,
            [OrderDate] = case @UpdateOrderDate
                when 1 then @OrderDate
                else [OrderDate]
            end
        output
            [inserted].[OrderId]                as [OrderId],
            [inserted].[EmployeeId]             as [EmployeeId],
            [inserted].[CustomerId]             as [CustomerId],
            [inserted].[OrderDate]              as [OrderDate]
        where [OrderId] = @OrderId;

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
