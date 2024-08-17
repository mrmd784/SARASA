if not exists (select * from syscolumns where id=object_id('InvPromotionMaster') and name='OneTimeLoyalty') 
	begin
		alter table InvPromotionMaster add OneTimeLoyalty bit NOT NULL DEFAULT ((0))
		print 'added'
	end
else
	begin
		print 'exists'
	end
go