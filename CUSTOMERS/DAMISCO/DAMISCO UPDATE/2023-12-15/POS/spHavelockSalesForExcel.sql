USE [SPOSDATA]
GO
/****** Object:  StoredProcedure [dbo].[spHavelockSalesForExcel]    Script Date: 2023-12-21 02:25:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER proc [dbo].[spHavelockSalesForExcel]

 @TenantId varchar(15)
,@PosId varchar(25)
,@StallNo varchar(4)
,@FromDate date
,@IsMonth int
AS
begin
	

	update HavelockSalesDataBackup set TenantId=@TenantId,PosId=@PosId,StallNo=@StallNo,DataTransfer=1
	where DataTransfer<1
	
	update HavelockSalesData set TenantId=@TenantId,PosId=@PosId,StallNo=@StallNo
end
			--select TenantId [Tenant ID],PosId [POS ID],StallNo [Stall No],[cashierId][Cashier ID],[customerMobileNo][Customer Mobile No],[invoiceType][Invoice Type]
			--,[invoiceNo][Invoice No],day([invoiceDate])DD,month([invoiceDate])MM,year([invoiceDate])YYYY,datepart(hour,[invoiceDate])HH,datepart(minute,[invoiceDate])mm,datepart(second,[invoiceDate])SS
			--,[currencyCode][Currency Code],[currencyRate][Currency Rate],[totalInvoice][Total Invoice]
   --         ,[totalTax][Total Tax],[totalDiscount][Total Discount],[totalGiftVoucherSale][Total Gift Voucher Sale]
			--,[totalGiftVoucherDiscount][Total Gift Voucher Discount],[paidByCash][Paid By Cash]
   --         ,[paidByCard][Paid By Card],[cardBank][Card Bank],[cardCategory][Card Category],[cardType][Card Type]
			--,[GiftVoucherBurn][Gift Voucher Burn],[hcmLoyalty][HCM Loyalty],[tenantLoyalty][Tenant Loyalty]
   --         ,[creditNotes][Credit Note],[otherPayments][Other Payments]
			--from HavelockSalesData where (CAST(invoiceDate as date) = @FromDate or @IsMonth=1) and ((YEAR(invoiceDate)=YEAR(@FromDate) and MONTH(invoiceDate)=MONTH(@FromDate)) or @IsMonth=0)  order by idx


			--select @TenantId [Tenant ID],@PosId [POS ID],@StallNo [Stall No],[cashierId][Cashier ID],[customerMobileNo][Customer Mobile No],[invoiceType][Invoice Type]
			--,[invoiceNo][Invoice No],day([invoiceDate])DD,month([invoiceDate])MM,year([invoiceDate])YYYY,datepart(hour,[invoiceDate])HH,datepart(minute,[invoiceDate])mm,datepart(second,[invoiceDate])SS
			--,[currencyCode][Currency Code],[currencyRate][Currency Rate],[totalInvoice][Total Invoice]
   --         ,[totalTax][Total Tax],[totalDiscount][Total Discount],[totalGiftVoucherSale][Total Gift Voucher Sale]
			--,[totalGiftVoucherDiscount][Total Gift Voucher Discount],[paidByCash][Paid By Cash]
   --         ,[paidByCard][Paid By Card],[cardBank][Card Bank],[cardCategory][Card Category],[cardType][Card Type]
			--,[GiftVoucherBurn][Gift Voucher Burn],[hcmLoyalty][HCM Loyalty],[tenantLoyalty][Tenant Loyalty]
   --         ,[creditNotes][Credit Note],[otherPayments][Other Payments]
			--from HavelockSalesDataBackup where (CAST(invoiceDate as date) = @FromDate or @IsMonth=1) and ((YEAR(invoiceDate)=YEAR(@FromDate) and MONTH(invoiceDate)=MONTH(@FromDate)) or @IsMonth=0)  order by idx
