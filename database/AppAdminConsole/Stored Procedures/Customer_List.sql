create procedure [AppAdminConsole].[Customer_List]
as
begin
    set xact_abort, nocount on;
    set transaction isolation level serializable;

    begin transaction;
    begin try
         select
            [C].[FirstName]                     as [FirstName],
            [C].[MiddleName]                    as [MiddleName],
            [C].[LastName]                      as [LastName],
            [C].[Email]                         as [Email],
            [C].[Phone]                         as [Phone]
        from [Data].[Customer] as [C];

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
