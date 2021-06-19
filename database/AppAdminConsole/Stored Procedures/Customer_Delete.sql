create procedure [AppAdminConsole].[Customer_Delete](
    @CustomerId uniqueidentifier
)
as
begin
    set xact_abort, nocount on;
    set transaction isolation level serializable;

    begin transaction;
    begin try
        delete from [Data].[Customer]
        output
            [deleted].[CustomerId]              as [CustomerId],
            [deleted].[FirstName]               as [FirstName],
            [deleted].[MiddleName]              as [MiddleName],
            [deleted].[LastName]                as [LastName],
            [deleted].[Email]                   as [Email],
            [deleted].[Phone]                   as [Phone]
        where [CustomerId] = @CustomerId;

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
