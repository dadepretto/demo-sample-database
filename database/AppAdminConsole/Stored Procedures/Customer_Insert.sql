create procedure [AppAdminConsole].[Customer_Insert](
    @CustomerId uniqueidentifier = null output,
    @FirstName nvarchar(64),
    @MiddleName nvarchar(64) = null,
    @LastName nvarchar(64) = null,
    @Email nvarchar(512) = null,
    @Phone nvarchar(32) = null
)
as
begin
    set xact_abort, nocount on;
    set transaction isolation level serializable;

    begin transaction;
    begin try
        if @CustomerId is null
        begin
            set @CustomerId = newid();
        end;
        
        insert into [Data].[Customer] (
            [CustomerId],
            [FirstName],
            [MiddleName],
            [LastName],
            [Email],
            [Phone]
        )
        output
            [inserted].[CustomerId]             as [CustomerId],
            [inserted].[FirstName]              as [FirstName],
            [inserted].[MiddleName]             as [MiddleName],
            [inserted].[LastName]               as [LastName],
            [inserted].[Email]                  as [Email],
            [inserted].[Phone]                  as [Phone]
        values (
            @CustomerId,
            @FirstName,
            @MiddleName,
            @LastName,
            @Email,
            @Phone
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
