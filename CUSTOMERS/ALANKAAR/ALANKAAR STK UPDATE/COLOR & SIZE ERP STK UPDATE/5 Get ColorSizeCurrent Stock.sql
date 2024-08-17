	
declare 
@CompanyId INT=1,
@SelectedLocationID INT=1,
@GivenDate DATETIME ='2023-10-28',
@StockDate DateTime='2023-06-20', --get the stockdate from location table
@FromCode VARCHAR(20)='0',
@ToCode VARCHAR(20)='z',
@UserId BIGINT=1,
@UniqueId BIGINT=1,
@CreatedUser VARCHAR(30)='SARASA'

	--drop table #tempCurrentStock
			
    CREATE TABLE #tempCurrentStock(
	[LocationID] [bigint] NOT NULL,
	[ProductID] [bigint] NOT NULL,
	[ColorSizeID] [bigint] NOT NULL,
	[BatchNo] [nvarchar](25) NULL,
	[Qty] [decimal](18, 0) NOT NULL,
	[CostValue] [decimal](18, 2),
	[SellingValue] [decimal](18, 2))	
	
		
			---Opening Stock
				INSERT INTO #tempCurrentStock (LocationID, ProductID, BatchNo, Qty,CostValue,SellingValue,ColorSizeID)
				SELECT sd.LocationID, sd.ProductID, sd.BatchNo, SUM(sd.OrderQty), SUM(sd.OrderQty*sd.CostPrice), SUM(sd.OrderQty*sd.SellingPrice),sd.InvProductColorSizeID
				FROM OpeningStockDetail sd INNER JOIN OpeningStockHeader sh ON sd.DocumentNo = sh.DocumentNo AND sd.DocumentID = sh.DocumentID 
					AND sd.LocationID = sh.LocationID AND sd.DocumentStatus = sh.DocumentStatus
				WHERE sd.DocumentStatus = 1 AND sh.OpeningStockType = 1 AND sd.DocumentID = 503 
					AND sd.LocationID = @SelectedLocationID 
					AND (CAST(sd.DocumentDate AS DATE) <= @GivenDate)
					AND (CAST(sd.DocumentDate AS DATE) >= @StockDate)
				GROUP BY sd.LocationID, sd.ProductID, sd.BatchNo,sd.InvProductColorSizeID


			--GRN & Purchase Returns
				INSERT INTO #tempCurrentStock (LocationID, ProductID, BatchNo, Qty,CostValue,SellingValue,ColorSizeID)
				SELECT LocationID, ProductID, BatchNo, SUM(CASE DocumentID WHEN 1502 THEN  (Qty) WHEN 1503 THEN  -(Qty) ELSE 0 END) AS QTY,
				SUM((CASE DocumentID WHEN 1502 THEN  (Qty) WHEN 1503 THEN  -(Qty) ELSE 0 END)*ph.CostPrice),SUM((CASE DocumentID WHEN 1502 THEN  (Qty) WHEN 1503 THEN  -(Qty) ELSE 0 END)*ph.SellingPrice),ph.InvProductColorSizeID
				FROM InvPurchase ph WHERE DocumentStatus = 1 AND (DocumentID IN (1502, 1503)) 
					AND LocationID = @SelectedLocationID 
					AND (CAST(DocumentDate AS DATE) <= @GivenDate)
					AND (CAST(DocumentDate AS DATE) >= @StockDate)
				GROUP BY LocationID, ProductID, BatchNo,ph.InvProductColorSizeID		


			--TOG IN
				INSERT INTO #tempCurrentStock (LocationID, ProductID, BatchNo, Qty,CostValue,SellingValue,ColorSizeID)
				SELECT td.ToLocationID, td.ProductID, td.BatchNo, SUM(td.Qty), SUM(td.Qty*td.CostPrice), SUM(td.Qty*td.SellingPrice),td.InvProductColorSizeID
				FROM InvTransferNoteDetail td INNER JOIN InvTransferNoteHeader th ON th.DocumentNo = td.DocumentNo
					AND th.DocumentID = td.DocumentID AND th.LocationID = td.LocationID
					AND th.DocumentStatus = td.DocumentStatus 
				WHERE td.DocumentStatus = 1 AND td.DocumentID = 1504 
					AND td.ToLocationID = @SelectedLocationID 
					AND (CAST(td.DocumentDate AS DATE) <= @GivenDate)
					AND (CAST(td.DocumentDate AS DATE) >= @StockDate)
				GROUP BY td.ToLocationID, td.ProductID, td.BatchNo,td.InvProductColorSizeID
					
					
			--TOG OUT
				INSERT INTO #tempCurrentStock (LocationID, ProductID, BatchNo, Qty,CostValue,SellingValue,ColorSizeID)
				SELECT td.LocationID, td.ProductID, td.BatchNo, (SUM(td.Qty) *-1),(SUM(td.Qty*td.CostPrice) *-1),(SUM(td.Qty*td.SellingPrice) *-1),td.InvProductColorSizeID
				FROM InvTransferNoteDetail td INNER JOIN InvTransferNoteHeader th ON th.DocumentNo = td.DocumentNo
					AND th.DocumentID = td.DocumentID AND th.LocationID = td.LocationID
					AND th.DocumentStatus = td.DocumentStatus 
				WHERE td.DocumentStatus = 1 AND td.DocumentID = 1504 
					AND td.LocationID = @SelectedLocationID 
					AND (CAST(td.DocumentDate AS DATE) <= @GivenDate)
					AND (CAST(td.DocumentDate AS DATE) >= @StockDate)
				GROUP BY td.LocationID, td.ProductID, td.BatchNo,td.InvProductColorSizeID
				
				
			--Stock Adjustment (ADD)
				INSERT INTO #tempCurrentStock (LocationID, ProductID, BatchNo, Qty,CostValue,SellingValue,ColorSizeID)
				SELECT ad.LocationID, ad.ProductID,ad.BatchNo, SUM(ad.ExcessQty),SUM(ad.ExcessQty*ad.CostPrice), SUM(ad.ExcessQty*ad.SellingPrice),ad.InvProductColorSizeID
				FROM InvStockAdjustmentDetail ad INNER JOIN InvStockAdjustmentHeader ah ON ad.DocumentNo = ah.DocumentNo
					AND ad.DocumentID = ah.DocumentID AND ad.LocationID = ah.LocationID
					AND ad.DocumentStatus = ah.DocumentStatus 
				WHERE ad.DocumentStatus = 1 AND ad.DocumentID = 1505 AND ad.StockAdjustmentMode = 1 
					AND ad.LocationID = @SelectedLocationID 
					AND (CAST(ad.DocumentDate AS DATE) <= @GivenDate)
					AND (CAST(ad.DocumentDate AS DATE) >= @StockDate)
				GROUP BY ad.LocationID, ad.ProductID, ad.BatchNo,ad.InvProductColorSizeID
				
				
			--Stock Adjustment (REDUSE)
				INSERT INTO #tempCurrentStock (LocationID, ProductID, BatchNo, Qty,CostValue,SellingValue,ColorSizeID)
				SELECT ad.LocationID, ad.ProductID, ad.BatchNo, (SUM(ad.ShortageQty)*-1),(SUM(ad.ShortageQty*ad.CostPrice)*-1), (SUM(ad.ShortageQty*ad.SellingPrice)*-1),ad.InvProductColorSizeID
				FROM InvStockAdjustmentDetail ad INNER JOIN InvStockAdjustmentHeader ah ON ad.DocumentNo = ah.DocumentNo
					AND ad.DocumentID = ah.DocumentID AND ad.LocationID = ah.LocationID
					AND ad.DocumentStatus = ah.DocumentStatus WHERE ad.DocumentStatus = 1
					AND ad.DocumentID = 1505 AND ad.StockAdjustmentMode = 2 AND ad.LocationID = @SelectedLocationID 
					AND (CAST(ad.DocumentDate AS DATE) <= @GivenDate)
					AND (CAST(ad.DocumentDate AS DATE) >= @StockDate)
				GROUP BY ad.LocationID, ad.ProductID, ad.BatchNo,ad.InvProductColorSizeID
				
			--Stock Adjustment (Overwrite)
				--INSERT INTO #tempCurrentStock (LocationID, ProductID, BatchNo, Qty,CostValue,SellingValue)
				--SELECT ad.LocationID, ad.ProductID, ad.BatchNo, (SUM(ad.ExcessQty) + (SUM(ad.ShortageQty)*-1)),(SUM((ad.ExcessQty + ((ad.ShortageQty)*-1))*ad.CostPrice)), (SUM((ad.ExcessQty + ((ad.ShortageQty)*-1))*ad.SellingPrice))
				--FROM InvStockAdjustmentDetail ad INNER JOIN InvStockAdjustmentHeader ah ON ad.DocumentNo = ah.DocumentNo
				--	AND ad.DocumentID = ah.DocumentID AND ad.LocationID = ah.LocationID
				--	AND ad.DocumentStatus = ah.DocumentStatus WHERE ad.DocumentStatus = 1
				--	AND ad.DocumentID = 1505 AND ad.StockAdjustmentMode = 3 AND ad.LocationID = @SelectedLocationID 
				--	AND (CAST(ad.DocumentDate AS DATE) <= @GivenDate)
				--	AND (CAST(ad.DocumentDate AS DATE) >= @StockDate)
				--GROUP BY ad.LocationID, ad.ProductID, ad.BatchNo
					
			--Sales & Returns	
				--INSERT INTO #tempCurrentStock (LocationID, ProductID, BatchNo, Qty)
				--SELECT td.LocationID, td.ProductID, td.BatchNo, SUM(CASE DocumentID WHEN 1 THEN  -Qty WHEN 3 THEN  -Qty WHEN 2 THEN  Qty WHEN 4 THEN  Qty ELSE 0 END)
				--FROM TransactionDet td WHERE  [Status] = 1  AND TransStatus = 1 AND saletypeid=1 and billtypeid=1 AND td.LocationID = @SelectedLocationID AND (DocumentID IN(1,2,3,4)) AND (Cast(td.RecDate As Date) <= @GivenDate)
				--GROUP BY td.LocationID, td.ProductID, td.BatchNo
			
			--Sales & Returns (POS)
				INSERT INTO #tempCurrentStock (LocationID, ProductID, BatchNo, Qty,CostValue,SellingValue,ColorSizeID)
				SELECT td.LocationID, td.ProductID, td.BatchNo, SUM(Qty*-1),SUM((Qty*-1)*td.CostPrice), SUM((Qty*-1)*td.SellingPrice),td.InvProductColorSizeID
				FROM InvSales td WHERE td.LocationID = @SelectedLocationID AND DocumentStatus = 1 
				AND (td.DocumentID IN(1,2,3,4)) 
				AND td.IsBackOffice = 0
				AND (CAST(td.DocumentDate AS DATE) <= @GivenDate)
				AND (CAST(td.DocumentDate AS DATE) >= @StockDate)
				GROUP BY td.LocationID, td.ProductID, td.BatchNo,td.InvProductColorSizeID
				
			--Sales & Returns (BACK OFFICE)
				INSERT INTO #tempCurrentStock (LocationID, ProductID, BatchNo, Qty,CostValue,SellingValue,ColorSizeID)
				SELECT td.LocationID, td.ProductID, td.BatchNo, SUM(Qty*-1),SUM((Qty*-1)*td.CostPrice), SUM((Qty*-1)*td.SellingPrice),td.InvProductColorSizeID
				FROM InvSales td WHERE td.LocationID = @SelectedLocationID AND DocumentStatus = 1 
				AND (td.DocumentID IN(1508, 1509)) --AND (td.DocumentID IN(1,2,3,4)) 
				AND td.IsBackOffice = 0
				AND td.IsDispatch = 1
				AND (CAST(td.DocumentDate AS DATE) <= @GivenDate)
				AND (CAST(td.DocumentDate AS DATE) >= @StockDate)
				GROUP BY td.LocationID, td.ProductID, td.BatchNo,td.InvProductColorSizeID			
				
				/*
				--BundleUp (ADD)
				INSERT INTO #tempCurrentStock (LocationID, ProductID, BatchNo, Qty,CostValue,SellingValue)
				SELECT ad.LocationID, ad.ProductID, ad.BatchNo, SUM(ad.ExcessQty),SUM(ad.ExcessQty*ad.CostPrice), SUM(ad.ExcessQty*ad.SellingPrice)
				FROM dbo.InvBundleUpProductDetail ad 
				INNER JOIN InvBundleUpProductHeader ah ON ad.DocumentNo = ah.DocumentNo
					AND ad.DocumentID = ah.DocumentID AND ad.LocationID = ah.LocationID
					AND ad.DocumentStatus = ah.DocumentStatus
				WHERE ad.DocumentStatus = 1 AND ad.DocumentID = 1518 
					AND ((ad.BundleUpProductMode = 1 AND ad.ProductID =0) OR (ad.BundleUpProductMode = 2 AND ad.ProductID !=0))
					AND ad.LocationID = @SelectedLocationID  
					AND (CAST(ad.DocumentDate AS DATE) <= @GivenDate)
					AND (CAST(ad.DocumentDate AS DATE) >= @StockDate)
				GROUP BY ad.LocationID, ad.ProductID, ad.BatchNo
							
							
			--BundleUp (REDUSE)
				INSERT INTO #tempCurrentStock (LocationID, ProductID, BatchNo, Qty,CostValue,SellingValue)
				SELECT ad.LocationID, ad.ProductID, ad.BatchNo, (SUM(ad.ShortageQty)*-1),(SUM(ad.ShortageQty*ad.CostPrice)*-1), (SUM(ad.ShortageQty*ad.SellingPrice)*-1)
				FROM dbo.InvBundleUpProductDetail ad 
				INNER JOIN InvBundleUpProductHeader ah ON ad.DocumentNo = ah.DocumentNo
					AND ad.DocumentID = ah.DocumentID AND ad.LocationID = ah.LocationID
					AND ad.DocumentStatus = ah.DocumentStatus
				WHERE ad.DocumentStatus = 1 AND ad.DocumentID = 1518 
					AND ((ad.BundleUpProductMode = 1 AND ad.ProductID !=0) OR (ad.BundleUpProductMode = 2 AND ad.ProductID =0))
					AND ad.LocationID = @SelectedLocationID  
					AND (CAST(ad.DocumentDate AS DATE) <= @GivenDate)
					AND (CAST(ad.DocumentDate AS DATE) >= @StockDate)
				GROUP BY ad.LocationID, ad.ProductID, ad.BatchNo
				*/

										--Bundleup Assemble 
			INSERT INTO #tempCurrentStock (LocationID, ProductID, BatchNo, Qty,CostValue,SellingValue,ColorSizeID)
	        SELECT pd.LocationID, pd.InvBundleUpProductID, pd.DocumentNo,SUM(pd.OrderQty),SUM(pd.OrderQty*pd.CostPrice),SUM(pd.OrderQty*pd.SellingPrice),pd.InvProductColorSizeID
		    FROM InvBundleUpProductDetail pd
			INNER JOIN InvBundleUpProductHeader ph ON ph.InvBundleUpProductHeaderID=pd.InvBundleUpProductHeaderID 
			WHERE pd.DocumentStatus = 1 AND pd.DocumentID = 1518
			AND pd.BundleUpProductMode = 1 AND pd.LocationID = @SelectedLocationID   
			AND pd.ProductID=0 AND (CAST(pd.DocumentDate AS DATE) <= @GivenDate)
			AND (CAST(pd.DocumentDate AS DATE) >= @StockDate)
		    GROUP BY pd.LocationID,pd.DocumentNo,pd.InvBundleUpProductID,pd.InvProductColorSizeID
		    
			
			INSERT INTO #tempCurrentStock (LocationID, ProductID, BatchNo, Qty,CostValue,SellingValue,ColorSizeID)
	        SELECT pd.LocationID,pd.ProductID, pd.DocumentNo,SUM(pd.OrderQty)*(-1),SUM(pd.OrderQty*pm.CostPrice)*(-1),SUM(pd.OrderQty*pm.SellingPrice)*(-1),pd.InvProductColorSizeID
		    FROM InvBundleUpProductDetail pd
			INNER JOIN InvBundleUpProductHeader ph ON ph.InvBundleUpProductHeaderID=pd.InvBundleUpProductHeaderID 
			INNER JOIN InvProductMaster pm on pd.ProductID=pm.InvProductMasterID
			WHERE pd.DocumentStatus = 1 AND pd.DocumentID = 1518
			AND pd.BundleUpProductMode = 1  AND pd.LocationID = @SelectedLocationID    and pd.ProductID!=0
			AND (CAST(pd.DocumentDate AS DATE) <= @GivenDate)
			AND (CAST(pd.DocumentDate AS DATE) >= @StockDate)
			GROUP BY pd.LocationID,pd.DocumentNo,pd.ProductID,pd.InvProductColorSizeID
			

		----Bundleup Disassemble 
			INSERT INTO #tempCurrentStock (LocationID, ProductID, BatchNo, Qty,CostValue,SellingValue,ColorSizeID)
	        SELECT pd.LocationID, pd.InvBundleUpProductID, pd.DocumentNo,SUM(pd.OrderQty)*(-1),SUM(pd.OrderQty*pd.CostPrice)*(-1),SUM(pd.OrderQty*pd.SellingPrice)*(-1),pd.InvProductColorSizeID
		    FROM InvBundleUpProductDetail pd
			INNER JOIN InvBundleUpProductHeader ph ON ph.InvBundleUpProductHeaderID=pd.InvBundleUpProductHeaderID  
			WHERE pd.DocumentStatus = 1 AND pd.DocumentID = 1518
			AND pd.BundleUpProductMode = 2   AND pd.LocationID = @SelectedLocationID  
			AND pd.ProductID=0 AND (CAST(pd.DocumentDate AS DATE) <= @GivenDate)
			AND (CAST(pd.DocumentDate AS DATE) >= @StockDate)
		    GROUP BY pd.LocationID,pd.DocumentNo,pd.InvBundleUpProductID,pd.InvProductColorSizeID

			INSERT INTO #tempCurrentStock (LocationID, ProductID, BatchNo, Qty,CostValue,SellingValue,ColorSizeID)
	        SELECT pd.LocationID,pd.ProductID, pd.DocumentNo,SUM(pd.OrderQty),SUM(pd.OrderQty*pm.CostPrice),SUM(pd.OrderQty*pm.SellingPrice),pd.InvProductColorSizeID
		    FROM InvBundleUpProductDetail pd
			INNER JOIN InvBundleUpProductHeader ph ON ph.InvBundleUpProductHeaderID=pd.InvBundleUpProductHeaderID 
			INNER JOIN InvProductMaster pm on pd.ProductID=pm.InvProductMasterID
			WHERE pd.DocumentStatus = 1 AND pd.DocumentID = 1518
			AND pd.BundleUpProductMode = 2  AND pd.LocationID = @SelectedLocationID   and pd.ProductID!=0
			AND (CAST(pd.DocumentDate AS DATE) <= @GivenDate)
			AND (CAST(pd.DocumentDate AS DATE) >= @StockDate)
			GROUP BY pd.LocationID,pd.DocumentNo,pd.ProductID,pd.InvProductColorSizeID
	
	
	--update sum qty to the InvTmpProductStockDetailsColorSize
	
	update cs
	set cs.StockQty=t.Qty
	from #tempCurrentStock t
	inner join InvTmpProductStockDetailsColorSize cs on t.ProductID=cs.ProductID
	and cs.colorSizeID=t.ColorSizeID
	
	select stockqty from InvTmpProductStockDetailsColorSize