USE [EASYWAY]
GO

/****** Object:  StoredProcedure [dbo].[Sp_BackupBFStock]    Script Date: 2024-03-01 11:37:02 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER Proc [dbo].[Sp_BackupBFStock]
@Loca		Char(5),
@Type		Int,
@Id			Char(5),
@UName		Char(15),
@From		Varchar(25),
@To			VarChar(25),
@RefNo		Varchar(20)
AS
Declare @CNo Int
Set @CNo=0
--Exec [Sp_BackupBFStock]'02',0,'OIT','EasyWay','','',''
Select @CNo=Isnull(Max(Abs(CNo))+1,1) From tb_Stock_Backup Where CNo<0 And LocaCode=@Loca
Update tb_Stock_Backup Set CNo=-@CNo Where LocaCode=@Loca And CNo<=0
IF @Type=1 --Range
	Begin
	If @Id='OCT'
		Begin
			--Update tb_Stock_Backup Set CNo=@CNo Where LocaCode=@Loca And CNo=0  And ItemCode In (Select Item_Code From tb_Item Where Cat_Code Between @From And @To)
			Insert Into tb_Stock_Backup ([Idx],[SerialNo],[LocaCode],[RefNo],[PDate],[SuppCode],[RepCode],[TourCode],[ItemCode],[Scale],[PackSize],[Qty],[Balance],[Rate],[Cost],[RealCost],[Type],[ID],[CrDate],[Status],[IType],[BkpDate],[CNo],[BatchNo],[CsCode],[StockCountRef])
			Select [Idx],[SerialNo],[LocaCode],[RefNo],[PDate],[SuppCode],[RepCode],[TourCode],[ItemCode],[Scale],[PackSize],[Qty],[Balance],[Rate],[Cost],[RealCost],[Type],[ID],[CrDate],[Status],[IType],GetDate(),0,[BatchNo],[CsCode],@RefNo From tb_Stock 
			Where LocaCode=@Loca And ItemCode In (Select Item_Code From tb_Item Where Cat_Code Between @From And @To) And [Status]=1
		End
	Else If @Id='OSC'
		Begin
			--Update tb_Stock_Backup Set CNo=@CNo Where LocaCode=@Loca And CNo=0  And ItemCode In (Select Item_Code From tb_Item Where SubCat_Code Between @From And @To)
			Insert Into tb_Stock_Backup ([Idx],[SerialNo],[LocaCode],[RefNo],[PDate],[SuppCode],[RepCode],[TourCode],[ItemCode],[Scale],[PackSize],[Qty],[Balance],[Rate],[Cost],[RealCost],[Type],[ID],[CrDate],[Status],[IType],[BkpDate],[CNo],[BatchNo],[CsCode],[StockCountRef])
			Select [Idx],[SerialNo],[LocaCode],[RefNo],[PDate],[SuppCode],[RepCode],[TourCode],[ItemCode],[Scale],[PackSize],[Qty],[Balance],[Rate],[Cost],[RealCost],[Type],[ID],[CrDate],[Status],[IType],GetDate(),0,[BatchNo],[CsCode],@RefNo From tb_Stock 
			Where LocaCode=@Loca And ItemCode In (Select Item_Code From tb_Item Where SubCat_Code Between @From And @To)  And [Status]=1
		End
	Else If @Id='OIT'
		Begin
			--Update tb_Stock_Backup Set CNo=@CNo Where LocaCode=@Loca And CNo=0  And ItemCode Between @From And @To
			Insert Into tb_Stock_Backup ([Idx],[SerialNo],[LocaCode],[RefNo],[PDate],[SuppCode],[RepCode],[TourCode],[ItemCode],[Scale],[PackSize],[Qty],[Balance],[Rate],[Cost],[RealCost],[Type],[ID],[CrDate],[Status],[IType],[BkpDate],[CNo],[BatchNo],[CsCode],[StockCountRef])
			Select [Idx],[SerialNo],[LocaCode],[RefNo],[PDate],[SuppCode],[RepCode],[TourCode],[ItemCode],[Scale],[PackSize],[Qty],[Balance],[Rate],[Cost],[RealCost],[Type],[ID],[CrDate],[Status],[IType],GetDate(),0,[BatchNo],[CsCode],@RefNo From tb_Stock 
			Where LocaCode=@Loca And ItemCode Between @From And @To And Status=1
		End
	Else If @Id='OSP'
		Begin
			--Update tb_Stock_Backup Set CNo=@CNo Where LocaCode=@Loca And CNo=0  And ItemCode In (Select Item_Code From tb_Item Where Supp_Code Between @From And @To)
			Insert Into tb_Stock_Backup ([Idx],[SerialNo],[LocaCode],[RefNo],[PDate],[SuppCode],[RepCode],[TourCode],[ItemCode],[Scale],[PackSize],[Qty],[Balance],[Rate],[Cost],[RealCost],[Type],[ID],[CrDate],[Status],[IType],[BkpDate],[CNo],[BatchNo],[CsCode],[StockCountRef])
			Select [Idx],[SerialNo],[LocaCode],[RefNo],[PDate],[SuppCode],[RepCode],[TourCode],[ItemCode],[Scale],[PackSize],[Qty],[Balance],[Rate],[Cost],[RealCost],[Type],[ID],[CrDate],[Status],[IType],GetDate(),0 ,[BatchNo],[CsCode],@RefNo From tb_Stock 
			Where LocaCode=@Loca And ItemCode In (Select Item_Code From tb_Item Where Supp_Code Between @From And @To) And Status=1
		End
	Else If @Id='OBN'
		Begin
			--Update tb_Stock_Backup Set CNo=@CNo Where LocaCode=@Loca And CNo=0  And ItemCode In (Select Item_Code From tb_Item Where Supp_Code Between @From And @To)
			Insert Into tb_Stock_Backup ([Idx],[SerialNo],[LocaCode],[RefNo],[PDate],[SuppCode],[RepCode],[TourCode],[ItemCode],[Scale],[PackSize],[Qty],[Balance],[Rate],[Cost],[RealCost],[Type],[ID],[CrDate],[Status],[IType],[BkpDate],[CNo],[BatchNo],[CsCode],[StockCountRef])
			Select [Idx],[SerialNo],[LocaCode],[RefNo],[PDate],[SuppCode],[RepCode],[TourCode],[ItemCode],[Scale],[PackSize],[Qty],[Balance],[Rate],[Cost],[RealCost],[Type],[ID],[CrDate],[Status],[IType],GetDate(),0 ,[BatchNo],[CsCode],@RefNo From tb_Stock 
			Where LocaCode=@Loca And ItemCode In (Select Item_Code From tb_ItemDet Where BinNo Between @From And @To And Loca_Code=@Loca) And Status=1
		End
	End
Else
	Begin
	If @Id='OCT'
		Begin
			--Update tb_Stock_Backup Set CNo=@CNo Where LocaCode=@Loca And CNo=0  And ItemCode In  (Select Item_Code From tb_Item Where Cat_Code In (Select Code From tb_TempSelect Where UserName=@Uname And [ID]=@Id And LocaCode=@Loca)) 
			Insert Into tb_Stock_Backup ([Idx],[SerialNo],[LocaCode],[RefNo],[PDate],[SuppCode],[RepCode],[TourCode],[ItemCode],[Scale],[PackSize],[Qty],[Balance],[Rate],[Cost],[RealCost],[Type],[ID],[CrDate],[Status],[IType],[BkpDate],[CNo],[BatchNo],[CsCode],[StockCountRef])
			Select [Idx],[SerialNo],[LocaCode],[RefNo],[PDate],[SuppCode],[RepCode],[TourCode],[ItemCode],[Scale],[PackSize],[Qty],[Balance],[Rate],[Cost],[RealCost],[Type],[ID],[CrDate],[Status],[IType],GetDate(),0,[BatchNo],[CsCode],@RefNo From tb_Stock 
			Where LocaCode=@Loca And ItemCode In (Select Item_Code From tb_Item Where Cat_Code In (Select Code From tb_TempSelect Where UserName=@Uname And [ID]=@Id And LocaCode=@Loca)) And Status=1
		End
	Else If @Id='OSC'
		Begin
			--Update tb_Stock_Backup Set CNo=@CNo Where LocaCode=@Loca And CNo=0  And ItemCode In  (Select Item_Code From tb_Item Where SubCat_Code In (Select Code From tb_TempSelect Where UserName=@Uname And [ID]=@Id And LocaCode=@Loca)) 
			Insert Into tb_Stock_Backup ([Idx],[SerialNo],[LocaCode],[RefNo],[PDate],[SuppCode],[RepCode],[TourCode],[ItemCode],[Scale],[PackSize],[Qty],[Balance],[Rate],[Cost],[RealCost],[Type],[ID],[CrDate],[Status],[IType],[BkpDate],[CNo],[BatchNo],[CsCode],[StockCountRef])
			Select [Idx],[SerialNo],[LocaCode],[RefNo],[PDate],[SuppCode],[RepCode],[TourCode],[ItemCode],[Scale],[PackSize],[Qty],[Balance],[Rate],[Cost],[RealCost],[Type],[ID],[CrDate],[Status],[IType],GetDate(),0,[BatchNo],[CsCode],@RefNo From tb_Stock 
			Where LocaCode=@Loca And ItemCode In (Select Item_Code From tb_Item Where SubCat_Code In (Select Code From tb_TempSelect Where UserName=@Uname And [ID]=@Id And LocaCode=@Loca)) And Status=1
		End
   Else If @Id='OIT'
		Begin
			--Update tb_Stock_Backup Set CNo=@CNo Where LocaCode=@Loca And CNo=0  And ItemCode In  (Select Code From tb_TempSelect Where UserName=@Uname And [ID]=@Id And LocaCode=@Loca) 
			Insert Into tb_Stock_Backup ([Idx],[SerialNo],[LocaCode],[RefNo],[PDate],[SuppCode],[RepCode],[TourCode],[ItemCode],[Scale],[PackSize],[Qty],[Balance],[Rate],[Cost],[RealCost],[Type],[ID],[CrDate],[Status],[IType],[BkpDate],[CNo],[BatchNo],[CsCode],[StockCountRef])
			Select [Idx],[SerialNo],[LocaCode],[RefNo],[PDate],[SuppCode],[RepCode],[TourCode],[ItemCode],[Scale],[PackSize],[Qty],[Balance],[Rate],[Cost],[RealCost],[Type],[ID],[CrDate],[Status],[IType],GetDate(),0,[BatchNo],[CsCode],@RefNo From tb_Stock 
			Where LocaCode=@Loca And ItemCode IN (Select Code From tb_TempSelect Where UserName=@Uname And [ID]=@Id And LocaCode=@Loca) And Status=1
		End
   Else If @Id='OSP'
		Begin
			--Update tb_Stock_Backup Set CNo=@CNo Where LocaCode=@Loca And CNo=0  And ItemCode In  (Select Item_Code From tb_Item Where Supp_Code In (Select Code From tb_TempSelect Where UserName=@Uname And [ID]=@Id And LocaCode=@Loca)) 
			Insert Into tb_Stock_Backup ([Idx],[SerialNo],[LocaCode],[RefNo],[PDate],[SuppCode],[RepCode],[TourCode],[ItemCode],[Scale],[PackSize],[Qty],[Balance],[Rate],[Cost],[RealCost],[Type],[ID],[CrDate],[Status],[IType],[BkpDate],[CNo],[BatchNo],[CsCode],[StockCountRef])
			Select [Idx],[SerialNo],[LocaCode],[RefNo],[PDate],[SuppCode],[RepCode],[TourCode],[ItemCode],[Scale],[PackSize],[Qty],[Balance],[Rate],[Cost],[RealCost],[Type],[ID],[CrDate],[Status],[IType],GetDate(),0,[BatchNo],[CsCode],@RefNo From tb_Stock 
			Where LocaCode=@Loca And ItemCode In (Select Item_Code From tb_Item Where Supp_Code In (Select Code From tb_TempSelect Where UserName=@Uname And [ID]=@Id And LocaCode=@Loca)) And Status=1
		End
   End
   

GO

