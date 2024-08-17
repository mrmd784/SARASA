select * from tbPostransact where ZNo=71 and UnitNo=1
select * from tbPospayment where ZNo=71 and UnitNo=1


select * from tbPostransactSum where ZNo='71' and UnitNo=1
select * from tbPospaymentSum where ZNo='71' and UnitNo=1
select * from tb_InvDet where IDate='2023-11-07' and ID='inv' and RefNo like '1-71%'
select * from tb_InvSumm where IDate='2023-11-07' and ID='inv'
select * from tb_Stock where PDate='2023-11-07' and ID='inv'
select * from tb_Payment where InvoiceDate='2023-11-07' and RefNo like '1-71%'


delete from tbPostransactSum where ZNo='71' and UnitNo=1
delete from tbPospaymentSum where ZNo='71' and UnitNo=1
delete from tb_InvDet where IDate='2023-11-07' and ID='inv' and RefNo like '1-71%'
delete from tb_InvSumm where IDate='2023-11-07' and ID='inv'
delete from tb_Stock where PDate='2023-11-07' and ID='inv'
delete from tb_Payment where InvoiceDate='2023-11-07' and RefNo like '1-71%'

