create procedure [ProcessingCRM].[Customer_Import]
as
begin
    set xact_abort, nocount on;
    set transaction isolation level serializable;

    begin transaction;
    begin try
        insert into [Data].[Customer] (
            [CustomerId],
            [FirstName],
            [MiddleName],
            [LastName],
            [Email],
            [Phone]   
        )
        select
            newid(),
            [FirstName],
            [MiddleName]
            [LastName],
            [Email],
            [Phone]
        from [InboundCRM].[Customer] as [IC]
        where not exists (
            select *
            from [Data].[Customer] as [DC]
            where [DC].[Email] = [IC].[Email]
        );

        update [DC]
        set [DC].[FirstName] = [IC].[FirstName],
            [DC].[MiddleName] = [IC].[MiddleName],
            [DC].[LastName] = [IC].[LastName],
            [DC].[Email] = [IC].[Email],
            [DC].[Phone] = [IC].[Phone]
        from [InboundCRM].[Customer] as [IC]
            inner join [Data].[Customer] as [DC]
                on [IC].[Email] = [DC].[Email]
                    and [IC].[_lastUpdate] >= [DC].[_validFrom];

        delete from [Data].[Customer]
        where [Email] not in (
            select [Email]
            from [InboundCRM].[Customer]
            where [Email] is not null
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
