create procedure [ProcessingOutbound].[Main_Export]
as
begin
    set xact_abort, nocount on;
    set transaction isolation level serializable;

    begin transaction;
    begin try
        execute [ProcessingOutbound].[Order_Export];
        execute [ProcessingOutbound].[OrderDetail_Export];

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
