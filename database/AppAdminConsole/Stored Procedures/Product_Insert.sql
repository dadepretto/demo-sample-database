create procedure [AppAdminConsole].[Product_Insert](
    @ProductId uniqueidentifier = null output,
    @Code nvarchar(32),
    @Name nvarchar(64),
    @Description nvarchar(max) = null,
    @Price money,
    @VAT numeric(7, 4)
)
as
begin
    set xact_abort, nocount on;
    set transaction isolation level serializable;

    begin transaction;
    begin try
        if @ProductId is null
        begin
            set @ProductId = newid();
        end;

        insert into [Data].[Product] (
            [ProductId],
            [Code],
            [Name],
            [Description],
            [Price],
            [VAT]
        )
        output
            [inserted].[ProductId]              as [ProductId],
            [inserted].[Code]                   as [Code],
            [inserted].[Name]                   as [Name],
            [inserted].[Description]            as [Description],
            [inserted].[Price]                  as [Price],
            [inserted].[VAT]                    as [VAT]
        values (
            @ProductId,
            @Code,
            @Name,
            @Description,
            @Price,
            @Description
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
