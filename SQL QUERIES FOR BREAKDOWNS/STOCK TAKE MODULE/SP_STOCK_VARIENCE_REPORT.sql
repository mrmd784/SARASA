USE [EASYWAY]
GO

/****** Object:  StoredProcedure [dbo].[SP_STOCK_VARIENCE_REPORT]    Script Date: 2024-03-01 11:39:21 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[SP_STOCK_VARIENCE_REPORT]
@LOCA		VARCHAR(5),
@CODE1		VARCHAR(20),
@CODE2		VARCHAR(20),
@ID			INT,
@TYPE		INT,
@USERNAME	VARCHAR(10),
@REFNO		VARCHAR(10),
@COLOURNSIZE INT
AS
BEGIN
-- @TYPE = 0 All Else selection
-- @ID = 1 Item Wise
-- @ID = 2 Category Wise
-- @ID = 3 Sub-Category Wise
-- @ID = 4 Supplier Wise
-- @ID = 5 BinLocation Wise

Declare @Sql As Varchar(MAX)
Declare @CNo As NVarchar(10)
Set @CNo=0
If RTRIM(@REFNO)<>''
Begin
	Select @CNo=CNo from tb_Stock_Backup Where StockCountRef=RTRIM(@REFNO)
	If (Rtrim(@CODE1)='' And RTRIM(@CODE2)='')
	Begin
		Select @CODE1=MIN(ItemCode) from tb_Stock_Backup Where StockCountRef=RTRIM(@REFNO) And CNo=@CNo
		Select @CODE2=MAX(ItemCode) from tb_Stock_Backup Where StockCountRef=RTRIM(@REFNO) And CNo=@CNo
	End	
End


IF @COLOURNSIZE = 0
BEGIN 
Set @Sql='Alter View vw_StockBalCL As Select ItemCode,LocaCode,
Isnull(Sum(Case [Id] When ''OPB'' Then (PackSize*Qty) When ''PCH'' Then (PackSize*Qty) When ''PRN'' '+ 
'Then -(PackSize*Qty) When ''INV'' Then -(PackSize*Qty) When ''MKR'' Then (PackSize*Qty) When ''DMG'' '+ 
'Then -(PackSize*Qty) When ''PRD'' Then -(PackSize*Qty) When ''DSC'' Then -(PackSize*Qty) When ''ADD'' '+ 
'Then (PackSize*Qty) When ''TOG'' Then -(PackSize*Qty) When ''IN1'' Then (PackSize*Qty) When ''IN2'' ' +
'Then (PackSize*Qty) When ''AOD'' Then -(PackSize*Qty) Else 0 End),0) As Stock From  tb_Stock_Backup ' +
'Where LocaCode=''' + @LOCA + ''' And CNo=' + @CNo + ' And [Status]=1 Group By LocaCode,ItemCode '

Exec (@Sql)
print (@Sql)

Set @Sql='Alter View vw_StockBalOp As Select ItemCode,LocaCode,Isnull(Sum(Case [Id] When ''OPB'' Then (PackSize*Qty) When ''PCH'' ' + 
'Then (PackSize*Qty) When ''PRN'' Then -(PackSize*Qty) When ''INV'' Then -(PackSize*Qty) When ''MKR'' Then (PackSize*Qty) ' +
'When ''DMG'' Then -(PackSize*Qty) When ''PRD'' Then -(PackSize*Qty) When ''DSC'' Then -(PackSize*Qty) When ''ADD'' Then (PackSize*Qty) ' +
'When ''TOG'' Then -(PackSize*Qty) When ''IN1'' Then (PackSize*Qty) When ''IN2'' Then (PackSize*Qty) When ''AOD'' Then -(PackSize*Qty) ' +
'Else 0 End),0) As Stock From  tb_Stock_OpBal  Where LocaCode=''' + @LOCA + ''' And CNo=' + @CNo + ' And Status=1 Group By LocaCode,ItemCode'

Exec (@Sql)
print (@Sql)
END
ELSE
BEGIN 

Set @Sql='Alter View vw_StockBalCL As Select ItemCode,LocaCode,CSCode,
Isnull(Sum(Case [Id] When ''OPB'' Then (PackSize*Qty) When ''PCH'' Then (PackSize*Qty) When ''PRN'' '+ 
'Then -(PackSize*Qty) When ''INV'' Then -(PackSize*Qty) When ''MKR'' Then (PackSize*Qty) When ''DMG'' '+ 
'Then -(PackSize*Qty) When ''PRD'' Then -(PackSize*Qty) When ''DSC'' Then -(PackSize*Qty) When ''ADD'' '+ 
'Then (PackSize*Qty) When ''TOG'' Then -(PackSize*Qty) When ''IN1'' Then (PackSize*Qty) When ''IN2'' ' +
'Then (PackSize*Qty) When ''AOD'' Then -(PackSize*Qty) Else 0 End),0) As Stock From  tb_Stock_Backup ' +
'Where LocaCode=''' + @LOCA + ''' And CNo=' + @CNo + ' And [Status]=1 Group By LocaCode,ItemCode,CSCode '

Exec (@Sql)
PRINT (@Sql)

Set @Sql='Alter View vw_StockBalOp As Select ItemCode,LocaCode,CSCode,Isnull(Sum(Case [Id] When ''OPB'' Then (PackSize*Qty) When ''PCH'' ' + 
'Then (PackSize*Qty) When ''PRN'' Then -(PackSize*Qty) When ''INV'' Then -(PackSize*Qty) When ''MKR'' Then (PackSize*Qty) ' +
'When ''DMG'' Then -(PackSize*Qty) When ''PRD'' Then -(PackSize*Qty) When ''DSC'' Then -(PackSize*Qty) When ''ADD'' Then (PackSize*Qty) ' +
'When ''TOG'' Then -(PackSize*Qty) When ''IN1'' Then (PackSize*Qty) When ''IN2'' Then (PackSize*Qty) When ''AOD'' Then -(PackSize*Qty) ' +
'Else 0 End),0) As Stock From  tb_Stock_OpBal  Where LocaCode=''' + @LOCA + ''' And CNo=' + @CNo + ' And Status=1 Group By LocaCode,ItemCode,CSCode '

Exec (@Sql)
PRINT (@Sql)

END

IF @ID = 1
BEGIN
IF @COLOURNSIZE = 0
BEGIN 
	IF @TYPE = 1 --Item Wise
		BEGIN
			SELECT tb_ItemDet.ERet_Price, tb_ItemDet.Cost_Price,tb_Item.Descrip,
			ISNULL(vw_StockBalCL.Stock,0) AS Stock, tb_Item.Item_Code,ISNULL(vw_StockBalOp.Stock,0) AS Stock
			FROM (((tb_ItemDet 
			INNER JOIN  tb_Item ON  tb_ItemDet.Item_Code = tb_Item.Item_Code) 
			LEFT OUTER JOIN vw_StockBalCL ON tb_Item.Item_Code = vw_StockBalCL.ItemCode) 
			LEFT OUTER JOIN vw_StockBalOp ON tb_Item.Item_Code = vw_StockBalOp.ItemCode) 
			WHERE tb_Item.Item_Code BETWEEN @CODE1 AND  @CODE2 
			AND  tb_ItemDet.Loca_Code = @LOCA AND tb_Item.Use_Exp <> 3
			ORDER BY tb_Item.Item_Code ASC
		END
	ELSE
		BEGIN
			SELECT tb_ItemDet.ERet_Price, tb_ItemDet.Cost_Price,tb_Item.Descrip,
			ISNULL(vw_StockBalCL.Stock,0) AS Stock,tb_Item.Item_Code,ISNULL(vw_StockBalOp.Stock,0) AS Stock
			FROM (((tb_ItemDet 
			INNER JOIN  tb_Item ON  tb_ItemDet.Item_Code = tb_Item.Item_Code)
			LEFT OUTER JOIN vw_StockBalCL ON tb_Item.Item_Code = vw_StockBalCL.ItemCode) 
			LEFT OUTER JOIN vw_StockBalOp ON tb_Item.Item_Code = vw_StockBalOp.ItemCode) 
			WHERE tb_Item.Item_Code IN (SELECT Code FROM tb_TempSelect WHERE UserName=@USERNAME  AND [ID]='OIT' AND LocaCode=@LOCA)  
			AND  tb_ItemDet.Loca_Code = @LOCA AND tb_Item.Use_Exp <> 3
			ORDER BY tb_Item.Item_Code ASC
		END
END
ELSE
BEGIN 
IF @TYPE = 1 --Item Wise
	BEGIN
		SET @Sql = ''
		Set @Sql=' SELECT tb_ItemDet.ERet_Price,tb_ItemDet.Cost_Price,tb_Item.Descrip,
		ISNULL(vw_StockBalCL.Stock,0) AS Stock,tb_Item.Item_Code,ISNULL(vw_StockBalOp.Stock,0) AS Stock,
		tb_Colour_Size.CSCode,tb_Colour_Size.CSName
		FROM ((((tb_ItemDet 
		INNER JOIN  tb_Item ON  tb_ItemDet.Item_Code = tb_Item.Item_Code)
		INNER JOIN tb_Colour_Size ON tb_ItemDet.Item_Code = tb_Colour_Size.ItemCode AND tb_Colour_Size.LocaCode = '''+@LOCA+''')
		LEFT OUTER JOIN vw_StockBalCL ON tb_Item.Item_Code = vw_StockBalCL.ItemCode AND tb_Colour_Size.CSCode = vw_StockBalCL.CSCode) 
		LEFT OUTER JOIN vw_StockBalOp ON tb_Item.Item_Code = vw_StockBalOp.ItemCode AND tb_Colour_Size.CSCode = vw_StockBalOp.CSCode)
		WHERE tb_Item.Item_Code BETWEEN '''+ @CODE1 +''' AND  '''+@CODE2+''' AND  tb_ItemDet.Loca_Code = '''+@LOCA+''' AND tb_Item.Use_Exp = 3
		ORDER BY tb_Item.Item_Code ASC '
		EXEC(@Sql);
		PRINT(@Sql);
	END
ELSE
	BEGIN
		SET @Sql = ''
		SET @Sql = 'SELECT tb_ItemDet.ERet_Price,tb_ItemDet.Cost_Price,tb_Item.Descrip,
		ISNULL(vw_StockBalCL.Stock,0) AS Stock,tb_Item.Item_Code,ISNULL(vw_StockBalOp.Stock,0) AS Stock,
		tb_Colour_Size.CSCode,tb_Colour_Size.CSName
		FROM ((((tb_ItemDet 
		INNER JOIN  tb_Item ON  tb_ItemDet.Item_Code = tb_Item.Item_Code)
		LEFT JOIN tb_Colour_Size ON tb_ItemDet.Item_Code = tb_Colour_Size.ItemCode AND tb_Colour_Size.LocaCode = '''+@LOCA+''')
		LEFT OUTER JOIN vw_StockBalCL ON tb_Item.Item_Code = vw_StockBalCL.ItemCode AND tb_Colour_Size.CSCode = vw_StockBalCL.CSCode) 
		LEFT OUTER JOIN vw_StockBalOp ON tb_Item.Item_Code = vw_StockBalOp.ItemCode AND tb_Colour_Size.CSCode = vw_StockBalOp.CSCode)
		WHERE tb_Item.Item_Code IN (SELECT Code FROM tb_TempSelect WHERE UserName='''+@USERNAME+'''  AND [ID]=''OIT'' AND LocaCode='''+@LOCA+''')  
		AND  tb_ItemDet.Loca_Code = '''+@LOCA+''' AND tb_Item.Use_Exp = 3
		ORDER BY tb_Item.Item_Code ASC '
		EXEC(@Sql);
		PRINT(@Sql);
	END
END
END
ELSE IF @ID = 2 --Category Wise
BEGIN
IF @COLOURNSIZE = 0
BEGIN
	IF @TYPE = 1
		BEGIN
			SELECT tb_ItemDet.ERet_Price, tb_ItemDet.Cost_Price,tb_Item.Descrip, tb_Item.Cat_Code, tb_Item.SubCat_Code,
			tb_Category.Cat_Name , tb_SubCategory.SubCat_Code,ISNULL(vw_StockBalCL.Stock,0)AS Stock,tb_Item.Item_Code,ISNULL(vw_StockBalOp.Stock,0) AS Stock 
			FROM (((((tb_ItemDet INNER JOIN  tb_Item ON  tb_ItemDet.Item_Code = tb_Item.Item_Code) 
			INNER JOIN tb_SubCategory ON  tb_Item.SubCat_Code = tb_SubCategory.SubCat_Code) 
			LEFT OUTER JOIN vw_StockBalCL ON tb_Item.Item_Code = vw_StockBalCL.ItemCode) 
			LEFT OUTER JOIN vw_StockBalOp ON tb_Item.Item_Code = vw_StockBalOp.ItemCode) 
			INNER JOIN tb_Category ON tb_Item.Cat_Code = tb_Category.Cat_Code) 
			WHERE tb_Item.Cat_Code BETWEEN @CODE1 AND @CODE2 AND  tb_ItemDet.Loca_Code = @LOCA AND tb_Item.Use_Exp <> 3
			ORDER BY tb_Item.Cat_Code ASC,tb_Item.SubCat_Code ASC,tb_Item.Item_Code ASC
		END
	ELSE
		BEGIN
			SELECT tb_ItemDet.ERet_Price, tb_ItemDet.Cost_Price,tb_Item.Descrip, tb_Item.Cat_Code, tb_Item.SubCat_Code,
			tb_Category.Cat_Name , tb_SubCategory.SubCat_Code,ISNULL(vw_StockBalCL.Stock,0)AS Stock,tb_Item.Item_Code,ISNULL(vw_StockBalOp.Stock,0) AS Stock 
			FROM (((((tb_ItemDet 
			INNER JOIN  tb_Item ON  tb_ItemDet.Item_Code = tb_Item.Item_Code) 
			INNER JOIN tb_SubCategory ON  tb_Item.SubCat_Code = tb_SubCategory.SubCat_Code) 
			LEFT OUTER JOIN vw_StockBalCL ON tb_Item.Item_Code = vw_StockBalCL.ItemCode) 
			LEFT OUTER JOIN vw_StockBalOp ON tb_Item.Item_Code = vw_StockBalOp.ItemCode) 
			INNER JOIN tb_Category ON tb_Item.Cat_Code = tb_Category.Cat_Code) 
			WHERE tb_Item.Cat_Code IN (SELECT Code FROM tb_TempSelect WHERE UserName=@USERNAME AND [ID]='OCT' AND LocaCode=@LOCA)  
			AND  tb_ItemDet.Loca_Code = @LOCA AND tb_Item.Use_Exp <> 3
			ORDER BY tb_Item.Cat_Code ASC,tb_Item.SubCat_Code ASC,tb_Item.Item_Code ASC
		END
END
ELSE
BEGIN
	IF @TYPE = 1
		BEGIN
			SET @Sql = ''
			SET @Sql = ' SELECT tb_ItemDet.ERet_Price,tb_ItemDet.Cost_Price,tb_Item.Descrip,tb_Item.Cat_Code,tb_Item.SubCat_Code,
			tb_Category.Cat_Name , tb_SubCategory.SubCat_Code,ISNULL(vw_StockBalCL.Stock,0) AS Stock,tb_Item.Item_Code,ISNULL(vw_StockBalOp.Stock,0) AS Stock,
			tb_Colour_Size.CSCode,tb_Colour_Size.CSName
			FROM ((((((tb_ItemDet 
			INNER JOIN  tb_Item ON  tb_ItemDet.Item_Code = tb_Item.Item_Code) 
			INNER JOIN tb_Colour_Size ON tb_ItemDet.Item_Code = tb_Colour_Size.ItemCode AND tb_Colour_Size.LocaCode = '''+@LOCA+''')
			INNER JOIN tb_SubCategory ON  tb_Item.SubCat_Code = tb_SubCategory.SubCat_Code) 
			LEFT OUTER JOIN vw_StockBalCL ON tb_Item.Item_Code = vw_StockBalCL.ItemCode AND tb_Colour_Size.CSCode = vw_StockBalCL.CSCode) 
			LEFT OUTER JOIN vw_StockBalOp ON tb_Item.Item_Code = vw_StockBalOp.ItemCode AND tb_Colour_Size.CSCode = vw_StockBalOp.CSCode)  
			INNER JOIN tb_Category ON tb_Item.Cat_Code = tb_Category.Cat_Code) 
			WHERE tb_Item.Cat_Code BETWEEN '''+@CODE1+''' AND '''+@CODE2+''' AND  tb_ItemDet.Loca_Code = '''+@LOCA+''' AND tb_Item.Use_Exp = 3
			ORDER BY tb_Item.Cat_Code ASC,tb_Item.SubCat_Code ASC,tb_Item.Item_Code ASC '
			EXEC(@Sql);
			--PRINT(@Sql);
		END
	ELSE
		BEGIN
			SET @Sql = ''
			SET @Sql = ' SELECT tb_ItemDet.ERet_Price, tb_ItemDet.Cost_Price,tb_Item.Descrip, tb_Item.Cat_Code, tb_Item.SubCat_Code,
			tb_Category.Cat_Name , tb_SubCategory.SubCat_Code,ISNULL(vw_StockBalCL.Stock,0) AS Stock, tb_Item.Item_Code,ISNULL(vw_StockBalOp.Stock,0) AS Stock,
			tb_Colour_Size.CSCode,tb_Colour_Size.CSName
			FROM ((((((tb_ItemDet 
			INNER JOIN  tb_Item ON  tb_ItemDet.Item_Code = tb_Item.Item_Code) 
			INNER JOIN tb_Colour_Size ON tb_ItemDet.Item_Code = tb_Colour_Size.ItemCode AND tb_Colour_Size.LocaCode = '''+@LOCA+''')
			INNER JOIN tb_SubCategory ON  tb_Item.SubCat_Code = tb_SubCategory.SubCat_Code) 
			LEFT OUTER JOIN vw_StockBalCL ON tb_Item.Item_Code = vw_StockBalCL.ItemCode  AND tb_Colour_Size.CSCode = vw_StockBalCL.CSCode) 
			LEFT OUTER JOIN vw_StockBalOp ON tb_Item.Item_Code = vw_StockBalOp.ItemCode AND tb_Colour_Size.CSCode = vw_StockBalOp.CSCode) 
			INNER JOIN tb_Category ON tb_Item.Cat_Code = tb_Category.Cat_Code) 
			WHERE tb_Item.Cat_Code IN (SELECT Code FROM tb_TempSelect WHERE UserName='''+@USERNAME+''' AND [ID]=''OCT'' AND LocaCode='''+@LOCA+''')  
			AND  tb_ItemDet.Loca_Code = '''+@LOCA+''' AND tb_Item.Use_Exp = 3
			ORDER BY tb_Item.Cat_Code ASC,tb_Item.SubCat_Code ASC,tb_Item.Item_Code ASC '
			EXEC(@Sql);
			--PRINT(@Sql);
		END
END
END
ELSE IF @ID = 3 --Sub-Category Wise
BEGIN
IF @COLOURNSIZE = 0
BEGIN
	IF @TYPE = 1
	BEGIN
		SELECT tb_ItemDet.ERet_Price, tb_ItemDet.Cost_Price,tb_Item.Descrip, tb_Item.SubCat_Code,
		vw_StockBalCL.Stock, tb_Item.Item_Code, vw_StockBalOp.Stock 
		FROM ((((tb_ItemDet INNER JOIN  tb_Item ON  tb_ItemDet.Item_Code = tb_Item.Item_Code) 
		INNER JOIN tb_SubCategory ON  tb_Item.SubCat_Code = tb_SubCategory.SubCat_Code) 
		LEFT OUTER JOIN vw_StockBalCL ON tb_Item.Item_Code = vw_StockBalCL.ItemCode) 
		LEFT OUTER JOIN vw_StockBalOp ON tb_Item.Item_Code = vw_StockBalOp.ItemCode) 
		WHERE tb_Item.SubCat_Code BETWEEN @CODE1 AND  @CODE2 AND  tb_ItemDet.Loca_Code = @LOCA AND tb_Item.Use_Exp <> 3
		ORDER BY tb_Item.SubCat_Code ASC,tb_Item.Item_Code ASC
	END
	ELSE
	BEGIN
		SELECT tb_ItemDet.ERet_Price, tb_ItemDet.Cost_Price,tb_Item.Descrip, tb_Item.SubCat_Code,
		ISNULL(vw_StockBalCL.Stock,0) As Stock, tb_Item.Item_Code, ISNULL(vw_StockBalOp.Stock,0) AS Stock 
		FROM ((((tb_ItemDet INNER JOIN  tb_Item ON  tb_ItemDet.Item_Code = tb_Item.Item_Code) 
		INNER JOIN tb_SubCategory ON  tb_Item.SubCat_Code = tb_SubCategory.SubCat_Code) 
		LEFT OUTER JOIN vw_StockBalCL ON tb_Item.Item_Code = vw_StockBalCL.ItemCode) 
		LEFT OUTER  JOIN vw_StockBalOp ON tb_Item.Item_Code = vw_StockBalOp.ItemCode) 
		WHERE tb_Item.SubCat_Code IN (SELECT Code FROM tb_TempSelect WHERE UserName=@USERNAME AND [ID]='OSC' AND LocaCode=@LOCA)  
		AND tb_ItemDet.Loca_Code = @LOCA AND tb_Item.Use_Exp <> 3
		ORDER BY tb_Item.SubCat_Code ASC,tb_Item.Item_Code ASC
	END
END
ELSE
BEGIN
IF @TYPE = 1
	BEGIN
		SET @Sql = ''
		SET @Sql = ' SELECT tb_ItemDet.ERet_Price, tb_ItemDet.Cost_Price,tb_Item.Descrip, tb_Item.SubCat_Code,
		ISNULL(vw_StockBalCL.Stock) AS Stock, tb_Item.Item_Code,ISNULL(vw_StockBalOp.Stock) AS Stock,
		tb_Colour_Size.CSCode,tb_Colour_Size.CSName
		FROM (((((tb_ItemDet INNER JOIN  tb_Item ON  tb_ItemDet.Item_Code = tb_Item.Item_Code) 
		INNER JOIN tb_SubCategory ON  tb_Item.SubCat_Code = tb_SubCategory.SubCat_Code) 
		INNER JOIN tb_Colour_Size ON tb_ItemDet.Item_Code = tb_Colour_Size.ItemCode AND tb_Colour_Size.LocaCode = '''+@LOCA+''')
		LEFT OUTER JOIN vw_StockBalCL ON tb_Item.Item_Code = vw_StockBalCL.ItemCode AND tb_Colour_Size.CSCode = vw_StockBalCL.CSCode) 
		LEFT OUTER JOIN vw_StockBalOp ON tb_Item.Item_Code = vw_StockBalOp.ItemCode AND tb_Colour_Size.CSCode = vw_StockBalOp.CSCode) 
		WHERE tb_Item.SubCat_Code BETWEEN '''+@CODE1+''' AND  '''+@CODE2+''' AND  tb_ItemDet.Loca_Code = '''+@LOCA+''' AND tb_Item.Use_Exp = 3
		ORDER BY tb_Item.SubCat_Code ASC,tb_Item.Item_Code ASC '
		EXEC(@Sql)
		--PRINT(@Sql)
	END
ELSE
	BEGIN
		SET @Sql = ''
		SET @Sql = ' SELECT tb_ItemDet.ERet_Price, tb_ItemDet.Cost_Price,tb_Item.Descrip, tb_Item.SubCat_Code,
		ISNULL(vw_StockBalCL.Stock,0) As Stock, tb_Item.Item_Code, ISNULL(vw_StockBalOp.Stock,0) AS Stock,
		tb_Colour_Size.CSCode,tb_Colour_Size.CSName
		FROM (((((tb_ItemDet 
		INNER JOIN  tb_Item ON  tb_ItemDet.Item_Code = tb_Item.Item_Code) 
		INNER JOIN tb_Colour_Size ON tb_ItemDet.Item_Code = tb_Colour_Size.ItemCode AND tb_Colour_Size.LocaCode = '''+@LOCA+''')
		INNER JOIN tb_SubCategory ON  tb_Item.SubCat_Code = tb_SubCategory.SubCat_Code) 
		LEFT OUTER JOIN vw_StockBalCL ON tb_Item.Item_Code = vw_StockBalCL.ItemCode AND tb_Colour_Size.CSCode = vw_StockBalCL.CSCode) 
		LEFT OUTER  JOIN vw_StockBalOp ON tb_Item.Item_Code = vw_StockBalOp.ItemCode AND tb_Colour_Size.CSCode = vw_StockBalOp.CSCode) 
		WHERE tb_Item.SubCat_Code IN (SELECT Code FROM tb_TempSelect WHERE UserName='''+@USERNAME+''' AND [ID]=''OSC'' AND LocaCode='''+@LOCA+''')  
		AND  tb_ItemDet.Loca_Code = '''+@LOCA+''' AND tb_Item.Use_Exp = 3
		ORDER BY tb_Item.SubCat_Code ASC,tb_Item.Item_Code ASC '
		EXEC(@Sql)
		--PRINT(@Sql)
	END
END
END
ELSE IF @ID = 4 --Supplier Wise
BEGIN
IF @COLOURNSIZE = 0
BEGIN
	IF @TYPE = 1
	BEGIN
		SELECT tb_ItemDet.ERet_Price, tb_ItemDet.Cost_Price,tb_Item.Descrip,tb_Item.SubCat_Code,
		tb_Supplier.Supp_Name , tb_Item.Supp_Code, vw_StockBalCL.Stock, tb_Item.Item_Code, vw_StockBalOp.Stock 
		FROM (((((tb_ItemDet INNER JOIN  tb_Item ON  tb_ItemDet.Item_Code = tb_Item.Item_Code)
		LEFT OUTER  JOIN vw_StockBalCL ON tb_Item.Item_Code = vw_StockBalCL.ItemCode) 
		LEFT OUTER JOIN vw_StockBalOp ON tb_Item.Item_Code = vw_StockBalOp.ItemCode) 
		INNER JOIN tb_Supplier ON tb_Item.Supp_Code = tb_Supplier.Supp_Code) 
		INNER JOIN tb_SubCategory ON tb_Item.SubCat_Code = tb_SubCategory.SubCat_Code) 
		WHERE tb_Item.Supp_Code BETWEEN @CODE1 AND  @CODE2 AND  tb_ItemDet.Loca_Code = @LOCA AND tb_Item.Use_Exp <> 3
		ORDER BY tb_Item.Supp_Code ASC,tb_Item.SubCat_Code ASC,tb_Item.Item_Code ASC
	END
	ELSE
	BEGIN
		SELECT tb_ItemDet.ERet_Price, tb_ItemDet.Cost_Price,tb_Item.Descrip,tb_Item.SubCat_Code,
		tb_Supplier.Supp_Name , tb_Item.Supp_Code, vw_StockBalCL.Stock, tb_Item.Item_Code, vw_StockBalOp.Stock 
		FROM (((((tb_ItemDet INNER JOIN  tb_Item ON  tb_ItemDet.Item_Code = tb_Item.Item_Code) 
		LEFT OUTER  JOIN vw_StockBalCL ON tb_Item.Item_Code = vw_StockBalCL.ItemCode) 
		LEFT OUTER JOIN vw_StockBalOp ON tb_Item.Item_Code = vw_StockBalOp.ItemCode) 
		INNER JOIN tb_Supplier ON tb_Item.Supp_Code = tb_Supplier.Supp_Code) 
		INNER JOIN tb_SubCategory ON tb_Item.SubCat_Code = tb_SubCategory.SubCat_Code) 
		WHERE tb_Item.Supp_Code IN (SELECT Code FROM tb_TempSelect WHERE UserName=@USERNAME AND [ID]='OSP' AND LocaCode=@LOCA)  
		AND  tb_ItemDet.Loca_Code = @LOCA AND tb_Item.Use_Exp <> 3
		ORDER BY tb_Item.Supp_Code ASC,tb_Item.SubCat_Code ASC,tb_Item.Item_Code ASC
	END
END
ELSE
BEGIN
IF @TYPE = 1
	BEGIN
		SET @Sql = ''
		SET @Sql = ' SELECT tb_ItemDet.ERet_Price, tb_ItemDet.Cost_Price,tb_Item.Descrip,tb_Item.SubCat_Code,
		tb_Supplier.Supp_Name , tb_Item.Supp_Code,ISNULL(vw_StockBalCL.Stock,0) AS Stock,tb_Item.Item_Code,ISNULL(vw_StockBalOp.Stock,0) AS Stock,
		tb_Colour_Size.CSCode,tb_Colour_Size.CSName
		FROM ((((((tb_ItemDet 
		INNER JOIN  tb_Item ON  tb_ItemDet.Item_Code = tb_Item.Item_Code)
		INNER JOIN tb_Colour_Size ON tb_ItemDet.Item_Code = tb_Colour_Size.ItemCode AND tb_Colour_Size.LocaCode = '''+@LOCA+''')
		LEFT OUTER  JOIN vw_StockBalCL ON tb_Item.Item_Code = vw_StockBalCL.ItemCode AND tb_Colour_Size.CSCode = vw_StockBalCL.CSCode) 
		LEFT OUTER JOIN vw_StockBalOp ON tb_Item.Item_Code = vw_StockBalOp.ItemCode AND tb_Colour_Size.CSCode = vw_StockBalOp.CSCode) 
		INNER JOIN tb_Supplier ON tb_Item.Supp_Code = tb_Supplier.Supp_Code) 
		INNER JOIN tb_SubCategory ON tb_Item.SubCat_Code = tb_SubCategory.SubCat_Code) 
		WHERE tb_Item.Supp_Code BETWEEN '''+@CODE1+''' AND  '''+@CODE2+''' AND  tb_ItemDet.Loca_Code = '''+@LOCA+'''
		AND tb_Item.Use_Exp = 3
		ORDER BY tb_Item.Supp_Code ASC,tb_Item.SubCat_Code ASC,tb_Item.Item_Code ASC '
		EXEC(@Sql)
		--PRINT(@Sql)
	END
	ELSE
	BEGIN
		SET @Sql = ''
		SET @Sql = ' SELECT tb_ItemDet.ERet_Price, tb_ItemDet.Cost_Price,tb_Item.Descrip,tb_Item.SubCat_Code,
		tb_Supplier.Supp_Name,tb_Item.Supp_Code,ISNULL(vw_StockBalCL.Stock,0) AS Stock,tb_Item.Item_Code,ISNULL(vw_StockBalOp.Stock,0) AS Stock,
		tb_Colour_Size.CSCode,tb_Colour_Size.CSName
		FROM ((((((tb_ItemDet 
		INNER JOIN  tb_Item ON  tb_ItemDet.Item_Code = tb_Item.Item_Code) 
		INNER JOIN tb_Colour_Size ON tb_ItemDet.Item_Code = tb_Colour_Size.ItemCode AND tb_Colour_Size.LocaCode = '''+@LOCA+''')
		LEFT OUTER JOIN vw_StockBalCL ON tb_Item.Item_Code = vw_StockBalCL.ItemCode AND tb_Colour_Size.CSCode = vw_StockBalCL.CSCode) 
		LEFT OUTER JOIN vw_StockBalOp ON tb_Item.Item_Code = vw_StockBalOp.ItemCode AND tb_Colour_Size.CSCode = vw_StockBalOp.CSCode) 
		INNER JOIN tb_Supplier ON tb_Item.Supp_Code = tb_Supplier.Supp_Code) 
		INNER JOIN tb_SubCategory ON tb_Item.SubCat_Code = tb_SubCategory.SubCat_Code) 
		WHERE tb_Item.Supp_Code IN (SELECT Code FROM tb_TempSelect WHERE UserName='''+@USERNAME+''' AND [ID]=''OSP'' AND LocaCode='''+@LOCA+''')  
		AND  tb_ItemDet.Loca_Code = '''+@LOCA+''' AND tb_Item.Use_Exp = 3
		ORDER BY tb_Item.Supp_Code ASC,tb_Item.SubCat_Code ASC,tb_Item.Item_Code ASC '
		EXEC(@Sql)
		--PRINT(@Sql)
	END
END
END
ELSE IF @ID = 5 --Bin Location Wise
BEGIN
IF @COLOURNSIZE = 0
	BEGIN
		SELECT tb_ItemDet.ERet_Price, tb_ItemDet.Cost_Price,tb_Item.Descrip,tb_Item.SubCat_Code,tb_ItemDet.BinNo,
		tb_Supplier.Supp_Name , tb_Item.Supp_Code, vw_StockBalCL.Stock, tb_Item.Item_Code, vw_StockBalOp.Stock 
		FROM (((((tb_ItemDet 
		INNER JOIN  tb_Item ON  tb_ItemDet.Item_Code = tb_Item.Item_Code)
		LEFT OUTER JOIN vw_StockBalCL ON tb_Item.Item_Code = vw_StockBalCL.ItemCode) 
		LEFT OUTER JOIN vw_StockBalOp ON tb_Item.Item_Code = vw_StockBalOp.ItemCode) 
		INNER JOIN tb_Supplier ON tb_Item.Supp_Code = tb_Supplier.Supp_Code) 
		INNER JOIN tb_SubCategory ON tb_Item.SubCat_Code = tb_SubCategory.SubCat_Code) 
		WHERE tb_ItemDet.BinNo BETWEEN @CODE1 AND  @CODE2 AND  tb_ItemDet.Loca_Code = @LOCA AND tb_Item.Use_Exp <> 3
		ORDER BY tb_ItemDet.BinNo ASC,tb_Item.SubCat_Code ASC,tb_Item.Item_Code ASC
	END	
ELSE
	BEGIN
		SET @Sql = ''
		SET @Sql = ' SELECT tb_ItemDet.ERet_Price, tb_ItemDet.Cost_Price,tb_Item.Descrip,tb_Item.SubCat_Code,tb_ItemDet.BinNo,
		tb_Supplier.Supp_Name , tb_Item.Supp_Code,ISNULL(vw_StockBalCL.Stock,0)AS Stock,tb_Item.Item_Code,ISNULL(vw_StockBalOp.Stock,0) AS Stock,
		tb_Colour_Size.CSCode,tb_Colour_Size.CSName 
		FROM ((((((tb_ItemDet 
		INNER JOIN  tb_Item ON  tb_ItemDet.Item_Code = tb_Item.Item_Code)
		INNER JOIN tb_Colour_Size ON tb_ItemDet.Item_Code = tb_Colour_Size.ItemCode AND tb_Colour_Size.LocaCode = '''+@LOCA+''')
		LEFT OUTER JOIN vw_StockBalCL ON tb_Item.Item_Code = vw_StockBalCL.ItemCode AND tb_Colour_Size.CSCode = vw_StockBalCL.CSCode) 
		LEFT OUTER JOIN vw_StockBalOp ON tb_Item.Item_Code = vw_StockBalOp.ItemCode AND tb_Colour_Size.CSCode = vw_StockBalOp.CSCode) 
		INNER JOIN tb_Supplier ON tb_Item.Supp_Code = tb_Supplier.Supp_Code) 
		INNER JOIN tb_SubCategory ON tb_Item.SubCat_Code = tb_SubCategory.SubCat_Code) 
		WHERE tb_ItemDet.BinNo BETWEEN '''+@CODE1+''' AND  '''+@CODE2+''' 
		AND  tb_ItemDet.Loca_Code = '''+@LOCA+''' AND tb_Item.Use_Exp = 3
		ORDER BY tb_ItemDet.BinNo ASC,tb_Item.SubCat_Code ASC,tb_Item.Item_Code ASC '
		EXEC(@Sql)
		--PRINT(@Sql)
	END
END
END

GO

