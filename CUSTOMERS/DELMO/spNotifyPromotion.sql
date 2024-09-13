USE [Spos_Data]
GO

/****** Object:  StoredProcedure [dbo].[spNotifyPromotion]    Script Date: 09/12/2024 14:15:28 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER Proc [dbo].[spNotifyPromotion]
@UnitNo		Char(3),
@Receipt	Varchar(10),
@Loca		Char(5),
@ItemCode	Varchar(20),
@CustType	Char(1)='C'

As
Declare @PromId Int
Declare @PromType Int
Declare @ExistsPromId	Int

Declare @PromBillTotal Decimal(12,2)
Declare @CurrBillTotal Decimal(12,2)
Declare @UnileverBillTotal Decimal(12,2)

Declare @PromItmesTotal Decimal(12,2)
Declare @LoyaltyType Int

Declare @PromDiscount Decimal(12,4)
Declare @CurrPromDiscount Decimal(12,4)

--Declare @EligibleGetItemCount Decimal(12,4)

Declare @AllowedDiscount Decimal(12,2)
Declare @AllowedPromId Int
--Declare @AllowedItemCount Decimal(12,4)

Declare @ValidDiscount Decimal(12,2)
Declare @ValidPromId Int

Declare @BuyItemQty Decimal(12,4)
Declare @BuyItemValue Decimal(12,4)
Declare @GetItemQty Decimal(12,4)
Declare @GetItemDiscount Decimal(12,4)

Declare @BuyQty Decimal(12,4)
Declare @DiscountAllowdQty Decimal(12,4)
Declare @DiscountGrantedQty Decimal(12,4)

Set @LoyaltyType=0
Set @AllowedPromId=0
Set @PromItmesTotal=0
Set @ExistsPromId=0

Declare @DisplayMsg Varchar(600)
Declare @Description Varchar(60)
Set @DisplayMsg=''
--Current Bill Total
SELECT  @CurrBillTotal= ISNULL(SUM(Case 
	When Iid='001' Or Iid='003' Then ((Qty*Price)-(IDiscount1 + IDiscount2 + IDiscount3 + IDiscount4 + IDiscount5)+Tax)
	When Iid='002' Or Iid='004' Then -((Qty*Price)-(IDiscount1 + IDiscount2 + IDiscount3 + IDiscount4 + IDiscount5)+Tax)
	When Iid='006' Then -Nett Else 0 End),0) 
	FROM tbXItem Where Loca=@Loca And Receipt=@Receipt And UnitNo=@UnitNo
--Already Granted Discount For Promotion/s
SELECT  @AllowedDiscount= ISNULL(SUM(Case 
	When Iid='001' Or Iid='003' Then (IDiscount1 + IDiscount2 + IDiscount3 + IDiscount4 + IDiscount5)
	When Iid='002' Or Iid='004' Then -(IDiscount1 + IDiscount2 + IDiscount3 + IDiscount4 + IDiscount5)
	When Iid='006' Then Nett Else 0 End),0) 
	FROM tbXItem Where Loca=@Loca And Receipt=@Receipt And UnitNo=@UnitNo And PromId>0

Select Top 1 @ExistsPromId=PromId From tbXitem Where Loca=@Loca And Receipt=@Receipt And UnitNo=@UnitNo And PromId>0 
---If @AllowedDiscount>0 Break
If Exists(Select * from tbPromotionMaster Where Status=1 And Convert(Datetime,Convert(Varchar(11),Getdate(),103),103) Between DateFrom And DateTo
	And Convert(Varchar(5),Getdate(),108) Between TimeFrom And TimeTo And BillTotal<=@CurrBillTotal)
Begin
	DECLARE curPromotion CURSOR FOR Select PromId,PromDiscount,BillTotal,PromType,PromotionName,OnlyLoyalty from 
	tbPromotionMaster Where Status=1 And Convert(Datetime,Convert(Varchar(11),Getdate(),103),103) 
	Between DateFrom And DateTo And Convert(Varchar(5),Getdate(),108) Between TimeFrom And TimeTo

	OPEN curPromotion
	FETCH NEXT FROM curPromotion INTO @PromId,@PromDiscount,@PromBillTotal,@PromType,@Description,@LoyaltyType
	WHILE @@FETCH_STATUS = 0
	BEGIN  	
		If (@PromType=1) --Discount Liable For Achieve Only  Bill Total Ex: 5% Discount for all bills which total>1500
		Begin 			
			If (@CurrBillTotal>=@PromBillTotal)
			Begin			
				Set @CurrPromDiscount=0		
				SELECT  @CurrPromDiscount= ISNULL(SUM(Case When Iid='001' Or Iid='003' Then (IDiscount1 + IDiscount2 + IDiscount3 + IDiscount4 + IDiscount5)
				When Iid='002' Or Iid='004' Then -(IDiscount1 + IDiscount2 + IDiscount3 + IDiscount4 + IDiscount5)
				When Iid='006' Then Nett Else 0 End),0) 
				FROM tbXItem Where Loca=@Loca And Receipt=@Receipt And UnitNo=@UnitNo And PromId>0 And PromId=@PromId

				Set @ValidPromId=@PromId
				Set @ValidDiscount=(@PromDiscount/100)*@CurrBillTotal				 
				If (@ValidDiscount<>@CurrPromDiscount) 
				Begin
					If ((@ExistsPromId=0 Or @ExistsPromId=@ValidPromId) And Not(@LoyaltyType=1 And @CustType<>'L')) Set @DisplayMsg=@DisplayMsg + Rtrim(Convert(Varchar(10),@PromId)) + ' > ' + @Description + CHAR(13)
				End
			End
		End
		Else If (@PromType=2) --Discount Liable For Achieve Only Bill Total and Same Promotion Items Quantity Limit
			--if buy 3 pcs from Item 'A' fourth one allow 50% discount/100% discount (free) 
		Begin 
			If Exists(Select * From tbItemsBuy Where PromId=@PromId And ItemCode=@ItemCode And Status=1)
			Begin
				if @Description like '%unilever%'
				begin
					--Current Bill Total
					SELECT  @UnileverBillTotal= ISNULL(SUM(Case 
						When Iid='001' Or Iid='003' Then ((Qty*Price)-(IDiscount1 + IDiscount2 + IDiscount3 + IDiscount4 + IDiscount5)+Tax)
						When Iid='002' Or Iid='004' Then -((Qty*Price)-(IDiscount1 + IDiscount2 + IDiscount3 + IDiscount4 + IDiscount5)+Tax)
						When Iid='006' Then -Nett Else 0 End),0) 
						FROM tbXItem x join tbItemsBuy b on x.ItemCode=b.ItemCode 
						Where Loca=@Loca And Receipt=@Receipt And UnitNo=@UnitNo and b.PromId=@PromId

					if @UnileverBillTotal>=@PromBillTotal
					begin
						if Not(@LoyaltyType=1 And @CustType<>'L')Set @DisplayMsg=@DisplayMsg + Rtrim(Convert(Varchar(10),@PromId)) + ' > ' + @Description + CHAR(13)
					end
				end
				else
				begin
				
					Select @BuyItemValue=TotalPromItemsValue,@BuyItemQty=TotalPromItemsQty From tbItemsBuy 
					Where PromId=@PromId And ItemCode=@ItemCode And Status=1

					Select @GetItemQty=PromQty,@GetItemDiscount=PromDiscount From tbItemsGet 
					Where PromId=@PromId And ItemCode=@ItemCode 

					SELECT  @BuyQty= ISNULL(SUM(Case When Iid='001' Then Qty
					When Iid='002'  Then -Qty Else 0 End),0) FROM tbXItem 
					Where Loca=@Loca And Receipt=@Receipt And UnitNo=@UnitNo And ItemCode=@ItemCode 
					And (Idi1<>6 And Idi2<>6 And Idi3<>6 And Idi4<>6 And Idi5<>6)
				
					Set @DiscountAllowdQty=0
					If (@GetItemQty>0 and @BuyItemQty>0) Set @DiscountAllowdQty=Floor(((@GetItemQty/@BuyItemQty)+0.0001)*@BuyQty)

					SELECT  @DiscountGrantedQty= ISNULL(SUM(Case When Iid='001' Then Qty
					When Iid='002'  Then -Qty Else 0 End),0) FROM tbXItem 
					Where Loca=@Loca And Receipt=@Receipt And UnitNo=@UnitNo And ItemCode=@ItemCode And PromId=@PromId
					And (IDiscount1 + IDiscount2 + IDiscount3 + IDiscount4 + IDiscount5)<>0 And (Idi1=6 Or Idi2=6 Or Idi3=6 Or Idi4=6 Or Idi5=6)


					If (@CurrBillTotal>=@PromBillTotal And @DiscountAllowdQty>0 And @DiscountAllowdQty<>@DiscountGrantedQty)
					Begin
						Set @ValidPromId=@PromId
						Set @ValidDiscount=@PromDiscount 
						If ((@ExistsPromId=0 Or @ExistsPromId=@ValidPromId) And Not(@LoyaltyType=1 And @CustType<>'L')) Set @DisplayMsg=@DisplayMsg + Rtrim(Convert(Varchar(10),@PromId)) + ' > ' + @Description + CHAR(13)
					End
				end
			End			
		End
		Else If (@PromType=3) --Discount Liable For Achieve Only Bill Total and  Promotion Items total Quantity Limit
			--Ex: if buy 3 pcs from out of Items 'A','B','C','D' then allow 50% discount/100% discount (free) form one item out of  'X','Y','Z'
		Begin 
			If Exists(Select * From tbItemsBuy Where PromId=@PromId And ItemCode=@ItemCode And Status=1)
			Begin			
				
				Select @BuyItemValue=TotalPromItemsValue,@BuyItemQty=TotalPromItemsQty From tbItemsBuy 
				Where PromId=@PromId And ItemCode=@ItemCode And Status=1
				
				Select Top 1 @GetItemQty=PromQty,@GetItemDiscount=PromDiscount From tbItemsGet 
				Where PromId=@PromId And ItemCode=@ItemCode 
				
				SELECT  @BuyQty= ISNULL(SUM(Case When Iid='001' Then Qty
				When Iid='002'  Then -Qty Else 0 End),0) FROM tbXItem 
				Where Loca=@Loca And Receipt=@Receipt And UnitNo=@UnitNo And ItemCode In
				(Select ItemCode From tbItemsBuy Where PromId=@PromId And Status=1)
				And (Idi1<>6 And Idi2<>6 And Idi3<>6 And Idi4<>6 And Idi5<>6)
				
				Set @DiscountAllowdQty=0
				If (@GetItemQty>0 and @BuyItemQty>0) Set @DiscountAllowdQty=Floor(((@GetItemQty/@BuyItemQty)+0.0001)*@BuyQty)

				SELECT  @DiscountGrantedQty= ISNULL(SUM(Case When Iid='001' Then Qty
				When Iid='002'  Then -Qty Else 0 End),0) FROM tbXItem 
				Where Loca=@Loca And Receipt=@Receipt And UnitNo=@UnitNo And ItemCode In 
				(Select ItemCode From tbItemsGet Where PromId=@PromId) 
				And PromId=@PromId And (IDiscount1 + IDiscount2 + IDiscount3 + IDiscount4 + IDiscount5)<>0 
				And (Idi1=6 Or Idi2=6 Or Idi3=6 Or Idi4=6 Or Idi5=6)

				If (@CurrBillTotal>=@PromBillTotal And @DiscountAllowdQty>0 And @DiscountAllowdQty<>@DiscountGrantedQty)
				Begin
					Set @AllowedPromId=@PromId
					Set @AllowedDiscount=@PromDiscount
						If ((@ExistsPromId=0 Or @ExistsPromId=@ValidPromId) And Not(@LoyaltyType=1 And @CustType<>'L')) Set @DisplayMsg=@DisplayMsg + Rtrim(Convert(Varchar(10),@PromId)) + ' > ' + @Description + CHAR(13)
				End
			End			
		End
		Else If (@PromType=4) --Discount Liable For Achieve Only Bill Total and  Promotion Items total amount Limit
			--Ex: if buy 2000 worth items from out of Items 'A','B','C','D' then allow 100% discount (free) form one item out of  'X','Y','Z'
		Begin 
			If Exists(Select * From tbItemsBuy Where PromId=@PromId And ItemCode=@ItemCode And Status=1)
			Begin				

				Select @BuyItemValue=TotalPromItemsValue,@BuyItemQty=TotalPromItemsQty From tbItemsBuy 
				Where PromId=@PromId And ItemCode=@ItemCode And Status=1

				Select Top 1 @GetItemQty=PromQty,@GetItemDiscount=PromDiscount From tbItemsGet 
				Where PromId=@PromId And ItemCode=@ItemCode 

				SELECT  @BuyQty= ISNULL(SUM(Case When Iid='001' Then (Qty*Price)
				When Iid='002'  Then -(Qty*Price) Else 0 End),0) FROM tbXItem 
				Where Loca=@Loca And Receipt=@Receipt And UnitNo=@UnitNo And ItemCode In
				(Select ItemCode From tbItemsBuy Where PromId=@PromId And Status=1)
				And (Idi1<>6 And Idi2<>6 And Idi3<>6 And Idi4<>6 And Idi5<>6)
				
				Set @DiscountAllowdQty=0
				If (@GetItemQty>0 and @BuyItemValue>0) Set @DiscountAllowdQty=Floor((@GetItemQty/@BuyItemValue)*@BuyQty)

				SELECT  @DiscountGrantedQty= ISNULL(SUM(Case When Iid='001' Then Qty
				When Iid='002'  Then -Qty Else 0 End),0) FROM tbXItem 
				Where Loca=@Loca And Receipt=@Receipt And UnitNo=@UnitNo And ItemCode In 
				(Select ItemCode From tbItemsGet Where PromId=@PromId) 
				And PromId=@PromId And (IDiscount1 + IDiscount2 + IDiscount3 + IDiscount4 + IDiscount5)<>0 
				And (Idi1=6 Or Idi2=6 Or Idi3=6 Or Idi4=6 Or Idi5=6)

				If (@CurrBillTotal>=@PromBillTotal And @DiscountAllowdQty>0 And @DiscountAllowdQty<>@DiscountGrantedQty)
				Begin
					Set @AllowedPromId=@PromId
					Set @AllowedDiscount=@PromDiscount
					If ((@ExistsPromId=0 Or @ExistsPromId=@ValidPromId) And Not(@LoyaltyType=1 And @CustType<>'L')) Set @DisplayMsg=@DisplayMsg + Rtrim(Convert(Varchar(10),@PromId)) + ' > ' + @Description + CHAR(13)
					
				End
			End				
		End

		FETCH NEXT FROM curPromotion INTO @PromId,@PromDiscount,@PromBillTotal,@PromType,@Description,@LoyaltyType
	END

	CLOSE curPromotion
	DEALLOCATE curPromotion
		
End

Select @DisplayMsg As Msg






GO

