
--Stock Update As Opening Stock

--Check DataTransfer Ok Or Not
select *  from tbPosTransact2 where loca='01' and Upload='F' or Upload is null
select Distinct Loca,UnitNo,zno from tbPosTransact2 where loca='01' and Upload is null
--- u1 5, u5 1,u2 2197, u3 5, u4 4, u6 464, u7 5

select Distinct Loca,UnitNo,zno from tbPosTransact2 where loca='01' and Upload is null and ZNo in (5,1,2197,5,4,464,5)
select Distinct Loca,UnitNo,zno from tbPosTransact2 where loca='01' and Upload is null and ZNo = 5 and UnitNo in (1,3,7)
select Distinct Loca,UnitNo,zno from tbPosTransact2 where loca='01' and Upload is null and ZNo = 2197 and UnitNo = 2
select Distinct Loca,UnitNo,zno from tbPosTransact2 where loca='01' and Upload is null and ZNo = 4 and unitno = 4
select Distinct Loca,UnitNo,zno from tbPosTransact2 where loca='01' and Upload is null and ZNo = 1 and UnitNo = 5
select Distinct Loca,UnitNo,zno from tbPosTransact2 where loca='01' and Upload is null and ZNo = 464 and UnitNo = 6

update tbPosTransact2 set Upload='A' where loca='01' and Upload is null and ZNo in('5') and UnitNo in (1,3,7)
update tbPospayment set Upload='A' where loca='01' and Upload ='F' and ZNo in('5') and UnitNo in (1,3,7)
update tbPosTransact2 set Upload='A' where loca='01' and Upload is null and ZNo = 2197 and UnitNo = 2
update tbPospayment set Upload='A' where loca='01' and Upload ='F' and ZNo = 2197 and UnitNo = 2
update tbPosTransact2 set Upload='A' where loca='01' and Upload is null and ZNo = 4 and unitno = 4
update tbPospayment set Upload='A' where loca='01' and Upload ='F' and ZNo = 4 and unitno = 4
update tbPosTransact2 set Upload='A' where loca='01' and Upload is null and ZNo = 1 and UnitNo = 5
update tbPospayment set Upload='A' where loca='01' and Upload ='F' and ZNo = 1 and UnitNo = 5
update tbPosTransact2 set Upload='A' where loca='01' and Upload is null and ZNo = 464 and UnitNo = 6
update tbPospayment set Upload='A' where loca='01' and Upload ='F' and ZNo = 464 and UnitNo = 6




Select loca, Isnull(Sum(Case Iid When '001' Then Nett
 When '002' Then -Nett Else 0 End),0) AS Nett  From tbPosTransact2 
Where Status=1 And SaleType='S' And Upload='A' and loca='01' group by Loca
--3  	01   	36443153
--2  	01   	22165737
--6  	01   	37502220
--7  	01   	52233073
--1  	01   	8008388
--5  	01   	73086776.6
--4  	01   	84072778.96
-- total 313512126.56
Select Isnull(Sum(Case Iid When '001' Then qty
When '002' Then -Qty Else 0 End),0) AS qty  From tbPosTransact2 
Where Status=1 And SaleType='S' And Upload='A' and loca='01'
--QTY 262934

---Change Upload Staus(For Not Update as sale)
select Distinct Upload from tbPosTransact2 where loca='01'

update tbPosTransact2 set Upload='B' where loca='01' and Upload='F' and ZNo in('573')
update tbPospayment set Upload='B' where loca='01' and Upload='F' and ZNo in('573')


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
From tbPosTransact2 Where Upload='A'  And loca='01' and  Status = '1' Group By ItemCode,Cost,Price

--2.(Check Item not in easyway)
select * from tbPosTransact2 Where Loca = '01' and Upload = 'B' and ItemCode not in(select item_code from tb_Item)

--3.
Update tb_DwnStock Set Nett = (Qty * Price)
Select SUM(Nett) From tb_DwnStock  ---313573687.31

--4.Update Document no for Stock Adjestment
Select OPB,* From tb_System Where LocaCode = '01'    --2033
update tb_System set OPB='2034' Where LocaCode = '01'

--5.Check If There Any Transactions After Stock Take
Select * From tb_Stock Where LocaCode = '01' And Status = '1' order by pdate desc

--6.Stock Zero
Update tb_Stock Set Status = '9', TourCode = 'STK07/23' Where LocaCode = '01' And Status = '1' 
--and PDate>'2023-01-31'

--7. Insert Stock 
--If there is a trigger in tb_stock table run this
--update tb_Item set Countable='1' where Countable='0'

Insert Into tb_Stock ([SerialNo],[LocaCode],[RefNo],[PDate],[SuppCode],[RepCode],[TourCode],
	[ItemCode],[Scale],[PackSize],[Qty],[Balance],[Rate],[Cost],[RealCost],[Type],[ID],[CrDate],[Status],[IType])
Select
	'01'+'002034','01','OB' + Convert(Varchar(10),'2023-07-03'),'2023-07-03',Rtrim
	(I.Supp_Code),Null,'StkUp',Rtrim(I.Item_Code),'Each','1'
	,IsNull(S.Qty,0),IsNull(S.Qty,0),s.Price,D.Cost_Price,D.Cost_price,0,'OPB',GetDate(),1,Null 
From tb_DwnStock As S Join tb_Item As I On S.ItemCode = I.Item_Code Join tb_ItemDet As D On 
S.ItemCode = D.Item_Code Where D.Loca_Code = '01'


--8.Insert Price Change For Valuation Report
Insert Into tb_PriceChange([ItemCode],[ItemDescrip],[LocaCode],[SuppCode],[Qty],[PackSize],[CostPrice],[ERetPrice],[PRetPrice]
,[EWholePrice],[PWholePrice],[NewCostPrice],[NewERetPrice],[NewPRetPrice],[NewEWholePrice],[NewPWholePrice],[CDate],[UserName]
,[CType],[CDatetime],[Status],[AvgCost],[NewAvgCost])
Select 	D.Item_Code,I.Descrip,'01',I.Supp_Code,0,I.Pack_Size,0,0,0,0,0,S.Cost,S.Price,D.PRet_Price,D.EWhole_Price
,D.PWhole_Price,'2023-07-03','EasyWay','ITC',GetDate(),1,S.Cost,S.Cost From tb_Item As I Join tb_ItemDet As D
On I.Item_Code=D.Item_Code Join tb_DwnStock As S On I.Item_Code=S.ItemCode Where D.Loca_Code='01'


--9.For Stock Variance Report
select * from tb_Stock_OpBal where LocaCode = '01'
delete from tb_Stock_OpBal where LocaCode = '01'
Insert Into tb_Stock_OpBal ([Idx],[SerialNo],[LocaCode],[RefNo],[PDate],[SuppCode],[RepCode],[TourCode],[ItemCode],[Scale],[PackSize],[Qty],[Balance],[Rate],[Cost],[RealCost],[Type],[ID],[CrDate],[Status],[IType],[BkpDate],[CNo])
	Select					[Idx],[SerialNo],[LocaCode],[RefNo],[PDate],[SuppCode],[RepCode],[TourCode],[ItemCode],[Scale],[PackSize],[Qty],[Balance],[Rate],[Cost],[RealCost],[Type],[ID],[CrDate],[Status],[IType],GetDate(),  0 
From tb_Stock Where LocaCode = '01' And Status = '1'
							

select * from tb_Stock_Backup where LocaCode = '01'
delete from tb_Stock_Backup where LocaCode = '01'
Insert Into tb_Stock_Backup ([Idx],[SerialNo],[LocaCode],[RefNo],[PDate],[SuppCode],[RepCode],[TourCode],[ItemCode],[Scale],[PackSize],[Qty],[Balance],[Rate],[Cost],[RealCost],[Type],[ID],[CrDate],[Status],[IType],[BkpDate],[CNo])
	Select					 [Idx],[SerialNo],[LocaCode],[RefNo],[PDate],[SuppCode],[RepCode],[TourCode],[ItemCode],[Scale],[PackSize],[Qty],[Balance],[Rate],[Cost],[RealCost],[Type],[ID],[CrDate],'1',[IType],GetDate(),  0 
From tb_Stock Where LocaCode = '01' And Status = '9' and  TourCode = 'STK07/23'


--10.For View Stock Adjestment Report

Insert Into tb_StAdjDet	([SerialNo],[LocaCode],[RefNo] ,[IDate]     ,[SuppCode] ,[ItemCode],[ItemDescrip],[Scale],[Remark],[Cost]      ,[Rate]      ,[Qty],[CostValue]         ,[RetValue]          ,[TrDate] ,[ID] ,[Status],[LnNo],[PackSize],[ExpDate],[BatchNo])
Select	 	             '01002034',   '01'   ,'OPBSTK','2023-07-03',I.Supp_Code,D.ItemCode,I.Inv_Descrip,'Each' ,'StockUP' ,E.Cost_Price,E.ERet_Price,D.Qty,(D.Qty*E.Cost_Price),(D.Qty*E.ERet_Price),GetDate(),'OPB',   '1'  ,  '1' ,    '1'   ,    ''   ,   ''
From tb_ItemDet As E Join tb_DwnStock As D On E.Item_Code = D.ItemCode Join tb_Item As I On D.ItemCode = I.Item_Code
Where E.Loca_Code = '01' 


Insert Into tb_StAdjSumm ([SerialNo],[LocaCode],[RefNo]       ,[IDate]     ,[CostValue]   ,[RetValue]   ,[Id] ,[Type],[Status],[TrDate] ,[UserName])			
Select 					  '01002034',   '01'   ,'OP2023-07-03','2023-07-03',Sum(CostValue),Sum(RetValue),'OPB',  '1' ,   '1'  ,GetDate(),  'Sarasa'
From tb_StAdjDet Where LocaCode = '01' And SerialNo = '01002034'
----

