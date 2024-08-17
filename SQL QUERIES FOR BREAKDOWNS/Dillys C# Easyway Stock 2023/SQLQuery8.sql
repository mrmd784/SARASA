
	Insert Into tb_StAdjSumm([SerialNo],[LocaCode],[RefNo],[IDate],[CostValue],[RetValue],[Id],[Type],[Status],[TrDate],[UserName])
	Select '33000013','33','ST33241023','2023-10-24',Isnull(Sum(Balance*Cost),0),Isnull(Sum(Balance*Price),0),'ADD','',1,GetDate(),'Easyway'  From tb_DwnStock Where Balance>0
	
	Insert Into tb_StAdjDet([LnNo],[SerialNo],[LocaCode],[IDate],[RefNo],[SuppCode],[ItemCode],[ItemDescrip],[Scale],[PackSize],[Cost],[Rate],[Qty],[CostValue],[RetValue],[TrDate],[ID],[Remark],[Status],[ExpDate],[BatchNo],[CScode])
	Select 1,'33000013','33','33241023','2023-10-24',tb_Item.Supp_Code,tb_DwnStock.ItemCode,tb_Item.Descrip,'Each',1,tb_DwnStock.Cost,tb_DwnStock.Price,tb_DwnStock.Balance,tb_DwnStock.Balance*tb_DwnStock.Cost,tb_DwnStock.Balance*tb_DwnStock.Price,Getdate(),'ADD','',1,Null,Null,tb_DwnStock.CScode
	From tb_DwnStock Join tb_Item On tb_DwnStock.ItemCode=tb_item.Item_Code Where tb_DwnStock.Balance>0
	
	Insert Into tb_Stock ([SerialNo],[LocaCode],[RefNo],[PDate],[SuppCode],[RepCode],[TourCode],[ItemCode],[ExpDate],[BatchNo],[Scale],[PackSize],[Qty],[Balance],[Rate],[Cost],[RealCost],[Type],[ID],[CrDate],[Status],[IType],[PosUnit],[CScode])
	Select '33000013','33','ST33241023','2023-10-24',tb_Item.Supp_Code,Null,Null,tb_DwnStock.ItemCode,Null,Null,'EACH',1,tb_DwnStock.Balance,tb_DwnStock.Balance,tb_DwnStock.Price,tb_DwnStock.Cost,tb_DwnStock.Cost,0,'ADD',Getdate(),1,Null,Null,tb_DwnStock.CScode
	From tb_DwnStock Join tb_Item On tb_DwnStock.ItemCode=tb_item.Item_Code Where tb_DwnStock.Balance>0



select * from tb_stock where LocaCode='33' and RefNo='ST33241023'
delete from tb_stock where LocaCode='33' and RefNo='ST33241023'

--Stock Reduce


	Insert Into tb_StAdjSumm([SerialNo],[LocaCode],[RefNo],[IDate],[CostValue],[RetValue],[Id],[Type],[Status],[TrDate],[UserName])
	Select '33000014','33','ST33241023','2023-10-24',Isnull(Sum(Abs(Balance)*Cost),0),Isnull(Sum(Abs(Balance)*Price),0),'DSC','',1,GetDate(),'Easyway'  From tb_DwnStock Where Balance<0
	
	Insert Into tb_StAdjDet([LnNo],[SerialNo],[LocaCode],[IDate],[RefNo],[SuppCode],[ItemCode],[ItemDescrip],[Scale],[PackSize],[Cost],[Rate],[Qty],[CostValue],[RetValue],[TrDate],[ID],[Remark],[Status],[ExpDate],[BatchNo],[CScode])
	Select 1,'33000014','33','33241023','2023-10-24',tb_Item.Supp_Code,tb_DwnStock.ItemCode,tb_Item.Descrip,'Each',1,tb_DwnStock.Cost,tb_DwnStock.Price,Abs(tb_DwnStock.Balance),Abs(tb_DwnStock.Balance)*tb_DwnStock.Cost,Abs(tb_DwnStock.Balance)*tb_DwnStock.Price,Getdate(),'DSC','',1,Null,Null,tb_DwnStock.CScode
	From tb_DwnStock Join tb_Item On tb_DwnStock.ItemCode=tb_item.Item_Code Where tb_DwnStock.Balance<0
	
	Insert Into tb_Stock ([SerialNo],[LocaCode],[RefNo],[PDate],[SuppCode],[RepCode],[TourCode],[ItemCode],[ExpDate],[BatchNo],[Scale],[PackSize],[Qty],[Balance],[Rate],[Cost],[RealCost],[Type],[ID],[CrDate],[Status],[IType],[PosUnit],[CScode])
	Select '33000014','33','ST33241023','2023-10-24',tb_Item.Supp_Code,Null,Null,tb_DwnStock.ItemCode,Null,Null,'EACH',1,Abs(tb_DwnStock.Balance),Abs(tb_DwnStock.Balance),tb_DwnStock.Price,tb_DwnStock.Cost,tb_DwnStock.Cost,0,'DSC',Getdate(),1,Null,Null,tb_DwnStock.CScode
	From tb_DwnStock Join tb_Item On tb_DwnStock.ItemCode=tb_item.Item_Code Where tb_DwnStock.Balance<0



--Insert Into tb_PriceChange([ItemCode]		,[ItemDescrip]	,[LocaCode]	,[SuppCode]	,[Qty]			,[PackSize]	,[CostPrice]	
--,[ERetPrice]		,[PRetPrice]		,[EWholePrice]	,[PWholePrice]	,[NewCostPrice]	,[NewERetPrice]		,[NewPRetPrice]
--,[NewEWholePrice]	,[NewPWholePrice]	,[CDate]		,[UserName]	,[CType]	,[CDatetime]		,[Status],[avgcost],[newavgcost],[CSCode],[CSName])

--Select 			d.Item_Code		,i.Descrip	,@Loca	,i.Supp_Code	,0			,i.Pack_Size	,0
--,0			,0			,0		,0		,d.Cost_Price	,d.ERet_Price		,d.PRet_Price
--,d.EWhole_Price	,d.PWhole_Price	,@Date	,@UName	,'ITC'		,@Date		,1 ,d.Cost_Price,d.Cost_Price,'',''
--From tb_Item As i Join tb_ItemDet As d On i.Item_Code=d.Item_Code Where d.Loca_Code=@Loca


END

select * from tb_Stock_OpBal

INSERT INTO [dbo].[tb_Stock_OpBal]
           ([Idx],[SerialNo],[LocaCode],[RefNo],[PDate],[SuppCode],[RepCode],[TourCode],[ItemCode],[Scale],[ExpDate],[BatchNo],[PackSize],[Qty]
           ,[Balance],[Rate],[Cost],[RealCost],[Type],[ID],[CrDate],[Status],[IType],[BkpDate],[CNo],[CSCode],[StockCountRef],[SupplierName]
           ,[CategoryCode],[CategoryName],[SubCategoryCode],[SubCategoryName])	
 Select		[Idx],[SerialNo],[LocaCode],[RefNo],[PDate],[SuppCode],[RepCode],[TourCode],[ItemCode],[Scale],[ExpDate],[BatchNo],[PackSize],[Qty]
           ,[Balance],[Rate],[Cost],[RealCost],[Type],[ID],[CrDate],[Status],[IType],'2023-10-24',0,[CSCode],'20231024',''
           ,'','','',''
From tb_Stock where status='1' and LocaCode='33' order by pdate


select * from [tb_Stock_Backup]
INSERT INTO [dbo].[tb_Stock_Backup]
           ([Idx],[SerialNo],[LocaCode],[RefNo],[PDate],[SuppCode],[RepCode],[TourCode],[ItemCode],[Scale],[ExpDate],[BatchNo],[BarcodeSerial]
           ,[PackSize],[Qty],[Balance],[Rate],[RetPrice],[Cost],[RealCost],[Type],[ID],[CrDate],[Status],[IType],[BkpDate],[CNo],[CSCode]
           ,[StockCountRef])
		   	Select	[Idx],[SerialNo],[LocaCode],[RefNo],[PDate],[SuppCode],[RepCode],[TourCode],[ItemCode],[Scale],[ExpDate],[BatchNo],[BarcodeSerial]
           ,[PackSize],[Qty],[Balance],[Rate],[RetPrice],[Cost],[RealCost],[Type],[ID],[CrDate],[Status],[IType],'2023-10-24',0,[CSCode]
           ,'20231024'
From tb_Stock Where LocaCode = '33' And Status = '1' and  PDate<'2023-10-24' order by pdate
    

	select * from tb_Stock Where LocaCode = '33' And Status = '1' and  PDate='2023-10-24'