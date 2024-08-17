USE [EasyWay]
GO

INSERT INTO [dbo].[tb_Item]
([Item_Code],[Ref_Code],[Barcode],[Inv_Descrip],[Descrip],[SinhalaDescrip],[Cat_Code],[SubCat_Code],[L1_Code],[L2_Code],[L3_Code],[L4_Code]
,[L5_Code],[L6_Code],[L7_Code],[Supp_Code],[Pack_Size],[W_Margine],[R_Margine],[PUnit],[EUnit],[Tax1],[MaxPrice],[Tax2],[Tax3],[Countable]
,[Use_Exp],[ConvertFact],[ConvertFactUnit],[Consign],[OpenPrice],[isCombined],[isTaxApply],[isNbtApply],[ComRate],[Intergration_Upload]
,[ItemType],[AutoSerial],[QrCodeDescrip])

SELECT [MODEL NO],'','',Item_Name,Item_Name,ISNULL(Reference_code,''),C.CAT_CODE,S.SubCat_Code,ISNULL(L1.L1_Code,''),ISNULL(L2.L2_Code,''),ISNULL(L3.L3_Code,''),''
,'','','',SP.Supp_Code,1,'0.0000','0.0000','NOS','NOS','0.00','0.00','0.00','0.00','1'
,0,1,'NOS',0,0,0,0,0,1,0
,0,0,'' FROM ITEMDETAILS I
LEFT JOIN TB_CATEGORY C ON I.Category_Name=C.Cat_Name
LEFT JOIN tb_SubCategory S ON I.SubCategory_Name=S.SubCat_Name
LEFT JOIN tb_Supplier SP ON I.Supplier_Name=SP.Supp_Name
LEFT JOIN tb_Link1 L1 ON I.BRAND=L1.L1_Name
LEFT JOIN tb_Link2 L2 ON I.SHOWCASE=L2.L2_Name
LEFT JOIN tb_Link3 L3 ON I.WARRANTY=L3.L3_Name
ORDER BY I.Item_Name



SELECT * FROM 
