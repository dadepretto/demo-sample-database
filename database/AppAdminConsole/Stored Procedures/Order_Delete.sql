create procedure [AppAdminConsole].[Order_Delete](
    @OrderId uniqueidentifier
)
as
begin
    set xact_abort, nocount on;
    set transaction isolation level serializable;

    begin transaction;
    begin try
        delete from [Data].[Order]
        output
            [deleted].[OrderId]                 as [OrderId],
            [deleted].[EmployeeId]              as [EmployeeId],
            [deleted].[CustomerId]              as [CustomerId],
            [deleted].[OrderDate]               as [OrderDate]
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
