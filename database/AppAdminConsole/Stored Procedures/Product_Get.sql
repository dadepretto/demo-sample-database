create procedure [AppAdminConsole].[Product_Get](
    @ProductId uniqueidentifier
)
as
begin
    set xact_abort, nocount on;
    set transaction isolation level serializable;

    begin transaction;
    begin try
        select
            [ProductId]                         as [ProductId],
            [Code]                              as [Code],
            [Name]                              as [Name],
            [Description]                       as [Description],
            [Price]                             as [Price],
            [VAT]                               as [VAT]
        from [Data].[Product]
        where [ProductId] = @ProductId;

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
