*** tb_Location ***
--Delete From tb_Location
--Select * From tb_Location
Insert Into tb_Location ([Loca_Code],[Loca_Name],[Contact_Name],[Contact_No],[Address1],[Address2],[Address3],[Ref_Code],[Phone1],[Phone2],[Phone3],[Fax],[email],[Web_Site],[CDate],[State],[User_ID],[PNO],[PRNO],[OPB],[L1Name],[L2Name],[L3Name],[L4Name],[Dept_Item],[StkSt],[MLInv],[ActPrl],[PrcPch],[Lac],[ItmAuto],[ItmClr],[ItmMgn],[PchDec],[BId],[MlSrl],[PrintOrg],[MsgPort],[ImagePath],[AutoSrl],[Coloursize],[Colour],[Size],[PCHType],[L5Name],[GROUP_CODE],[L6Name],[L7Name],[decPointCurr],[decPointNum],[decPointGen],[decPointQty],[useColorNSize],[vatPercentage],[expandLinks],[costCodeIsMin],[updateReturnChq],[clearPDCheques],[allowNonSupplierItem],[autoSuggest],[autoFilter],[autoUpdate],[priceRounding],[SubCatDepend],[SpPricesOnLocaOnly],[isBackDateInvoice],[costCodeLength],[CostingMethod],[NBT],[VatCalculationMethod],[FontNameForLanguage],[prefixLength],[IsConItemCode],[ProfitMgn],[TogRateChangingMethod],[Ret_Allow_On_Retail_Inv],[ShowCostInRetailInvoice],[FocusingSaveOrSaveAll],[WholeSalePriceInRetailInvoice])
Select			 [Loca_Code],[Loca_Name],[Contact_Name],[Contact_No],[Address1],[Address2],[Address3],[Ref_Code],[Phone1],[Phone2],[Phone3],[Fax],[email],[Web_Site],[CDate],[State],[User_ID],[PNO],[PRNO],[OPB],[L1Name],[L2Name],[L3Name],[L4Name],[Dept_Item],[StkSt],[MLInv],[ActPrl],[PrcPch],[Lac],[ItmAuto],[ItmClr],[ItmMgn],[PchDec],[BId],[MlSrl],[PrintOrg],[MsgPort],[ImagePath],			0			,		1,'Colour','Size',	0,'---------',		1,		'---------','---------',2,			3,				3,			3,				1,				0,				0,			0,				0,					0,				1,						1,				1,			1,			0,				1,				0,					0,					2,				0,			0.000000,		3,					'Bamini',			0,				0,				4,			1,						1,						1,							0,								0 From DEPTEX.dbo.tb_Location where Loca_Code='01'
Select * From tb_Location
Select * From TEST.dbo.tb_Location
Select * From DEPTEX.dbo.tb_Location

--Delete From tb_Category
--Select * From tb_Category
Insert Into tb_Category([Cat_Code],[Cat_Name],[Cat_Rate],[CDate],[User_Id])
Select  		[Cat_Code],[Cat_Name],[Cat_Rate],[CDate],[User_Id] From DEPTEX.dbo.tb_Category
select * from DEPTEX.dbo.tb_Category
*** tb_SubCategory ***

--Delete From tb_SubCategory
--Select * From tb_SubCategory
Insert Into tb_SubCategory([Cat_Code],[SubCat_Code],[SubCat_Name],[CDate],[User_Id],[Cat_Rate])
Select 			   [Cat_Code],[SubCat_Code],[SubCat_Name],[CDate],[User_Id],0.00 From DEPTEX.dbo.tb_SubCategory
select * from DEPTEX.dbo.tb_SubCategory
Select * From TEST.dbo.tb_SubCategory
*** tb_Supplier ***

--Delete From tb_Supplier
--Select * From tb_Supplier
Insert Into tb_Supplier ([Supp_Code],[Supp_Name],[Contact_Name],[Contact_No],[Address1],[Address2],[Address3],[Country],[Phone1],[Phone2],[Phone3],[Fax],[Email],[Web_Site],[CDate],[Status],[User_Id],[Download],[AccNo],[Branch],[credit_period],[cat_rate],[EditDate],[LeadTime],[CountryCode])
Select 			 [Supp_Code],[Supp_Name],[Contact_Name],[Contact_No],[Address1],[Address2],[Address3],[Country],[Phone1],[Phone2],[Phone3],[Fax],[Email],[Web_Site],[CDate],[Status],[User_Id],				'F'    ,   ''  ,   '' ,30,				0.00,		GETDATE(),	0,			01   From DEPTEX.dbo.tb_Supplier 
select * from DEPTEX.dbo.tb_Supplier
Select * From TEST.dbo.tb_Supplier
*** tb_Link1 ***

--Delete From tb_Link1
--Select * From tb_Link1
Insert Into tb_Link1 ([L1_Code],[L1_Name],[L1_Rate],[CDate],[User_Id],[color_name],[color_code],[Printer_name])
Select  	      [L1_Code],[L1_Name],[L1_Rate],[CDate],[User_Id],[color_name],[color_code],[Printer_name]  From DEPTEX.dbo.tb_Link1

Select * From DEPTEX.dbo.tb_Link1

*** tb_Link2 ***

--Delete From tb_Link2
--Select * From tb_Link2
Insert Into tb_Link2 ([L2_Code],[L2_Name],[L2_Rate],[CDate],[User_Id])
Select  	      [L2_Code],[L2_Name],[L2_Rate],[CDate],[User_Id]  From DEPTEX.dbo.tb_Link2
Select * From DEPTEX.dbo.tb_Link2
*** tb_Link3 ***

--Delete From tb_Link3
--Select * From tb_Link3
Insert Into tb_Link3 ([L3_Code],[L3_Name],[L3_Rate],[CDate],[User_Id])
Select   	      [L3_Code],[L3_Name],[L3_Rate],[CDate],[User_Id]  From DEPTEX.dbo.tb_Link3
Select * From DEPTEX.dbo.tb_Link3
*** tb_Link4 ***

--Delete From tb_Link4
--Select * From tb_Link4
Insert Into tb_Link4 ([L4_Code],[L4_Name],[L4_Rate],[CDate],[User_Id])
Select   	      [L4_Code],[L4_Name],[L4_Rate],[CDate],[User_Id]  From DEPTEX.dbo.tb_Link4
Select * From DEPTEX.dbo.tb_Link4

--Delete From tb_Link5
--Select * From tb_Link5
Insert Into tb_Link5 ([L5_Code],[L5_Name],[L5_Rate],[CDate],[User_Id])
Select   	      [L5_Code],[L5_Name],[L5_Rate],[CDate],[User_Id]  From DEPTEX.dbo.tb_Link5
Select * From DEPTEX.dbo.tb_Link5

--Delete From tb_Link6
--Select * From tb_Link6
Insert Into tb_Link6 ([L6_Code],[L6_Name],[L6_Rate],[CDate],[User_Id])
Select   	      [L6_Code],[L6_Name],[L6_Rate],[CDate],[User_Id]  From DEPTEX.dbo.tb_Link6
Select * From DEPTEX.dbo.tb_Link6

--Delete From tb_Link7
--Select * From tb_Link7
Insert Into tb_Link7 ([L7_Code],[L7_Name],[L7_Rate],[CDate],[User_Id])
Select   	      [L7_Code],[L7_Name],[L7_Rate],[CDate],[User_Id]  From DEPTEX.dbo.tb_Link7
Select * From DEPTEX.dbo.tb_Link7
*** tb_Item ***

--Delete From tb_Item
--Select * From tb_Item
Insert Into tb_Item ([Item_Code],[Ref_Code],[Barcode],[Inv_Descrip],[Descrip],[Cat_Code],[SubCat_Code],[L1_Code]
,[L2_Code],[L3_Code],[L4_Code],[L5_Code],[L6_Code],[L7_Code],[Supp_Code],[Pack_Size],[W_Margine],[R_Margine],[PUnit],[EUnit],[Tax1],[MaxPrice],[Tax2],[Tax3],[Countable]
,[Use_Exp],[ConvertFact],[ConvertFactUnit],[Consign],[OpenPrice],[isCombined],[isTaxApply],[isNbtApply],[ComRate],[Intergration_Upload],[ItemType],[AutoSerial],[QrCodeDescrip])
select [Item_Code],[Ref_Code],[Barcode],[Inv_Descrip],[Descrip],[Cat_Code],[SubCat_Code],[L1_Code]
,[L2_Code],[L3_Code],[L4_Code],	'',			'',		'',[Supp_Code],[Pack_Size],[W_Margine],[R_Margine],[PUnit],[EUnit],[Tax1],			0.00,[Tax2],[Tax3],[Countable]
,[Use_Exp],[ConvertFact],[ConvertFactUnit],[Consign],[OpenPrice],	0,			0,			0,			1,			0,					0,			0,			''
 From DEPTEX.dbo.tb_Item
 
 Select * From TEST.dbo.tb_Item
 Select * From DEPTEX.dbo.tb_Item


*** tb_ItemDet ***

--Delete From tb_ItemDet
--Select * From tb_ItemDet
Insert Into tb_ItemDet([Item_Code],[Loca_Code],[PRet_Price],[PWhole_Price],[PSp_Price],[ERet_Price],[EWhole_Price]
,[ESp_Price],[Cost_Price],[Cost_Code],[Lock_S],[Lock_P],[Re_Qty],[Rol],[Qty],[User_Id],[CDate],[EditDate],[BinNo]
,[NoDiscount],[SPQ],[SPR],[TPQ],[TPR],[FPQ],[FPR],[FIPQ],[FIPR],[SIPQ],[SIPR],[SEPQ],[SEPR],[EIPQ],[EIPR],[Commission],[SPHSQ],[SPHSR],[TPHSQ],[TPHSR],[FPHSQ],[FPHSR],[SIPHSQ],[SEPHSR],[EIPHSQ],[EIPHSR],[C_Price])
Select[Item_Code],[Loca_Code],[PRet_Price],[PWhole_Price],[PSp_Price],[ERet_Price],[EWhole_Price]
,[ESp_Price],[Cost_Price],[Cost_Code],[Lock_S],[Lock_P],[Re_Qty],[Rol],[Qty],[User_Id],[CDate],[EditDate],[BinNo]
,[NoDiscount],[SPQ],[SPR],[TPQ],[TPR],[FPQ],[FPR],[FIPQ],[FIPR],[SIPQ],[SIPR],[SEPQ],[SEPR],[EIPQ],[EIPR],0.00		,	0.0000,	0.00,	0.0000,	0.00,	0.0000,	0.00,	0.0000,	0.00,	0.0000,		0.00,	0.00 From DEPTEX.dbo.tb_ItemDet Where Loca_Code = '01'
 
 Select * From DEPTEX.dbo.tb_Itemdet

  Select * From TEST.dbo.tb_ItemDet
*** tb_Stock ***

--Delete From tb_Stock
--Select * From tb_Stock
Insert Into tb_Stock ([SerialNo],[LocaCode],[RefNo],[PDate],[SuppCode],[RepCode],[TourCode],[ItemCode],[ExpDate],[BatchNo],[BarcodeSerial],[Scale],[PackSize]
,[Qty],[Balance],[Rate],[Cost],[RealCost],[Type],[ID],[CrDate],[Status],[IType],[PosUnit],[cscode],[csname],[unitno],[Zno],[receipt])
Select [SerialNo],[LocaCode],[RefNo],[PDate],[SuppCode],[RepCode],[TourCode],[ItemCode],[Scale],[PackSize]
,[Qty],[Balance],[Rate],[Cost],[RealCost],[Type],[ID],[CrDate],[Status],[IType],[PosUnit],''	,	'' From DEPTEX.dbo.tb_Stock Where LocaCode = '01'
Select * From tb_Stock
Select * From DEPTEX.dbo.tb_Stock
Select * From TEST.dbo.tb_Stock
*** tb_PriceChange ***

--Delete From tb_PriceChange
--Select * From tb_PriceChange
Insert Into tb_PriceChange ([ItemCode],[ItemDescrip],[LocaCode],[SuppCode],[Qty],[PackSize],[CostPrice],[ERetPrice]
,[PRetPrice],[EWholePrice],[PWholePrice],[NewCostPrice],[NewERetPrice],[NewPRetPrice],[NewEWholePrice],[NewPWholePrice]
,[CDate],[UserName],[CType],[CDatetime],[Status],[avgcost],[newavgcost]) 
Select  [ItemCode],[ItemDescrip],[LocaCode],[SuppCode],[Qty],[PackSize],[CostPrice],[ERetPrice]
,[PRetPrice],[EWholePrice],[PWholePrice],[NewCostPrice],[NewERetPrice],[NewPRetPrice],[NewEWholePrice],[NewPWholePrice]
,[CDate],[UserName],[CType],[CDatetime],[Status],[avgcost],[newavgcost] From DEPTEX.dbo.tb_PriceChange
Select * From tb_PriceChange
Select * From DEPTEX.dbo.tb_PriceChange

Select * From TEST.dbo.tb_PriceChange

*** tb_Customer ***

--Delete From tb_Customer
--Select * From tb_Customer
Insert Into tb_Customer ([Cust_Code],[Cust_Name],[Contact_Name],[Contact_No],[Address1],[Address2],[Address3],[Country],[Region]
,[Phone1],[Phone2],[Phone3],[Fax],[Email],[Web_Site],[CreditLimit],[CreditPeriod],[Route],[CDate],[State],[User_Id]
,[Balance],[AccBalance],[PriceStat],[OverDraft],[Download],[Discount],[type],[intergration_upload],[loyaltycustcode],[EditDate],[salesRep])
Select  [Cust_Code],[Cust_Name],[Contact_Name],[Contact_No],[Address1],[Address2],[Address3],[Region]
,[Country],[Phone1],[Phone2],[Phone3],[Fax],[Email],[Web_Site],[CreditLimit],[CreditPeriod],[Route],[CDate],[State],[User_Id]
,[Balance],[AccBalance],[PriceStat],[OverDraft],[Download],[Discount],0,		0,						'',			GETDATE(),		'001' From DEPTEX.dbo.tb_Customer

Select * From tb_Customer
Select * From DEPTEX.dbo.tb_Customer
Select * From TEST.dbo.tb_Customer
*** tb_Salesrep ***

--Delete From tb_Salesrep
--Select * From tb_Salesrep
Insert Into tb_Salesrep ([Rep_Code],[Rep_Name],[Contact_Name],[Contact_No],[Address1],[Address2],[Address3]
,[Country],[Phone1],[Phone2],[Phone3],[Fax],[Email],[Web_Site],[CommRate],[TargetAmt],[Rep],[CDate],[State],[User_Id],[reading],[locacode],[Log],[levelCode],[Route_Code])
Select  [Rep_Code],[Rep_Name],[Contact_Name],[Contact_No],[Address1],[Address2],[Address3]
,[Country],[Phone1],[Phone2],[Phone3],[Fax],[Email],[Web_Site],[CommRate],[TargetAmt],[Rep],[CDate],[State],[User_Id],		0,		'01'	,0,		'00',		'00' From DEPTEX.dbo.tb_Salesrep
Select * From tb_Salesrep
Select * From DEPTEX.dbo.tb_Salesrep
Select * From TEST.dbo.tb_Salesrep
*** tb_System ***

--Delete From tb_System
--Select * From tb_System
Insert Into tb_System (LocaCode,PNO,PRNO,PORD,INV,INVCR,INVP,IN2,MKR,QUT,AOD,PMT,PMP,OPB,TOG,REP,OUB,DID,CRD,BUND,Advance,pout,giftv,aodr,mrn,dbn,invf,prom,POSTOG,DelNote,ACCTOG,DMNS)
Select     	       LocaCode,PNO,PRNO,PORD,INV,  0  , 0  ,IN2,MKR,QUT,AOD,PMT,PMP,OPB,TOG,REP,OUB,DID,CRD,BUND,Advance,pout,giftv,aodr,mrn,dbn,invf,prom	 From DEPTEX.dbo.tb_System
Select * From tb_System
Select * From DEPTEX.dbo.tb_System
*** tb_InvSumm ***

--Delete From tb_InvSumm
--Select * From tb_InvSumm
Insert Into tb_InvSumm ([SerialNo],[LocaCode],[RefNo],[IDate],[DilDate],[CustCode],[CustName],[RepCode],[RepName],[QutNo],[TourCode],[PType],[PMode],[GAmount],[SubTotDiscount],[Discount],[Disc],[Tax],[NetAmount],[Advance],[PModeAdv],[RetP],[Returns],[Balance],[Id],[Status],[TrDate],[UserName],[Pay1],,[Pay2],[Pay3],[Pay4],[Amt1],[Amt2],[Amt3],[Amt4],[BalPay],[BalAmt],[Rem1],[Rem2],[Rem3],[Rem4],[IType],[TotOuts],[TotPdChq],[TotRtChq],[Print],[Upload],[Intergration_Upload],[VatNo],[IsSusVat],[Recalled],[VehicleNumber],[RefDocument],[WarrantyReferenceNo],[VatP],[InvoiceRemark],[OriginalInvDate],[ChqDate1],[ChqDate2],[ChqDate3],[ChqDate4],[ChqBank1],[ChqBank2],[ChqBank3],[ChqBank4],[Vat],[Nbt],[Upd],[ToDelivery],[NbtP],[ShippingAmount])
Select  		[SerialNo],[LocaCode],[RefNo],[IDate],[DilDate],[CustCode],[CustName],[RepCode],[RepName],[QutNo],[TourCode],[PType],[PMode],[GAmount],[SubTotDiscount],[Discount],[Disc],[Tax],[NetAmount],[Advance],[PModeAdv],[RetP],[Returns],[Balance],[Id],[Status],[TrDate],[UserName],[Pay1],,[Pay2],[Pay3],[Pay4],[Amt1],[Amt2],[Amt3],[Amt4],[BalPay],[BalAmt],[Rem1],[Rem2],[Rem3],[Rem4],[IType],[TotOuts],[TotPdChq],[TotRtChq],[Print],[Upload],[Intergration_Upload],[VatNo],[IsSusVat],[Recalled],[VehicleNumber],[RefDocument],[WarrantyReferenceNo],[VatP],[InvoiceRemark],[OriginalInvDate],[ChqDate1],[ChqDate2],[ChqDate3],[ChqDate4],[ChqBank1],[ChqBank2],[ChqBank3],[ChqBank4],[Vat],[Nbt],[Upd],[ToDelivery],[NbtP],[ShippingAmount]   From DEPTEX.dbo.tb_InvSumm
Select * From tb_InvSumm
Select * From DEPTEX.dbo.tb_InvSumm
*** tb_InvDet ***

--Delete From tb_InvDet
--Select * From tb_InvDet
Insert Into tb_InvDet ([SerialNo],[LocaCode],[RefNo],[CustCode],[ItemCode],[ItemDescrip],[Scale],[Unit],[ItemSerialNo],[Cost],[Rate],[Qty],[GAmount],[Discp],[Discount],[Tax],[NetAmount],[TrDate],[ID],[Status],[LnNo],[PackSize],[IDate],[DiscountForTot],[AodDate],[RepCode],[ConFact],[ConFactUnit],[Rem1],[Rem2],[Rem3],[Upload],[Deal],[Intergration_Upload]
      ,[BarcodeSerial],[CSCode],[CSName],[IsSusVat],[RefSize],[RefQty],[USDRate],[SinhalaDescrip],[Recalled],[Rem4],[Warrenty],[ItemRemark],[Vat],[VatP])
Select	[SerialNo],[LocaCode],[RefNo],[CustCode],[ItemCode],[ItemDescrip],[Scale],[Unit],[ItemSerialNo],[Cost],[Rate],[Qty],[GAmount],[Discp],[Discount],[Tax],[NetAmount],[TrDate],[ID],[Status],[LnNo],[PackSize],[IDate],[DiscountForTot],[AodDate],[RepCode],[ConFact],[ConFactUnit],[Rem1],[Rem2],[Rem3],[Upload],[Deal],[Intergration_Upload]
      ,[BarcodeSerial],[CSCode],[CSName],[IsSusVat],[RefSize],[RefQty],[USDRate],[SinhalaDescrip],[Recalled],[Rem4],[Warrenty],[ItemRemark],[Vat],[VatP]  From DEPTEX.dbo.tb_InvDet
Select * From tb_InvDet
Select * From DEPTEX.dbo.tb_InvDet
-------------------------------------------------------
*** tb_PurSumm ***

--Delete From tb_PurSumm
--Select * From tb_PurSumm
Insert Into tb_PurSumm ([SerialNo],[LocaCode],[RefNo],[PDate],[DilDate],[SuppCode],[SuppName],[PODNo],[PType],[PMode],[GAmount],[Disc],[SubTotDiscount],[Discount],[Tax],[NetAmount],[RefAmount],[Advance],[PModeAdv],[Returns],[Balance],[Id],[Status],[TrDate],[UserName],[Upd])
Select			[SerialNo],[LocaCode],[RefNo],[PDate],[DilDate],[SuppCode],[SuppName],[PODNo],[PType],[PMode],[GAmount],  0   ,[SubTotDiscount],[Discount],[Tax],[NetAmount],[RefAmount],[Advance],[PModeAdv],[Returns],[Balance],[Id],[Status],[TrDate],[UserName], Null  From DEPTEX.dbo.tb_PurSumm[DilDate]

*** tb_PurDet ***

--Delete From tb_PurDet
--Select * From tb_PurDet
Insert Into tb_PurDet ([LnNo],[SerialNo],[LocaCode],[RefNo],[PDate],[SuppCode],[ItemCode],[ItemDescrip],[Scale],[PackSize],[Unit],[Cost],[Rate],[Qty],[Balance],[GAmount],[Discount],[DiscountForTot],[DiscP],[Tax],[NetAmount],[TrDate],[ID],[Status],[ExpDate],[BatchNo],[ERet_Price])
Select		       [LnNo],[SerialNo],[LocaCode],[RefNo],[PDate],[SuppCode],[ItemCode],[ItemDescrip],[Scale],[PackSize],[Unit],[Cost],[Rate],[Qty],[Balance],[GAmount],[Discount],[DiscountForTot],[DiscP],[Tax],[NetAmount],[TrDate],[ID],[Status],[ExpDate],  Null   ,[ERet_Price]  From DEPTEX.dbo.tb_PurDet

*** tb_PurDet ***

--Delete From tb_Payment
--Select * From tb_Payment
Insert Into tb_Payment ([ReceiptNo],[CustCode],[CustName],[SerialNo],[RefNo],[InvoiceDate],[GrossAmount],[Discount],[IDiscount],[Tax],[Amount],[Balance],[CreditNote],[DebitNote],[Id],[Status],[Type],[PMode],[ChqNo],[ChqDate],[Bank],[AccNo],[LocaCode],[RepCode],[UserId],[Tr_Date],[IType],[PayStat],[Remark],[RetChq],[Upload],[UnitNo])
Select			[ReceiptNo],[CustCode],[CustName],[SerialNo],[RefNo],[InvoiceDate],[GrossAmount],[Discount],[IDiscount],[Tax],[Amount],[Balance],[CreditNote],[DebitNote],[Id],[Status],[Type],[PMode],[ChqNo],[ChqDate],[Bank],[AccNo],[LocaCode],[RepCode],[UserId],[Tr_Date],[IType],[PayStat],[Remark],[RetChq],  '0'  ,   ''    From DEPTEX.dbo.tb_Payment

*** tb_PriceLink ***

--Delete From tb_PriceLink
--Select * From tb_PriceLink
Insert Into tb_PriceLink ([ItemCode],[Loca],[Inv_Descrip],[Price],[EWholePrice],[PRetPrice],[PWholePrice],[PackSize],[CostPrice],[CreateDate],[CreateBy],[DeleteDate],[DeleteBy],[Status]) 
Select 			  [ItemCode],[Loca],[Inv_Descrip],[Price],[EWholePrice],[PRetPrice],[PWholePrice],[PackSize],[CostPrice],[CreateDate],[CreateBy],     ''     ,    ''    ,[Status]  From DEPTEX.dbo.tb_PriceLink

*** tb_StAdjSumm ***

--Delete From tb_StAdjSumm
--Select * From tb_StAdjSumm
Insert Into tb_StAdjSumm ([SerialNo],[LocaCode],[RefNo],[IDate],[CostValue],[RetValue],[Id],[Type],[Status],[TrDate],[UserName])
Select 			  [SerialNo],[LocaCode],[RefNo],[IDate],[CostValue],[RetValue],[Id],[Type],[Status],[TrDate],[UserName]  From DEPTEX.dbo.tb_StAdjSumm

*** tb_StAdjDet ***

--Delete From tb_StAdjDet
--Select * From tb_StAdjDet
Insert Into tb_StAdjDet	([LnNo],[SerialNo],[LocaCode],[IDate],[RefNo],[SuppCode],[ItemCode],[ItemDescrip],[Scale],[PackSize],[Cost],[Rate],[Qty],[CostValue],[RetValue],[TrDate],[ID],[Remark],[Status],[ExpDate],[BatchNo])
Select 			 [LnNo],[SerialNo],[LocaCode],[IDate],[RefNo],[SuppCode],[ItemCode],[ItemDescrip],[Scale],[PackSize],[Cost],[Rate],[Qty],[CostValue],[RetValue],[TrDate],[ID],[Remark],[Status],[ExpDate],[BatchNo] From DEPTEX.dbo.tb_StAdjDet

*** tbPosTransact ***

--Delete From tbPosTransact
--Select * From tbPosTransact
Insert Into tbPosTransact ([ItemCode],[RefCode],[Descrip],[Cost],[Price],[Qty],[Amount],[IDI1],[IDis1],[IDiscount1],[IDI2],[IDis2],[IDiscount2],[IDI3],[IDis3],[IDiscount3],[IDI4],[IDis4],[IDiscount4],[IDI5],[IDis5],[IDiscount5],[Rate],[SDStat],[SDNo],[SDID],[SDIs],[SDiscount],[Tax],[Nett],[Loca],[IId],[Receipt],[Salesman],[Cust],[Cashier],[StartTime],[EndTime],[RecDate],[BillType],[Unit],[UnitNo],[RowNo],[CDate],[Status],[UpdateBy],[RecallStat],[SaleType],[RecallNo],[Pcs],[Invoice],[TrType],[Upload],[ZNo],[Insertdate],[PriceLevel],[Did],[Serial],[PackSize],[InvSerial],[ExpDate],[ItemType],[ConFact],[PackScale])
Select			   [ItemCode],[RefCode],[Descrip],[Cost],[Price],[Qty],[Amount],[IDI1],[IDis1],[IDiscount1],[IDI2],[IDis2],[IDiscount2],[IDI3],[IDis3],[IDiscount3],[IDI4],[IDis4],[IDiscount4],[IDI5],[IDis5],[IDiscount5],[Rate],[SDStat],[SDNo],[SDID],[SDIs],[SDiscount],[Tax],[Nett],[Loca],[IId],[Receipt],[Salesman],[Cust],[Cashier],[StartTime],[EndTime],[RecDate],[BillType],[Unit],[UnitNo],[RowNo],[CDate],[Status],[UpdateBy],[RecallStat],[SaleType],[RecallNo],[Pcs],[Invoice],[TrType],[Upload],[ZNo],[Insertdate],[PriceLevel],[Did],[Serial],[PackSize],[InvSerial],    ''   ,    0     ,    1    ,     1	   From DEPTEX.dbo.tbPosTransact

*** tbPosTransactSum ***

--Delete From tbPosTransactSum
--Select * From tbPosTransactSum
Insert Into tbPosTransactSum ([ItemCode],[RefCode],[Descrip],[Cost],[Price],[Qty],[Amount],[IDI1],[IDis1],[IDiscount1],[IDI2],[IDis2],[IDiscount2],[IDI3],[IDis3],[IDiscount3],[IDI4],[IDis4],[IDiscount4],[IDI5],[IDis5],[IDiscount5],[Rate],[SDStat],[SDNo],[SDID],[SDIs],[SDiscount],[Tax],[Nett],[Loca],[IId],[Receipt],[Salesman],[Cust],[Cashier],[StartTime],[EndTime],[RecDate],[BillType],[Unit],[UnitNo],[RowNo],[CDate],[Status],[UpdateBy],[RecallStat],[SaleType],[RecallNo],[Pcs],[TrType],[Upload],[ZNo],[Insertdate],[Invoice],[PriceLevel],[PackSize],[InvSerial],[Serial],[PackScale])
Select			      [ItemCode],[RefCode],[Descrip],[Cost],[Price],[Qty],[Amount],[IDI1],[IDis1],[IDiscount1],[IDI2],[IDis2],[IDiscount2],[IDI3],[IDis3],[IDiscount3],[IDI4],[IDis4],[IDiscount4],[IDI5],[IDis5],[IDiscount5],[Rate],[SDStat],[SDNo],[SDID],[SDIs],[SDiscount],[Tax],[Nett],[Loca],[IId],[Receipt],[Salesman],[Cust],[Cashier],[StartTime],[EndTime],[RecDate],[BillType],[Unit],[UnitNo],[RowNo],[CDate],[Status],[UpdateBy],[RecallStat],[SaleType],[RecallNo],[Pcs],[TrType],[Upload],[ZNo],[Insertdate],[Invoice],[PriceLevel],[PackSize],[InvSerial],[Serial],   0	From DEPTEX.dbo.tbPosTransactSum

*** tbPosPayment ***

--Delete From tbPosPayment
--Select * From tbPosPayment
Insert Into tbPosPayment ([Receipt],[Loca],[UnitNo],[Sdate],[Id],[TypeId],[Amount],[Balance],[Cashier],[PaidAt],[BillType],[SerialNo],[PStatus],[Cust],[CustType],[BankId],[ChequeDate],[UpdateBy],[AdvanceNo],[Invoice],[Upload],[ZNo],[Insertdate],[Did],[PId],[Serial],[CustName],[PaymentNo],[TypeId2],[InvSerial])
Select			  [Receipt],[Loca],[UnitNo],[Sdate],[Id],[TypeId],[Amount],[Balance],[Cashier],[PaidAt],[BillType],[SerialNo],[PStatus],[Cust],[CustType],[BankId],[ChequeDate],[UpdateBy],[AdvanceNo],[Invoice],[Upload],[ZNo],[Insertdate],[Did],[PId],[Serial],[CustName],[PaymentNo],[TypeId2],[InvSerial]  From DEPTEX.dbo.tbPosPayment

*** tbPosPaymentSum ***

--Delete From tbPosPaymentSum
--Select * From tbPosPaymentSum
Insert Into tbPosPaymentSum ([Receipt],[Loca],[UnitNo],[Sdate],[Id],[TypeId],[Amount],[Balance],[Cashier],[PaidAt],[BillType],[SerialNo],[PStatus],[Cust],[CustType],[BankId],[ChequeDate],[UpdateBy],[AdvanceNo],[Upload],[ZNo],[Insertdate],[Invoice],[Crpt],[ClDate],[InvSerial],[Serial],[CustName],[PaymentNo])
Select			     [Receipt],[Loca],[UnitNo],[Sdate],[Id],[TypeId],[Amount],[Balance],[Cashier],[PaidAt],[BillType],[SerialNo],[PStatus],[Cust],[CustType],[BankId],[ChequeDate],[UpdateBy],[AdvanceNo],[Upload],[ZNo],[Insertdate],[Invoice],[Crpt],[ClDate],[InvSerial],[Serial],[CustName],[PaymentNo]  From DEPTEX.dbo.tbPosPaymentSum

*** tb_ACCOUNT_FROM_POS ***

--Delete From tb_ACCOUNT_FROM_POS
--Select * From tb_ACCOUNT_FROM_POS
Insert Into tb_ACCOUNT_FROM_POS ([GRN_NO],[REF_NO],[SuppCode],[GRN_DATE],[AMOUNT],[DISCOUNT],[TAX],[NET_AMOUNT],[GRN_TYPE],[PAYMENT_TYPE],[LOCATION],[TRANSACTION_DATE],[IID],[FromLoca],[ToLoca],[Status],[REF],[Add_Amount],[Ded_Amount],[INVOICE_NO])
Select 				 [GRN_NO],[REF_NO],[SuppCode],[GRN_DATE],[AMOUNT],[DISCOUNT],[TAX],[NET_AMOUNT],[GRN_TYPE],[PAYMENT_TYPE],[LOCATION],[TRANSACTION_DATE],[IID],[FromLoca],[ToLoca],[Status],[REF],[Add_Amount],[Ded_Amount],[INVOICE_NO]  From DEPTEX.dbo.tb_ACCOUNT_FROM_POS

*** tb_AcTransDetails ***

--Delete From tb_AcTransDetails
--Select * From tb_AcTransDetails
Insert Into tb_AcTransDetails ([TrnsType],[LocaCode],[TrDate],[Descrip],[BookNo],[Amount],[Status],[Sdate],[UName],[Author])
Select			       [TrnsType],[LocaCode],[TrDate],[Descrip],[BookNo],[Amount],[Status],[Sdate],[UName],[Author]  From DEPTEX.dbo.tb_AcTransDetails

*** tb_AdjQty ***

--Delete From tb_AdjQty
--Select * From tb_AdjQty
Insert Into tb_AdjQty ([ItemCode],[LocaCode],[Qty],[Id],[Cr_Date])
Select 		       [ItemCode],[LocaCode],[Qty],[Id],[Cr_Date]  From DEPTEX.dbo.tb_AdjQty

*** tb_Age ***

--Delete From tb_Age
--Select * From tb_Age
Insert Into tb_Age ([ItemCode],[LocaCode],[NoDay],[Qty],[LastSold],[CDate])
Select		    [ItemCode],[LocaCode],[NoDay],[Qty],[LastSold],[CDate]  From DEPTEX.dbo.tb_Age

*** tb_AODDet ***

--Delete From tb_AODDet
--Select * From tb_AODDet
Insert Into tb_AODDet ([LnNo],[SerialNo],[LocaCode],[IDate],[RefNo],[CustCode],[SuppCode],[ItemCode],[ItemDescrip],[Scale],[PackSize],[ItemSerialNo],[BatchNo],[Unit],[Cost],[Rate],[Qty],[GAmount],[Discount],[DiscP],[Tax],[NetAmount],[DiscountForTot],[TrDate],[ID],[Status],[ConFact],[ConFactUnit])
Select				   [LnNo],[SerialNo],[LocaCode],[IDate],[RefNo],[CustCode],[SuppCode],[ItemCode],[ItemDescrip],[Scale],[PackSize],[ItemSerialNo],[BatchNo],[Unit],[Cost],[Rate],[Qty],[GAmount],[Discount],[DiscP],[Tax],[NetAmount],[DiscountForTot],[TrDate],[ID],[Status],[ConFact],[ConFactUnit]  From DEPTEX.dbo.tb_AODDet

*** tb_AODQty ***

--Delete From tb_AODQty
--Select * From tb_AODQty
Insert Into tb_AODQty ([ItemCode],[LocaCode],[Qty],[Cr_Date])
Select				   [ItemCode],[LocaCode],[Qty],[Cr_Date]  From DEPTEX.dbo.tb_AODQty

*** tb_AODSumm ***

--Delete From tb_AODSumm
--Select * From tb_AODSumm
Insert Into tb_AODSumm ([SerialNo],[LocaCode],[RefNo],[IDate],[DilDate],[CustCode],[CustName],[RepCode],[RepName],[QutNo],[TourCode],[PType],[PMode],[GAmount],[SubTotDiscount],[Discount],[Tax],[NetAmount],[Advance],[PModeAdv],[Returns],[Balance],[Id],[Status],[TrDate],[UserName],[SetOff])
Select					[SerialNo],[LocaCode],[RefNo],[IDate],[DilDate],[CustCode],[CustName],[RepCode],[RepName],[QutNo],[TourCode],[PType],[PMode],[GAmount],[SubTotDiscount],[Discount],[Tax],[NetAmount],[Advance],[PModeAdv],[Returns],[Balance],[Id],[Status],[TrDate],[UserName],[SetOff]  From DEPTEX.dbo.tb_AODSumm

*** tb_TogDet ***

--Delete From tb_TogDet
--Select * From tb_TogDet
Insert Into tb_TogDet ([LnNo],[SerialNo],[LocaCode],[TDate],[SuppCode],[ItemCode],[ItemDescrip],[Scale],[PackSize],[Unit],[Cost],[Rate],[Qty],[CostValue],[RetValue],[FromLoca],[ToLoca],[TrDate],[ID],[Status],[ExpDate],[BatchNo])
Select				   [LnNo],[SerialNo],[LocaCode],[TDate],[SuppCode],[ItemCode],[ItemDescrip],[Scale],[PackSize],[Unit],[Cost],[Rate],[Qty],[CostValue],[RetValue],[FromLoca],[ToLoca],[TrDate],[ID],[Status],[ExpDate],[BatchNo] From DEPTEX.dbo.tb_TogDet

*** tb_TogSumm ***

--Delete From tb_TogSumm
--Select * From tb_TogSumm
Insert Into tb_TogSumm ([SerialNo],[LocaCode],[RefNo],[TDate],[Type],[DilDate],[FromLoca],[ToLoca],[TotalCostValue],[TotalRetValue],[Id],[Status],[TrDate],[UserName],[RepCode],[RepName],[TourCode])
Select					[SerialNo],[LocaCode],[RefNo],[TDate],[Type],[DilDate],[FromLoca],[ToLoca],[TotalCostValue],[TotalRetValue],[Id],[Status],[TrDate],[UserName],[RepCode],[RepName],[TourCode] From DEPTEX.dbo.tb_TogSumm

*** tb_Balance ***

--Delete From tb_Balance
--Select * From tb_Balance
Insert Into tb_Balance ([LocaCode],[SerialNo],[Id],[ItemCode],[Scale],[PackSize],[Qty],[RefNo],[Remark],[UpdateAt],[ExpDate],[StkType])
Select					[LocaCode],[SerialNo],[Id],[ItemCode],[Scale],[PackSize],[Qty],[RefNo],[Remark],[UpdateAt],[ExpDate],[StkType]   From DEPTEX.dbo.tb_Balance