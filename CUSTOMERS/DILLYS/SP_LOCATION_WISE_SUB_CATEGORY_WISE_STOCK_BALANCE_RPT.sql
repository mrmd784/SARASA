USE [Eastpoint]
GO

/****** Object:  StoredProcedure [dbo].[SP_LOCATION_WISE_SUB_CATEGORY_WISE_STOCK_BALANCE_RPT]    Script Date: 2023-12-28 2:48:16 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[SP_LOCATION_WISE_SUB_CATEGORY_WISE_STOCK_BALANCE_RPT]
@USERNAME VARCHAR(15),
@LOCA VARCHAR(5),
@FROMCODE VARCHAR(20),
@TOCODE VARCHAR(20),
@FROMLOCACODE VARCHAR(20),
@TOLOCACODE VARCHAR(20),
@ISALLCODE INT,
@ISALLLOCA INT,
@ISLISTCODE INT,
@ISLISTLOCA INT,
@PDATE VARCHAR(10),
@ISCODERANGE INT,
@ISLOCARANGE INT

AS
DECLARE @SQL VARCHAR(MAX)
DECLARE @l_Error INT
BEGIN TRAN
SET @l_Error=0


IF (@ISLISTLOCA = 1 AND @ISLISTCODE = 1) -- Loca List , Code List
	BEGIN
		SET @SQL = N'ALTER VIEW vw_StockBalLoca AS SELECT tb_Stock.ItemCode,tb_Stock.LocaCode,Sum(Case [Id] WHEN ''OPB'' THEN
					(PackSize*Qty) WHEN ''PCH'' THEN (PackSize*Qty) WHEN ''PRN'' THEN -(PackSize*Qty) WHEN ''INV'' THEN -(PackSize*Qty) WHEN ''MKR'' THEN 
					(PackSize*Qty) WHEN ''DMG'' THEN -(PackSize*Qty) WHEN ''PRD'' THEN -(PackSize*Qty) WHEN ''DSC'' THEN -(PackSize*Qty) WHEN ''ADD'' THEN (PackSize*Qty)
					WHEN ''TOG'' Then -(PackSize*Qty) WHEN ''AOD'' Then -(PackSize*Qty) WHEN ''IN1'' Then (PackSize*Qty) WHEN ''IN2'' THEN (PackSize*Qty) ELSE 0 END) AS Stock 
					FROM tb_Stock 
					INNER JOIN tb_Item ON tb_Stock.ItemCode = tb_Item.Item_Code
					WHERE tb_Stock.PDate <= ''' + @PDATE +''' AND tb_Stock.LocaCode IN (SELECT Code FROM tb_TempSelect WHERE UserName=''' + @USERNAME + ''' AND [Id]=''LOC'' AND LocaCode=''' +@LOCA + ''') AND tb_Stock.Status=1 
					AND tb_Item.SubCat_Code IN (SELECT Code FROM tb_TempSelect WHERE UserName=''' + @USERNAME +''' AND [Id]=''LST'' AND LocaCode=''' + @LOCA + ''')
					GROUP BY tb_Stock.LocaCode,tb_Stock.ItemCode'
					EXEC(@SQL)
					SELECT  DISTINCT tb_Item.Item_Code, tb_Item.Descrip, tb_Item.Cat_Code, tb_Item.SubCat_Code, tb_Item.Pack_Size, tb_Item.PUnit, tb_Item.EUnit,
					tb_ItemDet.PRet_Price, tb_ItemDet.ERet_Price, tb_ItemDet.Cost_Price ,vw_StockBalLoca.Stock ,tb_Location.Ref_Code AS LocaCode ,tb_SubCategory.SubCat_Name          
					FROM (tb_Item INNER JOIN tb_ItemDet ON  tb_Item.Item_Code = tb_ItemDet.Item_Code)
					INNER JOIN vw_StockBalLoca ON  vw_StockBalLoca.ItemCode  = tb_Item.Item_Code
					INNER JOIN tb_SubCategory ON tb_SubCategory.SubCat_Code = tb_Item.SubCat_Code
					INNER JOIN tb_Location ON tb_Location.Loca_Code = vw_StockBalLoca.LocaCode
					WHERE tb_ItemDet.Loca_Code = vw_StockBalLoca.LocaCode 
					ORDER BY tb_Item.Item_Code ASC
		          
					IF @@Error <> 0  SET @l_Error=@@Error
	END
ELSE IF (@ISLISTLOCA = 1 AND @ISCODERANGE = 1) -- Loca List , Code range
	BEGIN
		
			SET @SQL = N'ALTER VIEW vw_StockBalLoca AS SELECT tb_Stock.ItemCode,tb_Stock.LocaCode,Sum(Case [Id] WHEN ''OPB'' THEN
			(PackSize*Qty) WHEN ''PCH'' THEN (PackSize*Qty) WHEN ''PRN'' THEN -(PackSize*Qty) WHEN ''INV'' THEN -(PackSize*Qty) WHEN ''MKR'' THEN 
			(PackSize*Qty) WHEN ''DMG'' THEN -(PackSize*Qty) WHEN ''PRD'' THEN -(PackSize*Qty) WHEN ''DSC'' THEN -(PackSize*Qty) WHEN ''ADD'' THEN (PackSize*Qty)
			WHEN ''TOG'' Then -(PackSize*Qty) WHEN ''AOD'' Then -(PackSize*Qty) WHEN ''IN1'' Then (PackSize*Qty) WHEN ''IN2'' THEN (PackSize*Qty) ELSE 0 END) AS Stock 
			FROM tb_Stock 
			INNER JOIN tb_Item ON tb_Stock.ItemCode = tb_Item.Item_Code
			WHERE tb_Stock.PDate <= ''' + @PDATE +''' AND tb_Stock.LocaCode IN (SELECT Code FROM tb_TempSelect WHERE UserName=''' + @USERNAME + ''' AND [Id]=''LOC'' AND LocaCode=''' +@LOCA + ''') AND tb_Stock.Status=1 
			AND tb_Item.SubCat_Code BETWEEN ''' + @FROMCODE + ''' AND  ''' + @TOCODE + '''
			GROUP BY tb_Stock.LocaCode,tb_Stock.ItemCode'
			EXEC(@SQL)
			--PRINT @SQL
			
			SELECT  DISTINCT tb_Item.Item_Code, tb_Item.Descrip, tb_Item.Cat_Code, tb_Item.SubCat_Code, tb_Item.Pack_Size, tb_Item.PUnit, tb_Item.EUnit,
            tb_ItemDet.PRet_Price, tb_ItemDet.ERet_Price, tb_ItemDet.Cost_Price ,vw_StockBalLoca.Stock ,tb_Location.Ref_Code AS LocaCode  ,tb_SubCategory.SubCat_Name             
            FROM (tb_Item INNER JOIN tb_ItemDet ON  tb_Item.Item_Code = tb_ItemDet.Item_Code)
            INNER JOIN vw_StockBalLoca ON  vw_StockBalLoca.ItemCode  = tb_Item.Item_Code
            INNER JOIN tb_Location ON tb_Location.Loca_Code = vw_StockBalLoca.LocaCode
            INNER JOIN tb_SubCategory ON tb_SubCategory.SubCat_Code = tb_Item.SubCat_Code
            WHERE tb_ItemDet.Loca_Code = vw_StockBalLoca.LocaCode AND tb_Item.SubCat_Code BETWEEN
            @FROMCODE AND @TOCODE
            ORDER BY tb_Item.Item_Code ASC
         
			IF @@Error <> 0  SET @l_Error=@@Error	
	END
ELSE IF (@ISLISTLOCA = 1 AND @ISALLCODE = 1) -- Loca List, Code All
	BEGIN
			PRINT '1'
			SET @SQL = N'ALTER VIEW vw_StockBalLoca AS SELECT tb_Stock.ItemCode,tb_Stock.LocaCode,Sum(Case [Id] WHEN ''OPB'' THEN
			(PackSize*Qty) WHEN ''PCH'' THEN (PackSize*Qty) WHEN ''PRN'' THEN -(PackSize*Qty) WHEN ''INV'' THEN -(PackSize*Qty) WHEN ''MKR'' THEN 
			(PackSize*Qty) WHEN ''DMG'' THEN -(PackSize*Qty) WHEN ''PRD'' THEN -(PackSize*Qty) WHEN ''DSC'' THEN -(PackSize*Qty) WHEN ''ADD'' THEN (PackSize*Qty)
			WHEN ''TOG'' Then -(PackSize*Qty) WHEN ''AOD'' Then -(PackSize*Qty) WHEN ''IN1'' Then (PackSize*Qty) WHEN ''IN2'' THEN (PackSize*Qty) ELSE 0 END) AS Stock 
			FROM tb_Stock
			INNER JOIN tb_Item ON tb_Stock.ItemCode = tb_Item.Item_Code
			WHERE tb_Stock.PDate <= ''' + @PDATE +''' AND tb_Stock.LocaCode IN (SELECT Code FROM tb_TempSelect WHERE UserName=''' + @USERNAME + ''' AND [Id]=''LOC'' AND LocaCode=''' +@LOCA + ''') AND tb_Stock.Status=1 
			GROUP BY tb_Stock.LocaCode,tb_Stock.ItemCode'
			EXEC(@SQL)
			PRINT @SQL
			
			SELECT  DISTINCT tb_Item.Item_Code, tb_Item.Descrip, tb_Item.Cat_Code, tb_Item.SubCat_Code, tb_Item.Pack_Size, tb_Item.PUnit, tb_Item.EUnit,
            tb_ItemDet.PRet_Price, tb_ItemDet.ERet_Price, tb_ItemDet.Cost_Price ,vw_StockBalLoca.Stock ,tb_Location.Ref_Code AS LocaCode  ,tb_SubCategory.SubCat_Name              
            FROM (tb_Item INNER JOIN tb_ItemDet ON  tb_Item.Item_Code = tb_ItemDet.Item_Code)
            INNER JOIN vw_StockBalLoca ON  vw_StockBalLoca.ItemCode  = tb_Item.Item_Code
            INNER JOIN tb_Location ON tb_Location.Loca_Code = vw_StockBalLoca.LocaCode
            INNER JOIN tb_SubCategory ON tb_SubCategory.SubCat_Code = tb_Item.SubCat_Code
            WHERE tb_ItemDet.Loca_Code = vw_StockBalLoca.LocaCode 
            ORDER BY tb_Item.Item_Code ASC
         PRINT '2'
			IF @@Error <> 0  SET @l_Error=@@Error	
	END
ELSE IF (@ISLISTCODE = 1 AND @ISLOCARANGE = 1) -- Code List , Loca range
	BEGIN
		
			SET @SQL = N'ALTER VIEW vw_StockBalLoca AS SELECT tb_Stock.ItemCode,tb_Stock.LocaCode,Sum(Case [Id] WHEN ''OPB'' THEN
			(PackSize*Qty) WHEN ''PCH'' THEN (PackSize*Qty) WHEN ''PRN'' THEN -(PackSize*Qty) WHEN ''INV'' THEN -(PackSize*Qty) WHEN ''MKR'' THEN 
			(PackSize*Qty) WHEN ''DMG'' THEN -(PackSize*Qty) WHEN ''PRD'' THEN -(PackSize*Qty) WHEN ''DSC'' THEN -(PackSize*Qty) WHEN ''ADD'' THEN (PackSize*Qty)
			WHEN ''TOG'' Then -(PackSize*Qty) WHEN ''AOD'' Then -(PackSize*Qty) WHEN ''IN1'' Then (PackSize*Qty) WHEN ''IN2'' THEN (PackSize*Qty) ELSE 0 END) AS Stock 
			FROM tb_Stock 
			INNER JOIN tb_Item ON tb_Stock.ItemCode = tb_Item.Item_Code
			WHERE tb_Stock.PDate <= ''' + @PDATE +''' AND tb_Item.SubCat_Code IN (SELECT Code FROM tb_TempSelect WHERE UserName=''' + @USERNAME + ''' AND [Id]=''LST'' AND LocaCode=''' +@LOCA + ''') AND tb_Stock.Status=1 
			AND tb_Stock.LocaCode BETWEEN ''' + @FROMLOCACODE + ''' AND  ''' + @TOLOCACODE + '''
			GROUP BY tb_Stock.LocaCode,tb_Stock.ItemCode'
			EXEC(@SQL)
			--PRINT @SQL
			
			SELECT  DISTINCT tb_Item.Item_Code, tb_Item.Descrip, tb_Item.Cat_Code, tb_Item.SubCat_Code, tb_Item.Pack_Size, tb_Item.PUnit, tb_Item.EUnit,
            tb_ItemDet.PRet_Price, tb_ItemDet.ERet_Price, tb_ItemDet.Cost_Price ,vw_StockBalLoca.Stock ,tb_Location.Ref_Code AS LocaCode ,tb_SubCategory.SubCat_Name          
            FROM (tb_Item INNER JOIN tb_ItemDet ON  tb_Item.Item_Code = tb_ItemDet.Item_Code)
            INNER JOIN vw_StockBalLoca ON  vw_StockBalLoca.ItemCode  = tb_Item.Item_Code
            INNER JOIN tb_Location ON tb_Location.Loca_Code = vw_StockBalLoca.LocaCode
            INNER JOIN tb_SubCategory ON tb_SubCategory.SubCat_Code = tb_Item.SubCat_Code
            WHERE tb_ItemDet.Loca_Code = vw_StockBalLoca.LocaCode AND vw_StockBalLoca.LocaCode BETWEEN
            @FROMLOCACODE AND @TOLOCACODE
            ORDER BY tb_Item.Item_Code ASC
         
			IF @@Error <> 0  SET @l_Error=@@Error	
	END
ELSE IF (@ISLISTCODE = 1 AND @ISALLLOCA = 1) -- Code List, Loca All
	BEGIN
			
			SET @SQL = N'ALTER VIEW vw_StockBalLoca AS SELECT tb_Stock.ItemCode,tb_stock.BatchNo as CsCode,tb_Stock.LocaCode,Sum(Case [Id] WHEN ''OPB'' THEN
			(PackSize*Qty) WHEN ''PCH'' THEN (PackSize*Qty) WHEN ''PRN'' THEN -(PackSize*Qty) WHEN ''INV'' THEN -(PackSize*Qty) WHEN ''MKR'' THEN 
			(PackSize*Qty) WHEN ''DMG'' THEN -(PackSize*Qty) WHEN ''PRD'' THEN -(PackSize*Qty) WHEN ''DSC'' THEN -(PackSize*Qty) WHEN ''ADD'' THEN (PackSize*Qty)
			WHEN ''TOG'' Then -(PackSize*Qty) WHEN ''AOD'' Then -(PackSize*Qty) WHEN ''IN1'' Then (PackSize*Qty) WHEN ''IN2'' THEN (PackSize*Qty) ELSE 0 END) AS Stock 
			FROM tb_Stock 
			INNER JOIN tb_Item ON tb_Stock.ItemCode = tb_Item.Item_Code
			WHERE tb_Stock.PDate <= ''' + @PDATE +''' AND tb_Item.SubCat_Code IN (SELECT Code FROM tb_TempSelect WHERE UserName=''' + @USERNAME + ''' AND [Id]=''LST'' AND LocaCode=''' +@LOCA + ''') AND tb_Stock.Status=1 
			GROUP BY tb_Stock.LocaCode,tb_Stock.ItemCode,tb_stock.BatchNo'
			EXEC(@SQL)
			PRINT @SQL
			--FOR DILLY & CARLO
			--SELECT  DISTINCT tb_Item.Item_Code, tb_Item.Descrip, tb_Item.Cat_Code, tb_Item.SubCat_Code, tb_Item.Pack_Size, tb_Item.PUnit, tb_Item.EUnit,
   --         tb_ItemDet.PRet_Price, tb_ItemDet.ERet_Price, tb_ItemDet.Cost_Price ,vw_StockBalLoca.Stock ,tb_Location.Ref_Code AS LocaCode  ,tb_SubCategory.SubCat_Name           
   --         FROM (tb_Item INNER JOIN tb_ItemDet ON  tb_Item.Item_Code = tb_ItemDet.Item_Code)
   --         INNER JOIN vw_StockBalLoca ON  vw_StockBalLoca.ItemCode  = tb_Item.Item_Code
   --         INNER JOIN tb_Location ON tb_Location.Loca_Code = vw_StockBalLoca.LocaCode
   --         INNER JOIN tb_SubCategory ON tb_SubCategory.SubCat_Code = tb_Item.SubCat_Code
   --         WHERE tb_ItemDet.Loca_Code = vw_StockBalLoca.LocaCode 
   --         ORDER BY tb_Item.Item_Code ASC
   SELECT  DISTINCT tb_Item.Item_Code, tb_Item.Descrip,tb_Colour_Size.CSCode,tb_Colour_Size.CSName, tb_Item.Cat_Code, tb_Item.SubCat_Code, tb_Item.Pack_Size, tb_Item.PUnit, tb_Item.EUnit,
            tb_ItemDet.PRet_Price, tb_ItemDet.ERet_Price, tb_ItemDet.Cost_Price ,vw_StockBalLoca.Stock ,tb_Location.Ref_Code AS LocaCode  ,tb_SubCategory.SubCat_Name           
            FROM (tb_Item INNER JOIN tb_ItemDet ON  tb_Item.Item_Code = tb_ItemDet.Item_Code)
            INNER JOIN vw_StockBalLoca ON  vw_StockBalLoca.ItemCode  = tb_Item.Item_Code
            INNER JOIN tb_Location ON tb_Location.Loca_Code = vw_StockBalLoca.LocaCode
            INNER JOIN tb_SubCategory ON tb_SubCategory.SubCat_Code = tb_Item.SubCat_Code
			INNER JOIN tb_Colour_Size on vw_StockBalLoca.CsCode=tb_Colour_Size.CSCode
			--INNER JOIN tb_Colour_Size on tb_item.Item_Code=tb_Colour_Size.ItemCode
            WHERE tb_ItemDet.Loca_Code = vw_StockBalLoca.LocaCode 
            ORDER BY tb_Item.Item_Code ASC
        
			IF @@Error <> 0  SET @l_Error=@@Error	
	END
ELSE IF (@ISALLCODE = 1  AND @ISALLLOCA = 1)--All Loca ,All Code
	BEGIN
		SET @SQL = N'ALTER VIEW vw_StockBalLoca AS SELECT tb_Stock.ItemCode,tb_Stock.LocaCode,Sum(Case [Id] WHEN ''OPB'' THEN
				(PackSize*Qty) WHEN ''PCH'' THEN (PackSize*Qty) WHEN ''PRN'' THEN -(PackSize*Qty) WHEN ''INV'' THEN -(PackSize*Qty) WHEN ''MKR'' THEN 
				(PackSize*Qty) WHEN ''DMG'' THEN -(PackSize*Qty) WHEN ''PRD'' THEN -(PackSize*Qty) WHEN ''DSC'' THEN -(PackSize*Qty) WHEN ''ADD'' THEN (PackSize*Qty)
				WHEN ''TOG'' Then -(PackSize*Qty) WHEN ''AOD'' Then -(PackSize*Qty) WHEN ''IN1'' Then (PackSize*Qty) WHEN ''IN2'' THEN (PackSize*Qty) ELSE 0 END) AS Stock 
				FROM tb_Stock
				INNER JOIN tb_Item ON tb_Stock.ItemCode = tb_Item.Item_Code
				WHERE tb_Stock.PDate <= ''' + @PDATE +''' AND tb_Stock.Status=1 
				GROUP BY tb_Stock.LocaCode,tb_Stock.ItemCode'
				EXEC(@SQL)
				--PRINT @SQL
				SELECT  DISTINCT tb_Item.Item_Code, tb_Item.Descrip, tb_Item.Cat_Code, tb_Item.SubCat_Code, tb_Item.Pack_Size, tb_Item.PUnit, tb_Item.EUnit,
				tb_ItemDet.PRet_Price, tb_ItemDet.ERet_Price, tb_ItemDet.Cost_Price ,vw_StockBalLoca.Stock ,tb_Location.Ref_Code AS LocaCode  ,tb_SubCategory.SubCat_Name             
				FROM (tb_Item INNER JOIN tb_ItemDet ON  tb_Item.Item_Code = tb_ItemDet.Item_Code)
				INNER JOIN vw_StockBalLoca ON  vw_StockBalLoca.ItemCode  = tb_Item.Item_Code
				INNER JOIN tb_Location ON tb_Location.Loca_Code = vw_StockBalLoca.LocaCode
				INNER JOIN tb_SubCategory ON tb_SubCategory.SubCat_Code = tb_Item.SubCat_Code
				WHERE tb_ItemDet.Loca_Code = vw_StockBalLoca.LocaCode 
				ORDER BY tb_Item.Item_Code ASC
	        
				IF @@Error <> 0  SET @l_Error=@@Error	
	END
ELSE IF (@ISALLCODE = 1  AND @ISLOCARANGE = 1)--All Code,Loca range
	BEGIN
		SET @SQL = N'ALTER VIEW vw_StockBalLoca AS SELECT tb_Stock.ItemCode,tb_Stock.LocaCode,Sum(Case [Id] WHEN ''OPB'' THEN
				(PackSize*Qty) WHEN ''PCH'' THEN (PackSize*Qty) WHEN ''PRN'' THEN -(PackSize*Qty) WHEN ''INV'' THEN -(PackSize*Qty) WHEN ''MKR'' THEN 
				(PackSize*Qty) WHEN ''DMG'' THEN -(PackSize*Qty) WHEN ''PRD'' THEN -(PackSize*Qty) WHEN ''DSC'' THEN -(PackSize*Qty) WHEN ''ADD'' THEN (PackSize*Qty)
				WHEN ''TOG'' Then -(PackSize*Qty) WHEN ''AOD'' Then -(PackSize*Qty) WHEN ''IN1'' Then (PackSize*Qty) WHEN ''IN2'' THEN (PackSize*Qty) ELSE 0 END) AS Stock 
				FROM tb_Stock 
				INNER JOIN tb_Item ON tb_Stock.ItemCode = tb_Item.Item_Code
				WHERE tb_Stock.PDate <= ''' + @PDATE +''' AND tb_Stock.Status=1 
				AND tb_Stock.LocaCode BETWEEN ''' + @FROMLOCACODE + ''' AND  ''' + @TOLOCACODE + '''
				GROUP BY tb_Stock.LocaCode,tb_Stock.ItemCode'
				EXEC(@SQL)
				--PRINT @SQL
				
				SELECT  DISTINCT tb_Item.Item_Code, tb_Item.Descrip, tb_Item.Cat_Code, tb_Item.SubCat_Code, tb_Item.Pack_Size, tb_Item.PUnit, tb_Item.EUnit,
				tb_ItemDet.PRet_Price, tb_ItemDet.ERet_Price, tb_ItemDet.Cost_Price ,vw_StockBalLoca.Stock ,tb_Location.Ref_Code AS LocaCode  ,tb_SubCategory.SubCat_Name            
				FROM (tb_Item INNER JOIN tb_ItemDet ON  tb_Item.Item_Code = tb_ItemDet.Item_Code)
				INNER JOIN vw_StockBalLoca ON  vw_StockBalLoca.ItemCode  = tb_Item.Item_Code
				INNER JOIN tb_Location ON tb_Location.Loca_Code = vw_StockBalLoca.LocaCode
				INNER JOIN tb_SubCategory ON tb_SubCategory.SubCat_Code = tb_Item.SubCat_Code
				WHERE tb_ItemDet.Loca_Code = vw_StockBalLoca.LocaCode AND vw_StockBalLoca.LocaCode BETWEEN
				@FROMLOCACODE AND @TOLOCACODE
				ORDER BY tb_Item.Item_Code ASC
	         
				IF @@Error <> 0  SET @l_Error=@@Error	
	END
ELSE IF (@ISCODERANGE = 1 AND @ISLOCARANGE = 1)--Code Range,Loca range
	BEGIN
		SET @SQL = N'ALTER VIEW vw_StockBalLoca AS SELECT tb_Stock.ItemCode,tb_Stock.LocaCode,Sum(Case [Id] WHEN ''OPB'' THEN
				(PackSize*Qty) WHEN ''PCH'' THEN (PackSize*Qty) WHEN ''PRN'' THEN -(PackSize*Qty) WHEN ''INV'' THEN -(PackSize*Qty) WHEN ''MKR'' THEN 
				(PackSize*Qty) WHEN ''DMG'' THEN -(PackSize*Qty) WHEN ''PRD'' THEN -(PackSize*Qty) WHEN ''DSC'' THEN -(PackSize*Qty) WHEN ''ADD'' THEN (PackSize*Qty)
				WHEN ''TOG'' Then -(PackSize*Qty) WHEN ''AOD'' Then -(PackSize*Qty) WHEN ''IN1'' Then (PackSize*Qty) WHEN ''IN2'' THEN (PackSize*Qty) ELSE 0 END) AS Stock 
				FROM tb_Stock 
				INNER JOIN tb_Item ON tb_Stock.ItemCode = tb_Item.Item_Code
				WHERE tb_Stock.PDate <= ''' + @PDATE +''' AND tb_Stock.Status=1 
				AND tb_Stock.LocaCode BETWEEN ''' + @FROMLOCACODE + ''' AND  ''' + @TOLOCACODE + '''
				AND tb_Item.SubCat_Code BETWEEN ''' + @FROMCODE + ''' AND  ''' + @TOCODE + '''
				GROUP BY tb_Stock.LocaCode,tb_Stock.ItemCode'
				EXEC(@SQL)
				--PRINT @SQL
				
				SELECT  DISTINCT tb_Item.Item_Code, tb_Item.Descrip, tb_Item.Cat_Code, tb_Item.SubCat_Code, tb_Item.Pack_Size, tb_Item.PUnit, tb_Item.EUnit,
				tb_ItemDet.PRet_Price, tb_ItemDet.ERet_Price, tb_ItemDet.Cost_Price ,vw_StockBalLoca.Stock ,tb_Location.Ref_Code AS LocaCode   ,tb_SubCategory.SubCat_Name         
				FROM (tb_Item INNER JOIN tb_ItemDet ON  tb_Item.Item_Code = tb_ItemDet.Item_Code)
				INNER JOIN vw_StockBalLoca ON  vw_StockBalLoca.ItemCode  = tb_Item.Item_Code
				INNER JOIN tb_Location ON tb_Location.Loca_Code = vw_StockBalLoca.LocaCode
				INNER JOIN tb_SubCategory ON tb_SubCategory.SubCat_Code = tb_Item.SubCat_Code
				WHERE tb_ItemDet.Loca_Code = vw_StockBalLoca.LocaCode AND vw_StockBalLoca.LocaCode BETWEEN
				@FROMLOCACODE AND @TOLOCACODE AND tb_Item.SubCat_Code BETWEEN @FROMCODE AND @TOCODE
				ORDER BY tb_Item.Item_Code ASC
	         
				IF @@Error <> 0  SET @l_Error=@@Error	
	END
ELSE IF (@ISCODERANGE = 1 AND @ISALLLOCA = 1)--Code Range,All Loca
	BEGIN
		SET @SQL = N'ALTER VIEW vw_StockBalLoca AS SELECT tb_Stock.ItemCode,tb_Stock.LocaCode,Sum(Case [Id] WHEN ''OPB'' THEN
				(PackSize*Qty) WHEN ''PCH'' THEN (PackSize*Qty) WHEN ''PRN'' THEN -(PackSize*Qty) WHEN ''INV'' THEN -(PackSize*Qty) WHEN ''MKR'' THEN 
				(PackSize*Qty) WHEN ''DMG'' THEN -(PackSize*Qty) WHEN ''PRD'' THEN -(PackSize*Qty) WHEN ''DSC'' THEN -(PackSize*Qty) WHEN ''ADD'' THEN (PackSize*Qty)
				WHEN ''TOG'' Then -(PackSize*Qty) WHEN ''AOD'' Then -(PackSize*Qty) WHEN ''IN1'' Then (PackSize*Qty) WHEN ''IN2'' THEN (PackSize*Qty) ELSE 0 END) AS Stock 
				FROM tb_Stock 
				INNER JOIN tb_Item ON tb_Stock.ItemCode = tb_Item.Item_Code
				WHERE tb_Stock.PDate <= ''' + @PDATE +''' AND tb_Stock.Status=1 				
				AND tb_Item.SubCat_Code BETWEEN ''' + @FROMCODE + ''' AND  ''' + @TOCODE + '''
				GROUP BY tb_Stock.LocaCode,tb_Stock.ItemCode'
				EXEC(@SQL)
				--PRINT @SQL
				
				SELECT  DISTINCT tb_Item.Item_Code, tb_Item.Descrip, tb_Item.SubCat_Code, tb_Item.Cat_Code, tb_Item.Pack_Size, tb_Item.PUnit, tb_Item.EUnit,
				tb_ItemDet.PRet_Price, tb_ItemDet.ERet_Price, tb_ItemDet.Cost_Price ,vw_StockBalLoca.Stock ,tb_Location.Ref_Code AS LocaCode   
				FROM (tb_Item INNER JOIN tb_ItemDet ON  tb_Item.Item_Code = tb_ItemDet.Item_Code)
				INNER JOIN vw_StockBalLoca ON  vw_StockBalLoca.ItemCode  = tb_Item.Item_Code
				INNER JOIN tb_Location ON tb_Location.Loca_Code = vw_StockBalLoca.LocaCode
				INNER JOIN tb_SubCategory ON tb_SubCategory.SubCat_Code = tb_Item.SubCat_Code
				WHERE tb_ItemDet.Loca_Code = vw_StockBalLoca.LocaCode AND tb_Item.SubCat_Code BETWEEN @FROMCODE AND @TOCODE
				ORDER BY tb_Item.Item_Code ASC
	         
				IF @@Error <> 0  SET @l_Error=@@Error	
	END

IF @l_Error<> 0 
ROLLBACK TRAN
ELSE
COMMIT TRAN


GO

