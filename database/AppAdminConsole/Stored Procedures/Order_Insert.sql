create procedure [AppAdminConsole].[Order_Insert](
    @OrderId uniqueidentifier = null output,
    @EmployeeId uniqueidentifier = null,
    @CustomerId uniqueidentifier = null,
    @OrderDate datetime2(0) = null output
)
as
begin
    set xact_abort, nocount on;
    set transaction isolation level serializable;

    begin transaction;
    begin try
        if @OrderId is null
        begin
            set @OrderId = newid();
        end;

        if @OrderDate is null
        begin
            set @OrderDate = sysutcdatetime();
        end;
    
        insert into [Data].[Order] (
            [OrderId],
            [EmployeeId],
            [CustomerId],
            [OrderDate]
        )
        output
            [inserted].[OrderId]                as [OrderId],
            [inserted].[EmployeeId]             as [EmployeeId],
            [inserted].[CustomerId]             as [CustomerId],
            [inserted].[OrderDate]              as [OrderDate]
        values (
            @OrderId,
            @EmployeeId,
            @CustomerId,
            @OrderDate
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
