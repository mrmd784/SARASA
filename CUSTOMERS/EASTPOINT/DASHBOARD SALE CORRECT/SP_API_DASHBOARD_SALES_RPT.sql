USE [easyway]
GO

/****** Object:  StoredProcedure [dbo].[SP_API_DASHBOARD_SALES_RPT]    Script Date: 2024-09-02 12:38:35 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[SP_API_DASHBOARD_SALES_RPT]			  

--SP_API_DASHBOARD_SALES_RPT 0,1,'01','','','','','2024-06-01','2024-06-05',1

@ReportId Int,
@Id INT,
@LocaCode VARCHAR(max) = '',
@CatCode VARCHAR(max) = '',
@SubCatCode	 VARCHAR(max) = '',
@SuppCode VARCHAR(max) ='',
@CustCode VARCHAR(max) = '',
@DateFrom DATE = '1990-01-01',
@DateTo DATE  = '1990-01-01',
@IsSummary TINYINT,
@slab1From INT = 0,
@slab1To INT = 30,
@slab2From INT = 31,
@slab2To INT = 60,
@slab3From INT = 61,
@slab3To INT = 90,
@SerialNo VARCHAR(1000) = '',
@DocType VARCHAR(1000) = ''
AS


BEGIN
	DECLARE @sql NVARCHAR (max) = '',@DisplayCol NVARCHAR (max) = '',@WhereClause NVARCHAR (max) = '' ,	@TypeId	INT,@GroupByClause NVARCHAR (max) = '',@NettSales money 

update SalesDashboard set CustCode=0 where custCode is null
update SalesDashboard set Rate=1 where Rate<1
update SalesDashboard set Cost=1 where Cost<1
update tb_itemDet set ERet_Price=1	where ERet_Price<1
update tb_itemDet set Cost_Price=1		 where Cost_Price<1

--update 	tb_Stock set  tb_Stock.Cost	= tb_ItemDet.Cost_Price from  tb_Stock join  tb_itemDet on tb_Stock.ItemCode= tb_itemDet.Item_Code and 	 tb_Stock.LocaCode= tb_itemDet.Loca_Code

IF(@ID=1) --Sales
BEGIN
					IF(@ReportId=1) --Cat
					BEGIN
						IF (@ISSUMMARY=1)
						BEGIN
						set @DisplayCol ='tb_Item.Cat_Code As Code,tb_Category.Cat_Name As Name,'
						--set @WhereClause = 'tb_InvDet.ItemCode IN (SELECT Item_Code FROM Tb_Item WHERE Cat_Code In ('+ @CatCode +')) AND tb_InvDet.ItemCode IN (SELECT Item_Code FROM Tb_Item WHERE Supp_Code In ('+ @SuppCode +')) AND'
						set @GroupByClause = 'GROUP BY tb_Item.Cat_Code,tb_Category.Cat_Name,NoOfReceipt'						  
							END
							ELSE
							  BEGIN
							set @DisplayCol ='SalesDashboard.ItemCode, SalesDashboard.ItemDescrip, SalesDashboard.PackSize,SalesDashboard.CSCode,SalesDashboard.CSName,tb_Item.Cat_Code,tb_Category.Cat_Name,'
							set @WhereClause = 'SalesDashboard.ItemCode IN (SELECT Item_Code FROM Tb_Item WHERE Cat_Code In ('+ @CatCode +')) AND SalesDashboard.ItemCode IN (SELECT Item_Code FROM Tb_Item WHERE Supp_Code In ('+ @SuppCode +')) AND'
							set @GroupByClause = 'GROUP BY SalesDashboard.ItemCode, SalesDashboard.ItemDescrip, SalesDashboard.PackSize,SalesDashboard.CSCode,SalesDashboard.CSName,tb_Item.Cat_Code,tb_Category.Cat_Name,NoOfReceipt'
							END
					END
					ELSE
					IF(@ReportId=2) --Supp
					BEGIN
						IF (@ISSUMMARY=1)
						BEGIN
						set @DisplayCol ='tb_Item.Supp_Code As Code,tb_Supplier.Supp_Name As Name,'
						--set @WhereClause = 'SalesDashboard.ItemCode IN (SELECT Item_Code FROM Tb_Item WHERE Cat_Code In ('+ @CatCode +')) AND SalesDashboard.ItemCode IN (SELECT Item_Code FROM Tb_Item WHERE Supp_Code In ('+ @SuppCode +')) AND'
						set @GroupByClause = 'GROUP BY tb_Item.Supp_Code,tb_Supplier.Supp_Name,NoOfReceipt'						  
							END
							ELSE
							  BEGIN
							set @DisplayCol ='SalesDashboard.ItemCode, SalesDashboard.ItemDescrip, SalesDashboard.PackSize,SalesDashboard.CSCode,SalesDashboard.CSName,tb_Item.Supp_Code,tb_Supplier.Supp_Name,'
							set @WhereClause = 'SalesDashboard.ItemCode IN (SELECT Item_Code FROM Tb_Item WHERE Cat_Code In ('+ @CatCode +')) AND SalesDashboard.ItemCode IN (SELECT Item_Code FROM Tb_Item WHERE Supp_Code In ('+ @SuppCode +')) AND'
							set @GroupByClause = 'GROUP BY SalesDashboard.ItemCode, SalesDashboard.ItemDescrip, SalesDashboard.PackSize,SalesDashboard.CSCode,SalesDashboard.CSName,tb_Item.Supp_Code,tb_Supplier.Supp_Name,NoOfReceipt'
							END
					END
					ELSE
					IF(@ReportId=3) --Loca
					BEGIN
						IF (@ISSUMMARY=1)
						BEGIN
						set @DisplayCol ='SalesDashboard.LocaCode As Code,tb_Location.Loca_Name As Name,'
						--set @WhereClause = 'SalesDashboard.ItemCode IN (SELECT Item_Code FROM Tb_Item WHERE Cat_Code In ('+ @CatCode +')) AND SalesDashboard.ItemCode IN (SELECT Item_Code FROM Tb_Item WHERE Supp_Code In ('+ @SuppCode +')) AND'
						set @GroupByClause = 'GROUP BY SalesDashboard.LocaCode,tb_Location.Loca_Name'						  
							END
							ELSE
							  BEGIN
							set @DisplayCol ='SalesDashboard.ItemCode, SalesDashboard.ItemDescrip, SalesDashboard.PackSize,SalesDashboard.CSCode,SalesDashboard.CSName,SalesDashboard.LocaCode,tb_Location.Loca_Name,'
							set @WhereClause = 'SalesDashboard.ItemCode IN (SELECT Item_Code FROM Tb_Item WHERE Cat_Code In ('+ @CatCode +')) AND SalesDashboard.ItemCode IN (SELECT Item_Code FROM Tb_Item WHERE Supp_Code In ('+ @SuppCode +')) AND'
							set @GroupByClause = 'GROUP BY SalesDashboard.ItemCode, SalesDashboard.ItemDescrip, SalesDashboard.PackSize,SalesDashboard.CSCode,SalesDashboard.CSName,SalesDashboard.LocaCode,tb_Location.Loca_Name'
							END
					END
					ELSE
					IF(@ReportId=4) --Cust
					BEGIN
						IF (@ISSUMMARY=1) 
						BEGIN
						set @DisplayCol ='tb_Customer.Cust_Code As Code,tb_Customer.Cust_Name As Name,'
						--set @WhereClause = 'SalesDashboard.ItemCode IN (SELECT Item_Code FROM Tb_Item WHERE Cat_Code In ('+ @CatCode +')) AND SalesDashboard.ItemCode IN (SELECT Item_Code FROM Tb_Item WHERE Supp_Code In ('+ @SuppCode +')) AND tb_InvSumm.CustCode In ('+ @CustCode +' ) AND '
						set @GroupByClause = 'GROUP BY tb_Customer.Cust_Code,tb_Customer.Cust_Name,NoOfReceipt'						  
							END
							ELSE
							  BEGIN
							set @DisplayCol ='SalesDashboard.ItemCode, SalesDashboard.ItemDescrip, SalesDashboard.PackSize,SalesDashboard.CSCode,SalesDashboard.CSName,SalesDashboard.LocaCode,tb_Location.Loca_Name,'
							set @WhereClause = 'SalesDashboard.ItemCode IN (SELECT Item_Code FROM Tb_Item WHERE Cat_Code In ('+ @CatCode +')) AND SalesDashboard.ItemCode IN (SELECT Item_Code FROM Tb_Item WHERE Supp_Code In ('+ @SuppCode +')) AND SalesDashboard.CustCode In ('+ @CustCode +' ) AND '
							set @GroupByClause = 'GROUP BY SalesDashboard.ItemCode, SalesDashboard.ItemDescrip, SalesDashboard.PackSize,SalesDashboard.CSCode,SalesDashboard.CSName,SalesDashboard.LocaCode,tb_Location.Loca_Name,NoOfReceipt'
							END

					END
					ELSE
					IF(@ReportId=5) --SubCat
					BEGIN
						IF (@ISSUMMARY=1) 
						BEGIN
						set @DisplayCol ='tb_Item.SubCat_Code As Code,tb_SubCategory.SubCat_Name As Name,'
						--set @WhereClause = 'SalesDashboard.ItemCode IN (SELECT Item_Code FROM Tb_Item WHERE Cat_Code In ('+ @CatCode +')) AND SalesDashboard.ItemCode IN (SELECT Item_Code FROM Tb_Item WHERE Supp_Code In ('+ @SuppCode +')) AND tb_InvSumm.CustCode In ('+ @CustCode +' ) And SalesDashboard.ItemCode IN (SELECT Item_Code FROM Tb_Item WHERE SubCat_Code In ('+ @SubCatCode +')) AND '
						set @GroupByClause = 'GROUP BY tb_Item.SubCat_Code,tb_SubCategory.SubCat_Name,NoOfReceipt'						  
							END
							ELSE
							  BEGIN
							set @DisplayCol ='SalesDashboard.ItemCode, SalesDashboard.ItemDescrip, SalesDashboard.PackSize,SalesDashboard.CSCode,SalesDashboard.CSName,SalesDashboard.LocaCode,tb_Location.Loca_Name,'
							set @WhereClause = 'SalesDashboard.ItemCode IN (SELECT Item_Code FROM Tb_Item WHERE Cat_Code In ('+ @CatCode +')) AND SalesDashboard.ItemCode IN (SELECT Item_Code FROM Tb_Item WHERE Supp_Code In ('+ @SuppCode +')) AND SalesDashboard.CustCode In ('+ @CustCode +' ) AND '
							set @GroupByClause = 'GROUP BY SalesDashboard.ItemCode, SalesDashboard.ItemDescrip, SalesDashboard.PackSize,SalesDashboard.CSCode,SalesDashboard.CSName,SalesDashboard.LocaCode,tb_Location.Loca_Name,NoOfReceipt'
							END

					END
					ELSE
					IF(@ReportId=6) --Day
					BEGIN
						IF (@ISSUMMARY=1) 
						BEGIN
						set @DisplayCol ='DatePart(WeekDay,SalesDashboard.IDate) As Code,DATENAME(dw, SalesDashboard.IDate) As Name, '
						--set @WhereClause = 'SalesDashboard.ItemCode IN (SELECT Item_Code FROM Tb_Item WHERE Cat_Code In ('+ @CatCode +')) AND SalesDashboard.ItemCode IN (SELECT Item_Code FROM Tb_Item WHERE Supp_Code In ('+ @SuppCode +')) AND tb_InvSumm.CustCode In ('+ @CustCode +' ) AND '
						set @GroupByClause = 'GROUP BY DatePart(WeekDay,SalesDashboard.IDate),DATENAME(dw, SalesDashboard.IDate),NoOfReceipt'						  
							END
							ELSE
							  BEGIN
							set @DisplayCol ='SalesDashboard.ItemCode, SalesDashboard.ItemDescrip, SalesDashboard.PackSize,SalesDashboard.CSCode,SalesDashboard.CSName,SalesDashboard.LocaCode,tb_Location.Loca_Name,'
							set @WhereClause = 'SalesDashboard.ItemCode IN (SELECT Item_Code FROM Tb_Item WHERE Cat_Code In ('+ @CatCode +')) AND SalesDashboard.ItemCode IN (SELECT Item_Code FROM Tb_Item WHERE Supp_Code In ('+ @SuppCode +')) AND SalesDashboard.CustCode In ('+ @CustCode +' ) AND '
							set @GroupByClause = 'GROUP BY SalesDashboard.ItemCode, SalesDashboard.ItemDescrip, SalesDashboard.PackSize,SalesDashboard.CSCode,SalesDashboard.CSName,SalesDashboard.LocaCode,tb_Location.Loca_Name,NoOfReceipt'
							END

					END
					ELSE
					IF(@ReportId=7) --Mo
					BEGIN
						IF (@ISSUMMARY=1) 
						BEGIN
						set @DisplayCol ='DatePart(Month,SalesDashboard.IDate) As Code,DateName(month , SalesDashboard.IDate) As Name, '
						set @GroupByClause = 'GROUP BY DatePart(Month,SalesDashboard.IDate),DateName(month, SalesDashboard.IDate),NoOfReceipt '						  
							END
							ELSE
							  BEGIN
							set @DisplayCol ='SalesDashboard.ItemCode, SalesDashboard.ItemDescrip, SalesDashboard.PackSize,SalesDashboard.CSCode,SalesDashboard.CSName,SalesDashboard.LocaCode,tb_Location.Loca_Name,'
							set @WhereClause = 'SalesDashboard.ItemCode IN (SELECT Item_Code FROM Tb_Item WHERE Cat_Code In ('+ @CatCode +')) AND SalesDashboard.ItemCode IN (SELECT Item_Code FROM Tb_Item WHERE Supp_Code In ('+ @SuppCode +')) AND SalesDashboard.CustCode In ('+ @CustCode +' ) AND '
							set @GroupByClause = 'GROUP BY SalesDashboard.ItemCode, SalesDashboard.ItemDescrip, SalesDashboard.PackSize,SalesDashboard.CSCode,SalesDashboard.CSName,SalesDashboard.LocaCode,tb_Location.Loca_Name,NoOfReceipt'
							END

					END
					--ELSE
					--BEGIN
						
					--	set @GroupByClause = 'GROUP BY NoOfReceipt'

					--END
					
					set @sql =	 ' Select  @cnt = ISNULL(SUM(SalesDashboard.NetAmount),0) FROM SalesDashboard 
							INNER JOIN  tb_Item ON SalesDashboard.ItemCode = tb_Item.Item_Code
							WHERE '+ @WhereClause +'
							SalesDashboard.IDate BETWEEN '''+ convert(varchar, @DateFrom, 23) +''' AND '''+ convert(varchar, @DateTo, 23) +''' AND SalesDashboard.LocaCode In ('+ @LocaCode +' ) '
					--print (@sql);

					EXECUTE sp_executesql @sql, N'@cnt money OUTPUT', @cnt=@NettSales OUTPUT
					--select @NettSales

					if @NettSales = 0
					BEGIN
					set @NettSales = 1
					END
							--INNER JOIN  tb_Item ON SalesDashboard.ItemCode = tb_Item.Item_Code)					
					set @sql =	 ' Select  '+ @DisplayCol + '
							ISNULL(SUM(SalesDashboard.Qty),0) AS Qty, 
							ISNULL(SUM(SalesDashboard.GAmount),0) AS GAmount,
							ISNULL(SUM(SalesDashboard.Discount),0) AS Discount,
							ISNULL(SUM(SalesDashboard.Tax),0) AS Tax,
							ISNULL(SUM(SalesDashboard.NetAmount),0) AS NetAmount, 
							ISNULL(SUM(SalesDashboard.DiscountForTot),0) AS DiscountForTot,
							ISNULL(SUM(SalesDashboard.CostValue),0) AS CostValue,
							ISNULL(SUM(SalesDashboard.NetAmount),0) - ISNULL(SUM(SalesDashboard.CostValue),0) As Profit,Sum(NoOfReceipt) NoOfReceipt, 			
							cast((ISNULL(SUM(SalesDashboard.NetAmount),0)/' + convert(nvarchar, @NettSales) +') * 100  as  decimal(16,2)) AS Ratio,'+ convert(nvarchar, @NettSales) +' As TotalSale
							FROM ((((((SalesDashboard  
							INNER JOIN  tb_Item ON SalesDashboard.ItemCode = tb_Item.Item_Code)
							INNER JOIN tb_Category ON tb_Item.Cat_Code = tb_Category.Cat_Code)
							INNER JOIN tb_SubCategory ON tb_Item.SubCat_Code = tb_SubCategory.SubCat_Code) 
							INNER JOIN tb_Supplier ON tb_Supplier.Supp_Code = tb_Item.Supp_Code)   		
							INNER JOIN tb_Location ON tb_Location.Loca_Code = SalesDashboard.LocaCode)
							INNER JOIN tb_Customer ON tb_Customer.Cust_Code = SalesDashboard.CustCode)	 	
							WHERE '+ @WhereClause +' SalesDashboard.ItemCode IN (SELECT Item_Code FROM Tb_Item WHERE Cat_Code In ('+ @CatCode +')) AND SalesDashboard.ItemCode IN (SELECT Item_Code FROM Tb_Item WHERE Supp_Code In ('+ @SuppCode +')) AND SalesDashboard.CustCode In ('+ @CustCode +' ) And SalesDashboard.ItemCode IN (SELECT Item_Code FROM Tb_Item WHERE SubCat_Code In ('+ @SubCatCode +')) AND
							SalesDashboard.IDate BETWEEN'''+ convert(varchar, @DateFrom, 23) +''' AND '''+ convert(varchar, @DateTo, 23) +''' AND SalesDashboard.LocaCode In ('+ @LocaCode +' ) '+ @GroupByClause +''
					exec (@sql);
					
END
ELSE
IF(@ID=2) --Pur
BEGIN
					IF(@ReportId=1) --Cat
					BEGIN
						IF (@ISSUMMARY=1)
						BEGIN
						set @DisplayCol ='tb_Item.Cat_Code As Code,tb_Category.Cat_Name As Name,'
						--set @WhereClause = 'tb_InvDet.ItemCode IN (SELECT Item_Code FROM Tb_Item WHERE Cat_Code In ('+ @CatCode +')) AND tb_InvDet.ItemCode IN (SELECT Item_Code FROM Tb_Item WHERE Supp_Code In ('+ @SuppCode +')) AND'
						set @GroupByClause = 'GROUP BY tb_Item.Cat_Code,tb_Category.Cat_Name'						  
							END
							ELSE
							  BEGIN
							set @DisplayCol ='tb_InvDet.ItemCode, tb_InvDet.ItemDescrip, tb_InvDet.PackSize,tb_InvDet.CSCode,tb_InvDet.CSName,tb_Item.Cat_Code,tb_Category.Cat_Name,'
							set @WhereClause = 'tb_InvDet.ItemCode IN (SELECT Item_Code FROM Tb_Item WHERE Cat_Code In ('+ @CatCode +')) AND tb_InvDet.ItemCode IN (SELECT Item_Code FROM Tb_Item WHERE Supp_Code In ('+ @SuppCode +')) AND'
							set @GroupByClause = 'GROUP BY tb_InvDet.ItemCode, tb_InvDet.ItemDescrip, tb_InvDet.PackSize,tb_InvDet.CSCode,tb_InvDet.CSName,tb_Item.Cat_Code,tb_Category.Cat_Name'
							END
					END
					ELSE
					IF(@ReportId=2) --Supp
					BEGIN
						IF (@ISSUMMARY=1)
						BEGIN
						set @DisplayCol ='tb_Item.Supp_Code As Code,tb_Supplier.Supp_Name As Name,'
						--set @WhereClause = 'tb_InvDet.ItemCode IN (SELECT Item_Code FROM Tb_Item WHERE Cat_Code In ('+ @CatCode +')) AND tb_InvDet.ItemCode IN (SELECT Item_Code FROM Tb_Item WHERE Supp_Code In ('+ @SuppCode +')) AND'
						set @GroupByClause = 'GROUP BY tb_Item.Supp_Code,tb_Supplier.Supp_Name'						  
							END
							ELSE
							  BEGIN
							set @DisplayCol ='tb_InvDet.ItemCode, tb_InvDet.ItemDescrip, tb_InvDet.PackSize,tb_InvDet.CSCode,tb_InvDet.CSName,tb_Item.Supp_Code,tb_Supplier.Supp_Name,'
							set @WhereClause = 'tb_InvDet.ItemCode IN (SELECT Item_Code FROM Tb_Item WHERE Cat_Code In ('+ @CatCode +')) AND tb_InvDet.ItemCode IN (SELECT Item_Code FROM Tb_Item WHERE Supp_Code In ('+ @SuppCode +')) AND'
							set @GroupByClause = 'GROUP BY tb_InvDet.ItemCode, tb_InvDet.ItemDescrip, tb_InvDet.PackSize,tb_InvDet.CSCode,tb_InvDet.CSName,tb_Item.Supp_Code,tb_Supplier.Supp_Name'
							END

					END
					ELSE
					IF(@ReportId=3) --Loca
					BEGIN
						IF (@ISSUMMARY=1)
						BEGIN
						set @DisplayCol ='tb_PurSumm.LocaCode As Code,tb_Location.Loca_Name As Name,'
						--set @WhereClause = 'tb_InvDet.ItemCode IN (SELECT Item_Code FROM Tb_Item WHERE Cat_Code In ('+ @CatCode +')) AND tb_InvDet.ItemCode IN (SELECT Item_Code FROM Tb_Item WHERE Supp_Code In ('+ @SuppCode +')) AND'
						set @GroupByClause = 'GROUP BY tb_PurSumm.LocaCode,tb_Location.Loca_Name'						  
							END
							ELSE
							  BEGIN
							set @DisplayCol ='tb_InvDet.ItemCode, tb_InvDet.ItemDescrip, tb_InvDet.PackSize,tb_InvDet.CSCode,tb_InvDet.CSName,tb_InvSumm.LocaCode,tb_Location.Loca_Name,'
							set @WhereClause = 'tb_InvDet.ItemCode IN (SELECT Item_Code FROM Tb_Item WHERE Cat_Code In ('+ @CatCode +')) AND tb_InvDet.ItemCode IN (SELECT Item_Code FROM Tb_Item WHERE Supp_Code In ('+ @SuppCode +')) AND'
							set @GroupByClause = 'GROUP BY tb_InvDet.ItemCode, tb_InvDet.ItemDescrip, tb_InvDet.PackSize,tb_InvDet.CSCode,tb_InvDet.CSName,tb_InvSumm.LocaCode,tb_Location.Loca_Name'
							END

					END
					ELSE
					IF(@ReportId=4) --SubCat
					BEGIN
						IF (@ISSUMMARY=1) 
						BEGIN
						set @DisplayCol ='tb_Item.SubCat_Code As Code,tb_SubCategory.SubCat_Name As Name,'
						--set @WhereClause = 'tb_InvDet.ItemCode IN (SELECT Item_Code FROM Tb_Item WHERE Cat_Code In ('+ @CatCode +')) AND tb_InvDet.ItemCode IN (SELECT Item_Code FROM Tb_Item WHERE Supp_Code In ('+ @SuppCode +')) AND tb_InvSumm.CustCode In ('+ @CustCode +' ) And tb_InvDet.ItemCode IN (SELECT Item_Code FROM Tb_Item WHERE SubCat_Code In ('+ @SubCatCode +')) AND '
						set @GroupByClause = 'GROUP BY tb_Item.SubCat_Code,tb_SubCategory.SubCat_Name'						  
							END
							ELSE
							  BEGIN
							set @DisplayCol ='tb_InvDet.ItemCode, tb_InvDet.ItemDescrip, tb_InvDet.PackSize,tb_InvDet.CSCode,tb_InvDet.CSName,tb_InvSumm.LocaCode,tb_Location.Loca_Name,'
							set @WhereClause = 'tb_InvDet.ItemCode IN (SELECT Item_Code FROM Tb_Item WHERE Cat_Code In ('+ @CatCode +')) AND tb_InvDet.ItemCode IN (SELECT Item_Code FROM Tb_Item WHERE Supp_Code In ('+ @SuppCode +')) AND tb_InvSumm.CustCode In ('+ @CustCode +' ) AND '
							set @GroupByClause = 'GROUP BY tb_InvDet.ItemCode, tb_InvDet.ItemDescrip, tb_InvDet.PackSize,tb_InvDet.CSCode,tb_InvDet.CSName,tb_InvSumm.LocaCode,tb_Location.Loca_Name'
							END

					END
					ELSE
					IF(@ReportId=5) --Day
					BEGIN
						IF (@ISSUMMARY=1) 
						BEGIN
						set @DisplayCol ='DatePart(WeekDay,tb_PurSumm.PDate) As Code,DATENAME(dw, tb_PurSumm.PDate) As Name, '
						--set @WhereClause = 'tb_InvDet.ItemCode IN (SELECT Item_Code FROM Tb_Item WHERE Cat_Code In ('+ @CatCode +')) AND tb_InvDet.ItemCode IN (SELECT Item_Code FROM Tb_Item WHERE Supp_Code In ('+ @SuppCode +')) AND tb_InvSumm.CustCode In ('+ @CustCode +' ) AND '
						set @GroupByClause = 'GROUP BY DatePart(WeekDay,tb_PurSumm.PDate),DATENAME(dw, tb_PurSumm.PDate) '						  
							END
							ELSE
							  BEGIN
							set @DisplayCol ='tb_InvDet.ItemCode, tb_InvDet.ItemDescrip, tb_InvDet.PackSize,tb_InvDet.CSCode,tb_InvDet.CSName,tb_InvSumm.LocaCode,tb_Location.Loca_Name,'
							set @WhereClause = 'tb_InvDet.ItemCode IN (SELECT Item_Code FROM Tb_Item WHERE Cat_Code In ('+ @CatCode +')) AND tb_InvDet.ItemCode IN (SELECT Item_Code FROM Tb_Item WHERE Supp_Code In ('+ @SuppCode +')) AND tb_InvSumm.CustCode In ('+ @CustCode +' ) AND '
							set @GroupByClause = 'GROUP BY tb_InvDet.ItemCode, tb_InvDet.ItemDescrip, tb_InvDet.PackSize,tb_InvDet.CSCode,tb_InvDet.CSName,tb_InvSumm.LocaCode,tb_Location.Loca_Name'
							END

					END
					ELSE
					IF(@ReportId=6) -- Mo
					BEGIN
						IF (@ISSUMMARY=1) 
						BEGIN
						set @DisplayCol ='DatePart(Month,tb_PurSumm.PDate) As Code,DATENAME(Month, tb_PurSumm.PDate) As Name, '
						--set @WhereClause = 'tb_InvDet.ItemCode IN (SELECT Item_Code FROM Tb_Item WHERE Cat_Code In ('+ @CatCode +')) AND tb_InvDet.ItemCode IN (SELECT Item_Code FROM Tb_Item WHERE Supp_Code In ('+ @SuppCode +')) AND tb_InvSumm.CustCode In ('+ @CustCode +' ) AND '
						set @GroupByClause = 'GROUP BY DatePart(Month,tb_PurSumm.PDate),DATENAME(Month, tb_PurSumm.PDate) '						  
							END
							ELSE
							  BEGIN
							set @DisplayCol ='tb_InvDet.ItemCode, tb_InvDet.ItemDescrip, tb_InvDet.PackSize,tb_InvDet.CSCode,tb_InvDet.CSName,tb_InvSumm.LocaCode,tb_Location.Loca_Name,'
							set @WhereClause = 'tb_InvDet.ItemCode IN (SELECT Item_Code FROM Tb_Item WHERE Cat_Code In ('+ @CatCode +')) AND tb_InvDet.ItemCode IN (SELECT Item_Code FROM Tb_Item WHERE Supp_Code In ('+ @SuppCode +')) AND tb_InvSumm.CustCode In ('+ @CustCode +' ) AND '
							set @GroupByClause = 'GROUP BY tb_InvDet.ItemCode, tb_InvDet.ItemDescrip, tb_InvDet.PackSize,tb_InvDet.CSCode,tb_InvDet.CSName,tb_InvSumm.LocaCode,tb_Location.Loca_Name,NoOfReceipt'
							END

					END
												
					set @sql =	 ' Select  '+ @DisplayCol +'
							Sum(CASE tb_PurDet.[Id] WHEN ''PCH'' Then tb_PurDet.Qty WHEN ''PRN'' Then -tb_PurDet.Qty Else 0 End) As Qty,  
							Sum(CASE tb_PurDet.[Id] WHEN ''PCH'' Then tb_PurDet.GAmount WHEN ''PRN'' Then -tb_PurDet.GAmount Else 0 End) As GAmount,  
							Sum(CASE tb_PurDet.[Id] WHEN ''PCH'' Then tb_PurDet.Discount WHEN ''PRN'' Then -tb_PurDet.Discount Else 0 End) As Discount,  
							Sum(CASE tb_PurDet.[Id] WHEN ''PCH'' Then tb_PurDet.Tax WHEN ''PRN'' Then -tb_PurDet.Tax Else 0 End) As Tax,  
							Sum(CASE tb_PurDet.[Id] WHEN ''PCH'' Then tb_PurDet.NetAmount WHEN ''PRN'' Then -tb_PurDet.NetAmount Else 0 End) As NetAmount,  
							Sum(CASE tb_PurDet.[Id] WHEN ''PCH'' Then tb_PurDet.DiscountForTot WHEN ''PRN'' Then -tb_PurDet.DiscountForTot Else 0 End) As DiscountForTot,
							ISNULL(SUM(CASE tb_PurDet.[Id] WHEN ''PCH'' THEN (tb_PurDet.Qty*tb_PurDet.Cost) WHEN ''PRN'' THEN (-tb_PurDet.Qty*tb_PurDet.Cost) ELSE 0 END),0) AS CostValue,
							ISNULL(SUM(CASE tb_PurDet.[Id] WHEN ''PCH'' THEN tb_PurDet.NetAmount WHEN ''PRN'' THEN -tb_PurDet.NetAmount ELSE 0 END),0) - ISNULL(SUM(CASE tb_PurDet.[Id] WHEN ''INV'' THEN (tb_PurDet.Qty*tb_PurDet.Cost) WHEN ''MKR'' THEN (-tb_PurDet.Qty*tb_PurDet.Cost) ELSE 0 END),0) As Profit,Count(tb_PurSumm.SerialNo) As NoOfReceipt 			
							FROM ((((((tb_PurDet INNER JOIN  tb_PurSumm ON tb_PurDet.SerialNo = tb_PurSumm.SerialNo AND 
							tb_PurDet.LocaCode = tb_PurSumm.LocaCode AND  tb_PurDet.SuppCode = tb_PurSumm.SuppCode AND tb_PurDet.ID = tb_PurSumm.Id) 
							INNER JOIN  tb_Item ON tb_PurDet.ItemCode = tb_Item.Item_Code)
							INNER JOIN tb_Category ON tb_Item.Cat_Code = tb_Category.Cat_Code)
							INNER JOIN tb_SubCategory ON tb_Item.SubCat_Code = tb_SubCategory.SubCat_Code) 
							INNER JOIN tb_Supplier ON tb_Supplier.Supp_Code = tb_Item.Supp_Code)   		
							INNER JOIN tb_Location ON tb_Location.Loca_Code = tb_PurSumm.LocaCode)	 	
							WHERE ((tb_PurDet.[Id]=''PCH'' OR tb_PurDet.[Id]=''PRN'') AND tb_PurDet.Status =1)
							AND ((tb_PurSumm.[Id]=''PCH'' OR tb_PurSumm.[Id]=''PRN'') AND tb_PurSumm.Status =1) AND '+ @WhereClause +' tb_PurDet.ItemCode IN (SELECT Item_Code FROM Tb_Item WHERE Cat_Code In ('+ @CatCode +')) AND tb_PurDet.ItemCode IN (SELECT Item_Code FROM Tb_Item WHERE Supp_Code In ('+ @SuppCode +')) And tb_PurDet.ItemCode IN (SELECT Item_Code FROM Tb_Item WHERE SubCat_Code In ('+ @SubCatCode +')) AND
							tb_PurSumm.PDate BETWEEN'''+ convert(varchar, @DateFrom, 23) +''' AND '''+ convert(varchar, @DateTo, 23) +''' AND tb_PurSumm.LocaCode In ('+ @LocaCode +' ) '+ @GroupByClause +''
					exec (@sql);
END
ELSE
IF(@ID=3) -- Outstanding
BEGIN

					IF(@ReportId=1) --CREDOUTS
					BEGIN
						IF (@ISSUMMARY=1)
						BEGIN
								SELECT tb_Payment.CustCode Code, tb_Payment.CustName Name,Sum(tb_Payment.Amount) Amount, Sum(tb_Payment.Balance) Balance,tb_PurchaseType.TypeName,tb_PaymentMode.TypeName,tb_Payment.Type FROM ((tb_Payment INNER JOIN tb_PaymentMode ON tb_Payment.PMode = tb_PaymentMode.TypeId) INNER JOIN tb_PurchaseType ON tb_Payment.Type = tb_PurchaseType.TypeId)  Where Status=1 And [Id]='PCH' And Balance<>0		group by  tb_Payment.CustCode, tb_Payment.CustName,tb_PurchaseType.TypeName,tb_PaymentMode.TypeName,tb_Payment.Type				  
							END
							ELSE
							  BEGIN
								SELECT tb_Payment.CustCode Code, tb_Payment.CustName Name, tb_Payment.SerialNo, tb_Payment.RefNo, tb_Payment.InvoiceDate ,tb_Payment.Amount, tb_Payment.Balance, tb_Payment.UserId,tb_PurchaseType.TypeName,tb_PaymentMode.TypeName,tb_Payment.Type,DATEDIFF(Day, [InvoiceDate], GETDATE()) As Age,CASE WHEN DATEDIFF(Day, [InvoiceDate], GETDATE()) BETWEEN @slab1From And @slab1To THEN DATEDIFF(Day, [InvoiceDate], GETDATE()) ELSE '' End slab1, CASE WHEN DATEDIFF(Day, [InvoiceDate], GETDATE()) BETWEEN @slab2From AND @slab2To THEN DATEDIFF(Day, [InvoiceDate], GETDATE()) ELSE '' End slab2,CASE WHEN DATEDIFF(Day, [InvoiceDate], GETDATE()) BETWEEN @slab3From AND @slab3To THEN DATEDIFF(Day, [InvoiceDate], GETDATE()) ELSE '' End slab3, CASE WHEN DATEDIFF(Day, [InvoiceDate], GETDATE()) > @slab3To THEN DATEDIFF(Day, [InvoiceDate], GETDATE()) ELSE '' End slab4 ,CASE WHEN DATEDIFF(Day, [InvoiceDate], GETDATE()) > Credit_Period THEN 1 ELSE 0 End  overdue
								FROM ((tb_Payment INNER JOIN tb_PaymentMode ON tb_Payment.PMode = tb_PaymentMode.TypeId) 
								INNER JOIN tb_PurchaseType ON tb_Payment.Type = tb_PurchaseType.TypeId)
								INNER JOIN tb_Supplier ON tb_Payment.CustCode=tb_Supplier.Supp_Code  
								Where tb_Payment.Status=1 And [Id]='PCH' And tb_Payment.Balance<>0
							END
					END
					ELSE
					IF(@ReportId=2) --DEBTOUTS
					BEGIN
						IF (@ISSUMMARY=1)
						BEGIN
					  		  	SELECT tb_Payment.CustCode Code, tb_Payment.CustName Name,Sum(Case Id When 'INV' Then tb_Payment.Amount Else -tb_Payment.Amount End) As Amount, 
								Sum(Case Id When 'INV' Then tb_Payment.Balance Else -tb_Payment.Balance End) As Balance,tb_PurchaseType.TypeName,tb_PaymentMode.TypeName PaymentMode,tb_Payment.Type
								FROM ((tb_Payment INNER JOIN tb_PaymentMode ON tb_Payment.PMode = tb_PaymentMode.TypeId) 
								INNER JOIN tb_PurchaseType ON tb_Payment.Type = tb_PurchaseType.TypeId) 
								INNER JOIN tb_SalesRep ON tb_Payment.RepCode=tb_SalesRep.Rep_Code
								Where Status=1 And ([Id]='INV' Or [Id]='CRN') And Balance<>0 Group By tb_Payment.CustCode, tb_Payment.CustName ,tb_PurchaseType.TypeName,tb_PaymentMode.TypeName,tb_Payment.Type
							END
							ELSE
							  BEGIN
								SELECT tb_Payment.CustCode Code, tb_Payment.CustName Name, tb_Payment.SerialNo, tb_Payment.RefNo, tb_Payment.InvoiceDate ,Case Id When 'INV' Then tb_Payment.Amount Else -tb_Payment.Amount End As Amount, 
								Case Id When 'INV' Then tb_Payment.Balance Else -tb_Payment.Balance End As Balance, tb_Payment.UserId,tb_PurchaseType.TypeName,tb_PaymentMode.TypeName,tb_Payment.Type,tb_SalesRep.Rep_Name AS Route_Name,DATEDIFF(Day, [InvoiceDate], GETDATE()) As Age,CASE WHEN DATEDIFF(Day, [InvoiceDate], GETDATE()) BETWEEN @slab1From And @slab1To THEN DATEDIFF(Day, [InvoiceDate], GETDATE()) ELSE '' End slab1, CASE WHEN DATEDIFF(Day, [InvoiceDate], GETDATE()) BETWEEN @slab2From AND @slab2To THEN DATEDIFF(Day, [InvoiceDate], GETDATE()) ELSE '' End slab2,CASE WHEN DATEDIFF(Day, [InvoiceDate], GETDATE()) BETWEEN @slab3From AND @slab3To THEN DATEDIFF(Day, [InvoiceDate], GETDATE()) ELSE '' End slab3, CASE WHEN DATEDIFF(Day, [InvoiceDate], GETDATE()) > @slab3To THEN DATEDIFF(Day, [InvoiceDate], GETDATE()) ELSE '' End slab4 ,CASE WHEN DATEDIFF(Day, [InvoiceDate], GETDATE()) > CreditPeriod THEN 1 ELSE 0 End  overdue
								FROM (((tb_Payment INNER JOIN tb_PaymentMode ON tb_Payment.PMode = tb_PaymentMode.TypeId) 
								INNER JOIN tb_PurchaseType ON tb_Payment.Type = tb_PurchaseType.TypeId) 
								INNER JOIN tb_SalesRep ON tb_Payment.RepCode=tb_SalesRep.Rep_Code)
								INNER JOIN tb_customer ON tb_Payment.CustCode=tb_customer.Cust_Code
								Where Status=1 And ([Id]='INV' Or [Id]='CRN') And tb_Payment.Balance<>0 
							END

					END
					ELSE
					 BEGIN
						DECLARE @Credit decimal(18,2), @Debit decimal(18,2), @Points decimal(18,2), @PointsCr decimal(18,2), @GiftVoucher decimal(18,2)

						SELECT @Credit = Isnull(SUM(Balance),0)  FROM dbo.tb_Payment WHERE (Id = 'PCH' OR Id = 'DBN') AND (Balance > 0)
						SELECT @Debit = Isnull(SUM(Balance ),0) FROM tb_Payment WHERE (Id = 'INV') AND (Balance > 0) 
						Select @Points = Isnull(Sum(Case When Iid =1 Then Points When Iid=2 Then -Points Else 0 End),0) From tb_LoyaltyDet
						Select @PointsCr = Isnull(Sum(Case When Iid =3 Then Amount When Iid=4 Then -Amount Else 0 End),0)  From tb_LoyaltyDet
						SELECT @GiftVoucher =  Isnull(Sum(Amount),0) FROM tb_GiftVoucher WHERE  (Sal='T') AND (Rec='F' OR Rec IS NULL) AND Status='F' and SalDate between @DateFrom And @DateTo

						Select @Credit As Credit,@Debit As Debit,@Points As Points,@PointsCr As PointsCr,@GiftVoucher as GiftVoucher

					 END



END
ELSE
IF(@ID=4)  --Stock Val
BEGIN

DECLARE @Stock decimal(18,2), @Pch decimal(18,2), @Add decimal(18,2), @reduce decimal(18,2), @prn decimal(18,2)

Declare @Object NVarchar(20)
Declare @ObjectIdx NVarchar(21)
Declare @ObjectStk NVarchar(21)
Declare @UserName	NVarchar(15)

set @UserName = 'Dash'
Set @Object='tb_' + Rtrim(@UserName) 
Set @ObjectIdx=@Object + 'Idx'
Set @ObjectStk=@Object + 'Stk'

Set @Sql ='if exists (select * from dbo.sysobjects where id = object_id(N''[dbo].[' + Rtrim(@ObjectIdx) + ']'') and OBJECTPROPERTY(id, N''IsUserTable'') = 1) drop table [dbo].[' + rtrim(@ObjectIdx) + ']'
Exec (@Sql)

Set @Sql ='Create Table ' + Rtrim(@ObjectIdx)  + ' ([LocaCode] Varchar(5) Null ,[ItemCode] Varchar(25) Null , [Idx] Int Not Null Default(0))'
Exec (@Sql)

Set @Sql ='Insert Into ' + Rtrim(@ObjectIdx)  + ' ([LocaCode],[ItemCode],[Idx]) Select LocaCode,ItemCode, Max(Idx) From tb_PriceChange Where LocaCode In ('+ @LocaCode + ' ) And (CType=''ITC'' Or CType=''ITU'' Or CType=''PCH'') And CDate < DateAdd(d, 1, ''' + convert(varchar, @DateTo, 23) + ''')' 
Set @Sql = Rtrim(@Sql) + ' And tb_PriceChange.ItemCode Between ''0'' And  ''Z'' Group By ItemCode,LocaCode'

Exec (@Sql)


--Price Change
Set @Sql ='if exists (select * from dbo.sysobjects where id = object_id(N''[dbo].[' + Rtrim(@Object) + ']'') and OBJECTPROPERTY(id, N''IsUserTable'') = 1) drop table [dbo].[' + rtrim(@Object) + ']'
Exec (@Sql)

Set @Sql ='Create Table ' + Rtrim(@Object)  + ' ([LocaCode] Varchar(5) Null ,[ItemCode] Varchar(25) Null ,[Stock] Decimal(18,4) Not Null Default(0),[CostPrice] Money Not Null Default(0),[NewCostPrice] Money Not Null Default(0),[NewERetPrice] Money Not Null Default(0),[NewPRetPrice] Money Not Null Default(0))'
Exec (@Sql)

Set @Sql ='Insert Into ' + Rtrim(@Object)  + ' ([LocaCode],[ItemCode],[Stock],[CostPrice],[NewCostPrice],[NewERetPrice],[NewPRetPrice])'
Set @Sql =Rtrim(@Sql) + ' Select tb_PriceChange.LocaCode,tb_PriceChange.ItemCode,0,tb_PriceChange.NewCostPrice,tb_PriceChange.NewCostPrice,tb_PriceChange.NewERetPrice,tb_PriceChange.NewPRetPrice From tb_PriceChange' 
Set @Sql =Rtrim(@Sql) + ' Inner Join ' + Rtrim(@ObjectIdx) + ' As Idx On tb_PriceChange.ItemCode=Idx.ItemCode And tb_PriceChange.LocaCode=Idx.LocaCode And tb_PriceChange.Idx=Idx.Idx'
Exec (@Sql)

Set @Sql ='Truncate Table ' + Rtrim(@ObjectIdx) 
Exec (@Sql)

Set @Sql ='Drop Table ' + Rtrim(@ObjectIdx) 
Exec (@Sql)

--Stock 
Set @Sql ='if exists (select * from dbo.sysobjects where id = object_id(N''[dbo].[' + Rtrim(@ObjectStk) + ']'') and OBJECTPROPERTY(id, N''IsUserTable'') = 1) drop table [dbo].[' + rtrim(@ObjectStk) + ']'
Exec (@Sql)

Set @Sql ='Create Table ' + Rtrim(@ObjectStk)  + ' ([LocaCode] Varchar(5) Null ,[ItemCode] Varchar(25) Null ,[Stock] Decimal(18,4) Not Null Default(0))'
Exec (@Sql)

		Set @Sql ='Insert Into ' + Rtrim(@ObjectStk)  + ' ([ItemCode],[LocaCode],[Stock]) Select tb_Stock.ItemCode,tb_Stock.LocaCode,Sum(Case [Id] When ''OPB'' Then (PackSize*Qty)'
		Set @Sql =Rtrim(@Sql) + ' When ''PCH'' Then (PackSize*Qty) When ''PRN'' Then -(PackSize*Qty) When ''INV'' Then -(PackSize*Qty) When ''MKR'' Then (PackSize*Qty)'
		Set @Sql =Rtrim(@Sql) + ' When ''DMG'' Then -(PackSize*Qty) When ''PRD'' Then -(PackSize*Qty) When ''DSC'' Then -(PackSize*Qty) When ''ADD'' Then (PackSize*Qty)' 
		Set @Sql =Rtrim(@Sql) + ' When ''TOG'' Then -(PackSize*Qty) When ''AOD'' Then -(PackSize*Qty) When ''IN1'' Then (PackSize*Qty) When ''IN2'' Then (PackSize*Qty) Else 0 End) From tb_Stock'
		Set @Sql =Rtrim(@Sql) + ' Where tb_Stock.LocaCode In ( ' + @LocaCode + ' ) And tb_Stock.Status=1 And tb_Stock.ItemCode Between ''0'' And  ''Z'''
		Set @Sql =Rtrim(@Sql) + ' And tb_Stock.PDate <= ''' + convert(varchar, @DateTo, 23) + '''  Group By tb_Stock.LocaCode,tb_Stock.ItemCode'

Exec (@Sql)

	Set @Sql= 'Delete From ' + Rtrim(@ObjectStk) + ' Where Stock<=0'
	Exec (@Sql)

--Clear Useless Records
Set @Sql= 'Delete From ' + Rtrim(@Object) + ' Where ItemCode Not In (Select ItemCode From ' + @ObjectStk + ')'
Exec (@Sql)

--Reset Stock For Value
Set @Sql ='Update p Set p.Stock=s.Stock From ' + @Object + ' As p Join ' + @ObjectStk + ' As s On p.ItemCode=s.ItemCode And p.LocaCode=s.LocaCode'
Exec (@Sql)
Set @Sql ='Truncate Table ' + Rtrim(@ObjectStk) 
Exec (@Sql)
Set @Sql ='Drop Table ' + Rtrim(@ObjectStk) 
Exec (@Sql)

--Insert Common Object
If Not Exists (Select Top 1 ItemCode From [tb_Value|X] Where UserId<>@UserName) 
Begin
	Truncate Table [tb_Value|X]
End
Else
Begin
	Delete From [tb_Value|X] Where UserId=@UserName
End

Set @Sql='Insert Into [tb_Value|X] ([LocaCode],[ItemCode],[Stock],[CostPrice],[NewCostPrice],[NewERetPrice],[NewPRetPrice],[UserId])'
Set @Sql =Rtrim(@Sql) + ' Select [LocaCode],[ItemCode],[Stock],[CostPrice],[NewCostPrice],[NewERetPrice],[NewPRetPrice],''' + @UserName + ''' From ' + Rtrim(@Object)  
Exec (@Sql)

Set @Sql ='Truncate Table ' + Rtrim(@Object) 
Exec (@Sql)
Set @Sql ='Drop Table ' + Rtrim(@Object) 
Exec (@Sql)

--exec SP_ResetValue '4','1','0','01','0','Z',@DateTo,'Dash'

Set @Sql  = 'SELECT @Stk = SUM([Stock]/Pack_Size*[NewCostPrice])  FROM   tb_Item  INNER JOIN [tb_Value|X] tb_Value_X ON tb_Item.Item_Code = tb_Value_X.ItemCode Where tb_Value_X.UserId=''Dash'' And Isnull(Stock,0)<>0 
And ItemCode IN (SELECT Item_Code FROM Tb_Item WHERE Cat_Code In ('+ @CatCode +')) AND ItemCode IN (SELECT Item_Code FROM Tb_Item WHERE Supp_Code In ('+ @SuppCode +')) And ItemCode IN (SELECT Item_Code FROM Tb_Item WHERE SubCat_Code In ('+ @SubCatCode +'))'

EXECUTE sp_executesql @sql, N'@Stk decimal(18,2) OUTPUT', @Stk=@Stock OUTPUT

--set @sql = 'SELECT  @Stk = CAST(IsNull(SUM(CASE [Id] WHEN ''OPB'' THEN 
--(RetPrice*Qty) WHEN ''PCH'' THEN (RetPrice*Qty) WHEN ''PRN'' THEN -(RetPrice*Qty) WHEN ''INV'' THEN -(RetPrice*Qty) WHEN ''MKR'' THEN 
--(RetPrice*Qty) WHEN ''DMG'' THEN -(RetPrice*Qty) WHEN ''PRD'' THEN -(RetPrice*Qty) WHEN ''DSC'' THEN -(RetPrice*Qty) WHEN ''ADD'' THEN (RetPrice*Qty)
--WHEN ''TOG'' THEN -(RetPrice*Qty) WHEN ''AOD'' THEN -(RetPrice*Qty) WHEN ''IN1'' THEN (RetPrice*Qty) WHEN ''IN2'' THEN (RetPrice*Qty) ELSE 0 END),0) as  decimal(16,2))
--FROM tb_Stock WHERE Status=1 And Pdate <= '''+ convert(varchar, @DateTo, 23) +''' And ItemCode IN (SELECT Item_Code FROM Tb_Item WHERE Cat_Code In ('+ @CatCode +')) AND ItemCode IN (SELECT Item_Code FROM Tb_Item WHERE Supp_Code In ('+ @SuppCode +')) And ItemCode IN (SELECT Item_Code FROM Tb_Item WHERE SubCat_Code In ('+ @SubCatCode +'))'

--print (@sql)
--EXECUTE sp_executesql @sql, N'@Stk decimal(18,2) OUTPUT', @Stk=@Stock OUTPUT

set @sql = 'SELECT ' + convert(nvarchar, @Stock) +  ' Stock,
CAST(IsNull(SUM(CASE [Id] WHEN ''PCH'' THEN (RetPrice*(Packsize*Qty)) WHEN ''PRN'' THEN -(RetPrice*(Packsize*Qty))  ELSE 0 END),0) as  decimal(16,2))  As Purchase,
CAST(IsNull(SUM(CASE [Id] WHEN ''PRN'' THEN (RetPrice*(Packsize*Qty)) ELSE 0 END),0) as  decimal(16,2)) As PurchaseReturn,
CAST(IsNull(SUM(CASE [Id] WHEN ''OPB'' THEN (RetPrice*(Packsize*Qty)) WHEN ''ADD'' THEN  (RetPrice*(Packsize*Qty)) ELSE 0 END),0) as  decimal(16,2)) As Added,
CAST(IsNull(SUM(CASE [Id] WHEN ''DMG'' THEN (RetPrice*(Packsize*Qty)) WHEN ''PRD'' THEN  (RetPrice*(Packsize*Qty)) WHEN ''DSC'' THEN (RetPrice*(Packsize*Qty)) ELSE 0 END),0) as  decimal(16,2)) As Reduced,
CAST(IsNull(SUM(CASE [Id] WHEN ''INV'' THEN (RetPrice*(Packsize*Qty)) WHEN ''MKR'' THEN -(RetPrice*(Packsize*Qty)) ELSE 0 END),0) as  decimal(16,2)) As Sales
FROM tb_Stock WHERE Status=1 And PDate BETWEEN '''+ convert(varchar, @DateFrom, 23) +''' AND '''+ convert(varchar, @DateTo, 23) +''' AND LocaCode In ('+ @LocaCode +' ) And ItemCode IN (SELECT Item_Code FROM Tb_Item WHERE Cat_Code In ('+ @CatCode +')) AND ItemCode IN (SELECT Item_Code FROM Tb_Item WHERE Supp_Code In ('+ @SuppCode +')) And ItemCode IN (SELECT Item_Code FROM Tb_Item WHERE SubCat_Code In ('+ @SubCatCode +'))'

exec (@sql);

END
ELSE
IF(@ID=5) -- Rol
BEGIN

					IF(@ReportId=1) --Cat
					BEGIN
						IF (@ISSUMMARY=1)
						BEGIN
							set @DisplayCol ='tb_Item.Cat_Code As Code,tb_Category.Cat_Name As Name, '' '' As Item_Code,'
							set @GroupByClause = 'GROUP BY tb_Item.Cat_Code,tb_Category.Cat_Name'						  
							END
							ELSE
							  BEGIN
							set @DisplayCol ='tb_Item.SubCat_Code,tb_SubCategory.SubCat_Name,tb_Item.Item_Code, tb_Item.Descrip,tb_Item.Cat_Code, tb_Category.Cat_Name,tb_Item.Pack_Size, tb_Item.PUnit, tb_Item.EUnit,tb_Item.Ref_Code,tb_ItemDet.PRet_Price, tb_ItemDet.ERet_Price, tb_ItemDet.Cost_Price,tb_Item.Supp_Code,tb_Supplier.Supp_Name,'
							set @GroupByClause = 'GROUP BY tb_Item.SubCat_Code,tb_SubCategory.SubCat_Name,tb_Item.Item_Code, tb_Item.Descrip,tb_Item.Cat_Code, tb_Category.Cat_Name,tb_Item.Pack_Size, tb_Item.PUnit, tb_Item.EUnit,tb_Item.Ref_Code,tb_ItemDet.PRet_Price, tb_ItemDet.ERet_Price, tb_ItemDet.Cost_Price,tb_Item.Supp_Code,tb_Supplier.Supp_Name'
							END
					END
					ELSE
					IF(@ReportId=2) --Supp
					BEGIN
						IF (@ISSUMMARY=1)
						BEGIN
						set @DisplayCol ='tb_Item.Supp_Code As Code,tb_Supplier.Supp_Name As Name, '' '' As Item_Code,'
						set @GroupByClause = 'GROUP BY tb_Item.Supp_Code,tb_Supplier.Supp_Name'						  
							END
							ELSE
							  BEGIN
							set @DisplayCol ='tb_Item.SubCat_Code,tb_SubCategory.SubCat_Name,tb_Item.Item_Code, tb_Item.Descrip,tb_Item.Cat_Code, tb_Category.Cat_Name,tb_Item.Pack_Size, tb_Item.PUnit, tb_Item.EUnit,tb_Item.Ref_Code,tb_ItemDet.PRet_Price, tb_ItemDet.ERet_Price, tb_ItemDet.Cost_Price,tb_Item.Supp_Code,tb_Supplier.Supp_Name,'
							set @GroupByClause = 'GROUP BY tb_Item.SubCat_Code,tb_SubCategory.SubCat_Name,tb_Item.Item_Code, tb_Item.Descrip,tb_Item.Cat_Code, tb_Category.Cat_Name,tb_Item.Pack_Size, tb_Item.PUnit, tb_Item.EUnit,tb_Item.Ref_Code,tb_ItemDet.PRet_Price, tb_ItemDet.ERet_Price, tb_ItemDet.Cost_Price,tb_Item.Supp_Code,tb_Supplier.Supp_Name'							END

					END
					ELSE
					IF(@ReportId=3) --Loca
					BEGIN
						IF (@ISSUMMARY=1)
						BEGIN
						set @DisplayCol ='tb_Location.Loca_Code As Code,tb_Location.Loca_Name As Name, '' '' As Item_Code,'
						set @GroupByClause = 'GROUP BY tb_Location.Loca_Code,tb_Location.Loca_Name'						  
							END
							ELSE
							  BEGIN
							set @DisplayCol ='tb_Item.SubCat_Code,tb_SubCategory.SubCat_Name,tb_Item.Item_Code, tb_Item.Descrip,tb_Item.Cat_Code, tb_Category.Cat_Name,tb_Item.Pack_Size, tb_Item.PUnit, tb_Item.EUnit,tb_Item.Ref_Code,tb_ItemDet.PRet_Price, tb_ItemDet.ERet_Price, tb_ItemDet.Cost_Price,tb_Item.Supp_Code,tb_Supplier.Supp_Name,'
							set @GroupByClause = 'GROUP BY tb_Item.SubCat_Code,tb_SubCategory.SubCat_Name,tb_Item.Item_Code, tb_Item.Descrip,tb_Item.Cat_Code, tb_Category.Cat_Name,tb_Item.Pack_Size, tb_Item.PUnit, tb_Item.EUnit,tb_Item.Ref_Code,tb_ItemDet.PRet_Price, tb_ItemDet.ERet_Price, tb_ItemDet.Cost_Price,tb_Item.Supp_Code,tb_Supplier.Supp_Name'							END

					END
					ELSE
					IF(@ReportId=4) --SubCat
					BEGIN
						IF (@ISSUMMARY=1) 
						BEGIN
						set @DisplayCol ='tb_Item.SubCat_Code As Code,tb_SubCategory.SubCat_Name As Name, '' '' As Item_Code,'
						set @GroupByClause = 'GROUP BY tb_Item.SubCat_Code,tb_SubCategory.SubCat_Name'						  
							END
							ELSE
							  BEGIN
							set @DisplayCol ='tb_Item.SubCat_Code,tb_SubCategory.SubCat_Name,tb_Item.Item_Code, tb_Item.Descrip,tb_Item.Cat_Code, tb_Category.Cat_Name,tb_Item.Pack_Size, tb_Item.PUnit, tb_Item.EUnit,tb_Item.Ref_Code,tb_ItemDet.PRet_Price, tb_ItemDet.ERet_Price, tb_ItemDet.Cost_Price,tb_Item.Supp_Code,tb_Supplier.Supp_Name,'
							set @GroupByClause = 'GROUP BY tb_Item.SubCat_Code,tb_SubCategory.SubCat_Name,tb_Item.Item_Code, tb_Item.Descrip,tb_Item.Cat_Code, tb_Category.Cat_Name,tb_Item.Pack_Size, tb_Item.PUnit, tb_Item.EUnit,tb_Item.Ref_Code,tb_ItemDet.PRet_Price, tb_ItemDet.ERet_Price, tb_ItemDet.Cost_Price,tb_Item.Supp_Code,tb_Supplier.Supp_Name'
							END

					END


set @sql =	'IF OBJECT_ID(''tempdb..#TempRol'') IS NOT NULL BEGIN DROP TABLE #TempRol END SELECT   '+ @DisplayCol + ' Sum(tb_ItemDet.Re_Qty) As ReQty,Sum(tb_ItemDet.Rol) As Rol ,Sum(vw_Stock.Stock) As Stock,Count(*) As Count,'' 1990-01-01 '' LastSalesDate,'' 1990-01-01 '' LastPurchaseDate into #TempRol
			FROM ((((( tb_ItemDet INNER JOIN tb_Item ON  tb_Item.Item_Code = tb_ItemDet.Item_Code)
			INNER JOIN tb_Category ON tb_Item.Cat_Code = tb_Category.Cat_Code)
			INNER JOIN tb_SubCategory ON tb_Item.SubCat_Code = tb_SubCategory.SubCat_Code) 
			INNER JOIN tb_Supplier ON tb_Supplier.Supp_Code = tb_Item.Supp_Code)   		
			INNER JOIN tb_Location ON tb_Location.Loca_Code = tb_ItemDet.Loca_Code) 
			LEFT OUTER JOIN vw_Stock ON  tb_ItemDet.Item_Code = vw_Stock.ItemCode AND tb_ItemDet.Loca_Code = vw_Stock.LocaCode 
			WHERE  tb_Item.Cat_Code In ('+ @CatCode +') AND tb_Item.Supp_Code In ('+ @SuppCode +') AND tb_Item.SubCat_Code In ('+ @SubCatCode +') AND
			tb_ItemDet.Loca_Code in ('+@LocaCode+') AND tb_ItemDet.Re_Qty > 0 AND (vw_Stock.Stock/tb_Item.Pack_Size)< tb_ItemDet.Rol ' + @GroupByClause +'

			IF OBJECT_ID(''tempdb..#TempR'') IS NOT NULL BEGIN DROP TABLE #TempR END 
			select * into #TempR from (
			select itemcode,qty, Pdate as LastDate,''PCH'' As Id
			from (select 
						 itemcode,
						 Qty,
						 Pdate,
						 row_number() over(partition by itemcode order by pdate desc) as rn
				  from tb_PurDet where id=''PCH'') as T
			where rn = 1  
			union all
			select itemcode,qty, Idate as LastDate,''INV''  As Id
			from (select 
						 itemcode,
						 Qty,
						 Idate,
						 row_number() over(partition by itemcode order by idate desc) as rn
				  from tb_invDet where id=''INV'') as T
			where rn = 1  

			) a

			update u
			set u.LastSalesDate = convert(varchar, s.LastDate, 23)
			from #TempRol  u
				inner join #TempR s on
					u.Item_Code = s.itemcode and s.Id=''INV''

					update u
			set u.LastPurchaseDate =  convert(varchar, s.LastDate, 23)
			from #TempRol  u
				inner join #TempR s on
					u.Item_Code = s.itemcode and s.Id=''PCH''

			Select * from #TempRol '
			exec (@sql);

END
ELSE
IF(@ID=6) -- Fast Moving
BEGIN
					IF(@ReportId=1) --Cat
					BEGIN
						IF (@ISSUMMARY=1)
						BEGIN
						set @DisplayCol ='tb_Item.Cat_Code As Code,tb_Category.Cat_Name As Name,Isnull(Sum(#TempTable.Stk),0)  As CurrentQty,'
						set @GroupByClause = 'GROUP BY tb_Item.Cat_Code,tb_Category.Cat_Name'						  
							END
							ELSE
							  BEGIN
							--set @DisplayCol ='SalesDashboard.ItemCode  As Code, tb_Item.Inv_Descrip As Name,SalesDashboard.Cost As CostPrice,SalesDashboard.Rate As UnitPrice,Isnull(#TempTable.Stk,0)  As CurrentQty,tb_Item.SubCat_Code As SubCatCode ,tb_SubCategory.SubCat_Name As SubCatName,tb_Item.Cat_Code As CatCode, tb_Category.Cat_Name CatName,tb_Item.Supp_Code SuppCode,tb_Supplier.Supp_Name As SuppName,'
							--set @GroupByClause = 'GROUP BY SalesDashboard.ItemCode, tb_Item.Inv_Descrip,SalesDashboard.Cost,SalesDashboard.Rate,#TempTable.Stk,tb_Item.SubCat_Code,tb_SubCategory.SubCat_Name,tb_Item.Cat_Code, tb_Category.Cat_Name,tb_Item.Supp_Code,tb_Supplier.Supp_Name'
							set @DisplayCol ='SalesDashboard.ItemCode  As Code, tb_Item.Inv_Descrip As Name,0 As CostPrice,0 As UnitPrice,Isnull(#TempTable.Stk,0)  As CurrentQty,tb_Item.SubCat_Code As SubCatCode ,tb_SubCategory.SubCat_Name As SubCatName,tb_Item.Cat_Code As CatCode, tb_Category.Cat_Name CatName,tb_Item.Supp_Code SuppCode,tb_Supplier.Supp_Name As SuppName,'
							set @GroupByClause = 'GROUP BY SalesDashboard.ItemCode, tb_Item.Inv_Descrip,#TempTable.Stk,tb_Item.SubCat_Code,tb_SubCategory.SubCat_Name,tb_Item.Cat_Code, tb_Category.Cat_Name,tb_Item.Supp_Code,tb_Supplier.Supp_Name'
							END
					END
					ELSE
					IF(@ReportId=2) --Supp
					BEGIN
						IF (@ISSUMMARY=1)
						BEGIN
						set @DisplayCol ='tb_Item.Supp_Code As Code,tb_Supplier.Supp_Name As Name,Isnull(Sum(#TempTable.Stk),0) As CurrentQty,'
						set @GroupByClause = 'GROUP BY tb_Item.Supp_Code,tb_Supplier.Supp_Name'						  
							END
							ELSE
							  BEGIN
							--set @DisplayCol ='SalesDashboard.ItemCode  As Code, tb_Item.Inv_Descrip As Name,SalesDashboard.Cost As CostPrice,SalesDashboard.Rate As UnitPrice,Isnull(#TempTable.Stk,0)  As CurrentQty,tb_Item.SubCat_Code As SubCatCode ,tb_SubCategory.SubCat_Name As SubCatName,tb_Item.Cat_Code As CatCode, tb_Category.Cat_Name CatName,tb_Item.Supp_Code SuppCode,tb_Supplier.Supp_Name As SuppName,'
							--set @GroupByClause = 'GROUP BY SalesDashboard.ItemCode, tb_Item.Inv_Descrip,SalesDashboard.Cost,SalesDashboard.Rate,#TempTable.Stk,tb_Item.SubCat_Code,tb_SubCategory.SubCat_Name,tb_Item.Cat_Code, tb_Category.Cat_Name,tb_Item.Supp_Code,tb_Supplier.Supp_Name'							
							set @DisplayCol ='SalesDashboard.ItemCode  As Code, tb_Item.Inv_Descrip As Name,0 As CostPrice,0 As UnitPrice,Isnull(#TempTable.Stk,0)  As CurrentQty,tb_Item.SubCat_Code As SubCatCode ,tb_SubCategory.SubCat_Name As SubCatName,tb_Item.Cat_Code As CatCode, tb_Category.Cat_Name CatName,tb_Item.Supp_Code SuppCode,tb_Supplier.Supp_Name As SuppName,'
							set @GroupByClause = 'GROUP BY SalesDashboard.ItemCode, tb_Item.Inv_Descrip,#TempTable.Stk,tb_Item.SubCat_Code,tb_SubCategory.SubCat_Name,tb_Item.Cat_Code, tb_Category.Cat_Name,tb_Item.Supp_Code,tb_Supplier.Supp_Name'
							END

					END
					ELSE
					IF(@ReportId=3) --Loca
					BEGIN
						IF (@ISSUMMARY=1)
						BEGIN
						set @DisplayCol ='tb_Location.Loca_Code As Code,tb_Location.Loca_Name As Name,Isnull(Sum(#TempTable.Stk),0)  As CurrentQty,'
						set @GroupByClause = 'GROUP BY tb_Location.Loca_Code,tb_Location.Loca_Name'						  
							END
							ELSE
							  BEGIN
							--set @DisplayCol ='SalesDashboard.ItemCode  As Code, tb_Item.Inv_Descrip As Name,SalesDashboard.Cost As CostPrice,SalesDashboard.Rate As UnitPrice,Isnull(#TempTable.Stk,0) As CurrentQty,tb_Item.SubCat_Code As SubCatCode ,tb_SubCategory.SubCat_Name As SubCatName,tb_Item.Cat_Code As CatCode, tb_Category.Cat_Name CatName,tb_Item.Supp_Code SuppCode,tb_Supplier.Supp_Name As SuppName,'
							--set @GroupByClause = 'GROUP BY SalesDashboard.ItemCode, tb_Item.Inv_Descrip,SalesDashboard.Cost,SalesDashboard.Rate,#TempTable.Stk,tb_Item.SubCat_Code,tb_SubCategory.SubCat_Name,tb_Item.Cat_Code, tb_Category.Cat_Name,tb_Item.Supp_Code,tb_Supplier.Supp_Name'
							set @DisplayCol ='SalesDashboard.ItemCode  As Code, tb_Item.Inv_Descrip As Name,0 As CostPrice,0 As UnitPrice,Isnull(#TempTable.Stk,0)  As CurrentQty,tb_Item.SubCat_Code As SubCatCode ,tb_SubCategory.SubCat_Name As SubCatName,tb_Item.Cat_Code As CatCode, tb_Category.Cat_Name CatName,tb_Item.Supp_Code SuppCode,tb_Supplier.Supp_Name As SuppName,'
							set @GroupByClause = 'GROUP BY SalesDashboard.ItemCode, tb_Item.Inv_Descrip,#TempTable.Stk,tb_Item.SubCat_Code,tb_SubCategory.SubCat_Name,tb_Item.Cat_Code, tb_Category.Cat_Name,tb_Item.Supp_Code,tb_Supplier.Supp_Name'
							END

					END
					ELSE
					IF(@ReportId=4) --SubCat
					BEGIN
						IF (@ISSUMMARY=1) 
						BEGIN
						set @DisplayCol ='tb_Item.SubCat_Code As Code,tb_SubCategory.SubCat_Name As Name,Isnull(Sum(#TempTable.Stk),0)  As CurrentQty,'
						set @GroupByClause = 'GROUP BY tb_Item.SubCat_Code,tb_SubCategory.SubCat_Name'						  
							END
							ELSE
							  BEGIN
							--set @DisplayCol ='SalesDashboard.ItemCode  As Code, tb_Item.Inv_Descrip As Name,SalesDashboard.Cost As CostPrice,SalesDashboard.Rate As UnitPrice,Isnull(#TempTable.Stk,0)  As CurrentQty,tb_Item.SubCat_Code As SubCatCode ,tb_SubCategory.SubCat_Name As SubCatName,tb_Item.Cat_Code As CatCode, tb_Category.Cat_Name CatName,tb_Item.Supp_Code SuppCode,tb_Supplier.Supp_Name As SuppName,'
							--set @GroupByClause = 'GROUP BY SalesDashboard.ItemCode, tb_Item.Inv_Descrip,SalesDashboard.Cost,SalesDashboard.Rate,#TempTable.Stk,tb_Item.SubCat_Code,tb_SubCategory.SubCat_Name,tb_Item.Cat_Code, tb_Category.Cat_Name,tb_Item.Supp_Code,tb_Supplier.Supp_Name'
														set @DisplayCol ='SalesDashboard.ItemCode  As Code, tb_Item.Inv_Descrip As Name,0 As CostPrice,0 As UnitPrice,Isnull(#TempTable.Stk,0)  As CurrentQty,tb_Item.SubCat_Code As SubCatCode ,tb_SubCategory.SubCat_Name As SubCatName,tb_Item.Cat_Code As CatCode, tb_Category.Cat_Name CatName,tb_Item.Supp_Code SuppCode,tb_Supplier.Supp_Name As SuppName,'
							set @GroupByClause = 'GROUP BY SalesDashboard.ItemCode, tb_Item.Inv_Descrip,#TempTable.Stk,tb_Item.SubCat_Code,tb_SubCategory.SubCat_Name,tb_Item.Cat_Code, tb_Category.Cat_Name,tb_Item.Supp_Code,tb_Supplier.Supp_Name'
							END

					END
					
					set @sql =	 ' Select  @cnt = ISNULL(SUM(SalesDashboard.NetAmount),0)		
							FROM SalesDashboard  INNER JOIN  tb_Item ON SalesDashboard.ItemCode = tb_Item.Item_Code
							WHERE  '+ @WhereClause +' SalesDashboard.IDate BETWEEN '''+ convert(varchar, @DateFrom, 23) +''' AND '''+ convert(varchar, @DateTo, 23) +''' AND SalesDashboard.LocaCode In ('+ @LocaCode +' ) '
					--print (@sql);

					EXECUTE sp_executesql @sql, N'@cnt money OUTPUT', @cnt=@NettSales OUTPUT
					--select @NettSales

					set @sql = 'IF OBJECT_ID(''tempdb..#TempTable'') IS NOT NULL 
								BEGIN 
									DROP TABLE #TempTable
								END 
					SELECT  CAST(IsNull(SUM(CASE [Id] WHEN ''OPB'' THEN 
					(Qty) WHEN ''PCH'' THEN (Qty) WHEN ''PRN'' THEN -(Qty) WHEN ''INV'' THEN -(Qty) WHEN ''MKR'' THEN 
					(Qty) WHEN ''DMG'' THEN -(Qty) WHEN ''PRD'' THEN -(Qty) WHEN ''DSC'' THEN -(Qty) WHEN ''ADD'' THEN (Qty)
					WHEN ''TOG'' THEN -(Qty) WHEN ''AOD'' THEN -(Qty) WHEN ''IN1'' THEN (Qty) WHEN ''IN2'' THEN (Qty) ELSE 0 END),0) as  decimal(16,2)) As Stk,ItemCode,LocaCode INTO #TempTable
					FROM tb_Stock WHERE Status=1 And Pdate <= getdate() And ItemCode IN (SELECT Item_Code FROM Tb_Item WHERE Cat_Code In ('+ @CatCode +')) AND ItemCode IN (SELECT Item_Code FROM Tb_Item WHERE Supp_Code In ('+ @SuppCode +')) And ItemCode IN (SELECT Item_Code FROM Tb_Item WHERE SubCat_Code In ('+ @SubCatCode +')) group by ItemCode,LocaCode

					Select  top 100 '+ @DisplayCol + '
							ISNULL(SUM(SalesDashboard.Qty),0) AS SoldQty, 
							ISNULL(SUM(SalesDashboard.Qty*SalesDashboard.Rate),0) AS Sales, 
							ISNULL(SUM(SalesDashboard.Qty*SalesDashboard.Cost),0) AS CostOfSales,
							cast(ISNULL(SUM(SalesDashboard.Qty*SalesDashboard.Rate),0) - ISNULL(SUM(SalesDashboard.Qty*SalesDashboard.Cost),0) / ISNULL(SUM(SalesDashboard.Qty*SalesDashboard.Rate),0) as  decimal(16,2)) As GPMargin, NoOfReceipt, 			
							cast(ISNULL(SUM(SalesDashboard.Qty*SalesDashboard.Rate) ,0) /' + convert(nvarchar, @NettSales) +' * 100  as  decimal(16,2)) AS SalesRatio,Count(*) As Count
							FROM ((((((SalesDashboard INNER JOIN  tb_Item ON SalesDashboard.ItemCode = tb_Item.Item_Code) 
							INNER JOIN tb_Category ON tb_Item.Cat_Code = tb_Category.Cat_Code)
							INNER JOIN tb_SubCategory ON tb_Item.SubCat_Code = tb_SubCategory.SubCat_Code) 
							INNER JOIN tb_Supplier ON tb_Supplier.Supp_Code = tb_Item.Supp_Code)   		
							INNER JOIN tb_Location ON tb_Location.Loca_Code = SalesDashboard.LocaCode)
							LEFT OUTER JOIN #TempTable ON #TempTable.LocaCode = SalesDashboard.LocaCode And #TempTable.ItemCode = SalesDashboard.ItemCode)	 	
							WHERE '+ @WhereClause +' SalesDashboard.ItemCode IN (SELECT Item_Code FROM Tb_Item WHERE Cat_Code In ('+ @CatCode +')) AND SalesDashboard.ItemCode IN (SELECT Item_Code FROM Tb_Item WHERE Supp_Code In ('+ @SuppCode +')) And SalesDashboard.ItemCode IN (SELECT Item_Code FROM Tb_Item WHERE SubCat_Code In ('+ @SubCatCode +')) AND
							SalesDashboard.IDate BETWEEN'''+ convert(varchar, @DateFrom, 23) +''' AND '''+ convert(varchar, @DateTo, 23) +''' AND SalesDashboard.LocaCode In ('+ @LocaCode +' ) '+ @GroupByClause +' having ISNULL(SUM(SalesDashboard.Qty),0) > 0 Order By ISNULL(SUM(SalesDashboard.Qty),0) DESC'
					exec (@sql);
END
ELSE
IF(@ID=7) -- Non Moving
BEGIN
--2.	Non Moving
--Non Moving Items Report
--Code, Name, Qty, Cost Price, Unit Price, Cost Value, Stock Ratio%

--Non Moving Cat, Sub Cat, Supp, Location Report
--Code, Name, Qty, Stock Value, Stock Ratio%

					IF(@ReportId=1) --Cat
					BEGIN
						IF (@ISSUMMARY=1)
						BEGIN
						set @DisplayCol ='tb_Item.Cat_Code As Code,tb_Category.Cat_Name As Name,Count(tb_Item.Item_Code) Count,'
						set @GroupByClause = ' GROUP BY tb_Item.Cat_Code,tb_Category.Cat_Name'						  
							END
							ELSE
							  BEGIN
							set @DisplayCol ='tb_Item.Item_Code  As Code, tb_Item.Inv_Descrip As Name,Cost_Price As CostPrice,ERet_Price As UnitPrice,tb_Item.SubCat_Code As SubCatCode ,tb_SubCategory.SubCat_Name As SubCatName,tb_Item.Cat_Code As CatCode, tb_Category.Cat_Name CatName,tb_Item.Supp_Code SuppCode,tb_Supplier.Supp_Name As SuppName ,IsNull(LastSalesDate,'''') LastSalesDate,IsNull(LastPurchaseDate,'''') LastPurchaseDate,'
							set @GroupByClause = ' GROUP BY tb_Item.Item_Code, tb_Item.Inv_Descrip,Cost_Price,ERet_Price,tb_Item.SubCat_Code,tb_SubCategory.SubCat_Name,tb_Item.Cat_Code, tb_Category.Cat_Name,tb_Item.Supp_Code,tb_Supplier.Supp_Name,LastSalesDate,LastPurchaseDate'
							END
					END
					ELSE
					IF(@ReportId=2) --Supp
					BEGIN
						IF (@ISSUMMARY=1)
						BEGIN
						set @DisplayCol =' tb_Item.Supp_Code As Code,tb_Supplier.Supp_Name As Name,Count(tb_Item.Item_Code) Count,'
						set @GroupByClause = ' GROUP BY tb_Item.Supp_Code,tb_Supplier.Supp_Name'						  
							END
							ELSE
							  BEGIN
							set @DisplayCol ='tb_Item.Item_Code  As Code, tb_Item.Inv_Descrip As Name,Cost_Price As CostPrice,ERet_Price As UnitPrice,tb_Item.SubCat_Code As SubCatCode ,tb_SubCategory.SubCat_Name As SubCatName,tb_Item.Cat_Code As CatCode, tb_Category.Cat_Name CatName,tb_Item.Supp_Code SuppCode,tb_Supplier.Supp_Name As SuppName,IsNull(LastSalesDate,'''') LastSalesDate,IsNull(LastPurchaseDate,'''') LastPurchaseDate,'
							set @GroupByClause = ' GROUP BY tb_Item.Item_Code, tb_Item.Inv_Descrip,Cost_Price,ERet_Price,tb_Item.SubCat_Code,tb_SubCategory.SubCat_Name,tb_Item.Cat_Code, tb_Category.Cat_Name,tb_Item.Supp_Code,tb_Supplier.Supp_Name,LastSalesDate,LastPurchaseDate'							
							END

					END
					ELSE
					IF(@ReportId=3) --Loca
					BEGIN
						IF (@ISSUMMARY=1)
						BEGIN
						set @DisplayCol ='tb_Location.Loca_Code As Code,tb_Location.Loca_Name As Name,Count(tb_Item.Item_Code) Count,'
						set @GroupByClause = ' GROUP BY tb_Location.Loca_Code,tb_Location.Loca_Name'						  
							END
							ELSE
							  BEGIN
							set @DisplayCol ='tb_Item.Item_Code  As Code, tb_Item.Inv_Descrip As Name,Cost_Price As CostPrice,ERet_Price As UnitPrice,tb_Item.SubCat_Code As SubCatCode ,tb_SubCategory.SubCat_Name As SubCatName,tb_Item.Cat_Code As CatCode, tb_Category.Cat_Name CatName,tb_Item.Supp_Code SuppCode,tb_Supplier.Supp_Name As SuppName,IsNull(LastSalesDate,'''') LastSalesDate,IsNull(LastPurchaseDate,'''') LastPurchaseDate,'
							set @GroupByClause = ' GROUP BY tb_Item.Item_Code, tb_Item.Inv_Descrip,Cost_Price,ERet_Price,tb_Item.SubCat_Code,tb_SubCategory.SubCat_Name,tb_Item.Cat_Code, tb_Category.Cat_Name,tb_Item.Supp_Code,tb_Supplier.Supp_Name,LastSalesDate,LastPurchaseDate'
							END

					END
					ELSE
					IF(@ReportId=4) --SubCat
					BEGIN
						IF (@ISSUMMARY=1) 
						BEGIN
						set @DisplayCol ='tb_Item.SubCat_Code As Code,tb_SubCategory.SubCat_Name As Name,Count(tb_Item.Item_Code) Count,'
						set @GroupByClause = ' GROUP BY tb_Item.SubCat_Code,tb_SubCategory.SubCat_Name'						  
							END
							ELSE
							  BEGIN
							set @DisplayCol ='tb_Item.Item_Code  As Code, tb_Item.Inv_Descrip As Name,Cost_Price As CostPrice,ERet_Price As UnitPrice,tb_Item.SubCat_Code As SubCatCode ,tb_SubCategory.SubCat_Name As SubCatName,tb_Item.Cat_Code As CatCode, tb_Category.Cat_Name CatName,tb_Item.Supp_Code SuppCode,tb_Supplier.Supp_Name As SuppName,IsNull(LastSalesDate,'''') LastSalesDate,IsNull(LastPurchaseDate,'''') LastPurchaseDate,'
							set @GroupByClause = ' GROUP BY tb_Item.Item_Code, tb_Item.Inv_Descrip,Cost_Price,ERet_Price,tb_Item.SubCat_Code,tb_SubCategory.SubCat_Name,tb_Item.Cat_Code, tb_Category.Cat_Name,tb_Item.Supp_Code,tb_Supplier.Supp_Name,LastSalesDate,LastPurchaseDate'
							END

					END


set @UserName = 'Non'
Set @Object='tb_' + Rtrim(@UserName) 
Set @ObjectIdx=@Object + 'Idx'
Set @ObjectStk=@Object + 'Stk'

Set @Sql ='if exists (select * from dbo.sysobjects where id = object_id(N''[dbo].[' + Rtrim(@ObjectIdx) + ']'') and OBJECTPROPERTY(id, N''IsUserTable'') = 1) drop table [dbo].[' + rtrim(@ObjectIdx) + ']'
Exec (@Sql)

Set @Sql ='Create Table ' + Rtrim(@ObjectIdx)  + ' ([LocaCode] Varchar(5) Null ,[ItemCode] Varchar(25) Null , [Idx] Int Not Null Default(0))'
Exec (@Sql)

Set @Sql ='Insert Into ' + Rtrim(@ObjectIdx)  + ' ([LocaCode],[ItemCode],[Idx]) Select LocaCode,ItemCode, Max(Idx) From tb_PriceChange Where LocaCode In ('+ @LocaCode + ' ) And (CType=''ITC'' Or CType=''ITU'' Or CType=''PCH'') And CDate < DateAdd(d, 1, ''' + convert(varchar, @DateTo, 23) + ''')' 
Set @Sql = Rtrim(@Sql) + ' And tb_PriceChange.ItemCode Between ''0'' And  ''Z'' Group By ItemCode,LocaCode'

Exec (@Sql)


--Price Change
Set @Sql ='if exists (select * from dbo.sysobjects where id = object_id(N''[dbo].[' + Rtrim(@Object) + ']'') and OBJECTPROPERTY(id, N''IsUserTable'') = 1) drop table [dbo].[' + rtrim(@Object) + ']'
Exec (@Sql)

Set @Sql ='Create Table ' + Rtrim(@Object)  + ' ([LocaCode] Varchar(5) Null ,[ItemCode] Varchar(25) Null ,[Stock] Decimal(18,4) Not Null Default(0),[CostPrice] Money Not Null Default(0),[NewCostPrice] Money Not Null Default(0),[NewERetPrice] Money Not Null Default(0),[NewPRetPrice] Money Not Null Default(0))'
Exec (@Sql)

Set @Sql ='Insert Into ' + Rtrim(@Object)  + ' ([LocaCode],[ItemCode],[Stock],[CostPrice],[NewCostPrice],[NewERetPrice],[NewPRetPrice])'
Set @Sql =Rtrim(@Sql) + ' Select tb_PriceChange.LocaCode,tb_PriceChange.ItemCode,0,tb_PriceChange.NewCostPrice,tb_PriceChange.NewCostPrice,tb_PriceChange.NewERetPrice,tb_PriceChange.NewPRetPrice From tb_PriceChange' 
Set @Sql =Rtrim(@Sql) + ' Inner Join ' + Rtrim(@ObjectIdx) + ' As Idx On tb_PriceChange.ItemCode=Idx.ItemCode And tb_PriceChange.LocaCode=Idx.LocaCode And tb_PriceChange.Idx=Idx.Idx'
Exec (@Sql)

Set @Sql ='Truncate Table ' + Rtrim(@ObjectIdx) 
Exec (@Sql)

Set @Sql ='Drop Table ' + Rtrim(@ObjectIdx) 
Exec (@Sql)

--Stock 
Set @Sql ='if exists (select * from dbo.sysobjects where id = object_id(N''[dbo].[' + Rtrim(@ObjectStk) + ']'') and OBJECTPROPERTY(id, N''IsUserTable'') = 1) drop table [dbo].[' + rtrim(@ObjectStk) + ']'
Exec (@Sql)

Set @Sql ='Create Table ' + Rtrim(@ObjectStk)  + ' ([LocaCode] Varchar(5) Null ,[ItemCode] Varchar(25) Null ,[Stock] Decimal(18,4) Not Null Default(0))'
Exec (@Sql)

		Set @Sql ='Insert Into ' + Rtrim(@ObjectStk)  + ' ([ItemCode],[LocaCode],[Stock]) Select tb_Stock.ItemCode,tb_Stock.LocaCode,Sum(Case [Id] When ''OPB'' Then (PackSize*Qty)'
		Set @Sql =Rtrim(@Sql) + ' When ''PCH'' Then (PackSize*Qty) When ''PRN'' Then -(PackSize*Qty) When ''INV'' Then -(PackSize*Qty) When ''MKR'' Then (PackSize*Qty)'
		Set @Sql =Rtrim(@Sql) + ' When ''DMG'' Then -(PackSize*Qty) When ''PRD'' Then -(PackSize*Qty) When ''DSC'' Then -(PackSize*Qty) When ''ADD'' Then (PackSize*Qty)' 
		Set @Sql =Rtrim(@Sql) + ' When ''TOG'' Then -(PackSize*Qty) When ''AOD'' Then -(PackSize*Qty) When ''IN1'' Then (PackSize*Qty) When ''IN2'' Then (PackSize*Qty) Else 0 End) From tb_Stock'
		Set @Sql =Rtrim(@Sql) + ' Where tb_Stock.LocaCode In ( ' + @LocaCode + ' ) And tb_Stock.Status=1 And tb_Stock.ItemCode Between ''0'' And  ''Z'''
		Set @Sql =Rtrim(@Sql) + ' And tb_Stock.PDate <= ''' + convert(varchar, @DateTo, 23) + '''  Group By tb_Stock.LocaCode,tb_Stock.ItemCode'

Exec (@Sql)

--Clear Useless Records
---Set @Sql= 'Delete From ' + Rtrim(@Object) + ' Where ItemCode Not In (Select ItemCode From ' + @ObjectStk + ')'
---Exec (@Sql)

--Reset Stock For Value
Set @Sql ='Update p Set p.Stock=s.Stock From ' + @Object + ' As p Join ' + @ObjectStk + ' As s On p.ItemCode=s.ItemCode And p.LocaCode=s.LocaCode'
Exec (@Sql)
Set @Sql ='Truncate Table ' + Rtrim(@ObjectStk) 
Exec (@Sql)
Set @Sql ='Drop Table ' + Rtrim(@ObjectStk) 
Exec (@Sql)

--Insert Common Object
If Not Exists (Select Top 1 ItemCode From [tb_Value|X] Where UserId<>@UserName) 
Begin
	Truncate Table [tb_Value|X]
End
Else
Begin
	Delete From [tb_Value|X] Where UserId=@UserName
End

Set @Sql='Insert Into [tb_Value|X] ([LocaCode],[ItemCode],[Stock],[CostPrice],[NewCostPrice],[NewERetPrice],[NewPRetPrice],[UserId])'
Set @Sql =Rtrim(@Sql) + ' Select [LocaCode],[ItemCode],[Stock],[CostPrice],[NewCostPrice],[NewERetPrice],[NewPRetPrice],''' + @UserName + ''' From ' + Rtrim(@Object)  
Exec (@Sql)

Set @Sql ='Truncate Table ' + Rtrim(@Object) 
Exec (@Sql)
Set @Sql ='Drop Table ' + Rtrim(@Object) 
Exec (@Sql)

Set @Sql  = 'SELECT @Stk = SUM([Stock]/Pack_Size*[NewCostPrice]) FROM   tb_Item  INNER JOIN [tb_Value|X] tb_Value_X ON tb_Item.Item_Code = tb_Value_X.ItemCode Where tb_Value_X.UserId=''Dash'' '

EXECUTE sp_executesql @sql, N'@Stk decimal(18,2) OUTPUT', @Stk=@Stock OUTPUT

IF OBJECT_ID('tempdb..#Temp') IS NOT NULL BEGIN DROP TABLE #Temp END 
select * into #Temp from (
select itemcode,qty, Pdate as LastDate,'PCH' As Id
from (select 
             itemcode,
             Qty,
			 Pdate,
             row_number() over(partition by itemcode order by pdate desc) as rn
      from tb_PurDet where id='PCH') as T
where rn = 1  
union all
select itemcode,qty, Idate as LastDate,'INV'  As Id
from (select 
             itemcode,
             Qty,
			 Idate,
             row_number() over(partition by itemcode order by idate desc) as rn
      from SalesDashboard) as T
where rn = 1  

) a


update u
set u.LastSalesDate = convert(varchar, s.LastDate, 23)
from [tb_Value|X]  u
    inner join #Temp s on
        u.itemcode = s.itemcode and s.Id='INV'

		update u
set u.LastPurchaseDate =  convert(varchar, s.LastDate, 23)
from [tb_Value|X]  u
    inner join #Temp s on
        u.itemcode = s.itemcode and s.Id='PCH'

set @Stock = 1

set @sql = 'IF OBJECT_ID(''tempdb..#TempTable'') IS NOT NULL BEGIN DROP TABLE #TempTable END 
select ISNULL(SUM(SalesDashboard.Qty),0) Qty,ItemCode INTO #TempTable from SalesDashboard 
where LocaCode In ('+ @LocaCode +' ) And ItemCode IN (SELECT Item_Code FROM Tb_Item WHERE Cat_Code In ('+ @CatCode +')) AND ItemCode IN (SELECT Item_Code FROM Tb_Item WHERE Supp_Code In ('+ @SuppCode +')) And ItemCode IN (SELECT Item_Code FROM Tb_Item WHERE SubCat_Code In ('+ @SubCatCode +')) And IDate BETWEEN'''+ convert(varchar, @DateFrom, 23) +''' AND '''+ convert(varchar, @DateTo, 23) +''' 
Group by ItemCode;

SELECT '+ @DisplayCol + ' CAST(IsNull(Sum([tb_Value|X].Stock),0) as  decimal(16,2)) Qty ,CAST(IsNull(SUM([Stock]/Pack_Size*[NewCostPrice]),0) as  decimal(16,2)) CostValue,CAST(IsNull(SUM(([tb_Value|X].Stock*tb_item.Pack_size) * NewEretPrice),0) as  decimal(16,2)) SalesValue,CAST(IsNull(SUM([Stock]/Pack_Size*[NewCostPrice]),0) /' + convert(nvarchar, @Stock) +  '  * 100 as  decimal(16,2)) StockRatio 
FROM ((((((([tb_Value|X] INNER JOIN  tb_Item ON [tb_Value|X].ItemCode = tb_Item.Item_Code) 
INNER JOIN tb_Category ON tb_Item.Cat_Code = tb_Category.Cat_Code)
INNER JOIN tb_SubCategory ON tb_Item.SubCat_Code = tb_SubCategory.SubCat_Code) 
INNER JOIN tb_Supplier ON tb_Supplier.Supp_Code = tb_Item.Supp_Code)   		
INNER JOIN tb_Location ON tb_Location.Loca_Code = [tb_Value|X].LocaCode)
LEFT OUTER JOIN #Temp ON #Temp.ItemCode = tb_Item.Item_Code) 
INNER JOIN  tb_ItemDet ON [tb_Value|X].ItemCode = tb_ItemDet.Item_Code And [tb_Value|X].LocaCode = tb_ItemDet.Loca_Code) 
WHERE  LocaCode In ('+ @LocaCode +' ) And [tb_Value|X].ItemCode IN (SELECT Item_Code FROM Tb_Item WHERE Cat_Code In ('+ @CatCode +')) AND [tb_Value|X].ItemCode IN (SELECT Item_Code FROM Tb_Item WHERE Supp_Code In ('+ @SuppCode +')) And [tb_Value|X].ItemCode IN (SELECT Item_Code FROM Tb_Item WHERE SubCat_Code In ('+ @SubCatCode +')) And tb_Item.Item_Code NOT IN (Select ItemCode from #TempTable) And UserId= '''+ @UserName + '''' +
+ @GroupByClause +''


exec  (@sql);

END
ELSE
IF(@ID=8) -- New Arrivals 
BEGIN
					IF(@ReportId=1) --Cat
					BEGIN
						IF (@ISSUMMARY=1)
						BEGIN
						set @DisplayCol ='tb_Item.Cat_Code As Code,tb_Category.Cat_Name As Name,Isnull(Sum(#TempTable.Stk),0)  As CurrentQty,'
						set @GroupByClause = 'GROUP BY tb_Item.Cat_Code,tb_Category.Cat_Name'						  
							END
							ELSE
							  BEGIN
							set @DisplayCol ='SalesDashboard.ItemCode  As Code, tb_Item.Inv_Descrip As Name,SalesDashboard.Cost As CostPrice,SalesDashboard.Rate As UnitPrice,Isnull(#TempTable.Stk,0)  As CurrentQty,tb_Item.SubCat_Code As SubCatCode ,tb_SubCategory.SubCat_Name As SubCatName,tb_Item.Cat_Code As CatCode, tb_Category.Cat_Name CatName,tb_Item.Supp_Code SuppCode,tb_Supplier.Supp_Name As SuppName,'
							set @GroupByClause = 'GROUP BY SalesDashboard.ItemCode, tb_Item.Inv_Descrip,SalesDashboard.Cost,SalesDashboard.Rate,#TempTable.Stk,tb_Item.SubCat_Code,tb_SubCategory.SubCat_Name,tb_Item.Cat_Code, tb_Category.Cat_Name,tb_Item.Supp_Code,tb_Supplier.Supp_Name'
							END
					END
					ELSE
					IF(@ReportId=2) --Supp
					BEGIN
						IF (@ISSUMMARY=1)
						BEGIN
						set @DisplayCol ='tb_Item.Supp_Code As Code,tb_Supplier.Supp_Name As Name,Isnull(Sum(#TempTable.Stk),0)  As CurrentQty,'
						set @GroupByClause = 'GROUP BY tb_Item.Supp_Code,tb_Supplier.Supp_Name'						  
							END
							ELSE
							  BEGIN
							set @DisplayCol ='SalesDashboard.ItemCode  As Code, tb_Item.Inv_Descrip As Name,SalesDashboard.Cost As CostPrice,SalesDashboard.Rate As UnitPrice,Isnull(#TempTable.Stk,0)  As CurrentQty,tb_Item.SubCat_Code As SubCatCode ,tb_SubCategory.SubCat_Name As SubCatName,tb_Item.Cat_Code As CatCode, tb_Category.Cat_Name CatName,tb_Item.Supp_Code SuppCode,tb_Supplier.Supp_Name As SuppName,'
							set @GroupByClause = 'GROUP BY SalesDashboard.ItemCode, tb_Item.Inv_Descrip,SalesDashboard.Cost,SalesDashboard.Rate,#TempTable.Stk,tb_Item.SubCat_Code,tb_SubCategory.SubCat_Name,tb_Item.Cat_Code, tb_Category.Cat_Name,tb_Item.Supp_Code,tb_Supplier.Supp_Name'							
							END

					END
					ELSE
					IF(@ReportId=3) --Loca
					BEGIN
						IF (@ISSUMMARY=1)
						BEGIN
						set @DisplayCol ='tb_Location.Loca_Code As Code,tb_Location.Loca_Name As Name,Isnull(Sum(#TempTable.Stk),0)  As CurrentQty,'
						set @GroupByClause = 'GROUP BY tb_Location.Loca_Code,tb_Location.Loca_Name'						  
							END
							ELSE
							  BEGIN
							set @DisplayCol ='SalesDashboard.ItemCode  As Code, tb_Item.Inv_Descrip As Name,SalesDashboard.Cost As CostPrice,SalesDashboard.Rate As UnitPrice,Isnull(#TempTable.Stk,0)  As CurrentQty,tb_Item.SubCat_Code As SubCatCode ,tb_SubCategory.SubCat_Name As SubCatName,tb_Item.Cat_Code As CatCode, tb_Category.Cat_Name CatName,tb_Item.Supp_Code SuppCode,tb_Supplier.Supp_Name As SuppName,'
							set @GroupByClause = 'GROUP BY SalesDashboard.ItemCode, tb_Item.Inv_Descrip,SalesDashboard.Cost,SalesDashboard.Rate,#TempTable.Stk,tb_Item.SubCat_Code,tb_SubCategory.SubCat_Name,tb_Item.Cat_Code, tb_Category.Cat_Name,tb_Item.Supp_Code,tb_Supplier.Supp_Name'
							END

					END
					ELSE
					IF(@ReportId=4) --SubCat
					BEGIN
						IF (@ISSUMMARY=1) 
						BEGIN
						set @DisplayCol ='tb_Item.SubCat_Code As Code,tb_SubCategory.SubCat_Name As Name,Isnull(Sum(#TempTable.Stk),0)  As CurrentQty,'
						set @GroupByClause = 'GROUP BY tb_Item.SubCat_Code,tb_SubCategory.SubCat_Name'						  
							END
							ELSE
							  BEGIN
							set @DisplayCol ='SalesDashboard.ItemCode  As Code, tb_Item.Inv_Descrip As Name,SalesDashboard.Cost As CostPrice,SalesDashboard.Rate As UnitPrice,Isnull(#TempTable.Stk,0)  As CurrentQty,tb_Item.SubCat_Code As SubCatCode ,tb_SubCategory.SubCat_Name As SubCatName,tb_Item.Cat_Code As CatCode, tb_Category.Cat_Name CatName,tb_Item.Supp_Code SuppCode,tb_Supplier.Supp_Name As SuppName,'
							set @GroupByClause = 'GROUP BY SalesDashboard.ItemCode, tb_Item.Inv_Descrip,SalesDashboard.Cost,SalesDashboard.Rate,#TempTable.Stk,tb_Item.SubCat_Code,tb_SubCategory.SubCat_Name,tb_Item.Cat_Code, tb_Category.Cat_Name,tb_Item.Supp_Code,tb_Supplier.Supp_Name'
							END

					END
					ELSE
					IF(@ReportId=5) --Item
					BEGIN
						IF (@ISSUMMARY=1) 
						BEGIN
						set @DisplayCol ='tb_Item.Item_Code As Code,tb_Item.Inv_Descrip As Name,Isnull(Sum(#TempTable.Stk),0)  As CurrentQty,'
						set @GroupByClause = 'GROUP BY tb_Item.Item_Code,tb_Item.Inv_Descrip'						  
							END
							ELSE
							  BEGIN
							set @DisplayCol ='SalesDashboard.ItemCode  As Code, tb_Item.Inv_Descrip As Name,SalesDashboard.Cost As CostPrice,SalesDashboard.Rate As UnitPrice,Isnull(#TempTable.Stk,0)  As CurrentQty,tb_Item.SubCat_Code As SubCatCode ,tb_SubCategory.SubCat_Name As SubCatName,tb_Item.Cat_Code As CatCode, tb_Category.Cat_Name CatName,tb_Item.Supp_Code SuppCode,tb_Supplier.Supp_Name As SuppName,'
							set @GroupByClause = 'GROUP BY SalesDashboard.ItemCode, tb_Item.Inv_Descrip,SalesDashboard.Cost,SalesDashboard.Rate,#TempTable.Stk,tb_Item.SubCat_Code,tb_SubCategory.SubCat_Name,tb_Item.Cat_Code, tb_Category.Cat_Name,tb_Item.Supp_Code,tb_Supplier.Supp_Name'
							END

					END
					
					set @sql =	 ' Select  @cnt = ISNULL(SUM(SalesDashboard.NetAmount),0) FROM SalesDashboard 
							WHERE  '+ @WhereClause +' SalesDashboard.IDate BETWEEN '''+ convert(varchar, @DateFrom, 23) +''' AND '''+ convert(varchar, @DateTo, 23) +''' AND SalesDashboard.LocaCode In ('+ @LocaCode +' ) '
					--print (@sql);

					EXECUTE sp_executesql @sql, N'@cnt money OUTPUT', @cnt=@NettSales OUTPUT
					--select @NettSales

					set @sql = 'IF OBJECT_ID(''tempdb..#TempTable'') IS NOT NULL 
								BEGIN 
									DROP TABLE #TempTable
								END 
					SELECT  CAST(1 as  decimal(16,2)) As Stk,Item_Code As ItemCode ,Loca_Code As LocaCode,Item_Code As Barcode INTO #TempTable
					FROM  tb_ItemDet WHERE Cdate BETWEEN '''+ convert(varchar, @DateFrom, 23) +''' AND '''+ convert(varchar, @DateTo, 23) +''' 

					update u set u.Barcode = s.Barcode from #TempTable u inner join tb_Item s on u.ItemCode = s.Item_Code 

					Select  '+ @DisplayCol + '
							ISNULL(SUM(SalesDashboard.Qty),0) AS SoldQty, 
							ISNULL(SUM(SalesDashboard.Qty*SalesDashboard.Rate),0) AS Sales, 
							ISNULL(SUM(SalesDashboard.Qty*SalesDashboard.Cost),0) AS CostOfSales,
							cast((ISNULL(SUM(SalesDashboard.Qty*SalesDashboard.Rate),0) - ISNULL(SUM(SalesDashboard.Qty*SalesDashboard.Cost),0))/ISNULL(SUM(SalesDashboard.Qty*SalesDashboard.Rate),0) as  decimal(16,2)) As GPMargin, NoOfReceipt, 			
							cast((ISNULL(SUM(SalesDashboard.Qty*SalesDashboard.Rate),0)/' + convert(nvarchar, @NettSales) +') * 100  as  decimal(16,2)) AS SalesRatio
							FROM (((((((SalesDashboard INNER JOIN  tb_Item ON SalesDashboard.ItemCode = tb_Item.Item_Code)
							INNER JOIN tb_ItemDet ON tb_ItemDet.Item_Code = tb_Item.Item_Code And SalesDashboard.LocaCode=tb_ItemDet.Loca_Code) 
							INNER JOIN tb_Category ON tb_Item.Cat_Code = tb_Category.Cat_Code)
							INNER JOIN tb_SubCategory ON tb_Item.SubCat_Code = tb_SubCategory.SubCat_Code) 
							INNER JOIN tb_Supplier ON tb_Supplier.Supp_Code = tb_Item.Supp_Code)   		
							INNER JOIN tb_Location ON tb_Location.Loca_Code = SalesDashboard.LocaCode)
							INNER JOIN #TempTable ON #TempTable.LocaCode = SalesDashboard.LocaCode And #TempTable.ItemCode = SalesDashboard.ItemCode)	 	
							WHERE  '+ @WhereClause +' SalesDashboard.ItemCode IN (SELECT Item_Code FROM Tb_Item WHERE Cat_Code In ('+ @CatCode +')) AND SalesDashboard.ItemCode IN (SELECT Item_Code FROM Tb_Item WHERE Supp_Code In ('+ @SuppCode +')) And SalesDashboard.ItemCode IN (SELECT Item_Code FROM Tb_Item WHERE SubCat_Code In ('+ @SubCatCode +')) AND
							SalesDashboard.IDate BETWEEN'''+ convert(varchar, @DateFrom, 23) +''' AND '''+ convert(varchar, @DateTo, 23) +''' AND SalesDashboard.LocaCode In ('+ @LocaCode +' ) '+ @GroupByClause +' having ISNULL(SUM(SalesDashboard.Qty),0) > 0 Order By ISNULL(SUM(SalesDashboard.Qty),0) DESC'
					exec (@sql);
END
ELSE
IF(@ID=9) -- item
BEGIN
						set @DisplayCol ='SalesDashboard.ItemCode,SalesDashboard.IDate,'
						set @GroupByClause = 'GROUP BY SalesDashboard.ItemCode,SalesDashboard.IDate'
												
					set @sql =	 ' Select  '+ @DisplayCol + '
							ISNULL(SUM(SalesDashboard.Qty),0) AS Qty, 
							ISNULL(SUM(SalesDashboard.GAmount),0) AS GAmount,
							ISNULL(SUM(SalesDashboard.Discount),0) AS Discount,
							ISNULL(SUM(SalesDashboard.Tax),0) AS Tax,
							ISNULL(SUM(SalesDashboard.NetAmount),0) AS NetAmount, 
							ISNULL(SUM(SalesDashboard.DiscountForTot),0) AS DiscountForTot,
							ISNULL(SUM(SalesDashboard.Qty*SalesDashboard.Cost),0) AS CostValue,
							ISNULL(SUM(SalesDashboard.NetAmount),0) - ISNULL(SUM(SalesDashboard.Qty*SalesDashboard.Cost),0) As Profit, NoOfReceipt			
							FROM ((((((SalesDashboard INNER JOIN  tb_Item ON SalesDashboard.ItemCode = tb_Item.Item_Code)
							INNER JOIN tb_Category ON tb_Item.Cat_Code = tb_Category.Cat_Code)
							INNER JOIN tb_SubCategory ON tb_Item.SubCat_Code = tb_SubCategory.SubCat_Code) 
							INNER JOIN tb_Supplier ON tb_Supplier.Supp_Code = tb_Item.Supp_Code)   		
							INNER JOIN tb_Location ON tb_Location.Loca_Code = SalesDashboard.LocaCode)
							INNER JOIN tb_Customer ON tb_Customer.Cust_Code = SalesDashboard.CustCode)	 	
							WHERE  '+ @WhereClause +' SalesDashboard.ItemCode IN ('+ @CatCode +') AND
							SalesDashboard.IDate BETWEEN DATEADD (DAY, -15,  '''+ convert(varchar, @DateTo, 23) +''') AND '''+ convert(varchar, @DateTo, 23) +'''   AND SalesDashboard.LocaCode In ('+ @LocaCode +' ) '+ @GroupByClause +''
					exec (@sql);
END
ELSE
IF(@ID=10) -- trans
BEGIN

	IF(@ReportId=1)
	BEGIN

set @sql =	'select Date,ISNULL([PO],0) [PO], ISNULL([PCH],0) [PCH], ISNULL([PRN],0) [PRN],ISNULL([INV],0) [INV],ISNULL([MKR],0) [MKR],ISNULL([ADD],0) [ADD],ISNULL([PRD],0) [PRD],ISNULL([DMG],0) [DMG],ISNULL([DSC],0) [DSC],ISNULL([QUT],0)	[QUT],ISNULL([TOG],0) [TOG]
			from 
			(
			select distinct Pdate as date,count(*) qty,Id from tb_PurSumm where Pdate between 	 DATEADD(mm, DATEDIFF(mm, 0, '''+ convert(varchar, @DateFrom, 23) +''' ), 0) And 	DATEADD (dd, -1, DATEADD(mm, DATEDIFF(mm, 0, '''+ convert(varchar, @DateTo, 23) +''' ) + 1, 0))	And LocaCode In ('+ @LocaCode +' ) group by Pdate,Id
			union all
			select distinct Idate as date,count(*) qty,Id from tb_InvSumm where Idate between 	 DATEADD(mm, DATEDIFF(mm, 0, '''+ convert(varchar, @DateFrom, 23) +''' ), 0) And 	DATEADD (dd, -1, DATEADD(mm, DATEDIFF(mm, 0, '''+ convert(varchar, @DateTo, 23) +''' ) + 1, 0))	And LocaCode In ('+ @LocaCode +' )   group by Idate,Id
			union all
			select distinct Idate as date,count(*) qty,Id from tb_StAdjSumm where Idate between 	 DATEADD(mm, DATEDIFF(mm, 0, '''+ convert(varchar, @DateFrom, 23) +''' ), 0) And 	DATEADD (dd, -1, DATEADD(mm, DATEDIFF(mm, 0, '''+ convert(varchar, @DateTo, 23) +''' ) + 1, 0))	And LocaCode In ('+ @LocaCode +' )  group by Idate,Id
			union all
			select distinct Tdate as date,count(*) qty,Id from tb_TogSumm where Tdate between 	 DATEADD(mm, DATEDIFF(mm, 0, '''+ convert(varchar, @DateFrom, 23) +''' ), 0) And 	DATEADD (dd, -1, DATEADD(mm, DATEDIFF(mm, 0, '''+ convert(varchar, @DateTo, 23) +''' ) + 1, 0))	And LocaCode In ('+ @LocaCode +' ) group by Tdate,Id

			) src
			pivot
			(
			  sum(qty)
			  for Id in ([PO], [PCH], [PRN],[INV],[MKR],[ADD],[PRD],[DMG],[DSC],[QUT],[TOG])
			) piv;'

			exec (@sql);
	 
	END
	ELSE
	IF(@ReportId=2)
	BEGIN

set @sql =	'select distinct Pdate as Date,SerialNo,Id DocumentType,RefNo,SuppCode Code,SuppName Name,GAmount,SubTotDiscount+Discount Discount,Tax,NetAmount from tb_PurSumm where Pdate between  '''+ convert(varchar, @DateFrom, 23) +''' And  '''+ convert(varchar, @DateTo, 23) +''' And LocaCode In ('+ @LocaCode +' ) And Id In ('+ @DocType +' ) 
			union all
			select distinct Idate as date,SerialNo,Id DocumentType,RefNo,CustCode Code,CustName Name,GAmount,SubTotDiscount+Discount Discount,Tax,NetAmount from tb_InvSumm where Idate between '''+ convert(varchar, @DateFrom, 23) +'''  And 	 '''+ convert(varchar, @DateTo, 23) +''' And LocaCode In ('+ @LocaCode +' )  And Id In ('+ @DocType +' ) 
			union all
			select distinct Idate as date,SerialNo,Id DocumentType,RefNo,'''' Code,'''' Name,RetValue GAmount,0 Discount,0 Tax,CostValue NetAmount from tb_StAdjSumm where Idate between '''+ convert(varchar, @DateFrom, 23) +'''  And  '''+ convert(varchar, @DateTo, 23) +''' And LocaCode In ('+ @LocaCode +' )  And Id In ('+ @DocType +' ) 
			union all
			select distinct Tdate as date,SerialNo,Id DocumentType,RefNo,'''' Code,'''' Name,TotalRetValue GAmount,0 Discount,0 Tax,TotalCostValue NetAmount from tb_TogSumm where Tdate between '''+ convert(varchar, @DateFrom, 23) +'''  And  '''+ convert(varchar, @DateTo, 23) +''' And LocaCode In ('+ @LocaCode +' ) And Id In ('+ @DocType +' ) '	  

			exec (@sql);
	END
	ELSE
	IF(@ReportId=3)
	BEGIN
	select ItemCode,Rate,Cost,Qty from tb_Stock where  SerialNo = @SerialNo and Id=	@DocType
	END
END
ELSE
IF(@ID=11) -- curr sales
BEGIN
						
					set @sql =	 ' Select LocationCode code,LocationName name,Sum(NoOfReceipts) receipts,Sum(NetSale) AS netAmount,Sum([voidTotal]) voidTotal ,Sum([refundTotal]) refundTotal ,Sum([cancelTotal]) cancelTotal ,Sum([discountTotal]) discountTotal,Sum([cashSale]) cashSale,Sum([nonCashSale]) nonCashSale,Sum([exchangeTotal]) exchangeTotal		
							FROM (CurrentSalesDashboard INNER JOIN tb_Location ON tb_Location.Loca_Code = CurrentSalesDashboard.LocationCode) group by LocationCode,LocationName'
					exec (@sql);
					
					--WHERE  CurrentSalesDashboard.LocationCode In ('+ @LocaCode +' )  

END
ELSE
IF(@ID=12) -- curr sales unit wise
BEGIN
						
					set @sql =	 ' Select LocationCode ,'''' name,Sum(NoOfReceipts) receipts,Sum(NetSale) AS netAmount,Sum([voidTotal]) voidTotal ,Sum([refundTotal]) refundTotal ,Sum([cancelTotal]) cancelTotal ,Sum([discountTotal]) discountTotal,Sum([cashSale]) cashSale,Sum([nonCashSale]) nonCashSale,Sum([exchangeTotal]) exchangeTotal,UnitNo code	
							FROM (CurrentSalesDashboard INNER JOIN tb_Location ON tb_Location.Loca_Code = CurrentSalesDashboard.LocationCode) where LocationCode in ('+ @LocaCode +' ) group by LocationCode,LocationName,UnitNo'
					exec (@sql);
					
					--WHERE  CurrentSalesDashboard.LocationCode In ('+ @LocaCode +' )  

END
ELSE
IF(@ID=13) -- Sales comparison
BEGIN
						
set @sql =
 
	  'SELECT [Year]
      ,COALESCE([1], 0) [January]
      ,COALESCE([2], 0) [February]
      ,COALESCE([3], 0) [March]
      ,COALESCE([4], 0) [April]
      ,COALESCE([5], 0) [May]
      ,COALESCE([6], 0) [June]
      ,COALESCE([7], 0) [July]
      ,COALESCE([8], 0) [August]
      ,COALESCE([9], 0) [September]
      ,COALESCE([10], 0) [October]
      ,COALESCE([11], 0) [November]
      ,COALESCE([12], 0) [December]
FROM      
(
	SELECT YEAR([IDate]) AS [Year],MONTH([IDate]) AS [monthval],ISNULL(SUM(NetAmount),0) AS NetAmount FROM SalesDashboard 
	Where ItemCode IN (SELECT Item_Code FROM Tb_Item WHERE Cat_Code In ('+ @CatCode +')) AND ItemCode IN (SELECT Item_Code FROM Tb_Item WHERE Supp_Code In ('+ @SuppCode +')) And ItemCode IN (SELECT Item_Code FROM Tb_Item WHERE SubCat_Code In ('+ @SubCatCode +')) AND LocaCode In ('+ @LocaCode +' )
	--MONTH([IDate])= 2 or MONTH([IDate])= 4 
	Group by 	MONTH([IDate]),YEAR([IDate])
) AS SourceTable 
PIVOT 
(
  Sum(NetAmount) FOR monthval IN ([1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12])  
) AS PivotTable '
exec (@sql);
END
END


--ItemCode IN (SELECT Item_Code FROM Tb_Item WHERE Cat_Code In ('+ @CatCode +')) AND ItemCode IN (SELECT Item_Code FROM Tb_Item WHERE Supp_Code In ('+ @SuppCode +')) And ItemCode IN (SELECT Item_Code FROM Tb_Item WHERE SubCat_Code In ('+ @SubCatCode +'))  And 
GO


