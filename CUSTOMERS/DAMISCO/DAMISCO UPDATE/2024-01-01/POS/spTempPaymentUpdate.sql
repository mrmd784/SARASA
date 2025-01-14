USE [SPOSDATA]
GO
/****** Object:  StoredProcedure [dbo].[spTempPaymentUpdate]    Script Date: 2024-01-01 10:09:42 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [dbo].[spTempPaymentUpdate]


  @LocationID int
 ,@Receipt char(10)
 ,@UnitNo int
 ,@BillTypeID INT
 ,@SaleTypeID INT
 ,@CashierID bigint	  
 ,@PayTypeID int
 ,@Amount decimal(18,4)
 ,@Balance decimal(18,4)
 ,@RefNo varchar(30)
 ,@BankID bigint
 ,@TerminalID int
 ,@ChequeDate date=null
 ,@IsRecallAdv bit
 ,@RecallNo varchar(10)
 ,@Descrip varchar(20)
 ,@EnCodeName varchar(50)
 ,@LoyaltyCardMasterID bigint
 ,@SaleStatus varchar(20)
	  
 AS

 Declare     @RowNo bigint=0,
			 @RowNoItem bigint=0

SET NOCOUNT ON

BEGIN TRY
       BEGIN TRANSACTION 

select @RowNoItem=isnull(max((RowNo)),0) from TempItemDet Where LocationID=@LocationID And Receipt=@Receipt And UnitNo=@UnitNo
			

select @RowNo=isnull(max(RowNo),0) from TempPaymentDet Where LocationID=@LocationID And Receipt=@Receipt And UnitNo=@UnitNo
			
			
IF @RowNo<@RowNoItem
			BEGIN
				SET @RowNo=@RowNoItem
				
			END

SET @RowNo=@RowNo+1

if(@PayTypeID=6)
begin
if not exists(select PayTypeID from TempPaymentDet Where LocationID=@LocationID And Receipt=@Receipt And UnitNo=@UnitNo And PayTypeID=6 And RefNo=@RefNo )
	begin
				
	Insert Into TempPaymentDet
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
		  ,EnCodeName
		  ,[LoyaltyCardMasterID]
		  ,[SaleStatus]
	)
	Values 
	(
		   @RowNo
		  ,@PayTypeID
		  ,@Amount
		  ,@Balance
		  ,getdate()
		  ,@Receipt
		  ,@LocationID
		  ,@CashierID
		  ,@UnitNo
		  ,@BillTypeID
		  ,@SaleTypeID
		  ,@RefNo
		  ,@BankId
		  ,@TerminalID
		  ,@ChequeDate
		  ,@IsRecallAdv
		  ,@RecallNo
		  ,@Descrip
		  ,@EnCodeName
		  ,@LoyaltyCardMasterID
		  ,@SaleStatus
	)
	
	end
end
else
begin
Insert Into TempPaymentDet
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
	  ,EnCodeName
	  ,[LoyaltyCardMasterID]
	  ,[SaleStatus]
)
Values 
(
	   @RowNo
      ,@PayTypeID
      ,@Amount
      ,@Balance
      ,getdate()
      ,@Receipt
      ,@LocationID
      ,@CashierID
      ,@UnitNo
      ,@BillTypeID
      ,@SaleTypeID
      ,@RefNo
      ,@BankId
	  ,@TerminalID
      ,@ChequeDate
      ,@IsRecallAdv
      ,@RecallNo
	  ,@Descrip
	  ,@EnCodeName
	  ,@LoyaltyCardMasterID
	  ,@SaleStatus
)
end

	
	
	UPDATE TempItemDet SET IsPaid=1 WHERE LocationID=@LocationID AND UnitNo=@UnitNo AND Receipt=@Receipt
	AND BillTypeID=@BillTypeID
	
	  COMMIT TRANSACTION;
	  SELECT '0' AS Result
	END TRY
  
    BEGIN CATCH
      IF @@TRANCOUNT > 0
	  begin
         ROLLBACK TRANSACTION
		 SELECT ERROR_MESSAGE()  AS Result

	  end
	  else
      begin
		 SELECT ERROR_MESSAGE()  AS Result
	  end
    END CATCH




