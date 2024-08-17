
if not exists (select * from syscolumns where id=object_id('SysConfig') and name='LogoPrintCopy') 
	begin
		alter table SysConfig add LogoPrintCopy bit NOT NULL DEFAULT ((0))
		print 'added'
	end
else
	begin
		print 'exists'
	end
go