USE [ERP]
GO

/****** Object:  Trigger [dbo].[UpdateLoyaltyPoints]    Script Date: 2024-08-17 10:54:54 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Pravin
-- Create date: 2017-01-03
-- Description:	Update Loyalty Points
-- =============================================
ALTER TRIGGER [dbo].[UpdateLoyaltyPoints] 
   ON  [dbo].[InvLoyaltyTransaction]
   AFTER INSERT
AS 
	Declare @message As Varchar(255)
	Declare @Points As Varchar(20)
	Declare @ReceiptNo As Varchar(20)
	Declare @Amount As Varchar(20)
	Declare @Customer As Varchar(20)
	Declare @Phone As Varchar(20)
	Declare @Balance As Varchar(20)
	
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON
	/*
	declare @TransID int=1,
	@Points decimal(18,4)=0,
	@CustomerID bigint=1

	select @TransID=isnull(inserted.TransID,0),@Points=isnull(inserted.Points,0),@CustomerID=isnull(inserted.CustomerID,0) from inserted
	
	if @TransID=1
	begin

		update LoyaltyCustomer 
		set CPoints=CPoints+@Points,
		EPoints=EPoints+@Points
		where LoyaltyCustomerID=@CustomerID

	end
	else if @TransID=2
	begin

		update LoyaltyCustomer 
		set CPoints=CPoints-@Points,
		RPoints=RPoints+@Points
		where LoyaltyCustomerID=@CustomerID

	end
	*/

	--select getdate() a into #t

	IF OBJECT_ID('tempdb..#t') IS NOT NULL
		DROP TABLE #t

	select sum(case transid when 1 then points else - points end) points,customerid into #t 
    from inserted group by customerid

	update l set l.CPoints=CPoints+i.points,
	EPoints=EPoints+case when i.points>0 then i.points else 0 end,
	RPoints=RPoints+case when i.points<0 then i.points else 0 end,
	ExpiryPoints=ExpiryPoints+case when i.points<0 then i.points else 0 end
	from LoyaltyCustomer l inner join
	#t i
	on l.LoyaltyCustomerID=i.CustomerID


	If Exists(Select * from inserted Where TransID=1)
	Begin
		Select @Customer=CustomerId,@Points=Convert(Decimal(18,2),Points),@Amount=Convert(Decimal(18,2),Amount),@ReceiptNo=Receipt From Inserted Where TransID=1
		select @Balance=Convert(Decimal(18,2),CPoints) from LoyaltyCustomer where LoyaltyCustomerID=@Customer
		Select @Phone=Mobile from LoyaltyCustomer Where LoyaltyCustomerID=@Customer
		If len(Rtrim(@Phone))=10
		Begin
			Set @message=	'Dear Customer, You Have Earned ' + @Points + ' Point(s).Your Loyalty Points Balance - '+@Balance+'. Thank You For Your Patronage.' 
			Insert Into LoyaltyMessage (PhoneNo,MessageText,SendStatus,BatchCode,Mask) Values (@Phone,@message,0,'','')
		End
	End
	
	If Exists(Select * from inserted Where TransID=2)
	Begin
		Select @Customer=CustomerId,@Points=Convert(Decimal(18,2),Points),@Amount=Convert(Decimal(18,2),Amount),@ReceiptNo=Receipt From Inserted Where TransID=2
		select @Balance=Convert(Decimal(18,2),CPoints) from LoyaltyCustomer where LoyaltyCustomerID=@Customer
		Select @Phone=Mobile from LoyaltyCustomer Where LoyaltyCustomerID=@Customer
		If len(Rtrim(@Phone))=10
		Begin
			Set @message=	'Dear Customer, You Have Redeemed ' + @Points + ' Point(s).Your Loyalty Points Balance - '+@Balance+'.' 
			Insert Into LoyaltyMessage (PhoneNo,MessageText,SendStatus,BatchCode,Mask) Values (@Phone,@message,0,'','')
		End
	End

    -- Insert statements for trigger here
	--IF OBJECT_ID('tempdb..#tSmsLoyalty') IS NOT NULL
	--	DROP TABLE #tSmsLoyalty

	--select i.customerid,lc.Mobile,i.points,i.amount as amount
	--,lc.CPoints as CurrentPoints ,Cast(i.DocumentDate as date) as InvoiceDate,
	--CONVERT(varchar(15),CAST(i.DocumentTime AS TIME),100)  as InvoiceTime,i.TransID
	--into #tSmsLoyalty 
 --   from inserted i
	--inner join LoyaltyCustomer lc
	--on i.CustomerID=lc.LoyaltyCustomerID

	/*
	INSERT INTO SMSDB.[dbo].[LoyaltyMessage]
           ([PhoneNo]
           ,[MessageText]
           ,[SendStatus]
           ,[UpdatedDate]
		   ,[SMSType])

          SELECT  
        '94'+ SUBSTRING(t.Mobile,2,LEN(t.Mobile)) AS [PhoneNo],
		
        'Dear customer, you have '+ CASE WHEN t.TransID =1 THEN 'earned ' ELSE  'redeem ' END + CAST(t.points AS VARCHAR(100))+ ' points for your transaction of Rs.'+CAST(t.amount AS VARCHAR(100))+
		+' on '+CAST(t.InvoiceDate AS VARCHAR(100)) +' '+ CAST(t.InvoiceTime AS VARCHAR(100))
		+'. Total points balance '+CAST(t.CurrentPoints AS VARCHAR(100))+'.' as [MessageText],
         0 AS [SendStatus],
         GETDATE() [UpdatedDate],
		 1 as [SMSType]
         FROM #tSmsLoyalty t
         WHERE  
	     t.Mobile is not null AND t.Mobile<>'' and Len(t.Mobile)=10 AND 
		 SUBSTRING(t.Mobile,0,3)='07'

*/
END
GO

