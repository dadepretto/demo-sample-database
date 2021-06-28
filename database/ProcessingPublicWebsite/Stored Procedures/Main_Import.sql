create procedure [ProcessingPublicWebsite].[Main_Import]
as
begin
    set xact_abort, nocount on;
    set transaction isolation level serializable;

    begin transaction;
    begin try
        execute [ProcessingPublicWebsite].[Customer_Import];

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
