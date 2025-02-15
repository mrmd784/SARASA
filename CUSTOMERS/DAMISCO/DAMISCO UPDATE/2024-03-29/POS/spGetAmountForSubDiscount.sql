USE [SPOSDATA]
GO
/****** Object:  StoredProcedure [dbo].[spGetAmountForSubDiscount]    Script Date: 29/03/2024 02:32:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER proc [dbo].[spGetAmountForSubDiscount]
	   @LocationID int
	  ,@DocumentID int
      ,@Receipt varchar(10)
	  ,@CashierID int
	  ,@UnitNo int
	  ,@Discount decimal(18,4)
	  ,@IsPercentage bit
	  ,@IsSubTotal bit
	  ,@DiscountID int
	  ,@NetAmount decimal(18,4)
	  ,@BillTypeID int
	  ,@SaleTypeID int
	  ,@CustomerID bigint
	  ,@Cashier varchar(50)
	  ,@DecimalPointsCurrency int
	  ,@CustomerType INT
	  ,@TransStatus INT
	  ,@IsPromotion bit
	  ,@RefCode varchar(20)
	  as
	  
	 Declare @ProductID bigint=0,
			 @RowNO bigint=0,
			 @DiscountAmount decimal(18,4)=0,
			 @DiscountPercentage decimal(18,4)=0,
			 @Amount decimal(18,4)=0,
			 @TempAmount decimal(18,4)=0,
			 @CurrentDiscount decimal(18,4)=0,
			 @RowNoPayment bigint=0,
			 @PromotionID bigint=0,
			 @PromotionTypeID int=0,
			 @IsOneItemAllowOneDiscount bit = 0

	   select @IsOneItemAllowOneDiscount=IsOneItemAllowOneDiscount from SysConfig where LocationID=@LocationID and UnitNo=@UnitNo

			SELECT @NetAmount=Round(SUM(CASE WHEN (DocumentID=1 OR DocumentID=3 OR DocumentID=8 OR DocumentID=9) THEN Nett  WHEN (DocumentID=2 OR DocumentID=4) THEN -Nett end),@DecimalPointsCurrency)
			FROM TempItemDet t
			LEFT JOIN (SELECT ProductID,IsPromotion,IsNonDiscount,SellingPrice FROM ProductMaster GROUP BY ProductID,IsPromotion,IsNonDiscount,SellingPrice) p 
			on p.ProductID=t.ProductID and (Price=SellingPrice or not exists(select ProductCode from ProductMaster where ProductID=t.ProductID group by ProductCode having COUNT(1)>1))
			WHERE DocumentID IN(1,2,3,4,8,9) AND TransStatus=1
			AND (@IsOneItemAllowOneDiscount=0 OR IsFixedDiscount=1 OR (IDI1=0 and IsSDis=0))
			AND (@IsPromotion=0 OR p.IsPromotion=1 OR p.IsPromotion IS NULL)
			AND (p.IsNonDiscount=0 OR p.IsNonDiscount IS NULL) AND t.LocationID=@LocationID AND t.UnitNo=@unitNo AND t.Receipt=@Receipt
			
			SELECT @TempAmount =ROUND(ISNULL(SUM(Nett),0),@DecimalPointsCurrency)
			From TempItemDet 
			Where  LocationID=@LocationID And Receipt=@Receipt And UnitNo=@UnitNo And DocumentID=6
			AND BillTypeID=@BillTypeID AND SaleTypeID=@SaleTypeID

			SET @NetAmount=@NetAmount-@TempAmount

			SELECT @TempAmount =ROUND(ISNULL(sum(CASE WHEN Amount > Balance THEN Balance ELSE Amount END ),0),@DecimalPointsCurrency)
			From TempPaymentDet 
			Where  LocationID=@LocationID And Receipt=@Receipt And UnitNo=@UnitNo 
			AND BillTypeID=@BillTypeID AND SaleTypeID=@SaleTypeID

			set @NetAmount=@NetAmount-@TempAmount

			SELECT ISNULL(@NetAmount,0) AS RESULT