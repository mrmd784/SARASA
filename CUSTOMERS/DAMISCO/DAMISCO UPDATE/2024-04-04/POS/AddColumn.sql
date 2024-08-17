
if not exists (select * from syscolumns where id=object_id('SysConfig') and name='PrinterBarcodeMode') 
	begin
		alter table SysConfig add PrinterBarcodeMode smallint NOT NULL DEFAULT ((1))
		print 'added'
	end
else
	begin
		print 'exists'
	end
go