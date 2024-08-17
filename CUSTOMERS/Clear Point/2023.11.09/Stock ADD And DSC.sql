
--Stock Update As Adjustment

Select UnitNo,loca, Isnull(Sum(Case Iid When '001' Then Nett
 When '002' Then -Nett Else 0 End),0) AS Nett  From tbPosTransact 
Where Status=1 And SaleType='S' And upload='F' or Upload is null and loca='01' group by UnitNo,Loca
--Net 27385324.175 (Chack net value)

Select Isnull(Sum(Case Iid When '001' Then qty
When '002' Then -Qty Else 0 End),0) AS qty  From tbPosTransact 
Where Status=1 And SaleType='S' And upload='F' or Upload is null and loca='01'
--QTY 55430.05 (Chack all qty)


---Change Upload Staus(For Not Update as sale)
select Distinct Upload from tbPostransact where loca='01'

update tbPostransact set Upload='A' where loca='01' and Upload is null and ZNo in('71','72','73','74','75','76','77','78')
update tbPospayment set Upload='A' where loca='01' and Upload is null and ZNo in('71','72','73','74','75','76','77','78')

--Check DataTransfer Ok Or Not
select *  from tbPostransact where loca='01' and Upload='A'
select Distinct Loca,UnitNo,zno from tbPostransact where loca='01' and Upload='A' or Upload is null

Select UnitNo,loca, Isnull(Sum(Case Iid When '001' Then Nett
 When '002' Then -Nett Else 0 End),0) AS Nett  From tbPosTransact 
Where Status=1 And SaleType='S' And Upload='A' and loca='01' group by UnitNo,Loca


Select Isnull(Sum(Case Iid When '001' Then qty
When '002' Then -Qty Else 0 End),0) AS qty  From tbPosTransact 
Where Status=1 And SaleType='S' And Upload='A' and loca='01'



/*
select * from tb_MastLog where TR_TYPE='ITEM' and TR_FROM='2010152'   
0-delete from location
1-delete from all location
*/
----------STOCK_UPDATE-------------
-- Create tempary table

Drop Table tb_DwnStock
CREATE TABLE [dbo].[tb_DwnStock] (
	[ItemCode] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Loca] [char] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[GetQty] [decimal](18, 4) NULL ,
	[Balance] [decimal](12, 4) NULL ,
	[ADQTY] [decimal](12, 4) NULL ,
	[Cost] [money] NOT NULL ,
	[Price] [money] NOT NULL,
	[Nett] [money] Not Null 
) ON [PRIMARY]
GO


select * from tb_DwnStock

--Insert into DownStock Table
Insert Into tb_DwnStock(GetQty,ItemCode,Cost,Price,Nett) 
Select  IsNull(Sum(Case When IID = '001' Then Qty When IID='002' Then -Qty End),0) As Qty,ItemCode,0,0,0
From tbPostransact Where Upload='A'  And loca='01' and zno in ('71','72','73','74','75','76','77','78') and Status = '1' Group By ItemCode

/*
Insert Into tb_DwnStock(getQty,ItemCode,Cost,Price,Nett) 
Select  qty,code,0,0,0 from STKKZNOE03072019  Group By qty,Code
*/
select * from tb_DwnStock
--Update tb_DwnStock Set Nett = (getQty * Price)
--Select SUM(Nett) From tb_DwnStock

--Insert Items that in inventory but not calculated in stock update or not in shop
insert into tb_DwnStock( [itemcode],[loca],[getqty],[balance],[adqty],[cost],[price],[nett])
select ItemCode,'01',0,Stock,0,0,0,0 from Vw_Stock  where LocaCode='01' and ItemCode not in(select ItemCode from tb_DwnStock where LocaCode='01') 

--Check OPB in Location table
--open balance incarse 1 digit,or adaj 2 digits
Select * From tb_System Where LocaCode = '01' --280

--
update tb_System set opb=OPB+2 Where LocaCode = '01' --281 & 282

--Check whether transactions happen after stock take
select * from tb_Stock where LocaCode='01' order by pdate desc

select SUM(getqty) from tb_DwnStock    --55430.0500

-- Check if there any items not in easyway if available delete them
select SUM(getqty) from tb_DwnStock where ItemCode not in (select item_code from tb_item)
select ItemCode,GetQty from tb_DwnStock where ItemCode not in (select item_code from tb_item)

delete from tb_DwnStock where ItemCode not in (select item_code from tb_item)

--update the item values using value in item form
update b set b.cost=a.cost_price,b.Price=a.ERet_Price  from tb_DwnStock as b join tb_itemdet as a on a.item_code=b.itemcode where a.Loca_Code='01' 
update b set b.Balance=a.stock from tb_DwnStock as b join Vw_Stock as a on a.itemcode=b.itemcode where a.LocaCode='01' 

select * from tb_DwnStock where Balance is null

update tb_DwnStock set Balance=0.0000 where Balance is null

--Calculate ADQTY
update tb_DwnStock set ADQTY=GetQty-Balance 

select* from tb_DwnStock where ItemCode='10010006'
select * from tb_stock where ItemCode='10010006' order by PDate desc

-- Stock will be added as 2 types one for decrease and one for addings
--DSC 
Insert Into tb_Stock ([SerialNo],[LocaCode],[RefNo],[PDate],[SuppCode],[RepCode],[TourCode],
	[ItemCode],[Scale],[PackSize],[Qty],[Balance],[Rate],[Cost],[RealCost],[Type],[ID],[CrDate],[Status],[IType])
Select
	'01'+'000281','01','DSC' + Convert(Varchar(10),'2023-11-07'),'2023-11-07',Rtrim
	(I.Supp_Code),Null,'StkUp',Rtrim(I.Item_Code),'Each','1'
	,abs(IsNull(S.ADQty,0)),abs(IsNull(S.ADQty,0)),D.Eret_Price,D.Cost_Price,D.Cost_price,0,'DSC',GetDate(),1,Null 
From tb_DwnStock As S Join tb_Item As I On S.ItemCode = I.Item_Code Join tb_ItemDet As D On 
S.ItemCode = D.Item_Code Where D.Loca_Code = '01' and ADQTY<0 

--ADD
Insert Into tb_Stock ([SerialNo],[LocaCode],[RefNo],[PDate],[SuppCode],[RepCode],[TourCode],
	[ItemCode],[Scale],[PackSize],[Qty],[Balance],[Rate],[Cost],[RealCost],[Type],[ID],[CrDate],[Status],[IType])
Select
	'01'+'000282','01','ADD' + Convert(Varchar(10),'2023-11-07'),'2023-11-07',Rtrim
	(I.Supp_Code),Null,'StkUp',Rtrim(I.Item_Code),'Each','1'
	,IsNull(S.ADQty,0),IsNull(S.ADQty,0),D.Eret_Price,D.Cost_Price,D.Cost_price,0,'ADD',GetDate(),1,Null 
From tb_DwnStock As S Join tb_Item As I On S.ItemCode = I.Item_Code Join tb_ItemDet As D On 
S.ItemCode = D.Item_Code Where D.Loca_Code = '01' and ADQTY>0 

--select * from vw_stock where ItemCode='MS00051' and LocaCode='01'
--select a.itemcode,a.getqty,b.stock from tb_DwnStock as a join vw_stock as b on a.itemcode=b.itemcode  and b.LocaCode='01' and a.getqty<>b.stock 

--select * from tbPostransact where Upload='C' and ItemCode='MS00214'
--select * from tb_DwnStock where ItemCode='MS00214'
--select * from tb_stock where ItemCode='MS00051' and LocaCode='01' order by pdate
--select SUM(stock) from vw_stock where  LocaCode='01'
--select SUM(getqty) from tb_DwnStock 




//

*/
--tb_PriceChange 

Insert Into tb_PriceChange([ItemCode],[ItemDescrip],[LocaCode],[SuppCode],[Qty],[PackSize],[CostPrice],[ERetPrice],[PRetPrice]
,[EWholePrice],[PWholePrice],[NewCostPrice],[NewERetPrice],[NewPRetPrice],[NewEWholePrice],[NewPWholePrice],[CDate],[UserName]
,[CType],[CDatetime],[Status],[AvgCost],[NewAvgCost])
Select 	D.Item_Code,I.Descrip,'01',I.Supp_Code,0,I.Pack_Size,0,0,0,0,0,S.Cost,S.Price,D.PRet_Price,D.EWhole_Price
,D.PWhole_Price,'2023-11-07','EasyWay','ITC',GetDate(),1,S.Cost,S.Cost From tb_Item As I Join tb_ItemDet As D
On I.Item_Code=D.Item_Code Join tb_DwnStock As S On I.Item_Code=S.ItemCode Where D.Loca_Code='01'




--------------------------------------------------------------------------------------------
--select * from tb_StAdjDet where SerialNo='06000001'
--delete from tb_StAdjDet where LocaCode='08' and IDate='2019-06-26'
--delete from tb_StAdjSumm where LocaCode='08' and IDate='2019-06-26' and SerialNo='08000003'

--DSC

Insert Into tb_StAdjDet	([SerialNo],[LocaCode],[RefNo] ,[IDate]     ,[SuppCode] ,[ItemCode],[ItemDescrip],[Scale],[Remark],[Cost]      ,[Rate]      ,[Qty],[CostValue]         ,[RetValue]          ,[TrDate] ,[ID] ,[Status],[LnNo],[PackSize],[ExpDate],[BatchNo])
Select	 	             '01000281',   '01'   ,'DSCSTK','2023-11-07',I.Supp_Code,D.ItemCode,I.Inv_Descrip,'Each' ,'StockUP' ,E.Cost_Price,E.ERet_Price,abs(D.ADQTY),abs(D.ADQty*E.Cost_Price),abs(D.ADQty*E.ERet_Price),GetDate(),'DSC',   '1'  ,  '1' ,    '1'   ,    ''   ,   ''
From tb_ItemDet As E Join tb_DwnStock As D On E.Item_Code = D.ItemCode Join tb_Item As I On D.ItemCode = I.Item_Code
Where E.Loca_Code = '01' and d.ADQTY<0 

Insert Into tb_StAdjSumm ([SerialNo],[LocaCode],[RefNo]       ,[IDate]     ,[CostValue]   ,[RetValue]   ,[Id] ,[Type],[Status],[TrDate] ,[UserName])			
Select 					  '01000281',   '01'   ,'DSC2023-11-07','2023-11-07',Sum(CostValue),Sum(RetValue),'DSC',  '1' ,   '1'  ,GetDate(),  'Sarasa'
From tb_StAdjDet Where LocaCode = '01' And SerialNo = '01000281'

--ADD

Insert Into tb_StAdjDet	([SerialNo],[LocaCode],[RefNo] ,[IDate]     ,[SuppCode] ,[ItemCode],[ItemDescrip],[Scale],[Remark],[Cost]      ,[Rate]      ,[Qty],[CostValue]         ,[RetValue]          ,[TrDate] ,[ID] ,[Status],[LnNo],[PackSize],[ExpDate],[BatchNo])
Select	 	             '01000282',   '01'   ,'ADDSTK','2023-11-07',I.Supp_Code,D.ItemCode,I.Inv_Descrip,'Each' ,'StockUP' ,E.Cost_Price,E.ERet_Price,(D.ADQTY),(D.ADQty*E.Cost_Price),(D.ADQty*E.ERet_Price),GetDate(),'ADD',   '1'  ,  '1' ,    '1'   ,    ''   ,   ''
From tb_ItemDet As E Join tb_DwnStock As D On E.Item_Code = D.ItemCode Join tb_Item As I On D.ItemCode = I.Item_Code
Where E.Loca_Code = '01' and d.ADQTY>0 

Insert Into tb_StAdjSumm ([SerialNo],[LocaCode],[RefNo]       ,[IDate]     ,[CostValue]   ,[RetValue]   ,[Id] ,[Type],[Status],[TrDate] ,[UserName])			
Select 					  '01000282',   '01'   ,'ADD2023-11-07','2023-11-07',Sum(CostValue),Sum(RetValue),'ADD',  '1' ,   '1'  ,GetDate(),  'Sarasa'
From tb_StAdjDet Where LocaCode = '01' And SerialNo = '01000282'



-----

-- Stock Variance
//

update tb_Stock_OpBal set CNo='9' where CNo='0' and  LocaCode = '01'
Insert Into tb_Stock_OpBal ([Idx],[SerialNo],[LocaCode],[RefNo],[PDate],[SuppCode],[RepCode],[TourCode],[ItemCode],[Scale],[PackSize],[Qty],[Balance],[Rate],[Cost],[RealCost],[Type],[ID],[CrDate],[Status],[IType],[BkpDate],[CNo])
	Select					[Idx],[SerialNo],[LocaCode],[RefNo],[PDate],[SuppCode],[RepCode],[TourCode],[ItemCode],[Scale],[PackSize],[Qty],[Balance],[Rate],[Cost],[RealCost],[Type],[ID],[CrDate],[Status],[IType],GetDate(),  0 
From tb_Stock where status='1' and LocaCode='01' and PDate<'2023-11-08'
							
delete from tb_Stock_OpBal where CNo=0 and ItemCode='10010001'

update tb_Stock_Backup set CNo='9' where CNo='0' and  LocaCode = '01'
Insert Into tb_Stock_Backup ([Idx],[SerialNo],[LocaCode],[RefNo],[PDate],[SuppCode],[RepCode],[TourCode],[ItemCode],[Scale],[PackSize],[Qty],[Balance],[Rate],[Cost],[RealCost],[Type],[ID],[CrDate],[Status],[IType],[BkpDate],[CNo])
	Select					 [Idx],[SerialNo],[LocaCode],[RefNo],[PDate],[SuppCode],[RepCode],[TourCode],[ItemCode],[Scale],[PackSize],[Qty],[Balance],[Rate],[Cost],[RealCost],[Type],[ID],[CrDate],[Status],[IType],GetDate(),  0 
From tb_Stock Where LocaCode = '01' And Status = '1' and  PDate<'2023-11-07' order by pdate desc
*/

select * from tb_Stock_Backup where CNo=0

