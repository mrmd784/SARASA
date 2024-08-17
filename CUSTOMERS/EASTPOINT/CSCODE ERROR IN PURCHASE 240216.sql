select * from tb_Colour_Size where ItemCode='30030001'


select * from tb_stock order by pdate desc

select * from tb_stock where CSCode='30030001#ACLRS\9Y-10'


select * from tb_TempPurch where Remark='30030001#ACLRS\9Y-10'

select * from tb_purdet where SerialNo='01000048'

select distinct pd.cscode into tempCsCode from tb_purdet pd
join tb_Colour_Size cs on pd.CSCode=cs.CSCode
where SerialNo='01000048' 

select * into WrnCSCode from tb_PurDet where SerialNo='01000048'
and CSCode not in(select CSCode from tempCsCode)

select * from WrnCSCode

select cs.cscode,wc.cscode from tb_Colour_Size cs
join WrnCSCode wc on cs.csname=wc.csname 
group by wc.CSCode,cs.CSCode


select * from tb_stock where SerialNo='01000048' and id='PCH'



select * from tb_Colour_Size where CSCode='10010058#WHT\L'

select * from tb_purdet pd
join tb_Colour_Size cs on pd.CSCode=cs.CSCode
where SerialNo='01000048' 
and pd.csname=cs.csname and pd.CSCode<>cs.CSCode

select distinct CSCode from tb_Stock where CSCode not in
(select distinct st.CSCode from tb_stock st
join tb_Colour_Size cs on st.CSCode=cs.CSCode)


drop table tempCsCode

select distinct st.CSCode from tb_stock st
join tb_Colour_Size cs on st.CSCode=cs.CSCode
where SerialNo='01000048'


drop table WrnCSCode

select * from WrnCSCode

select distinct CSCode from tb_Stock where SerialNo='01000048'
and CSCode not in(select cscode from tempCsCode)


select distinct st.CSCode,cs.CSCode from tb_Stock st
join tb_Colour_Size cs on st.CSName=cs.CSName
 where SerialNo='01000048'
and st.CSCode in(select cscode from WrnCSCode)

select * from tb_stock where CSCode='10010062#YELLOW PIN\'
select * from tb_Colour_Size where CSCode='10010061#YELLOW PIN\L'


begin tran
update st set st.cscode=cs.cscode from tb_colour_size as cs
join tb_stock as st on cs.CSName=st.CSName
where SerialNo='01000048'
and st.CSCode in(select cscode from WrnCSCode)

rollback

commit


select * from tb_Stock where CSCode='30030001#ACLRS\9Y-10' and serialno='01000030'

update tb_Stock set CSCode='30030001#ACLRS\9Y-10Y' where CSCode='30030001#ACLRS\9Y-10' and serialno='01000030'

select * from tb_Stock where CSCode='40010022#BLUEPINK\7Y'
select * from tb_Stock where CSCode='40010022#GREENASH\7Y'



