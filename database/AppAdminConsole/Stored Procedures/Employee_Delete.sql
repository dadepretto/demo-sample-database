create procedure [AppAdminConsole].[Employee_Delete](
    @EmployeeId uniqueidentifier
)
as
begin
    set xact_abort, nocount on;
    set transaction isolation level serializable;

    begin transaction;
    begin try
        delete from [Data].[Employee]
        output
            [deleted].[EmployeeId]              as [EmployeeId],
            [deleted].[FirstName]               as [FirstName],
            [deleted].[MiddleName]              as [MiddleName],
            [deleted].[LastName]                as [LastName],
            [deleted].[Email]                   as [Email],
            [deleted].[HiringDate]              as [HiringDate]
        where [EmployeeId] = @EmployeeId;

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
