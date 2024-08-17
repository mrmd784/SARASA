USE [Easyway]
GO

/****** Object:  StoredProcedure [dbo].[Send_Birthday]    Script Date: 2024-02-29 11:50:41 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE proc [dbo].[Send_Birthday]
as

DECLARE @InNextDays INT;
SET @InNextDays =7


--SEND BIRTHDAY PROMOTION
INSERT INTO [LoyaltyMessage]
([PhoneNo],[MessageText],[SendStatus],[UpdatedDate])

SELECT '94'+ SUBSTRING(Mobile,2,LEN(Mobile)),'A little birdie told us that someone special is celebrating their birthday next week and we at MIIKA love celebrating special days and so we have a gift just for you!'+ 
'
For any purchases made on your birthday month at one of our stores will give you 20% off on your total purchase!!!'+
'
Hotline - 0764455145'
,0,GetDate()
FROM tb_CustomerLoyalty where  sendstat='0' and DOB<>'1900-01-01 00:00:00.000' and len(mobile)='10'
and DATEADD( Year, DATEPART( Year, GETDATE()) - DATEPART( Year, DOB), DOB)
      BETWEEN CONVERT( DATE, GETDATE()) 
      AND CONVERT( DATE, GETDATE() + @InNextDays)


--Update sendstat as 1
update tb_CustomerLoyalty set sendstat=1 where  sendstat='0' and DOB<>'1900-01-01 00:00:00.000' and len(mobile)='10'
and DATEADD( Year, DATEPART( Year, GETDATE()) - DATEPART( Year, DOB), DOB)
      BETWEEN CONVERT( DATE, GETDATE()) 
      AND CONVERT( DATE, GETDATE() + @InNextDays)


--SEND BIRTHDAY WISH

INSERT INTO [LoyaltyMessage]
([PhoneNo],[MessageText],[SendStatus],[UpdatedDate])
 SELECT '94'+  SUBSTRING(Mobile,2,LEN(Mobile))
 ,'Hip Hip hoorayy!!! It is your birthday today!'+ 
'
We at MIIKA wish you a very Happy Birthday Dear '+ CustName +'.'+
'
Go on, Enjoy 20% off on us today. Valid for any purchase from our stores.'+
'
Hotline - 0764455145'
,0,GetDate()
FROM tb_CustomerLoyalty
where  DOB<>'1900-01-01 00:00:00.000' and len(mobile)='10' and sendstat='1' and SendBday='0'
and DATEADD( Year, DATEPART( Year, GETDATE()) - DATEPART( Year, DOB), DOB) = CONVERT( DATE, GETDATE())


--Update sendBday as 1
update tb_CustomerLoyalty set SendBday='1'
where  DOB<>'1900-01-01 00:00:00.000' and len(mobile)='10' and SendBday='0'
and DATEADD( Year, DATEPART( Year, GETDATE()) - DATEPART( Year, DOB), DOB) = CONVERT( DATE, GETDATE())



--UPDATE SENDSTAT FOR NEXT YEAR

--select * from tb_CustomerLoyalty where DATEPART(MONTH,DOB)<DATEPART(MONTH,GETDATE())

update tb_CustomerLoyalty set sendstat='0',SendBday='0'
where DATEPART(MONTH,DOB)<DATEPART(MONTH,GETDATE())




GO

