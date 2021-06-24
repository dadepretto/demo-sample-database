create procedure [AppCustomerPortal].[Order_List](
    @CustomerId uniqueidentifier
)
as
begin
    set xact_abort, nocount on;
    set transaction isolation level serializable;

    begin transaction;
    begin try
        select
            [O].[OrderId]                       as [OrderId],
            [O].[EmployeeId]                    as [EmployeeId],
            [E].[FirstName]                     as [EmployeeFirstName],
            [E].[MiddleName]                    as [EmployeeMiddleName],
            [E].[LastName]                      as [EmployeeLastName],
            [O].[CustomerId]                    as [CustomerId],
            [C].[FirstName]                     as [CustomerFirstName],
            [C].[MiddleName]                    as [CustomerMiddleName],
            [C].[LastName]                      as [CustomerLastName],
            [O].[OrderDate]                     as [OrderDate]
        from [Data].[Order] as [O]
            left join [Data].[Employee] as [E]
                on [O].[EmployeeId] = [E].[EmployeeId]
            left join [Data].[Customer] as [C]
                on [O].[CustomerId] = [C].[CustomerId]
        where [O].[CustomerId] = @CustomerId;

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
