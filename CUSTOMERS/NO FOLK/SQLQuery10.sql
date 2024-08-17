select I.Item_Code,I.Inv_Descrip,P.Price AS OLDMRP,ID.ERet_Price AS NEWMRP,SL.SpecialPriceListNAME,S.RET_PRICE AS MRP,S.EachRet_Price AS SPECIALPRICE from tb_ItemDet ID
JOIN TB_ITEM I ON ID.Item_Code=I.Item_Code
JOIN NEWPRICELIST N ON ID.Item_Code=N.[Item Code]
JOIN tb_PriceLink P ON ID.Item_Code=P.ItemCode
JOIN tb_SpecialPrices S ON ID.Item_Code=S.Item_Code
JOIN tb_SpecialPriceList SL ON S.SpecialPriceListID=SL.SpecialPriceListID
WHERE ID.Loca_Code='01' AND P.Loca='01'
AND CAST(P.CreateDate AS DATE)='2024-06-18'
AND S.SpecialPriceListID IN('1','2')
order by ID.Item_Code,S.SpecialPriceListID


select * from tb_SpecialPrices where Item_Code='FBC0008'

SELECT * FROM tb_SpecialPriceList

