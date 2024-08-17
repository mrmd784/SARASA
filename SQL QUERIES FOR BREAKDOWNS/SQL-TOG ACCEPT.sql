USE [Easyway]
GO
/****** Object:  StoredProcedure [dbo].[sp_UPDATE_TOG_NOTE]    Script Date: 18/12/2020 3:39:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_UPDATE_TOG_NOTE]
@SerialNo 		Varchar(20),
@RefNo			Varchar(30),
@Type			Varchar(2) , 
@TDate			Datetime , 
@FromLoca		Varchar(5),
@ToLoca			Varchar(5),
@CostValue		Money,
@RetValue		Money,
@LocaCode		Varchar(5),
@Id				Varchar(3),
@UserName		Varchar(15),
@Status			Int,
@PchSerial		Varchar(10),
@isExp			Int,
@approvalCode	Varchar(10)='',
@ReturnDocNo	Varchar(20) ='<>' output
 AS
Declare @DFR 		As	 Char(2)
Declare @NextIdx 	As	 Char(13)
Declare @DocNo	As	Char(15)
Declare @ReceNo	As	Char(10)
	
declare @Qty  decimal(18,2)	

GetNextId: 
Set @DFR	= ''
Set @NextIdx	= 0
SET @isExp = 0

If @Status=1 
	Begin
		Select @DFR = Ref_Code FROM tb_Location WHERE Loca_Code = @FromLoca
			
		UPDATE tb_System SET TOG=TOG+1 WHERE LocaCode=@FromLoca
		
		Select @NextIdx = Cast(TOG As Char(6)) FROM tb_System WHERE LocaCode = @FromLoca

		Set @NextIdx = Replicate('0',6-Len(Rtrim(@NextIdx))) + Rtrim(@NextIdx)
		
		IF (@DFR Is Null)
			Begin
			Set  @DocNo= Rtrim(@NextIdx)	
			End 
		ELSE
			Begin
			Set  @DocNo= @DFR +  Rtrim(@NextIdx)	
			End
		
		IF Exists(Select SerialNo From tb_TogSumm Where SerialNo=@DocNo And FromLoca=@FromLoca  And [Id]='TOG') Goto GetNextId

		Update tb_TempTog Set tb_TempTog.unit = case when tb_TempTog.PackSize>1 then  tb_Item.PUnit else tb_Item.EUnit end  from tb_TempTog inner join tb_Item On tb_TempTog.ItemCode=tb_Item.Item_Code
		Update tb_TempTog Set tb_TempTog.ItemType =tb_Item.Use_Exp From tb_TempTog Join tb_Item On tb_TempTog.ItemCode=tb_Item.Item_Code
		Where tb_TempTog.LocaCode= @LocaCode	And tb_TempTog.SerialNo	= @SerialNo And tb_TempTog.[ID]	= @Id

		Update t Set t.L1_Name=l.L1_Name From (tb_Link1 as l Join tb_Item As i on l.L1_Code=i.L1_Code) Join tb_TempTog as t
		on i.item_Code=t.itemcode  Where   t.LocaCode	= @LocaCode	And t.SerialNo	= @SerialNo  And t.ID	= 'TOG'	

		--Update t Set t.L2_Name=l.L2_Name From (tb_Link2 as l Join tb_Item As i on l.L2_Code=i.L2_Code) Join tb_TempTog as t
		--on i.item_Code=t.itemcode  Where   t.LocaCode	= @LocaCode	And t.SerialNo	= @SerialNo  And t.ID		= 'TOG'

		--Update t Set t.L3_Name=l.L3_Name From (tb_Link3 as l Join tb_Item As i on l.L3_Code=i.L3_Code) Join tb_TempTog as t
		--on i.item_Code=t.itemcode  Where   t.LocaCode	= @LocaCode	And t.SerialNo	= @SerialNo  And t.ID		= 'TOG'

		--Update t Set t.L4_Name=l.L4_Name From (tb_Link4 as l Join tb_Item As i on l.L4_Code=i.L4_Code) Join tb_TempTog as t
		--on i.item_Code=t.itemcode  Where   t.LocaCode	= @LocaCode	And t.SerialNo	= @SerialNo  And t.ID		= 'TOG'

		Select @Qty=Isnull(sum(Qty),0) From  tb_TempTog	Where   LocaCode	= @LocaCode	And	SerialNo= @SerialNo And [ID]= 'TOG'	And	[Qty]>0

		Insert Into tb_TogSumm	 
				([SerialNo]	,[LocaCode]	,[RefNo],[TDate],[FromLoca]	,[ToLoca]	,[Type]		,[TotalCostValue]	,[TotalRetValue]	,[Id]		,[Status]	,[TrDate]	,[UserName]	,[Qty]	,[Recalled]	,[approvalCode]) 
		Values 	(@DocNo		,@FromLoca	,@RefNo ,@TDate ,@FromLoca 	,@ToLoca 	,@Type 		,@CostValue     	,@RetValue 			,'TOG' 		,@Status 	,GetDate()  ,@UserName	,@Qty	,0			,@approvalCode)
		
		
		Insert Into tb_TogDet	
					([SerialNo]	,[LocaCode]	,[SuppCode]		,[ItemCode]		,[ItemDescrip]	,[Scale]		,[Unit]	
					,[Cost]		,[Rate]		,[Qty]			,[CostValue]	,[RetValue]		,[FromLoca]		,[ToLoca]		
					,[TrDate]	,[ID]		,[Status]		,[LnNo] 		,[PackSize]		,[TDate]		,[ExpDate]
					,[BatchNo]				,[BarcodeSerial],[L1_Name]		,[L2_Name]		,[L3_Name]		,[L4_Name]
					,[CsCode]												,[CsName]	
					,[AcQty]	,[sNoteNumber],[SQty])
		Select 		@DocNo		,@FromLoca	,''	  			,ItemCode       ,ItemDescrip 	,Scale			,Unit
					,Cost		,Rate		,Qty			,CostValue		,RetValue      	,@FromLoca 		,@ToLoca
					,GetDate()	,[Id]		,@Status		,IdNo 			,[PackSize]		,@TDate			,Case When ItemType=2 Then Case Rtrim(Isnull(Remark,'')) When '' Then Null Else Rtrim(Remark) End Else Null End
					,Rtrim(Isnull(Remark,'')),''			,L1_Name		,''				,''				,''		
					,Case When ItemType=3 Then Remark Else '' End			,Case When ItemType=3 Then CsName Else '' End		
					,Qty			,sNoteNumber,AcQty
		From  tb_TempTog	Where   LocaCode	= @LocaCode	And
						SerialNo	= @SerialNo       And
						[ID]		= 'TOG'		And
						[Qty]		>0

		--Stock @ Distination Location
		Insert Into tb_Stock	
					([SerialNo]			,[LocaCode]		,[RefNo]	,[PDate]	,[SuppCode]	,[ItemCode]	,[Qty]		,[Balance]	,[Rate]
					,[Cost]								,[RealCost]				,[ID]		,[CrDate]	,[Scale]	,[PackSize]	,[Type]		
					,[ExpDate]
					,[BatchNo]							,[CSCode]
					,[CSName]			,[Status]		,[BarcodeSerial])                                                
		Select 		@DocNo				,@FromLoca		,@RefNo		,@TDate		,@ToLoca	,ItemCode	,Sum(Qty) 	,Sum(Qty)	,Sum(RetValue)/Sum(Qty)
					,Sum(CostValue)/Sum(Qty)			,Sum(CostValue)/Sum(Qty) ,'TOG'		,GetDate()	,Scale		,PackSize	,@Type		
					,Case When ItemType=2 Then Case Rtrim(Isnull(Remark,'')) When '' Then Null Else Rtrim(Remark) End Else Null End
					,Rtrim(Remark)						,Case When ItemType=3 Then Remark Else '' End	
					,''					,1				,''
		From tb_TempTog 	Where   LocaCode	= @LocaCode	And
						SerialNo	= @SerialNo      And
						[ID]		= 'TOG'		And
						[Qty]		>0
					Group By ItemCode,Scale,PackSize,Rtrim(Remark),Case When ItemType=2 Then Case Rtrim(Isnull(Remark,'')) When '' Then Null Else Rtrim(Remark) End Else Null End
					,Case When ItemType=3 Then Remark Else '' End 

		--Stock @ Target  Location
		Insert Into tb_Stock	
					([SerialNo]			,[LocaCode]		,[RefNo]	,[PDate]	,[SuppCode]	,[ItemCode]	,[Qty]		,[Balance]	,[Rate]
					,[Cost]								,[RealCost]				,[ID]		,[CrDate]	,[Scale]	,[PackSize]	,[Type]		
				,[ExpDate]
					,[BatchNo]							,[CSCode]
					,[CSName]			,[Status]	,[BarcodeSerial])                                                
		Select 		@DocNo				,@ToLoca		,@RefNo		,@TDate		,@FromLoca	,ItemCode	,-Sum(Qty) 	,-Sum(Qty)	,Sum(RetValue)/Sum(Qty)
					,Sum(CostValue)/Sum(Qty)			,Sum(CostValue)/Sum(Qty) ,'TOG'		,GetDate()	,Scale		,PackSize	,@Type		
					,Case When ItemType=2 Then Case Rtrim(Isnull(Remark,'')) When '' Then Null Else Rtrim(Remark) End Else Null End
					,Rtrim(Remark)						,Case When ItemType=3 Then Remark Else '' End	
					,''					,1			,''
		From tb_TempTog 	Where   LocaCode	= @LocaCode	And
						SerialNo	= @SerialNo      And
						[ID]		= 'TOG'		And
						[Qty]		>0
					Group By ItemCode,Scale,PackSize,Rtrim(Remark),Case When ItemType=2 Then Case Rtrim(Isnull(Remark,'')) When '' Then Null Else Rtrim(Remark) End Else Null End
					,Case When ItemType=3 Then Remark Else '' End 

		Insert Into tb_TogQty 	([ItemCode]	,[LocaCode]	,[Qty]		,[Cr_Date])
		Select 			ItemCode	,@FromLoca	,-Sum(Qty)	,GetDate()
		From tb_TempTog 	Where   LocaCode	= @LocaCode	And
						SerialNo	= @SerialNo      And
						[ID]		= 'TOG'		And
						[Qty]		>0
					Group By ItemCode

		If(@PchSerial<>'')
		Begin		
			Insert Into tb_Balance	
						([LocaCode]	,[SerialNo]	,[Id]	,[ItemCode]	,[Scale]		,[PackSize]	,[Qty]		,[RefNo]	,[UpdateAt]	,[StkType]	,[Remark]
						,[ExpDate])                                                
			Select 		@FromLoca	,@DocNo		,'PCH'	,ItemCode	,Scale			,PackSize	,Sum(Qty) 	,@PchSerial	,GetDate()	,ItemType	,Rtrim(Isnull(Remark,''))
						,Case When ITemType=2 Then Case Rtrim(Isnull(Remark,'')) When '' Then Null Else remark End Else Null End
			From tb_TempTog 	Where   LocaCode	= @LocaCode	And
							SerialNo	= @SerialNo      And
							[ID]		= 'TOG'		And
							[Qty]		>0
						Group By ItemCode,Scale,PackSize,ItemType,Rtrim(Isnull(Remark,''))
						,Case When ITemType=2 Then Case Rtrim(Isnull(Remark,'')) When '' Then Null Else remark End Else Null End
		End		
		
		Insert Into tb_ItemSerialTmp ([Idx],[ItemCode],[Descrip],[BatchNo],[LocaCode],[RefNo],[Qty],[UserName],[Status],[Id],[RefDate],[CostPrice],[RetPrice],[SuppCode])
		Select IDNo,ItemCode,Rtrim(ItemDescrip),RTRIM(Remark),@ToLoca,@DocNo,Qty,@UserName,1,'TOG',@TDate,Cost,Rate,@FromLoca
		From tb_TempTog Where LocaCode	= @LocaCode	And SerialNo= @SerialNo And	[ID]= 'TOG' And ItemType=4
		
		Insert Into tb_ItemSerialTmp ([Idx],[ItemCode],[Descrip],[BatchNo],[LocaCode],[RefNo],[Qty],[UserName],[Status],[Id],[RefDate],[CostPrice],[RetPrice],[SuppCode])
		Select IDNo,ItemCode,Rtrim(ItemDescrip),RTRIM(Remark),@FromLoca,@DocNo,-Qty,@UserName,1,'TIS',@TDate,Cost,Rate,@FromLoca
		From tb_TempTog Where LocaCode	= @LocaCode	And SerialNo= @SerialNo And	[ID]= 'TOG' And ItemType=4

		INSERT INTO tb_Alert
				([SerialNo] ,[LocaCode] ,[Code]			,[Name]		,[Remark]	,[Amount]	,[ID]	,[Discount] ,[PMode],[IsView]	,[Sms]	,[Email],[Date])
		VALUES	(@DocNo		, @FromLoca	,@approvalCode	,@FromLoca	,@ToLoca	,@RetValue	,'TOR'	,0			,@Type	,0			,0		,0		,@TDate)
	
		Insert Into tb_DocNo ([DocNo],[tempNo],[Loca],[ID],[UserName]) Values (@DocNo,@SerialNo,@FromLoca,'TOG',@UserName)
	End 	
Else
	Begin
		Set @DocNo=@SerialNo
		Insert Into tb_TogSumm	 
				([SerialNo]			,[LocaCode]	,[RefNo]	,[TDate]	,[FromLoca]	,[ToLoca]	,[Type]		,[TotalCostValue]	
				,[TotalRetValue]	,[Id]		,[Status]	,[TrDate]	,[UserName],[Recalled]	,[approvalCode] )
		Values 	(@DocNo				,@LocaCode	,@RefNo 	,@TDate 	,@FromLoca 	,@ToLoca 	,@Type 		,@CostValue 
				,@RetValue 			,'TOG' 		,@Status 	, GetDate() ,@UserName	,0			,@approvalCode)
		

		Insert Into tb_TogDet	
				([SerialNo]	,[LocaCode]	,[SuppCode]		,[ItemCode]		,[ItemDescrip]	,[Scale]		,[Unit]	
				,[Cost]		,[Rate]		,[Qty]			,[CostValue]	,[RetValue]		,[FromLoca]		,[ToLoca]		
				,[TrDate]	,[ID]		,[Status]		,[LnNo] 		,[PackSize]		,[TDate]		,[ExpDate]
				,[BatchNo]				,[BarcodeSerial],[CSCode]		
				,[CSName]												,[sNoteNumber])
		Select 	@DocNo		,@LocaCode	,''	  			,ItemCode       ,ItemDescrip 	,Scale			,Unit
				,Cost		,Rate		,Qty            ,CostValue		,RetValue      	,@FromLoca 		,@ToLoca
				,GetDate()	,[Id]		,@Status		,IdNo 			,[PackSize]		,@TDate			,Case When ItemType=2 Then Case Rtrim(Isnull(Remark,'')) When '' Then Null Else Rtrim(Remark) End Else Null End
				,Rtrim(Isnull(Remark,'')),''			,Case When ItemType=3 Then Remark Else '' End			
				,Case When ItemType=3 Then CsName Else '' End			,sNoteNumber
		From  tb_TempTog	Where   LocaCode	= @LocaCode	And
						SerialNo	= @SerialNo       And
						[ID]		= 'TOG'		And
						[Qty]		>0
	End

	Delete From tb_TempTog 	Where   LocaCode	= @LocaCode	And
						SerialNo	= @SerialNo      And
						[ID]		= 'TOG'


SELECT @ReturnDocNo=Rtrim(@DocNo);