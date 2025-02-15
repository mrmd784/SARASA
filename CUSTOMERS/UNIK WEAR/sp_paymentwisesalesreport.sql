USE [easyway]
GO
/****** Object:  StoredProcedure [dbo].[Sp_PaytypeWiseItemSales]    Script Date: 2024-08-09 9:59:17 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER Proc [dbo].[Sp_PaytypeWiseItemSales]
@LocaCode	Varchar(10),
@ItemFrom	Varchar(30),
@ItemTo		Varchar(30),
@DateFrom	Varchar(10),
@DateTo		Varchar(10),
@UserName	Varchar(20),
@Type		Int	
AS

Select SerialNo,LocaCode,IDate,ItemCode,ItemDescrip,Scale,PackSize,Rate,Qty,GAmount,Discount,NetAmount,DiscountForTot,ID,tb_item.Ref_Code as status,
0 As PMode,'                              ' As PaymentMode Into #Sales
From tb_InvDet inner join tb_item  On tb_InvDet.ItemCode = tb_item.Item_Code
Where [Status]=1 And LocaCode=@LocaCode And IDate Between @DateFrom And @DateTo And Status=1 And ID In ('INV','MKR')

Update #Sales Set #Sales.PMode=tb_InvSumm.PMode From #Sales Join tb_InvSumm On #Sales.LocaCode=tb_InvSumm.LocaCode And 
#Sales.SerialNo=tb_InvSumm.SerialNo And #Sales.Id=tb_InvSumm.Id Where #Sales.Id='INV' And tb_InvSumm.Id='INV'

Select ReceiptNo,LocaCode,InvoiceDate,'INV' As ID,
Max(Case

When PMode=1 Then 1 
When PMode=2 Then 2
When PMode=3 Then 3
When PMode=4 Then 4
When PMode=6 Then 6 
When PMode=7 Then 7         
--When (PMode=10 OR PMode=11 OR PMode=12 OR PMode=4) Then 3 
When PMode=23 Then 23
When PMode=24 Then 24
When PMode=25 Then 25
When PMode=29 Then 29  
When PMode=30 Then 30
When PMode=31 Then 31
When PMode=32 Then 32    
ELSE 5 End) As Mode   Into #Pmt
From tb_Payment Where [Status]=1 And LocaCode=@LocaCode And InvoiceDate Between @DateFrom And @DateTo And Status=1 And ID In ('PMT')
Group By ReceiptNo,LocaCode,InvoiceDate

--Select ReceiptNo,LocaCode,InvoiceDate,'INV' As ID,
--Max(PMode) As Mode  Into #Pmt
--From tb_Payment Where [Status]=1 And LocaCode=@LocaCode And InvoiceDate Between @DateFrom And @DateTo And Status=1 And ID In ('PMT')
--Group By ReceiptNo,LocaCode,InvoiceDate

--13-8
Update #Sales Set #Sales.PMode=#Pmt.Mode From #Sales Join #Pmt On #Sales.LocaCode=#Pmt.LocaCode And 
#Sales.SerialNo=#Pmt.ReceiptNo And #Sales.Id=#Pmt.Id Where #Sales.Id='INV' 
And #Sales.SerialNo Like 'P%' 

Update #Sales Set #Sales.PMode=2 From #Sales Join tb_InvSumm On #Sales.LocaCode=tb_InvSumm.LocaCode And 
#Sales.SerialNo=tb_InvSumm.SerialNo And #Sales.Id=tb_InvSumm.Id Where #Sales.Id='INV' And tb_InvSumm.Id='INV'
And #Sales.SerialNo Not Like 'P%' And tb_InvSumm.PMode=2

Update #Sales Set #Sales.PMode=#Pmt.Mode From #Sales Join #Pmt On #Sales.LocaCode=#Pmt.LocaCode And 
#Sales.SerialNo=#Pmt.ReceiptNo And #Sales.Id=#Pmt.Id Where #Sales.Id='INV' 
And #Sales.SerialNo Not Like 'P%' And #Sales.PMode=0

Update #Sales Set #Sales.PMode=#Pmt.Mode From #Sales Join #Pmt On #Sales.LocaCode=#Pmt.LocaCode And 
#Sales.SerialNo=#Pmt.ReceiptNo And #Sales.Idate=#Pmt.InvoiceDate Where #Sales.Id='MKR' And #Pmt.ID='INV'
And #Sales.SerialNo Not Like 'P%' And #Sales.PMode=0


Update #Sales Set PaymentMode= tb_PaymentMode.TypeName from #Sales Inner join tb_PaymentMode on #Sales.PMode = tb_PaymentMode.RefId
Update #Sales Set PaymentMode='CASH SALES' Where PMode=1
--Update #Sales Set PaymentMode='CREDIT CARD SALES' Where PMode in ('2','3','4')
Update #Sales Set PaymentMode='BANK TRANSFER' Where PMode=30
Update #Sales Set PaymentMode='KOKO' Where PMode=24
Update #Sales Set PaymentMode='MINT' Where PMode=25
Update #Sales Set PaymentMode='COD' Where PMode=29
Update #Sales Set PaymentMode='OTHER PAYMENT SALES' Where PMode=5

Truncate Table #Pmt
Drop Table #Pmt
--Select Distinct PaymentMode from #Sales
If (@Type=0)
Begin

	UPDATE S SET S.ID=I.SubCat_Code FROM TB_ITEM AS I JOIN #Sales AS S ON I.Item_Code=S.ItemCode
	UPDATE S SET S.Status=C.SubCat_Name FROM tb_SubCategory AS C JOIN #Sales AS S ON C.SubCat_Code=S.Id

	Select * from #Sales Where ItemCode Between @ItemFrom And @ItemTo order by PaymentMode asc
End
Else
Begin
	UPDATE S SET S.ID=I.SubCat_Code FROM TB_ITEM AS I JOIN #Sales AS S ON I.Item_Code=S.ItemCode
	UPDATE S SET S.Status=C.SubCat_Name FROM tb_SubCategory AS C JOIN #Sales AS S ON C.SubCat_Code=S.Id

	Select * from #Sales Where ItemCode IN 
	(SELECT Code FROM tb_TempSelect WHERE UserName=@UserName AND [Id]='ISL' AND LocaCode=@LocaCode) order by PaymentMode asc
End
Drop Table #Sales