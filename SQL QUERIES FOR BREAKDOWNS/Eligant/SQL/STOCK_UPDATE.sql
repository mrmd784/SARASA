

---------------------------------------

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

//

Truncate Table tb_DwnStock
Select * From tb_DwnStock
SELECT SUM(Stock) FROM EASYWAY.DBO.Vw_Stock WHERE LocaCode ='99' 
//
Insert Into tb_DwnStock(Qty,ItemCode,Cost,Price,Nett) 
Select  Stock,ItemCode,0,0,0
FROM EASYWAY.DBO.Vw_Stock WHERE LocaCode ='99'

Update tb_DwnStock Set Nett = (Qty * Price)
Select SUM(Nett) From tb_DwnStock
Select SUM(Qty) From tb_DwnStock


--------------------------------
SELECT * FROM tb_Location 

SELECT * FROM tb_Stock
--DELETE FROM tb_Stock 
--------------------------------
--DELETE FROM [dbo].[tb_TempAdjust]
SELECT * FROM [dbo].[tb_TempAdjust] WHERE LocaCode='99'



SELECT * FROM  tb_DwnStock
UPDATE tb_DwnStock SET Loca='99'

Insert Into [tb_TempAdjust] ([SerialNo],[LocaCode],[SuppCode],[ItemCode],[Stock],[ID],
					  [Scale],[PackSize],[ItemDescrip])
			Select	
					  '0-EASYW9377','99',I.Supp_Code,V.ItemCode,V.QTY,'OPB',
					  'Each','1',I.INV_DESCRIP
From tb_ItemDet As D Join tb_DwnStock As V On D.Item_Code = V.ItemCode AND D.LOCA_CODE='99' Join tb_Item As I On I.Item_Code = V.ItemCode
Where V.LOCA = '99'


UPDATE [dbo].[tb_TempAdjust] SET Remark='',RemarkExp='',CSCode='',CSName='',adjRemark=''
WHERE LocaCode='99' AND ID='OPB'

UPDATE tb_TempAdjust SET tb_TempAdjust.CostPrice=tb_ItemDet.Cost_Price,tb_TempAdjust.RetPrice=tb_ItemDet.ERet_Price,tb_TempAdjust.CostValue=(tb_TempAdjust.Stock)*tb_TempAdjust.CostPrice,
						tb_TempAdjust.RetValue	=(tb_TempAdjust.Stock)*tb_TempAdjust.RetPrice      
FROM         tb_TempAdjust INNER JOIN
                      tb_ItemDet ON tb_TempAdjust.ItemCode = tb_ItemDet.Item_Code





----------------------------
SELECT * FROM tb_PriceChange WHERE LocaCode ='99'
DELETE FROM tb_PriceChange WHERE LocaCode ='99'
DELETE FROM tb_PriceChange
--NEW--ALL ITEM----
Insert Into tb_PriceChange([ItemCode],[ItemDescrip],[LocaCode],[SuppCode],[Qty],[PackSize],[CostPrice],[ERetPrice],[PRetPrice]
,[EWholePrice],[PWholePrice],[NewCostPrice],[NewERetPrice],[NewPRetPrice],[NewEWholePrice],[NewPWholePrice],[CDate],[UserName]
,[CType],[CDatetime],[Status],[AvgCost],[NewAvgCost])
Select 	D.Item_Code,I.Descrip,'99',I.Supp_Code,0,I.Pack_Size,0,0,0,0,0,D.Cost_Price,D.ERet_Price ,D.PRet_Price,D.EWhole_Price
,D.PWhole_Price,'2023-07-31','EasyWay','ITC',GetDate(),1,D.Cost_Price ,D.Cost_Price From tb_Item As I Join tb_ItemDet As D
On I.Item_Code=D.Item_Code  Where D.Loca_Code='99'
---------------

Insert Into tb_PriceChange (ItemCode, ItemDescrip, LocaCode, SuppCode, Qty, PackSize, CostPrice, ERetPrice, PRetPrice, EWholePrice, PWholePrice, NewCostPrice, NewERetPrice, NewPRetPrice, NewEWholePrice, 
                         NewPWholePrice, CDate, UserName, CType, CDatetime, Status, AvgCost, NewAvgCost, CSCode, CSName) 
Select                      ItemCode, ItemDescrip, LocaCode, SuppCode, Qty, PackSize, CostPrice, ERetPrice, PRetPrice, EWholePrice, PWholePrice, NewCostPrice, NewERetPrice, NewPRetPrice, NewEWholePrice, 
                         NewPWholePrice, CDate, UserName, CType, CDatetime, Status, AvgCost, NewAvgCost, '', '' From EASYWAY.dbo.tb_PriceChange WHERE LocaCode ='99'


