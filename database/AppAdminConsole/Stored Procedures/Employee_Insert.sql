create procedure [AppAdminConsole].[Employee_Insert](
    @EmployeeId uniqueidentifier = null output,
    @FirstName nvarchar(64),
    @MiddleName nvarchar(64) = null,
    @LastName nvarchar(64) = null,
    @Email nvarchar(512),
    @HiringDate date
)
as
begin
    set xact_abort, nocount on;
    set transaction isolation level serializable;

    begin transaction;
    begin try
        if @EmployeeId is  null
        begin
            set @EmployeeId = newid();
        end;

        insert into [Data].[Employee] (
            [EmployeeId],
            [FirstName],
            [MiddleName],
            [LastName],
            [Email],
            [HiringDate]
        )
        output
            [inserted].[EmployeeId]             as [EmployeeId],
            [inserted].[FirstName]              as [FirstName],
            [inserted].[MiddleName]             as [MiddleName],
            [inserted].[LastName]               as [LastName],
            [inserted].[Email]                  as [Email],
            [inserted].[HiringDate]             as [HiringDate]
        values (
            @EmployeeId,
            @FirstName,
            @LastName,
            @MiddleName,
            @Email,
            @HiringDate
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
