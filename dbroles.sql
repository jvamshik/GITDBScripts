--Get All Users from cpg_read_only Group and delete all users from that group.
DECLARE @RoleName sysname
set @RoleName = N'cpg_read_only'
IF  EXISTS (SELECT * FROM sys.database_principals WHERE name = @RoleName AND type = 'R')
Begin
	DECLARE @RoleMemberName sysname
	DECLARE Member_Cursor CURSOR FOR
	select [name]
	from sys.database_principals 
	where principal_id in ( 
		select member_principal_id 
		from sys.database_role_members 
		where role_principal_id in (
			select principal_id
			FROM sys.database_principals where [name] = @RoleName  AND type = 'R' ))

	OPEN Member_Cursor;

	FETCH NEXT FROM Member_Cursor
	into @RoleMemberName

	WHILE @@FETCH_STATUS = 0
	BEGIN
		exec sp_droprolemember @rolename=@RoleName, @membername= @RoleMemberName
		FETCH NEXT FROM Member_Cursor
		into @RoleMemberName
	END;
	CLOSE Member_Cursor;
	DEALLOCATE Member_Cursor;
End
GO

--Delete the Role If Exists
IF  EXISTS (SELECT * FROM sys.database_principals WHERE name = N'cpg_read_only' AND type = 'R')
DROP ROLE [cpg_read_only]
GO

--Create the Role
CREATE ROLE [cpg_read_only] 
GO
-----------------------------------------------------------------------------

--Get All Users from cpg_read_only Group and delete all users from that group.
DECLARE @RoleName sysname
set @RoleName = N'cpg_read_write'
IF  EXISTS (SELECT * FROM sys.database_principals WHERE name = @RoleName AND type = 'R')
Begin
	DECLARE @RoleMemberName sysname
	DECLARE Member_Cursor CURSOR FOR
	select [name]
	from sys.database_principals 
	where principal_id in ( 
		select member_principal_id 
		from sys.database_role_members 
		where role_principal_id in (
			select principal_id
			FROM sys.database_principals where [name] = @RoleName  AND type = 'R' ))

	OPEN Member_Cursor;

	FETCH NEXT FROM Member_Cursor
	into @RoleMemberName

	WHILE @@FETCH_STATUS = 0
	BEGIN
		exec sp_droprolemember @rolename=@RoleName, @membername= @RoleMemberName
		FETCH NEXT FROM Member_Cursor
		into @RoleMemberName
	END;

	CLOSE Member_Cursor;
	DEALLOCATE Member_Cursor;
End
GO

--Delete the Role If Exists
IF  EXISTS (SELECT * FROM sys.database_principals WHERE name = N'cpg_read_write' AND type = 'R')
DROP ROLE [cpg_read_write]
GO
--Create the Role
CREATE ROLE [cpg_read_write] 
GO