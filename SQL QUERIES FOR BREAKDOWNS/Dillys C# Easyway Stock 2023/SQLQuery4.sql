

select distinct UnitNo,ZNo from tbPostransact where Upload='F' and Loca='33'

update tbPostransact set Upload='C' where Upload is null and Loca='04'
update tbPospayment set Upload='C' where Upload is null and Loca='04'


Select UnitNo,LOCA,Isnull(Sum(Case Iid When '001' Then Nett
 When '002' Then -Nett Else 0 End),0) AS Nett  From tbPosTransact 
Where Status=1 And SaleType='S' And Upload='A' and loca='33'   Group By UnitNo,LOCA


Select Isnull(Sum(Case Iid When '001' Then qty
When '002' Then -Qty Else 0 End),0) AS qty From tbPosTransact 
Where Status=1 And SaleType='S' And Upload='A' and loca='33'  -- group by UnitNo  --2179


select * from tbPostransact where Loca='33' and Upload='A' and itemcode  not in (select item_code from tb_ItemDet where Loca_Code='33')

select * from tb_DwnStock where ItemCode not in (select item_code from tb_item)


select SUM(stock) from VW_STOCKCS where LocaCode='33' --2195  
select SUM(stock) from VW_STOCK where LocaCode='33'  --2195
select sum (qty)from tb_DwnStock

Truncate Table tb_DwnStock
select * from tb_DwnStock


select * from tbPostransact where Loca='33' and Upload='A' and RefCode not like '%#%' and RefCode<>''
update tbPostransact set RefCode=''  where Loca='33' and Upload='A' and RefCode not like '%#%' and RefCode<>''


select * from tb_Colour_Size

Insert Into tb_DwnStock (ItemCode,CScode  ,Loca ,Qty  ,Balance,Cost,Price,currqty) 
select                   ItemCode,RefCode,'33' ,Isnull(Sum(Case Iid When '001' Then Qty When '002' Then -Qty Else 0 End),0),Isnull(Sum(Case Iid When '001' Then Qty When '002' Then -Qty Else 0 End),0) ,0,0,0
From TBPOSTRANSACT   Where Status=1 And SaleType='S' and Loca='33' and Upload='A' group by ItemCode,RefCode

select * from tb_item
select distinct Use_Exp from tb_item

Insert Into tb_DwnStock (ItemCode,CScode ,Loca,Qty  ,Balance,Cost,Price,currqty) 
select                   Item_Code,'','33' ,0,0 ,0,0,0 from tb_Item where  Use_Exp<>3 and Item_Code not in 
(select itemcode from tb_DwnStock )

select * from tb_DwnStock

Insert Into tb_DwnStock (ItemCode,CScode ,Loca,Qty  ,Balance,Cost,Price,currqty) 
select                   ItemCode,CSCode,'33' ,0,0 ,0,0,0 from tb_Colour_Size where LocaCode='33'
 and CSCode not in (select CSCode from tb_DwnStock where CSCode<>'')

--
--select * from tb_DwnStock

Update tb_DwnStock Set tb_DwnStock.Currqty=VW_STOCKCS.Stock From tb_DwnStock  Join  VW_STOCKCS On VW_STOCKCS.ItemCode=tb_DwnStock.ItemCode  And  VW_STOCKCS.LocaCode=tb_DwnStock.Loca and VW_STOCKCS.ItemCode=tb_DwnStock.ItemCode and VW_STOCKCS.CSCode=tb_DwnStock.CSCode

Update tb_DwnStock Set Balance=Balance-currQty

----End add stock to temp table -------------------------------------------------------

select * from tb_Stock where LocaCode='03'order by pdate


select SUM(STOCK) from VW_STOCK_CS where LocaCode='04'
select SUM(STOCK) from VW_STOCK where LocaCode='04'
select * from VW_STOCK


alter VIEW [Stock] AS
select SUM(tb_DwnStock.Qty) as qty,tb_DwnStock.ItemCode,loca from tb_DwnStock group by tb_DwnStock.ItemCode,loca

select Stock.Qty,Stock.ItemCode from Stock 
join Vw_Stock on  Stock.ItemCode=Vw_Stock.ItemCode 
and Vw_Stock.LocaCode=Stock.loca and Stock.Qty<>Vw_Stock.Stock  order by Stock.ItemCode --16



select * from tb_Stock where LocaCode='02' and ItemCode='R089M21166' order by pdate
update tb_Stock set Status=9,TourCode='WNGTO' where LocaCode='02' and ItemCode='MDR05DE684' 
update tb_Stock set CSCode='R089M21166#WHT-XS' where LocaCode='02' and ItemCode='R089M21166' and Idx='148534'
delete from tb_Stock where refno='ST04102019' and LocaCode='08' and ItemCode='DM39TO0724'
delete from tb_Stock_OpBal where refno='ST04102019' and LocaCode='08' and ItemCode='DM39TO0724'

select * from tb_Itemdet where Item_Code='DM39TO0724'

select * from VW_STOCKCS where LocaCode='33' and ItemCode='F099W22032' order by CSCode
select * from tb_Colour_Size where ItemCode='F099W22032' and LocaCode='33' order by CSCode
select * from VW_STOCK where LocaCode='02' and ItemCode='MDR05DE684'

FD22C3193A#DNM\S30

select * from tbPostransact where Upload='A' and Loca='33' and ItemCode='F099W22032'
select * from tb_DwnStock where ItemCode='F099W22032' order by CSCode
select * from tb_Colour_Size where ItemCode='F099W22032' and LocaCode='33' order by CSCode
select * into TB_STOCK_WRONGCS  from TB_STOCK where  LocaCode='33' and ItemCode='F099W22032' order by pdate
select *   from TB_STOCK where  LocaCode='33' and ItemCode='F099W22032' order by pdate
update TB_STOCK set cscode='DM723D1983#BEG\14'  where  LocaCode='33' and ItemCode='DM723D1983' and idx=451848


update TB_STOCK set cscode='F099W22032#DNM\S36' where idx=468942
update TB_STOCK set cscode='F099W22032#DNM\S30' where idx=468943
update TB_STOCK set cscode='F099W22032#DNM\S32' where idx=468944
update TB_STOCK set cscode='F099W22032#DNM\S34' where idx=468945


select * from tb_togdet where serialno='17002560'

delete from tb_Colour_Size where ItemCode='DM39TO0724' and LocaCode='08' order by CSCode
--update tb_Item set Coloursize=0 where Item_Code='DM39TO0724'

update tbPostransact set RefCode='' where Upload='A' and Loca='05' and ItemCode='DM39TO0724'
update TB_STOCK set CSCode='' where  ItemCode='DM39TO0724' and   LocaCode='05'

select * from TB_STOCK where  LocaCode='05' and ItemCode='F118X21580' and CSCode='F118X21580#BLU\'

update TB_STOCK set CSCode='F118X21580#BLU\15' where  LocaCode='05' and ItemCode='F118X21580' and CSCode='F118X21580#BLU\'
select distinct CSCode from TB_STOCK where  LocaCode='05' and ItemCode='DM39TO0724'
select distinct CSCode from tb_Colour_Size where ItemCode='DM39TO0724' and LocaCode='05' 

delete from tb_Colour_Size where ItemCode='DM39TO0724' and LocaCode='05' 


select * from TB_STOCK where LocaCode='19' and ItemCode='F118X21580' and CSCode not like '%#%'
update TB_STOCK set CSCode='F085110539#GRN\L' where LocaCode='05' and ItemCode='F085110539' and CSCode=''
select * from tb_Colour_Size where  LocaCode='19' and ItemCode='F098G21622'  -- F098U21594#0\0


delete from tb_Colour_Size where ItemCode='F098U21594' and Idx in('2043745','2043661') and LocaCode='04' 

select * from tb_DwnStock where ItemCode='EST0010029'

select * from TB_STOCK where  LocaCode='04'  and ItemCode in ('EMA0010107') 

select * from TB_STOCK where  LocaCode='19'  and ItemCode in ('DF57PA0075') and CSCode=''

--update tbPostransact set RefCode=''where LEN(RefCode)<11
--update TB_STOCK set CSCode='' where  LocaCode='19'  and ItemCode in ('EMA0010018') and CSCode=''


select * from tb_DwnStock where ItemCode='F098G21622'              
SELECT * FROM VW_STOCK_CS WHERE  LocaCode='08' and itemcode='DN65DR3185'
select * from vw_stock where locacode='08' and itemcode='DN65DR3185'
select * from tb_itemdet where loca_code='08' and item_code='DN65DR3185'
select * from tb_Colour_Size where itemcode='DN65DR3185' 

--update tb_stock set status='9' where idx=128928

END



