Insert Into  ERP.DBO.TransactionDet 
([ProductID],[ProductCode],[RefCode],[BarCodeFull],[Descrip],[BatchNo],[SerialNo],[ExpiryDate],[Cost],[AvgCost],[Price]
,[Qty],[Amount],[UnitOfMeasureID],[UnitOfMeasureName],[ConvertFactor],[IDI1],[IDis1],[IDiscount1],[IDI1CashierID]
,[IDI2],[IDis2],[IDiscount2],[IDI2CashierID],[IDI3],[IDis3],[IDiscount3],[IDI3CashierID],[IDI4],[IDis4],[IDiscount4]
,[IDI4CashierID],[IDI5],[IDis5],[IDiscount5],[IDI5CashierID],[Rate],[IsSDis],[SDNo],[SDID],[SDIs],[SDiscount],[DDisCashierID]
,[Nett],[LocationID],[DocumentID],[BillTypeID],[SaleTypeID],[Receipt],[SalesmanID],[Salesman],[CustomerID],[Customer]
,[CashierID],[Cashier],[StartTime],[EndTime],[RecDate],[BaseUnitID],[UnitNo],[RowNo],[IsRecall],[RecallNo],[RecallAdv],[TaxAmount]
,[IsTax],[TaxPercentage],[IsStock],[UpdateBy],[Status],[CustomerType],[ZNo],[TransStatus],GroupOfCompanyID,DataTransfer,Zdate
,IsPromotionApplied,PromotionID,IsPromotion,[NOS],[SaleStatus],[AdvaneReceiptNo],[RecallAvdInvoice],[CurrencyID],[CurrencyRate]
,[ProductColorSizeID]	
)
SELECT 
[ProductID],[ProductCode],[RefCode],[BarCodeFull],[Descrip],[BatchNo],[SerialNo],[ExpiaryDate],[Cost],[AvgCost],[Price]
,[Qty],[Amount],[UnitOfMeasureID],[UnitOfMeasureName],[ConvertFactor],[IDI1],[IDis1],[IDiscount1],[IDI1CashierID]
,[IDI2],[IDis2],[IDiscount2],[IDI2CashierID],[IDI3],[IDis3],[IDiscount3],[IDI3CashierID],[IDI4],[IDis4],[IDiscount4]
,[IDI4CashierID],[IDI5],[IDis5],[IDiscount5],[IDI5CashierID],[Rate],[IsSDis],[SDNo],[SDID],[SDIs],[SDiscount],[DDisCashierID]
,[Nett],[LocationID],[DocumentID],[BillTypeID],[SaleTypeID],[Receipt],[SalesmanID],[Salesman],[CustomerID],[Customer]
,[CashierID],[Cashier],[StartTime],[EndTime],[RecDate],[BaseUnitID],[UnitNo],[RowNo],[IsRecall],[RecallNo],[RecallAdv],[TaxAmount]
,[IsTax],[TaxPercentage],[IsStock],[UpdateBy],[Status],[CustomerType],[ZNo],[TransStatus],0,0,'2023-09-12'
,IsPromotionApplied,PromotionID,IsPromotion,'100.00',[SaleStatus] ,[AdvaneReceiptNo],[RecallAvdInvoice],[CurrencyID],[CurrencyRate]
,[ProductColorSizeID]	
FROM TransactionDet
where LocationID='8' and
UnitNo='3'  



Insert Into ERP.DBO.PaymentDet
([RowNo],[PayTypeID],[Amount],[Balance],[SDate],[Receipt],[LocationID],[CashierID],[UnitNo],[BillTypeID],[SaleTypeID],[RefNo]
,[BankId],[TerminalID],[ChequeDate],[IsRecallAdv],[RecallNo],[Descrip],[EnCodeName],[UpdatedBy],[Status],[CustomerID],[CustomerType]
,[CustomerCode],[LoyaltyCardMasterID],[ZNo],GroupOfCompanyID,DataTransfer,ZDate,LoyaltyType,NOS,[SaleStatus] ,[AdvaneReceiptNo]
,[RecallAvdInvoice],[CurrencyID],[CurrencyRate],[IsUploadToGl],[LocationIDBilling],[TableID],[TicketID],[OrderNo],[ShiftNo]
,[IsDayEnd],[UpdateUnitNo]
	  )
SELECT 
[RowNo],[PayTypeID],[Amount],[Balance],[SDate],[Receipt],[LocationID],[CashierID],[UnitNo],[BillTypeID],[SaleTypeID],[RefNo]
,[BankId],[TerminalID],[ChequeDate],[IsRecallAdv],[RecallNo],[Descrip],[EnCodeName],[UpdatedBy],[Status],[CustomerID],[CustomerType]
,[CustomerCode],[LoyaltyCardMasterID],[ZNo],0,0,'2023-09-12',LoyaltyType,'100.00',[SaleStatus] ,[AdvaneReceiptNo]
,[RecallAvdInvoice],[CurrencyID],[CurrencyRate],0,0,0,0,0,0
,0,0
FROM PaymentDet where LocationID='8' and
UnitNo='3' 