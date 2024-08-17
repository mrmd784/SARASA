USE [ERP]
GO

/****** Object:  Trigger [dbo].[trgLoyaltySave]    Script Date: 2024-06-12 10:24:05 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE TRIGGER [dbo].[trgLoyaltySave]   
ON [dbo].[LoyaltyCustomer] 
AFTER INSERT  
AS 	
	Declare @message As Varchar(255)
	Declare @Points As Varchar(20)
	Declare @ReceiptNo As Varchar(20)
	Declare @Amount As Varchar(20)
	Declare @Customer As Varchar(20)
	Declare @Phone As Varchar(20)
	Declare @Name As Varchar(30)

	If Exists(Select * from inserted)
	Begin
		Select @Customer=CustomerCode From Inserted
		
		Select @Phone=Mobile from LoyaltyCustomer Where CustomerCode=@Customer
		Select @Name=CustomerName from LoyaltyCustomer Where CustomerCode=@Customer
		
		If (len(Rtrim(@Phone))=10 and LEFT(@Phone,2)='07')or(len(Rtrim(@Phone))=9 and LEFT(@Phone,1)='7')
		Begin
			Set @message='Dear ' + @Name + ', Welcome to our Loyalty Program! Enjoy Exclusive perks and Rewards just for you. Stay tuned for more benefits! - TKS FASHION' 
			Insert Into LoyaltyMessage (PhoneNo,MessageText,SendStatus,BatchCode,Mask) Values (@Phone,@message,0,'','')
		End
	End


GO

