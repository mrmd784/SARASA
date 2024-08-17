USE [Easyway]
GO
/****** Object:  StoredProcedure [dbo].[Send_Birthday]    Script Date: 2024-07-03 9:18:51 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER proc [dbo].[DELETE_EBILL]
as

--select cast(dateadd(day, -30, getdate()) as date)
--select * from tbpostransact where upload='O' and cast(recdate as date)=cast(dateadd(day, -30, getdate()) as date)
--select * from tbpospayment where upload='O' and cast(sdate as date)=cast(dateadd(day, -30, getdate()) as date)

INSERT INTO [dbo].[tbPostransact2]
([ItemCode],[RefCode],[Descrip],[Cost],[Price],[Qty],[Amount],[IDI1],[IDis1],[IDiscount1],[IDI2],[IDis2],[IDiscount2],[IDI3]
,[IDis3],[IDiscount3],[IDI4],[IDis4],[IDiscount4],[IDI5],[IDis5],[IDiscount5],[Rate],[SDStat],[SDNo],[SDID],[SDIs],[SDiscount]
,[Tax],[Nett],[Loca],[IId],[Receipt],[Salesman],[Cust],[Cashier],[StartTime],[EndTime],[RecDate],[BillType],[Unit],[UnitNo]
,[RowNo],[CDate],[Status],[UpdateBy],[RecallStat],[SaleType],[RecallNo],[Pcs],[Invoice],[TrType],[Upload],[ZNo],[Insertdate],[PriceLevel]
,[Did],[Serial],[PackSize],[InvSerial],[ExpDate],[ItemType],[ConFact],[PackScale],[NewCustCode],[BarCode],[KotType],[TaxAmount],[TaxStat]
,[TaxPcnt],[OrderBy],[OrderNo],[PromId],[ndescripplus],[TableNo],[TerminalNo],[FLoca],[KotBotNo],[KotBotNoCnl],[RecallAdv],[Sinhala],[KotPrint]
,[RecallOrder],[Shift],[RefItemCode],[Pax],[descripplus],[CustName],[RefRowNo],[TransferDate],[Rc],[InvoiceNo])
SELECT
[ItemCode],[RefCode],[Descrip],[Cost],[Price],[Qty],[Amount],[IDI1],[IDis1],[IDiscount1],[IDI2],[IDis2],[IDiscount2]
,[IDI3],[IDis3],[IDiscount3],[IDI4],[IDis4],[IDiscount4],[IDI5],[IDis5],[IDiscount5],[Rate],[SDStat],[SDNo],[SDID],[SDIs],[SDiscount]
,[Tax],[Nett],[Loca],[IId],[Receipt],[Salesman],[Cust],[Cashier],[StartTime],[EndTime],[RecDate],[BillType],[Unit],[UnitNo]
,[RowNo],[CDate],[Status],[UpdateBy],[RecallStat],[SaleType],[RecallNo],[Pcs],[Invoice],[TrType],[Upload],[ZNo],[Insertdate],[PriceLevel]
,[Did],'EBILLBKP',[PackSize],[InvSerial],[ExpDate],[ItemType],[ConFact],[PackScale],[NewCustCode],[BarCode],[KotType],[TaxAmount],[TaxStat]
,[TaxPcnt],[OrderBy],[OrderNo],[PromId],[ndescripplus],[TableNo],[TerminalNo],[FLoca],[KotBotNo],[KotBotNoCnl],[RecallAdv],[Sinhala],[KotPrint]
,[RecallOrder],[Shift],[RefItemCode],[Pax],[descripplus],[CustName],[RefRowNo],[TransferDate],[Rc],[InvoiceNo]
FROM [dbo].[tbPostransact] where upload='O' and cast(recdate as date)=cast(dateadd(day, -30, getdate()) as date)


INSERT INTO [dbo].[tbPospayment2]
([Receipt],[Loca],[UnitNo],[Sdate],[Id],[TypeId],[Amount],[Balance],[Cashier],[PaidAt],[BillType],[SerialNo],[PStatus],[Cust],[CustType]
,[BankId],[ChequeDate],[UpdateBy],[AdvanceNo],[Invoice],[Upload],[ZNo],[Insertdate],[Did],[PId],[Serial],[PaymentNo],[TypeId2]
,[InvSerial],[NewCustCode],[CurId],[CurRate],[CurCode],[CurRateRel],[CurRateLkr],[CurIdDef],[RealAmount],[FLoca],[TableNo]
,[OrderNo],[Shift],[CustName],[CardRate],[ErpId],[TransferDate],[Rc],[PStatusX],[InvoiceNo])
SELECT 
[Receipt],[Loca],[UnitNo],[Sdate],[Id],[TypeId],[Amount],[Balance],[Cashier],[PaidAt],[BillType],[SerialNo],[PStatus],[Cust],[CustType]
,[BankId],[ChequeDate],[UpdateBy],[AdvanceNo],[Invoice],[Upload],[ZNo],[Insertdate],[Did],[PId],'EBILLBKP',[PaymentNo],[TypeId2]
,[InvSerial],[NewCustCode],[CurId],[CurRate],[CurCode],[CurRateRel],[CurRateLkr],[CurIdDef],[RealAmount],[FLoca],[TableNo]
,[OrderNo],[Shift],[CustName],[CardRate],[ErpId],[TransferDate],[Rc],[PStatusX],[InvoiceNo]
 FROM [dbo].[tbPospayment] where upload='O' and cast(sdate as date)=cast(dateadd(day, -30, getdate()) as date)


delete from tbpostransact where upload='O' and cast(recdate as date)=cast(dateadd(day, -30, getdate()) as date)
delete from tbpospayment where upload='O' and cast(sdate as date)=cast(dateadd(day, -30, getdate()) as date)






