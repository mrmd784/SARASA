USE [ERP]
GO
/****** Object:  StoredProcedure [dbo].[spRegisterCustomer]    Script Date: 14/06/2023 2:03:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[spRegisterCustomer]

       @Name varchar(50),
       @Mobile varchar(10),
	   @CashierID bigint,
	   @LocationID int,
	   @Title int=1,
	   @TerritoryID int=0,
	   @Email Varchar(50)='',
	   @NIC Varchar(12)='',
	   @Occupaption Varchar(50)='',
	   @Address Varchar(200)='',
	   @CustomerType int=3,
	   @SHNewYear int=0,
	   @ThaiPongal int=0,
	   @Vesak int=0,
	   @Hajj int=0,
	   @Ramazan int=0,
	   @Xmas int=0,
	   @CardNo VARCHAR(16)='',
	   @UnitNo int=0,
	   @ReceiptNo nvarchar(50)='',
	   @Zno bigint = 0,
	   @BD date='1900-01-01'
as
--By Ayasha
----11/09/2019

	 Declare @GroupOfCompanyID INT		
			,@CardMasterID INT
			,@CustomerCode VARCHAR(8)
			,@Gender int
			,@BD_Year int
			,@BD_Month int
			,@BD_Date int
			,@BD_OFFSET int
			,@UserName nvarchar(50)=''
	 
SET NOCOUNT ON

BEGIN TRY
       BEGIN TRANSACTION

IF NOT EXISTS (SELECT CardNo FROM LoyaltyCustomer WHERE Mobile=@Mobile)
BEGIN

	if exists (select top 1 JournalName from CashierPermission where CashierID=@CashierID)
		select top 1 @UserName=JournalName from CashierPermission where CashierID=@CashierID
	
	
	if(@BD='1900-01-01' and (LEN(@NIC)=12 or LEN(@NIC)=10))
	begin
		
		IF LEN(@NIC)=12
		BEGIN
			set @BD_Year=CAST(SUBSTRING(@nic,1,4) as int)
			set @BD_OFFSET=CAST(SUBSTRING(@nic,5,3) as int)
		END
		ELSE
		BEGIN
			set @BD_Year=CAST('19'+SUBSTRING(@nic,1,2) as int)
			set @BD_OFFSET=CAST(SUBSTRING(@nic,3,3) as int)
		END
		SELECT @Gender=LookupKey FROM ReferenceType WHERE LookupType=1 and LookupValue=CASE WHEN @BD_OFFSET<500 THEN 'Male' ELSE 'Female' END
			 
		if @BD_OFFSET>500
			set @BD_OFFSET=@BD_OFFSET-500

		if ISDATE(CAST(@BD_Year AS char(4)) + '0229') = 0 and @BD_OFFSET>60
 			set @BD_OFFSET=@BD_OFFSET-1

		set @BD= DATEADD(d, @BD_OFFSET-1, CAST(@BD_Year as varchar(4))+'/01/01')
	end

	SELECT @Gender=LookupKey FROM ReferenceType WHERE LookupType=1 and LookupValue=CASE WHEN @Title=1 THEN 'Male' ELSE 'Female' END
	SELECT top 1 @GroupOfCompanyID=GroupOfCompanyID FROM GroupOfCompany where IsActive=1
	SELECT top 1 @CardMasterID=CardMasterid from CardMaster where (RTRIM(CardName)=case @CustomerType when 5 then 'GENERAL CUSTOMER' else 'SILVER CARD' end)

	if @CustomerType=5
	begin
		--declare @CustomerCode VARCHAR(8)
		SELECT top 1 @CustomerCode=CustomerCode from LoyaltyCustomer  where CustomerCode like 'G%' order by CustomerCode desc
	
		if(@CustomerCode is null)
		begin
			set @CustomerCode='G0000000'
		end

		while exists(select * from LoyaltyCustomer where CustomerCode=@CustomerCode)
		begin
			set @CustomerCode= 'G'+(right(('000000'+CAST((CAST(RIGHT(@CustomerCode,7) as int)+1) as varchar(8))),7))
			--select @CustomerCode
		end
	end
	else
	begin
		SELECT top 1 @CustomerCode=CustomerCode from LoyaltyCustomer  where CustomerCode like 'L%' order by CustomerCode desc
	
		if(@CustomerCode is null)
		begin
			set @CustomerCode='L0000000'
		end

		while exists(select * from LoyaltyCustomer where CustomerCode=@CustomerCode)
		begin
			set @CustomerCode= 'L'+(right(('000000'+CAST((CAST(RIGHT(@CustomerCode,7) as int)+1) as varchar(8))),7))
			--select @CustomerCode
		end
	end


	INSERT INTO LoyaltyCustomer
	(
		   [CardNo]
		  ,[CustomerCode]
		  ,[CustomerTitle]
		  ,[CustomerName]
		  ,[NameOnCard]
		  ,[Gender]
		  ,[Nationality]
		  ,[CustomerId]
		  ,[NicNo]
		  ,[DateOfBirth]
		  ,[Age]
		  ,[Religion]
		  ,[District]
		  ,[CardMasterID]
		  ,[CardIssued]
		  ,[IssuedOn]
		  ,[ExpiryDate]
		  ,[RenewedOn]      
		  ,[CivilStatus]
		  ,[FemaleAdults]
		  ,[MaleAdults]
		  ,[Childrens]
		  ,[SpouseDateOfBirth]
		  ,[Anniversary]
		  ,[SinhalaHinduNewYear]
		  ,[ThaiPongal]
		  ,[Wesak]
		  ,[HajFestival]
		  ,[Ramazan]
		  ,[Xmas]
		  ,[Deepavali]
		  ,[FavoriteTvChannel]
		  ,[FavoriteNewsPapers]
		  ,[FavoriteRadioChannels]
		  ,[FavoriteMagazines]
		  ,[LedgerId]
		  ,[LedgerId2]
		  ,[CreditLimit]
		  ,[CreditPeriod]
		  ,[DeliverTo]
		  ,[DeliverToAddress]
		  ,[CustomerSince]
		  ,[SendUpdatesViaEmail]
		  ,[SendUpdatesViaSms]
		  ,[IsSuspended]
		  ,[IsBlackListed]
		  ,[IsCreditAllowed]
		  ,[IsDelete]
		  ,[Active]
		  ,[GroupOfCompanyID]
		  ,[CreatedDate]
		  ,[ModifiedDate]
		  ,[DataTransfer]
		  ,[CPoints]
		  ,[EPoints]
		  ,[RPoints]
		  ,[IsReDimm]
		  ,[AcitiveDate]
		  ,[IsRegByPOS]
		  ,[CashierID]
		  ,LocationID
		  ,LoyaltyType
		  ,IsAbeyance	
		  ,Mobile	
		  ,TerritoryID
		  ,Email
		  ,Occupation
		  ,Address1
		  ,LoyaltyCustomerGroupID
		  ,CreatedUser
		  ,ModifiedUser
		  ,UnitNo
		  ,ReceiptNo
		  ,Zno
	)
	VALUES
	(
		   @CardNo
		  ,@CustomerCode
		  ,@Title
		  ,@Name
		  ,@Name
		  ,@Gender
		  ,0
		  ,0
		  ,@NIC
		  ,@BD
		  ,0
		  ,0
		  ,0
		  ,@CardMasterID
		  ,0
		  ,GETDATE()
		  ,DATEADD(mm,6, GETDATE())
		  ,GETDATE()     
		  ,0
		  ,0
		  ,0
		  ,0
		  ,GETDATE()
		  ,GETDATE()
		  ,@SHNewYear
		  ,@ThaiPongal
		  ,@Vesak
		  ,@Hajj
		  ,@Ramazan
		  ,@Xmas
		  ,0
		  ,0
		  ,0
		  ,0
		  ,0
		  ,0
		  ,0
		  ,0
		  ,0
		  ,0
		  ,''
		  ,GETDATE()
		  ,0
		  ,0
		  ,0
		  ,0
		  ,0
		  ,0
		  ,1
		  ,@GroupOfCompanyID
		  ,GETDATE()
		  ,GETDATE()
		  ,0
		  ,0
		  ,0
		  ,0
		  ,0
		  ,GETDATE()
		  ,1
		  ,@CashierID
		  ,@LocationID
		  ,case @CustomerType when 3 then 2 else 0 end
		  ,0
		  ,@Mobile
		  ,@TerritoryID
		  ,@Email
		  ,@Occupaption
		  ,@Address
		  ,1
		  ,@UserName
		  ,@UserName
		  ,@UnitNo
		  ,@ReceiptNo
		  ,@Zno
	)
END

	


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

