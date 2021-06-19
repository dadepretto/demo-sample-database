create procedure [AppAdminConsole].[Customer_Update](
    @CustomerId uniqueidentifier,
    @FirstName nvarchar(64) = null,
    @UpdateFirstName bit = 0,
    @MiddleName nvarchar(64) = null,
    @UpdateMiddleName bit = 0,
    @LastName nvarchar(64) = null,
    @UpdateLastName bit = 0,
    @Email nvarchar(512) = null,
    @UpdateEmail bit = 0,
    @Phone nvarchar(32) = null,
    @UpdatePhone bit = 0
)
as
begin
    set xact_abort, nocount on;
    set transaction isolation level serializable;

    begin transaction;
    begin try
        update [Data].[Customer]
        set
            [FirstName] = case @UpdateFirstName
                when 1 then @FirstName
                else [FirstName]
            end,
            [MiddleName] = case @UpdateMiddleName
                when 1 then @MiddleName
                else [MiddleName]
            end,
            [LastName] = case @UpdateLastName
                when 1 then @LastName
                else [LastName]
            end,
            [Email] = case @UpdateEmail
                when 1 then @Email
                else [Email]
            end,
            [Phone] = case @UpdatePhone
                when 1 then @Phone
                else [Phone]
            end
        output
            [inserted].[CustomerId]             as [CustomerId],
            [inserted].[FirstName]              as [FirstName],
            [inserted].[MiddleName]             as [MiddleName],
            [inserted].[LastName]               as [LastName],
            [inserted].[Email]                  as [Email],
            [inserted].[Phone]                  as [Phone]
        where [CustomerId] = @CustomerId;

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
