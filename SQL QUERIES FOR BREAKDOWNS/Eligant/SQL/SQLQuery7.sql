SELECT * FROM tb_ItemDet WHERE Loca_Code ='04'

SELECT * FROM tb_Stock WHERE LocaCode ='05' AND PDate >'2023-07-31'

SELECT * FROM tb_StAdjDet WHERE LocaCode='05' AND SerialNo='05000001'
SELECT * FROM tb_StAdjSumm WHERE LocaCode='05' AND SerialNo='05000001'
SELECT * FROM tb_Stock  WHERE LocaCode='05'

DELETE FROM tb_StAdjDet WHERE LocaCode='05' AND SerialNo='05000001'
DELETE FROM tb_StAdjSumm WHERE LocaCode='05' AND SerialNo='05000001'
DELETE FROM tb_Stock  WHERE LocaCode='05'      

SELECT * FROM tb_System  WHERE LocaCode='05' 
UPDATE tb_System SET OPB=1 WHERE LocaCode='05' 




