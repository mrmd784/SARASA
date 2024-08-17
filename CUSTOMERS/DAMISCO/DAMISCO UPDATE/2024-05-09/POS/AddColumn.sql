
if not exists (select * from syscolumns where id=object_id('SysConfig') and name='PrintSignatureOnCnl') 
	begin
		alter table SysConfig add PrintSignatureOnCnl bit NOT NULL DEFAULT ((0))
		print 'added'
	end
else
	begin
		print 'exists'
	end
go