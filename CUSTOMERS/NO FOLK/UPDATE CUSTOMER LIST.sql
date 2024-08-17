USE [EASYWAYMT]
GO

INSERT INTO [dbo].[tb_Customer]
([Cust_Code],[Cust_Name],[Contact_Name],[Contact_No],[Address1],[Address2],[Address3],[Country],[Phone1]
,[Phone2],[Phone3],[Fax],[Email],[Web_Site],[CreditLimit],[CreditPeriod],[Route],[CDate],[State],[User_Id],[Balance]
,[AccBalance],[PriceStat],[OverDraft],[Download],[Discount],[Type],[Intergration_Upload],[LoyaltyCustCode]
,[EditDate],[salesRep],[PriceListID],[SaleType])

SELECT
[Cust_Code],[Cust_Name],[Contact_Name],''[Contact_No],[Address1],[Address2],[Address3],[VAT NO][Country],''[Phone1]
,''[Phone2],''[Phone3],[Fax],''[Email],''[Web_Site],'0.00'[CreditLimit],0[CreditPeriod],'07'[Route],getdate()[CDate],0[State],'EASYWAY'[User_Id],0[Balance]
,0[AccBalance],1[PriceStat],0[OverDraft],'F'[Download],0[Discount],0[Type],0[Intergration_Upload],''[LoyaltyCustCode]
,getdate()[EditDate],
CASE 
WHEN salesRep='ALUTHGAMA' THEN '16' 
WHEN salesRep='AMBALANGODA' THEN '17'
WHEN salesRep='AMPARA' THEN '57' 
WHEN salesRep='ANURADHAPURA' THEN '56' 
WHEN salesRep='BADULLA' THEN '50' 
WHEN salesRep='BATTICALOA' THEN '55' 
WHEN salesRep='BERUWALA' THEN '15' 
WHEN salesRep='DAMBULLA' THEN '45' 
WHEN salesRep='GALLE' THEN '21' 
WHEN salesRep='HALDAMULLA' THEN '51' 
WHEN salesRep='HAMBANTOTA' THEN '24' 
WHEN salesRep='HATTON' THEN '48' 
WHEN salesRep='JAFFNA' THEN '52' 
WHEN salesRep='KULIYAPITIYA' THEN '38' 
WHEN salesRep='MATARA' THEN '23' 
WHEN salesRep='NUWARAELIYA' THEN '49' 
WHEN salesRep='PUTTALAM' THEN '36' 
WHEN salesRep='RATHNAPURA' THEN '20' 
WHEN salesRep='TRINCOMALEE' THEN '54' 
WHEN salesRep='WELIGAMA' THEN '22' 
else '' END,'10'[PriceListID],0[SaleType] FROM sathosacus

select distinct salesrep from sathosacus



select * from tb_Customer
select * from sathosacus

select * from tb_Route
select * from tb_SalesRep
select * from tb_SpecialPriceList  10