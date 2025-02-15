USE [SPOSDATA]
GO
/****** Object:  StoredProcedure [dbo].[SPRSalesSummery]    Script Date: 2023-12-21 04:28:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
BY PRAVIN
NEW RELEASE 30-01-2014
*/
--SPRSalesSummery 2,1,3,10000,3

ALTER PROCEDURE [dbo].[SPRSalesSummery]  
   @LocationID int,
   @UnitNo INT,
   @CashierID BIGINT,
   @DeclaredAmount DECIMAL(18,4),
   @ReportType INT,
   @IsYReport BIT=0
   
   
AS 

SET NOCOUNT ON
set XACT_ABORT ON

BEGIN TRY
       --BEGIN TRANSACTION 
	  


      DECLARE         
		@vouchersalegross DECIMAL(18,4) = 0
		, @nvouchersale BIGINT = 0 
		, @voudiscount DECIMAL(18,4) = 0
		, @nvoudiscount BIGINT = 0 
		, @vouRedeem DECIMAL(18,4) = 0
		, @nvouRedeem BIGINT = 0
		, @loyaltyRedeem DECIMAL(18,4) = 0
		, @nloyaltyRedeem BIGINT = 0 
		, @vouchernet DECIMAL(18,4) = 0
		, @vouchercash DECIMAL(18,4) = 0
		, @vouchercredit DECIMAL(18,4) = 0
		, @grosssale DECIMAL(18,4) = 0
		, @refunds DECIMAL(18,4) = 0
		, @Excrefunds DECIMAL(18,4) = 0
		, @nrefunds BIGINT = 0
		, @nExcrefunds BIGINT = 0 
		, @Idiscount decimal(19, 4) = 0
		, @nidiscount BIGINT = 0 
		, @sdiscount decimal(19, 4) = 0
		, @nsdiscount BIGINT = 0 
		, @voids DECIMAL(18,4) = 0
		, @nvoids BIGINT = 0 
		, @voidscancel DECIMAL(18,4) = 0
		, @nvoidscancel INT = 0
		, @error DECIMAL(18,4) = 0
		, @nerror BIGINT = 0 
		, @cancel DECIMAL(18,4) = 0
		, @ncancel BIGINT = 0 
		, @loyalty DECIMAL(18,4) = 0
		, @nloyalty BIGINT = 0 
		, @nett DECIMAL(18,4) = 0
		, @credpay DECIMAL(18,4) = 0
		, @ncredpay BIGINT = 0 
		, @paidout DECIMAL(18,4) = 0
		, @npaidout BIGINT = 0 
		, @paidin DECIMAL(18,4) = 0
		, @npaidin BIGINT = 0 
		, @paidincash DECIMAL(18,4) = 0
		, @npaidincash BIGINT = 0 	  
		, @cashsale DECIMAL(18,4) = 0
		, @staffcashsale DECIMAL(18,4) = 0
		, @nstaffcashsale BIGINT = 0 
		, @cashrefund DECIMAL(18,4) = 0
		, @ncashrefund BIGINT = 0 
		, @advancereceive DECIMAL(18,4) = 0
		, @nadvancereceive BIGINT = 0 
		, @advancerefund DECIMAL(18,4) = 0
		, @nadvancerefund BIGINT = 0 
		, @advancereceivecrd DECIMAL(18,4) = 0
		, @nadvancereceivecrd BIGINT = 0 
		, @advancerefundcrd DECIMAL(18,4) = 0
		, @nadvancerefundcrd BIGINT = 0 
		, @advancesettlement DECIMAL(18,4) = 0
		, @nadvancesettlement BIGINT = 0 
		, @noofbills BIGINT = 0 
		, @staffcred DECIMAL(18,4) = 0
		, @nstaffcred BIGINT = 0 
		, @cheque DECIMAL(18,4) = 0
		, @ncheque BIGINT = 0 
		, @starpoint DECIMAL(18,4) = 0
		, @starpointErn DECIMAL(18,4) = 0
		, @starpointErnVal DECIMAL(18,4) = 0
		, @nstarpoint BIGINT = 0 
		, @mcredit DECIMAL(18,4) = 0
		, @nmcredit BIGINT = 0 
		, @credit DECIMAL(18,4) = 0
		, @ncredit BIGINT = 0  
		, @crdnote DECIMAL(18,4) = 0
		, @ncrdnote BIGINT = 0  
		, @crdnotestle DECIMAL(18,4) = 0
		, @ncrdnotestle BIGINT = 0       
		, @voucher DECIMAL(18,4) = 0
		, @nvoucher  BIGINT = 0 
		, @ReceivedOnAccount DECIMAL(18,4) = 0
		, @Vstaffcashsale DECIMAL(18,4) = 0
		, @VstaffCreditsale DECIMAL(18,4) = 0
		, @vArawanaRedeem DECIMAL(18,4) = 0
		, @nArawanaRedeem bigint = 0
		, @vSalaryAdvance DECIMAL(18,4) = 0
		, @nSalaryAdvance bigint = 0
		, @vRaccRedeem DECIMAL(18,4) = 0
		, @ServerIP NVARCHAR(50)
		, @DBName NVARCHAR(50)
		, @DBUserName NVARCHAR(50)
		, @DBPwd NVARCHAR(50)
		, @ReportNo BIGINT
		, @GroupOfCompanyID INT
		, @ZNo BIGINT
		, @IsExchangeCounter bit=0
		, @IsHavelockSync bit=0
		, @GiftCardcash DECIMAL(18,4) = 0
		, @GiftCardstaffcashsale DECIMAL(18,4) = 0
		, @GiftCardDiscount DECIMAL(18,4) = 0
		, @nGiftCardDiscount BIGINT
		,@GiftCardRedeem DECIMAL(18,4) = 0
		,@nGiftCardRedeem BIGINT
		,@GiftCardnet DECIMAL(18,4) = 0
		,@GiftCardcredit DECIMAL(18,4) = 0
		,@GiftCardsalegross DECIMAL(18,4) = 0
		,@nGiftCardsalegross BIGINT
		,@GiftCard  DECIMAL(18,4) = 0
		,@nGiftCard BIGINT
		,@Nos Decimal(12,2)=100
		,@advancePayments DECIMAL(18,4) = 0
		,@advanceRefunds DECIMAL(18,4) = 0
		,@advanceSetoffs DECIMAL(18,4) = 0
		,@advancebalances DECIMAL(18,4) = 0
		,@noofsalebills BIGINT
		,@nQtySales BIGINT
		,@ZCashier VARCHAR(15)


		  Select @Nos=Isnull(Nos,100) From SysConfig Where @LocationID=@LocationID

		  select @ZCashier=Name from Cashier where CashierID=@CashierID

          SELECT @ServerIP=Outlet,@DBName=DBName,@DBUserName='sa',@DBPwd=outpwd,@GroupOfCompanyID=GroupOfCompanyID
		  ,@ZNo=Zno,@IsExchangeCounter=ExchangeCounter,@IsHavelockSync=IsHavelockSync
   		  FROM SysConfig  WHERE LocationID=@LocationID AND UnitNo=@UnitNo
   

	   
	  IF(@ReportType=1)
	  BEGIN
	  	
	   SELECT @loyaltyRedeem=ISNULL(SUM(Amount),0),@nloyaltyRedeem=ISNULL(count(PaytypeID),0)     
						FROM PaymentDet
						WHERE LocationID = @LocationID AND PayTypeID=5
						AND Status = 1 AND UnitNo=@UnitNo  AND SaleTypeID=1
						AND UpdatedBy=@CashierID AND BillTypeID=1 AND Amount>0
						AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')
						AND RecallAvdInvoice = 0 --(SaleStatus='C' OR SaleStatus='' Or SaleStatus Is Null)
	  
         
			SELECT @vouchersalegross = ISNULL(sum(CASE DocumentID WHEN 1 THEN Amount 
						WHEN 2 THEN -Amount ELSE 0 END), 0)--,
						--@nvouchersale = ISNULL(COUNT(DocumentID), 0)
						FROM TransactionDet
						WHERE LocationID = @LocationID AND (DocumentID = 1 OR DocumentID =2) 
						AND Status = 1 AND TransStatus=1 AND BillTypeID=1 AND SaleTypeID=2 AND UnitNo=@UnitNo
						AND UpdateBy=@CashierID
						AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')  


            
     SELECT @voudiscount = ISNULL(sum(SDiscount), 0),@nvoudiscount = ISNULL(COUNT(DocumentID), 0)						
						FROM TransactionDet
						WHERE LocationID = @LocationID AND (DocumentID =6) 
						AND Status = 1 AND TransStatus=1 AND SaleTypeID=2 AND UnitNo=@UnitNo
						AND UpdateBy=@CashierID AND BillTypeID=1
						AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')  

     SELECT @voudiscount =@voudiscount+ ISNULL(sum(IDiscount1+IDiscount2+IDiscount3+IDiscount4+IDiscount5), 0),
						  @nvoudiscount = @nvoudiscount+ISNULL(COUNT(DocumentID), 0)						
						FROM TransactionDet
						WHERE LocationID = @LocationID AND (DocumentID = 1 OR DocumentID =2) 
						AND Status = 1 AND TransStatus=1 AND SaleTypeID=2 AND UnitNo=@UnitNo
						AND UpdateBy=@CashierID  AND BillTypeID=1
						AND (IDiscount1<>0 or IDiscount2<>0 or IDiscount3<>0 or IDiscount4<>0 or IDiscount5 <>0)
						AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')   
						    
    
						
    SELECT @vouRedeem=ISNULL(SUM(Amount),0),@nvouRedeem=ISNULL(count(PaytypeID),0)     
						FROM PaymentDet
						WHERE LocationID = @LocationID AND PayTypeID=5
						AND Status = 1 AND UnitNo=@UnitNo  AND SaleTypeID=2 
						AND UpdatedBy=@CashierID AND BillTypeID=1 AND Amount>0
						AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')   
						AND RecallAvdInvoice = 0      

            SET @vouchernet = @vouchersalegross - @voudiscount - @vouRedeem

            SELECT @vouchercash = ISNULL(sum(CASE WHEN PaymentDet.Amount > PaymentDet.Balance THEN PaymentDet.Balance ELSE PaymentDet.Amount END ),0)
            FROM PaymentDet
            WHERE LocationID = @LocationID AND PayTypeID=1
			AND Status = 1 AND UnitNo=@UnitNo AND BillTypeID=1
			AND UpdatedBy=@CashierID AND SaleTypeID=2 AND Amount>0 AND CustomerType!=2
			AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')   
						AND RecallAvdInvoice = 0   

            SELECT @vouchercredit = ISNULL(sum(ISNULL(Amount, 0)), 0)
            FROM PaymentDet
            WHERE LocationID = @LocationID AND PayTypeID!=1  AND PayTypeID!=5   AND PayTypeID!=8
			AND Status = 1 AND UnitNo=@UnitNo AND BillTypeID=1
			AND UpdatedBy=@CashierID AND SaleTypeID=2 AND Amount>0 AND CustomerType!=2
			AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')   
						AND RecallAvdInvoice = 0   

			SELECT @Vstaffcashsale = ISNULL(sum(CASE WHEN PaymentDet.Amount > PaymentDet.Balance THEN PaymentDet.Balance ELSE PaymentDet.Amount END ),0)
            FROM PaymentDet
            WHERE LocationID = @LocationID AND PayTypeID=1
			AND Status = 1 AND UnitNo=@UnitNo AND BillTypeID=1
			AND UpdatedBy=@CashierID AND SaleTypeID=2 AND Amount>0 AND CustomerType=2
			AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')   
						AND RecallAvdInvoice = 0   

            SELECT @VstaffCreditSale = ISNULL(sum(ISNULL(Amount, 0)), 0)
            FROM PaymentDet
            WHERE LocationID = @LocationID AND PayTypeID=8
			AND Status = 1 AND UnitNo=@UnitNo AND BillTypeID=1
			AND UpdatedBy=@CashierID AND SaleTypeID=2 AND Amount>0 AND CustomerType=2
			AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')   
						AND RecallAvdInvoice = 0   



			--gift card

			begin

			SELECT @GiftCardsalegross = ISNULL(sum(CASE DocumentID WHEN 1 THEN Amount 
						WHEN 2 THEN -Amount ELSE 0 END), 0),
						@nGiftCardsalegross = ISNULL(COUNT(DocumentID), 0)
						FROM TransactionDet
						WHERE LocationID = @LocationID AND (DocumentID = 1 OR DocumentID =2) 
						AND Status = 1 AND TransStatus=1 AND BillTypeID=1 AND SaleTypeID=7 AND UnitNo=@UnitNo
						AND UpdateBy=@CashierID
						AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')


            
     SELECT @GiftCardDiscount = ISNULL(sum(SDiscount), 0),@nGiftCardDiscount = ISNULL(COUNT(DocumentID), 0)						
						FROM TransactionDet
						WHERE LocationID = @LocationID AND (DocumentID =6) 
						AND Status = 1 AND TransStatus=1 AND SaleTypeID=7 AND UnitNo=@UnitNo
						AND UpdateBy=@CashierID AND BillTypeID=1
						AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')

     SELECT @GiftCardDiscount =@GiftCardDiscount+ ISNULL(sum(IDiscount1+IDiscount2+IDiscount3+IDiscount4+IDiscount5), 0),
						  @nGiftCardDiscount = @nGiftCardDiscount+ISNULL(COUNT(DocumentID), 0)						
						FROM TransactionDet
						WHERE LocationID = @LocationID AND (DocumentID = 1 OR DocumentID =2) 
						AND Status = 1 AND TransStatus=1 AND SaleTypeID=7 AND UnitNo=@UnitNo
						AND UpdateBy=@CashierID  AND BillTypeID=1
						AND (IDiscount1<>0 or IDiscount2<>0 or IDiscount3<>0 or IDiscount4<>0 or IDiscount5 <>0) 
						AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')
						    
    
						
    SELECT @GiftCardRedeem=ISNULL(SUM(Amount),0),@nGiftCardRedeem=ISNULL(count(PaytypeID),0)     
						FROM PaymentDet
						WHERE LocationID = @LocationID AND PayTypeID=5
						AND Status = 1 AND UnitNo=@UnitNo  AND SaleTypeID=7 
						AND UpdatedBy=@CashierID AND BillTypeID=1 AND Amount>0
						AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')
						AND RecallAvdInvoice = 0      

            SET @GiftCardnet = @GiftCardsalegross - @GiftCardDiscount - @GiftCardRedeem

            SELECT @GiftCardcash = ISNULL(sum(CASE WHEN PaymentDet.Amount > PaymentDet.Balance THEN PaymentDet.Balance ELSE PaymentDet.Amount END ),0)
            FROM PaymentDet
            WHERE LocationID = @LocationID AND PayTypeID=1
			AND Status = 1 AND UnitNo=@UnitNo AND BillTypeID=1
			AND UpdatedBy=@CashierID AND SaleTypeID=7 AND Amount>0 AND CustomerType!=2
			AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')
						AND RecallAvdInvoice = 0

            SELECT @GiftCardcredit = ISNULL(sum(ISNULL(Amount, 0)), 0)
            FROM PaymentDet
            WHERE LocationID = @LocationID AND PayTypeID!=1  AND PayTypeID!=5   AND PayTypeID!=8
			AND Status = 1 AND UnitNo=@UnitNo AND BillTypeID=1
			AND UpdatedBy=@CashierID AND SaleTypeID=7 AND Amount>0 AND CustomerType!=2
			AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')
						AND RecallAvdInvoice = 0

			SELECT @GiftCardstaffcashsale = ISNULL(sum(CASE WHEN PaymentDet.Amount > PaymentDet.Balance THEN PaymentDet.Balance ELSE PaymentDet.Amount END ),0)
            FROM PaymentDet
            WHERE LocationID = @LocationID AND PayTypeID=1
			AND Status = 1 AND UnitNo=@UnitNo AND BillTypeID=1
			AND UpdatedBy=@CashierID AND SaleTypeID=7 AND Amount>0 AND CustomerType=2
			AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')
						AND RecallAvdInvoice = 0

            SELECT @GiftCardcredit = ISNULL(sum(ISNULL(Amount, 0)), 0)
            FROM PaymentDet
            WHERE LocationID = @LocationID AND PayTypeID=8
			AND Status = 1 AND UnitNo=@UnitNo AND BillTypeID=1
			AND UpdatedBy=@CashierID AND SaleTypeID=7 AND Amount>0 AND CustomerType=2
			AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')
						AND RecallAvdInvoice = 0

			end

		   SELECT @grosssale = ISNULL(sum(Amount),0)
						FROM TransactionDet
						WHERE LocationID = @LocationID AND (DocumentID = 1 OR DocumentID =3) 
						AND Status = 1 AND TransStatus=1 AND SaleTypeID=1 AND UnitNo=@UnitNo
						AND UpdateBy=@CashierID AND BillTypeID=1
						AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')

            
        

		SELECT @refunds = ISNULL(sum(Amount),0),@nrefunds= ISNULL(sum(Qty),0)
						FROM TransactionDet
						WHERE LocationID = @LocationID AND (DocumentID = 2 OR DocumentID =4) 
						AND Status = 1 AND TransStatus=1 AND SaleTypeID=1 AND UnitNo=@UnitNo
						AND UpdateBy=@CashierID  AND BillTypeID=1
						AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')

		SELECT @Excrefunds = ISNULL(sum(Amount),0),@nExcrefunds= ISNULL(sum(Qty),0)
						FROM TransactionDet
						WHERE LocationID = @LocationID AND (DocumentID = 2 OR DocumentID =4) 
						AND Status = 1 AND TransStatus=1 AND SaleTypeID=1 AND UnitNo=@UnitNo
						AND UpdateBy=@CashierID  AND BillTypeID=1
						AND RecallUnitNo IN (SELECT  ExchangeUnitNo FROM SysConfig)
						AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')
            
		SELECT @Idiscount = ISNULL(sum(CASE WHEN DocumentID=1 OR DocumentID=3 THEN (IDiscount1+IDiscount2+IDiscount3+IDiscount4+IDiscount5)
							WHEN DocumentID=2 OR DocumentID=4 THEN -(IDiscount1+IDiscount2+IDiscount3+IDiscount4+IDiscount5) ELSE 0 END ),0),
							@nIdiscount = ISNULL(count(DocumentID),0)
						FROM TransactionDet
						WHERE LocationID = @LocationID AND (DocumentID = 1 OR DocumentID =2 or DocumentID = 3 OR DocumentID =4) 
						AND Status = 1 AND TransStatus=1  AND UnitNo=@UnitNo
						AND UpdateBy=@CashierID  AND BillTypeID=1  AND SaleTypeID=1
						AND (IDiscount1<>0 or IDiscount2<>0 or IDiscount3<>0 or IDiscount4<>0 or IDiscount5 <>0) 
						AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')
						
            

         SELECT @sdiscount = ISNULL(sum(SDiscount), 0),@nsdiscount = ISNULL(COUNT(DocumentID), 0)						
						FROM TransactionDet
						WHERE LocationID = @LocationID AND (DocumentID =6) 
						AND Status = 1 AND TransStatus=1  AND UnitNo=@UnitNo
						AND UpdateBy=@CashierID AND BillTypeID=1 AND SaleTypeID=1 
						AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')  

         SELECT @voids = ISNULL(sum(Nett), 0),@nvoids = ISNULL(COUNT(DocumentID), 0)						
						FROM TransactionDet
						WHERE LocationID = @LocationID AND (DocumentID = 5) 
						AND Status = 1 AND UnitNo=@UnitNo
						AND UpdateBy=@CashierID 
						AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')

		SELECT @voidscancel = ISNULL(sum(Nett), 0),@nvoidscancel = ISNULL(COUNT(DocumentID), 0)						
						FROM TransactionDet
						WHERE LocationID = @LocationID AND (DocumentID = 5) 
						AND Status = 0 AND UnitNo=@UnitNo
						AND UpdateBy=@CashierID 
						AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')

         SELECT @error = ISNULL(sum(Nett), 0),@nerror = ISNULL(COUNT(DocumentID), 0)						
						FROM TransactionDet
						WHERE LocationID = @LocationID AND (DocumentID = 7) 
						AND Status = 1  AND UnitNo=@UnitNo
						AND UpdateBy=@CashierID
						AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')

           


		SELECT @cancel = ISNULL(sum(CASE WHEN DocumentID = 1 OR DocumentID = 3 THEN Nett 
						 WHEN DocumentID = 2 OR DocumentID = 3 OR DocumentID = 6 OR DocumentID = 8 THEN -Nett  ELSE 0 END), 0)
						 --,
						--@ncancel = ISNULL(COUNT(DocumentID),0)
						FROM TransactionDet
						WHERE LocationID = @LocationID 
						AND (DocumentID = 1 OR DocumentID =2 OR DocumentID =3 OR DocumentID =4 OR DocumentID =6 OR DocumentID =8) 
						AND Status = 0 AND UnitNo=@UnitNo
						AND UpdateBy=@CashierID
						AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')

       SELECT DISTINCT Receipt  INTO #T1
						FROM TransactionDet
						WHERE LocationID = @LocationID 
						AND (DocumentID = 1 OR DocumentID =2 OR DocumentID =3 OR DocumentID =4 OR DocumentID =6 OR DocumentID =8) 
						AND Status = 0 AND UnitNo=@UnitNo
						AND UpdateBy=@CashierID
						AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')

		SELECT @ncancel=@@ROWCOUNT

      SELECT @loyalty=ISNULL(SUM(Amount),0),@nloyalty=ISNULL(count(PaytypeID),0)     
						FROM PaymentDet
						WHERE LocationID = @LocationID AND PayTypeID=14
						AND Status = 1 AND UnitNo=@UnitNo   AND SaleTypeID=1
						AND UpdatedBy=@CashierID  AND BillTypeID=1 AND Amount>0
						AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')
						AND RecallAvdInvoice = 0

 
      SELECT @nett= ISNULL(sum(CASE WHEN DocumentID = 1 OR DocumentID = 3 THEN Nett 
						 WHEN DocumentID = 2 OR DocumentID = 3 OR DocumentID = 6 THEN -Nett  ELSE 0 END), 0)
						FROM TransactionDet
						WHERE LocationID = @LocationID 
						AND (DocumentID = 1 OR DocumentID =2 OR DocumentID =3 OR DocumentID =4 OR DocumentID =6 OR DocumentID =8) 
						AND Status = 1 AND SaleTypeID=1 AND UnitNo=@UnitNo
						AND UpdateBy=@CashierID  AND BillTypeID=1  AND TransStatus=1
						AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')

		SET @nett=@nett-@loyaltyRedeem
           SELECT @paidout= ISNULL(SUM(p.Amount),0),@npaidout= ISNULL(count(p.DocumentID),0)     
						FROM TransactionDet p inner join PaidOutType pt
						on p.ProductID=pt.PaidOutTypeID
						WHERE p.LocationID = @LocationID AND p.BillTypeID=3
						AND p.Status = 1 AND p.UnitNo=@UnitNo and DocumentID=8
						AND p.UpdateBy=@CashierID AND p.Amount>0 and [IsSalesSummery]=1
						AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')

			SELECT @paidin= ISNULL(SUM(p.Amount),0),@npaidin= ISNULL(count(p.DocumentID),0)     
						FROM TransactionDet p inner join PaidInType pt
						on p.ProductID=pt.PaidInTypeID
						WHERE p.LocationID = @LocationID AND p.BillTypeID=6
						AND p.Status = 1 AND p.UnitNo=@UnitNo and DocumentID=9
						AND p.UpdateBy=@CashierID AND p.Amount>0 and [IsSalesSummery]=1
						AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')

						SELECT @vSalaryAdvance= ISNULL(SUM(p.Amount),0),@nSalaryAdvance= ISNULL(count(p.DocumentID),0)     
						FROM TransactionDet p inner join PaidOutType pt
						on p.ProductID=pt.PaidOutTypeID
						WHERE p.LocationID = @LocationID AND p.BillTypeID=3
						AND p.Status = 1 AND p.UnitNo=@UnitNo and DocumentID=8
						AND p.UpdateBy=@CashierID AND p.Amount>0 and [IsSalesSummery]=0 and p.ProductID=3
						AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')

						SELECT @vArawanaRedeem= ISNULL(SUM(p.Amount),0),@nArawanaRedeem= ISNULL(count(p.DocumentID),0)     
						FROM TransactionDet p inner join PaidOutType pt
						on p.ProductID=pt.PaidOutTypeID
						WHERE p.LocationID = @LocationID AND p.BillTypeID=3
						AND p.Status = 1 AND p.UnitNo=@UnitNo and DocumentID=8
						AND p.UpdateBy=@CashierID AND p.Amount>0 and [IsSalesSummery]=0 and p.ProductID=6
						AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')

						SELECT @vRaccRedeem= ISNULL(SUM(p.Amount),0)     
						FROM TransactionDet p inner join PaidOutType pt
						on p.ProductID=pt.PaidOutTypeID
						WHERE p.LocationID = @LocationID AND p.BillTypeID=3
						AND p.Status = 1 AND p.UnitNo=@UnitNo and DocumentID=8
						AND p.UpdateBy=@CashierID AND p.Amount>0 and [IsSalesSummery]=0 and p.ProductID=4
						AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')

						SELECT @ReceivedOnAccount= ISNULL( SUM(Amount),0)-@vRaccRedeem 
						FROM ReceivedOnAccount WHERE CashierID=@CashierID AND UnitNo=@UnitNo 
						AND ZNo=@ZNo AND LocationID=@LocationID


/*


            SELECT @credpay = ISNULL(sum(
               CASE 
                  WHEN IId = 001 OR IId = 003 THEN Nett
                  WHEN IId = 002 OR IId = 004 OR IId = 006 THEN -Nett
                  ELSE 0
               END), 0)
            FROM TransactionDet
            WHERE 
               LocationID = @LocationID AND 
               RecDate BETWEEN @DateF1 AND @DateF2 AND 
               Status = 1 AND 
               SaleType = N'C' AND UnitNo=@UnitNo

            SELECT @ncredpay = ISNULL(count_big(DISTINCT Receipt), 0)
            FROM TransactionDet
            WHERE 
               LocationID = @LocationID AND 
               RecDate BETWEEN @DateF1 AND @DateF2 AND 
               Status = 1 AND 
               SaleType = N'C' AND UnitNo=@UnitNo
 */
            SELECT @cashsale=ISNULL(sum(CASE WHEN PaymentDet.Amount > PaymentDet.Balance THEN PaymentDet.Balance ELSE PaymentDet.Amount END ),0)     
						FROM PaymentDet  INNER JOIN (SELECT distinct LocationID,UnitNo,Receipt,ZNo FROM TransactionDet WHERE TransStatus=1) t ON PaymentDet.LocationID=t.LocationID AND PaymentDet.UnitNo=t.UnitNo AND PaymentDet.Receipt=t.Receipt AND PaymentDet.ZNo=t.ZNo
						WHERE PaymentDet.LocationID =@LocationID  AND BillTypeID=1
						AND  PaymentDet.UnitNo=@UnitNo AND PayTypeID=1   AND SaleTypeID=1 AND Status = 1
						AND Balance>0 AND CustomerType!=2
						AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')
						--AND RecallAvdInvoice = 0

			SELECT @paidincash=ISNULL(sum(CASE WHEN PaymentDet.Amount > PaymentDet.Balance THEN PaymentDet.Balance ELSE PaymentDet.Amount END ),0)     
						FROM PaymentDet
						WHERE LocationID = @LocationID AND BillTypeID=6
						AND Status = 1 AND UnitNo=@UnitNo AND PayTypeID=1   AND SaleTypeID=1
						AND UpdatedBy=@CashierID AND Balance>0 
						AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')
						AND RecallAvdInvoice = 0

            SELECT @staffcashsale=ISNULL(sum(CASE WHEN PaymentDet.Amount > PaymentDet.Balance THEN PaymentDet.Balance ELSE PaymentDet.Amount END ),0),  @nstaffcashsale=ISNULL(COUNT(PayTypeID),0)   
						FROM PaymentDet
						WHERE LocationID = @LocationID AND BillTypeID=1  AND SaleTypeID=1
						AND Status = 1 AND UnitNo=@UnitNo AND PayTypeID=1
						AND CustomerType=2 AND Balance>0
						AND UpdatedBy=@CashierID
						AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')
						AND RecallAvdInvoice = 0

           SELECT @cashrefund=abs(ISNULL(SUM(Amount),0)) ,@ncashrefund=abs(ISNULL(COUNT(PayTypeID),0))    
						FROM PaymentDet
						WHERE LocationID = @LocationID AND BillTypeID=1
						AND Status = 1 AND UnitNo=@UnitNo AND PayTypeID=1
						AND Amount<0  AND SaleTypeID=1 
						AND UpdatedBy=@CashierID
						AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')
						AND RecallAvdInvoice = 0

			SELECT @advancepayments = ISNULL(sum(Amount),0) --advance payment
						FROM PaymentDet                      
						WHERE UnitNo=@UnitNo AND LocationID=@LocationID 
						AND SaleStatus = 'A' and RecallAvdInvoice=0
						AND SaleTypeID=1 AND BillTypeID=1



			SELECT @advancerefunds =ISNULL(sum(Amount),0) --advance refund
						FROM PaymentDet
						WHERE UnitNo=@UnitNo AND LocationID=@LocationID 
						AND SaleStatus = 'X' AND RecallAvdInvoice=1
						AND SaleTypeID=1 AND BillTypeID=1



			SELECT @advancesetoffs =ISNULL(sum(Amount),0) --advance set-off
						FROM PaymentDet
						WHERE UnitNo=@UnitNo AND LocationID=@LocationID 
						AND SaleStatus = 'C' AND RecallAvdInvoice=1
						AND SaleTypeID=1 AND BillTypeID=1


			SET @advancebalances = @advancepayments - @advancerefunds - @advancesetoffs -- balance

/*
            
			SELECT @advancereceive=abs(ISNULL(SUM(Amount),0)) ,@nadvancereceive=abs(ISNULL(COUNT(PayTypeID),0))    
						FROM PaymentDet
						WHERE LocationID = @LocationID AND BillTypeID=5
						AND Status = 1 AND UnitNo=@UnitNo
						AND  Amount>0
						AND UpdatedBy=@CashierID
            
            SELECT @advancerefund=abs(ISNULL(SUM(Amount),0)) ,@nadvancerefund=abs(ISNULL(COUNT(PayTypeID),0))    
						FROM PaymentDet
						WHERE LocationID = @LocationID AND BillTypeID=5
						AND Status = 1 AND UnitNo=@UnitNo
						AND  Amount<0
						AND UpdatedBy=@CashierID

           

            SELECT @advancereceivecrd = abs(ISNULL(sum(Amount), 0))
            FROM PaymentDet
            WHERE 
               LocationID = @LocationID AND 
               SDATE BETWEEN @DateF1 AND @DateF2 AND 
               PStatus = N'A' AND 
               TypeId <> 1 AND 
               Amount >= 0 AND UnitNo=@UnitNo

            SELECT @nadvancereceivecrd = ISNULL(count_big(Amount), 0)
            FROM PaymentDet
            WHERE 
               LocationID = @LocationID AND 
               SDATE BETWEEN @DateF1 AND @DateF2 AND 
               PStatus = N'A' AND 
               TypeId <> 1 AND 
               Amount >= 0 AND UnitNo=@UnitNo

            SELECT @advancerefundcrd = abs(ISNULL(sum(Amount), 0))
            FROM PaymentDet
            WHERE 
               LocationID = @LocationID AND 
               SDATE BETWEEN @DateF1 AND @DateF2 AND 
               PStatus = N'A' AND 
               TypeId <> 1 AND 
               Amount < 0 AND UnitNo=@UnitNo

            SELECT @nadvancerefundcrd = ISNULL(count_big(Amount), 0)
            FROM PaymentDet
            WHERE 
               LocationID = @LocationID AND 
  SDATE BETWEEN @DateF1 AND @DateF2 AND 
               PStatus = N'A' AND 
               TypeId <> 1 AND 
               Amount < 0 AND UnitNo=@UnitNo

            SELECT @advancesettlement = abs(ISNULL(sum(Amount), 0))
            FROM PaymentDet
            WHERE 
               LocationID = @LocationID AND 
               SDATE BETWEEN @DateF1 AND @DateF2 AND 
               PStatus = N'D' AND UnitNo=@UnitNo

            SELECT @nadvancesettlement = ISNULL(count_big(DISTINCT AdvanceNo), 0)
            FROM PaymentDet
            WHERE 
               LocationID = @LocationID AND 
               SDATE BETWEEN @DateF1 AND @DateF2 AND 
               PStatus = N'D' AND UnitNo=@UnitNo
*/
         
		    SELECT @noofbills = ISNULL(count(DISTINCT Receipt), 0)
            FROM PaymentDet
            WHERE LocationID = @LocationID
			AND Status = 1 AND UnitNo=@UnitNo
			AND UpdatedBy=@CashierID AND BillTypeID=1
			AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')
			AND RecallAvdInvoice = 0

			SELECT  @noofsalebills =ISNULL(count(DISTINCT Receipt), 0)
            FROM TransactionDet 
			WHERE LocationID = @LocationID
			AND [Status] = 1 AND UnitNo=@UnitNo
			AND UpdateBy=@CashierID AND DocumentID IN (1,3) and SaleTypeID=1
            and BillTypeID=1
			AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')
			AND RecallAvdInvoice = 0


            SELECT @voucher = ISNULL(sum(ISNULL(Amount, 0)), 0),@nvoucher = ISNULL(COUNT(ISNULL(PayTypeID, 0)), 0)
            FROM PaymentDet
            WHERE LocationID = @LocationID
			AND Status = 1 AND UnitNo=@UnitNo AND PayTypeID=6
			AND UpdatedBy=@CashierID AND BillTypeID=1  AND SaleTypeID=1 
			AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')
			AND RecallAvdInvoice = 0

			SELECT @GiftCard = ISNULL(sum(ISNULL(Amount, 0)), 0),@nGiftCard = ISNULL(COUNT(ISNULL(PayTypeID, 0)), 0)
            FROM PaymentDet
            WHERE LocationID = @LocationID
			AND Status = 1 AND UnitNo=@UnitNo AND PayTypeID=19
			AND UpdatedBy=@CashierID AND BillTypeID=1  AND SaleTypeID=1 
			AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')
			AND RecallAvdInvoice = 0

           
            SELECT @staffcred = ISNULL(sum(ISNULL(Amount, 0)), 0),@nstaffcred = ISNULL(COUNT(ISNULL(PayTypeID, 0)), 0)
            FROM PaymentDet
            WHERE LocationID = @LocationID
			AND Status = 1 AND UnitNo=@UnitNo AND PayTypeID=8
			AND UpdatedBy=@CashierID AND BillTypeID=1
			AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')
			AND RecallAvdInvoice = 0
           

            SELECT @cheque = ISNULL(sum(ISNULL(Amount, 0)), 0),@ncheque = ISNULL(COUNT(ISNULL(PayTypeID, 0)), 0)
            FROM PaymentDet
            WHERE LocationID = @LocationID
			AND Status = 1 AND UnitNo=@UnitNo AND PayTypeID=9
			AND UpdatedBy=@CashierID AND BillTypeID=1  AND SaleTypeID=1 
			AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')
			AND RecallAvdInvoice = 0

            /*

            SELECT @starpoint = ISNULL(sum(ISNULL(Amount, 0)), 0)
            FROM PaymentDet
            WHERE 
               LocationID = @LocationID AND 
               SDATE BETWEEN @DateF1 AND @DateF2 AND 
               PStatus = N'S' AND 
               TypeId = 10 AND UnitNo=@UnitNo

            SELECT @starpointErn = ISNULL(sum(ISNULL(Amount, 0)), 0)
            FROM PaymentDet
            WHERE 
               LocationID = @LocationID AND 
               SDATE BETWEEN @DateF1 AND @DateF2 AND 
               TypeId = 999 AND UnitNo=@UnitNo

            SELECT @starpointErnVal = ISNULL(sum(ISNULL(Balance, 0)), 0)
            FROM PaymentDet
            WHERE 
               LocationID = @LocationID AND 
               SDATE BETWEEN @DateF1 AND @DateF2 AND 
               TypeId = 999 AND UnitNo=@UnitNo

            SELECT @nstarpoint = ISNULL(count_big(Amount), 0)
            FROM PaymentDet
            WHERE 
               LocationID = @LocationID AND 
               SDATE BETWEEN @DateF1 AND @DateF2 AND 
               PStatus = N'S' AND 
               TypeId = 10 AND UnitNo=@UnitNo

            SELECT @mcredit = ISNULL(sum(ISNULL(Amount, 0)), 0)
            FROM PaymentDet
            WHERE 
               LocationID = @LocationID AND 
               SDATE BETWEEN @DateF1 AND @DateF2 AND 
               PStatus = N'S' AND 
               TypeId = 11 AND UnitNo=@UnitNo

            SELECT @nmcredit = ISNULL(count_big(Amount), 0)
            FROM PaymentDet
            WHERE 
               LocationID = @LocationID AND 
               SDATE BETWEEN @DateF1 AND @DateF2 AND 
               PStatus = N'S' AND 
               TypeId = 11 AND UnitNo=@UnitNo

            SELECT @credit = ISNULL(sum(ISNULL(Amount, 0)), 0)
            FROM PaymentDet
            WHERE 
               LocationID = @LocationID AND 
               SDATE BETWEEN @DateF1 AND @DateF2 AND 
               PStatus = N'S' AND 
               TypeId = 12 AND UnitNo=@UnitNo

            SELECT @ncredit = ISNULL(count_big(Amount), 0)
            FROM PaymentDet
            WHERE 
               LocationID = @LocationID AND 
               SDATE BETWEEN @DateF1 AND @DateF2 AND 
               PStatus = N'S' AND 
               TypeId = 12 AND UnitNo=@UnitNo
*/
            SELECT @crdnote = ISNULL(sum(ISNULL(Amount, 0)), 0),@ncrdnote = ISNULL(COUNT(ISNULL(PayTypeID, 0)), 0)
            FROM PaymentDet
            WHERE LocationID = @LocationID
			AND Status = 1 AND UnitNo=@UnitNo AND PayTypeID=13
			AND UpdatedBy=@CashierID AND BillTypeID=1  AND SaleTypeID=1 
			AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')
			AND RecallAvdInvoice = 0
			
			SELECT @crdnotestle = ISNULL(sum(ISNULL(Amount, 0)), 0),@ncrdnotestle = ISNULL(COUNT(ISNULL(PayTypeID, 0)), 0)
            FROM PaymentDet
            WHERE LocationID = @LocationID
			AND Status = 1 AND UnitNo=@UnitNo AND PayTypeID=14
			AND UpdatedBy=@CashierID AND BillTypeID=1  AND SaleTypeID=1 
			AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')
			AND RecallAvdInvoice = 0

			SELECT @nQtySales=ISNULL(sum(CASE DocumentID WHEN 1 THEN Qty 
			WHEN 2 THEN -Qty ELSE 0 END), 0)
			FROM TransactionDet
			WHERE LocationID = @LocationID  AND (DocumentID = 1 OR DocumentID =2) 
			AND Status = 1 AND TransStatus=1 AND BillTypeID=1 AND SaleTypeID=1 AND UnitNo=@UnitNo
			AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')

/*
            SELECT @other = ISNULL(sum(ISNULL(Amount, 0)), 0)
            FROM PaymentDet
            WHERE 
               LocationID = @LocationID AND 
               SDATE BETWEEN @DateF1 AND @DateF2 AND 
               PStatus = N'S' AND 
               TypeId >= 15 AND UnitNo=@UnitNo

            SELECT @nother = ISNULL(count_big(Amount), 0)
            FROM PaymentDet
            WHERE 
               LocationID = @LocationID AND 
               SDATE BETWEEN @DateF1 AND @DateF2 AND 
               PStatus = N'S' AND 
               TypeId >= 15 AND UnitNo=@UnitNo
*/
            
	  END
	  
	  ELSE
	  BEGIN
	  	
	  	SELECT @ReceivedOnAccount= ISNULL( SUM(Amount),0) FROM ReceivedOnAccount WHERE UnitNo=@UnitNo AND ZNo=@ZNo AND LocationID=@LocationID


		   --Insert Void/Error item to TransactionDet before reporting
		IF EXISTS( SELECT 1 FROM [dbo].[TempItemDet] WHERE DocumentID in (5,7))
		 BEGIN

			DECLARE @status int = 1;
			DECLARE  @transStatus int=0;

			INSERT INTO TransactionDet
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
			  ,TransStatus
			  ,ZNo
			  ,[RecallAvdInvoice]
			  ,[SaleStatus]
			  ,[AdvaneReceiptNo]
			  ,[CurrencyID]
			  ,[CurrencyRate]
			  ,[ProductColorSizeID]
			  ,[ExchangeReasonID]
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
			  ,'xxx-void' ----receipt
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
			  ,@CashierID
			  ,@status
			  ,@transStatus
			  ,@ZNo
			  ,[RecallAvdInvoice]
			  ,'' 
			  ,[RecallNo]
			  ,0
			  ,0
			  ,[ProductColorSizeID]
			  ,[ExchangeReasonID]
			  FROM [dbo].[TempItemDet] WHERE LocationID=@LocationID and UnitNo=@UnitNo AND DocumentID in (5,7)

			  delete FROM [dbo].[TempItemDet] WHERE LocationID=@LocationID and UnitNo=@UnitNo AND DocumentID in (5,7)
			
		 END


	  		         
    SELECT @vouchersalegross = ISNULL(sum(CASE DocumentID WHEN 1 THEN Amount 
						WHEN 2 THEN -Amount ELSE 0 END), 0),
						@nvouchersale = ISNULL(COUNT(DocumentID), 0)
						FROM TransactionDet
						WHERE LocationID = @LocationID AND (DocumentID = 1 OR DocumentID =2) 
						AND Status = 1 AND TransStatus=1 AND BillTypeID=1 AND SaleTypeID=2 AND UnitNo=@UnitNo
						AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')
						


            
     SELECT @voudiscount = ISNULL(sum(SDiscount), 0),@nvoudiscount = ISNULL(COUNT(DocumentID), 0)						
						FROM TransactionDet
						WHERE LocationID = @LocationID AND (DocumentID =6) 
						AND Status = 1 AND TransStatus=1 AND SaleTypeID=2 AND UnitNo=@UnitNo
						AND BillTypeID=1
						AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')

     SELECT @voudiscount =@voudiscount+ ISNULL(sum(IDiscount1+IDiscount2+IDiscount3+IDiscount4+IDiscount5), 0),
						  @nvoudiscount = @nvoudiscount+ISNULL(COUNT(DocumentID), 0)						
						FROM TransactionDet
						WHERE LocationID = @LocationID AND (DocumentID = 1 OR DocumentID =2) 
						AND Status = 1 AND TransStatus=1 AND SaleTypeID=2 AND UnitNo=@UnitNo
						AND BillTypeID=1
						AND (IDiscount1<>0 or IDiscount2<>0 or IDiscount3<>0 or IDiscount4<>0 or IDiscount5 <>0)
						AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')
						    
     SELECT @loyaltyRedeem=ISNULL(SUM(Amount),0),@nloyaltyRedeem=ISNULL(count(PaytypeID),0)     
						FROM PaymentDet
						WHERE LocationID = @LocationID AND PayTypeID=5
						AND Status = 1 AND UnitNo=@UnitNo  AND SaleTypeID=1
						AND BillTypeID=1 AND Amount>0
						AND (SaleStatus='C' OR Isnull(SaleStatus,'')='') 
						AND RecallAvdInvoice = 0   
						
    SELECT @vouRedeem=ISNULL(SUM(Amount),0),@nvouRedeem=ISNULL(count(PaytypeID),0)     
						FROM PaymentDet
						WHERE LocationID = @LocationID AND PayTypeID=5
						AND Status = 1 AND UnitNo=@UnitNo  AND SaleTypeID=2 
						AND BillTypeID=1 AND Amount>0  
						AND (SaleStatus='C' OR Isnull(SaleStatus,'')='') 
						AND RecallAvdInvoice = 0         

            SET @vouchernet = @vouchersalegross - @voudiscount - @vouRedeem

            SELECT @vouchercash = ISNULL(sum(CASE WHEN PaymentDet.Amount > PaymentDet.Balance THEN PaymentDet.Balance ELSE PaymentDet.Amount END ),0)
            FROM PaymentDet
            WHERE LocationID = @LocationID AND PayTypeID=1
			AND Status = 1 AND UnitNo=@UnitNo AND BillTypeID=1
			AND SaleTypeID=2 AND Amount>0 AND CustomerType!=2
			AND (SaleStatus='C' OR Isnull(SaleStatus,'')='') 
						AND RecallAvdInvoice = 0   

            SELECT @vouchercredit = ISNULL(sum(ISNULL(Amount, 0)), 0)
            FROM PaymentDet
            WHERE LocationID = @LocationID AND PayTypeID!=1  AND PayTypeID!=5   AND PayTypeID!=8
			AND Status = 1 AND UnitNo=@UnitNo AND BillTypeID=1
			AND SaleTypeID=2 AND Amount>0 AND CustomerType!=2
			AND (SaleStatus='C' OR Isnull(SaleStatus,'')='') 
						AND RecallAvdInvoice = 0   

			SELECT @Vstaffcashsale = ISNULL(sum(CASE WHEN PaymentDet.Amount > PaymentDet.Balance THEN PaymentDet.Balance ELSE PaymentDet.Amount END ),0)
            FROM PaymentDet
            WHERE LocationID = @LocationID AND PayTypeID=1
			AND Status = 1 AND UnitNo=@UnitNo AND BillTypeID=1
			AND SaleTypeID=2 AND Amount>0 AND CustomerType=2
			AND (SaleStatus='C' OR Isnull(SaleStatus,'')='') 
						AND RecallAvdInvoice = 0   

            SELECT @VstaffCreditSale = ISNULL(sum(ISNULL(Amount, 0)), 0)
            FROM PaymentDet
            WHERE LocationID = @LocationID AND PayTypeID=8
			AND Status = 1 AND UnitNo=@UnitNo AND BillTypeID=1
			AND SaleTypeID=2 AND Amount>0 AND CustomerType=2
			AND (SaleStatus='C' OR Isnull(SaleStatus,'')='') 
						AND RecallAvdInvoice = 0   
			--gift card

			begin

			SELECT @GiftCardsalegross = ISNULL(sum(CASE DocumentID WHEN 1 THEN Amount 
						WHEN 2 THEN -Amount ELSE 0 END), 0),
						@nGiftCardsalegross = ISNULL(COUNT(DocumentID), 0)
						FROM TransactionDet
						WHERE LocationID = @LocationID AND (DocumentID = 1 OR DocumentID =2) 
						AND Status = 1 AND TransStatus=1 AND BillTypeID=1 AND SaleTypeID=7 AND UnitNo=@UnitNo
						AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')
						


            
     SELECT @GiftCardDiscount = ISNULL(sum(SDiscount), 0),@nGiftCardDiscount = ISNULL(COUNT(DocumentID), 0)						
						FROM TransactionDet
						WHERE LocationID = @LocationID AND (DocumentID =6) 
						AND Status = 1 AND TransStatus=1 AND SaleTypeID=7 AND UnitNo=@UnitNo
						AND BillTypeID=1
						AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')

     SELECT @GiftCardDiscount =@GiftCardDiscount+ ISNULL(sum(IDiscount1+IDiscount2+IDiscount3+IDiscount4+IDiscount5), 0),
						  @nGiftCardDiscount = @nGiftCardDiscount+ISNULL(COUNT(DocumentID), 0)						
						FROM TransactionDet
						WHERE LocationID = @LocationID AND (DocumentID = 1 OR DocumentID =2) 
						AND Status = 1 AND TransStatus=1 AND SaleTypeID=7 AND UnitNo=@UnitNo
						AND BillTypeID=1
						AND (IDiscount1<>0 or IDiscount2<>0 or IDiscount3<>0 or IDiscount4<>0 or IDiscount5 <>0) 
						AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')
						    
    
						
    SELECT @GiftCardRedeem=ISNULL(SUM(Amount),0),@nGiftCardRedeem=ISNULL(count(PaytypeID),0)     
						FROM PaymentDet
						WHERE LocationID = @LocationID AND PayTypeID=5
						AND Status = 1 AND UnitNo=@UnitNo  AND SaleTypeID=7 
						AND BillTypeID=1 AND Amount>0     
						AND (SaleStatus='C' OR Isnull(SaleStatus,'')='') 
						AND RecallAvdInvoice = 0     

            SET @GiftCardnet = @GiftCardsalegross - @GiftCardDiscount - @GiftCardRedeem

            SELECT @GiftCardcash = ISNULL(sum(CASE WHEN PaymentDet.Amount > PaymentDet.Balance THEN PaymentDet.Balance ELSE PaymentDet.Amount END ),0)
            FROM PaymentDet
            WHERE LocationID = @LocationID AND PayTypeID=1
			AND Status = 1 AND UnitNo=@UnitNo AND BillTypeID=1
			AND SaleTypeID=7 AND Amount>0 AND CustomerType!=2
			AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')
			AND RecallAvdInvoice = 0

            SELECT @GiftCardcredit = ISNULL(sum(ISNULL(Amount, 0)), 0)
            FROM PaymentDet
            WHERE LocationID = @LocationID AND PayTypeID!=1  AND PayTypeID!=5   AND PayTypeID!=8
			AND Status = 1 AND UnitNo=@UnitNo AND BillTypeID=1
			AND SaleTypeID=7 AND Amount>0 AND CustomerType!=2
			AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')
			AND RecallAvdInvoice = 0

			SELECT @GiftCardstaffcashsale = ISNULL(sum(CASE WHEN PaymentDet.Amount > PaymentDet.Balance THEN PaymentDet.Balance ELSE PaymentDet.Amount END ),0)
            FROM PaymentDet
            WHERE LocationID = @LocationID AND PayTypeID=1
			AND Status = 1 AND UnitNo=@UnitNo AND BillTypeID=1
			AND SaleTypeID=7 AND Amount>0 AND CustomerType=2
			AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')
			AND RecallAvdInvoice = 0

            SELECT @GiftCardcredit = ISNULL(sum(ISNULL(Amount, 0)), 0)
            FROM PaymentDet
            WHERE LocationID = @LocationID AND PayTypeID=8
			AND Status = 1 AND UnitNo=@UnitNo AND BillTypeID=1
			AND SaleTypeID=7 AND Amount>0 AND CustomerType=2
			AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')
			AND RecallAvdInvoice = 0

			end


		SELECT @grosssale = ISNULL(sum(Amount),0)
						FROM TransactionDet
						WHERE LocationID = @LocationID AND (DocumentID = 1 OR DocumentID =3) 
						AND Status = 1 AND TransStatus=1 AND SaleTypeID=1 AND UnitNo=@UnitNo
						AND BillTypeID=1
						AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')
            
        

		SELECT @refunds = ISNULL(sum(Amount),0),@nrefunds= ISNULL(sum(Qty),0)
						FROM TransactionDet
						WHERE LocationID = @LocationID AND (DocumentID = 2 OR DocumentID =4) 
						AND Status = 1 AND TransStatus=1 AND SaleTypeID=1 AND UnitNo=@UnitNo
						AND BillTypeID=1
						AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')

		SELECT @Excrefunds = ISNULL(sum(Amount),0),@nExcrefunds= ISNULL(sum(Qty),0)
						FROM TransactionDet
						WHERE LocationID = @LocationID AND (DocumentID = 2 OR DocumentID =4) 
						AND Status = 1 AND TransStatus=1 AND SaleTypeID=1 AND UnitNo=@UnitNo
						AND BillTypeID=1
						AND RecallUnitNo IN (SELECT  ExchangeUnitNo FROM SysConfig)
						AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')
            
		SELECT @Idiscount = ISNULL(sum(CASE WHEN DocumentID=1 OR DocumentID=3 THEN (IDiscount1+IDiscount2+IDiscount3+IDiscount4+IDiscount5)
							WHEN DocumentID=2 OR DocumentID=4 THEN -(IDiscount1+IDiscount2+IDiscount3+IDiscount4+IDiscount5) ELSE 0 END ),0),
							@nIdiscount = ISNULL(count(DocumentID),0)
						FROM TransactionDet
						WHERE LocationID = @LocationID AND (DocumentID = 1 OR DocumentID =2 or DocumentID = 3 OR DocumentID =4) 
						AND Status = 1 AND TransStatus=1  AND UnitNo=@UnitNo
						AND BillTypeID=1  AND SaleTypeID=1
						AND (IDiscount1<>0 or IDiscount2<>0 or IDiscount3<>0 or IDiscount4<>0 or IDiscount5 <>0) 
						AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')
						
            

         SELECT @sdiscount = ISNULL(sum(SDiscount), 0),@nsdiscount = ISNULL(COUNT(DocumentID), 0)						
						FROM TransactionDet
						WHERE LocationID = @LocationID AND (DocumentID =6) 
						AND Status = 1 AND TransStatus=1  AND UnitNo=@UnitNo
						AND BillTypeID=1 AND SaleTypeID=1   
						AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')

         SELECT @voids = ISNULL(sum(Nett), 0),@nvoids = ISNULL(COUNT(DocumentID), 0)						
						FROM TransactionDet
						WHERE LocationID = @LocationID AND (DocumentID = 5) 
						AND Status = 1 AND UnitNo=@UnitNo
			
		SELECT @voidscancel = ISNULL(sum(Nett), 0),@nvoidscancel = ISNULL(COUNT(DocumentID), 0)						
						FROM TransactionDet
						WHERE LocationID = @LocationID AND (DocumentID = 5) 
						AND Status = 0 AND UnitNo=@UnitNo
								

         SELECT @error = ISNULL(sum(Nett), 0),@nerror = ISNULL(COUNT(DocumentID), 0)						
						FROM TransactionDet
						WHERE LocationID = @LocationID AND (DocumentID = 7) 
						AND Status = 1  AND UnitNo=@UnitNo
						

           


		SELECT @cancel = ISNULL(sum(CASE WHEN DocumentID = 1 OR DocumentID = 3 THEN Nett 
						 WHEN DocumentID = 2 OR DocumentID = 3 OR DocumentID = 6 OR DocumentID = 8 THEN -Nett  ELSE 0 END), 0)
						 --,
						--@ncancel = ISNULL(COUNT(DocumentID),0)
						FROM TransactionDet
						WHERE LocationID = @LocationID 
						AND (DocumentID = 1 OR DocumentID =2 OR DocumentID =3 OR DocumentID =4 OR DocumentID =6 OR DocumentID =8) 
						AND Status = 0 AND UnitNo=@UnitNo
						AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')
						
         SELECT DISTINCT Receipt INTO #T
						FROM TransactionDet
						WHERE LocationID = @LocationID 
						AND (DocumentID = 1 OR DocumentID =2 OR DocumentID =3 OR DocumentID =4 OR DocumentID =6 OR DocumentID =8) 
						AND Status = 0 AND UnitNo=@UnitNo
						AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')
						--AND UpdateBy=@CashierID

		SELECT @ncancel=@@ROWCOUNT   

      SELECT @loyalty=ISNULL(SUM(Amount),0),@nloyalty=ISNULL(count(PaytypeID),0)     
						FROM PaymentDet
						WHERE LocationID = @LocationID AND PayTypeID=14
						AND Status = 1 AND UnitNo=@UnitNo   AND SaleTypeID=1
						AND BillTypeID=1 AND Amount>0
						AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')
						AND RecallAvdInvoice = 0

 
      SELECT @nett= ISNULL(sum(CASE WHEN DocumentID = 1 OR DocumentID = 3 THEN Nett 
						 WHEN DocumentID = 2 OR DocumentID = 3 OR DocumentID = 6 THEN -Nett  ELSE 0 END), 0)
						FROM TransactionDet
						WHERE LocationID = @LocationID 
						AND (DocumentID = 1 OR DocumentID =2 OR DocumentID =3 OR DocumentID =4 OR DocumentID =6 OR DocumentID =8) 
						AND Status = 1 AND SaleTypeID=1 AND UnitNo=@UnitNo
						AND BillTypeID=1  AND TransStatus=1
						AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')

		SET @nett=@nett-@loyaltyRedeem
      --     SELECT @paidout=ISNULL(SUM(Amount),0),@npaidout=ISNULL(count(PaytypeID),0)     
						--FROM PaymentDet
						--WHERE LocationID = @LocationID AND BillTypeID=3
						--AND Status = 1 AND UnitNo=@UnitNo
						--AND Amount>0

						SELECT @paidout= ISNULL(SUM(p.Amount),0),@npaidout= ISNULL(count(p.DocumentID),0)     
						FROM TransactionDet p inner join PaidOutType pt
						on p.ProductID=pt.PaidOutTypeID
						WHERE p.LocationID = @LocationID AND p.BillTypeID=3
						AND p.Status = 1 AND p.UnitNo=@UnitNo and DocumentID=8
						AND p.Amount>0 and [IsSalesSummery]=1
						AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')

						SELECT @paidin= ISNULL(SUM(p.Amount),0),@npaidin= ISNULL(count(p.DocumentID),0)     
						FROM TransactionDet p inner join PaidInType pt
						on p.ProductID=pt.PaidInTypeID
						WHERE p.LocationID = @LocationID AND p.BillTypeID=6
						AND p.Status = 1 AND p.UnitNo=@UnitNo and DocumentID=9
						AND p.Amount>0 and [IsSalesSummery]=1
						AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')

						SELECT @vSalaryAdvance= ISNULL(SUM(p.Amount),0),@nSalaryAdvance= ISNULL(count(p.DocumentID),0)     
						FROM TransactionDet p inner join PaidOutType pt
						on p.ProductID=pt.PaidOutTypeID
						WHERE p.LocationID = @LocationID AND p.BillTypeID=3
						AND p.Status = 1 AND p.UnitNo=@UnitNo and DocumentID=8
						AND p.Amount>0 and [IsSalesSummery]=0 and p.ProductID=3
						AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')

						SELECT @vArawanaRedeem= ISNULL(SUM(p.Amount),0),@nArawanaRedeem= ISNULL(count(p.DocumentID),0)     
						FROM TransactionDet p inner join PaidOutType pt
						on p.ProductID=pt.PaidOutTypeID
						WHERE p.LocationID = @LocationID AND p.BillTypeID=3
						AND p.Status = 1 AND p.UnitNo=@UnitNo and DocumentID=8
						AND p.Amount>0 and [IsSalesSummery]=0 and p.ProductID=6
						AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')

						SELECT @vRaccRedeem= ISNULL(SUM(p.Amount),0)     
						FROM TransactionDet p inner join PaidOutType pt
						on p.ProductID=pt.PaidOutTypeID
						WHERE p.LocationID = @LocationID AND p.BillTypeID=3
						AND p.Status = 1 AND p.UnitNo=@UnitNo and DocumentID=8
						AND p.Amount>0 and [IsSalesSummery]=0 and p.ProductID=4
						AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')

						SELECT @ReceivedOnAccount= ISNULL( SUM(Amount),0)-@vRaccRedeem 
						FROM ReceivedOnAccount WHERE UnitNo=@UnitNo 
						AND ZNo=@ZNo AND LocationID=@LocationID

/*


            SELECT @credpay = ISNULL(sum(
               CASE 
                  WHEN IId = 001 OR IId = 003 THEN Nett
                  WHEN IId = 002 OR IId = 004 OR IId = 006 THEN -Nett
                  ELSE 0
               END), 0)
            FROM TransactionDet
            WHERE 
               LocationID = @LocationID AND 
               RecDate BETWEEN @DateF1 AND @DateF2 AND 
               Status = 1 AND 
               SaleType = N'C' AND UnitNo=@UnitNo

            SELECT @ncredpay = ISNULL(count_big(DISTINCT Receipt), 0)
            FROM TransactionDet
            WHERE 
               LocationID = @LocationID AND 
               RecDate BETWEEN @DateF1 AND @DateF2 AND 
               Status = 1 AND 
               SaleType = N'C' AND UnitNo=@UnitNo
 */
            SELECT @cashsale=ISNULL(sum(CASE WHEN PaymentDet.Amount > PaymentDet.Balance THEN PaymentDet.Balance ELSE PaymentDet.Amount END ),0)     
						FROM PaymentDet  INNER JOIN (SELECT distinct LocationID,UnitNo,Receipt,ZNo FROM TransactionDet WHERE TransStatus=1) t ON PaymentDet.LocationID=t.LocationID AND PaymentDet.UnitNo=t.UnitNo AND PaymentDet.Receipt=t.Receipt AND PaymentDet.ZNo=t.ZNo
						WHERE PaymentDet.LocationID =@LocationID  AND BillTypeID=1
						AND  PaymentDet.UnitNo=@UnitNo AND PayTypeID=1   AND SaleTypeID=1 AND Status = 1
						AND Balance>0 AND CustomerType!=2
						AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')
						--AND RecallAvdInvoice = 0

						SELECT @paidincash=ISNULL(sum(CASE WHEN PaymentDet.Amount > PaymentDet.Balance THEN PaymentDet.Balance ELSE PaymentDet.Amount END ),0)     
						FROM PaymentDet
						WHERE LocationID = @LocationID AND BillTypeID=6
						AND Status = 1 AND UnitNo=@UnitNo AND PayTypeID=1   AND SaleTypeID=1
						AND  Balance>0 
						AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')
						AND RecallAvdInvoice = 0

            SELECT @staffcashsale=ISNULL(sum(CASE WHEN PaymentDet.Amount > PaymentDet.Balance THEN PaymentDet.Balance ELSE PaymentDet.Amount END ),0) ,@nstaffcashsale=abs(ISNULL(COUNT(PayTypeID),0))
						FROM PaymentDet
						WHERE LocationID = @LocationID AND BillTypeID=1  AND SaleTypeID=1
						AND Status = 1 AND UnitNo=@UnitNo AND PayTypeID=1
						AND CustomerType=2 AND Balance>0
						AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')
						AND RecallAvdInvoice = 0
						

           SELECT @cashrefund=abs(ISNULL(SUM(Amount),0)) ,@ncashrefund=abs(ISNULL(COUNT(PayTypeID),0))    
						FROM PaymentDet
						WHERE LocationID = @LocationID AND BillTypeID=1
						AND Status = 1 AND UnitNo=@UnitNo AND PayTypeID=1
						AND Amount<0  AND SaleTypeID=1
						AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')
						AND RecallAvdInvoice = 0

									---Advance Payment Details on 2015-06-17
			SELECT @advancepayments = ISNULL(sum(Amount),0) --advance payment
						FROM PaymentDet                      
						WHERE UnitNo=@UnitNo AND LocationID=@LocationID AND SaleStatus = 'A' and RecallAvdInvoice=0
						AND SaleTypeID=1 AND BillTypeID=1



			SELECT @advancerefunds =ISNULL(sum(Amount),0) --advance refund
						FROM PaymentDet
						WHERE UnitNo=@UnitNo AND LocationID=@LocationID AND SaleStatus = 'X' AND RecallAvdInvoice=1
						AND SaleTypeID=1 AND BillTypeID=1



			SELECT @advancesetoffs =ISNULL(sum(Amount),0) --advance set-off
						FROM PaymentDet
						WHERE UnitNo=@UnitNo AND LocationID=@LocationID AND SaleStatus = 'C' AND RecallAvdInvoice=1
						AND SaleTypeID=1 AND BillTypeID=1


			 SET @advancebalances = @advancepayments - @advancerefunds - @advancesetoffs -- balance
						

/*
            
			SELECT @advancereceive=abs(ISNULL(SUM(Amount),0)) ,@nadvancereceive=abs(ISNULL(COUNT(PayTypeID),0))    
						FROM PaymentDet
						WHERE LocationID = @LocationID AND BillTypeID=5
						AND Status = 1 AND UnitNo=@UnitNo
						AND  Amount>0
						AND UpdatedBy=@CashierID
            
            SELECT @advancerefund=abs(ISNULL(SUM(Amount),0)) ,@nadvancerefund=abs(ISNULL(COUNT(PayTypeID),0))    
						FROM PaymentDet
						WHERE LocationID = @LocationID AND BillTypeID=5
						AND Status = 1 AND UnitNo=@UnitNo
						AND  Amount<0
						AND UpdatedBy=@CashierID

           

            SELECT @advancereceivecrd = abs(ISNULL(sum(Amount), 0))
            FROM PaymentDet
            WHERE 
               LocationID = @LocationID AND 
               SDATE BETWEEN @DateF1 AND @DateF2 AND 
               PStatus = N'A' AND 
               TypeId <> 1 AND 
               Amount >= 0 AND UnitNo=@UnitNo

            SELECT @nadvancereceivecrd = ISNULL(count_big(Amount), 0)
            FROM PaymentDet
            WHERE 
               LocationID = @LocationID AND 
               SDATE BETWEEN @DateF1 AND @DateF2 AND 
               PStatus = N'A' AND 
               TypeId <> 1 AND 
               Amount >= 0 AND UnitNo=@UnitNo

            SELECT @advancerefundcrd = abs(ISNULL(sum(Amount), 0))
            FROM PaymentDet
            WHERE 
               LocationID = @LocationID AND 
               SDATE BETWEEN @DateF1 AND @DateF2 AND 
               PStatus = N'A' AND 
               TypeId <> 1 AND 
               Amount < 0 AND UnitNo=@UnitNo

            SELECT @nadvancerefundcrd = ISNULL(count_big(Amount), 0)
            FROM PaymentDet
            WHERE 
               LocationID = @LocationID AND 
  SDATE BETWEEN @DateF1 AND @DateF2 AND 
               PStatus = N'A' AND 
               TypeId <> 1 AND 
               Amount < 0 AND UnitNo=@UnitNo

            SELECT @advancesettlement = abs(ISNULL(sum(Amount), 0))
            FROM PaymentDet
            WHERE 
               LocationID = @LocationID AND 
               SDATE BETWEEN @DateF1 AND @DateF2 AND 
               PStatus = N'D' AND UnitNo=@UnitNo

            SELECT @nadvancesettlement = ISNULL(count_big(DISTINCT AdvanceNo), 0)
            FROM PaymentDet
            WHERE 
               LocationID = @LocationID AND 
               SDATE BETWEEN @DateF1 AND @DateF2 AND 
               PStatus = N'D' AND UnitNo=@UnitNo
*/
            SELECT @noofbills = ISNULL(count(DISTINCT Receipt), 0)
            FROM PaymentDet
            WHERE LocationID = @LocationID
			AND Status = 1 AND UnitNo=@UnitNo
			AND BillTypeID=1
			AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')
			AND RecallAvdInvoice = 0


			SELECT  @noofsalebills =ISNULL(count(DISTINCT Receipt), 0)
            FROM TransactionDet 
			WHERE LocationID = @LocationID
			AND [Status] = 1 AND UnitNo=@UnitNo
			AND DocumentID IN (1,3) and SaleTypeID=1
            and BillTypeID=1
			AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')
			AND RecallAvdInvoice = 0

            

            SELECT @voucher = ISNULL(sum(ISNULL(Amount, 0)), 0),@nvoucher = ISNULL(COUNT(ISNULL(PayTypeID, 0)), 0)
            FROM PaymentDet
            WHERE LocationID = @LocationID
			AND Status = 1 AND UnitNo=@UnitNo AND PayTypeID=6
			AND BillTypeID=1  AND SaleTypeID=1 
			AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')
			AND RecallAvdInvoice = 0

			SELECT @GiftCard = ISNULL(sum(ISNULL(Amount, 0)), 0),@nGiftCard = ISNULL(COUNT(ISNULL(PayTypeID, 0)), 0)
            FROM PaymentDet
            WHERE LocationID = @LocationID
			AND Status = 1 AND UnitNo=@UnitNo AND PayTypeID=19
			AND BillTypeID=1  AND SaleTypeID=1 
			AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')
			AND RecallAvdInvoice = 0

           
            SELECT @staffcred = ISNULL(sum(ISNULL(Amount, 0)), 0),@nstaffcred = ISNULL(COUNT(ISNULL(PayTypeID, 0)), 0)
            FROM PaymentDet
            WHERE LocationID = @LocationID
			AND Status = 1 AND UnitNo=@UnitNo AND PayTypeID=8
			AND BillTypeID=1
			AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')
			AND RecallAvdInvoice = 0
           

            SELECT @cheque = ISNULL(sum(ISNULL(Amount, 0)), 0),@ncheque = ISNULL(COUNT(ISNULL(PayTypeID, 0)), 0)
            FROM PaymentDet
            WHERE LocationID = @LocationID
			AND Status = 1 AND UnitNo=@UnitNo AND PayTypeID=9
			AND BillTypeID=1  AND SaleTypeID=1 
			AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')
			AND RecallAvdInvoice = 0

            /*

            SELECT @starpoint = ISNULL(sum(ISNULL(Amount, 0)), 0)
            FROM PaymentDet
            WHERE 
               LocationID = @LocationID AND 
               SDATE BETWEEN @DateF1 AND @DateF2 AND 
               PStatus = N'S' AND 
               TypeId = 10 AND UnitNo=@UnitNo

            SELECT @starpointErn = ISNULL(sum(ISNULL(Amount, 0)), 0)
            FROM PaymentDet
            WHERE 
               LocationID = @LocationID AND 
               SDATE BETWEEN @DateF1 AND @DateF2 AND 
               TypeId = 999 AND UnitNo=@UnitNo

            SELECT @starpointErnVal = ISNULL(sum(ISNULL(Balance, 0)), 0)
            FROM PaymentDet
            WHERE 
               LocationID = @LocationID AND 
               SDATE BETWEEN @DateF1 AND @DateF2 AND 
               TypeId = 999 AND UnitNo=@UnitNo

            SELECT @nstarpoint = ISNULL(count_big(Amount), 0)
            FROM PaymentDet
            WHERE 
               LocationID = @LocationID AND 
               SDATE BETWEEN @DateF1 AND @DateF2 AND 
               PStatus = N'S' AND 
               TypeId = 10 AND UnitNo=@UnitNo

            SELECT @mcredit = ISNULL(sum(ISNULL(Amount, 0)), 0)
            FROM PaymentDet
            WHERE 
               LocationID = @LocationID AND 
               SDATE BETWEEN @DateF1 AND @DateF2 AND 
               PStatus = N'S' AND 
               TypeId = 11 AND UnitNo=@UnitNo

            SELECT @nmcredit = ISNULL(count_big(Amount), 0)
            FROM PaymentDet
            WHERE 
               LocationID = @LocationID AND 
               SDATE BETWEEN @DateF1 AND @DateF2 AND 
               PStatus = N'S' AND 
               TypeId = 11 AND UnitNo=@UnitNo

            SELECT @credit = ISNULL(sum(ISNULL(Amount, 0)), 0)
            FROM PaymentDet
            WHERE 
               LocationID = @LocationID AND 
               SDATE BETWEEN @DateF1 AND @DateF2 AND 
               PStatus = N'S' AND 
               TypeId = 12 AND UnitNo=@UnitNo

            SELECT @ncredit = ISNULL(count_big(Amount), 0)
            FROM PaymentDet
            WHERE 
               LocationID = @LocationID AND 
               SDATE BETWEEN @DateF1 AND @DateF2 AND 
               PStatus = N'S' AND 
               TypeId = 12 AND UnitNo=@UnitNo
*/
            SELECT @crdnote = ISNULL(sum(ISNULL(Amount, 0)), 0),@ncrdnote = ISNULL(COUNT(ISNULL(PayTypeID, 0)), 0)
            FROM PaymentDet
            WHERE LocationID = @LocationID
			AND Status = 1 AND UnitNo=@UnitNo AND PayTypeID=13
			AND BillTypeID=1  AND SaleTypeID=1 
			AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')
			AND RecallAvdInvoice = 0
			
			SELECT @crdnotestle = ISNULL(sum(ISNULL(Amount, 0)), 0),@ncrdnotestle = ISNULL(COUNT(ISNULL(PayTypeID, 0)), 0)
            FROM PaymentDet
            WHERE LocationID = @LocationID
			AND Status = 1 AND UnitNo=@UnitNo AND PayTypeID=14
			AND BillTypeID=1  AND SaleTypeID=1
			AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')
			AND RecallAvdInvoice = 0 

/*
            SELECT @other = ISNULL(sum(ISNULL(Amount, 0)), 0)
            FROM PaymentDet
            WHERE 
               LocationID = @LocationID AND 
               SDATE BETWEEN @DateF1 AND @DateF2 AND 
               PStatus = N'S' AND 
               TypeId >= 15 AND UnitNo=@UnitNo

            SELECT @nother = ISNULL(count_big(Amount), 0)
            FROM PaymentDet
            WHERE 
               LocationID = @LocationID AND 
               SDATE BETWEEN @DateF1 AND @DateF2 AND 
               PStatus = N'S' AND 
               TypeId >= 15 AND UnitNo=@UnitNo
*/


SELECT @nQtySales=ISNULL(sum(CASE DocumentID WHEN 1 THEN Qty 
WHEN 2 THEN -Qty ELSE 0 END), 0)
FROM TransactionDet
WHERE LocationID = @LocationID  AND (DocumentID = 1 OR DocumentID =2) 
AND Status = 1 AND TransStatus=1 AND BillTypeID=1 AND SaleTypeID=1 AND UnitNo=@UnitNo
AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')





			Declare @tmpAmount Money
			If Exists(Select * from CashierPermission Where CashierId=@CashierId And LocationId=@LocationId And IsAccess=1 And FunctName='YREPORT') AND @IsYReport=1
			Begin
			Select @tmpAmount=Isnull(Nos,100) From SysConfig Where @LocationID=@LocationID
				Set @Nos=@tmpAmount
				IF (@tmpAmount>100 OR @tmpAmount<=0) Set @tmpAmount=100
				Set @tmpAmount=@cashsale*(100-@tmpAmount)/100
				Set @grosssale= @grosssale-@tmpAmount
				Set @nett= @nett-@tmpAmount
				Set @cashsale=@cashsale-@tmpAmount
				If (@paidout>@cashsale) Set @paidout=@paidout-@tmpAmount 
 
			End

	  	END

 

 if @IsExchangeCounter=1
 begin
	
	IF(@ReportType=1)
	  BEGIN
	  	
	  
	  
         
	
						    
     

		   SELECT @grosssale = ISNULL(sum(Amount),0)
						FROM SuspendDet
						WHERE LocationID = @LocationID AND (DocumentID = 1 OR DocumentID =3) 
						AND  TransStatus=1 AND SaleTypeID=1 AND UnitNo=@UnitNo
						AND CashierID=@CashierID AND BillTypeID=1

            
        

		SELECT @refunds = ISNULL(sum(Amount),0),@nrefunds= ISNULL(sum(Qty),0)
						FROM SuspendDet
						WHERE LocationID = @LocationID AND (DocumentID = 2 OR DocumentID =4) 
						AND  TransStatus=1 AND SaleTypeID=1 AND UnitNo=@UnitNo
						AND CashierID=@CashierID  AND BillTypeID=1

		SELECT @Excrefunds = ISNULL(sum(Amount),0),@nExcrefunds= ISNULL(sum(Qty),0)
						FROM TransactionDet
						WHERE LocationID = @LocationID AND (DocumentID = 2 OR DocumentID =4) 
						AND TransStatus=1 AND SaleTypeID=1 AND UnitNo=@UnitNo
						AND CashierID=@CashierID  AND BillTypeID=1
						AND RecallUnitNo IN (SELECT  ExchangeUnitNo FROM SysConfig)
            
		

         SELECT @voids = ISNULL(sum(Nett), 0),@nvoids = ISNULL(COUNT(DocumentID), 0)						
						FROM TransactionDet
						WHERE LocationID = @LocationID AND (DocumentID = 5) 
						AND Status = 1 AND  UnitNo=@UnitNo
						AND CashierID=@CashierID 

		SELECT @voidscancel = ISNULL(sum(Nett), 0),@nvoidscancel = ISNULL(COUNT(DocumentID), 0)						
						FROM TransactionDet
						WHERE LocationID = @LocationID AND (DocumentID = 5) 
						AND Status = 0 AND  UnitNo=@UnitNo
						AND CashierID=@CashierID 
						

         SELECT @error = ISNULL(sum(Nett), 0),@nerror = ISNULL(COUNT(DocumentID), 0)						
						FROM SuspendDet
						WHERE LocationID = @LocationID AND (DocumentID = 7) 
						  AND UnitNo=@UnitNo
						AND CashierID=@CashierID          


		

 
      SELECT @nett= ISNULL(sum(CASE WHEN DocumentID = 1 OR DocumentID = 3 THEN Nett 
						 WHEN DocumentID = 2 OR DocumentID = 3 OR DocumentID = 6 THEN -Nett  ELSE 0 END), 0)
						FROM SuspendDet
						WHERE LocationID = @LocationID 
						AND (DocumentID = 1 OR DocumentID =2 OR DocumentID =3 OR DocumentID =4 OR DocumentID =6 OR DocumentID =8) 
						AND  SaleTypeID=1 AND UnitNo=@UnitNo
						AND CashierID=@CashierID  AND BillTypeID=1  AND TransStatus=1

		SET @nett=@nett-@loyaltyRedeem
           

						

						SELECT @ReceivedOnAccount= ISNULL( SUM(Amount),0)-@vRaccRedeem 
						FROM ReceivedOnAccount WHERE CashierID=@CashierID AND UnitNo=@UnitNo 
						AND ZNo=@ZNo AND LocationID=@LocationID



            SELECT @cashsale=ISNULL(sum(CASE WHEN PaymentDet.Amount > PaymentDet.Balance THEN PaymentDet.Balance ELSE PaymentDet.Amount END ),0)     
						FROM PaymentDet  INNER JOIN (SELECT distinct LocationID,UnitNo,Receipt,ZNo FROM TransactionDet WHERE TransStatus=1) t ON PaymentDet.LocationID=t.LocationID AND PaymentDet.UnitNo=t.UnitNo AND PaymentDet.Receipt=t.Receipt AND PaymentDet.ZNo=t.ZNo
						WHERE PaymentDet.LocationID =@LocationID  AND BillTypeID=1
						AND  PaymentDet.UnitNo=@UnitNo AND PayTypeID=1   AND SaleTypeID=1 AND Status = 1
						AND Balance>0 AND CustomerType!=2
						AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')
						
						SELECT @paidincash=ISNULL(sum(CASE WHEN PaymentDet.Amount > PaymentDet.Balance THEN PaymentDet.Balance ELSE PaymentDet.Amount END ),0)     
						FROM PaymentDet
						WHERE LocationID = @LocationID AND BillTypeID=6
						AND Status = 1 AND UnitNo=@UnitNo AND PayTypeID=1   AND SaleTypeID=1
						AND UpdatedBy=@CashierID AND Balance>0  
						AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')

            SELECT @staffcashsale=ISNULL(sum(CASE WHEN PaymentDet.Amount > PaymentDet.Balance THEN PaymentDet.Balance ELSE PaymentDet.Amount END ),0),  @nstaffcashsale=ISNULL(COUNT(PayTypeID),0)   
						FROM PaymentDet
						WHERE LocationID = @LocationID AND BillTypeID=1  AND SaleTypeID=1
						AND  UnitNo=@UnitNo AND PayTypeID=1
						AND CustomerType=2 AND Balance>0
						AND UpdatedBy=@CashierID
						AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')

           SELECT @cashrefund=abs(ISNULL(SUM(Amount),0)) ,@ncashrefund=abs(ISNULL(COUNT(PayTypeID),0))    
						FROM PaymentDet
						WHERE LocationID = @LocationID AND BillTypeID=1
						AND  UnitNo=@UnitNo AND PayTypeID=1
						AND Amount<0  AND SaleTypeID=1 
						AND UpdatedBy=@CashierID
						AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')


            SELECT @noofbills = ISNULL(count(DISTINCT Receipt), 0)
            FROM PaymentDet
            WHERE LocationID = @LocationID
			AND  UnitNo=@UnitNo
			AND UpdatedBy=@CashierID AND BillTypeID=1
			AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')

			SELECT  @noofsalebills =ISNULL(count(DISTINCT Receipt), 0)
            FROM TransactionDet 
			WHERE LocationID = @LocationID
			AND [Status] = 1 AND UnitNo=@UnitNo
			AND UpdateBy=@CashierID AND DocumentID IN (1,3) and SaleTypeID=1
            and BillTypeID=1
			AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')
			AND RecallAvdInvoice = 0

            

            SELECT @voucher = ISNULL(sum(ISNULL(Amount, 0)), 0),@nvoucher = ISNULL(COUNT(ISNULL(PayTypeID, 0)), 0)
            FROM PaymentDet
            WHERE LocationID = @LocationID
			AND  UnitNo=@UnitNo AND PayTypeID=6
			AND UpdatedBy=@CashierID AND BillTypeID=1  AND SaleTypeID=1 
			AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')

           
            SELECT @staffcred = ISNULL(sum(ISNULL(Amount, 0)), 0),@nstaffcred = ISNULL(COUNT(ISNULL(PayTypeID, 0)), 0)
            FROM PaymentDet
            WHERE LocationID = @LocationID
			AND  UnitNo=@UnitNo AND PayTypeID=8
			AND UpdatedBy=@CashierID AND BillTypeID=1
			AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')
           

            SELECT @cheque = ISNULL(sum(ISNULL(Amount, 0)), 0),@ncheque = ISNULL(COUNT(ISNULL(PayTypeID, 0)), 0)
            FROM PaymentDet
            WHERE LocationID = @LocationID
			AND  UnitNo=@UnitNo AND PayTypeID=9
			AND UpdatedBy=@CashierID AND BillTypeID=1  AND SaleTypeID=1 
			AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')
            
            SELECT @crdnote = ISNULL(sum(ISNULL(Amount, 0)), 0),@ncrdnote = ISNULL(COUNT(ISNULL(PayTypeID, 0)), 0)
            FROM PaymentDet
            WHERE LocationID = @LocationID
			AND  UnitNo=@UnitNo AND PayTypeID=13
			AND UpdatedBy=@CashierID AND BillTypeID=1  AND SaleTypeID=1 
			AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')
			
			SELECT @crdnotestle = ISNULL(sum(ISNULL(Amount, 0)), 0),@ncrdnotestle = ISNULL(COUNT(ISNULL(PayTypeID, 0)), 0)
            FROM PaymentDet
            WHERE LocationID = @LocationID
			AND  UnitNo=@UnitNo AND PayTypeID=14
			AND UpdatedBy=@CashierID AND BillTypeID=1  AND SaleTypeID=1 
			AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')

            
	  END
	  
	  ELSE
	  BEGIN
	  	
	  	SELECT @ReceivedOnAccount= ISNULL( SUM(Amount),0) FROM ReceivedOnAccount WHERE UnitNo=@UnitNo AND ZNo=@ZNo AND LocationID=@LocationID

	  		         
  

		SELECT @grosssale = ISNULL(sum(Amount),0)
						FROM SuspendDet
						WHERE LocationID = @LocationID AND (DocumentID = 1 OR DocumentID =3) 
						AND  TransStatus=1 AND SaleTypeID=1 AND UnitNo=@UnitNo
						AND BillTypeID=1

            
        

		SELECT @refunds = ISNULL(sum(Amount),0),@nrefunds= ISNULL(sum(Qty),0)
						FROM SuspendDet
						WHERE LocationID = @LocationID AND (DocumentID = 2 OR DocumentID =4) 
						AND  TransStatus=1 AND SaleTypeID=1 AND UnitNo=@UnitNo
						AND BillTypeID=1

		SELECT @Excrefunds = ISNULL(sum(Amount),0),@nExcrefunds= ISNULL(sum(Qty),0)
						FROM TransactionDet
						WHERE LocationID = @LocationID AND (DocumentID = 2 OR DocumentID =4) 
						AND Status = 1 AND TransStatus=1 AND SaleTypeID=1 AND UnitNo=@UnitNo
						AND BillTypeID=1
						AND RecallUnitNo IN (SELECT  ExchangeUnitNo FROM SysConfig)
            
		SELECT @Idiscount = ISNULL(sum(CASE WHEN DocumentID=1 OR DocumentID=3 THEN (IDiscount1+IDiscount2+IDiscount3+IDiscount4+IDiscount5)
							WHEN DocumentID=2 OR DocumentID=4 THEN -(IDiscount1+IDiscount2+IDiscount3+IDiscount4+IDiscount5) ELSE 0 END ),0),
							@nIdiscount = ISNULL(count(DocumentID),0)
						FROM SuspendDet
						WHERE LocationID = @LocationID AND (DocumentID = 1 OR DocumentID =2 or DocumentID = 3 OR DocumentID =4) 
						AND  TransStatus=1  AND UnitNo=@UnitNo
						AND BillTypeID=1  AND SaleTypeID=1
						AND (IDiscount1<>0 or IDiscount2<>0 or IDiscount3<>0 or IDiscount4<>0 or IDiscount5 <>0) 
						
            

         SELECT @sdiscount = ISNULL(sum(SDiscount), 0),@nsdiscount = ISNULL(COUNT(DocumentID), 0)						
						FROM SuspendDet
						WHERE LocationID = @LocationID AND (DocumentID =6) 
						AND  TransStatus=1  AND UnitNo=@UnitNo
						AND BillTypeID=1 AND SaleTypeID=1   

         SELECT @voids = ISNULL(sum(Nett), 0),@nvoids = ISNULL(COUNT(DocumentID), 0)						
						FROM TransactionDet
						WHERE LocationID = @LocationID AND (DocumentID = 5) 
						AND Status = 1 AND  UnitNo=@UnitNo
						
		SELECT @voidscancel = ISNULL(sum(Nett), 0),@nvoidscancel = ISNULL(COUNT(DocumentID), 0)						
						FROM TransactionDet
						WHERE LocationID = @LocationID AND (DocumentID = 5) 
						AND Status = 0 AND UnitNo=@UnitNo

         SELECT @error = ISNULL(sum(Nett), 0),@nerror = ISNULL(COUNT(DocumentID), 0)						
						FROM SuspendDet
						WHERE LocationID = @LocationID AND (DocumentID = 7) 
						  AND UnitNo=@UnitNo
						

           



      SELECT @loyalty=ISNULL(SUM(Amount),0),@nloyalty=ISNULL(count(PaytypeID),0)     
						FROM PaymentDet
						WHERE LocationID = @LocationID AND PayTypeID=14
						AND  UnitNo=@UnitNo   AND SaleTypeID=1
						AND BillTypeID=1 AND Amount>0
						AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')

 
      SELECT @nett= ISNULL(sum(CASE WHEN DocumentID = 1 OR DocumentID = 3 THEN Nett 
						 WHEN DocumentID = 2 OR DocumentID = 3 OR DocumentID = 6 THEN -Nett  ELSE 0 END), 0)
						FROM SuspendDet
						WHERE LocationID = @LocationID 
						AND (DocumentID = 1 OR DocumentID =2 OR DocumentID =3 OR DocumentID =4 OR DocumentID =6 OR DocumentID =8) 
						AND  SaleTypeID=1 AND UnitNo=@UnitNo
						AND BillTypeID=1  AND TransStatus=1

		SET @nett=@nett-@loyaltyRedeem
      --     SELECT @paidout=ISNULL(SUM(Amount),0),@npaidout=ISNULL(count(PaytypeID),0)     
						--FROM PaymentDet
						--WHERE LocationID = @LocationID AND BillTypeID=3
						--AND  UnitNo=@UnitNo
						--AND Amount>0

						SELECT @paidout= ISNULL(SUM(p.Amount),0),@npaidout= ISNULL(count(p.DocumentID),0)     
						FROM SuspendDet p inner join PaidOutType pt
						on p.ProductID=pt.PaidOutTypeID
						WHERE p.LocationID = @LocationID AND p.BillTypeID=3
						AND  p.UnitNo=@UnitNo and DocumentID=8
						AND p.Amount>0 and [IsSalesSummery]=1

						SELECT @vSalaryAdvance= ISNULL(SUM(p.Amount),0),@nSalaryAdvance= ISNULL(count(p.DocumentID),0)     
						FROM SuspendDet p inner join PaidOutType pt
						on p.ProductID=pt.PaidOutTypeID
						WHERE p.LocationID = @LocationID AND p.BillTypeID=3
						AND p.UnitNo=@UnitNo and DocumentID=8
						AND p.Amount>0 and [IsSalesSummery]=0 and p.ProductID=3

						SELECT @vArawanaRedeem= ISNULL(SUM(p.Amount),0),@nArawanaRedeem= ISNULL(count(p.DocumentID),0)     
						FROM SuspendDet p inner join PaidOutType pt
						on p.ProductID=pt.PaidOutTypeID
						WHERE p.LocationID = @LocationID AND p.BillTypeID=3
						AND  p.UnitNo=@UnitNo and DocumentID=8
						AND p.Amount>0 and [IsSalesSummery]=0 and p.ProductID=6

						SELECT @vRaccRedeem= ISNULL(SUM(p.Amount),0)     
						FROM SuspendDet p inner join PaidOutType pt
						on p.ProductID=pt.PaidOutTypeID
						WHERE p.LocationID = @LocationID AND p.BillTypeID=3
						AND  p.UnitNo=@UnitNo and DocumentID=8
						AND p.Amount>0 and [IsSalesSummery]=0 and p.ProductID=4

						SELECT @ReceivedOnAccount= ISNULL( SUM(Amount),0)-@vRaccRedeem 
						FROM ReceivedOnAccount WHERE UnitNo=@UnitNo 
						AND ZNo=@ZNo AND LocationID=@LocationID

/*


            SELECT @credpay = ISNULL(sum(
               CASE 
                  WHEN IId = 001 OR IId = 003 THEN Nett
                  WHEN IId = 002 OR IId = 004 OR IId = 006 THEN -Nett
                  ELSE 0
               END), 0)
            FROM SuspendDet
            WHERE 
               LocationID = @LocationID AND 
               RecDate BETWEEN @DateF1 AND @DateF2 AND 
                
               SaleType = N'C' AND UnitNo=@UnitNo

            SELECT @ncredpay = ISNULL(count_big(DISTINCT Receipt), 0)
            FROM SuspendDet
            WHERE 
               LocationID = @LocationID AND 
               RecDate BETWEEN @DateF1 AND @DateF2 AND 
                
               SaleType = N'C' AND UnitNo=@UnitNo
 */
            SELECT @cashsale=ISNULL(sum(CASE WHEN PaymentDet.Amount > PaymentDet.Balance THEN PaymentDet.Balance ELSE PaymentDet.Amount END ),0)     
						FROM PaymentDet  INNER JOIN (SELECT distinct LocationID,UnitNo,Receipt,ZNo FROM TransactionDet WHERE TransStatus=1) t ON PaymentDet.LocationID=t.LocationID AND PaymentDet.UnitNo=t.UnitNo AND PaymentDet.Receipt=t.Receipt AND PaymentDet.ZNo=t.ZNo
						WHERE PaymentDet.LocationID =@LocationID  AND BillTypeID=1
						AND  PaymentDet.UnitNo=@UnitNo AND PayTypeID=1   AND SaleTypeID=1 AND Status = 1
						AND Balance>0 AND CustomerType!=2
						AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')

						SELECT @paidincash=ISNULL(sum(CASE WHEN PaymentDet.Amount > PaymentDet.Balance THEN PaymentDet.Balance ELSE PaymentDet.Amount END ),0)     
						FROM PaymentDet
						WHERE LocationID = @LocationID AND BillTypeID=6
						AND Status = 1 AND UnitNo=@UnitNo AND PayTypeID=1   AND SaleTypeID=1
						AND  Balance>0 
						AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')

            SELECT @staffcashsale=ISNULL(sum(CASE WHEN PaymentDet.Amount > PaymentDet.Balance THEN PaymentDet.Balance ELSE PaymentDet.Amount END ),0) ,@nstaffcashsale=abs(ISNULL(COUNT(PayTypeID),0))
						FROM PaymentDet
						WHERE LocationID = @LocationID AND BillTypeID=1  AND SaleTypeID=1
						AND  UnitNo=@UnitNo AND PayTypeID=1
						AND CustomerType=2 AND Balance>0
						AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')
						

           SELECT @cashrefund=abs(ISNULL(SUM(Amount),0)) ,@ncashrefund=abs(ISNULL(COUNT(PayTypeID),0))    
						FROM PaymentDet
						WHERE LocationID = @LocationID AND BillTypeID=1
						AND  UnitNo=@UnitNo AND PayTypeID=1
						AND Amount<0  AND SaleTypeID=1 

									---Advance Payment Details on 2015-06-17
			SELECT @advancepayments = ISNULL(sum(Amount),0) --advance payment
			FROM PaymentDet                      
			WHERE UnitNo=@UnitNo AND LocationID=@LocationID 
			AND SaleStatus = 'A' and RecallAvdInvoice=0
			AND SaleTypeID=1 AND BillTypeID=1



			SELECT @advancerefunds =ISNULL(sum(Amount),0) --advance refund
			FROM PaymentDet
			WHERE UnitNo=@UnitNo AND LocationID=@LocationID 
			AND SaleStatus = 'X' AND RecallAvdInvoice=1
			AND SaleTypeID=1 AND BillTypeID=1



			SELECT @advancesetoffs =ISNULL(sum(Amount),0) --advance set-off
			FROM PaymentDet
			WHERE UnitNo=@UnitNo AND LocationID=@LocationID 
			AND SaleStatus = 'C' AND RecallAvdInvoice=1
			AND SaleTypeID=1 AND BillTypeID=1


			 SET @advancebalances = @advancepayments - @advancerefunds - @advancesetoffs -- balance
						

/*
            
			SELECT @advancereceive=abs(ISNULL(SUM(Amount),0)) ,@nadvancereceive=abs(ISNULL(COUNT(PayTypeID),0))    
						FROM PaymentDet
						WHERE LocationID = @LocationID AND BillTypeID=5
						AND  UnitNo=@UnitNo
						AND  Amount>0
						AND UpdatedBy=@CashierID
            
            SELECT @advancerefund=abs(ISNULL(SUM(Amount),0)) ,@nadvancerefund=abs(ISNULL(COUNT(PayTypeID),0))    
						FROM PaymentDet
						WHERE LocationID = @LocationID AND BillTypeID=5
						AND  UnitNo=@UnitNo
						AND  Amount<0
						AND UpdatedBy=@CashierID

           

            SELECT @advancereceivecrd = abs(ISNULL(sum(Amount), 0))
            FROM PaymentDet
            WHERE 
               LocationID = @LocationID AND 
               SDATE BETWEEN @DateF1 AND @DateF2 AND 
               PStatus = N'A' AND 
               TypeId <> 1 AND 
               Amount >= 0 AND UnitNo=@UnitNo

            SELECT @nadvancereceivecrd = ISNULL(count_big(Amount), 0)
            FROM PaymentDet
            WHERE 
               LocationID = @LocationID AND 
               SDATE BETWEEN @DateF1 AND @DateF2 AND 
               PStatus = N'A' AND 
               TypeId <> 1 AND 
               Amount >= 0 AND UnitNo=@UnitNo

            SELECT @advancerefundcrd = abs(ISNULL(sum(Amount), 0))
            FROM PaymentDet
            WHERE 
               LocationID = @LocationID AND 
               SDATE BETWEEN @DateF1 AND @DateF2 AND 
               PStatus = N'A' AND 
               TypeId <> 1 AND 
               Amount < 0 AND UnitNo=@UnitNo

            SELECT @nadvancerefundcrd = ISNULL(count_big(Amount), 0)
            FROM PaymentDet
            WHERE 
               LocationID = @LocationID AND 
  SDATE BETWEEN @DateF1 AND @DateF2 AND 
               PStatus = N'A' AND 
               TypeId <> 1 AND 
               Amount < 0 AND UnitNo=@UnitNo

            SELECT @advancesettlement = abs(ISNULL(sum(Amount), 0))
            FROM PaymentDet
            WHERE 
               LocationID = @LocationID AND 
               SDATE BETWEEN @DateF1 AND @DateF2 AND 
               PStatus = N'D' AND UnitNo=@UnitNo

            SELECT @nadvancesettlement = ISNULL(count_big(DISTINCT AdvanceNo), 0)
            FROM PaymentDet
            WHERE 
               LocationID = @LocationID AND 
               SDATE BETWEEN @DateF1 AND @DateF2 AND 
               PStatus = N'D' AND UnitNo=@UnitNo
*/
            SELECT @noofbills = ISNULL(count(DISTINCT Receipt), 0)
            FROM PaymentDet
            WHERE LocationID = @LocationID
			AND  UnitNo=@UnitNo
			AND BillTypeID=1
			AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')


			SELECT  @noofsalebills =ISNULL(count(DISTINCT Receipt), 0)
            FROM TransactionDet 
			WHERE LocationID = @LocationID
			AND [Status] = 1 AND UnitNo=@UnitNo
			AND DocumentID IN (1,3) and SaleTypeID=1
            and BillTypeID=1
			AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')
			AND RecallAvdInvoice = 0
            

            SELECT @voucher = ISNULL(sum(ISNULL(Amount, 0)), 0),@nvoucher = ISNULL(COUNT(ISNULL(PayTypeID, 0)), 0)
            FROM PaymentDet
            WHERE LocationID = @LocationID
			AND  UnitNo=@UnitNo AND PayTypeID=6
			AND BillTypeID=1  AND SaleTypeID=1 
			AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')

           
            SELECT @staffcred = ISNULL(sum(ISNULL(Amount, 0)), 0),@nstaffcred = ISNULL(COUNT(ISNULL(PayTypeID, 0)), 0)
            FROM PaymentDet
            WHERE LocationID = @LocationID
			AND  UnitNo=@UnitNo AND PayTypeID=8
			AND BillTypeID=1
			AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')
           

            SELECT @cheque = ISNULL(sum(ISNULL(Amount, 0)), 0),@ncheque = ISNULL(COUNT(ISNULL(PayTypeID, 0)), 0)
            FROM PaymentDet
            WHERE LocationID = @LocationID
			AND  UnitNo=@UnitNo AND PayTypeID=9
			AND BillTypeID=1  AND SaleTypeID=1 
			AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')

            /*

            SELECT @starpoint = ISNULL(sum(ISNULL(Amount, 0)), 0)
            FROM PaymentDet
            WHERE 
               LocationID = @LocationID AND 
               SDATE BETWEEN @DateF1 AND @DateF2 AND 
               PStatus = N'S' AND 
               TypeId = 10 AND UnitNo=@UnitNo

            SELECT @starpointErn = ISNULL(sum(ISNULL(Amount, 0)), 0)
            FROM PaymentDet
            WHERE 
               LocationID = @LocationID AND 
               SDATE BETWEEN @DateF1 AND @DateF2 AND 
               TypeId = 999 AND UnitNo=@UnitNo

            SELECT @starpointErnVal = ISNULL(sum(ISNULL(Balance, 0)), 0)
            FROM PaymentDet
            WHERE 
               LocationID = @LocationID AND 
               SDATE BETWEEN @DateF1 AND @DateF2 AND 
               TypeId = 999 AND UnitNo=@UnitNo

            SELECT @nstarpoint = ISNULL(count_big(Amount), 0)
            FROM PaymentDet
            WHERE 
               LocationID = @LocationID AND 
               SDATE BETWEEN @DateF1 AND @DateF2 AND 
               PStatus = N'S' AND 
               TypeId = 10 AND UnitNo=@UnitNo

            SELECT @mcredit = ISNULL(sum(ISNULL(Amount, 0)), 0)
            FROM PaymentDet
            WHERE 
               LocationID = @LocationID AND 
               SDATE BETWEEN @DateF1 AND @DateF2 AND 
               PStatus = N'S' AND 
               TypeId = 11 AND UnitNo=@UnitNo

            SELECT @nmcredit = ISNULL(count_big(Amount), 0)
            FROM PaymentDet
            WHERE 
               LocationID = @LocationID AND 
               SDATE BETWEEN @DateF1 AND @DateF2 AND 
               PStatus = N'S' AND 
               TypeId = 11 AND UnitNo=@UnitNo

            SELECT @credit = ISNULL(sum(ISNULL(Amount, 0)), 0)
            FROM PaymentDet
            WHERE 
               LocationID = @LocationID AND 
               SDATE BETWEEN @DateF1 AND @DateF2 AND 
               PStatus = N'S' AND 
               TypeId = 12 AND UnitNo=@UnitNo

            SELECT @ncredit = ISNULL(count_big(Amount), 0)
            FROM PaymentDet
            WHERE 
               LocationID = @LocationID AND 
               SDATE BETWEEN @DateF1 AND @DateF2 AND 
               PStatus = N'S' AND 
               TypeId = 12 AND UnitNo=@UnitNo
*/
            SELECT @crdnote = ISNULL(sum(ISNULL(Amount, 0)), 0),@ncrdnote = ISNULL(COUNT(ISNULL(PayTypeID, 0)), 0)
            FROM PaymentDet
            WHERE LocationID = @LocationID
			AND  UnitNo=@UnitNo AND PayTypeID=13
			AND BillTypeID=1  AND SaleTypeID=1 
			AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')
			
			SELECT @crdnotestle = ISNULL(sum(ISNULL(Amount, 0)), 0),@ncrdnotestle = ISNULL(COUNT(ISNULL(PayTypeID, 0)), 0)
            FROM PaymentDet
            WHERE LocationID = @LocationID
			AND  UnitNo=@UnitNo AND PayTypeID=14
			AND BillTypeID=1  AND SaleTypeID=1 
			AND (SaleStatus='C' OR Isnull(SaleStatus,'')='')

/*
            SELECT @other = ISNULL(sum(ISNULL(Amount, 0)), 0)
            FROM PaymentDet
            WHERE 
               LocationID = @LocationID AND 
               SDATE BETWEEN @DateF1 AND @DateF2 AND 
               PStatus = N'S' AND 
               TypeId >= 15 AND UnitNo=@UnitNo

            SELECT @nother = ISNULL(count_big(Amount), 0)
            FROM PaymentDet
            WHERE 
               LocationID = @LocationID AND 
               SDATE BETWEEN @DateF1 AND @DateF2 AND 
               PStatus = N'S' AND 
               TypeId >= 15 AND UnitNo=@UnitNo
*/
            

	  	END

 end







      DELETE FROM RSalesSummary WHERE CashierID=@CashierID AND UnitNo=@UnitNo AND LocationID=@LocationID
   
   SET @ReportNo=1


   IF(@ReportType=2)
   BEGIN
   		SELECT @ReportNo=isnull(Xno,1) FROM SysConfig WHERE LocationID=@LocationID AND UnitNo=@UnitNo
   END
   ELSE IF(@ReportType=3)
   BEGIN
		If @IsYReport=0
		BEGIN
   			SELECT @ReportNo=isnull(Zno,1) FROM SysConfig WHERE LocationID=@LocationID AND UnitNo=@UnitNo
		END
   END
   ELSE
   BEGIN
   		SET @ReportNo=1
   END
   	
		SELECT @ReceivedOnAccount+=ISNULL( SUM(RaccAmount),0)
						FROM TempMultiCurrencyDeclaration
   	
      INSERT RSalesSummary(
         LocationID, 
         UnitNo, 
         CashierID,
         vouchersalegross, 
         nvouchersale, 
         voudiscount, 
         nvoudiscount,
         vouRedeem,
         nvouRedeem, 
         loyaltyRedeem, 
         nloyaltyRedeem, 
         vouchernet, 
         vouchercash, 
         vouchercredit, 
         grosssale, 
         refunds,
		 Excrefunds, 
         nrefunds,
		 nExcrefunds,
         Idiscount, 
         nidiscount, 
         sdiscount, 
         nsdiscount, 
         voids, 
         nvoids, 
		 voidscancel,
		 nvoidscancel,
         error, 
         nerror, 
         cancel, 
         ncancel, 
         loyalty, 
         nloyalty, 
         nett, 
         credpay, 
         ncredpay, 
         paidout, 
         npaidout, 
		 paidIn, 
         npaidIn,
		 paidincash,
         cashsale, 
         staffcashsale, 
         nstaffcashsale, 
         cashrefund, 
         ncashrefund, 
         advancereceive, 
         nadvancereceive, 
         advancerefund, 
         nadvancerefund, 
         advancereceivecrd, 
         nadvancereceivecrd, 
         advancerefundcrd, 
         nadvancerefundcrd, 
         advancesettlement, 
         nadvancesettlement, 
         noofbills, 
         voucher, 
         nvoucher, 
         staffcred, 
         nstaffcred, 
         cheque, 
         ncheque, 
         starpoint, 
         starpointErn, 
         starpointErnVal, 
         nstarpoint, 
         mcredit, 
         nmcredit, 
         credit, 
         ncredit, 
         crdnote, 
         ncrdnote, 
         crdnotestle, 
         ncrdnotestle,
         CashInHand,
         DeclaredAmount,
         ReceivedOnAccount,
         ReportNo,
		 Vstaffcashsale,
		 VstaffCreditSale,
		 vArawanaRedeem,
		 nArawanaRedeem,
		 vSalaryAdvance,
		 nSalaryAdvance
		 ,GiftCardsalegross
		 ,nGiftCardsalegross
      ,GiftCardcash
      ,GiftCardstaffcashsale
      ,nGiftCardstaffcashsale
      ,GiftCardDiscount
      ,nGiftCardDiscount
      ,GiftCardRedeem
      ,nGiftCardRedeem
      ,GiftCardnet
      ,GiftCardcredit
      ,GiftCard
      ,nGiftCard
	  ,advancepayments 
		,advancerefunds 
		,advancebalances 
		,advancesetoffs 
		,nQtySales
		,noofsalebills
      )
         VALUES (
            @LocationID, 
            @unitno, 
            @CashierID,
            @vouchersalegross, 
            @nvouchersale, 
            @voudiscount, 
            @nvoudiscount,
            @vouRedeem,
            @nvouRedeem, 
            @loyaltyRedeem, 
            @nloyaltyRedeem, 
            @vouchernet, 
            @vouchercash, 
            @vouchercredit, 
            @grosssale, 
            @refunds,
			@Excrefunds,
            @nrefunds,
			@nExcrefunds,
            @Idiscount, 
            @nidiscount, 
            @sdiscount, 
            @nsdiscount, 
            @voids, 
            @nvoids, 
			@voidscancel,
			@nvoidscancel,
            @error, 
            @nerror, 
            @cancel, 
            @ncancel, 
            @loyalty, 
            @nloyalty, 
            @nett, 
            @credpay, 
            @ncredpay, 
            @paidout, 
            @npaidout,
			@paidIn, 
			@npaidIn,
			@paidincash, 
            @cashsale, 
            @staffcashsale, 
            @nstaffcashsale, 
            @cashrefund, 
            @ncashrefund, 
            @advancereceive, 
            @nadvancereceive, 
            @advancerefund, 
            @nadvancerefund, 
            @advancereceivecrd, 
            @nadvancereceivecrd, 
            @advancerefundcrd, 
            @nadvancerefundcrd, 
            @advancesettlement, 
            @nadvancesettlement, 
            @noofbills,           
            @voucher, 
            @nvoucher,           
            @staffcred, 
            @nstaffcred, 
            @cheque, 
            @ncheque, 
            @starpoint, 
            @starpointErn, 
            @starpointErnVal, 
            @nstarpoint, 
            @mcredit, 
            @nmcredit, 
            @credit, 
            @ncredit, 
            @crdnote, 
            @ncrdnote, 
            @crdnotestle, 
            @ncrdnotestle,
            @ReceivedOnAccount+@cashsale+@staffcashsale-@cashrefund-@paidout+@vouchercash+@VSTAFFCASHSALE-@vArawanaRedeem+@paidincash+@GiftCardcash+@GiftCardstaffcashsale,--cashinhand
            @DeclaredAmount,
            @ReceivedOnAccount,
            @ReportNo,
			@Vstaffcashsale,
			@VstaffCreditSale,
			@vArawanaRedeem,
			@nArawanaRedeem,
			@vSalaryAdvance,
			@nSalaryAdvance
			,@GiftCardsalegross
			,@nGiftCardsalegross
      ,@GiftCardcash
      ,@GiftCardstaffcashsale
      ,0
      ,@GiftCardDiscount
      ,@nGiftCardDiscount
      ,@GiftCardRedeem
      ,@nGiftCardRedeem
      ,@GiftCardnet
      ,@GiftCardcredit
      ,@GiftCard
      ,@nGiftCard
	  ,@advancepayments 
		,@advancerefunds 
		,@advancebalances 
		,@advancesetoffs
		,@nQtySales 
		,@noofsalebills
			)

 
 

   
   INSERT INTO MoneyDeclareDet(LocationID,UnitNo,CashierID,DeclaredAmount,ReportType)
   VALUES(@LocationID,@UnitNo,@CashierID,@DeclaredAmount,@ReportType)
   
   IF(@ReportType=2)
   BEGIN
   		UPDATE SysConfig
   		SET Xno = Xno+1 WHERE LocationID=@LocationID AND UnitNo=@UnitNo
   END
   ELSE IF(@ReportType=3)
   BEGIN
		If @IsYReport=0
		BEGIN
   			UPDATE SysConfig
   			SET Zno = Zno+1 WHERE LocationID=@LocationID AND UnitNo=@UnitNo
   		
   		
	  
	  UPDATE TransactionDet SET ZCashierId=@CashierID,ZCashier=@ZCashier 
	  WHERE LocationID=@LocationID AND UnitNo=@UnitNo
	   UPDATE PaymentDet SET ZCashierId=@CashierID,ZCashier=@ZCashier 
	  WHERE LocationID=@LocationID AND UnitNo=@UnitNo
   		
   		DECLARE @SQLString VARCHAR (MAX)
   		
   		SET @SQLString = N' 
							Insert Into  Openrowset(''Sqloledb'',''' + convert(varchar(50),@ServerIP) + ''';''' + convert(varchar(50),@DBUserName) + ''';''' + convert(varchar(50),@dbpwd) + ''',' + convert(varchar(50),@dbname) + '.DBO.TransactionDet) 
		   ([ProductID]
		  ,[ProductCode]
		  ,[RefCode]
		  ,[BarCodeFull]
		  ,[Descrip]
		  ,[BatchNo]
		  ,[SerialNo]
		  ,[ExpiryDate]
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
		  ,[ToLocationID]
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
		  ,[CustomerType]
		  ,[ZNo]
		  ,[TransStatus]
		  ,GroupOfCompanyID
		  ,DataTransfer
		  ,Zdate
		  ,IsPromotionApplied
		  ,PromotionID
		  ,IsPromotion
		  ,[NOS]
		  ,[SaleStatus]
		  ,[AdvaneReceiptNo]
		  ,[RecallAvdInvoice]
		  ,[CurrencyID]
		  ,[CurrencyRate]
		  ,[ProductColorSizeID]	
		  ,[Reference]
		  ,[ZCashierID]
		  ,[ZCashier]
		  ,[ExchangeReasonID]
		,[IsItemSeek]
		,[InvoiceNo]
		,[CopyReceiptCount]
							  
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
      ,[ToLocationID]
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
      ,[CustomerType]
      ,[ZNo]
      ,[TransStatus]
      ,' + convert(varchar(20),@GroupOfCompanyID) + '
      ,0
	  ,getdate()
	  ,IsPromotionApplied
	  ,PromotionID
	  ,IsPromotion,'+ convert(varchar(6),@Nos)  + '
	  ,[SaleStatus] 
	  ,[AdvaneReceiptNo]
	  ,[RecallAvdInvoice]
	  ,[CurrencyID]
	  ,[CurrencyRate]
	  ,[ProductColorSizeID]	
	  ,[Reference]
	  ,[ZCashierID]
	  ,[ZCashier]
	  ,[ExchangeReasonID]
		,[IsItemSeek]
		,[InvoiceNo]
		,[CopyReceiptCount]
	  FROM TransactionDet
where LocationID=' + convert(varchar(20),@LocationID) + ' and
	  UnitNo=' + convert(varchar(20),@UnitNo) + ' '  


							EXEC (@SQLString)
							
		
SET @SQLString = N' 
							Insert Into  Openrowset(''Sqloledb'',''' + convert(varchar(50),@ServerIP) + ''';''' + convert(varchar(50),@DBUserName) + ''';''' + convert(varchar(50),@dbpwd) + ''',' + convert(varchar(50),@dbname) + '.DBO.PaymentDet) 
							   ([RowNo]
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
	  ,[TerminalID]
      ,[ChequeDate]
      ,[IsRecallAdv]
      ,[RecallNo]
      ,[Descrip]
      ,[EnCodeName]
      ,[UpdatedBy]
      ,[Status]
      ,[CustomerID]
      ,[CustomerType]
      ,[CustomerCode]
	  ,[LoyaltyCardMasterID]
      ,[ZNo]
	  ,GroupOfCompanyID
	  ,DataTransfer,ZDate,LoyaltyType,NOS,[SaleStatus] 
	  ,[AdvaneReceiptNo]
	  ,[RecallAvdInvoice]
	  ,[CurrencyID]
	  ,[CurrencyRate]
	  ,[IsUploadToGl]
	  ,[LocationIDBilling]
	  ,[TableID]
	  ,[TicketID]
	  ,[OrderNo]
	  ,[ShiftNo]
	  ,[IsDayEnd]
	  ,[UpdateUnitNo]
		,[ZCashierID]
		,[ZCashier]
		,[InvoiceNo]
	  )
		SELECT 
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
	  ,[TerminalID]
      ,[ChequeDate]
      ,[IsRecallAdv]
      ,[RecallNo]
      ,[Descrip]
      ,[EnCodeName]
      ,[UpdatedBy]
      ,[Status]
      ,[CustomerID]
      ,[CustomerType]
      ,[CustomerCode]
	  ,[LoyaltyCardMasterID]
      ,[ZNo]
      ,' + convert(varchar(20),@GroupOfCompanyID) + '
      ,0
	  ,getdate(),LoyaltyType,'+ convert(varchar(6),@Nos)  + '
	  ,[SaleStatus] 
	  ,[AdvaneReceiptNo]
	  ,[RecallAvdInvoice]
	  ,[CurrencyID]
	  ,[CurrencyRate]
	  ,0
	  ,0,0,0,0,0,0,0
		,[ZCashierID]
		,[ZCashier]
		,[InvoiceNo]
	  FROM PaymentDet where LocationID=' + convert(varchar(20),@LocationID) + ' and
	  UnitNo=' + convert(varchar(20),@UnitNo) + ' '  

--PRINT @SQLString
							EXEC (@SQLString)
	
	if @IsHavelockSync=1
	begin
		SET @SQLString = N' 
			
			INSERT INTO  Openrowset(''Sqloledb'',''' + convert(varchar(50),@ServerIP) + ''';''' + convert(varchar(50),@DBUserName) + ''';''' + convert(varchar(50),@dbpwd) + ''',' + convert(varchar(50),@dbname) + '.[dbo].[HavelockSalesData])
           ([cashierId]
           ,[customerMobileNo]
           ,[invoiceType]
           ,[invoiceNo]
           ,[invoiceDate]
           ,[currencyCode]
           ,[currencyRate]
           ,[totalInvoice]
           ,[totalTax]
           ,[totalDiscount]
           ,[totalGiftVoucherSale]
           ,[totalGiftVoucherTax]
           ,[totalGiftVoucherDiscount]
           ,[paidByCash]
           ,[paidByCard]
           ,[cardBank]
           ,[cardCategory]
           ,[cardType]
           ,[GiftVoucherBurn]
           ,[hcmLoyalty]
           ,[tenantLoyalty]
           ,[creditNotes]
           ,[otherPayments]
           ,[DataTransfer]
           ,[TransferDate]
           ,[TenantId]
           ,[PosId]
           ,[StallNo])
    select [cashierId]
           ,[customerMobileNo]
           ,[invoiceType]
           ,[invoiceNo]
           ,[invoiceDate]
           ,[currencyCode]
           ,[currencyRate]
           ,[totalInvoice]
           ,[totalTax]
           ,[totalDiscount]
           ,[totalGiftVoucherSale]
           ,[totalGiftVoucherTax]
           ,[totalGiftVoucherDiscount]
           ,[paidByCash]
           ,[paidByCard]
           ,[cardBank]
           ,[cardCategory]
           ,[cardType]
           ,[GiftVoucherBurn]
           ,[hcmLoyalty]
           ,[tenantLoyalty]
           ,[creditNotes]
           ,[otherPayments]
           ,[DataTransfer]
           ,[TransferDate]
           ,[TenantId]
           ,[PosId]
           ,[StallNo]
		   from HavelockSalesData'  

	--PRINT @SQLString
							EXEC (@SQLString)
	end
							--- This is use to transfer data to terminals to server

--PRINTTransactionDetAVD @SQLString
/*
SET @SQLString = N' 
							Insert Into  Openrowset(''Sqloledb'',''' + convert(varchar(50),@ServerIP) + ''';''' + convert(varchar(50),@DBUserName) + ''';''' + convert(varchar(50),@dbpwd) + ''',' + convert(varchar(50),@dbname) + '.DBO.TransactionDetAVD) 
							   ([ProductID]
							  ,[ProductCode]
							  ,[RefCode]
							  ,[BarCodeFull]
							  ,[Descrip]
							  ,[BatchNo]
							  ,[SerialNo]
							  ,[ExpiryDate]
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
							  ,[CustomerType]
							  ,[ZNo]
							  ,[TransStatus]
							  ,[GroupOfCompanyID]
							  ,[DataTransfer]
							  ,[Zdate]
							  ,[IsPromotionApplied]
							  ,[PromotionID]
							  ,[IsPromotion]
							  ,[SaleStatus] 
							  ,[AdvaneReceiptNo]
							  ,[RecallAvdInvoice]
							  )
							SELECT 
							[ProductID]
      ,[ProductCode]
      ,[RefCode]
      ,[BarCodeFull]
      ,[Descrip]
      ,[BatchNo]
      ,[SerialNo]
      ,[ExpiryDate]
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
      ,[CustomerType]
      ,[ZNo]
      ,[TransStatus]
      ,' + convert(varchar(20),@GroupOfCompanyID) + '
      ,0
	  ,getdate()
	  ,[IsPromotionApplied]
	  ,[PromotionID]
	  ,[IsPromotion]
	  ,[SaleStatus] 
	  ,[AdvaneReceiptNo]
	  ,[RecallAvdInvoice]
	  FROM TransactionDetAVD
where LocationID=' + convert(varchar(20),@LocationID) + ' and
	  UnitNo=' + convert(varchar(20),@UnitNo) + ' '  


							EXEC (@SQLString)
							



SET @SQLString = N' 
							Insert Into  Openrowset(''Sqloledb'',''' + convert(varchar(50),@ServerIP) + ''';''' + convert(varchar(50),@DBUserName) + ''';''' + convert(varchar(50),@dbpwd) + ''',' + convert(varchar(50),@dbname) + '.DBO.PaymentDetAVD) 
							   ([RowNo]
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
	  ,[TerminalID]
      ,[ChequeDate]
      ,[IsRecallAdv]
      ,[RecallNo]
      ,[Descrip]
      ,[EnCodeName]
      ,[UpdatedBy]
      ,[Status]
      ,[CustomerID]
      ,[CustomerType]
      ,[CustomerCode]
      ,[ZNo]
	  ,[GroupOfCompanyID]
		,DataTransfer
		,ZDate
		,LoyaltyType
		,[SaleStatus]
		,[AdvaneReceiptNo]
		,[AdvanceBy]
		,[IsDeleteOnRecall]
		,[RecallAvdInvoice])
							SELECT 
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
	  ,[TerminalID]
      ,[ChequeDate]
      ,[IsRecallAdv]
      ,[RecallNo]
      ,[Descrip]
      ,[EnCodeName]
      ,[UpdatedBy]
      ,[Status]
      ,[CustomerID]
      ,[CustomerType]
      ,[CustomerCode]
      ,[ZNo]
      ,' + convert(varchar(20),@GroupOfCompanyID) + '
      ,0
	  ,getdate(),LoyaltyType
	  ,[SaleStatus]
	  ,[AdvaneReceiptNo]
	  ,[AdvanceBy]
	  ,[IsDeleteOnRecall]
	  ,[RecallAvdInvoice]
	  FROM PaymentDetAVD where LocationID=' + convert(varchar(20),@LocationID) + ' and
	  UnitNo=' + convert(varchar(20),@UnitNo) + ' '  

--PRINT @SQLString
							EXEC (@SQLString)


SET @SQLString = N' 
					Insert Into  Openrowset(''Sqloledb'',''' + convert(varchar(50),@ServerIP) + ''';''' + convert(varchar(50),@DBUserName) + ''';''' + convert(varchar(50),@dbpwd) + ''',' + convert(varchar(50),@dbname) + '.DBO.AdvanceHed) 
							   ([AdvanceNo],[Receipt],[LocationID],[UnitNo],[STime],[SDate],[Amount],[CashierID],[IsRecall],
							[RecallReceipt],[RecallCashierID],[RecallCashier],[RecallUnitNo],[RecallTime],[TransStatus],[NetAmount],[IsDelete])
      							SELECT
						[AdvanceNo],[Receipt],[LocationID],[UnitNo],[STime],[SDate],[Amount],[CashierID],[IsRecall],
							[RecallReceipt],[RecallCashierID],[RecallCashier],[RecallUnitNo],[RecallTime],[TransStatus],[NetAmount],[IsDelete]
	  FROM AdvanceHed where LocationID=' + convert(varchar(20),@LocationID) + ' and
	  UnitNo=' + convert(varchar(20),@UnitNo) + ' '  

--PRINT @SQLString
							EXEC (@SQLString)
					*/		
		END			
END
   		

   
   SELECT TOP 1 * FROM RSalesSummary  WHERE CashierID=@CashierID AND UnitNo=@UnitNo AND LocationID=@LocationID
   

   

     --COMMIT TRANSACTION;

	END TRY
  
    BEGIN CATCH
      IF @@TRANCOUNT > 0
	  begin
         --ROLLBACK TRANSACTION
		 SELECT ERROR_MESSAGE()  AS Result

	  end
	  else
      begin
		 SELECT ERROR_MESSAGE()  AS Result
	  end
    END CATCH

------------
