USE [SPOSDATA]
GO
/****** Object:  StoredProcedure [dbo].[spSaveInvoice]    Script Date: 18/12/2023 10:12:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[spSaveInvoice]
	   @LocationID int
	  ,@Receipt varchar(10)
	  ,@UnitNo int
	  ,@CashierID bigint
	  ,@CustomerID bigint
	  ,@CustomerType INT
	  ,@CustomerCode NVARCHAR(25)
	  ,@Amount decimal(18,4)
	  ,@LoyaltyType int
	  ,@EnCodeName varchar (30)
	  ,@LoyaltyCardMasterID bigint
	  ,@RecallNo char(10)
	  ,@CurrencyID bigint
	  ,@CurrencyRate decimal(18,4)
	  ,@Reference varchar(50)
	  ,@InvoiceNo varchar(100)=''
	  ,@CustomerPhone varchar(10)=''
	  as

SET NOCOUNT ON

BEGIN TRY
       BEGIN TRANSACTION 

	declare @IsRecallAvdInv bit = 0
    declare @RowNo bigint=0
	,@Zno bigint
	,@IsUpdateInvoiceNo bit=0
	,@RowNoPayment bigint=0
	,@IsOneGalleFaceIntegration bit=0 
	,@IsHavelockSync bit=0

	select @Zno=ZNo,@IsOneGalleFaceIntegration=IsOneGalleFaceIntegration,
					@IsHavelockSync=IsHavelockSync From [dbo].[SysConfig] Where LocationID=@LocationID and UnitNo=@UnitNo
	select @IsRecallAvdInv=IsRecall from AdvanceHed where LocationID=@LocationID and RecallUnitNo = @UnitNo and AdvanceNo=@RecallNo

	IF(@IsOneGalleFaceIntegration=1)
	BEGIN
	exec [spUpdateOneGalleFaceData] @LocationID,@UnitNo,@Receipt,@CurrencyID,@Zno
	END

	insert into TransactionDet
	(
	   [ProductID]
      ,[ProductCode]
      ,[RefCode]
      ,[BarCodeFull]
      ,[Descrip]
      ,[BatchNo]
      ,[SerialNo]
      ,[ExpiaryDate]
      ,[Cost]
      ,[AvgCost]
      ,[Price]
      ,[Qty]
      ,[Amount]
      ,[UnitOfMeasureID]
      ,[UnitOfMeasureName]
      ,[ConvertFactor]
      ,[IDI1]
      ,[IDis1]
      ,[IDiscount1]
      ,[IDI1CashierID]
      ,[IDI2]
      ,[IDis2]
      ,[IDiscount2]
      ,[IDI2CashierID]
      ,[IDI3]
      ,[IDis3]
      ,[IDiscount3]
      ,[IDI3CashierID]
      ,[IDI4]
      ,[IDis4]
      ,[IDiscount4]
      ,[IDI4CashierID]
      ,[IDI5]
      ,[IDis5]
      ,[IDiscount5]
      ,[IDI5CashierID]
      ,[Rate]
      ,[IsSDis]
      ,[SDNo]
      ,[SDID]
      ,[SDIs]
      ,[SDiscount]
      ,[DDisCashierID]
      ,[Nett]
      ,[LocationID]
      ,[DocumentID]
      ,[BillTypeID]
      ,[SaleTypeID]
      ,[Receipt]
      ,[SalesmanID]
      ,[Salesman]
      ,[CustomerID]
      ,[Customer]
      ,[CashierID]
      ,[Cashier]
      ,[StartTime]
      ,[EndTime]
      ,[RecDate]
      ,[BaseUnitID]
      ,[UnitNo]
      ,[RowNo]
      ,[IsRecall]
      ,[RecallNo]
      ,[RecallAdv]
      ,[TaxAmount]
      ,[IsTax]
      ,[TaxPercentage]
      ,[IsStock]
      ,[UpdateBy]
	  ,[Status]
	  ,CustomerType
	  ,TransStatus
	  ,IsPromotionApplied
	  ,PromotionID
	  ,IsPromotion
	  ,Zno
	  ,LoyaltyType
	  ,RecallUnitNo
	  ,[RecallAvdInvoice]
	  ,[SaleStatus]
	  ,[AdvaneReceiptNo]
	  ,[CurrencyID]
	  ,[CurrencyRate]
	  ,[ProductColorSizeID]
	  ,[Reference]
	  ,[IsNonDiscount]
	  ,[ExchangeReasonID]
	  ,[IsItemSeek]
	  ,[InvoiceNo]
	  ,[CustomerPhone]
	)
	SELECT
	   [ProductID]
      ,[ProductCode]
      ,[RefCode]
      ,[BarCodeFull]
      ,[Descrip]
      ,[BatchNo]
      ,[SerialNo]
      ,[ExpiaryDate]
      ,[Cost]
      ,[AvgCost]
      ,[Price]
      ,[Qty]
      ,[Amount]
      ,[UnitOfMeasureID]
      ,[UnitOfMeasureName]
      ,[ConvertFactor]
      ,[IDI1]
      ,[IDis1]
      ,[IDiscount1]
      ,[IDI1CashierID]
      ,[IDI2]
      ,[IDis2]
      ,[IDiscount2]
      ,[IDI2CashierID]
      ,[IDI3]
      ,[IDis3]
      ,[IDiscount3]
      ,[IDI3CashierID]
      ,[IDI4]
      ,[IDis4]
      ,[IDiscount4]
      ,[IDI4CashierID]
      ,[IDI5]
      ,[IDis5]
      ,[IDiscount5]
      ,[IDI5CashierID]
      ,[Rate]
      ,[IsSDis]
      ,[SDNo]
      ,[SDID]
      ,[SDIs]
      ,[SDiscount]
      ,[DDisCashierID]
      ,[Nett]
      ,[LocationID]
      ,[DocumentID]
      ,[BillTypeID]
      ,[SaleTypeID]
      ,[Receipt]
      ,[SalesmanID]
      ,[Salesman]
      ,@CustomerID
      ,@CustomerCode+' - '+@EnCodeName
      ,[CashierID]
      ,[Cashier]
      ,[StartTime]
      ,[EndTime]
      ,[RecDate]
      ,[BaseUnitID]
      ,[UnitNo]
      ,[RowNo]
      ,[IsRecall]
      ,[RecallNo]
      ,[RecallAdv]
      ,[TaxAmount]
      ,[IsTax]
      ,[TaxPercentage]
      ,[IsStock]
      ,@CashierID
	  ,1
	  ,@CustomerType
	  ,TransStatus
	  ,IsPromotionApplied
	  ,PromotionID
	  ,IsPromotion
	  ,@Zno
	  ,@LoyaltyType
	  ,RecallUnitNo
	  ,[RecallAvdInvoice]
	  ,CASE WHEN(@IsRecallAvdInv = 1) THEN  'C' ELSE '' END
	  ,[RecallNo]
	  ,@CurrencyID
	  ,@CurrencyRate
	  ,[ProductColorSizeID]
	  ,@Reference
	  ,IsNonDiscount
	  ,[ExchangeReasonID]
	  ,[IsItemSeek]
	  ,@InvoiceNo
	  ,@CustomerPhone
	  From [dbo].[TempItemDet] where Receipt=@Receipt and LocationID=@LocationID and UnitNo=@UnitNo 
	  

	if @@ROWCOUNT>0
	begin
		set @IsUpdateInvoiceNo=1
	end

	insert into PaymentDet
	(
	   [RowNo]
      ,[PayTypeID]
      ,[Amount]
      ,[Balance]
      ,[SDate]
      ,[Receipt]
      ,[LocationID]
      ,[CashierID]
      ,[UnitNo]
      ,[BillTypeID]
      ,[SaleTypeID]
      ,[RefNo]
      ,[BankId]
	  ,TerminalID
      ,[ChequeDate]
      ,[IsRecallAdv]
      ,[RecallNo]
      ,[Descrip]
      ,[EnCodeName]
	  ,UpdatedBy
	  ,[Status]
	  ,CustomerID
      ,CustomerCode
      ,CustomerType
	  ,ZNo
	  ,LoyaltyType
	  ,[LoyaltyCardMasterID]
	  ,[RecallAvdInvoice]
	  ,[SaleStatus]
	  ,[AdvaneReceiptNo]
	  ,[CurrencyID]
	  ,[CurrencyRate]
	  ,[InvoiceNo]
	)
	Select
	   [RowNo]
      ,[PayTypeID]
      ,[Amount]
      ,[Balance]
      ,[SDate]
      ,[Receipt]
      ,[LocationID]
      ,[CashierID]
      ,[UnitNo]
      ,[BillTypeID]
      ,[SaleTypeID]
      ,[RefNo]
      ,[BankId]
	  ,TerminalID
      ,[ChequeDate]
      ,[IsRecallAdv]
      ,[RecallNo]
      ,[Descrip]
      ,case when ltrim(rtrim([EnCodeName]))='' then @EnCodeName else [EnCodeName] end
	  ,@CashierID
	  ,1
	  ,@CustomerID
	  ,@CustomerCode
	  ,@CustomerType
	  ,@Zno
	  ,@LoyaltyType
	  ,@LoyaltyCardMasterID
	  ,[RecallAvdInvoice]
	  ,CASE WHEN(@IsRecallAvdInv = 1) THEN  'C' ELSE '' END
	  ,[RecallNo]
	  ,@CurrencyID
	  ,@CurrencyRate
	  ,@InvoiceNo
	  From [dbo].[TempPaymentDet] where Receipt=@Receipt and LocationID=@LocationID and UnitNo=@UnitNo


	if((@LoyaltyType=2 OR @LoyaltyType=3 OR (@LoyaltyType=0 and @CustomerType=5)) and @CustomerID!=0)
	
	begin

		select @RowNo=isnull(max(RowNo),0)+1 from TempPaymentDet Where LocationID=@LocationID And Receipt=@Receipt And UnitNo=@UnitNo
		select @RowNoPayment=isnull(max(RowNo),0) from TempPaymentDet Where LocationID=@LocationID And Receipt=@Receipt And UnitNo=@UnitNo

		IF @RowNo<@RowNoPayment
		BEGIN
			SET @RowNo=@RowNoPayment
				
		END
			
		set @RowNo=isnull(@RowNo,0)+1
			  
			  insert into PaymentDet
			(
			   [RowNo]
			  ,[PayTypeID]
			  ,[Amount]
			  ,[Balance]
			  ,[SDate]
			  ,[Receipt]
			  ,[LocationID]
			  ,[CashierID]
			  ,[UnitNo]
			  ,[BillTypeID]			 
			  ,UpdatedBy
			  ,[Status]
			  ,CustomerID
			  ,CustomerCode
			  ,CustomerType
			  ,EnCodeName
			  ,Zno
			  ,LoyaltyType
			  ,[LoyaltyCardMasterID]
			  ,[CurrencyID]
	          ,[CurrencyRate]
			  ,[InvoiceNo]
			)
			Values
			(
			   @RowNo
			  ,17
			  ,@Amount
			  ,0
			  ,GETDATE()
			  ,@Receipt
			  ,@LocationID
			  ,@CashierID
			  ,@UnitNo
			  ,2
			  ,@CashierID
			  ,1
			  ,@CustomerID
			  ,@CustomerCode
			  ,@CustomerType
			  ,@EnCodeName
			  ,@Zno
			  ,@LoyaltyType
			  ,@LoyaltyCardMasterID
			  ,@CurrencyID
	          ,@CurrencyRate
			  ,@InvoiceNo
			  )

			  

	  end
	if(@LoyaltyType=3 and @CustomerID!=0)
	
	begin
    DECLARE @GuidClaimedAmt DECIMAL(18,4)=0
    
    SELECT @GuidClaimedAmt=ISNULL(SUM(Amount),0) FROM TempItemDet Where LocationID=@LocationID And Receipt=@Receipt And UnitNo=@UnitNo AND DocumentID=8 AND ProductID=6

	IF(@GuidClaimedAmt>0)
	BEGIN
	
	select @RowNo=isnull(max(RowNo),0)+1 from TempPaymentDet Where LocationID=@LocationID And Receipt=@Receipt And UnitNo=@UnitNo
	select @RowNoPayment=isnull(max(RowNo),0) from TempPaymentDet Where LocationID=@LocationID And Receipt=@Receipt And UnitNo=@UnitNo

	IF @RowNo<@RowNoPayment
		BEGIN
			SET @RowNo=@RowNoPayment
				
		END
			
		set @RowNo=isnull(@RowNo,0)+1		
			  
			  insert into PaymentDet
			(
			   [RowNo]
			  ,[PayTypeID]
			  ,[Amount]
			  ,[Balance]
			  ,[SDate]
			  ,[Receipt]
			  ,[LocationID]
			  ,[CashierID]
			  ,[UnitNo]
			  ,[BillTypeID]			 
			  ,UpdatedBy
			  ,[Status]
			  ,CustomerID
			  ,CustomerCode
			  ,CustomerType
			  ,EnCodeName
			  ,Zno
			  ,LoyaltyType
			  ,[LoyaltyCardMasterID]
			  ,[CurrencyID]
	          ,[CurrencyRate]
			  ,[InvoiceNo]
			)
			Values
			(
			   @RowNo
			  ,18
			  ,@GuidClaimedAmt
			  ,0
			  ,GETDATE()
			  ,@Receipt
			  ,@LocationID
			  ,@CashierID
			  ,@UnitNo
			  ,4
			  ,@CashierID
			  ,1
			  ,@CustomerID
			  ,@CustomerCode
			  ,@CustomerType
			  ,@EnCodeName
			  ,@Zno
			  ,@LoyaltyType
			  ,@LoyaltyCardMasterID
			  ,@CurrencyID
	          ,@CurrencyRate
			  ,@InvoiceNo
			  )

	  end

  
			  DELETE FROM TransactionDet  where Receipt=@Receipt and LocationID=@LocationID and UnitNo=@UnitNo AND BillTypeID=4 AND (PromotionID=55 OR PromotionID=56) 
	END
	
	  Delete From [dbo].[TempItemDet] where Receipt=@Receipt and LocationID=@LocationID and UnitNo=@UnitNo 
	  
	  
	  Delete From [dbo].[TempPaymentDet] where Receipt=@Receipt and LocationID=@LocationID and UnitNo=@UnitNo 
	  

	  if @IsUpdateInvoiceNo =1
	  begin
		update [dbo].[SysConfig] Set Receipt=Receipt+1 Where LocationID=@LocationID and UnitNo=@UnitNo 
	  end
	  
	  if @IsHavelockSync=1
	  begin
		exec spHavelockSalesUpdate @LocationID,@Receipt,@UnitNo
	  end
		truncate Table TempPromotion
		truncate Table TempPromotionItem
		truncate Table TempReadPromotionDetails
	
	 	  COMMIT TRANSACTION;
	  SELECT 0 AS Result
	END TRY
  
    BEGIN CATCH
      IF @@TRANCOUNT > 0
	  begin
         ROLLBACK TRANSACTION
		 SELECT  ERROR_MESSAGE() AS Result

	  end
	  else
      begin
		 SELECT  ERROR_MESSAGE() AS Result
	  end
    END CATCH
