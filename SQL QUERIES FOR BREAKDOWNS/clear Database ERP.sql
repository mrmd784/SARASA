 
truncate table InvPurchase
truncate table InvPurchaseHeader
truncate table InvPurchaseDetail

truncate table InvStockAdjustmentHeader
truncate table InvStockAdjustmentDetail

delete  from InvPurchaseOrderHeader
DBCC CHECKIDENT ('dbo.InvPurchaseOrderHeader', reseed, 0)

truncate table InvPurchaseOrderDetail


truncate table InvTransferNoteHeader
truncate table InvTransferNoteDetail

truncate table InvStockAdjustmentDetail
truncate table InvStockAdjustmentHeader

truncate table InvSalesHeader
truncate table InvSalesDetail

 
truncate table AccAccountReconciliationDetail

delete  from AccAccountReconciliationHeader
DBCC CHECKIDENT ('dbo.AccAccountReconciliationHeader', reseed, 0)

truncate table AccAccountReportTemplate
truncate table AccBankDepositDetail

delete  from AccBankDepositHeader
DBCC CHECKIDENT ('dbo.AccBankDepositHeader', reseed, 0)
truncate table AccBankDirectTransferDetail

delete  from AccBankDirectTransferHeader
DBCC CHECKIDENT ('dbo.AccBankDirectTransferHeader', reseed, 0)

truncate table AccBillEntryDetail
 
delete  from AccBillEntryHeader
DBCC CHECKIDENT ('dbo.AccBillEntryHeader', reseed, 0)
truncate table AccBudgetDetail
truncate table AccCardCommission
truncate table AccChequeCancelDetail

delete  from AccChequeCancelHeader
DBCC CHECKIDENT ('dbo.AccChequeCancelHeader', reseed, 0)
truncate table AccChequeDetail
truncate table AccChequeNoEntry
truncate table AccChequeReturnDetail
 
delete  from AccChequeReturnHeader
DBCC CHECKIDENT ('dbo.AccChequeReturnHeader', reseed, 0)

truncate table AccCreditNoteDetail
 
delete  from AccCreditNoteHeader
DBCC CHECKIDENT ('dbo.AccCreditNoteHeader', reseed, 0)

truncate table AccDebitNoteDetail 

delete  from AccDebitNoteHeader
DBCC CHECKIDENT ('dbo.AccDebitNoteHeader', reseed, 0)

truncate table AccGlTransactionDetail

delete  from AccGlTransactionHeader
DBCC CHECKIDENT ('dbo.AccGlTransactionHeader', reseed, 0)
truncate table AccJournalEntryDetail

delete  from AccJournalEntryHeader
DBCC CHECKIDENT ('dbo.AccJournalEntryHeader', reseed, 0)

truncate table AccLoanEntryDetail
truncate table AccLoanEntryHeader
truncate table AccOpenningBalanceDetail

delete  from AccOpenningBalanceHeader
DBCC CHECKIDENT ('dbo.AccOpenningBalanceHeader', reseed, 0)


truncate table AccPaymentCancelDetail

truncate table  AccPaymentCancelHeader
truncate table AccPaymentDetail
truncate table AccPaymentHeader
truncate table AccPettyCashBillCancelDetail

delete  from AccPettyCashBillCancelHeader
DBCC CHECKIDENT ('dbo.AccPettyCashBillCancelHeader', reseed, 0)

truncate table AccPettyCashBillDetail

delete  from AccPettyCashBillHeader
DBCC CHECKIDENT ('dbo.AccPettyCashBillHeader', reseed, 0)
truncate table AccPettyCashImprestDetail
truncate table AccPettyCashIOUDetail

delete  from AccPettyCashIOUHeader
DBCC CHECKIDENT ('dbo.AccPettyCashIOUHeader', reseed, 0)
truncate table AccPettyCashPaymentDetail

delete  from AccPettyCashPaymentHeader
DBCC CHECKIDENT ('dbo.AccPettyCashPaymentHeader', reseed, 0)
truncate table AccPettyCashPaymentProcessDetail
truncate table AccPettyCashReimbursement
truncate table AccPettyCashVoucherDetail

delete  from AccPettyCashVoucherHeader
DBCC CHECKIDENT ('dbo.AccPettyCashVoucherHeader', reseed, 0)
truncate table AccSalesDownload

delete  from OpeningStockHeader
DBCC CHECKIDENT ('dbo.InvPurchaseOrderHeader', reseed, 0)

truncate table OpeningStockHeader
truncate table OpeningStockDetail

 

truncate table InvTransferNoteGatePassHeader
truncate table InvTransferNoteGatePassDetail

truncate table InvTransferNoteAcceptanceDetail
truncate table InvTransferNoteAcceptanceHeader

 

truncate table Transactiondet
truncate table PaymentDet

truncate table InvSales
 

truncate table InvSampleInDetail
truncate table InvSampleInHeader

truncate table InvSampleOutDetail
truncate table InvSampleOutHeader

truncate table  InvProductPriceChangeHeader
truncate table  InvProductPriceChangeDetail

truncate table InvQualityControlOutNoteDetail
truncate table InvQualityControlOutNoteHeader
truncate table InvQualityControlReceivedNoteDetail
truncate table InvQualityControlReceivedNoteHeader
truncate table InvQualityControlRejectNoteDetail
truncate table InvQualityControlRejectNoteHeader

truncate table SalesOrderHeader
truncate table SalesOrderDetail
 

Update DocumentNumber
Set DocumentNo=0,TempDocumentNo=0

select * from DocumentNumber
where DocumentNo<>0


 

--exec [spCalculateCurrentStock]