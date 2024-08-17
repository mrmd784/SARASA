USE [Easyway]
GO

/****** Object:  StoredProcedure [dbo].[SP_DOWNLOAD_MASTER]    Script Date: 03/16/2023 19:11:25 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



--delete from tb_supplier
--select * from tb_itemdet

ALTER PROCEDURE [dbo].[SP_DOWNLOAD_MASTER]
	@LOCATIONID	Varchar(5)='02'
AS
	SET NOCOUNT ON
	DECLARE @lastid int
	Set @lastid=0

-- 1
Declare @Cust_Code varchar(10)
Declare @Cust_Name varchar(50)
Declare @Contact_Name varchar(50)
Declare @Contact_No varchar(15)
Declare @Address1 varchar(50)
Declare @Address2 varchar(50)
Declare @Address3 varchar(50)
Declare @Country varchar(30)
Declare @Region varchar(30)
Declare @Phone1 varchar(15)
Declare @Phone2 varchar(15)
Declare @Phone3 varchar(15)
Declare @Fax varchar(15)
Declare @Email varchar(50)
Declare @Web_Site varchar(50)
Declare @CreditLimit money
Declare @CreditPeriod float
Declare @Route varchar(60)
Declare @CDate smalldatetime
Declare @State tinyint
Declare @User_Id varchar(15)
Declare @Balance float
Declare @AccBalance float
Declare @PriceStat int
Declare @OverDraft float
Declare @Idx int

--2 
Declare @Supp_Code varchar(10)
Declare @Supp_Name varchar(50)
Declare @Status bit
Declare @AccNo	Varchar(15)
Declare @Branch	Varchar(30)
--3 item

Declare @Item_Code varchar(20)
Declare @Ref_Code varchar(20)
Declare @Inv_Descrip char(35)
Declare @Descrip varchar(65)
Declare @Cat_Code varchar(10)
Declare @SubCat_Code varchar(10)
Declare @L1_Code varchar(10)
Declare @L2_Code varchar(10)
Declare @L3_Code varchar(10)
Declare @L4_Code varchar(10)
Declare @L5_Code varchar(10)
Declare @L6_Code varchar(10)
Declare @L7_Code varchar(10)
Declare @Pack_Size float
Declare @W_Margine nvarchar(20)
Declare @R_Margine nvarchar(20)
Declare @PUnit varchar(5)
Declare @EUnit varchar(5)
Declare @Tax1 varchar(10)
Declare @Tax2 varchar(10)
Declare @Tax3 varchar(10)
Declare @MaxPrice money
Declare @Countable tinyint
Declare @Use_Exp tinyint
Declare @ComRate float
Declare @ItemType tinyint
Declare @ConvertFact int
Declare @ConvertFactUnit char(5)
Declare @Barcode Varchar(20)
Declare @Consign Tinyint
Declare @OpenPrice Tinyint
Declare @AutoSerial Tinyint
Declare @isCombined bit
Declare @isTaxApply bit
Declare @Intergration_Upload bit
Declare @sinhalaDescrip varchar(100)


-- 4 item det

Declare @Lock_S bit
Declare @Lock_P bit
Declare @NoDiscount bit
Declare @EditDate datetime
Declare @SPQ decimal
Declare @TPQ decimal
Declare @FPQ decimal
Declare @Re_Qty float
Declare @Rol float
Declare @Qty float
Declare @PRet_Price money
Declare @PWhole_Price money
Declare @PSp_Price money
Declare @ERet_Price money
Declare @EWhole_Price money
Declare @ESp_Price money
Declare @Cost_Price money
Declare @SPR money
Declare @TPR money
Declare @FPR money
Declare @Loca_Code varchar(5)
Declare @Cost_Code varchar(10)
Declare @BinNo varchar(10)
Declare @AvgCost Money
Declare @FIPQ decimal
Declare @FIPR money
Declare @SIPQ decimal
Declare @SIPR money
Declare @SEPQ decimal
Declare @SEPR money
Declare @EIPQ decimal
Declare @EIPR money
Declare @Commission nvarchar(10)

-- 5 LINK1

Declare @L1_Rate decimal
Declare @L1_Name varchar(50)

Declare @L2_Rate decimal
Declare @L2_Name varchar(50)

Declare @L3_Rate decimal
Declare @L3_Name varchar(50)

Declare @L4_Rate decimal
Declare @L4_Name varchar(50)

--  6 cat

Declare @Cat_Rate decimal
Declare @Cat_Name varchar(50)

-- 7 SUB CAT
Declare @SubCat_Name varchar(50)

-- Colour Size 

Declare	@ItemCode varchar(30)
Declare	@CSCode varchar(30) 
Declare	@CSName varchar(100) 
Declare	@Rate decimal(18,2) 
Declare	@Price decimal(18,2)
Declare	@Discount decimal(18,2)
Declare	@CCode varchar(30) 
Declare	@SCode varchar(30) 
Declare	@LocaCode varchar(5) 


--8 Salesman
Declare @Rep_Code varchar(10)
Declare @Rep_Name varchar(50)
Declare @CommRate float
Declare @TargetAmt money
Declare @Rep bit
Declare @Locacode varchar(10)
Declare @Log Int


--  tb_Supplier DOWNLOAD

Select @lastid=IsNull(Max(LastId),0) From tb_DownloadIdx Where Iid='SUP' AND LOCA=@LOCATIONID
Delete From tb_DownloadIdx Where Iid='SUP' And LastId<@lastid AND LOCA=@LOCATIONID

DECLARE curSupp CURSOR FOR 
Select Supp_Code,Supp_Name,Contact_Name,Contact_No,Address1,Address2,Address3,Country,Phone1,Phone2,Phone3,Fax,Email,Web_Site,CDate,Status,[User_Id],Idx,AccNo,Branch from 
OpenRowset('Sqloledb','123.231.63.178';'sa';'tstc123',EasyWayC.Dbo.tb_Supplier_Rpl)WHERE Idx>@lastid Order By Idx

OPEN curSupp

FETCH NEXT FROM curSupp
INTO @Supp_Code,@Supp_Name,@Contact_Name,@Contact_No,@Address1,@Address2,@Address3,@Country,@Phone1,@Phone2,@Phone3,@Fax,@Email,@Web_Site,@CDate,@Status,@User_Id,@Idx,@AccNo,@Branch

WHILE @@FETCH_STATUS = 0
BEGIN   
	If Not Exists (Select Supp_Code From tb_Supplier Where Supp_Code= @Supp_Code)
	Begin 	
    	Insert Into tb_Supplier ([Supp_Code],[Supp_Name],[Contact_Name],[Contact_No],[Address1],[Address2],[Address3],[Country],[Phone1],[Phone2],[Phone3],[Fax],[Email],[Web_Site],[CDate],[Status],[User_Id],[Download],[AccNo],[Branch]) 
		Values(@Supp_Code,@Supp_Name,@Contact_Name,@Contact_No,@Address1,@Address2,@Address3,@Country,@Phone1,@Phone2,@Phone3,@Fax,@Email,@Web_Site,@CDate,@Status,@User_Id,'F',@AccNo,@Branch)		
	End
	Else
	Begin
		Update  tb_Supplier Set 	
					[Supp_Name]		=@Supp_Name,
					[Contact_Name]	=@Contact_Name,
					[Contact_No]	=@Contact_No,
					[Address1]		=@Address1,
					[Address2]		=@Address2,
					[Address3]		=@Address3,
					[Country]		=@Country,
					[Phone1]		=@Phone1,
					[Phone2]		=@Phone2,
					[Phone3]		=@Phone3,
					[Fax]			=@Fax,
					[Email]			=@Email,
					[Web_Site]		=@Web_Site,
					[CDate]			=@CDate,
					[Status]			=@Status,
					[User_Id]		=@User_Id,
					[Download]		='F',
					[AccNo]			=@AccNo,
					[Branch]		=@Branch
					Where Supp_Code=@Supp_Code		
	End

	Insert Into tb_DownloadIdx ([Iid],[lastid],[LOCA]) Values ('SUP',@Idx,@LOCATIONID)

       	FETCH NEXT FROM curSupp
	INTO @Supp_Code,@Supp_Name,@Contact_Name,@Contact_No,@Address1,@Address2,@Address3,@Country,@Phone1,@Phone2,@Phone3,@Fax,@Email,@Web_Site,@CDate,@Status,@User_Id,@Idx,@AccNo,@Branch

END

CLOSE curSupp
DEALLOCATE curSupp


--  tb_Link1 DOWNLOAD

Select @lastid=IsNull(Max(LastId),0) From tb_DownloadIdx Where Iid='LN1' AND LOCA=@LOCATIONID
Delete From tb_DownloadIdx Where Iid='LN1' And LastId<@lastid AND LOCA=@LOCATIONID

DECLARE curLink1 CURSOR FOR Select [User_Id],CDate,L1_Rate,Idx,L1_Code,L1_Name from 
OpenRowset('Sqloledb','123.231.63.178';'sa';'tstc123',EasyWayC.Dbo.tb_Link1_Rpl)
WHERE Idx>@lastid Order By Idx

OPEN curLink1

FETCH NEXT FROM curLink1	INTO @User_Id,@CDate,@L1_Rate,@Idx,@L1_Code,@L1_Name

WHILE @@FETCH_STATUS = 0
BEGIN     	
	If Not Exists (Select L1_Code From tb_Link1 Where L1_Code= @L1_Code)
	Begin 	
    		Insert Into tb_Link1 ([User_Id],[CDate],[L1_Rate],[L1_Code],[L1_Name])  Values(@User_Id,@CDate,@L1_Rate,@L1_Code,@L1_Name)	
	End
	Else
	Begin
		Update tb_Link1 Set [User_Id]=@User_Id,CDate=@CDate,L1_Rate=@L1_Rate,L1_Name=@L1_Name Where L1_Code=@L1_Code
	End
	Insert Into tb_DownloadIdx ([Iid],[lastid],[LOCA]) Values ('LN1',@Idx,@LOCATIONID)

     FETCH NEXT FROM curLink1 INTO @User_Id,@CDate,@L1_Rate,@Idx,@L1_Code,@L1_Name

END

CLOSE curLink1
DEALLOCATE curLink1

--  tb_Link2 DOWNLOAD

Select @lastid=IsNull(Max(LastId),0) From tb_DownloadIdx Where Iid='LN2' AND LOCA=@LOCATIONID
Delete From tb_DownloadIdx Where Iid='LN2' And LastId<@lastid AND LOCA=@LOCATIONID

DECLARE curLink2 CURSOR FOR Select [User_Id],CDate,L2_Rate,Idx,L2_Code,L2_Name from 
OpenRowset('Sqloledb','123.231.63.178';'sa';'tstc123',EasyWayC.Dbo.tb_Link2_Rpl)
WHERE Idx>@lastid Order By Idx

OPEN curLink2

FETCH NEXT FROM curLink2	INTO @User_Id,@CDate,@L2_Rate,@Idx,@L2_Code,@L2_Name

WHILE @@FETCH_STATUS = 0
BEGIN     	
	If Not Exists (Select L2_Code From tb_Link2 Where L2_Code= @L2_Code)
	Begin 	
    		Insert Into tb_Link2 ([User_Id],[CDate],[L2_Rate],[L2_Code],[L2_Name])  Values(@User_Id,@CDate,@L2_Rate,@L2_Code,@L2_Name)	
	End
	Else
	Begin
		Update tb_Link2 Set [User_Id]=@User_Id,CDate=@CDate,L2_Rate=@L2_Rate,L2_Name=@L2_Name Where L2_Code=@L2_Code
	End
	Insert Into tb_DownloadIdx ([Iid],[lastid],[LOCA]) Values ('LN2',@Idx,@LOCATIONID)

     FETCH NEXT FROM curLink2 INTO @User_Id,@CDate,@L2_Rate,@Idx,@L2_Code,@L2_Name
END

CLOSE curLink2
DEALLOCATE curLink2

--  tb_Link3 DOWNLOAD

Select @lastid=IsNull(Max(LastId),0) From tb_DownloadIdx Where Iid='LN3' AND LOCA=@LOCATIONID
Delete From tb_DownloadIdx Where Iid='LN3' And LastId<@lastid AND LOCA=@LOCATIONID

DECLARE curLink3 CURSOR FOR Select [User_Id],CDate,L3_Rate,Idx,L3_Code,L3_Name from 
OpenRowset('Sqloledb','123.231.63.178';'sa';'tstc123',EasyWayC.Dbo.tb_Link3_Rpl)
WHERE Idx>@lastid Order By Idx

OPEN curLink3

FETCH NEXT FROM curLink3	INTO @User_Id,@CDate,@L3_Rate,@Idx,@L3_Code,@L3_Name

WHILE @@FETCH_STATUS = 0
BEGIN     	
	If Not Exists (Select L3_Code From tb_Link3 Where L3_Code= @L3_Code)
	Begin 	
    		Insert Into tb_Link3 ([User_Id],[CDate],[L3_Rate],[L3_Code],[L3_Name])  Values(@User_Id,@CDate,@L3_Rate,@L3_Code,@L3_Name)	
	End
	Else
	Begin
		Update tb_Link3 Set [User_Id]=@User_Id,CDate=@CDate,L3_Rate=@L3_Rate,L3_Name=@L3_Name Where L3_Code=@L3_Code
	End
	Insert Into tb_DownloadIdx ([Iid],[lastid],[LOCA]) Values ('LN3',@Idx,@LOCATIONID)

     FETCH NEXT FROM curLink3 INTO @User_Id,@CDate,@L3_Rate,@Idx,@L3_Code,@L3_Name
END

CLOSE curLink3
DEALLOCATE curLink3

--  tb_Link4 DOWNLOAD

Select @lastid=IsNull(Max(LastId),0) From tb_DownloadIdx Where Iid='LN4' AND LOCA=@LOCATIONID
Delete From tb_DownloadIdx Where Iid='LN4' And LastId<@lastid AND LOCA=@LOCATIONID

DECLARE curLink4 CURSOR FOR Select [User_Id],CDate,L4_Rate,Idx,L4_Code,L4_Name from 
OpenRowset('Sqloledb','123.231.63.178';'sa';'tstc123',EasyWayC.Dbo.tb_Link4_Rpl)
WHERE Idx>@lastid Order By Idx

OPEN curLink4

FETCH NEXT FROM curLink4	INTO @User_Id,@CDate,@L4_Rate,@Idx,@L4_Code,@L4_Name

WHILE @@FETCH_STATUS = 0
BEGIN     	
	If Not Exists (Select L4_Code From tb_Link4 Where L4_Code= @L4_Code)
	Begin 	
    		Insert Into tb_Link4 ([User_Id],[CDate],[L4_Rate],[L4_Code],[L4_Name])  Values(@User_Id,@CDate,@L4_Rate,@L4_Code,@L4_Name)	
	End
	Else
	Begin
		Update tb_Link4 Set [User_Id]=@User_Id,CDate=@CDate,L4_Rate=@L4_Rate,L4_Name=@L4_Name Where L4_Code=@L4_Code
	End
	Insert Into tb_DownloadIdx ([Iid],[lastid],[LOCA]) Values ('LN4',@Idx,@LOCATIONID)

     FETCH NEXT FROM curLink4 INTO @User_Id,@CDate,@L4_Rate,@Idx,@L4_Code,@L4_Name
END

CLOSE curLink4
DEALLOCATE curLink4

--  tb_Category DOWNLOAD

Select @lastid=IsNull(Max(LastId),0) From tb_DownloadIdx Where Iid='CAT' AND LOCA=@LOCATIONID
Delete From tb_DownloadIdx Where Iid='CAT' And LastId<@lastid AND LOCA=@LOCATIONID


DECLARE curCat CURSOR FOR 
	Select User_Id,CDate,Cat_Rate,Idx,Cat_Code,Cat_Name from 
OpenRowset('Sqloledb','123.231.63.178';'sa';'tstc123',EasyWayC.Dbo.tb_Category_Rpl)WHERE Idx>@lastid Order By Idx

OPEN curCat

FETCH NEXT FROM curCat INTO @User_Id,@CDate,@Cat_Rate,@Idx,@Cat_Code,@Cat_Name

WHILE @@FETCH_STATUS = 0
BEGIN     	
	If Not Exists (Select Cat_Code From tb_Category Where Cat_Code= @Cat_Code)
	Begin 	
    		Insert Into tb_Category ([User_Id],[CDate],[Cat_Rate],[Cat_Code],[Cat_Name]) Values (@User_Id,@CDate,@Cat_Rate,@Cat_Code,@Cat_Name)			
	End
	Else
	Begin
		Update tb_Category Set Cat_Name=@Cat_Name,[User_Id]=@User_Id,[CDate]=@CDate,[Cat_Rate]=@Cat_Rate Where Cat_Code=@Cat_Code
	End
	Insert Into tb_DownloadIdx ([Iid],[lastid],[LOCA]) Values ('CAT',@Idx,@LOCATIONID)
        FETCH NEXT FROM curCat	INTO @User_Id,@CDate,@Cat_Rate,@Idx,@Cat_Code,@Cat_Name

END

CLOSE curCat
DEALLOCATE curCat


--  tb_SubCategory DOWNLOAD

Select @lastid=IsNull(Max(LastId),0) From tb_DownloadIdx Where Iid='SCAT' AND LOCA=@LOCATIONID
Delete From tb_DownloadIdx Where Iid='SCAT' And LastId<@lastid AND LOCA=@LOCATIONID


DECLARE curSubCat CURSOR FOR 
	Select Idx,CDate,User_Id,Cat_Code,SubCat_Code,SubCat_Name from 
OpenRowset('Sqloledb','123.231.63.178';'sa';'tstc123',EasyWayC.Dbo.tb_SubCategory_Rpl)WHERE Idx>@lastid Order By Idx

OPEN curSubCat

FETCH NEXT FROM curSubCat INTO @Idx,@CDate,@User_Id,@Cat_Code,@SubCat_Code,@SubCat_Name

WHILE @@FETCH_STATUS = 0
BEGIN     	
	If Not Exists (Select Cat_Code From tb_SubCategory Where Cat_Code= @Cat_Code And SubCat_Code=@SubCat_Code)
	Begin 
    		Insert Into tb_SubCategory ([CDate],[User_Id],[Cat_Code],[SubCat_Code],[SubCat_Name])  Values (@CDate,@User_Id,@Cat_Code,@SubCat_Code,@SubCat_Name)		
	End
	Else
	Begin
		Update tb_SubCategory Set [CDate] =@CDate ,[User_Id]=@User_Id   ,[SubCat_Name] =@SubCat_Name Where [SubCat_Code]=@SubCat_Code And [Cat_Code]=@Cat_Code
	End
	Insert Into tb_DownloadIdx ([Iid],[lastid],[LOCA]) Values ('SCAT',@Idx,@LOCATIONID)
        FETCH NEXT FROM curSubCat
	INTO @Idx,@CDate,@User_Id,@Cat_Code,@SubCat_Code,@SubCat_Name

END

CLOSE curSubCat
DEALLOCATE curSubCat


-- tb_Item DOWNLOAD

Select @lastid=IsNull(Max(LastId),0) From tb_DownloadIdx Where Iid='ITM' AND LOCA=@LOCATIONID
Delete From tb_DownloadIdx Where Iid='ITM' And LastId<@lastid AND LOCA=@LOCATIONID

DECLARE curItem CURSOR FOR Select Item_Code,Ref_Code,Barcode,Inv_Descrip,Descrip,Cat_Code,SubCat_Code,L1_Code,L2_Code,L3_Code,L4_Code,L5_Code,L6_Code,L7_Code,Supp_Code,Pack_Size,W_Margine,R_Margine,
	PUnit,EUnit,Tax1,Tax2,Tax3,MaxPrice,Countable,Use_Exp,ComRate,ItemType,ConvertFact,ConvertFactUnit,Idx,Consign,OpenPrice,AutoSerial,isCombined,isTaxApply,Intergration_Upload
       from 
	OpenRowset('Sqloledb','123.231.63.178';'sa';'tstc123',EasyWayC.Dbo.tb_Item_Rpl)WHERE Idx>@lastid Order By Idx

OPEN curItem

FETCH NEXT FROM curItem INTO @Item_Code,@Ref_Code,@Barcode,@Inv_Descrip,@Descrip,@Cat_Code,@SubCat_Code,@L1_Code,@L2_Code,@L3_Code,@L4_Code,@L5_Code,@L6_Code,@L7_Code,@Supp_Code,@Pack_Size,@W_Margine,@R_Margine,
@PUnit,@EUnit,@Tax1,@Tax2,@Tax3,@MaxPrice,@Countable,@Use_Exp,@ComRate,@ItemType,@ConvertFact,@ConvertFactUnit,@Idx,@Consign,@OpenPrice,@AutoSerial,@isCombined,@isTaxApply,@Intergration_Upload

WHILE @@FETCH_STATUS = 0
BEGIN     	
	IF (Not Exists(Select Item_Code From tb_Item Where Item_Code =@Item_Code))	
	Begin
	    Insert Into tb_Item ([Item_Code],[Ref_Code],[Barcode],[Inv_Descrip],[Descrip],[SinhalaDescrip],[Cat_Code],[SubCat_Code],[L1_Code],[L2_Code],[L3_Code],[L4_Code],[L5_Code],[L6_Code],[L7_Code],[Supp_Code],[Pack_Size],[W_Margine],
		[R_Margine],[PUnit],[EUnit],[Tax1],[Tax2],[Tax3],[MaxPrice],[Countable],[Use_Exp],[ComRate],[ItemType],[ConvertFact],[ConvertFactUnit],[Consign],[OpenPrice],[AutoSerial],[isCombined],[isTaxApply],[Intergration_Upload],[isNbtApply]) 
		Values(@Item_Code,@Ref_Code,@Barcode,@Inv_Descrip,@Descrip,'',@Cat_Code,@SubCat_Code,@L1_Code,@L2_Code,@L3_Code,@L4_Code,@L5_Code,@L6_Code,@L7_Code,@Supp_Code,@Pack_Size,@W_Margine,
		@R_Margine,@PUnit,@EUnit,@Tax1,@Tax2,@Tax3,@MaxPrice,@Countable,@Use_Exp,@ComRate,@ItemType,@ConvertFact,@ConvertFactUnit,@Consign,@OpenPrice,@AutoSerial,@isCombined,@isTaxApply,0,0)
	End
	Else
	Begin
		Update tb_Item Set 	[Ref_Code]	=@Ref_Code					
					,[Barcode]		=@Barcode
					,[Inv_Descrip]	=@Inv_Descrip
					,[Descrip]		=@Descrip
					,[SinhalaDescrip]=''
					,[Cat_Code]		=@Cat_Code
					,[SubCat_Code]	=@SubCat_Code
					,[L1_Code]		=@L1_Code
					,[L2_Code]		=@L2_Code
					,[L3_Code]		=@L3_Code
					,[L4_Code]		=@L4_Code
					,[L5_Code]		=@L5_Code
					,[L6_Code]		=@L6_Code
					,[L7_Code]		=@L7_Code
					,[Supp_Code]	=@Supp_Code
					,[Pack_Size]	=@Pack_Size
					,[W_Margine]	=@W_Margine
					,[R_Margine]	=@R_Margine
					,[PUnit]		=@PUnit
					,[EUnit]		=@EUnit
					,[Tax1]			=@Tax1
					,[Tax2]			=@Tax2
					,[Tax3]			=@Tax3
					,[MaxPrice]=@MaxPrice
					,[Countable]	=@Countable
					,[Use_Exp]		=@Use_Exp
					,[ComRate]		=@ComRate
					,[ItemType]		=@ItemType
					,[ConvertFact]	=@ConvertFact
					,[ConvertFactUnit]=@ConvertFactUnit
					,[Consign]		=@Consign
					,[OpenPrice]	=@OpenPrice
					,[AutoSerial]=@AutoSerial 
					,[isCombined]=@isCombined
					,[isTaxApply]=@isTaxApply
					,[Intergration_Upload]=0
					,isNbtApply=0
					Where Item_Code=@Item_Code
 
	End 
	Insert Into tb_DownloadIdx ([Iid],[lastid],[LOCA]) Values ('ITM',@Idx,@LOCATIONID)

	FETCH NEXT FROM curItem INTO @Item_Code,@Ref_Code,@Barcode,@Inv_Descrip,@Descrip,@Cat_Code,@SubCat_Code,@L1_Code,@L2_Code,@L3_Code,@L4_Code,@L5_Code,@L6_Code,@L7_Code,@Supp_Code,@Pack_Size,@W_Margine,@R_Margine,
	@PUnit,@EUnit,@Tax1,@Tax2,@Tax3,@MaxPrice,@Countable,@Use_Exp,@ComRate,@ItemType,@ConvertFact,@ConvertFactUnit,@Idx,@Consign,@OpenPrice,@AutoSerial,@isCombined,
@isTaxApply,@Intergration_Upload
END

CLOSE curItem
DEALLOCATE curItem


--  tb_ItemDet DOWNLOAD

Select @lastid=IsNull(Max(LastId),0) From tb_DownloadIdx Where Iid='ITD' AND LOCA=@LOCATIONID
Delete From tb_DownloadIdx Where Iid='ITD' And LastId<@lastid AND LOCA=@LOCATIONID

DECLARE curItemDet CURSOR FOR 
	Select Idx ,Item_Code,Loca_Code,PRet_Price,PWhole_Price,PSp_Price,ERet_Price,EWhole_Price,ESp_Price,Cost_Price
	,AvgCost,Cost_Code,Lock_S,Lock_P,NoDiscount,Re_Qty,Rol,Qty,[User_Id],CDate,EditDate,BinNo,SPQ,SPR,TPQ,TPR
	,FPQ,FPR,FIPQ,FIPR,SIPQ,SIPR,SEPQ,SEPR,EIPQ,EIPR,Commission  from 
	OpenRowset('Sqloledb','123.231.63.178';'sa';'tstc123',EasyWayC.Dbo.tb_ItemDet_Rpl)WHERE loca_code='02' and Idx>@lastid Order By Idx

OPEN curItemDet

	FETCH NEXT FROM curItemDet
	INTO @Idx ,@Item_Code,@Loca_Code,@PRet_Price,@PWhole_Price,@PSp_Price,@ERet_Price,@EWhole_Price,@ESp_Price,@Cost_Price
	,@AvgCost,@Cost_Code,@Lock_S,@Lock_P,@NoDiscount,@Re_Qty,@Rol,@Qty,@User_Id,@CDate,@EditDate,@BinNo,@SPQ,@SPR,@TPQ,@TPR
	,@FPQ,@FPR,@FIPQ,@FIPR,@SIPQ,@SIPR,@SEPQ,@SEPR,@EIPQ,@EIPR,@Commission 

WHILE @@FETCH_STATUS = 0
BEGIN     	
	If Not Exists (Select Item_Code From tb_ItemDet Where Item_Code=@Item_Code and Loca_Code=@Loca_Code)
	Begin
    	Insert Into tb_ItemDet (Item_Code,Loca_Code,PRet_Price,PWhole_Price,PSp_Price,ERet_Price,EWhole_Price,ESp_Price,Cost_Price
		,AvgCost,Cost_Code,Lock_S,Lock_P,NoDiscount,Re_Qty,Rol,Qty,[User_Id],CDate,EditDate,BinNo,SPQ,SPR,TPQ,TPR
		,FPQ,FPR,FIPQ,FIPR,SIPQ,SIPR,SEPQ,SEPR,EIPQ,EIPR,Commission ) 
		Values(@Item_Code,@Loca_Code,@PRet_Price,@PWhole_Price,@PSp_Price,@ERet_Price,@EWhole_Price,@ESp_Price,0
		,0,@Cost_Code,@Lock_S,@Lock_P,@NoDiscount,@Re_Qty,@Rol,@Qty,@User_Id,@CDate,@EditDate,@BinNo,@SPQ,@SPR,@TPQ,@TPR
		,@FPQ,@FPR,@FIPQ,@FIPR,@SIPQ,@SIPR,@SEPQ,@SEPR,@EIPQ,@EIPR,@Commission )
	End
	Else
	Begin
		Update  tb_ItemDet Set 
		PRet_Price=@PRet_Price,
		PWhole_Price=@PWhole_Price,
		PSp_Price=@PSp_Price,
		ERet_Price=@ERet_Price,
		EWhole_Price=@EWhole_Price,
		ESp_Price=@ESp_Price,
		Lock_S=@Lock_S,
		Lock_P=@Lock_P,
		NoDiscount=@NoDiscount,
		Re_Qty=@Re_Qty,
		Rol=@Rol,
		[User_Id]=@User_Id,
		CDate=@CDate,
		EditDate=@EditDate,
		BinNo=@BinNo,
		SPQ=@SPQ,
		SPR=@SPR,
		TPQ=@TPQ,
		TPR=@TPR,
		FPQ=@FPQ,
		FPR=@FPR,
		FIPQ=@FIPQ,
		FIPR=@FIPR,
		SIPQ=@SIPQ,
		SIPR=@SIPR,
		SEPQ=@SEPQ,
		SEPR=@SEPR,
		EIPQ=@EIPQ,
		EIPR=@EIPR,
		Commission =@Commission 
		Where Item_Code=@item_Code And Loca_Code=@Loca_Code
	End
	Insert Into tb_DownloadIdx ([Iid],[lastid],[LOCA]) Values ('ITD',@Idx,@LOCATIONID)

    FETCH NEXT FROM curItemDet
	INTO @Idx ,@Item_Code,@Loca_Code,@PRet_Price,@PWhole_Price,@PSp_Price,@ERet_Price,@EWhole_Price,@ESp_Price,@Cost_Price
	,@AvgCost,@Cost_Code,@Lock_S,@Lock_P,@NoDiscount,@Re_Qty,@Rol,@Qty,@User_Id,@CDate,@EditDate,@BinNo,@SPQ,@SPR,@TPQ,@TPR
	,@FPQ,@FPR,@FIPQ,@FIPR,@SIPQ,@SIPR,@SEPQ,@SEPR,@EIPQ,@EIPR,@Commission 

END

CLOSE curItemDet
DEALLOCATE curItemDet

--  tb_Colour_Size DOWNLOAD

Select @lastid=IsNull(Max(LastId),0) From tb_DownloadIdx Where Iid='ITC' AND LOCA=@LOCATIONID
Delete From tb_DownloadIdx Where Iid='ITC' And LastId<@lastid AND LOCA=@LOCATIONID


DECLARE curItemColour CURSOR FOR 
	Select ItemCode, CSCode, CSName, Rate, Price, Qty, Discount, CCode, SCode, @LOCATIONID, Idx from 
	OpenRowset('Sqloledb','123.231.63.178';'sa';'tstc123',EasyWayC.Dbo.tb_Colour_Size)WHERE locacode='01' and Idx>@lastid Order By Idx

OPEN curItemColour

	FETCH NEXT FROM curItemColour
	INTO @ItemCode,@CSCode,@CSName,@Rate,@Price,@Qty,@Discount,@CCode,@SCode,@LocaCode,@Idx

WHILE @@FETCH_STATUS = 0
BEGIN     	
	If Not Exists (Select ItemCode From tb_Colour_Size Where CSCode=@CSCode and LocaCode=@LocaCode)
	Begin
    		Insert Into tb_Colour_Size ([ItemCode],[CSCode],[CSName],[Rate],[Price],[Qty],[Discount],[CCode],[SCode],[LocaCode]) 
                Values(@ItemCode,@CSCode,@CSName,@Rate,@Price,@Qty,@Discount,@CCode,@SCode,@LocaCode)
	End
	Else
	Begin
		Update  tb_Colour_Size Set 

			 [ItemCode]=@ItemCode
			,[CSCode]  =@CSCode
			,[CSName]  =@CSName
			,[Rate]    =@Rate
			,[Price]   =@Price
			,[Qty]     =@Qty
			,[Discount]=@Discount
			,[CCode]   =@CCode
			,[SCode]   =@SCode
			,[LocaCode]=@LocaCode

		Where CSCode=@CSCode And LocaCode=@LocaCode
	End
	Insert Into tb_DownloadIdx ([Iid],[lastid],[LOCA]) Values ('ITC',@Idx,@LOCATIONID)

        	FETCH NEXT FROM curItemColour
	INTO @ItemCode,@CSCode,@CSName,@Rate,@Price,@Qty,@Discount,@CCode,@SCode,@LocaCode,@Idx
END

CLOSE curItemColour
DEALLOCATE curItemColour

--  tb_SalesRep DOWNLOAD

--delete from tb_salesrep
--delete from tb_downloadidx where iid='REP'

Select @lastid=IsNull(Max(LastId),0) From tb_DownloadIdx Where Iid='REP' AND LOCA=@LOCATIONID
Delete From tb_DownloadIdx Where Iid='REP' And LastId<@lastid AND LOCA=@LOCATIONID


DECLARE curRep CURSOR FOR 
	Select Rep_Code,Rep_Name,Contact_Name,Contact_No,Address1,Address2,Address3,Country,Phone1,Phone2,Phone3,Fax,Email,Web_Site,CommRate,TargetAmt,Rep,CDate,State,User_Id,Locacode,Log from 
	OpenRowset('Sqloledb','123.231.63.178';'sa';'tstc123',EasyWayC.Dbo.tb_SalesRep_Rpl)WHERE Idx>@lastid Order By Idx

OPEN curRep

	FETCH NEXT FROM curRep
	INTO @Rep_Code,@Rep_Name,@Contact_Name,@Contact_No,@Address1,@Address2,@Address3,@Country,@Phone1,@Phone2,
	@Phone3,@Fax,@Email,@Web_Site,@CommRate,@TargetAmt,@Rep,@CDate,@State,@User_Id,@Locacode,@Log
WHILE @@FETCH_STATUS = 0
BEGIN     
    If Not Exists(Select Rep_Code From tb_SalesRep Where 	Rep_Code=@Rep_Code)
    Begin
	   Insert Into tb_SalesRep ([Rep_Code],[Rep_Name],[Contact_Name],[Contact_No],[Address1],[Address2],[Address3],[Country],[Phone1],[Phone2],[Phone3],[Fax],[Email],[Web_Site],[CommRate],[TargetAmt],[Rep],[CDate],[State],[User_Id],[Locacode],[Log])
	   Values (@Rep_Code,@Rep_Name,@Contact_Name,@Contact_No,@Address1,@Address2,@Address3,@Country,@Phone1,@Phone2,
	   @Phone3,@Fax,@Email,@Web_Site,@CommRate,@TargetAmt,@Rep,@CDate,@State,@User_Id,@Locacode,@Log)
    End
    Else
    Begin
       Update tb_SalesRep Set [Rep_Name]=@Rep_Name ,[Contact_Name]=@Contact_Name,[Contact_No]=@Contact_No,[Address1]=@Address1
       ,[Address2]=@Address2,[Address3]=@Address3,[Country]=@Country,[Phone1]=@Phone1,[Phone2]=@Phone2,[Phone3]=@Phone3,
       [Fax]=@Fax,[Email]=@Email,[Web_Site]=@Web_Site,[CommRate]=@CommRate,[TargetAmt]=@TargetAmt,[Rep]=@Rep,
       [CDate]=@CDate,[State]=@State,[User_Id]=@User_Id,[Locacode]=@Locacode,[Log]=@Log Where Rep_Code=@Rep_Code	   
    End
	Insert Into tb_DownloadIdx ([Iid],[lastid],[LOCA]) Values ('REP',@Idx,@LOCATIONID)

	FETCH NEXT FROM curRep
	INTO @Rep_Code,@Rep_Name,@Contact_Name,@Contact_No,@Address1,@Address2,@Address3,@Country,@Phone1,@Phone2,
	@Phone3,@Fax,@Email,@Web_Site,@CommRate,@TargetAmt,@Rep,@CDate,@State,@User_Id,@Locacode,@Log
END

CLOSE curRep
DEALLOCATE curRep






GO

