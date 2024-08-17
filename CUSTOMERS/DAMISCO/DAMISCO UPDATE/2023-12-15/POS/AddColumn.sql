if not exists (select * from syscolumns where id=object_id('TransactionDet') and name='CustomerPhone') 
	begin
		alter table TransactionDet add CustomerPhone varchar(10) NOT NULL DEFAULT ((''))
		print 'added'
	end
else
	begin
		print 'exists'
	end
go
if not exists (select * from syscolumns where id=object_id('SysConfig') and name='IsHavelockSync') 
	begin
		alter table SysConfig add IsHavelockSync bit NOT NULL DEFAULT ((0))
		print 'added'
	end
else
	begin
		print 'exists'
	end
go
if not exists (select * from syscolumns where id=object_id('HavelockSalesDataBackup') and name='TenantId') 
	begin
		alter table HavelockSalesDataBackup add TenantId varchar(15)  NULL 
		print 'added'
	end
else
	begin
		print 'exists'
	end
go

if not exists (select * from syscolumns where id=object_id('HavelockSalesDataBackup') and name='PosId') 
	begin
		alter table HavelockSalesDataBackup add PosId varchar(25)  NULL 
		print 'added'
	end
else
	begin
		print 'exists'
	end
go

if not exists (select * from syscolumns where id=object_id('HavelockSalesDataBackup') and name='StallNo') 
	begin
		alter table HavelockSalesDataBackup add StallNo varchar(4)  NULL 
		print 'added'
	end
else
	begin
		print 'exists'
	end
go
	
if not exists (select * from syscolumns where id=object_id('HavelockSalesData') and name='TenantId') 
	begin
		alter table HavelockSalesData add TenantId varchar(15)  NULL 
		print 'added'
	end
else
	begin
		print 'exists'
	end
go

if not exists (select * from syscolumns where id=object_id('HavelockSalesData') and name='PosId') 
	begin
		alter table HavelockSalesData add PosId varchar(25)  NULL 
		print 'added'
	end
else
	begin
		print 'exists'
	end
go

if not exists (select * from syscolumns where id=object_id('HavelockSalesData') and name='StallNo') 
	begin
		alter table HavelockSalesData add StallNo varchar(4)  NULL 
		print 'added'
	end
else
	begin
		print 'exists'
	end
go