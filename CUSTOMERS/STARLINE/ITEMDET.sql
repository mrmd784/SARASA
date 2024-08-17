USE [EasyWay]
GO

INSERT INTO [dbo].[tb_ItemDet]
([Item_Code],[Loca_Code],[PRet_Price],[PWhole_Price],[PSp_Price],[ERet_Price],[EWhole_Price],[ESp_Price],[Cost_Price],[AvgCost]
,[Cost_Code],[Lock_S],[Lock_P],[NoDiscount],[Re_Qty],[Rol],[Qty],[User_Id],[CDate],[EditDate],[BinNo],[SPQ],[SPR],[TPQ],[TPR]
,[FPQ],[FPR],[FIPQ],[FIPR],[SIPQ],[SIPR],[SEPQ],[SEPR],[EIPQ],[EIPR],[Commission],[SPHSQ],[SPHSR],[TPHSQ],[TPHSR],[FPHSQ],[FPHSR],[FIPHSQ]
,[FIPHSR],[SIPHSQ],[SIPHSR],[SEPHSQ],[SEPHSR],[EIPHSQ],[EIPHSR],[C_Price])

SELECT
IT.[Item_Code],'03','0.00','0.00','0.00',CAST(I.SELLING_PRICE AS NUMERIC(18,2)),'0.00','0.00','0.00','0.00'
,'',0,	0,	0	,0	,0	,0,	'EASYWAY',GETDATE(),GETDATE(),'','0.0000',	'0.00',	'0.0000',	'0.00',	'0.0000',	'0.00'
,'0.0000',	'0.00',	'0.0000',	'0.00',	'0.0000',	'0.00',	'0.0000',	'0.00',	'0.00',	'0.0000',	'0.00',	'0.0000',	'0.00',	'0.0000'	,'0.00',	'0.0000',	'0.00',	'0.0000',
'0.00',	'0.0000',	'0.00',	'0.0000',	'0.00',	'0.00'
FROM tb_Item IT
JOIN ITEMDETAILS2 I ON IT.Item_Code=I.[MODEL NO]
WHERE IT.Item_Code<>'00000'

UPDATE IT SET IT.BINNO=I.[DISCOUNT CODE] FROM  ITEMDETAILS2 AS I JOIN tb_ItemDet AS IT ON I.[MODEL NO]=IT.Item_Code
WHERE I.[DISCOUNT CODE] IS NOT NULL

   