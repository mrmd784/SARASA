SELECT * FROM tb_StAdjDet WHERE LocaCode='99' AND SerialNo='99000001'
SELECT * FROM tb_StAdjSumm WHERE LocaCode='99' AND SerialNo='99000001'
SELECT * FROM tb_Stock  WHERE LocaCode='99'

UPDATE tb_StAdjDet SET IDate='2023-07-31 00:00:00.000'   WHERE LocaCode='99' AND SerialNo='99000001'
UPDATE tb_StAdjSumm SET IDate='2023-07-31 00:00:00.000'  WHERE LocaCode='99' AND SerialNo='99000001'
UPDATE tb_Stock SET PDate='2023-07-31 00:00:00.000'      WHERE LocaCode='99' AND SerialNo='99000001'

----
