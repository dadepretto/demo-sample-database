create procedure [AppAdminConsole].[Employee_Get](
    @EmployeeId uniqueidentifier
)
as
begin
    set xact_abort, nocount on;
    set transaction isolation level serializable;

    begin transaction;
    begin try
        select
            [E].[EmployeeId]                    as [EmployeeId],
            [E].[FirstName]                     as [FirstName],
            [E].[MiddleName]                    as [MiddleName],
            [E].[LastName]                      as [LastName],
            [E].[Email]                         as [Email],
            [E].[HiringDate]                    as [HiringDate]
        from [Data].[Employee] as [E]
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
