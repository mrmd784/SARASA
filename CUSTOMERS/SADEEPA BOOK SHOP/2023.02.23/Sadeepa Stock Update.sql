
--Stock Update As Opening Stock

--Check DataTransfer Ok Or Not
select *  from tbPostransact where loca='07' and Upload is null
select Distinct Loca,UnitNo,zno from tbPostransact where loca='07' and Upload is null

Select Unit,loca, Isnull(Sum(Case Iid When '001' Then Nett
 When '002' Then -Nett Else 0 End),0) AS Nett  From tbPosTransact 
Where Status=1 And SaleType='S' And Upload='B' and loca='07' group by Unit,Loca
--Net 1099814.00

Select Isnull(Sum(Case Iid When '001' Then qty
When '002' Then -Qty Else 0 End),0) AS qty  From tbPosTransact 
Where Status=1 And SaleType='S' And Upload='B' and loca='07'
--QTY 13816

---Change Upload Staus(For Not Update as sale)
select Distinct Upload from tbPostransact where loca='07'

update tbPostransact set Upload='B' where loca='07' and Upload is null and ZNo in('22')
update tbPospayment set Upload='B' where loca='07' and Upload is null and ZNo in('22')


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

//
--1.
Insert Into tb_DwnStock(Qty,ItemCode,Cost,Price,Nett) 
Select  IsNull(Sum(Case When IID = '001' Then Qty When IID='002' Then -Qty End),0) As Qty,ItemCode,Cost,Price,0
From tbPostransact Where Upload='B'  And loca='07' and  Status = '1' Group By ItemCode,Cost,Price

--2.(Check Item not in easyway)
select * from tbPostransact Where Loca = '07' and Upload = 'B' and ItemCode not in(select item_code from tb_Item)

--3.
Update tb_DwnStock Set Nett = (Qty * Price)
Select SUM(Nett) From tb_DwnStock  ---1099814.00

--4.Update Document no for Stock Adjestment
Select * From tb_System Where LocaCode = '07'    --3
update tb_System set OPB='4' Where LocaCode = '07'

--5.Check If There Any Transactions After Stock Take
Select * From tb_Stock Where LocaCode = '07' And Status = '1' order by pdate

--6.Stock Zero
Update tb_Stock Set Status = '9', TourCode = 'STK23/23' Where LocaCode = '07' And Status = '1' 
--and PDate>'2023-01-31'

--7. Insert Stock 
--If there is a trigger in tb_stock table run this
--update tb_Item set Countable='1' where Countable='0'

Insert Into tb_Stock ([SerialNo],[LocaCode],[RefNo],[PDate],[SuppCode],[RepCode],[TourCode],
	[ItemCode],[Scale],[PackSize],[Qty],[Balance],[Rate],[Retprice],[Cost],[RealCost],[Type],[ID],[CrDate],[Status],[IType])
Select
	'07'+'000004','07','OB' + Convert(Varchar(10),'2023-02-23'),'2023-02-23',Rtrim
	(I.Supp_Code),Null,'StkUp',Rtrim(I.Item_Code),'Each','1'
	,IsNull(S.Qty,0),IsNull(S.Qty,0),s.Price,s.Price,D.Cost_Price,D.Cost_price,0,'OPB',GetDate(),1,Null 
From tb_DwnStock As S Join tb_Item As I On S.ItemCode = I.Item_Code Join tb_ItemDet As D On 
S.ItemCode = D.Item_Code Where D.Loca_Code = '07'


--8.Insert Price Change For Valuation Report
Insert Into tb_PriceChange([ItemCode],[ItemDescrip],[LocaCode],[SuppCode],[Qty],[PackSize],[CostPrice],[ERetPrice],[PRetPrice]
,[EWholePrice],[PWholePrice],[NewCostPrice],[NewERetPrice],[NewPRetPrice],[NewEWholePrice],[NewPWholePrice],[CDate],[UserName]
,[CType],[CDatetime],[Status],[AvgCost],[NewAvgCost])
Select 	D.Item_Code,I.Descrip,'07',I.Supp_Code,0,I.Pack_Size,0,0,0,0,0,S.Cost,S.Price,D.PRet_Price,D.EWhole_Price
,D.PWhole_Price,'2023-02-23','EasyWay','ITC',GetDate(),1,S.Cost,S.Cost From tb_Item As I Join tb_ItemDet As D
On I.Item_Code=D.Item_Code Join tb_DwnStock As S On I.Item_Code=S.ItemCode Where D.Loca_Code='07'


--9.For Stock Variance Report
select * from tb_Stock_OpBal where LocaCode = '07'
delete from tb_Stock_OpBal where LocaCode = '07'
Insert Into tb_Stock_OpBal ([Idx],[SerialNo],[LocaCode],[RefNo],[PDate],[SuppCode],[RepCode],[TourCode],[ItemCode],[Scale],[PackSize],[Qty],[Balance],[Rate],[Cost],[RealCost],[Type],[ID],[CrDate],[Status],[IType],[BkpDate],[CNo])
	Select					[Idx],[SerialNo],[LocaCode],[RefNo],[PDate],[SuppCode],[RepCode],[TourCode],[ItemCode],[Scale],[PackSize],[Qty],[Balance],[Rate],[Cost],[RealCost],[Type],[ID],[CrDate],[Status],[IType],GetDate(),  0 
From tb_Stock Where LocaCode = '07' And Status = '1'
							

select * from tb_Stock_Backup where LocaCode = '07'
delete from tb_Stock_Backup where LocaCode = '07'
Insert Into tb_Stock_Backup ([Idx],[SerialNo],[LocaCode],[RefNo],[PDate],[SuppCode],[RepCode],[TourCode],[ItemCode],[Scale],[PackSize],[Qty],[Balance],[Rate],[Cost],[RealCost],[Type],[ID],[CrDate],[Status],[IType],[BkpDate],[CNo])
	Select					 [Idx],[SerialNo],[LocaCode],[RefNo],[PDate],[SuppCode],[RepCode],[TourCode],[ItemCode],[Scale],[PackSize],[Qty],[Balance],[Rate],[Cost],[RealCost],[Type],[ID],[CrDate],'1',[IType],GetDate(),  0 
From tb_Stock Where LocaCode = '07' And Status = '9' and  TourCode = 'STK23/23'


--10.For View Stock Adjestment Report

Insert Into tb_StAdjDet	([SerialNo],[LocaCode],[RefNo] ,[IDate]     ,[SuppCode] ,[ItemCode],[ItemDescrip],[Scale],[Remark],[Cost]      ,[Rate]      ,[Qty],[CostValue]         ,[RetValue]          ,[TrDate] ,[ID] ,[Status],[LnNo],[PackSize],[ExpDate],[BatchNo])
Select	 	             '07000004',   '07'   ,'OPBSTK','2023-02-23',I.Supp_Code,D.ItemCode,I.Inv_Descrip,'Each' ,'StockUP' ,E.Cost_Price,E.ERet_Price,D.Qty,(D.Qty*E.Cost_Price),(D.Qty*E.ERet_Price),GetDate(),'OPB',   '1'  ,  '1' ,    '1'   ,    ''   ,   ''
From tb_ItemDet As E Join tb_DwnStock As D On E.Item_Code = D.ItemCode Join tb_Item As I On D.ItemCode = I.Item_Code
Where E.Loca_Code = '07' 


Insert Into tb_StAdjSumm ([SerialNo],[LocaCode],[RefNo]       ,[IDate]     ,[CostValue]   ,[RetValue]   ,[Id] ,[Type],[Status],[TrDate] ,[UserName])			
Select 					  '07000004',   '07'   ,'OP2023-02-23','2023-02-23',Sum(CostValue),Sum(RetValue),'OPB',  '1' ,   '1'  ,GetDate(),  'Sarasa'
From tb_StAdjDet Where LocaCode = '07' And SerialNo = '07000004'
----
