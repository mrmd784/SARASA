USE [EASYWAY]
GO

/****** Object:  StoredProcedure [dbo].[Sp_BackupCFStock]    Script Date: 2024-03-01 11:38:52 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER Proc [dbo].[Sp_BackupCFStock]
@Loca		Char(5),
@Type		Int,
@Id			Char(5),
@UName		Char(15),
@From		Varchar(25),
@To			VarChar(25),
@RefNo		Varchar(20)
AS

IF @Type=1 --Range
	Begin
	If @Id='OCT'
		Begin
			--Update tb_Stock_OpBal Set CNo=1 Where CNo=0 And LocaCode=@Loca And ItemCode In (Select Item_Code From tb_Item Where Cat_Code Between @From And @To)	
			Delete From tb_Stock_OpBal Where CNo=0 And LocaCode=@Loca
			Insert Into tb_Stock_OpBal ([Idx],[SerialNo],[LocaCode],[RefNo],[PDate],[SuppCode],[RepCode],[TourCode],[ItemCode],[Scale],[PackSize],[Qty],[Balance],[Rate],[Cost],[RealCost],[Type],[ID],[CrDate],[Status],[IType],[BkpDate],[CNo],[CsCode],[BatchNo],[StockCountRef])
			Select [Idx],[SerialNo],[LocaCode],[RefNo],[PDate],[SuppCode],[RepCode],[TourCode],[ItemCode],[Scale],[PackSize],[Qty],[Balance],[Rate],[Cost],[RealCost],[Type],[ID],[CrDate],[Status],[IType],GetDate(),0,CSCode,BatchNo,@RefNo From tb_Stock 
			Where [Status]=1 And LocaCode=@Loca And ItemCode In (Select Item_Code From tb_Item Where Cat_Code Between @From And @To)
		End
	Else If @Id='OSC'
		Begin
			--Update tb_Stock_OpBal Set CNo=1 Where CNo=0 And LocaCode=@Loca And ItemCode In (Select Item_Code From tb_Item Where SubCat_Code Between @From And @To)
			Delete From tb_Stock_OpBal Where CNo=0 And LocaCode=@Loca
			Insert Into tb_Stock_OpBal ([Idx],[SerialNo],[LocaCode],[RefNo],[PDate],[SuppCode],[RepCode],[TourCode],[ItemCode],[Scale],[PackSize],[Qty],[Balance],[Rate],[Cost],[RealCost],[Type],[ID],[CrDate],[Status],[IType],[BkpDate],[CNo],[CsCode],[BatchNo],[StockCountRef])
			Select [Idx],[SerialNo],[LocaCode],[RefNo],[PDate],[SuppCode],[RepCode],[TourCode],[ItemCode],[Scale],[PackSize],[Qty],[Balance],[Rate],[Cost],[RealCost],[Type],[ID],[CrDate],[Status],[IType],GetDate(),0,CSCode,BatchNo,@RefNo From tb_Stock 
			Where [Status]=1 And LocaCode=@Loca And ItemCode In (Select Item_Code From tb_Item Where SubCat_Code Between @From And @To)
		End
	Else If @Id='OIT'
		Begin
			--Update tb_Stock_OpBal Set CNo=1 Where CNo=0 And LocaCode=@Loca And ItemCode Between @From And @To
			Delete From tb_Stock_OpBal Where CNo=0 And LocaCode=@Loca
			Insert Into tb_Stock_OpBal ([Idx],[SerialNo],[LocaCode],[RefNo],[PDate],[SuppCode],[RepCode],[TourCode],[ItemCode],[Scale],[PackSize],[Qty],[Balance],[Rate],[Cost],[RealCost],[Type],[ID],[CrDate],[Status],[IType],[BkpDate],[CNo],[CsCode],[BatchNo],[StockCountRef])
			Select [Idx],[SerialNo],[LocaCode],[RefNo],[PDate],[SuppCode],[RepCode],[TourCode],[ItemCode],[Scale],[PackSize],[Qty],[Balance],[Rate],[Cost],[RealCost],[Type],[ID],[CrDate],[Status],[IType],GetDate(),0,CSCode,BatchNo,@RefNo From tb_Stock 
			Where [Status]=1 And LocaCode=@Loca And ItemCode Between @From And @To
		End
	Else If @Id='OSP'
		Begin
			--Update tb_Stock_OpBal Set CNo=1 Where CNo=0 And LocaCode=@Loca And ItemCode In (Select Item_Code From tb_Item Where Supp_Code Between @From And @To)
			Delete From tb_Stock_OpBal Where CNo=0 And LocaCode=@Loca
			Insert Into tb_Stock_OpBal ([Idx],[SerialNo],[LocaCode],[RefNo],[PDate],[SuppCode],[RepCode],[TourCode],[ItemCode],[Scale],[PackSize],[Qty],[Balance],[Rate],[Cost],[RealCost],[Type],[ID],[CrDate],[Status],[IType],[BkpDate],[CNo],[CsCode],[BatchNo],[StockCountRef])
			Select [Idx],[SerialNo],[LocaCode],[RefNo],[PDate],[SuppCode],[RepCode],[TourCode],[ItemCode],[Scale],[PackSize],[Qty],[Balance],[Rate],[Cost],[RealCost],[Type],[ID],[CrDate],[Status],[IType],GetDate(),0,CSCode,BatchNo,@RefNo From tb_Stock 
			Where [Status]=1 And LocaCode=@Loca And ItemCode In (Select Item_Code From tb_Item Where Supp_Code Between @From And @To)
		End
	Else If @Id='OBN'
		Begin
			--Update tb_Stock_OpBal Set CNo=1 Where CNo=0 And LocaCode=@Loca And ItemCode In (Select Item_Code From tb_Item Where Supp_Code Between @From And @To)
			Delete From tb_Stock_OpBal Where CNo=0 And LocaCode=@Loca
			Insert Into tb_Stock_OpBal ([Idx],[SerialNo],[LocaCode],[RefNo],[PDate],[SuppCode],[RepCode],[TourCode],[ItemCode],[Scale],[PackSize],[Qty],[Balance],[Rate],[Cost],[RealCost],[Type],[ID],[CrDate],[Status],[IType],[BkpDate],[CNo],[CsCode],[BatchNo],[StockCountRef])
			Select [Idx],[SerialNo],[LocaCode],[RefNo],[PDate],[SuppCode],[RepCode],[TourCode],[ItemCode],[Scale],[PackSize],[Qty],[Balance],[Rate],[Cost],[RealCost],[Type],[ID],[CrDate],[Status],[IType],GetDate(),0,CSCode,BatchNo,@RefNo From tb_Stock 
			Where [Status]=1 And LocaCode=@Loca And ItemCode In (Select Item_Code From tb_ItemDet Where BinNo Between @From And @To And Loca_Code=@Loca)
		End
	End
Else
	Begin
	If @Id='OCT'
		Begin
			--Update tb_Stock_OpBal Set CNo=1 Where CNo=0 And LocaCode=@Loca And ItemCode In (Select Item_Code From tb_Item Where Cat_Code In (Select Code From tb_TempSelect Where UserName=@Uname And [ID]=@Id And LocaCode=@Loca))
			Delete From tb_Stock_OpBal Where CNo=0 And LocaCode=@Loca
			Insert Into tb_Stock_OpBal ([Idx],[SerialNo],[LocaCode],[RefNo],[PDate],[SuppCode],[RepCode],[TourCode],[ItemCode],[Scale],[PackSize],[Qty],[Balance],[Rate],[Cost],[RealCost],[Type],[ID],[CrDate],[Status],[IType],[BkpDate],[CNo],[CsCode],[BatchNo],[StockCountRef])
			Select [Idx],[SerialNo],[LocaCode],[RefNo],[PDate],[SuppCode],[RepCode],[TourCode],[ItemCode],[Scale],[PackSize],[Qty],[Balance],[Rate],[Cost],[RealCost],[Type],[ID],[CrDate],[Status],[IType],GetDate(),0,CSCode,BatchNo,@RefNo From tb_Stock 
			Where [Status]=1 And LocaCode=@Loca And ItemCode In (Select Item_Code From tb_Item Where Cat_Code In (Select Code From tb_TempSelect Where UserName=@Uname And [ID]=@Id And LocaCode=@Loca))
		End
	Else If @Id='OSC'
		Begin
			--Update tb_Stock_OpBal Set CNo=1 Where CNo=0 And LocaCode=@Loca And ItemCode In (Select Item_Code From tb_Item Where SubCat_Code In (Select Code From tb_TempSelect Where UserName=@Uname And [ID]=@Id And LocaCode=@Loca))
			Delete From tb_Stock_OpBal Where CNo=0 And LocaCode=@Loca
			Insert Into tb_Stock_OpBal ([Idx],[SerialNo],[LocaCode],[RefNo],[PDate],[SuppCode],[RepCode],[TourCode],[ItemCode],[Scale],[PackSize],[Qty],[Balance],[Rate],[Cost],[RealCost],[Type],[ID],[CrDate],[Status],[IType],[BkpDate],[CNo],[CsCode],[BatchNo],[StockCountRef])
			Select [Idx],[SerialNo],[LocaCode],[RefNo],[PDate],[SuppCode],[RepCode],[TourCode],[ItemCode],[Scale],[PackSize],[Qty],[Balance],[Rate],[Cost],[RealCost],[Type],[ID],[CrDate],[Status],[IType],GetDate(),0,CSCode,BatchNo,@RefNo From tb_Stock 
			Where [Status]=1 And LocaCode=@Loca And ItemCode In (Select Item_Code From tb_Item Where SubCat_Code In (Select Code From tb_TempSelect Where UserName=@Uname And [ID]=@Id And LocaCode=@Loca))
		End
	Else If @Id='OIT'
		Begin
			--Update tb_Stock_OpBal Set CNo=1 Where CNo=0 And LocaCode=@Loca And ItemCode IN (Select Code From tb_TempSelect Where UserName=@Uname And [ID]=@Id And LocaCode=@Loca)
			Delete From tb_Stock_OpBal Where CNo=0 And LocaCode=@Loca
			Insert Into tb_Stock_OpBal ([Idx],[SerialNo],[LocaCode],[RefNo],[PDate],[SuppCode],[RepCode],[TourCode],[ItemCode],[Scale],[PackSize],[Qty],[Balance],[Rate],[Cost],[RealCost],[Type],[ID],[CrDate],[Status],[IType],[BkpDate],[CNo],[CsCode],[BatchNo],[StockCountRef])
			Select [Idx],[SerialNo],[LocaCode],[RefNo],[PDate],[SuppCode],[RepCode],[TourCode],[ItemCode],[Scale],[PackSize],[Qty],[Balance],[Rate],[Cost],[RealCost],[Type],[ID],[CrDate],[Status],[IType],GetDate(),0,CSCode,BatchNo,@RefNo From tb_Stock 
			Where [Status]=1 And LocaCode=@Loca And ItemCode IN (Select Code From tb_TempSelect Where UserName=@Uname And [ID]=@Id And LocaCode=@Loca)
		End
	Else If @Id='OSP'
		Begin
			--Update tb_Stock_OpBal Set CNo=1 Where CNo=0 And LocaCode=@Loca And ItemCode In (Select Item_Code From tb_Item Where Supp_Code In (Select Code From tb_TempSelect Where UserName=@Uname And [ID]=@Id And LocaCode=@Loca))
			Delete From tb_Stock_OpBal Where CNo=0 And LocaCode=@Loca
			Insert Into tb_Stock_OpBal ([Idx],[SerialNo],[LocaCode],[RefNo],[PDate],[SuppCode],[RepCode],[TourCode],[ItemCode],[Scale],[PackSize],[Qty],[Balance],[Rate],[Cost],[RealCost],[Type],[ID],[CrDate],[Status],[IType],[BkpDate],[CNo],[CsCode],[BatchNo],[StockCountRef])
			Select [Idx],[SerialNo],[LocaCode],[RefNo],[PDate],[SuppCode],[RepCode],[TourCode],[ItemCode],[Scale],[PackSize],[Qty],[Balance],[Rate],[Cost],[RealCost],[Type],[ID],[CrDate],[Status],[IType],GetDate(),0,CSCode,BatchNo,@RefNo From tb_Stock 
			Where [Status]=1 And LocaCode=@Loca And ItemCode In (Select Item_Code From tb_Item Where Supp_Code In (Select Code From tb_TempSelect Where UserName=@Uname And [ID]=@Id And LocaCode=@Loca))
		End
   End





GO

