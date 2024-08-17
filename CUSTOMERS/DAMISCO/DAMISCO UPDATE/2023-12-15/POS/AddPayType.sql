declare @PaytypeHCM varchar(50)='HCM VOUCHER'
if not exists (select * from Paytype where Descrip=@PaytypeHCM)
begin
	INSERT INTO [dbo].[Paytype]
           ([PaymentID]
           ,[Descrip]
           ,[IsSwipe]
           ,[Type]
           ,[Rate]
           ,[IsRefundable]
           ,[IsActive]
           ,[IsBillCopy]
           ,[PrintDescrip]
           ,[PreFix]
           ,[MaxLength])
		   values
		   ((select MAX(PaymentID)+1 from Paytype)
		   ,@PaytypeHCM
		   ,0
		   ,6
		   ,0
		   ,0
		   ,1
		   ,0
		   ,@PaytypeHCM
		   ,''
		   ,0)
	PRINT 'INSERTED'
end
ELSE
	PRINT 'EXISTS'
go