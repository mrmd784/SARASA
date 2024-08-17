*** tb_Location ***
--Delete From tb_Location
--Select * From tb_Location
Insert Into tb_Location ([Loca_Code],[Loca_Name],[Contact_Name],[Contact_No],[Address1],[Address2],[Address3],[Ref_Code],[Phone1],[Phone2],[Phone3],[Fax],[email],[Web_Site],[CDate],[State],[User_ID],[PNO],[PRNO],[OPB],[L1Name],[L2Name],[L3Name],[L4Name],[Dept_Item],[StkSt],[MLInv],[ActPrl],[PrcPch],[Lac],[ItmAuto],[ItmClr],[ItmMgn],[PchDec],[BId],[MlSrl],[PrintOrg],[MsgPort],[ImagePath],[AutoSrl],[Coloursize],[Colour],[Size],[PCHType],[L5Name],[GROUP_CODE],[L6Name],[L7Name],[decPointCurr],[decPointNum],[decPointGen],[decPointQty],[useColorNSize],[vatPercentage],[expandLinks],[costCodeIsMin],[updateReturnChq],[clearPDCheques],[allowNonSupplierItem],[autoSuggest],[autoFilter],[autoUpdate],[priceRounding],[SubCatDepend],[SpPricesOnLocaOnly],[isBackDateInvoice],[costCodeLength],[CostingMethod],[VatP2])
Select			 [Loca_Code],[Loca_Name],[Contact_Name],[Contact_No],[Address1],[Address2],[Address3],[Ref_Code],[Phone1],[Phone2],[Phone3],[Fax],[email],[Web_Site],[CDate],[State],[User_ID],[PNO],[PRNO],[OPB],[L1Name],[L2Name],[L3Name],[L4Name],[Dept_Item],[StkSt],[MLInv],[ActPrl],[PrcPch],[Lac],[ItmAuto],[ItmClr],[ItmMgn],[PchDec],[BId],[MlSrl],[PrintOrg],[MsgPort],[ImagePath],[AutoSrl],[Coloursize],[Colour],[Size],[PCHType],[L5Name],[GROUP_CODE],[L6Name],[L7Name],[decPointCurr],[decPointNum],[decPointGen],[decPointQty],[useColorNSize],[vatPercentage],[expandLinks],[costCodeIsMin],[updateReturnChq],[clearPDCheques],[allowNonSupplierItem],[autoSuggest],[autoFilter],[autoUpdate],[priceRounding],[SubCatDepend],[SpPricesOnLocaOnly],[isBackDateInvoice],[costCodeLength],[CostingMethod],[VatP2] From PRADEEPP.dbo.tb_Location
Select * From tb_Location
Select * From PRADEEPP.dbo.tb_Location

--Delete From tb_Category
--Select * From tb_Category
Insert Into tb_Category([Cat_Code],[Cat_Name],[Cat_Rate],[CDate],[User_Id])
Select  		[Cat_Code],[Cat_Name],[Cat_Rate],[CDate],[User_Id] From PRADEEPP.dbo.tb_Category
select * from PRADEEPP.dbo.tb_Category
*** tb_SubCategory ***

--Delete From tb_SubCategory
--Select * From tb_SubCategory
Insert Into tb_SubCategory([Cat_Code],[SubCat_Code],[SubCat_Name],[CDate],[User_Id],[Cat_Rate])
Select 			   [Cat_Code],[SubCat_Code],[SubCat_Name],[CDate],[User_Id],0 From PRADEEPP.dbo.tb_SubCategory
select * from PRADEEPP.dbo.tb_SubCategory
*** tb_Supplier ***

--Delete From tb_Supplier
--Select * From tb_Supplier
Insert Into tb_Supplier ([Supp_Code],[Supp_Name],[Contact_Name],[Contact_No],[Address1],[Address2],[Address3],[Country],[Phone1],
[Phone2],[Phone3],[Fax],[Email],[Web_Site],[CDate],[Status],[User_Id],[Download],[AccNo],[Branch],[credit_period],[updateitem],
[cat_rate],[EditDate])--,[LeadTime],[CountryCode])

Select 			 [Supp_Code],[Supp_Name],[Contact_Name],[Contact_No],[Address1],[Address2],[Address3],[Country],[Phone1],
[Phone2],[Phone3],[Fax],[Email],[Web_Site],[CDate],[Status],[User_Id],    ''    ,   ''  ,   '' ,0,'',
0,'2022-08-13'   From PRADEEPP.dbo.tb_Supplier 

delete from PRADEEPP.dbo.tb_Supplier where  supp_code=''
update tb_Supplier set CountryCode='0'
*** tb_Link1 ***

--Delete From tb_Link1
--Select * From tb_Link1
--Insert Into tb_Link1 ([L1_Code],[L1_Name],[L1_Rate],[CDate],[User_Id],[color_name],[color_code],[Printer_name])
--Select  	      [L1_Code],[L1_Name],[L1_Rate],[CDate],[User_Id],'','',''  From PRADEEPP.dbo.tb_Link1

--Select * From PRADEEPP.dbo.tb_Link1

*** tb_Link2 ***

--Delete From tb_Link2
--Select * From tb_Link2
--Insert Into tb_Link2 ([L2_Code],[L2_Name],[L2_Rate],[CDate],[User_Id])
--Select  	      [L2_Code],[L2_Name],[L2_Rate],[CDate],[User_Id]  From PRADEEPP.dbo.tb_Link2
--Select * From PRADEEPP.dbo.tb_Link2
*** tb_Link3 ***

--Delete From tb_Link3
--Select * From tb_Link3
--Insert Into tb_Link3 ([L3_Code],[L3_Name],[L3_Rate],[CDate],[User_Id])
--Select   	      [L3_Code],[L3_Name],[L3_Rate],[CDate],[User_Id]  From PRADEEPP.dbo.tb_Link3
--Select * From PRADEEPP.dbo.tb_Link3
*** tb_Link4 ***

--Delete From tb_Link4
--Select * From tb_Link4
--Insert Into tb_Link4 ([L4_Code],[L4_Name],[L4_Rate],[CDate],[User_Id])
--Select   	      [L4_Code],[L4_Name],[L4_Rate],[CDate],[User_Id]  From PRADEEPP.dbo.tb_Link4
--Select * From PRADEEPP.dbo.tb_Link4

--Delete From tb_Link5
--Select * From tb_Link5
--Insert Into tb_Link5 ([L5_Code],[L5_Name],[L5_Rate],[CDate],[User_Id])
--Select   	      [L5_Code],[L5_Name],[L5_Rate],[CDate],[User_Id]  From PRADEEPP.dbo.tb_Link5
--Select * From PRADEEPP.dbo.tb_Link5

--Delete From tb_Link6
--Select * From tb_Link6
--Insert Into tb_Link6 ([L6_Code],[L6_Name],[L6_Rate],[CDate],[User_Id])
--Select   	      [L6_Code],[L6_Name],[L6_Rate],[CDate],[User_Id]  From PRADEEPP.dbo.tb_Link6
--Select * From PRADEEPP.dbo.tb_Link6

--Delete From tb_Link7
--Select * From tb_Link7
--Insert Into tb_Link7 ([L7_Code],[L7_Name],[L7_Rate],[CDate],[User_Id])
--Select   	      [L7_Code],[L7_Name],[L7_Rate],[CDate],[User_Id]  From PRADEEPP.dbo.tb_Link7
--Select * From PRADEEPP.dbo.tb_Link7
*** tb_Item ***

--Delete From tb_Item
--Select * From tb_Item
Insert Into tb_Item ([Item_Code],[Ref_Code],[Barcode],[Inv_Descrip],[Descrip],[Cat_Code],[SubCat_Code],[L1_Code]
,[L2_Code],[L3_Code],[L4_Code],[L5_Code],[L6_Code],[L7_Code],[Supp_Code],[Pack_Size],[W_Margine],[R_Margine],
[PUnit],[EUnit],[Tax1],[Tax2],[Tax3],[Countable],[Use_Exp],[ComRate],[ItemType],[ConvertFact],[ConvertFactUnit],
[Consign],[OpenPrice],[AutoSerial],[isCombined],[isTaxApply],[Intergration_Upload],[QrCodeDescrip],[isNbtApply])

select [Item_Code],[Ref_Code],[Barcode],[Inv_Descrip],[Descrip],[Cat_Code],[SubCat_Code],[L1_Code]
,[L2_Code],[L3_Code],[L4_Code],'','','',[Supp_Code],[Pack_Size],[W_Margine],[R_Margine],[PUnit],[EUnit],[Tax1],[Tax2],[Tax3],[Countable]
,[Use_Exp],[ComRate],[ItemType],[ConvertFact],[ConvertFactUnit],[Consign],[OpenPrice],'','','','','',0
 From PRADEEPP.dbo.tb_Item
 
 select * from tb_item
 update tb_item set Pack_Size='1'
 update  tb_item set Use_Exp='0'
 
 Select * From PRADEEPP.dbo.tb_Item


*** tb_ItemDet ***

--Delete From tb_ItemDet
--Select * From tb_ItemDet
Insert Into tb_ItemDet([Item_Code],[Loca_Code],[PRet_Price],[PWhole_Price],[PSp_Price],[ERet_Price],[EWhole_Price]
,[ESp_Price],[Cost_Price],[Cost_Code],[Lock_S],[Lock_P],[Re_Qty],[Rol],[Qty],[User_Id],[CDate],[EditDate],[BinNo]
,[NoDiscount],[SPQ],[SPR],[TPQ],[TPR],[FPQ],[FPR],[FIPQ],[FIPR],[SIPQ],[SIPR],[SEPQ],[SEPR],[EIPQ],[EIPR],[Commission])

Select[Item_Code],[Loca_Code],[PRet_Price],[PWhole_Price],[PSp_Price],[ERet_Price],[EWhole_Price]
,[ESp_Price],[Cost_Price],[Cost_Code],[Lock_S],[Lock_P],[Re_Qty],[Rol],[Qty],[User_Id],[CDate],[EditDate],[BinNo]
,[NoDiscount],[SPQ],[SPR],[TPQ],[TPR],[FPQ],[FPR],[FIPQ],[FIPR],[SIPQ],[SIPR],[SEPQ],[SEPR],[EIPQ],[EIPR],0 
From PRADEEPP.dbo.tb_ItemDet Where Loca_Code = '01'
 Select * From PRADEEPP.dbo.tb_Itemdet
*** tb_Stock ***


--Delete From tb_PriceChange
--Select * From tb_PriceChange
Insert Into tb_PriceChange ([ItemCode],[ItemDescrip],[LocaCode],[SuppCode],[Qty],[PackSize],[CostPrice],[ERetPrice]
,[PRetPrice],[EWholePrice],[PWholePrice],[NewCostPrice],[NewERetPrice],[NewPRetPrice],[NewEWholePrice],[NewPWholePrice]
,[CDate],[UserName],[CType],[CDatetime],[Status],[avgcost],[newavgcost],[cscode],[csname]) 
Select  [ItemCode],[ItemDescrip],[LocaCode],[SuppCode],[Qty],'1',[CostPrice],[ERetPrice]
,[PRetPrice],[EWholePrice],[PWholePrice],[NewCostPrice],[NewERetPrice],[NewPRetPrice],[NewEWholePrice],[NewPWholePrice]
,[CDate],[UserName],[CType],[CDatetime],[Status],[avgcost],[newavgcost],'','' From PRADEEPP.dbo.tb_PriceChange
Select * From tb_PriceChange
Select * From PRADEEPP.dbo.tb_PriceChange


*** tb_PriceLink ***

--Delete From tb_PriceLink
--Select * From tb_PriceLink
Insert Into tb_PriceLink ([ItemCode],[Loca],[Inv_Descrip],[Price],[EWholePrice],[PRetPrice],[PWholePrice],[PackSize],[CostPrice],[CreateDate],[CreateBy],[DeleteDate],[DeleteBy],[Status]) 
Select 			  [ItemCode],[Loca],[Inv_Descrip],[Price],[EWholePrice],[PRetPrice],[PWholePrice],[PackSize],[CostPrice],
[CreateDate],[CreateBy],     ''     ,    ''    ,[Status]  From PRADEEPP.dbo.tb_PriceLink


delete from [tb_SearchItem]
INSERT INTO [tb_SearchItem]
           ([Item_Code]           ,[Description]           ,[RefCode]           ,[BarCode]
           ,[Pack]           ,[Cost]           ,[Rate]           ,[Qty]           ,[Ref]
           ,[SupplierCode]           ,[SupplierName]           ,[CategoryCode]           ,[CategoryName]
           ,[SubCategoryCode]           ,[SubCategoryName]           ,[Binno]           ,[Status]           ,[CrDate],[costcode],[useexp],[LocaCode])
    
     select tb_Item.Item_Code ,tb_Item.Descrip,tb_Item.Ref_Code,tb_Item.Barcode,
			tb_Item.Pack_Size ,tb_ItemDet.Cost_Price,tb_ItemDet.ERet_Price,tb_ItemDet.qty,tb_Item.Ref_Code
			,tb_Item.Supp_Code,tb_Supplier.Supp_Name,tb_Item.Cat_Code,tb_Category.Cat_Name,
			tb_Item.SubCat_Code,tb_SubCategory.SubCat_Name,tb_ItemDet.BinNo,1,tb_ItemDet.CDate,'',0,'01'
     from tb_Item inner join tb_ItemDet on tb_Item.Item_Code = tb_ItemDet.Item_Code
     inner join tb_Supplier on tb_Item.supp_code= tb_Supplier.Supp_Code
     inner join tb_Category on tb_Item.Cat_Code = tb_Category.Cat_Code
     inner join tb_SubCategory on tb_Item.SubCat_Code = tb_SubCategory.SubCat_Code
     where tb_ItemDet.Loca_Code='01'






SELECT * FROM tb_PluLink
SELECT * From  PRADEEPP.Dbo.tb_PluLink



Insert Into tb_PluLink  ([ItemCode],[LinkCode],[CreateDate],[CreateUser],[DeleteDate],[DeleteUser],[Status])
Select [ItemCode],[LinkCode],[CreateDate],[CreateUser],[DeleteDate],[DeleteUser],[Status]
 From  PRADEEPP.Dbo.tb_PluLink WHERE [Status]=1 

 select count(itemcode) from	tb_PluLink
 select count(itemcode) From  PRADEEPP.Dbo.tb_PluLink



*** tb_Stock ***

--Delete From tb_Stock
--Select * From tb_Stock
  Insert Into tb_Stock ([SerialNo],[LocaCode],[RefNo],[PDate],[SuppCode],[RepCode],[TourCode],[ItemCode],[Scale],[PackSize],
           [Qty],[Balance],[Rate],[Cost],[RealCost],[Type],[ID],[CrDate],[Status],[IType],[PosUnit]
           ,[cscode],[csname],[unitno],[Zno],[receipt])
     
            Select [SerialNo],[LocaCode],[RefNo],[PDate],[SuppCode],[RepCode],[TourCode],[ItemCode],[Scale],[PackSize]
          ,[Qty],[Balance],[Rate],[Cost],[RealCost],[Type],[ID],[CrDate],[Status],[IType],[PosUnit],'','','','',''
             From PRADEEPP.dbo.tb_Stock  
              Where LocaCode = '01'
              
                               
                               Select * From tb_Stock
                               Select * From PRADEEPP.dbo.tb_Stock


-*** tb_System ***

--Delete From tb_System
--Select * From tb_System
Insert Into tb_System (LocaCode,PNO,PRNO,PORD,INV,INVCR,INVP,IN2,MKR,QUT,AOD,PMT,PMP,OPB,TOG,REP,OUB,DID,CRD,BUND,Advance,
pout,giftv,aodr,mrn,dbn,invf,prom,POSTOG,DelNote,ACCTOG,DMNS)

Select     	           LocaCode,PNO,PRNO,PORD,INV,  0  , 0  ,IN2,MKR,QUT,AOD,PMT,PMP,OPB,TOG,REP,OUB,DID,CRD,BUND,Advance,
0,0,0,0,0,0,0,0,0,0,0	 From PRADEEPP.dbo.tb_System

Select * From tb_System
Select * From PRADEEPP.dbo.tb_System
*** tb_InvSumm ***

select * from tb_Customer
delete from TB_CUSTOMER

INSERT INTO TB_CUSTOMER ( [CUST_CODE],	[COUNTRY],	[CUST_NAME],	[CONTACT_NAME],  	[CONTACT_NO],	[ADDRESS1],
						[ADDRESS2],	[ADDRESS3],	[PHONE1],    	[PHONE2],   		[PHONE3],		[FAX],		
						[EMAIL]	,	[WEB_SITE],	[CDATE],   	[USER_ID],		[CREDITLIMIT],		[CREDITPERIOD],	
						[ROUTE],	[BALANCE],	[ACCBALANCE],	[PRICESTAT],		[OVERDRAFT],		[STATE],		
						[DOWNLOAD],	[DISCOUNT],[type],[LoyaltyCustCode],Region)
Select [CUST_CODE],	[COUNTRY],	[CUST_NAME],	[CONTACT_NAME],  	[CONTACT_NO],	[ADDRESS1],
						[ADDRESS2],	[ADDRESS3],	[PHONE1],    	[PHONE2],   		[PHONE3],		[FAX],		
						[EMAIL]	,	[WEB_SITE],	[CDATE],   	[USER_ID],		[CREDITLIMIT],		[CREDITPERIOD],	
						[ROUTE],	[BALANCE],	[ACCBALANCE],	[PRICESTAT],		[OVERDRAFT],		[STATE],		
						[DOWNLOAD],	[DISCOUNT],[type],[LoyaltyCustCode],Region
						 FROM PRADEEPP.dbo.tb_Customer   
						                                                                                                                      					
INSERT INTO tb_Customer_Rpl( [CUST_CODE],	[COUNTRY],	[CUST_NAME],	[CONTACT_NAME],  	[CONTACT_NO],	[ADDRESS1],
						[ADDRESS2],	[ADDRESS3],	[PHONE1],    	[PHONE2],   		[PHONE3],		[FAX],		
						[EMAIL]	,	[WEB_SITE],	[CDATE],   	[USER_ID],		[CREDITLIMIT],		[CREDITPERIOD],	
						[ROUTE],	[BALANCE],	[ACCBALANCE],	[PRICESTAT],		[OVERDRAFT],		[STATE],		
							[DISCOUNT],[type],[LoyaltyCustCode],Region) 
select  [CUST_CODE],	[COUNTRY],	[CUST_NAME],	[CONTACT_NAME],  	[CONTACT_NO],	[ADDRESS1],
						[ADDRESS2],	[ADDRESS3],	[PHONE1],    	[PHONE2],   		[PHONE3],		[FAX],		
						[EMAIL]	,	[WEB_SITE],	[CDATE],   	[USER_ID],		[CREDITLIMIT],		[CREDITPERIOD],	
						[ROUTE],	[BALANCE],	[ACCBALANCE],	[PRICESTAT],		[OVERDRAFT],		[STATE],		
							[DISCOUNT],[type],[LoyaltyCustCode],Region from TB_CUSTOMER

Select * From PRADEEPP.dbo.tb_InvSumm
--Delete From tb_InvSumm
--Select * From tb_InvSumm
Insert Into tb_InvSumm ([SerialNo],[LocaCode],[RefNo],[IDate],[CustCode],[CustName],[QutNo],[TourCode],[PType],[PMode],[GAmount],[SubTotDiscount],[Tax],[NetAmount],[Advance],[PModeAdv],[Balance],[Id],[Status],[TrDate],[UserName],[Discount],[Returns],[RepCode],[RepName],[TotOuts],[TotPdChq],[TotRtChq],[Print],[Upload],[Intergration_Upload],[VatNo],[IsSusVat],[Recalled],[VehicleNumber],[RefDocument],[WarrantyReferenceNo],[VatP],[InvoiceRemark],[OriginalInvDate],[ChqDate1],[ChqDate2],[ChqDate3],[ChqDate4],[ChqBank1],[ChqBank2],[ChqBank3],[ChqBank4],[Vat])
Select  		[SerialNo],[LocaCode],[RefNo],[IDate],[CustCode],[CustName],[QutNo],[TourCode],[PType],[PMode],[GAmount],[SubTotDiscount],[Tax],[NetAmount],[Advance],[PModeAdv],[Balance],[Id],[Status],[TrDate],[UserName],[Discount],[Returns],[RepCode],[RepName],[TotOuts],[TotPdChq],[TotRtChq],[Print],[Upload],[Intergration_Upload],[VatNo],[IsSusVat],[Recalled],[VehicleNumber],[RefDocument],[WarrantyReferenceNo],[VatP],[InvoiceRemark],[OriginalInvDate],[ChqDate1],[ChqDate2],[ChqDate3],[ChqDate4],[ChqBank1],[ChqBank2],[ChqBank3],[ChqBank4],[Vat]   From PRADEEPP.dbo.tb_InvSumm

Select * From tb_InvSumm
Select * From PRADEEPP.dbo.tb_InvSumm
*** tb_InvDet ***

--Delete From tb_InvDet
--Select * From tb_InvDet
Insert Into tb_InvDet ([SerialNo],[LocaCode],[RefNo],[CustCode],[ItemCode],[ItemDescrip],[Scale],[Unit],[ItemSerialNo],[Cost],[Rate],[Qty],[GAmount],[Discp],[Discount],[Tax],[NetAmount],[TrDate],[ID],[Status],[LnNo],[PackSize],[IDate],[DiscountForTot],[AodDate],[RepCode],[ConFact],[ConFactUnit],[Rem1],[Rem2],[Rem3],[Upload],[Deal],[Intergration_Upload]
      ,[BarcodeSerial],[CSCode],[CSName],[IsSusVat],[RefSize],[RefQty],[USDRate],[SinhalaDescrip],[Recalled],[Rem4],[Warrenty],[ItemRemark],[Vat],[VatP])
Select	[SerialNo],[LocaCode],[RefNo],[CustCode],[ItemCode],[ItemDescrip],[Scale],[Unit],[ItemSerialNo],[Cost],[Rate],[Qty],[GAmount],[Discp],[Discount],[Tax],[NetAmount],[TrDate],[ID],[Status],[LnNo],[PackSize],[IDate],[DiscountForTot],[AodDate],[RepCode],[ConFact],[ConFactUnit],[Rem1],[Rem2],[Rem3],[Upload],[Deal],[Intergration_Upload]
      ,[BarcodeSerial],[CSCode],[CSName],[IsSusVat],[RefSize],[RefQty],[USDRate],[SinhalaDescrip],[Recalled],[Rem4],[Warrenty],[ItemRemark],[Vat],[VatP]  From PRADEEPP.dbo.tb_InvDet

Select * From tb_InvDet
Select * From PRADEEPP.dbo.tb_InvDet
-------------------------------------------------------
*** tb_PurSumm ***

--Delete From tb_PurSumm
--Select * From tb_PurSumm
Insert Into tb_PurSumm ([SerialNo],[LocaCode],[RefNo],[PDate],[DilDate],[SuppCode],[SuppName],[PODNo],[PType],[PMode],[GAmount],[Disc],[SubTotDiscount],[Discount],[Tax],[NetAmount],[RefAmount],[Advance],[PModeAdv],[Returns],[Balance],[Id],[Status],[TrDate],[UserName],[Upd])
Select			[SerialNo],[LocaCode],[RefNo],[PDate],[DilDate],[SuppCode],[SuppName],[PODNo],[PType],[PMode],[GAmount],  0   ,[SubTotDiscount],[Discount],[Tax],[NetAmount],[RefAmount],[Advance],[PModeAdv],[Returns],[Balance],[Id],[Status],[TrDate],[UserName], Null  From PRADEEPP.dbo.tb_PurSumm[DilDate]

*** tb_PurDet ***

--Delete From tb_PurDet
--Select * From tb_PurDet
Insert Into tb_PurDet ([LnNo],[SerialNo],[LocaCode],[RefNo],[PDate],[SuppCode],[ItemCode],[ItemDescrip],[Scale],[PackSize],[Unit],[Cost],[Rate],[Qty],[Balance],[GAmount],[Discount],[DiscountForTot],[DiscP],[Tax],[NetAmount],[TrDate],[ID],[Status],[ExpDate],[BatchNo],[ERet_Price])
Select		       [LnNo],[SerialNo],[LocaCode],[RefNo],[PDate],[SuppCode],[ItemCode],[ItemDescrip],[Scale],[PackSize],[Unit],[Cost],[Rate],[Qty],[Balance],[GAmount],[Discount],[DiscountForTot],[DiscP],[Tax],[NetAmount],[TrDate],[ID],[Status],[ExpDate],  Null   ,[ERet_Price]  From PRADEEPP.dbo.tb_PurDet

*** tb_PurDet ***

--Delete From tb_Payment
--Select * From tb_Payment
Insert Into tb_Payment ([ReceiptNo],[CustCode],[CustName],[SerialNo],[RefNo],[InvoiceDate],[GrossAmount],[Discount],[IDiscount],[Tax],[Amount],[Balance],[CreditNote],[DebitNote],[Id],[Status],[Type],[PMode],[ChqNo],[ChqDate],[Bank],[AccNo],[LocaCode],[RepCode],[UserId],[Tr_Date],[IType],[PayStat],[Remark],[RetChq],[Upload],[UnitNo])
Select			[ReceiptNo],[CustCode],[CustName],[SerialNo],[RefNo],[InvoiceDate],[GrossAmount],[Discount],[IDiscount],[Tax],[Amount],[Balance],[CreditNote],[DebitNote],[Id],[Status],[Type],[PMode],[ChqNo],[ChqDate],[Bank],[AccNo],[LocaCode],[RepCode],[UserId],[Tr_Date],[IType],[PayStat],[Remark],[RetChq],  '0'  ,   ''    From PRADEEPP.dbo.tb_Payment

*** tb_StAdjSumm ***

--Delete From tb_StAdjSumm
--Select * From tb_StAdjSumm
Insert Into tb_StAdjSumm ([SerialNo],[LocaCode],[RefNo],[IDate],[CostValue],[RetValue],[Id],[Type],[Status],[TrDate],[UserName])
Select 			  [SerialNo],[LocaCode],[RefNo],[IDate],[CostValue],[RetValue],[Id],[Type],[Status],[TrDate],[UserName]  From PRADEEPP.dbo.tb_StAdjSumm

*** tb_StAdjDet ***

--Delete From tb_StAdjDet
--Select * From tb_StAdjDet
Insert Into tb_StAdjDet	([LnNo],[SerialNo],[LocaCode],[IDate],[RefNo],[SuppCode],[ItemCode],[ItemDescrip],[Scale],[PackSize],[Cost],[Rate],[Qty],[CostValue],[RetValue],[TrDate],[ID],[Remark],[Status],[ExpDate],[BatchNo])
Select 			 [LnNo],[SerialNo],[LocaCode],[IDate],[RefNo],[SuppCode],[ItemCode],[ItemDescrip],[Scale],[PackSize],[Cost],[Rate],[Qty],[CostValue],[RetValue],[TrDate],[ID],[Remark],[Status],[ExpDate],[BatchNo] From PRADEEPP.dbo.tb_StAdjDet

*** tbPosTransact ***

--Delete From tbPosTransact
--Select * From tbPosTransact
Insert Into tbPosTransact ([ItemCode],[RefCode],[Descrip],[Cost],[Price],[Qty],[Amount],[IDI1],[IDis1],[IDiscount1],[IDI2],[IDis2],[IDiscount2],[IDI3],[IDis3],[IDiscount3],[IDI4],[IDis4],[IDiscount4],[IDI5],[IDis5],[IDiscount5],[Rate],[SDStat],[SDNo],[SDID],[SDIs],[SDiscount],[Tax],[Nett],[Loca],[IId],[Receipt],[Salesman],[Cust],[Cashier],[StartTime],[EndTime],[RecDate],[BillType],[Unit],[UnitNo],[RowNo],[CDate],[Status],[UpdateBy],[RecallStat],[SaleType],[RecallNo],[Pcs],[Invoice],[TrType],[Upload],[ZNo],[Insertdate],[PriceLevel],[Did],[Serial],[PackSize],[InvSerial],[ExpDate],[ItemType],[ConFact],[PackScale])
Select			   [ItemCode],[RefCode],[Descrip],[Cost],[Price],[Qty],[Amount],[IDI1],[IDis1],[IDiscount1],[IDI2],[IDis2],[IDiscount2],[IDI3],[IDis3],[IDiscount3],[IDI4],[IDis4],[IDiscount4],[IDI5],[IDis5],[IDiscount5],[Rate],[SDStat],[SDNo],[SDID],[SDIs],[SDiscount],[Tax],[Nett],[Loca],[IId],[Receipt],[Salesman],[Cust],[Cashier],[StartTime],[EndTime],[RecDate],[BillType],[Unit],[UnitNo],[RowNo],[CDate],[Status],[UpdateBy],[RecallStat],[SaleType],[RecallNo],[Pcs],[Invoice],[TrType],[Upload],[ZNo],[Insertdate],[PriceLevel],[Did],[Serial],[PackSize],[InvSerial],    ''   ,    0     ,    1    ,     1	   From PRADEEPP.dbo.tbPosTransact-- where idx=''

*** tbPosTransactSum ***

--Delete From tbPosTransactSum
--Select * From tbPosTransactSum
Insert Into tbPosTransactSum ([idx],[ItemCode],[RefCode],[Descrip],[Cost],[Price],[Qty],[Amount],[IDI1],[IDis1],[IDiscount1],[IDI2],[IDis2],[IDiscount2],[IDI3],[IDis3],[IDiscount3],[IDI4],[IDis4],[IDiscount4],[IDI5],[IDis5],[IDiscount5],[Rate],[SDStat],[SDNo],[SDID],[SDIs],[SDiscount],[Tax],[Nett],[Loca],[IId],[Receipt],[Salesman],[Cust],[Cashier],[StartTime],[EndTime],[RecDate],[BillType],[Unit],[UnitNo],[RowNo],[CDate],[Status],[UpdateBy],[RecallStat],[SaleType],[RecallNo],[Pcs],[TrType],[Upload],[ZNo],[Insertdate],[Invoice],[PriceLevel],[PackSize],[InvSerial],[Serial],[PackScale])
Select			             [idx], [ItemCode],[RefCode],[Descrip],[Cost],[Price],[Qty],[Amount],[IDI1],[IDis1],[IDiscount1],[IDI2],[IDis2],[IDiscount2],[IDI3],[IDis3],[IDiscount3],[IDI4],[IDis4],[IDiscount4],[IDI5],[IDis5],[IDiscount5],[Rate],[SDStat],[SDNo],[SDID],[SDIs],[SDiscount],[Tax],[Nett],[Loca],[IId],[Receipt],[Salesman],[Cust],[Cashier],[StartTime],[EndTime],[RecDate],[BillType],[Unit],[UnitNo],[RowNo],[CDate],[Status],[UpdateBy],[RecallStat],[SaleType],[RecallNo],[Pcs],[TrType],[Upload],[ZNo],[Insertdate],[Invoice],[PriceLevel],[PackSize],[InvSerial],[Serial],   0	From PRADEEPP.dbo.tbPosTransactSum

*** tbPosPayment ***

--Delete From tbPosPayment
--Select * From tbPosPayment
Insert Into tbPosPayment ([Receipt],[Loca],[UnitNo],[Sdate],[Id],[TypeId],[Amount],[Balance],[Cashier],[PaidAt],[BillType],[SerialNo],[PStatus],[Cust],[CustType],[BankId],[ChequeDate],[UpdateBy],[AdvanceNo],[Invoice],[Upload],[ZNo],[Insertdate],[Did],[PId],[Serial],[CustName],[PaymentNo],[TypeId2],[InvSerial])
Select			  [Receipt],[Loca],[UnitNo],[Sdate],[Id],[TypeId],[Amount],[Balance],[Cashier],[PaidAt],[BillType],[SerialNo],[PStatus],[Cust],[CustType],[BankId],[ChequeDate],[UpdateBy],[AdvanceNo],[Invoice],[Upload],[ZNo],[Insertdate],[Did],[PId],[Serial],[CustName],[PaymentNo],[TypeId2],[InvSerial]  From PRADEEPP.dbo.tbPosPayment

*** tbPosPaymentSum ***

--Delete From tbPosPaymentSum
--Select * From tbPosPaymentSum
Insert Into tbPosPaymentSum ([idx],[Receipt],[Loca],[UnitNo],[Sdate],[Id],[TypeId],[Amount],[Balance],[Cashier],[PaidAt],[BillType],[SerialNo],[PStatus],[Cust],[CustType],[BankId],[ChequeDate],[UpdateBy],[AdvanceNo],[Upload],[ZNo],[Insertdate],[Invoice],[Crpt],[ClDate],[InvSerial],[Serial],[CustName],[PaymentNo])
Select			     [idx],[Receipt],[Loca],[UnitNo],[Sdate],[Id],[TypeId],[Amount],[Balance],[Cashier],[PaidAt],[BillType],[SerialNo],[PStatus],[Cust],[CustType],[BankId],[ChequeDate],[UpdateBy],[AdvanceNo],[Upload],[ZNo],[Insertdate],[Invoice],[Crpt],[ClDate],[InvSerial],[Serial],[CustName],[PaymentNo]  From PRADEEPP.dbo.tbPosPaymentSum




*** tb_AdjQty ***

--Delete From tb_AdjQty
--Select * From tb_AdjQty
Insert Into tb_AdjQty ([ItemCode],[LocaCode],[Qty],[Id],[Cr_Date])
Select 		       [ItemCode],[LocaCode],[Qty],[Id],[Cr_Date]  From PRADEEPP.dbo.tb_AdjQty

