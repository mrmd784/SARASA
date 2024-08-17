select * from tb_itemdet itd
join newpricelist np on itd.Item_Code=np.[item code]
select * from newpricelist
select * from tb_PriceChange where ctype='ITU'


INSERT INTO [dbo].[tb_SpecialPrices]
([Item_Code],[CustCode],[PackSize],[Ret_Price],[Wh_Price],[ItemDescrip]
,[LocaCode],[UserId],[CDate],[SpecialPriceListID],[ModifiedUser],[ModifiedDate]
,[Persentage],[EachRet_Price],[IS_DELETE],[IS_DELETE_USER],[IS_DELETE_DATE])
SELECT [Item Code],NULL,1,CAST([Walk In Customer] AS NUMERIC(18,2)),CAST([Distributor price] AS NUMERIC(18,2)),[item description]
,NULL,'EASYWAY',GETDATE(),14,'EASYWAY',GETDATE(),0,CAST([Laugfs] AS NUMERIC(18,2)),0,NULL,NULL
FROM newpricelist
select * from tb_Location

update I set I.ERet_Price=N.[Walk In Customer] from newpricelist as N 
join tb_itemdet as I on N.[Item Code]=I.Item_Code


--pricechange
Insert Into tb_PriceChange([ItemCode],[ItemDescrip],[LocaCode],[SuppCode],[Qty],[PackSize],[CostPrice],[ERetPrice],[PRetPrice]
,[EWholePrice],[PWholePrice],[NewCostPrice],[NewERetPrice],[NewPRetPrice],[NewEWholePrice],[NewPWholePrice],[CDate],[UserName]
,[CType],[CDatetime],[Status],[AvgCost],[NewAvgCost])
Select 	D.Item_Code,I.Descrip,'01',I.Supp_Code,0,I.Pack_Size,0,0,0,0,0,D.Cost_Price,D.ERet_Price,D.PRet_Price,D.EWhole_Price
,D.PWhole_Price,'2024-06-17','EasyWay','ITC',GetDate(),1,D.Cost_Price,D.Cost_Price From tb_Item As I 
Join tb_ItemDet As D On I.Item_Code=D.Item_Code 
--Join tb_DwnStock As S On I.Item_Code=S.ItemCode 
Where D.Loca_Code='01'

