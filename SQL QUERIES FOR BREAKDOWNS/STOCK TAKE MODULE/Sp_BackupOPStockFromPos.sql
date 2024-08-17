USE [EASYWAY]
GO

/****** Object:  StoredProcedure [dbo].[Sp_BackupOPStockFromPos]    Script Date: 2024-03-01 11:39:47 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER Proc [dbo].[Sp_BackupOPStockFromPos]
@Loca		Char(5),
@Type		Int,
@Id			Char(5),
@UName		Char(15),
@From		Varchar(25),
@To			VarChar(25),
@REFNO		VARCHAR(10)
AS

Truncate Table tb_DwnStock
		
Insert Into tb_DwnStock (ItemCode,CSCode,Loca,Qty,Balance,Cost,Price,TypeId) 
Select ItemCode,RefNo,@Loca,Qty,Balance,Cost,Rate,0 From tb_Stock_OpBal where CNo=0 And Status=1
--Select ItemCode,RefCode,@Loca,Isnull(Sum(Case Iid When '001' Then Qty*Isnull(PackSize,1)*Isnull(PackScale,1) When '002' Then -Qty*Isnull(PackSize,1)*Isnull(PackScale,1) Else 0 End),0),Isnull(Sum(Case Iid When '001' Then Qty*Isnull(PackSize,1)*Isnull(PackScale,1) When '002' Then -Qty*Isnull(PackSize,1)*Isnull(PackScale,1) Else 0 End),0),0,0,0
--From tbPosTransact Where [Status]=1 And SaleType='S' And  Upload='S'  
--Group By ItemCode,RefCode

Update tb_DwnStock Set tb_DwnStock.TypeId=tb_Item.Use_Exp From tb_DwnStock Join tb_Item On tb_DwnStock.ItemCode=tb_Item.Item_Code

Insert Into tb_DwnStock (ItemCode,CScode ,Loca,Qty,Balance,Cost,Price,TypeId) 
select                   Item_Code,'',@Loca ,0,0 ,0,0,0 from tb_Item where Item_Code not in (select itemcode from tb_DwnStock )


--Insert Into tb_DwnStock (ItemCode,CSCode,Loca,Qty,Balance,Cost,Price,TypeId) 
--Select ItemCode,Case When TypeId=2 Then  CSCode When TypeId=3 Then  CSCode When TypeId=4 Then  CSCode Else '' End
--,Loca,Sum(Qty),Sum(Qty),0,0,TypeId From tb_DwnStock Where Balance =-1 
--Group By Loca,ItemCode,TypeId,Case When TypeId=2 Then  CSCode When TypeId=3 Then  CSCode When TypeId=4 Then  CSCode Else '' End

--Delete From tb_DwnStock Where Balance =-1

--Read From Data Collector
/*
Create Table #StkDc (ItemCode Varchar(25) Null,Qty Decimal(12,4) Null)
Insert Into #StkDc (ItemCode,Qty) Select ItemCode,Sum(Isnull(Qty,0)) From tb_DwnStockDc Group By ItemCode

Update tb_DwnStock Set tb_DwnStock.Qty=tb_DwnStock.Qty+#StkDc.Qty, tb_DwnStock.Balance=tb_DwnStock.Balance+#StkDc.Qty From tb_DwnStock Join  #StkDc On tb_DwnStock.ItemCode= #StkDc.ItemCode

Insert Into tb_DwnStock (ItemCode,Loca,Qty,Balance,Cost,Price) Select ItemCode,@Loca,Qty,Qty,0,0 From #StkDc Where ItemCode Not In (Select ItemCode From  tb_DwnStock)

Truncate Table tb_DwnStockDc

*/
--End Read Data Collector
Update tb_DwnStock Set tb_DwnStock.Cost=tb_itemDet.Cost_Price,tb_DwnStock.Price=tb_itemDet.ERet_Price From tb_ItemDet Join  tb_DwnStock On tb_ItemDet.Item_Code=tb_DwnStock.ItemCode  And  tb_ItemDet.Loca_Code=tb_DwnStock.Loca
--Update tb_DwnStock Set tb_DwnStock.Balance=tb_DwnStock.Balance-Vw_StockCS.Stock From Vw_StockCS Join  tb_DwnStock On Vw_StockCS.ItemCode=tb_DwnStock.ItemCode  And  Vw_StockCS.LocaCode=tb_DwnStock.Loca Where tb_DwnStock.TypeId =3
--Update tb_DwnStock Set tb_DwnStock.Balance=tb_DwnStock.Balance-Vw_StockNonCs.Stock From Vw_StockNonCs Join  tb_DwnStock On Vw_StockNonCs.ItemCode=tb_DwnStock.ItemCode  And  Vw_StockNonCs.LocaCode=tb_DwnStock.Loca Where tb_DwnStock.TypeId In (2,4)
Update tb_DwnStock Set tb_DwnStock.Balance=tb_DwnStock.Balance-vw_Stock.Stock From vw_Stock Join  tb_DwnStock On vw_Stock.ItemCode=tb_DwnStock.ItemCode  And  vw_Stock.LocaCode=tb_DwnStock.Loca Where tb_DwnStock.TypeId In (0,1)




IF @Type=1 --Range
Begin
	If @Id='OCT'
	Begin
		Delete From tb_DwnStock Where ItemCode Not In (Select Item_Code From tb_Item Where Cat_Code Between @From And @To)
	End
	Else If @Id='OSC'
	Begin
		Delete From tb_DwnStock Where ItemCode Not In (Select Item_Code From tb_Item Where SubCat_Code Between @From And @To)	
	End
	Else If @Id='OIT'
	Begin
		Delete From tb_DwnStock Where ItemCode Not Between @From And @To	
	End
	Else If @Id='OSP'
	Begin
		Delete From tb_DwnStock Where ItemCode Not In (Select Item_Code From tb_Item Where Supp_Code Between @From And @To)	
	End
	Else If @Id='OBN'
	Begin
		Delete From tb_DwnStock Where ItemCode Not In (Select Item_Code From tb_ItemDet Where BinNo Between @From And @To And Loca_Code=@Loca)	
	End
End
Else
Begin
	If @Id='OCT'
	Begin
		Delete From tb_DwnStock Where ItemCode Not In (Select Item_Code From tb_Item Where Cat_Code In (Select Code From tb_TempSelect Where UserName=@Uname And [ID]=@Id And LocaCode=@Loca))	
	End
	Else If @Id='OSC'
	Begin
		Delete From tb_DwnStock Where ItemCode Not In (Select Item_Code From tb_Item Where SubCat_Code In (Select Code From tb_TempSelect Where UserName=@Uname And [ID]=@Id And LocaCode=@Loca))	
	End
	Else If @Id='OIT'
	Begin
		Insert Into tb_DwnStock (ItemCode,CSCode,Loca,Qty,Balance,Cost,Price,TypeId) 
		Select Item_Code,'',@Loca,0,0,Cost_Price,ERet_Price,0 From tb_ItemDet where Item_Code 
		Not In (Select ItemCode From tb_DwnStock)  And Item_Code In (Select Code From tb_TempSelect Where UserName=@Uname And [ID]=@Id And LocaCode=@Loca)		
		Delete From tb_DwnStock Where ItemCode Not In (Select Code From tb_TempSelect Where UserName=@Uname  And LocaCode=@Loca And ID=@Id)		
	End
	Else If @Id='OSP'
	Begin
		Delete From tb_DwnStock Where ItemCode Not In (Select Item_Code From tb_Item Where Supp_Code In (Select Code From tb_TempSelect Where UserName=@Uname And [ID]=@Id And LocaCode=@Loca))		
	End
End

If Exists (Select Top 1 * From tb_DwnStock Where TypeId=4 And Qty>1)
Begin
	Select * From tb_DwnStock Where TypeId=4 And Qty>1
	return
End
Else If Exists (Select Top 1 * From tb_DwnStock Join tb_ItemSerial On tb_DwnStock.ItemCode=tb_ItemSerial.ItemCode And tb_DwnStock.CSCode=tb_ItemSerial.BatchNo  Where tb_DwnStock.TypeId=4 And tb_DwnStock.Qty>0 And tb_ItemSerial.Qty <>0 And tb_DwnStock.Loca =@Loca And tb_ItemSerial.LocaCode <>@Loca And tb_ItemSerial.[Status]=1)
Begin
	Select * From tb_DwnStock Join tb_ItemSerial On tb_DwnStock.ItemCode=tb_ItemSerial.ItemCode And tb_DwnStock.CSCode=tb_ItemSerial.BatchNo  Where tb_DwnStock.TypeId=4 And tb_DwnStock.Qty>0 And tb_ItemSerial.Qty <>0 And tb_DwnStock.Loca =@Loca And tb_ItemSerial.LocaCode <>@Loca And tb_ItemSerial.[Status]=1
	return
End
Else
Begin
	Declare @Serial		Varchar(10)
	Declare @Date		Datetime

	Declare @DFR 		As	Char(2)
	Declare @NextIdx 	As	Char(13)
	Declare @DocNo		As	Char(15)
	Declare	@ReceNo		As	Char(15)
	

	Set @Date= Convert(Datetime,Convert(Varchar,GetDate(),103),103)
	Set @Serial='STK ' + Convert(Varchar,getDate(),112)

	--Stock Add
	If Exists(Select * From tb_DwnStock Where Balance>0)
	Begin

	GetNextId: 
	Set @DFR	= ''
	Set @NextIdx	= 0
		Begin
			Select @DFR = Ref_Code FROM tb_Location WHERE Loca_Code = @Loca
						
			UPDATE tb_System SET OPB=OPB+1 WHERE LocaCode=@Loca
			
			Select @NextIdx = Cast(OPB As Char(6)) FROM tb_System WHERE LocaCode = @Loca
		
			Set @NextIdx = Replicate('0',6-Len(Rtrim(@NextIdx))) + Rtrim(@NextIdx)
			
			IF (@DFR Is Null)
				Begin
				Set  @DocNo= Rtrim(@NextIdx)	
				End 
			ELSE
				Begin
				Set  @DocNo= @DFR +  Rtrim(@NextIdx)	
				End
			
			IF Exists(Select SerialNo From tb_StAdjSumm Where SerialNo=@DocNo And LocaCode=@Loca  And ([Id]='OPB' Or [Id]='DMG' or [Id]='DSC' Or [Id]='ADD')) Goto GetNextId
		End 

		Insert Into tb_StAdjSumm([SerialNo],[LocaCode],[RefNo],[IDate],[CostValue],[RetValue],[Id],[Type],[Status],[TrDate],[UserName])
		Select @DocNo,@Loca,@Serial,@Date,Isnull(Sum(Balance*Cost),0),Isnull(Sum(Balance*Price),0),'ADD','',1,GetDate(),@UName  From tb_DwnStock Where Balance>0
		
		Insert Into tb_StAdjDet([LnNo],[SerialNo],[LocaCode],[IDate],[RefNo],[SuppCode],[ItemCode],[ItemDescrip],[Scale],[PackSize],[Cost],[Rate],[Qty],[CostValue],[RetValue],[TrDate],[ID],[Remark],[Status],[ExpDate],[BatchNo],[CsCode],[CSName],[AdjRemark])
		Select 1,@DocNo,@Loca,@Date,@Serial,tb_Item.Supp_Code,tb_DwnStock.ItemCode,tb_Item.Descrip,'EACH',1,tb_DwnStock.Cost,tb_DwnStock.Price,tb_DwnStock.Balance,tb_DwnStock.Balance*tb_DwnStock.Cost,tb_DwnStock.Balance*tb_DwnStock.Price,Getdate(),'ADD',TypeId,1,Null
		,CSCode,Case When TypeId=3 Then CSCode Else '' End,Case When TypeId=3 Then CSCode Else '' End,'STOCK'
		From tb_DwnStock Join tb_Item On tb_DwnStock.ItemCode=tb_item.Item_Code Where tb_DwnStock.Balance>0
			
		Insert Into tb_Stock ([SerialNo],[LocaCode],[RefNo],[PDate],[SuppCode],[RepCode],[TourCode],[ItemCode],[ExpDate],[BatchNo],[Scale],[PackSize]
		,[Qty],[Balance],[Rate],[Cost],[RealCost],[Type],[ID],[CrDate],[Status],[IType],[PosUnit],[BarcodeSerial],[RetPrice],[CSCode],[CSName])	
		Select @DocNo,@Loca,@Serial,@Date,tb_Item.Supp_Code,Null,Null,tb_DwnStock.ItemCode,Null,CSCode,'EACH',1,tb_DwnStock.Balance,tb_DwnStock.Balance
		,tb_DwnStock.Price,tb_DwnStock.Cost,tb_DwnStock.Cost,0,'ADD',Getdate(),1,Null,Null,'',tb_DwnStock.Price
		,Case When TypeId=3 Then CSCode Else '' End,Case When TypeId=3 Then CSCode Else '' End
		From tb_DwnStock Join tb_Item On tb_DwnStock.ItemCode=tb_item.Item_Code Where tb_DwnStock.Balance>0
	End


	--Stock Reduce
	If Exists(Select * From tb_DwnStock Where Balance<0)
	Begin

	GetNextId2: 
	Set @DFR	= ''
	Set @NextIdx	= 0
		Begin
			Select @DFR = Ref_Code FROM tb_Location WHERE Loca_Code = @Loca
				
			UPDATE tb_System SET OPB=OPB+1 WHERE LocaCode=@Loca
			
			Select @NextIdx = Cast(OPB As Char(6)) FROM tb_System WHERE LocaCode = @Loca
		
			Set @NextIdx = Replicate('0',6-Len(Rtrim(@NextIdx))) + Rtrim(@NextIdx)
			
			IF (@DFR Is Null)
				Begin
				Set  @DocNo= Rtrim(@NextIdx)	
				End 
			ELSE
				Begin
				Set  @DocNo= @DFR +  Rtrim(@NextIdx)	
				End
			
			IF Exists(Select SerialNo From tb_StAdjSumm Where SerialNo=@DocNo And LocaCode=@Loca  And ([Id]='OPB' Or [Id]='DMG' or [Id]='DSC' Or [Id]='ADD')) Goto GetNextId2
		End 

		Insert Into tb_StAdjSumm([SerialNo],[LocaCode],[RefNo],[IDate],[CostValue],[RetValue],[Id],[Type],[Status],[TrDate],[UserName])
		Select @DocNo,@Loca,@Serial,@Date,Isnull(Sum(Abs(Balance)*Cost),0),Isnull(Sum(Abs(Balance)*Price),0),'DSC','',1,GetDate(),@UName  From tb_DwnStock Where Balance<0
		
		Insert Into tb_StAdjDet([LnNo],[SerialNo],[LocaCode],[IDate],[RefNo],[SuppCode],[ItemCode],[ItemDescrip],[Scale],[PackSize],[Cost],[Rate],[Qty],[CostValue],[RetValue],[TrDate],[ID],[Remark],[Status],[ExpDate]
		,[BatchNo],[CsCode],[CSName],[AdjRemark])
		Select 1,@DocNo,@Loca,@Date,@Serial,tb_Item.Supp_Code,tb_DwnStock.ItemCode,tb_Item.Descrip,'EACH',1,tb_DwnStock.Cost,tb_DwnStock.Price,Abs(tb_DwnStock.Balance),Abs(tb_DwnStock.Balance)*tb_DwnStock.Cost,Abs(tb_DwnStock.Balance)*tb_DwnStock.Price,Getdate(),'DSC',TypeId,1,Null
		,CSCode,Case When TypeId=3 Then CSCode Else '' End,Case When TypeId=3 Then CSCode Else '' End,'STOCK'
		From tb_DwnStock Join tb_Item On tb_DwnStock.ItemCode=tb_item.Item_Code Where tb_DwnStock.Balance<0

			
		Insert Into tb_Stock ([SerialNo],[LocaCode],[RefNo],[PDate],[SuppCode],[RepCode],[TourCode],[ItemCode],[ExpDate],[BatchNo],[Scale],[PackSize]
		,[Qty],[Balance],[Rate],[Cost],[RealCost],[Type],[ID],[CrDate],[Status],[IType],[PosUnit],[BarcodeSerial],[RetPrice],[CSCode],[CSName])
		Select @DocNo,@Loca,@Serial,@Date,tb_Item.Supp_Code,Null,Null,tb_DwnStock.ItemCode,Null,CSCode,'EACH',1,Abs(tb_DwnStock.Balance),Abs(tb_DwnStock.Balance)
		,tb_DwnStock.Price,tb_DwnStock.Cost,tb_DwnStock.Cost,0,'DSC',Getdate(),1,Null,Null,'',tb_DwnStock.Price
		,Case When TypeId=3 Then CSCode Else '' End,Case When TypeId=3 Then CSCode Else '' End
		From tb_DwnStock Join tb_Item On tb_DwnStock.ItemCode=tb_item.Item_Code Where tb_DwnStock.Balance<0
	End	
	
	
	Update tb_ItemSerial Set tb_ItemSerial.[Status]=9 From tb_ItemSerial Join tb_DwnStock On 
	tb_ItemSerial.ItemCode=tb_DwnStock.ItemCode And --tb_ItemSerial.LocaCode=tb_DwnStock.Loca And 
	tb_ItemSerial.BatchNo=tb_DwnStock.CSCode  Where tb_ItemSerial.[Status]=1 And tb_DwnStock.TypeId=4

	
	Insert Into tb_ItemSerialTmp ([Idx],[ItemCode],[Descrip],[BatchNo],[LocaCode],[RefNo],[Qty],[UserName],[Status],[Id],[RefDate],[CostPrice],[RetPrice],[SuppCode])
	Select 1,tb_DwnStock.ItemCode,tb_Item.Descrip,RTRIM(tb_DwnStock.CSCode),tb_DwnStock.Loca,@DocNo,1,@UName,1,'ADD',@Date,tb_DwnStock.Cost,tb_DwnStock.Price,tb_Item.Supp_Code
	From tb_DwnStock Join tb_Item On tb_DwnStock.ItemCode =tb_Item.Item_Code Where tb_DwnStock.TypeId=4 And tb_DwnStock.TypeId=4 And tb_DwnStock.Qty >0
	

	Insert Into tb_Stock_OpBal_Backup ([Idx],[SerialNo],[LocaCode],[RefNo],[PDate],[SuppCode],[RepCode],[TourCode]
	,[ItemCode],[Scale],[PackSize],[Qty],[Balance],[Rate],[Cost],[RealCost],[Type],[ID],[CrDate],[Status]
	,[IType],[BkpDate],[CNo],[BatchNo],[CsCode],[StockCountRef],[SupplierName],[CategoryCode],[CategoryName],[SubCategoryCode],[SubCategoryName])
	(select [Idx],[SerialNo],[LocaCode],@REFNO,[PDate],[SuppCode],[RepCode],[TourCode]
	,[ItemCode],[Scale],[PackSize],[Qty],[Balance],[Rate],[Cost],[RealCost],[Type],[ID],GETDATE(),[Status]
	,[IType],[BkpDate],[CNo],[BatchNo],[CsCode],[StockCountRef],[SupplierName],[CategoryCode],[CategoryName],[SubCategoryCode],[SubCategoryName]		
	From tb_Stock_OpBal )	
	

	Update  tbPosTransact Set Upload='X' Where  Upload='S' and loca=@Loca
	Update  tbPosPayment Set Upload='X' Where  Upload='S' and loca=@Loca
	

End

GO

