USE SPOSDATA

DECLARE @loca int =(select top 1 locationid from sysconfig)

Insert into CashierPermission(CashierID,LocationID,FunctName,Description,IsAccess,MaxValue)
			values(999999,@loca,'ADVANCE','Advance Payment',1,999999)