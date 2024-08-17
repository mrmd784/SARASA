USE [EasywayC]
GO

/****** Object:  Trigger [dbo].[trgLoyaltySave]    Script Date: 01/24/2024 13:28:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[trgLoyaltySave]   
ON [dbo].[tb_CustomerLoyalty] 
AFTER INSERT  
AS 	
	Declare @message As Varchar(255)
	Declare @Points As Varchar(20)
	Declare @ReceiptNo As Varchar(20)
	Declare @Amount As Varchar(20)
	Declare @Customer As Varchar(20)
	Declare @Phone As Varchar(20)

	If Exists(Select * from inserted)
	Begin
		Select @Customer=CustCode From Inserted
		
		Select @Phone=Mobile from tb_CustomerLoyalty Where CustCode=@Customer
		If len(Rtrim(@Phone))=10
		Begin
			Set @message=	'Congratulations & Welcome to ES Loyalty Rewards!' 
			Insert Into LoyaltyMessage (PhoneNo,MessageText,SendStatus,BatchCode,Mask) Values (@Phone,@message,0,'','')
		End
	End

GO

