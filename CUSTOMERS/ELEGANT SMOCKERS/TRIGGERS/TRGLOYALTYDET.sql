USE [EasywayC]
GO

/****** Object:  Trigger [dbo].[trgLoyalty]    Script Date: 01/24/2024 13:29:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[trgLoyalty]   
ON [dbo].[tb_LoyaltyDet] 
AFTER INSERT  
AS 	
	Declare @message As Varchar(255)
	Declare @Points As Varchar(20)
	Declare @ReceiptNo As Varchar(20)
	Declare @Amount As Varchar(20)
	Declare @Customer As Varchar(20)
	Declare @Phone As Varchar(20)
	Declare @Balance As Varchar(20)

	If Exists(Select * from inserted Where Iid=1)
	Begin
		Select @Customer=CustCode,@Points=Convert(Decimal(18,2),Points),@Amount=Convert(Decimal(18,2),Amount),@ReceiptNo=Receipt From Inserted Where Iid=1
		select @Balance=Convert(Decimal(18,2),Points) from vw_LoyaltyBal where CustCode=@Customer
		Select @Phone=Mobile from tb_CustomerLoyalty Where CustCode=@Customer
		If len(Rtrim(@Phone))=10
		Begin
			Set @message=	'Dear Customer, You Have Earned ' + @Points + ' Point(s).Your Loyalty Points Balance - '+@Balance+'. Thank You For Your Patronage.' 
			Insert Into LoyaltyMessage (PhoneNo,MessageText,SendStatus,BatchCode,Mask) Values (@Phone,@message,0,'','')
		End
	End
	
	If Exists(Select * from inserted Where Iid=2)
	Begin
		Select @Customer=CustCode,@Points=Convert(Decimal(18,2),Points),@Amount=Convert(Decimal(18,2),Amount),@ReceiptNo=Receipt From Inserted Where Iid=2
		select @Balance=Convert(Decimal(18,2),Points) from vw_LoyaltyBal where CustCode=@Customer
		Select @Phone=Mobile from tb_CustomerLoyalty Where CustCode=@Customer
		If len(Rtrim(@Phone))=10
		Begin
			Set @message=	'Dear Customer, You Have Redeemed ' + @Points + ' Point(s).Your Loyalty Points Balance - '+@Balance+'.' 
			Insert Into LoyaltyMessage (PhoneNo,MessageText,SendStatus,BatchCode,Mask) Values (@Phone,@message,0,'','')
		End
	End


GO

