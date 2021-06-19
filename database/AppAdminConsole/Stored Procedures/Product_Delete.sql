create procedure [AppAdminConsole].[Product_Delete](
    @ProductId uniqueidentifier
)
as
begin
    set xact_abort, nocount on;
    set transaction isolation level serializable;

    begin transaction;
    begin try
        delete from [Data].[Product]
        output
            [deleted].[ProductId]               as [ProductId],
            [deleted].[Code]                    as [Code],
            [deleted].[Name]                    as [Name],
            [deleted].[Description]             as [Description],
            [deleted].[Price]                   as [Price],
            [deleted].[VAT]                     as [VAT]
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
