USE [Easyway]
GO
/****** Object:  StoredProcedure [dbo].[SP_GET_Invoice_RPT]    Script Date: 2024-08-10 9:34:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_GET_Invoice_RPT]--'C01000118','01','0'
@serialNo	Varchar(30),
@LocaCode		Char(5),
@custCode varchar(20) =''
AS

/*
SELECT tb_InvDet.ItemCode, 
tb_InvDet.ItemDescrip,
tb_Item.SinhalaDescrip, 
tb_InvDet.Unit, 
tb_InvDet.Rate, 
tb_InvDet.Qty,--tb_InvDet.GAmount,  tb_InvSumm.Nbt
tb_InvDet.GAmount,tb_InvDet.Discount as detDisc, tb_InvSumm.Disc,
tb_InvDet.DiscP,tb_Item.L1_Code AS Warrenty, Isnull(tb_InvDet.Rem1,'')as Rem1,Isnull(tb_InvDet.Rem2,'')as Rem2,Isnull(tb_InvDet.Rem3,'')as Rem3,Isnull(tb_InvDet.Rem4,'')as Rem4,case when tb_InvSumm.IType=1 
then CONVERT(DATETIME, CONVERT(CHAR(8), tb_InvSumm.IDate, 112) 
+ ' ' + CONVERT(CHAR(8), tb_InvSumm.DilDate, 108))
else tb_InvSumm.DilDate end as DilDate,  tb_InvDet.LnNo,  tb_InvDet.AodDate,  
tb_InvDet.ItemSerialNo,tb_InvDet.BatchNo,tb_SalesRep.Rep_Name,tb_SalesRep.Rep_Code,
tb_InvSumm.SerialNo, tb_InvSumm.LocaCode, tb_InvSumm.RefNo, tb_InvSumm.IDate, tb_InvSumm.CustCode, tb_InvSumm.CustName,
tb_InvSumm.BalPay,tb_InvSumm.BalAmt,tb_InvSumm.[Status],
tb_InvSumm.QutNo, tb_InvSumm.NetAmount As Gamount1, tb_InvSumm.SubTotDiscount as SubTotDiscount, tb_InvDet.Discount, tb_InvSumm.Tax,tb_InvSumm.Vat,
tb_InvDet.NetAmount,tb_InvSumm.Pay1,tb_InvSumm.Pay2,tb_InvSumm.Pay3,tb_InvSumm.Pay4,
tb_InvSumm.Amt1,tb_InvSumm.Amt2,tb_InvSumm.Amt3,tb_InvSumm.Amt4,tb_InvSumm.InvoiceRemark,
tb_InvSumm.Advance, tb_InvSumm.[Returns] AS NBT, tb_InvSumm.Balance, tb_InvSumm.UserName,tb_InvSumm.PType, tb_InvSumm.PMode,tb_PurchaseType.TypeName,tb_InvSumm.VehicleNumber,
tb_InvSumm.IType,
tb_PaymentMode.TypeName As TName,tb_Location.Loca_Name, tb_Location.Address1, tb_Location.Address2, tb_Location.Address3,tb_Customer.Address1 As CAdd1, tb_Customer.Address2 As CAdd2, tb_Customer.Address3 As CAdd3,
tb_Customer.Country As WarrantyReferenceNo, tb_Location.Phone1, tb_Location.Phone2,tb_Location.Phone3, tb_Location.Fax, tb_Location.email, tb_Location.Web_Site ,tb_Location.vatPercentage As VatP,tb_Customer.Contact_No,
 tb_InvDet.ItemRemark,tb_Customer.CreditLimit,tb_Customer.CreditPeriod,
 TB_SubCategory.SubCat_Code,
(LTRIM(RTRIM(TB_SubCategory.SubCat_Code))+'-'+(LTRIM(RTRIM(TB_SubCategory.SubCat_Name)))) AS SubCat_Name 
 From (((((((tb_InvDet 
 INNER JOIN tb_InvSumm ON tb_InvDet.SerialNo = tb_InvSumm.SerialNo 
 AND tb_InvDet.LocaCode = tb_InvSumm.LocaCode AND tb_InvDet.RefNo = tb_InvSumm.RefNo)
 INNER JOIN tb_SalesRep on  tb_InvDet.RepCode = tb_SalesRep.Rep_Code)
 INNER JOIN tb_PaymentMode ON tb_InvSumm.PMode = tb_PaymentMode.TypeId) 
 INNER JOIN tb_Location ON tb_InvSumm.LocaCode = tb_Location.Loca_Code) 
 INNER JOIN tb_PurchaseType ON tb_InvSumm.PType = tb_PurchaseType.TypeId)
 INNER JOIN tb_Item ON tb_InvDet.ItemCode = tb_Item.Item_Code
 INNER JOIN TB_SubCategory ON tb_Item.SubCat_Code = TB_SubCategory.SubCat_Code
 LEFT OUTER JOIN tb_Link1 ON tb_InvDet.Rem1= tb_Link1.L1_Code)
 Left Outer JOIN tb_Customer ON tb_InvSumm.CustCode = tb_Customer.Cust_Code)  
 Where 
 tb_InvSumm.SerialNo=@serialNo And  tb_InvSumm.LocaCode=@LocaCode  And  tb_InvSumm.Id='INV' And tb_InvDet.Id='INV'
 Order By tb_InvDet.LnNo
 */

 
 
SELECT tb_InvDet.ItemCode, 
tb_InvDet.ItemDescrip,
tb_Item.SinhalaDescrip, 
tb_InvDet.Unit, 
tb_InvDet.Rate, 
tb_InvDet.Qty,--tb_InvDet.GAmount,  tb_InvSumm.Nbt
tb_InvDet.GAmount,tb_InvDet.Discount as detDisc, tb_InvSumm.Disc,
tb_InvDet.DiscP,tb_Link2.L2_Name AS Warrenty, Isnull(tb_Link1.L1_Name,'')as Rem1,Isnull(tb_Link3.L3_Name,'')as Rem2,Isnull(tb_SubCategory.SubCat_Name,'')as Rem3,Isnull(tb_Category.Cat_Name,'')as Rem4,case when tb_InvSumm.IType=1 
then CONVERT(DATETIME, CONVERT(CHAR(8), tb_InvSumm.IDate, 112) 
+ ' ' + CONVERT(CHAR(8), tb_InvSumm.DilDate, 108))
else tb_InvSumm.DilDate end as DilDate,  tb_InvDet.LnNo,  tb_InvDet.AodDate,  
tb_InvDet.ItemSerialNo,tb_InvDet.BatchNo,tb_SalesRep.Rep_Name,tb_SalesRep.Rep_Code,
tb_InvSumm.SerialNo, tb_InvSumm.LocaCode, tb_InvSumm.RefNo, tb_InvSumm.IDate, tb_InvSumm.CustCode, tb_InvSumm.CustName,
tb_InvSumm.BalPay,tb_InvSumm.BalAmt,tb_InvSumm.[Status],
tb_InvSumm.QutNo, tb_InvSumm.NetAmount As Gamount1, tb_InvSumm.SubTotDiscount as SubTotDiscount, tb_InvDet.Discount, tb_InvSumm.Tax,tb_InvSumm.Vat,
tb_InvDet.NetAmount,tb_InvSumm.Pay1,tb_InvSumm.Pay2,tb_InvSumm.Pay3,tb_InvSumm.Pay4,
tb_InvSumm.Amt1,tb_InvSumm.Amt2,tb_InvSumm.Amt3,tb_InvSumm.Amt4,tb_InvSumm.InvoiceRemark,
tb_InvSumm.Advance, tb_InvSumm.[Returns] AS NBT, tb_InvSumm.Balance, tb_InvSumm.UserName,tb_InvSumm.PType, tb_InvSumm.PMode,tb_PurchaseType.TypeName,tb_InvSumm.VehicleNumber,
tb_InvSumm.IType,
tb_PaymentMode.TypeName As TName,tb_Location.Loca_Name, tb_Location.Address1, tb_Location.Address2, tb_Location.Address3,tb_Customer.Address1 As CAdd1, tb_Customer.Address2 As CAdd2, tb_Customer.Address3 As CAdd3,
tb_Customer.Country As WarrantyReferenceNo, tb_Location.Phone1, tb_Location.Phone2,tb_Location.Phone3, tb_Location.Fax, tb_Location.email, tb_Location.Web_Site ,tb_Location.vatPercentage As VatP,tb_Customer.Contact_No,
 tb_InvDet.ItemRemark,tb_Customer.CreditLimit,tb_Customer.CreditPeriod,
 TB_SubCategory.SubCat_Code,
(LTRIM(RTRIM(TB_SubCategory.SubCat_Code))+'-'+(LTRIM(RTRIM(TB_SubCategory.SubCat_Name)))) AS SubCat_Name 
 From ((((((((((((tb_InvDet 
 INNER JOIN tb_InvSumm ON tb_InvDet.SerialNo = tb_InvSumm.SerialNo 
 AND tb_InvDet.LocaCode = tb_InvSumm.LocaCode AND tb_InvDet.RefNo = tb_InvSumm.RefNo)
 INNER JOIN tb_SalesRep on  tb_InvDet.RepCode = tb_SalesRep.Rep_Code)
 INNER JOIN tb_PaymentMode ON tb_InvSumm.PMode = tb_PaymentMode.TypeId) 
 INNER JOIN tb_Location ON tb_InvSumm.LocaCode = tb_Location.Loca_Code) 
 INNER JOIN tb_PurchaseType ON tb_InvSumm.PType = tb_PurchaseType.TypeId)
 INNER JOIN tb_Item ON tb_InvDet.ItemCode = tb_Item.Item_Code)
 INNER JOIN TB_SubCategory ON tb_Item.SubCat_Code = TB_SubCategory.SubCat_Code)
 INNER JOIN TB_Category ON tb_Item.Cat_Code = TB_Category.Cat_Code)
 LEFT OUTER JOIN tb_Link1 ON tb_InvDet.Rem1= tb_Link1.L1_Code)
 LEFT OUTER JOIN tb_Link2 ON tb_InvDet.Rem2= tb_Link2.L2_Code)
 LEFT OUTER JOIN tb_Link3 ON tb_InvDet.Rem3= tb_Link3.L3_Code)
 Left Outer JOIN tb_Customer ON tb_InvSumm.CustCode = tb_Customer.Cust_Code)  
 Where 
 tb_InvSumm.SerialNo=@serialNo And  tb_InvSumm.LocaCode=@LocaCode  And  tb_InvSumm.Id='INV' And tb_InvDet.Id='INV'
 Order By tb_InvDet.LnNo