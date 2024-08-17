
--Stock Update As Opening Stock

--When Getting Supplier wise Stock Use below inner joins to join supplier code to tb_stock and tbpostransact tables
--	1.update b set b.newcustcode=a.supp_code from tbpostransact as b join tb_item as a on a.item_code=b.itemcode where b.upload='C'

--	to check whether only one supplier stock is taken
--	select * from tbpostransact where upload ='C' and newcustcode<>'U001'

-- 2.update b b.batchno=a.supp_code from tb_stock as b join tb_item as a on a.item_code=b.itemcode where b.status='1' and b.locacode='01'

---------------------------------------------------------------------------------------------------------------------------------------------
select * from tb_Location
--Check DataTransfer Ok Or Not
select *  from tbPostransact where loca='03' and upload='F' or Upload is null

select Distinct Loca,UnitNo,zno from tbPostransact where loca='03' and upload='F' or Upload is null

Select UnitNo,LOCA,Isnull(Sum(Case Iid When '001' Then Nett
 When '002' Then -Nett Else 0 End),0) AS Nett  From tbPosTransact 
Where Status=1 And SaleType='S' And Upload='D' and loca='03'   Group By UnitNo,LOCA
--1214460

Select Isnull(Sum(Case Iid When '001' Then qty
When '002' Then -Qty Else 0 End),0) AS qty  From tbPosTransact 
Where Status=1 And SaleType='S' And Upload='D' and loca='03'  Group By UnitNo 
--296

---Change Upload Staus(For Not Update as sale)
select Distinct Upload from tbPostransact where loca='03'


select * from tbpostransact where loca=03 and upload='F' and  ZNo in('2145','2147')
update tbPostransact set Upload='D' where loca='03' and Upload='F' and ZNo in('2145','2147')
update tbPospayment set Upload='D' where loca='03' and Upload='F' and ZNo in('2145','2147')


----------STOCK_UPDATE-------------

Drop Table tb_DwnStock
CREATE TABLE [dbo].[tb_DwnStock] (
	[ItemCode] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Loca] [char] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Qty] [decimal](18, 4) NULL ,
	[Balance] [decimal](12, 4) NULL ,
	[Cost] [money] NOT NULL ,
	[Price] [money] NOT NULL,
	[Nett] [money] Not Null 
) ON [PRIMARY]
GO

Truncate Table tb_DwnStock
Select * From tb_DwnStock
select * from tb_Location
//
--1.
Insert Into tb_DwnStock(Qty,ItemCode,Cost,Price,Nett) 
Select  IsNull(Sum(Case When IID = '001' Then Qty When IID='002' Then -Qty End),0) As Qty,ItemCode,Cost,Price,0
From tbPostransact Where Upload='D'  And loca='03' and  Status = '1' Group By ItemCode,Cost,Price

--2.(Check Item not in easyway)
select * from tbPostransact Where Loca = '03' and Upload = 'D' and ItemCode not in(select item_code from tb_Item)

--3.
Update tb_DwnStock Set Nett = (Qty * Price)
Select SUM(Nett) From tb_DwnStock  ---1214460.00

--4.Update Document no for Stock Adjestment
Select * From tb_System Where LocaCode = '03'    --3742
update tb_System set OPB='3743' Where LocaCode = '03'


--5.Check If There Any Transactions After Stock Take
select Serial from tbPostransact where Upload='D' and Serial<>'F011'
UPDATE C  SET  C.serial=D.Supp_Code FROM  TB_ITEM  AS  D  JOIN tbPostransact AS C ON D.ITEM_CODE=C.ITEMCODE where c.upload='D'



UPDATE C  SET  C.BatchNo=D.Supp_Code FROM  TB_ITEM  AS  D  JOIN tb_stock AS C ON D.ITEM_CODE=C.ITEMCODE


Select * From tb_Stock Where LocaCode = '03' And Status = '1' order by pdate desc

Select * From tb_Stock Where LocaCode = '03' And Status = '9' and batchno='F011' order by pdate desc

--6.Stock Zero
Update tb_Stock Set Status = '9', TourCode = 'STK25/23' Where LocaCode = '03' And Status = '1' and BatchNo='F011'
--and PDate>'2023-01-31'
select * from tb_Stock where SerialNo='03003741'

--7. Insert Stock 
Insert Into tb_Stock ([SerialNo],[LocaCode],[RefNo],[PDate],[SuppCode],[RepCode],[TourCode],
	[ItemCode],[Scale],[PackSize],[Qty],[Balance],[Rate],[Cost],[RealCost],[Type],[ID],[CrDate],[Status],[IType])
Select
	'03'+'003743','03','OB' + Convert(Varchar(10),'2023-06-25'),'2023-06-25',Rtrim(I.Supp_Code),Null,'StkUp'
	,Rtrim(I.Item_Code),'Each','1',IsNull(S.Qty,0),IsNull(S.Qty,0),s.Price,D.Cost_Price,D.Cost_price,0,'OPB',GetDate(),1,Null
From tb_DwnStock As S Join tb_Item As I On S.ItemCode = I.Item_Code Join tb_ItemDet As D On 
S.ItemCode = D.Item_Code Where D.Loca_Code = '03'


--8.Insert Price Change For Valuation Report
Insert Into tb_PriceChange([ItemCode],[ItemDescrip],[LocaCode],[SuppCode],[Qty],[PackSize],[CostPrice],[ERetPrice],[PRetPrice]
,[EWholePrice],[PWholePrice],[NewCostPrice],[NewERetPrice],[NewPRetPrice],[NewEWholePrice],[NewPWholePrice],[CDate],[UserName]
,[CType],[CDatetime],[Status],[AvgCost],[NewAvgCost])
Select 	D.Item_Code,I.Descrip,'03',I.Supp_Code,0,I.Pack_Size,0,0,0,0,0,S.Cost,S.Price,D.PRet_Price,D.EWhole_Price
,D.PWhole_Price,'2023-06-25','EasyWay','ITC',GetDate(),1,S.Cost,S.Cost From tb_Item As I Join tb_ItemDet As D
On I.Item_Code=D.Item_Code Join tb_DwnStock As S On I.Item_Code=S.ItemCode Where D.Loca_Code='03'


--9.For Stock Variance Report
select * from tb_Stock_OpBal where LocaCode = '03'
delete from tb_Stock_OpBal where LocaCode = '03'
Insert Into tb_Stock_OpBal ([Idx],[SerialNo],[LocaCode],[RefNo],[PDate],[SuppCode],[RepCode],[TourCode],[ItemCode],[Scale],[PackSize],[Qty],[Balance],[Rate],[Cost],[RealCost],[Type],[ID],[CrDate],[Status],[IType],[BkpDate],[CNo])
	Select					[Idx],[SerialNo],[LocaCode],[RefNo],[PDate],[SuppCode],[RepCode],[TourCode],[ItemCode],[Scale],[PackSize],[Qty],[Balance],[Rate],[Cost],[RealCost],[Type],[ID],[CrDate],[Status],[IType],GetDate(),  0 
From tb_Stock Where LocaCode = '03' And Status = '1' and BatchNo='E004'
							

select * from tb_Stock_Backup where LocaCode = '03'
delete from tb_Stock_Backup where LocaCode = '03'
Insert Into tb_Stock_Backup ([Idx],[SerialNo],[LocaCode],[RefNo],[PDate],[SuppCode],[RepCode],[TourCode],[ItemCode],[Scale],[PackSize],[Qty],[Balance],[Rate],[Cost],[RealCost],[Type],[ID],[CrDate],[Status],[IType],[BkpDate],[CNo])
	Select					 [Idx],[SerialNo],[LocaCode],[RefNo],[PDate],[SuppCode],[RepCode],[TourCode],[ItemCode],[Scale],[PackSize],[Qty],[Balance],[Rate],[Cost],[RealCost],[Type],[ID],[CrDate],'1',[IType],GetDate(),  0 
From tb_Stock Where LocaCode = '03' And Status = '9' and  TourCode = 'STK13/23'


--10.For View Stock Adjestment Report

Insert Into tb_StAdjDet	([SerialNo],[LocaCode],[RefNo] ,[IDate]     ,[SuppCode] ,[ItemCode],[ItemDescrip],[Scale],[Remark],[Cost]      ,[Rate]      ,[Qty],[CostValue]         ,[RetValue]          ,[TrDate] ,[ID] ,[Status],[LnNo],[PackSize],[ExpDate],[BatchNo])
Select	 	             '03003743',   '03'   ,'OPBSTK','2023-06-25',I.Supp_Code,D.ItemCode,I.Inv_Descrip,'Each' ,'StockUP' ,E.Cost_Price,E.ERet_Price,D.Qty,(D.Qty*E.Cost_Price),(D.Qty*E.ERet_Price),GetDate(),'OPB',   '1'  ,  '1' ,    '1'   ,    ''   ,   ''
From tb_ItemDet As E Join tb_DwnStock As D On E.Item_Code = D.ItemCode Join tb_Item As I On D.ItemCode = I.Item_Code
Where E.Loca_Code = '03' 


Insert Into tb_StAdjSumm ([SerialNo],[LocaCode],[RefNo]       ,[IDate]     ,[CostValue]   ,[RetValue]   ,[Id] ,[Type],[Status],[TrDate] ,[UserName])			
Select 					  '03003743',   '03'   ,'OP2023-06-25','2023-06-25',Sum(CostValue),Sum(RetValue),'OPB',  '1' ,   '1'  ,GetDate(),  'Sarasa'
From tb_StAdjDet Where LocaCode = '03' And SerialNo = '03003743'

----
