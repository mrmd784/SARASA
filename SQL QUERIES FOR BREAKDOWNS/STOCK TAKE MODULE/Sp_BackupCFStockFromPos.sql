USE [EASYWAY]
GO

/****** Object:  StoredProcedure [dbo].[Sp_BackupCFStockFromPos]    Script Date: 2024-03-01 11:38:36 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



ALTER Proc [dbo].[Sp_BackupCFStockFromPos]
@Loca		Char(5),
@Type		Int,
@Id			Char(5),
@UName		Char(15),
@From		Varchar(25),
@To			VarChar(25),
@REFNO		VARCHAR(10)

AS
Declare @Serial Varchar(10)
Declare @Dete	Datetime
Declare @CNo	Int
Set @Dete	= Convert(Datetime,Convert(Varchar,GetDate(),103),103)
Set @Serial	= Convert(Varchar,getDate(),112)

Drop table tb_DwnStock

CREATE TABLE [dbo].[tb_DwnStock](
	[ItemCode] [varchar](25) NULL,
	[Loca] [char](5) NULL,
	[Qty] [decimal](18, 4) NULL,
	[Balance] [decimal](12, 4) NULL,
	[Cost] [money] NOT NULL CONSTRAINT [DF__tb_DwnStoc__Cost__3DFE09A7]  DEFAULT ((0)),
	[Price] [money] NOT NULL CONSTRAINT [DF__tb_DwnSto__Price__3EF22DE0]  DEFAULT ((0)),
	[CSCode] [varchar](50) NULL,
	[TypeId] [int] NULL
) ON [PRIMARY]

Truncate Table tb_DwnStock
		
Insert Into tb_DwnStock (ItemCode,CSCode,Loca,Qty,Balance,Cost,Price,TypeId) 
Select ItemCode,RefCode,@Loca,Isnull(Sum(Case Iid When '001' Then Qty*Isnull(PackSize,1)*Isnull(PackScale,1) When '002' Then -Qty*Isnull(PackSize,1)*Isnull(PackScale,1) Else 0 End),0),0,0,0,0 From 
tbPosTransact Where [Status]=1 And SaleType='S' And Upload='S' and loca=@Loca
Group By ItemCode,RefCode

Insert Into tb_DwnStock (ItemCode,Loca,Qty,Balance,Cost,Price) Select Item_Code,@Loca,0,0,0,0 From tb_item Where Item_Code Not In (Select ItemCode From  tb_DwnStock)

Update tb_DwnStock Set tb_DwnStock.TypeId=tb_Item.Use_Exp From tb_DwnStock Join tb_Item On tb_DwnStock.ItemCode=tb_Item.Item_Code

--Read From Data Collector
/*
Create Table #StkDc (ItemCode Varchar(25) Null,Qty Decimal(12,4) Null)
Insert Into #StkDc (ItemCode,Qty) Select ItemCode,Sum(Isnull(Qty,0)) From tb_DwnStockDc Group By ItemCode

Update tb_DwnStock Set tb_DwnStock.Qty=tb_DwnStock.Qty+#StkDc.Qty From tb_DwnStock Join  #StkDc On tb_DwnStock.ItemCode= #StkDc.ItemCode

Insert Into tb_DwnStock (ItemCode,Loca,Qty,Balance,Cost,Price) Select ItemCode,@Loca,Qty,Qty,0,0 From #StkDc Where ItemCode Not In (Select ItemCode From  tb_DwnStock)

Truncate Table tb_DwnStockDc
*/

--End Read Data Collector
Delete From tb_Stock_OpBal Where CNo=0 And LocaCode=@Loca
IF @Type=1 --Range
Begin
	If @Id='OCT'
	Begin
		Insert Into tb_Stock_OpBal ([Idx],[SerialNo],[LocaCode],[RefNo],[PDate],[SuppCode],[RepCode],[TourCode]
		,[ItemCode],[Scale],[PackSize],[Qty],[Balance],[Rate],[Cost],[RealCost],[Type],[ID],[CrDate],[Status]
		,[IType],[BkpDate],[CNo],[BatchNo],[CsCode],[StockCountRef],[SupplierName],[CategoryCode],[CategoryName],[SubCategoryCode],[SubCategoryName])
		Select 1,@Serial,@Loca,@Serial,@Dete,tb_Item.Supp_Code,Null,Null,tb_DwnStock.ItemCode,'Eack',1
		,tb_DwnStock.Qty,tb_DwnStock.Qty,tb_ItemDet.ERet_Price,tb_ItemDet.Cost_Price,tb_ItemDet.Cost_Price,0,'OPB',GetDate(),1
		,Null,GetDate(),0,CsCode
		,Case When tb_DwnStock.TypeId=3 Then tb_DwnStock.CsCode Else '' End,  @REFNO ,'',tb_Item.Cat_Code,'',tb_Item.SubCat_Code,''
		From (tb_DwnStock Join tb_Item On tb_DwnStock.ItemCode=tb_Item.Item_Code) Join tb_ItemDet 
		On tb_ItemDet.Item_Code=tb_Item.Item_Code And tb_ItemDet.Loca_Code=tb_DwnStock.Loca
 		Where tb_ItemDet.Loca_Code=@Loca And tb_DwnStock.Loca=@Loca And tb_DwnStock.ItemCode 
 		In (Select Item_Code From tb_Item Where Cat_Code Between @From And @To) 
	End
	Else If @Id='OSC'
	Begin
		Insert Into tb_Stock_OpBal ([Idx],[SerialNo],[LocaCode],[RefNo],[PDate],[SuppCode],[RepCode],[TourCode]
		,[ItemCode],[Scale],[PackSize],[Qty],[Balance],[Rate],[Cost],[RealCost],[Type],[ID],[CrDate],[Status]
		,[IType],[BkpDate],[CNo],[BatchNo],[CsCode],[StockCountRef],[SupplierName],[CategoryCode],[CategoryName],[SubCategoryCode],[SubCategoryName])
		Select 1,@Serial,@Loca,@Serial,@Dete,tb_Item.Supp_Code,Null,Null,tb_DwnStock.ItemCode,'Eack',1
		,tb_DwnStock.Qty,tb_DwnStock.Qty,tb_ItemDet.ERet_Price,tb_ItemDet.Cost_Price,tb_ItemDet.Cost_Price,0,'OPB',GetDate(),1
		,Null,GetDate(),0,CsCode
		,Case When tb_DwnStock.TypeId=3 Then tb_DwnStock.CsCode Else '' End,  @REFNO ,'',tb_Item.Cat_Code,'',tb_Item.SubCat_Code,''
		From (tb_DwnStock Join tb_Item On tb_DwnStock.ItemCode=tb_Item.Item_Code) Join tb_ItemDet 
		On tb_ItemDet.Item_Code=tb_Item.Item_Code And tb_ItemDet.Loca_Code=tb_DwnStock.Loca
 		Where tb_ItemDet.Loca_Code=@Loca And tb_DwnStock.Loca=@Loca And tb_DwnStock.ItemCode 
 		In (Select Item_Code From tb_Item Where SubCat_Code Between @From And @To) 
	End
	Else If @Id='OIT'
	Begin
		Insert Into tb_Stock_OpBal ([Idx],[SerialNo],[LocaCode],[RefNo],[PDate],[SuppCode],[RepCode],[TourCode]
		,[ItemCode],[Scale],[PackSize],[Qty],[Balance],[Rate],[Cost],[RealCost],[Type],[ID],[CrDate],[Status]
		,[IType],[BkpDate],[CNo],[BatchNo],[CsCode],[StockCountRef],[SupplierName],[CategoryCode],[CategoryName],[SubCategoryCode],[SubCategoryName])
		Select 1,@Serial,@Loca,@Serial,@Dete,tb_Item.Supp_Code,Null,Null,tb_DwnStock.ItemCode,'Eack',1
		,tb_DwnStock.Qty,tb_DwnStock.Qty,tb_ItemDet.ERet_Price,tb_ItemDet.Cost_Price,tb_ItemDet.Cost_Price,0,'OPB',GetDate(),1
		,Null,GetDate(),0,CsCode
		,Case When tb_DwnStock.TypeId=3 Then tb_DwnStock.CsCode Else '' End,  @REFNO ,'',tb_Item.Cat_Code,'',tb_Item.SubCat_Code,''
		From (tb_DwnStock Join tb_Item On tb_DwnStock.ItemCode=tb_Item.Item_Code) Join tb_ItemDet 
		On tb_ItemDet.Item_Code=tb_Item.Item_Code And tb_ItemDet.Loca_Code=tb_DwnStock.Loca
 		Where tb_ItemDet.Loca_Code=@Loca And tb_DwnStock.Loca=@Loca And tb_DwnStock.ItemCode Between @From And @To		
	End
	Else If @Id='OSP'
	Begin
		Insert Into tb_Stock_OpBal ([Idx],[SerialNo],[LocaCode],[RefNo],[PDate],[SuppCode],[RepCode],[TourCode]
		,[ItemCode],[Scale],[PackSize],[Qty],[Balance],[Rate],[Cost],[RealCost],[Type],[ID],[CrDate],[Status]
		,[IType],[BkpDate],[CNo],[BatchNo],[CsCode],[StockCountRef],[SupplierName],[CategoryCode],[CategoryName],[SubCategoryCode],[SubCategoryName])
		Select 1,@Serial,@Loca,@Serial,@Dete,tb_Item.Supp_Code,Null,Null,tb_DwnStock.ItemCode,'Eack',1
		,tb_DwnStock.Qty,tb_DwnStock.Qty,tb_ItemDet.ERet_Price,tb_ItemDet.Cost_Price,tb_ItemDet.Cost_Price,0,'OPB',GetDate(),1
		,Null,GetDate(),0,CsCode
		,Case When tb_DwnStock.TypeId=3 Then tb_DwnStock.CsCode Else '' End,  @REFNO ,'',tb_Item.Cat_Code,'',tb_Item.SubCat_Code,''
		From (tb_DwnStock Join tb_Item On tb_DwnStock.ItemCode=tb_Item.Item_Code) Join tb_ItemDet 
		On tb_ItemDet.Item_Code=tb_Item.Item_Code And tb_ItemDet.Loca_Code=tb_DwnStock.Loca
 		Where tb_ItemDet.Loca_Code=@Loca And tb_DwnStock.Loca=@Loca And tb_DwnStock.ItemCode
 		In (Select Item_Code From tb_Item Where Supp_Code Between @From And @To) 
	End
	Else If @Id='OBN'
	Begin
		Insert Into tb_Stock_OpBal ([Idx],[SerialNo],[LocaCode],[RefNo],[PDate],[SuppCode],[RepCode],[TourCode]
		,[ItemCode],[Scale],[PackSize],[Qty],[Balance],[Rate],[Cost],[RealCost],[Type],[ID],[CrDate],[Status]
		,[IType],[BkpDate],[CNo],[BatchNo],[CsCode],[StockCountRef],[SupplierName],[CategoryCode],[CategoryName],[SubCategoryCode],[SubCategoryName])
		Select 1,@Serial,@Loca,@Serial,@Dete,tb_Item.Supp_Code,Null,Null,tb_DwnStock.ItemCode,'Eack',1
		,tb_DwnStock.Qty,tb_DwnStock.Qty,tb_ItemDet.ERet_Price,tb_ItemDet.Cost_Price,tb_ItemDet.Cost_Price,0,'OPB',GetDate(),1
		,Null,GetDate(),0,CsCode
		,Case When tb_DwnStock.TypeId=3 Then tb_DwnStock.CsCode Else '' End,  @REFNO ,'',tb_Item.Cat_Code,'',tb_Item.SubCat_Code,''
		From (tb_DwnStock Join tb_Item On tb_DwnStock.ItemCode=tb_Item.Item_Code) Join tb_ItemDet 
		On tb_ItemDet.Item_Code=tb_Item.Item_Code And tb_ItemDet.Loca_Code=tb_DwnStock.Loca
 		Where tb_ItemDet.Loca_Code=@Loca And tb_DwnStock.Loca=@Loca And tb_DwnStock.ItemCode
 		In (Select Item_Code From tb_Item Where BinNo Between @From And @To) 
	End
End
Else
Begin
	If @Id='OCT'
	Begin
		Insert Into tb_Stock_OpBal ([Idx],[SerialNo],[LocaCode],[RefNo],[PDate],[SuppCode],[RepCode],[TourCode]
		,[ItemCode],[Scale],[PackSize],[Qty],[Balance],[Rate],[Cost],[RealCost],[Type],[ID],[CrDate],[Status]
		,[IType],[BkpDate],[CNo],[BatchNo],[CsCode],[StockCountRef],[SupplierName],[CategoryCode],[CategoryName],[SubCategoryCode],[SubCategoryName])
		Select 1,@Serial,@Loca,@Serial,@Dete,tb_Item.Supp_Code,Null,Null,tb_DwnStock.ItemCode,'Eack',1
		,tb_DwnStock.Qty,tb_DwnStock.Qty,tb_ItemDet.ERet_Price,tb_ItemDet.Cost_Price,tb_ItemDet.Cost_Price,0,'OPB',GetDate(),1
		,Null,GetDate(),0,CsCode
		,Case When tb_DwnStock.TypeId=3 Then tb_DwnStock.CsCode Else '' End,  @REFNO ,'',tb_Item.Cat_Code,'',tb_Item.SubCat_Code,''
		From (tb_DwnStock Join tb_Item On tb_DwnStock.ItemCode=tb_Item.Item_Code) Join tb_ItemDet 
		On tb_ItemDet.Item_Code=tb_Item.Item_Code And tb_ItemDet.Loca_Code=tb_DwnStock.Loca
 		Where tb_ItemDet.Loca_Code=@Loca And tb_DwnStock.Loca=@Loca And tb_DwnStock.ItemCode In 
 		(Select Item_Code From tb_Item Where Cat_Code In (Select Code From tb_TempSelect Where UserName=@Uname And [ID]=@Id And LocaCode=@Loca))
	End
	Else If @Id='OSC'
	Begin
		Insert Into tb_Stock_OpBal ([Idx],[SerialNo],[LocaCode],[RefNo],[PDate],[SuppCode],[RepCode],[TourCode]
		,[ItemCode],[Scale],[PackSize],[Qty],[Balance],[Rate],[Cost],[RealCost],[Type],[ID],[CrDate],[Status]
		,[IType],[BkpDate],[CNo],[BatchNo],[CsCode],[StockCountRef],[SupplierName],[CategoryCode],[CategoryName],[SubCategoryCode],[SubCategoryName])
		Select 1,@Serial,@Loca,@Serial,@Dete,tb_Item.Supp_Code,Null,Null,tb_DwnStock.ItemCode,'Eack',1
		,tb_DwnStock.Qty,tb_DwnStock.Qty,tb_ItemDet.ERet_Price,tb_ItemDet.Cost_Price,tb_ItemDet.Cost_Price,0,'OPB',GetDate(),1
		,Null,GetDate(),0,CsCode
		,Case When tb_DwnStock.TypeId=3 Then tb_DwnStock.CsCode Else '' End,  @REFNO ,'',tb_Item.Cat_Code,'',tb_Item.SubCat_Code,''
		From (tb_DwnStock Join tb_Item On tb_DwnStock.ItemCode=tb_Item.Item_Code) Join tb_ItemDet 
		On tb_ItemDet.Item_Code=tb_Item.Item_Code And tb_ItemDet.Loca_Code=tb_DwnStock.Loca
 		Where tb_ItemDet.Loca_Code=@Loca And tb_DwnStock.Loca=@Loca And tb_DwnStock.ItemCode In 
 		(Select Item_Code From tb_Item Where SubCat_Code In (Select Code From tb_TempSelect Where UserName=@Uname And [ID]=@Id And LocaCode=@Loca))
	End
	Else If @Id='OIT'
	Begin
		Insert Into tb_Stock_OpBal ([Idx],[SerialNo],[LocaCode],[RefNo],[PDate],[SuppCode],[RepCode],[TourCode]
		,[ItemCode],[Scale],[PackSize],[Qty],[Balance],[Rate],[Cost],[RealCost],[Type],[ID],[CrDate],[Status]
		,[IType],[BkpDate],[CNo],[BatchNo],[CsCode],[StockCountRef],[SupplierName],[CategoryCode],[CategoryName],[SubCategoryCode],[SubCategoryName])
		Select 1,@Serial,@Loca,@Serial,@Dete,tb_Item.Supp_Code,Null,Null,tb_DwnStock.ItemCode,'Eack',1
		,tb_DwnStock.Qty,tb_DwnStock.Qty,tb_ItemDet.ERet_Price,tb_ItemDet.Cost_Price,tb_ItemDet.Cost_Price,0,'OPB',GetDate(),1
		,Null,GetDate(),0,CsCode
		,Case When tb_DwnStock.TypeId=3 Then tb_DwnStock.CsCode Else '' End,  @REFNO ,'',tb_Item.Cat_Code,'',tb_Item.SubCat_Code,''
		From (tb_DwnStock Join tb_Item On tb_DwnStock.ItemCode=tb_Item.Item_Code) Join tb_ItemDet 
		On tb_ItemDet.Item_Code=tb_Item.Item_Code And tb_ItemDet.Loca_Code=tb_DwnStock.Loca
 		Where tb_ItemDet.Loca_Code=@Loca And tb_DwnStock.Loca=@Loca And tb_DwnStock.ItemCode IN (Select Code From tb_TempSelect Where UserName=@Uname And [ID]=@Id And LocaCode=@Loca) 
	End
	Else If @Id='OSP'
	Begin
		Insert Into tb_Stock_OpBal ([Idx],[SerialNo],[LocaCode],[RefNo],[PDate],[SuppCode],[RepCode],[TourCode]
		,[ItemCode],[Scale],[PackSize],[Qty],[Balance],[Rate],[Cost],[RealCost],[Type],[ID],[CrDate],[Status]
		,[IType],[BkpDate],[CNo],[BatchNo],[CsCode],[StockCountRef],[SupplierName],[CategoryCode],[CategoryName],[SubCategoryCode],[SubCategoryName])
		Select 1,@Serial,@Loca,@Serial,@Dete,tb_Item.Supp_Code,Null,Null,tb_DwnStock.ItemCode,'Eack',1
		,tb_DwnStock.Qty,tb_DwnStock.Qty,tb_ItemDet.ERet_Price,tb_ItemDet.Cost_Price,tb_ItemDet.Cost_Price,0,'OPB',GetDate(),1
		,Null,GetDate(),0,CsCode
		,Case When tb_DwnStock.TypeId=3 Then tb_DwnStock.CsCode Else '' End,  @REFNO ,'',tb_Item.Cat_Code,'',tb_Item.SubCat_Code,''
		From (tb_DwnStock Join tb_Item On tb_DwnStock.ItemCode=tb_Item.Item_Code) Join tb_ItemDet 
		On tb_ItemDet.Item_Code=tb_Item.Item_Code And tb_ItemDet.Loca_Code=tb_DwnStock.Loca
 		Where tb_ItemDet.Loca_Code=@Loca And tb_DwnStock.Loca=@Loca And tb_DwnStock.ItemCode In 
 		(Select Item_Code From tb_Item Where Supp_Code In (Select Code From tb_TempSelect Where UserName=@Uname And [ID]=@Id And LocaCode=@Loca)) 
	End
End

				
UPDATE tb_Stock_OpBal SET [SupplierName]=tb_Supplier.Supp_Name,[CategoryName]=tb_Category.Cat_Name,[SubCategoryName]=tb_SubCategory.SubCat_Code
FROM tb_Stock_OpBal INNER JOIN tb_Supplier ON tb_Stock_OpBal.SuppCode=tb_Supplier.Supp_Code
INNER JOIN tb_Category ON tb_Stock_OpBal.CategoryCode=tb_Category.Cat_Code
INNER JOIN tb_SubCategory ON  tb_Stock_OpBal.SubCategoryCode = tb_SubCategory.SubCat_Code

Truncate Table tb_DwnStock




GO

