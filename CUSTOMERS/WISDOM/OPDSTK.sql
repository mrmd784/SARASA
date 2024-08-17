
--Stock Update As Opening Stock

----------STOCK_UPDATE-------------

Drop Table tb_DwnStock
CREATE TABLE [dbo].[tb_DwnStock] (
	[ItemCode] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Loca] [char] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Qty] [decimal](18, 4) NULL ,
	--[Balance] [decimal](12, 4) NULL ,
	--[Cost] [money] NOT NULL ,
	--[Price] [money] NOT NULL,
	--[Nett] [money] Not Null 
) ON [PRIMARY]
GO

Truncate Table tb_DwnStock
Select * From tb_DwnStock

//
--1.
Insert Into tb_DwnStock(ItemCode,Loca,Qty) 
Select ItemCode,'01',stock from 
OpenRowset('Sqloledb','220.247.240.208';'sa';'tstc123',EasyWay.Dbo.vw_stock) where locacode='04'


--4.Update Document no for Stock Adjestment
Select * From tb_System Where LocaCode = '01'    --0
update tb_System set OPB='1' Where LocaCode = '01'

--5.Check If There Any Transactions After Stock Take
Select * From tb_Stock Where LocaCode = '01' And Status = '1' order by pdate desc

--7. Insert Stock 
--If there is a trigger in tb_stock table run this
--update tb_Item set Countable='1' where Countable='0'

Insert Into tb_Stock ([SerialNo],[LocaCode],[RefNo],[PDate],[SuppCode],[RepCode],[TourCode],
	[ItemCode],[Scale],[PackSize],[Qty],[Balance],[Rate],[Retprice],[Cost],[RealCost],[Type],[ID],[CrDate],[Status],[IType])
Select
	'01'+'000001','01','OB' + Convert(Varchar(10),'2024-06-20'),'2024-06-20',Rtrim
	(I.Supp_Code),Null,'StkUp',Rtrim(I.Item_Code),'Each','1'
	,IsNull(S.Qty,0),IsNull(S.Qty,0),D.ERet_Price,D.ERet_Price,D.Cost_Price,D.Cost_price,0,'OPB',GetDate(),1,Null 
From tb_DwnStock As S Join tb_Item As I On S.ItemCode = I.Item_Code Join tb_ItemDet As D On 
S.ItemCode = D.Item_Code Where D.Loca_Code = '01'


--8.Insert Price Change For Valuation Report
Insert Into tb_PriceChange([ItemCode],[ItemDescrip],[LocaCode],[SuppCode],[Qty],[PackSize],[CostPrice],[ERetPrice],[PRetPrice]
,[EWholePrice],[PWholePrice],[NewCostPrice],[NewERetPrice],[NewPRetPrice],[NewEWholePrice],[NewPWholePrice],[CDate],[UserName]
,[CType],[CDatetime],[Status],[AvgCost],[NewAvgCost])
Select 	D.Item_Code,I.Descrip,'02',I.Supp_Code,0,I.Pack_Size,0,0,0,0,0,S.Cost,S.Price,D.PRet_Price,D.EWhole_Price
,D.PWhole_Price,'2023-05-18','EasyWay','ITC',GetDate(),1,S.Cost,S.Cost From tb_Item As I Join tb_ItemDet As D
On I.Item_Code=D.Item_Code Join tb_DwnStock As S On I.Item_Code=S.ItemCode Where D.Loca_Code='02'


--9.For Stock Variance Report
select * from tb_Stock_OpBal where LocaCode = '02'
delete from tb_Stock_OpBal where LocaCode = '02'
Insert Into tb_Stock_OpBal ([Idx],[SerialNo],[LocaCode],[RefNo],[PDate],[SuppCode],[RepCode],[TourCode],[ItemCode],[Scale],[PackSize],[Qty],[Balance],[Rate],[Cost],[RealCost],[Type],[ID],[CrDate],[Status],[IType],[BkpDate],[CNo])
	Select					[Idx],[SerialNo],[LocaCode],[RefNo],[PDate],[SuppCode],[RepCode],[TourCode],[ItemCode],[Scale],[PackSize],[Qty],[Balance],[Rate],[Cost],[RealCost],[Type],[ID],[CrDate],[Status],[IType],GetDate(),  0 
From tb_Stock Where LocaCode = '02' And Status = '1'
							

select * from tb_Stock_Backup where LocaCode = '02'
delete from tb_Stock_Backup where LocaCode = '02'
Insert Into tb_Stock_Backup ([Idx],[SerialNo],[LocaCode],[RefNo],[PDate],[SuppCode],[RepCode],[TourCode],[ItemCode],[Scale],[PackSize],[Qty],[Balance],[Rate],[Cost],[RealCost],[Type],[ID],[CrDate],[Status],[IType],[BkpDate],[CNo])
	Select					 [Idx],[SerialNo],[LocaCode],[RefNo],[PDate],[SuppCode],[RepCode],[TourCode],[ItemCode],[Scale],[PackSize],[Qty],[Balance],[Rate],[Cost],[RealCost],[Type],[ID],[CrDate],'1',[IType],GetDate(),  0 
From tb_Stock Where LocaCode = '02' And Status = '9' and  TourCode = 'STK05/23'


--10.For View Stock Adjestment Report

Insert Into tb_StAdjDet	([SerialNo],[LocaCode],[RefNo] ,[IDate]     ,[SuppCode] ,[ItemCode],[ItemDescrip],[Scale],[Remark],[Cost]      ,[Rate]      ,[Qty],[CostValue]         ,[RetValue]          ,[TrDate] ,[ID] ,[Status],[LnNo],[PackSize],[ExpDate],[BatchNo])
Select	 	             '01000001',   '01'   ,'OPBSTK','2024-06-20',I.Supp_Code,D.ItemCode,I.Inv_Descrip,'Each' ,'StockUP' ,E.Cost_Price,E.ERet_Price,D.Qty,(D.Qty*E.Cost_Price),(D.Qty*E.ERet_Price),GetDate(),'OPB',   '1'  ,  '1' ,    '1'   ,    ''   ,   ''
From tb_ItemDet As E Join tb_DwnStock As D On E.Item_Code = D.ItemCode Join tb_Item As I On D.ItemCode = I.Item_Code
Where E.Loca_Code = '01' 


Insert Into tb_StAdjSumm ([SerialNo],[LocaCode],[RefNo]       ,[IDate]     ,[CostValue]   ,[RetValue]   ,[Id] ,[Type],[Status],[TrDate] ,[UserName])			
Select 					  '01000001',   '01'   ,'OP2024-06-20','2024-06-20',isNUll(Sum(CostValue),0),Sum(RetValue),'OPB',  '1' ,   '1'  ,GetDate(),  'Sarasa'
From tb_StAdjDet Where LocaCode = '01' And SerialNo = '01000001'


----------------check stock-----------

select *from vw_stock as v1
JOIN
OpenRowset('Sqloledb','220.247.240.208';'sa';'tstc123',EasyWay.Dbo.vw_stock) as v2 on v1.ItemCode=v2.itemcode
where v1.Stock<>v2.stock and v2.locacode='04'
