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
            [OO].[EmployeeId] = [OD].[EmployeeId],
            [OO].[EmployeeFirstName] = [OE].[FirstName],
            [OO].[EmployeeMiddleName] = [OE].[MiddleName],
            [OO].[EmployeeLastName] = [OE].[LastName],
            [OO].[CustomerId] = [OC].[CustomerId],
            [OO].[CustomerFirstName] = [OC].[FirstName],
            [OO].[CustomerMiddleName] = [OC].[MiddleName],
            [OO].[CustomerLastName] = [OC].[LastName],
            [OO].[CustomerEmail] = [OC].[Email],
            [OO].[OrderDate] = [OD].[OrderDate],
            [OO].[_lastUpdate] = sysutcdatetime()
        from [Outbound].[Order] as [OO]
            inner join [OrderExtended] as [DO]
                on [OO].[OrderId] = [DO].[OrderId]
                    and [OO].[_lastUpdate] <= [DO].[_validFrom];

        update [OO]
        set [OO].[EmployeeFirstName] = [OE].[FirstName],
            [OO].[EmployeeMiddleName] = [OE].[MiddleName],
            [OO].[EmployeeLastName] = [OE].[LastName],
            [OO].[_lastUpdate] = sysutcdatetime()
        from [Outbound].[Order] as [OO]
            inner join [Data].[Employee] as [DE]
                on [OO].[EmployeeId] = [DE].[EmployeeId]
                    and [OO].[_lastUpdate] <= [DE].[_validFrom];

        update [OO]
        set [OO].[CustomerFirstName] = [OC].[FirstName],
            [OO].[CustomerMiddleName] = [OC].[MiddleName],
            [OO].[CustomerLastName] = [OC].[LastName],
            [OO].[CustomerEmail] = [OC].[Email],
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
