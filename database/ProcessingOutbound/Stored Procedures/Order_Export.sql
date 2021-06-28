create procedure [ProcessingOutbound].[Order_Export]
as
declare
    @lastExport datetime2(0)
begin
    set xact_abort, nocount on;
    set transaction isolation level serializable;

    begin transaction;
    begin try
        set @lastExport = (
            select max([_lastUpdate])
            from [Outbound].[Order]
        );

        insert into [Outbound].[Order] (
            [OrderId],
            [EmployeeId],
            [EmployeeFirstName],
            [EmployeeMiddleName],
            [EmployeeLastName],
            [CustomerId],
            [CustomerFirstName],
            [CustomerMiddleName],
            [CustomerLastName],
            [CustomerEmail],
            [OrderDate],
            [_lastUpdate]
        )
        select
            [DO].[OrderId]                      as [OrderId],
            [DO].[EmployeeId]                   as [EmployeeId],
            [DE].[FirstName]                    as [EmployeeFirstName],
            [DE].[MiddleName]                   as [EmployeeMiddleName],
            [DE].[LastName]                     as [EmployeeLastName],
            [DO].[CustomerId]                   as [CustomerId],
            [DC].[FirstName]                    as [CustomerFirstName],
            [DC].[MiddleName]                   as [CustomerMiddleName],
            [DC].[LastName]                     as [CustomerLastName],
            [DC].[Email]                        as [CustomerEmail],
            [DO].[OrderDate]                    as [OrderDate],
            sysutcdatetime()                    as [_lastUpdate]
        from [Data].[Order] as [DO]
            left join [Data].[Employee] as [DE]
                on [DO].[EmployeeId] = [DE].[EmployeeId]
            left join [Data].[Customer] as [DC]
                on [DO].[CustomerId] = [DC].[CustomerId]
        where not exists (
            select *
            from [Outbound].[Order] as [OO]
            where [OO].[OrderId] = [DO].[OrderId]
        );

        with
            [OrderExtended] as (
                select
                    [DO].[OrderId]              as [OrderId],
                    [DO].[EmployeeId]           as [EmployeeId],
                    [DE].[FirstName]            as [EmployeeFirstName],
                    [DE].[MiddleName]           as [EmployeeMiddleName],
                    [DE].[LastName]             as [EmployeeLastName],
                    [DO].[CustomerId]           as [CustomerId],
                    [DC].[FirstName]            as [CustomerFirstName],
                    [DC].[MiddleName]           as [CustomerMiddleName],
                    [DC].[LastName]             as [CustomerLastName],
                    [DC].[Email]                as [CustomerEmail],
                    [DO].[OrderDate]            as [OrderDate],
                    [DO].[_validFrom]           as [_validFrom]
                from [Data].[Order] as [DO]
                    left join [Data].[Employee] as [DE]
                        on [DO].[EmployeeId] = [DE].[EmployeeId]
                    left join [Data].[Customer] as [DC]
                        on [DO].[CustomerId] = [DC].[CustomerId]    
            )
        update [OO]
        set [OO].[OrderId] = [DO].[OrderId],
            [OO].[EmployeeId] = [DO].[EmployeeId],
            [OO].[EmployeeFirstName] = [DO].[EmployeeFirstName],
            [OO].[EmployeeMiddleName] = [DO].[EmployeeMiddleName],
            [OO].[EmployeeLastName] = [DO].[EmployeeLastName],
            [OO].[CustomerId] = [DO].[CustomerId],
            [OO].[CustomerFirstName] = [DO].[CustomerFirstName],
            [OO].[CustomerMiddleName] = [DO].[CustomerMiddleName],
            [OO].[CustomerLastName] = [DO].[CustomerLastName],
            [OO].[CustomerEmail] = [DO].[CustomerEmail],
            [OO].[OrderDate] = [DO].[OrderDate],
            [OO].[_lastUpdate] = sysutcdatetime()
        from [Outbound].[Order] as [OO]
            inner join [OrderExtended] as [DO]
                on [OO].[OrderId] = [DO].[OrderId]
                    and [OO].[_lastUpdate] <= [DO].[_validFrom];

        update [OO]
        set [OO].[EmployeeFirstName] = [DE].[FirstName],
            [OO].[EmployeeMiddleName] = [DE].[MiddleName],
            [OO].[EmployeeLastName] = [DE].[LastName],
            [OO].[_lastUpdate] = sysutcdatetime()
        from [Outbound].[Order] as [OO]
            inner join [Data].[Employee] as [DE]
                on [OO].[EmployeeId] = [DE].[EmployeeId]
                    and [OO].[_lastUpdate] <= [DE].[_validFrom];

        update [OO]
        set [OO].[CustomerFirstName] = [DC].[FirstName],
            [OO].[CustomerMiddleName] = [DC].[MiddleName],
            [OO].[CustomerLastName] = [DC].[LastName],
            [OO].[CustomerEmail] = [DC].[Email],
            [OO].[_lastUpdate] = sysutcdatetime()
        from [Outbound].[Order] as [OO]
            inner join [Data].[Customer] as [DC]
                on [OO].[CustomerId] = [DC].[CustomerId]
                    and [OO].[_lastUpdate] <= [DC].[_validFrom];

        delete from [Outbound].[Order]
        where [OrderId] not in (
            select [OrderId]
            from [Data].[Order]
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
