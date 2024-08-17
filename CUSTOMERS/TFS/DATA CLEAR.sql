select * from tbPostransact2 where Loca='02'
and RecDate>'2024-01-31'
order by recdate

select * from tbPospayment2 where Loca='02'
and sdate>'2024-01-31'
order by sdate

select * from tbPostransactsum where Loca='02'
and RecDate>'2024-01-31'
order by recdate

select * from tbPospaymentsum where Loca='02'
and sdate>'2024-01-31'
order by sdate

select * from tb_InvDet where LocaCode='02' and IDate>'2024-01-31'
order by SerialNo --30704

select * from tb_InvSumm where LocaCode='02' and IDate>'2024-01-31'
order by SerialNo --30704

select * from tb_Stock where LocaCode='02' and PDate>'2024-01-31'
order by pdate
 
select *  from tb_Payment where LocaCode='02' and InvoiceDate>'2024-01-31' and Id='PMT'
order by SerialNo --30705
 
select * from tb_ACCOUNT_FROM_POS where LOCATION='02' and GRN_DATE>'2024-01-31'--1374
 order by GRN_NO
 
select * from tb_System where LocaCode='02'
update tb_System set INV='30704',PMT='30705',DID='1374' where LocaCode='02'

-------------------------------------------------------------------------------------------------

delete from tbPostransact2 where Loca='02'
and RecDate>'2024-01-31'

delete from tbPospayment2 where Loca='02'
and sdate>'2024-01-31'

delete from tbPostransactsum where Loca='02'
and RecDate>'2024-01-31'

delete from tbPospaymentsum where Loca='02'
and sdate>'2024-01-31'

delete from tb_InvDet where LocaCode='02' and IDate>'2024-01-31'
--30704
delete from tb_InvSumm where LocaCode='02' and IDate>'2024-01-31'
--30704
delete from tb_Stock where LocaCode='02' and PDate>'2024-01-31'
 
delete from tb_Payment where LocaCode='02' and InvoiceDate>'2024-01-31' and Id='PMT'
 --30705
delete from tb_ACCOUNT_FROM_POS where LOCATION='02' and GRN_DATE>'2024-01-31'--1374
