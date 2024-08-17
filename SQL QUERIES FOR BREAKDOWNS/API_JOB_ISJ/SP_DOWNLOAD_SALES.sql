USE [Easyway]
GO

/****** Object:  StoredProcedure [dbo].[SP_DOWNLOAD_SALES]    Script Date: 11/09/2023 15:56:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[SP_DOWNLOAD_SALES]
@CuLoca	VarChar(3)='01'
AS
SET NOCOUNT ON
DECLARE @lastid 	int
Set @lastid=0


--Transact Download
DECLARE @Idx Int,@ItemCode varchar(25),@RefCode varchar(25),@Descrip  varchar(40),@Cost Money,@Price Money,@Qty Float,@Amount Decimal(18,4)
DECLARE @IDI1 Int,@IDis1 Char(10),@IDiscount1 Float,@IDI2 Int,@IDis2 Char(10),@IDiscount2 Float,@IDI3 Int,@IDis3 Char(10),@IDiscount3 Float
DECLARE @IDI4 Int,@IDis4 Char(10),@IDiscount4 Float,@IDI5 Int,@IDis5 Char(10),@IDiscount5 Float,@Rate Float,@SDStat Char(1),@SDNo Int
DECLARE @SDID Int,@SDIs Char(10),@SDiscount Float,@Tax Float,@Nett Float,@Loca Char(5),@IId Char(3),@Receipt Char(10),@Salesman Char(10)
DECLARE @Cust Varchar(15),@Cashier Varchar(15),@StartTime Datetime,@EndTime Datetime,@RecDate Datetime,@BillType Char(1),@Unit Char(5)
DECLARE @UnitNo Char(3),@RowNo Int,@CDate Datetime,@Status Int,@UpdateBy Varchar(15),@RecallStat Char(1),@SaleType Char(1),@RecallNo Varchar(10)
DECLARE @Pcs Decimal(18,0),@TrType Char(4),@Upload Char(1),@ZNo Decimal(18,0),@Invoice nchar(10),@Insertdate datetime,@PriceLevel int
DECLARE @Did int,@Serial char(10),@PackSize int,@InvSerial varchar(12),@ExpDate Varchar(20),@ItemType int,@ConFact Decimal(18,2),@PackScale Decimal(18,4)
DECLARE @NewCustCode varchar(20),@Barcode varchar(25),@KotType char(10),@TaxAmount float,@TaxStat char(10),@TaxPcnt char(10),@OrderBy varchar(15)
DECLARE	@OrderNo varchar(15),@PromId int,@ndescripplus varchar(100),@TableNo nchar(10),@TerminalNo nchar(10),@FLoca nchar(10),@KotBotNo nchar(10)
DECLARE @KotBotNoCnl nchar(10),@RecallAdv nchar(1),@Sinhala nvarchar(100),@KotPrint nchar(1),@RecallOrder nchar(1),@Shift int,@RefItemCode varchar(20)
DECLARE @Pax int,@descripplus varchar(100),@CustName nvarchar(100),@RefRowNo int,@Rc int,@TempReceipt char(10),@InvoiceNo nvarchar(100),@ReceiptEncrypt char(100)



Select @lastid=IsNull(Max(LastId),0) From tb_DownloadIdx Where Iid='SAL1' AND LOCA=@CuLoca
Delete From tb_DownloadIdx Where Iid='SAL1' And LastId<@lastid AND LOCA=@CuLoca

DECLARE cur_trns CURSOR FOR 
Select Idx,ItemCode,RefCode,Descrip,Cost,Price,Qty,Amount,IDI1,IDis1,IDiscount1,IDI2,IDis2,IDiscount2
,IDI3,IDis3,IDiscount3,IDI4,IDis4,IDiscount4,IDI5,IDis5,IDiscount5,Rate,SDStat,SDNo,SDID,SDIs,SDiscount
,Tax,Nett,Loca,IId,Receipt,Salesman,Cust,Cashier,StartTime,EndTime,RecDate,BillType,Unit,UnitNo,RowNo,CDate
,Status,UpdateBy,RecallStat,SaleType,RecallNo,Pcs,TrType,Upload,ZNo,invoice,Insertdate,PriceLevel,Did,Serial
,PackSize,InvSerial,ExpDate,ItemType,ConFact,PackScale,NewCustCode,Barcode,KotType,TaxAmount,TaxStat,TaxPcnt
,OrderBy,OrderNo,PromId,ndescripplus,TableNo,TerminalNo,FLoca,KotBotNo,KotBotNoCnl,RecallAdv,Sinhala,KotPrint
,RecallOrder,Shift,RefItemCode,Pax,descripplus,CustName,RefRowNo,Rc,TempReceipt,InvoiceNo,ReceiptEncrypt from  Easyway.Dbo.tbPosTransact WHERE Idx>@lastid Order By Idx

OPEN cur_trns

FETCH NEXT FROM cur_trns
INTO @Idx,@ItemCode,@RefCode,@Descrip,@Cost,@Price,@Qty,@Amount,@IDI1,@IDis1,@IDiscount1,@IDI2,@IDis2,@IDiscount2
,@IDI3,@IDis3,@IDiscount3,@IDI4,@IDis4,@IDiscount4,@IDI5,@IDis5,@IDiscount5,@Rate,@SDStat,@SDNo,@SDID,@SDIs,@SDiscount
,@Tax,@Nett,@Loca,@IId,@Receipt,@Salesman,@Cust,@Cashier,@StartTime,@EndTime,@RecDate,@BillType,@Unit,@UnitNo,@RowNo,@CDate
,@Status,@UpdateBy,@RecallStat,@SaleType,@RecallNo,@Pcs,@TrType,@Upload,@ZNo,@invoice,@Insertdate,@PriceLevel,@Did,@Serial
,@PackSize,@InvSerial,@ExpDate,@ItemType,@ConFact,@PackScale,@NewCustCode,@Barcode,@KotType,@TaxAmount,@TaxStat,@TaxPcnt
,@OrderBy,@OrderNo,@PromId,@ndescripplus,@TableNo,@TerminalNo,@FLoca,@KotBotNo,@KotBotNoCnl,@RecallAdv,@Sinhala,@KotPrint
,@RecallOrder,@Shift,@RefItemCode,@Pax,@descripplus,@CustName,@RefRowNo,@Rc,@TempReceipt,@InvoiceNo,@ReceiptEncrypt

WHILE @@FETCH_STATUS = 0
BEGIN     	
Insert Into OpenRowset('Sqloledb','124.43.76.88';'sa';'tstc123',EasyWay.dbo.tbPosTransact)([ItemCode],[RefCode],[Descrip],[Cost],[Price],[Qty],[Amount],[IDI1],[IDis1],[IDiscount1]
,[IDI2],[IDis2],[IDiscount2],[IDI3],[IDis3],[IDiscount3],[IDI4],[IDis4],[IDiscount4],[IDI5],[IDis5],[IDiscount5],[Rate]
,[SDStat],[SDNo],[SDID],[SDIs],[SDiscount],[Tax],[Nett],[Loca],[IId],[Receipt],[Salesman],[Cust],[Cashier],[StartTime]
,[EndTime],[RecDate],[BillType],[Unit],[UnitNo],[RowNo],[CDate],[Status],[UpdateBy],[RecallStat],[SaleType],[RecallNo]
,[Pcs],[TrType],[Upload],[ZNo],[invoice],[Insertdate],[PriceLevel],[Did],[Serial],[PackSize],[InvSerial],[ExpDate],[ItemType],[ConFact],[PackScale],[NewCustCode],[Barcode],[KotType],[TaxAmount],[TaxStat],[TaxPcnt]
,[OrderBy],[OrderNo],[PromId],[ndescripplus],[TableNo],[TerminalNo],[FLoca],[KotBotNo],[KotBotNoCnl],[RecallAdv],[Sinhala],[KotPrint]
,[RecallOrder],[Shift],[RefItemCode],[Pax],[descripplus],[CustName],[RefRowNo],[Rc],[TempReceipt],[InvoiceNo],[ReceiptEncrypt]) 
Values(@ItemCode,@RefCode,@Descrip,@Cost,@Price,@Qty,@Amount,@IDI1,@IDis1,@IDiscount1,@IDI2,@IDis2,@IDiscount2
,@IDI3,@IDis3,@IDiscount3,@IDI4,@IDis4,@IDiscount4,@IDI5,@IDis5,@IDiscount5,@Rate,@SDStat,@SDNo,@SDID,@SDIs,@SDiscount
,@Tax,@Nett,@Loca,@IId,@Receipt,@Salesman,@Cust,@Cashier,@StartTime,@EndTime,@RecDate,@BillType,@Unit,@UnitNo,@RowNo,@CDate
,@Status,@UpdateBy,@RecallStat,@SaleType,@RecallNo,@Pcs,@TrType,@Upload,@ZNo,@invoice,@Insertdate,@PriceLevel,@Did,@Serial
,@PackSize,@InvSerial,@ExpDate,@ItemType,@ConFact,@PackScale,@NewCustCode,@Barcode,@KotType,@TaxAmount,@TaxStat,@TaxPcnt
,@OrderBy,@OrderNo,@PromId,@ndescripplus,@TableNo,@TerminalNo,@FLoca,@KotBotNo,@KotBotNoCnl,@RecallAdv,@Sinhala,@KotPrint
,@RecallOrder,@Shift,@RefItemCode,@Pax,@descripplus,@CustName,@RefRowNo,@Rc,@TempReceipt,@InvoiceNo,@ReceiptEncrypt)
	
Insert Into tb_DownloadIdx ([Iid],[lastid],[LOCA]) Values ('SAL1',@Idx,@CuLoca)
        FETCH NEXT FROM cur_trns
	INTO @Idx,@ItemCode,@RefCode,@Descrip,@Cost,@Price,@Qty,@Amount,@IDI1,@IDis1,@IDiscount1,@IDI2,@IDis2,@IDiscount2
,@IDI3,@IDis3,@IDiscount3,@IDI4,@IDis4,@IDiscount4,@IDI5,@IDis5,@IDiscount5,@Rate,@SDStat,@SDNo,@SDID,@SDIs,@SDiscount
,@Tax,@Nett,@Loca,@IId,@Receipt,@Salesman,@Cust,@Cashier,@StartTime,@EndTime,@RecDate,@BillType,@Unit,@UnitNo,@RowNo,@CDate
,@Status,@UpdateBy,@RecallStat,@SaleType,@RecallNo,@Pcs,@TrType,@Upload,@ZNo,@INVOICE,@Insertdate,@PriceLevel,@Did,@Serial
,@PackSize,@InvSerial,@ExpDate,@ItemType,@ConFact,@PackScale,@NewCustCode,@Barcode,@KotType,@TaxAmount,@TaxStat,@TaxPcnt
,@OrderBy,@OrderNo,@PromId,@ndescripplus,@TableNo,@TerminalNo,@FLoca,@KotBotNo,@KotBotNoCnl,@RecallAdv,@Sinhala,@KotPrint
,@RecallOrder,@Shift,@RefItemCode,@Pax,@descripplus,@CustName,@RefRowNo,@Rc,@TempReceipt,@InvoiceNo,@ReceiptEncrypt

END

CLOSE cur_trns
DEALLOCATE cur_trns

--Download Payments
Set @lastid=0
DECLARE @Id Int,@TypeId Int,@Balance Float,@PaidAt Datetime,@SerialNo Varchar(20),@PStatus Char(1),@CustType Char(1)
DECLARE @BankId Int,@ChequeDate Varchar(15),@AdvanceNo Char(10),@PId int,@PaymentNo varchar(10),@TypeId2 int,@CurId int
DECLARE @CurRate decimal(18,4),@Curcode char(3),@CurRateRel decimal(18,6),@CurRateLkr decimal(18,6),@CurIdDef int,@RealAmount decimal(18,4)
DECLARE @CardRate decimal(12,2),@ErpId int,@PStatusX char(1)



Select @lastid=IsNull(Max(LastId),0) From tb_DownloadIdx Where Iid='SAL2' AND LOCA=@CuLoca
Delete From tb_DownloadIdx Where Iid='SAL2' And LastId<@lastid  AND LOCA=@CuLoca


DECLARE cur_pay CURSOR FOR 
Select Idx,Receipt,Loca,UnitNo,Sdate,Id,TypeId,Amount,Balance,Cashier,PaidAt,BillType,SerialNo,PStatus,Cust,CustType
,BankId,ChequeDate,UpdateBy,AdvanceNo,Upload,ZNo,INVOICE,Insertdate,Did,PId,Serial,PaymentNo,TypeId2,InvSerial,NewCustCode
,CurId,CurRate,CurCode,CurRateRel,CurRateLkr,CurIdDef,RealAmount,FLoca,TableNo,OrderNo,Shift,CustName,CardRate,ErpId,Rc,PStatusX
,TempReceipt,InvoiceNo,ReceiptEncrypt from EasyWay.Dbo.tbPosPayment WHERE Idx>@lastid Order By Idx

OPEN cur_pay

FETCH NEXT FROM cur_pay
INTO @Idx,@Receipt,@Loca,@UnitNo,@RecDate,@Id,@TypeId,@Amount,@Balance,@Cashier,@PaidAt,@BillType,@SerialNo,@PStatus,@Cust,@CustType
,@BankId,@ChequeDate,@UpdateBy,@AdvanceNo,@Upload,@ZNo,@Invoice,@Insertdate,@Did,@PId,@Serial,@PaymentNo,@TypeId2,@InvSerial,@NewCustCode
,@CurId,@CurRate,@CurCode,@CurRateRel,@CurRateLkr,@CurIdDef,@RealAmount,@FLoca,@TableNo,@OrderNo,@Shift,@CustName,@CardRate,@ErpId,@Rc,@PStatusX
,@TempReceipt,@InvoiceNo,@ReceiptEncrypt

WHILE @@FETCH_STATUS = 0
BEGIN     	
     Insert Into OpenRowset('Sqloledb','124.43.76.88';'sa';'tstc123',EasyWay.dbo.tbPosPayment)([Receipt],[Loca],[UnitNo],[Sdate],[Id],[TypeId],[Amount],[Balance],[Cashier]
	,[PaidAt],[BillType],[SerialNo],[PStatus],[Cust],[CustType],[BankId],[ChequeDate],[UpdateBy],[AdvanceNo]
	,[Upload],[ZNo],[Invoice],[Insertdate],[Did],[PId],[Serial],[PaymentNo],[TypeId2],[InvSerial],[NewCustCode]
,[CurId],[CurRate],[CurCode],[CurRateRel],[CurRateLkr],[CurIdDef],[RealAmount],[FLoca],[TableNo],[OrderNo],[Shift],[CustName],[CardRate],[ErpId],[Rc],[PStatusX]
,[TempReceipt],[InvoiceNo],[ReceiptEncrypt]) 
	Values(@Receipt,@Loca,@UnitNo,@RecDate,@Id,@TypeId,@Amount,@Balance,@Cashier,@PaidAt,@BillType,@SerialNo
	,@PStatus,@Cust,@CustType,@BankId,@ChequeDate,@UpdateBy,@AdvanceNo,@Upload,@ZNo,@invoice,@Insertdate,@Did,@PId,@Serial,@PaymentNo,@TypeId2,@InvSerial,@NewCustCode
,@CurId,@CurRate,@CurCode,@CurRateRel,@CurRateLkr,@CurIdDef,@RealAmount,@FLoca,@TableNo,@OrderNo,@Shift,@CustName,@CardRate,@ErpId,@Rc,@PStatusX
,@TempReceipt,@InvoiceNo,@ReceiptEncrypt)
	
	Insert Into tb_DownloadIdx ([Iid],[lastid],[loca]) Values ('SAL2',@Idx,@CuLoca)
     FETCH NEXT FROM cur_pay
INTO @Idx,@Receipt,@Loca,@UnitNo,@RecDate,@Id,@TypeId,@Amount,@Balance,@Cashier,@PaidAt,@BillType,@SerialNo,@PStatus,@Cust,@CustType
,@BankId,@ChequeDate,@UpdateBy,@AdvanceNo,@Upload,@ZNo,@invoice,@Insertdate,@Did,@PId,@Serial,@PaymentNo,@TypeId2,@InvSerial,@NewCustCode
,@CurId,@CurRate,@CurCode,@CurRateRel,@CurRateLkr,@CurIdDef,@RealAmount,@FLoca,@TableNo,@OrderNo,@Shift,@CustName,@CardRate,@ErpId,@Rc,@PStatusX
,@TempReceipt,@InvoiceNo,@ReceiptEncrypt

END

CLOSE cur_pay
DEALLOCATE cur_pay

GO

