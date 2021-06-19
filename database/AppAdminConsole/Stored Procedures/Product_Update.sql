create procedure [AppAdminConsole].[Product_Update](
    @ProductId uniqueidentifier,
    @Code nvarchar(32) = null,
    @UpdateCode bit = 0,
    @Name nvarchar(64) = null,
    @UpdateName bit = 0,
    @Description nvarchar(max) = null,
    @UpdateDescription bit = 0,
    @Price money = null,
    @UpdatePrice bit = 0,
    @VAT numeric(7, 4) = null,
    @UpdateVAT bit = 0
)
as
begin
    set xact_abort, nocount on;
    set transaction isolation level serializable;

    begin transaction;
    begin try
        update [Data].[Product]
        set
            [Code] = case @UpdateCode
                when 1 then @Code
                else [Code]
            end,
            [Name] = case @UpdateName
                when 1 then @Name
                else [Name]
            end,
            [Description] = case @UpdateDescription
                when 1 then @Description
                else [Description]
            end,
            [Price] = case @UpdatePrice
                when 1 then @Price
                else [Price]
            end,
            [VAT] = case @UpdateVAT
                when 1 then @VAT
                else [VAT]
            end
        output
            [inserted].[ProductId]              as [ProductId],
            [inserted].[Code]                   as [Code],
            [inserted].[Name]                   as [Name],
            [inserted].[Description]            as [Description],
            [inserted].[Price]                  as [Price],
            [inserted].[VAT]                    as [VAT]
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
