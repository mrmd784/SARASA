*** tb_Location ***
--Delete From tb_Location
--Select * From tb_Location
Insert Into tb_Location ([Loca_Code],[Loca_Name],[Contact_Name],[Contact_No],[Address1],[Address2],[Address3],[Ref_Code],[Phone1],[Phone2],[Phone3],[Fax],[email],[Web_Site],[CDate],[State],[User_ID],[PNO],[PRNO],[OPB],[L1Name],[L2Name],[L3Name],[L4Name],[Dept_Item],[StkSt],[MLInv],[ActPrl],[PrcPch],[Lac],[ItmAuto],[ItmClr],[ItmMgn],[PchDec],[BId],[MlSrl],[PrintOrg],[MsgPort],[ImagePath],[AutoSrl],[Coloursize],[Colour],[Size],[PCHType],[L5Name],[GROUP_CODE],[L6Name],[L7Name],[decPointCurr],[decPointNum],[decPointGen],[decPointQty],[useColorNSize],[vatPercentage],[expandLinks],[costCodeIsMin],[updateReturnChq],[clearPDCheques],[allowNonSupplierItem],[autoSuggest],[autoFilter],[autoUpdate],[priceRounding],[SubCatDepend],[SpPricesOnLocaOnly],[isBackDateInvoice],[costCodeLength],[CostingMethod],[VatP2])
Select			 [Loca_Code],[Loca_Name],[Contact_Name],[Contact_No],[Address1],[Address2],[Address3],[Ref_Code],[Phone1],[Phone2],[Phone3],[Fax],[email],[Web_Site],[CDate],[State],[User_ID],[PNO],[PRNO],[OPB],[L1Name],[L2Name],[L3Name],[L4Name],[Dept_Item],[StkSt],[MLInv],[ActPrl],[PrcPch],[Lac],[ItmAuto],[ItmClr],[ItmMgn],[PchDec],[BId],[MlSrl],[PrintOrg],[MsgPort],[ImagePath],[AutoSrl],[Coloursize],[Colour],[Size],[PCHType],[L5Name],[GROUP_CODE],[L6Name],[L7Name],[decPointCurr],[decPointNum],[decPointGen],[decPointQty],[useColorNSize],[vatPercentage],[expandLinks],[costCodeIsMin],[updateReturnChq],[clearPDCheques],[allowNonSupplierItem],[autoSuggest],[autoFilter],[autoUpdate],[priceRounding],[SubCatDepend],[SpPricesOnLocaOnly],[isBackDateInvoice],[costCodeLength],[CostingMethod],[VatP2] From EASYWAY.dbo.tb_Location
Select * From tb_Location
Select * From EASYWAY.dbo.tb_Location

--Delete From tb_Category
Select * From tb_Category


Insert Into tb_Category([Cat_Code],[Cat_Name],[Cat_Rate],[CDate],[User_Id])
Select  		[Cat_Code],[Cat_Name],[Cat_Rate],[CDate],[User_Id] From EASYWAY.dbo.tb_Category

select * from EASYWAY.dbo.tb_Category
*** tb_SubCategory ***

--Delete From tb_SubCategory
Select * From tb_SubCategory
Insert Into tb_SubCategory([Cat_Code],[SubCat_Code],[SubCat_Name],[CDate],[User_Id])
Select 			   [Cat_Code],[SubCat_Code],[SubCat_Name],[CDate],[User_Id] From EASYWAY.dbo.tb_SubCategory

select * from EASYWAY.dbo.tb_SubCategory
*** tb_Supplier ***

--Delete From tb_Supplier
select * From tb_Supplier
Insert Into tb_Supplier (Supp_Code, Supp_Name, Contact_Name, Contact_No, Address1, Address2, Address3, Country, Phone1, Phone2, Phone3, Fax, Email, Web_Site, CDate, Status, User_Id, Download, AccNo, Branch, 
                         Credit_Period, UpdateItem, Cat_Rate, EditDate, LeadTime, CountryCode)
Select 			         Supp_Code, Supp_Name, Contact_Name, Contact_No, Address1, Address2, Address3, Country, Phone1, Phone2, Phone3, Fax, Email, Web_Site, CDate, Status, User_Id, Download, AccNo, Branch, 
                         0, NULL, 0.00, '2023-07-31 13:52:53.790', 0, 0   From EASYWAY.dbo.tb_Supplier 

select * from EASYWAY.dbo.tb_Supplier

UPDATE tb_Supplier SET CountryCode='01',AccNo='',Branch=''   

*** tb_Link1 ***

--Delete From tb_Link1
--Select * From tb_Link1
Insert Into tb_Link1 ([L1_Code],[L1_Name],[L1_Rate],[CDate],[User_Id],[color_name],[color_code],[Printer_name])
Select  	      [L1_Code],[L1_Name],[L1_Rate],[CDate],[User_Id],'','',''  From EASYWAY.dbo.tb_Link1

Select * From EASYWAY.dbo.tb_Link1

*** tb_Link2 ***

--Delete From tb_Link2
--Select * From tb_Link2
Insert Into tb_Link2 ([L2_Code],[L2_Name],[L2_Rate],[CDate],[User_Id])
Select  	      [L2_Code],[L2_Name],[L2_Rate],[CDate],[User_Id]  From EASYWAY.dbo.tb_Link2
Select * From EASYWAY.dbo.tb_Link2
*** tb_Link3 ***

--Delete From tb_Link3
--Select * From tb_Link3
Insert Into tb_Link3 ([L3_Code],[L3_Name],[L3_Rate],[CDate],[User_Id])
Select   	      [L3_Code],[L3_Name],[L3_Rate],[CDate],[User_Id]  From EASYWAY.dbo.tb_Link3
Select * From EASYWAY.dbo.tb_Link3
*** tb_Link4 ***

--Delete From tb_Link4
--Select * From tb_Link4
Insert Into tb_Link4 ([L4_Code],[L4_Name],[L4_Rate],[CDate],[User_Id])
Select   	      [L4_Code],[L4_Name],[L4_Rate],[CDate],[User_Id]  From EASYWAY.dbo.tb_Link4
Select * From EASYWAY.dbo.tb_Link4

--Delete From tb_Link5
--Select * From tb_Link5
Insert Into tb_Link5 ([L5_Code],[L5_Name],[L5_Rate],[CDate],[User_Id])
Select   	      [L5_Code],[L5_Name],[L5_Rate],[CDate],[User_Id]  From EASYWAY.dbo.tb_Link5
Select * From EASYWAY.dbo.tb_Link5

--Delete From tb_Link6
--Select * From tb_Link6
Insert Into tb_Link6 ([L6_Code],[L6_Name],[L6_Rate],[CDate],[User_Id])
Select   	      [L6_Code],[L6_Name],[L6_Rate],[CDate],[User_Id]  From EASYWAY.dbo.tb_Link6
Select * From EASYWAY.dbo.tb_Link6

--Delete From tb_Link7
--Select * From tb_Link7
Insert Into tb_Link7 ([L7_Code],[L7_Name],[L7_Rate],[CDate],[User_Id])
Select   	      [L7_Code],[L7_Name],[L7_Rate],[CDate],[User_Id]  From EASYWAY.dbo.tb_Link7
Select * From EASYWAY.dbo.tb_Link7
*** tb_Item ***

--Delete From tb_Item
Select * From tb_Item
Insert Into tb_Item ( Item_Code, Ref_Code, Barcode, Inv_Descrip, Descrip, SinhalaDescrip, Cat_Code, SubCat_Code, L1_Code, L2_Code, L3_Code, L4_Code, L5_Code, L6_Code, L7_Code, Supp_Code, Pack_Size, 
                         W_Margine, R_Margine, PUnit, EUnit, Tax1, MaxPrice, Tax2, Tax3, Countable, Use_Exp, ConvertFact, ConvertFactUnit, Consign, OpenPrice, isCombined, isTaxApply, isNbtApply, ComRate, Intergration_Upload, 
                         ItemType, AutoSerial, QrCodeDescrip)
select  Item_Code, Ref_Code, Barcode, Inv_Descrip, Descrip, '', Cat_Code, SubCat_Code, L1_Code, L2_Code, L3_Code, L4_Code, '', '', '', Supp_Code, Pack_Size, 
                         W_Margine, R_Margine, PUnit, EUnit, Tax1, 0.00, Tax2, Tax3, Countable, Use_Exp, ConvertFact, ConvertFactUnit, Consign, OpenPrice, 0, 0, 0, ComRate, 0, 
                         ItemType, 0, ''
 From EASYWAY.dbo.tb_Item 
 
 Select * From EASYWAY.dbo.tb_Item


*** tb_ItemDet ***

--Delete From tb_ItemDet
Select * From tb_ItemDet

select * from tb_ItemDet
select * From EASYWAY.dbo.tb_ItemDet Where Loca_Code = '01' 


Insert Into tb_ItemDet(Item_Code, Loca_Code, PRet_Price, PWhole_Price, PSp_Price, ERet_Price, EWhole_Price, ESp_Price, Cost_Price, AvgCost, Cost_Code, Lock_S, Lock_P, NoDiscount, Re_Qty, Rol, Qty, User_Id, CDate, 
                         EditDate, BinNo, SPQ, SPR, TPQ, TPR, FPQ, FPR, FIPQ, FIPR, SIPQ, SIPR, SEPQ, SEPR, EIPQ, EIPR, Commission, SPHSQ, SPHSR, TPHSQ, TPHSR, FPHSQ, FPHSR, FIPHSQ, FIPHSR, SIPHSQ, SIPHSR, SEPHSQ, 
                         SEPHSR, EIPHSQ, EIPHSR, C_Price)
Select Item_Code, '99', PRet_Price, PWhole_Price, PSp_Price, ERet_Price, EWhole_Price, ESp_Price, Cost_Price, AvgCost, Cost_Code, Lock_S, Lock_P, NoDiscount, Re_Qty, Rol, Qty, User_Id, CDate, 
                         EditDate, BinNo, SPQ, SPR, TPQ, TPR, FPQ, FPR, FIPQ, FIPR, SIPQ, SIPR, SEPQ, SEPR, EIPQ, EIPR, 0.00, 0.0000, 0.00, 0.0000, 0.00, 0.0000, 0.00, 0.0000, 0.00, 0.0000, 0.00, 0.0000, 
                         0.00, 0000, 0.00, 000 From EASYWAY.dbo.tb_ItemDet Where Loca_Code = '99' 


 Select * From EASYWAY.dbo.tb_Itemdet

*****
select * from [tb_SearchItem]
DELETE from [tb_SearchItem]

 INSERT INTO [tb_SearchItem]
           ([Item_Code]           ,[Description]           ,[RefCode]           ,[BarCode]
           ,[Pack]           ,[Cost]           ,[Rate]           ,[Qty]           ,[Ref]
           ,[SupplierCode]           ,[SupplierName]           ,[CategoryCode]           ,[CategoryName]
           ,[SubCategoryCode]           ,[SubCategoryName]           ,[Binno]           ,[Status]           ,[CrDate])
    
     select tb_Item.Item_Code ,tb_Item.Descrip,tb_Item.Ref_Code,tb_Item.Barcode,
			tb_Item.Pack_Size ,tb_ItemDet.Cost_Price,tb_ItemDet.ERet_Price,tb_ItemDet.qty,tb_Item.Ref_Code
			,tb_Item.Supp_Code,tb_Supplier.Supp_Name,tb_Item.Cat_Code,tb_Category.Cat_Name,
			tb_Item.SubCat_Code,tb_SubCategory.SubCat_Name,tb_ItemDet.BinNo,1,tb_ItemDet.CDate
     from tb_Item inner join tb_ItemDet on tb_Item.Item_Code = tb_ItemDet.Item_Code
     inner join tb_Supplier on tb_Item.supp_code= tb_Supplier.Supp_Code
     inner join tb_Category on tb_Item.Cat_Code = tb_Category.Cat_Code
     inner join tb_SubCategory on tb_Item.SubCat_Code = tb_SubCategory.SubCat_Code
     where tb_ItemDet.Loca_Code='01'



*** tb_Stock ***

--Delete From tb_Stock
--Select * From tb_Stock
Insert Into tb_Stock (SerialNo, LocaCode, RefNo, PDate, SuppCode, RepCode, TourCode, ItemCode, ExpDate, BatchNo, BarcodeSerial, Scale, PackSize, Qty, Balance, Rate, RetPrice, Cost, RealCost, Type, ID, CrDate, 
                         Status, IType, PosUnit, CSCode, CSName, UnitNo, zno, Receipt, Upd)
Select                SerialNo, LocaCode, RefNo, PDate, SuppCode, RepCode, TourCode, ItemCode, ExpDate, BatchNo, '', Scale, PackSize, Qty, Balance, Rate, NULL, Cost, RealCost, Type, ID, CrDate, 
                         Status, IType, PosUnit, '', '', NULL, NULL, NULL, Upd From EASYWAY.dbo.tb_Stock Where LocaCode = '01' and Status='1'
                            and ItemCode <>'32' and ItemCode <>'14044850' and ItemCode <>'10002095' and ItemCode <>'14044919'

Select * From tb_Stock
Select * From EASYWAY.dbo.tb_Stock
*** tb_PriceChange ***

--Delete From tb_PriceChange
--Select * From tb_PriceChange


Insert Into tb_PriceChange (ItemCode, ItemDescrip, LocaCode, SuppCode, Qty, PackSize, CostPrice, ERetPrice, PRetPrice, EWholePrice, PWholePrice, NewCostPrice, NewERetPrice, NewPRetPrice, NewEWholePrice, 
                         NewPWholePrice, CDate, UserName, CType, CDatetime, Status, AvgCost, NewAvgCost, CSCode, CSName) 
Select                      ItemCode, ItemDescrip, LocaCode, SuppCode, Qty, PackSize, CostPrice, ERetPrice, PRetPrice, EWholePrice, PWholePrice, NewCostPrice, NewERetPrice, NewPRetPrice, NewEWholePrice, 
                         NewPWholePrice, CDate, UserName, CType, CDatetime, Status, AvgCost, NewAvgCost, '', '' From EASYWAY.dbo.tb_PriceChange


Select * From tb_PriceChange
Select * From EASYWAY.dbo.tb_PriceChange


*** tb_Salesrep ***

--Delete From tb_Salesrep
--Select * From tb_Salesrep
Insert Into tb_Salesrep ([Rep_Code],[Rep_Name],[Contact_Name],[Contact_No],[Address1],[Address2],[Address3]
,[Country],[Phone1],[Phone2],[Phone3],[Fax],[Email],[Web_Site],[CommRate],[TargetAmt],[Rep],[CDate],[State],[User_Id],[reading],[locacode],[Log])
Select  [Rep_Code],[Rep_Name],[Contact_Name],[Contact_No],[Address1],[Address2],[Address3]
,[Country],[Phone1],[Phone2],[Phone3],[Fax],[Email],[Web_Site],[CommRate],[TargetAmt],[Rep],[CDate],[State],[User_Id],0,'01',0 From EASYWAY.dbo.tb_Salesrep


Select * From tb_Salesrep
Select * From EASYWAY.dbo.tb_Salesrep
----------------------------

*** tb_Customer ***

--Delete From tb_Customer
--Select * From tb_Customer
Insert Into tb_Customer ([Cust_Code],[Cust_Name],[Contact_Name],[Contact_No],[Address1],[Address2],[Address3],[Region]
,[Country],[Phone1],[Phone2],[Phone3],[Fax],[Email],[Web_Site],[CreditLimit],[CreditPeriod],[Route],[CDate],[State],[User_Id]
,[Balance],[AccBalance],[PriceStat],[OverDraft],[Download],[Discount],[type],[intergration_upload],[loyaltycustcode])
Select  [Cust_Code],[Cust_Name],[Contact_Name],[Contact_No],[Address1],[Address2],[Address3],[Region]
,[Country],[Phone1],[Phone2],[Phone3],[Fax],[Email],[Web_Site],[CreditLimit],[CreditPeriod],[Route],[CDate],[State],[User_Id]
,[Balance],[AccBalance],[PriceStat],[OverDraft],[Download],[Discount],[type],[intergration_upload],[loyaltycustcode] From EASYWAY.dbo.tb_Customer

Select * From tb_Customer
Select * From EASYWAY.dbo.tb_Customer

UPDATE tb_Customer SET salesRep =0,EditDate='2023-07-31 22:00:32.120' 



*** tb_PriceLink ***

--Delete From tb_PriceLink
Select * From tb_PriceLink
Select * From EASYWAY.dbo.tb_PriceLink


Insert Into tb_PriceLink ([ItemCode],[Loca],[Inv_Descrip],[Price],[EWholePrice],[PRetPrice],[PWholePrice],[PackSize],[CostPrice],[CreateDate],[CreateBy],[DeleteDate],[DeleteBy],[Status]) 
Select 			  [ItemCode],[Loca],[Inv_Descrip],[Price],[EWholePrice],[PRetPrice],[PWholePrice],[PackSize],[CostPrice],[CreateDate],[CreateBy],     ''     ,    ''    ,[Status]  From EASYWAY.dbo.tb_PriceLink WHERE Status='1'


****tb_priceLink *****

SELECT * FROM tb_PluLink

insert into tb_PluLink  (ItemCode, LinkCode, CreateDate, CreateUser, DeleteDate, DeleteUser, Status)
select 
                          ItemCode, LinkCode, CreateDate, CreateUser, DeleteDate, DeleteUser, Status
FROM   EASYWAY.dbo.tb_PluLink WHERE Status ='1'


******************** GiftVoucher ************************

-----
SELECT * FROM tb_GiftVoucher 
SELECT *  FROM EASYWAY.dbo.tb_GiftVoucher

INSERT INTO tb_GiftVoucher ( Pfx, Code, VouCode, BookNo, Amount, CDate, CredtedBy, IssueLoca, IssueDate, IssuedBy, Remark, Sal, SalDate, Rec, RecDate, Status, VoucherType)
SELECT 
 Pfx, Code, VouCode, BookNo, Amount, CDate, CredtedBy, IssueLoca, IssueDate, IssuedBy, Remark, Sal, SalDate, Rec, RecDate, Status, '0'
FROM EASYWAY.dbo.tb_GiftVoucher

SELECT * FROM tb_GiftVoucherSale
SELECT * FROM   EASYWAY.dbo.tb_GiftVoucherSale

INSERT INTO tb_GiftVoucherSale ( VouCode, Loca, SDate, UnitNo, ZNo, Receipt, Cashier, Id, Status, TrnsDate, Amount, Discount, Upload)

SELECT 
 VouCode, Loca, SDate, UnitNo, ZNo, Receipt, Cashier, Id, Status, TrnsDate, Amount, Discount, ''
FROM            EASYWAY.dbo.tb_GiftVoucherSale

---------------------------------------
************ tb_CustomerLoyalty *******

select * from tb_CustomerLoyalty
select * from EASYWAY.dbo.tb_CustomerLoyalty

delete from tb_CustomerLoyalty



insert into tb_CustomerLoyalty (CustCode, SerialNo, CustName, CustCardName, Address1, Address2, Address3, Mobile, Home, Fax, CivilStatus, Gender, Status, Dob, IdNo, PchMode, ClmMode, CardType, City, Occupation, Income,
                          Company, NewYear, Christmas, Ramadan, Vesak, email, web, AcNewArr, AcPromot, AcLoyalty, AcRemind, ByMobile, ByMail, ByPost, ByOffice, AppDate, IssueDate, ReNewDate, Location, SecCode, CreditLimit, 
                         CreditBalance, Points, CreateBy, CreateDate, EditBy, EditDate, LoyaltyType, AnnDate)


SELECT         CustCode, SerialNo, CustName, CustCardName, Address1, Address2, Address3, Mobile, Home, Fax, CivilStatus, Gender, Status, Dob, IdNo, PchMode, ClmMode, CardType, City, Occupation, Income,
                          Company, NewYear, Christmas, Ramadan, Vesak, email, web, AcNewArr, AcPromot, AcLoyalty, AcRemind, ByMobile, ByMail, ByPost, ByOffice, AppDate, IssueDate, ReNewDate, Location, SecCode, CreditLimit, 
                         CreditBalance, Points, CreateBy, CreateDate, EditBy, EditDate, LoyaltyType, '1900-01-01 00:00:00.000'
FROM            EASYWAY.dbo.tb_CustomerLoyalty


----------------------------------------
******************tb_LoyaltyDet ***************
select * from tb_LoyaltyDet
select * from EASYWAY.dbo.tb_LoyaltyDet
DELETE FROM tb_LoyaltyDet

insert into tb_LoyaltyDet (CustCode, CustName, CustType, Sdate, STime, Loca, UnitNo, Zno, Receipt, Cashier, Iid, ClaimType, PurcType, Total, Amount, Rate, Points, TrnsDate, Remark, Download, Upload, ReferenceNo, 
                         InvoiceNo, BFBalance)

SELECT        CustCode, CustName, CustType, Sdate, STime, Loca, UnitNo, Zno, Receipt, Cashier, Iid, ClaimType, PurcType, Total, Amount, Rate, Points, TrnsDate,Remark, NULL, 0, '','',0 
FROM  EASYWAY.dbo.tb_LoyaltyDet


************tb_CustomerRemark *****

--DIZINE tb_CustomerRemark CUSTCODE CHAR (20)--

SELECT * FROM  tb_CustomerRemark
SELECT * FROM  EASYWAY.dbo.tb_CustomerLoyalty WHERE LEN(CustCode)>12

Insert Into tb_CustomerRemark (CustCode,Remark) 
SELECT  CUSTCODE,'INSERT'
FROM            EASYWAY.dbo.tb_CustomerLoyalty


------------------
SELECT * FROM dbo.vw_LoyaltyBal ORDER BY CustCode
SELECT * FROM EASYWAY.DBO.vw_LoyaltyBal ORDER BY CustCode

SELECT SUM(Points) FROM dbo.vw_LoyaltyBal         --3632733.50392389
SELECT SUM(Points) FROM EASYWAY.DBO.vw_LoyaltyBal --3632733.50392389

-------------*****dbo.tbCreditNote*****-----------
SELECT * FROM dbo.tbCreditNote
SELECT DISTINCT Loca  FROM EASYWAY.DBO.tbCreditNote
SELECT *  FROM EASYWAY.DBO.tbCreditNote WHERE Loca ='03'


INSERT INTO tbCreditNote (Loca,CRNote,Receipt,Cashier,UnitNo,SDate,CDate,Amount,Balance,Status,CustCode,CustName,Remark,Type,DebtCret,Upload,PMode,ChqNo,Bank,ChqDate)
SELECT                    Loca,CRNote,Receipt,Cashier,UnitNo,SDate,CDate,Amount,Balance,Status,CustCode,CustName,Remark,Type,DebtCret,Upload,PMode,ChqNo,Bank,ChqDate
FROM         EASYWAY.DBO.tbCreditNote


--------------*****tb_Payment****-------------
SELECT * FROM dbo.tb_Payment
SELECT * FROM EASYWAY.DBO.tb_Payment


INSERT INTO tb_Payment  (ReceiptNo, CustCode, CustName, SerialNo, RefNo, InvoiceDate, GrossAmount, Discount, IDiscount, Tax, Amount, Balance, CreditNote, DebitNote, Id, Status, Type, PMode, ChqNo, 
                      ChqDate, Bank, AccNo, LocaCode, RepCode, UserId, Tr_Date, IType, PayStat, Remark, RetChq, Upload, UnitNo, Intergration_Upload, Nbt, Vat, SetOffDocument, Upd)
                      SELECT 
ReceiptNo, CustCode, CustName, SerialNo, RefNo, InvoiceDate, GrossAmount, Discount, IDiscount, Tax, Amount, Balance, CreditNote, DebitNote, Id, Status, Type, PMode, ChqNo, 
                      ChqDate, Bank, AccNo, LocaCode, RepCode, UserId, Tr_Date, IType, PayStat, Remark, RetChq, Upload, UnitNo, Intergration_Upload, Nbt, Vat, SetOffDocument, 0
FROM         AYURA.DBO.tb_Payment 











