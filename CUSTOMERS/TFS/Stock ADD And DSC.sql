
--Stock Update As Adjustment

--Check DataTransfer Ok Or Not
select *  from tbPostransact where loca='06' and Upload is null
select Distinct Loca,UnitNo,zno from tbPostransact where loca='06' and Upload is null order by zno

select Distinct Loca,UnitNo,zno from tbPostransact where loca='06' and Upload is null and zno='2001'

Select UnitNo,loca,zno, Isnull(Sum(Case Iid When '001' Then Nett
 When '002' Then -Nett Else 0 End),0) AS Nett  From tbPosTransact 
Where Status=1 And SaleType='S' And Upload='E' and loca='06' group by UnitNo,Loca,zno
--Net 9546475.336 (Chack net value)8

Select Isnull(Sum(Case Iid When '001' Then Nett
 When '002' Then -Nett Else 0 End),0) AS Nett  From tbPosTransact 
Where Status=1 And SaleType='S' And Upload='E' and loca='06' 
--240218108.38

Select Isnull(Sum(Case Iid When '001' Then qty
When '002' Then -Qty Else 0 End),0) AS qty  From tbPosTransact 
Where Status=1 And SaleType='S' And Upload='E' and loca='06'
--QTY 181301 (Chack all qty)

---Change Upload Staus(For Not Update as sale)
select Distinct Upload from tbPostransact where loca='06'

UPDATE tbPostransact SET Upload='F' WHERE Loca='06' AND ZNO IN ('179','85') AND Upload='G'
UPDATE tbPospayment SET Upload='F' WHERE Loca='06' AND ZNO IN ('179','85') AND Upload='G'

UPDATE tbPostransact SET Upload='E' WHERE Loca='06' AND ZNO IN ('178','84','2001','132','180','121','22') AND Upload IS NULL
UPDATE tbPospayment SET Upload='E' WHERE Loca='06' AND ZNO IN ('178','84','2001','132','180','121','22') AND Upload IS NULL


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
From tbPostransact Where Upload='E'  And loca='06' and 
zno in ('178','84','2001','132','180','121','22') and Status = '1' Group By ItemCode

/*
Insert Into tb_DwnStock(getQty,ItemCode,Cost,Price,Nett) 
Select  qty,code,0,0,0 from STKKZNOE03072019  Group By qty,Code
*/
select * from tb_DwnStock
--Update tb_DwnStock Set Nett = (getQty * Price)
--Select SUM(Nett) From tb_DwnStock

--Insert Items that in inventory but not calculated in stock update or not in shop
insert into tb_DwnStock( [itemcode],[loca],[getqty],[balance],[adqty],[cost],[price],[nett])
select ItemCode,'06',0,Stock,0,0,0,0 from Vw_Stock  where LocaCode='06' and ItemCode not in(select ItemCode from tb_DwnStock where LocaCode='06') 

--Check OPB in Location table
--open balance incarse 1 digit,or adaj 2 digits
Select * From tb_System Where LocaCode = '06' --24

--
update tb_System set opb=OPB+2 Where LocaCode = '06' --25 & 26

--Check whether transactions happen after stock take
select * from tb_Stock where LocaCode='06' order by pdate desc

select SUM(getqty) from tb_DwnStock    --181301
--181301.0000


-- Check if there any items not in easyway if available delete them
select * from tb_DwnStock where ItemCode not in (select item_code from tb_item)
delete from tb_DwnStock where ItemCode not in (select item_code from tb_item)

--update the item values using value in item form
update b set b.cost=a.cost_price,b.Price=a.ERet_Price  from tb_DwnStock as b join tb_itemdet as a on a.item_code=b.itemcode where a.Loca_Code='06' 
update b set b.Balance=a.stock from tb_DwnStock as b join Vw_Stock as a on a.itemcode=b.itemcode where a.LocaCode='06' 

select * from tb_DwnStock where Balance is null

update tb_DwnStock set Balance=0.0000 where Balance is null

--Calculate ADQTY
update tb_DwnStock set ADQTY=GetQty-Balance 

select* from tb_DwnStock 

-- Stock will be added as 2 types one for decrease and one for addings
--DSC 
Insert Into tb_Stock ([SerialNo],[LocaCode],[RefNo],[PDate],[SuppCode],[RepCode],[TourCode],
	[ItemCode],[Scale],[PackSize],[Qty],[Balance],[Rate],[Cost],[RealCost],[Type],[ID],[CrDate],[Status],[IType])
Select
	'06'+'000025','06','DSC' + Convert(Varchar(10),'2024-07-10'),'2024-07-10',Rtrim
	(I.Supp_Code),Null,'StkUp',Rtrim(I.Item_Code),'Each','1'
	,abs(IsNull(S.ADQty,0)),abs(IsNull(S.ADQty,0)),D.Eret_Price,D.Cost_Price,D.Cost_price,0,'DSC',GetDate(),1,Null 
From tb_DwnStock As S Join tb_Item As I On S.ItemCode = I.Item_Code Join tb_ItemDet As D On 
S.ItemCode = D.Item_Code Where D.Loca_Code = '06' and ADQTY<0 

--ADD
Insert Into tb_Stock ([SerialNo],[LocaCode],[RefNo],[PDate],[SuppCode],[RepCode],[TourCode],
	[ItemCode],[Scale],[PackSize],[Qty],[Balance],[Rate],[Cost],[RealCost],[Type],[ID],[CrDate],[Status],[IType])
Select
	'06'+'000026','06','ADD' + Convert(Varchar(10),'2024-07-10'),'2024-07-10',Rtrim
	(I.Supp_Code),Null,'StkUp',Rtrim(I.Item_Code),'Each','1'
	,IsNull(S.ADQty,0),IsNull(S.ADQty,0),D.Eret_Price,D.Cost_Price,D.Cost_price,0,'ADD',GetDate(),1,Null 
From tb_DwnStock As S Join tb_Item As I On S.ItemCode = I.Item_Code Join tb_ItemDet As D On 
S.ItemCode = D.Item_Code Where D.Loca_Code = '06' and ADQTY>0 

--select * from vw_stock where ItemCode='MS00051' and LocaCode='06'
--select a.itemcode,a.getqty,b.stock from tb_DwnStock as a join vw_stock as b on a.itemcode=b.itemcode  and b.LocaCode='06' and a.getqty<>b.stock 

--select * from tbPostransact where Upload='E' and ItemCode='MS00214'
--select * from tb_DwnStock where ItemCode='MS00214'
--select * from tb_stock where ItemCode='MS00051' and LocaCode='06' order by pdate
--select SUM(stock) from vw_stock where  LocaCode='06'
--select SUM(getqty) from tb_DwnStock 




//

*/
--tb_PriceChange 

Insert Into tb_PriceChange([ItemCode],[ItemDescrip],[LocaCode],[SuppCode],[Qty],[PackSize],[CostPrice],[ERetPrice],[PRetPrice]
,[EWholePrice],[PWholePrice],[NewCostPrice],[NewERetPrice],[NewPRetPrice],[NewEWholePrice],[NewPWholePrice],[CDate],[UserName]
,[CType],[CDatetime],[Status],[AvgCost],[NewAvgCost])
Select 	D.Item_Code,I.Descrip,'06',I.Supp_Code,0,I.Pack_Size,0,0,0,0,0,S.Cost,S.Price,D.PRet_Price,D.EWhole_Price
,D.PWhole_Price,'2024-07-10','EasyWay','ITC',GetDate(),1,S.Cost,S.Cost From tb_Item As I Join tb_ItemDet As D
On I.Item_Code=D.Item_Code Join tb_DwnStock As S On I.Item_Code=S.ItemCode Where D.Loca_Code='06'




-------------------------------------------------------------------------------------------

--DSC

Insert Into tb_StAdjDet	([SerialNo],[LocaCode],[RefNo] ,[IDate]     ,[SuppCode] ,[ItemCode],[ItemDescrip],[Scale],[Remark],[Cost]      ,[Rate]      ,[Qty],[CostValue]         ,[RetValue]          ,[TrDate] ,[ID] ,[Status],[LnNo],[PackSize],[ExpDate],[BatchNo])
Select	 	             '06000025',   '06'   ,'DSCSTK','2024-07-10',I.Supp_Code,D.ItemCode,I.Inv_Descrip,'Each' ,'StockUP' ,E.Cost_Price,E.ERet_Price,abs(D.ADQTY),abs(D.ADQty*E.Cost_Price),abs(D.ADQty*E.ERet_Price),GetDate(),'DSC',   '1'  ,  '1' ,    '1'   ,    ''   ,   ''
From tb_ItemDet As E Join tb_DwnStock As D On E.Item_Code = D.ItemCode Join tb_Item As I On D.ItemCode = I.Item_Code
Where E.Loca_Code = '06' and d.ADQTY<0 

Insert Into tb_StAdjSumm ([SerialNo],[LocaCode],[RefNo]       ,[IDate]     ,[CostValue]   ,[RetValue]   ,[Id] ,[Type],[Status],[TrDate] ,[UserName])			
Select 					  '06000025',   '06'   ,'DSC2024-07-10','2024-07-10',Sum(CostValue),Sum(RetValue),'DSC',  '1' ,   '1'  ,GetDate(),  'Sarasa'
From tb_StAdjDet Where LocaCode = '06' And SerialNo = '06000025'

--ADD

Insert Into tb_StAdjDet	([SerialNo],[LocaCode],[RefNo] ,[IDate]     ,[SuppCode] ,[ItemCode],[ItemDescrip],[Scale],[Remark],[Cost]      ,[Rate]      ,[Qty],[CostValue]         ,[RetValue]          ,[TrDate] ,[ID] ,[Status],[LnNo],[PackSize],[ExpDate],[BatchNo])
Select	 	             '06000026',   '06'   ,'ADDSTK','2024-07-10',I.Supp_Code,D.ItemCode,I.Inv_Descrip,'Each' ,'StockUP' ,E.Cost_Price,E.ERet_Price,(D.ADQTY),(D.ADQty*E.Cost_Price),(D.ADQty*E.ERet_Price),GetDate(),'ADD',   '1'  ,  '1' ,    '1'   ,    ''   ,   ''
From tb_ItemDet As E Join tb_DwnStock As D On E.Item_Code = D.ItemCode Join tb_Item As I On D.ItemCode = I.Item_Code
Where E.Loca_Code = '06' and d.ADQTY>0 

Insert Into tb_StAdjSumm ([SerialNo],[LocaCode],[RefNo]       ,[IDate]     ,[CostValue]   ,[RetValue]   ,[Id] ,[Type],[Status],[TrDate] ,[UserName])			
Select 					  '06000026',   '06'   ,'ADD2024-07-10','2024-07-10',Sum(CostValue),Sum(RetValue),'ADD',  '1' ,   '1'  ,GetDate(),  'Sarasa'
From tb_StAdjDet Where LocaCode = '06' And SerialNo = '06000026'



-----

-- Stock Variance
//

update tb_Stock_OpBal set CNo='9' where CNo='0' and  LocaCode = '06'
Insert Into tb_Stock_OpBal ([Idx],[SerialNo],[LocaCode],[RefNo],[PDate],[SuppCode],[RepCode],[TourCode],[ItemCode],[Scale],[PackSize],[Qty],[Balance],[Rate],[Cost],[RealCost],[Type],[ID],[CrDate],[Status],[IType],[BkpDate],[CNo])
	Select					[Idx],[SerialNo],[LocaCode],[RefNo],[PDate],[SuppCode],[RepCode],[TourCode],[ItemCode],[Scale],[PackSize],[Qty],[Balance],[Rate],[Cost],[RealCost],[Type],[ID],[CrDate],[Status],[IType],GetDate(),  0 
From tb_Stock where status='1' and LocaCode='06' order by pdate desc

select * from tb_Stock_OpBal where LocaCode='06'						
delete from tb_Stock_OpBal where CNo=0

update tb_Stock_Backup set CNo='9' where CNo='0' and  LocaCode = '06'
Insert Into tb_Stock_Backup ([Idx],[SerialNo],[LocaCode],[RefNo],[PDate],[SuppCode],[RepCode],[TourCode],[ItemCode],[Scale],[PackSize],[Qty],[Balance],[Rate],[Cost],[RealCost],[Type],[ID],[CrDate],[Status],[IType],[BkpDate],[CNo])
	Select					 [Idx],[SerialNo],[LocaCode],[RefNo],[PDate],[SuppCode],[RepCode],[TourCode],[ItemCode],[Scale],[PackSize],[Qty],[Balance],[Rate],[Cost],[RealCost],[Type],[ID],[CrDate],[Status],[IType],GetDate(),  0 
From tb_Stock Where LocaCode = '06' And Status = '1' and  PDate<'2024-07-10' order by pdate desc
*/

delete from tb_Stock_Backup where CNo=0

