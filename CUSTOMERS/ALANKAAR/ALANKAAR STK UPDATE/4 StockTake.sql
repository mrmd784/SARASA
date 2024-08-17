
DECLARE @LocationID INT
DECLARE @ZDate DATE
DECLARE @TempLocationID INT

SET @Zdate= '2023-10-28'
SET @LocationID = 1;
SET @TempLocationID = 1000;

IF OBJECT_ID('dbo.tempStockAdjustment', 'U') IS NOT NULL 
  DROP TABLE dbo.tempStockAdjustment;

CREATE TABLE tempStockAdjustment
(ProductID bigint not null,
 ColorSizeID bigint not null,
 LocationID bigint not null,
 CurrentQty decimal(10,2) not null,
 Qty decimal(10,2) not null,
 CostPrice  decimal(10,2) not null,
 SellingPrice decimal(10,2) not null,
 AverageCost  decimal(10,2) not null
)

IF OBJECT_ID('tempdb..#TempProducts', 'U') IS NOT NULL 
  DROP TABLE #TempProducts;

select  td.Productid,@LocationID as LocationID
	,isnull(max(td.cost),0) CostPrice,isnull(max(td.Price),0) as SellingPrice
	 ,isnull(max(td.AvgCost),0) as MaxAverageCost into #TempProducts
	 from TransactionDet td   
	  WHERE td.DocumentID in(1,2,3,4) AND [Status]=1
	AND SaleTypeID=1 AND BillTypeID=1 AND TransStatus=1
	AND CAST(td.Zdate AS Date) =@Zdate  AND td.LocationID=@TempLocationID 
	And ProductColorSizeID<>0
	  GROUP BY td.Productid,td.LocationID,td.ProductColorSizeID--,td.cost,td.Price

INSERT INTO tempStockAdjustment
(LocationID,ProductID,ColorSizeID,CurrentQty,Qty,CostPrice,SellingPrice,AverageCost)
select LocationID,ProductID,Colorsizeid,stockqty,0,costprice,sellingprice,averagecost from InvTmpProductStockDetailsColorSize
--	  SELECT  @LocationID as LocationID,pm.InvProductMasterID,0 as CurrentQty,0 as Qty,
--isnull(max(t1.CostPrice),pm.CostPrice) as CostPrice,isnull(max(t1.SellingPrice),pm.SellingPrice) as SellingPrice,
--pm.AverageCost as AvarageCost 
--from InvProductMaster pm
--left join #TempProducts t1 on t1.ProductID=pm.InvProductMasterID
--where pm.IsColorSize=0
--group by t1.LocationID,t1.ProductID,pm.InvProductMasterID--,t1.CostPrice,t1.SellingPrice
--,pm.AverageCost,pm.CostPrice,pm.SellingPrice

-- SELECT  @LocationID as LocationID,pm.InvProductMasterID,0 as CurrentQty,0 as Qty,
--pm.CostPrice as CostPrice,pm.SellingPrice as SellingPrice,
--pm.AverageCost as AvarageCost 
--from InvProductMaster pm 
--inner join InvSubCategory2 sc2 on pm.SubCategory2ID=sc2.InvSubCategory2ID
-- where sc2.SubCategory2Code in ('00292','00293','00307','00329','00333','00372')
 
 
 --select * from InvSubCategory2 where InvSubCategory2ID in (293,294,309,331,335,376)

/*
INSERT INTO tempStockAdjustment
(LocationID,ProductID,CurrentQty,Qty,CostPrice,SellingPrice,AverageCost)
SELECT  @LocationID,pm.InvProductMasterID,0 as CurrentQty,0 as Qty,
pm.CostPrice as CostPrice,pm.SellingPrice as sellingPrice,
pm.AverageCost as AvarageCost
from InvProductMaster pm
*/



update tempStockAdjustment
set qty=sumQty, 
CostPrice= GCostPrice,
SellingPrice=GSellingPrice,
AverageCost= MaxAverageCost
	  FROM (select td.Productid,td.ProductColorSizeID,@LocationID as LocationID,isnull(SUM(case td.DocumentID when 1 then td.Qty when 2 then -td.Qty else 0 end),0) AS SumQty
	,isnull(max(td.cost),0) GCostPrice,isnull(max(td.Price),0) as GSellingPrice
	 ,isnull(max(td.AvgCost),0) as MaxAverageCost
	 from TransactionDet td   
	  WHERE td.DocumentID in(1,2) AND [Status]=1
	AND SaleTypeID=1 AND BillTypeID=1 AND TransStatus=1
	AND CAST(td.Zdate AS Date)= @Zdate   AND td.LocationID=@TempLocationID 
	  GROUP BY td.Productid,td.LocationID,td.ProductColorSizeID)
	  Grouped where Grouped.ProductID= tempStockAdjustment.Productid
	  and Grouped.LocationID=tempStockAdjustment.LocationID and Grouped.ProductColorSizeID=tempStockAdjustment.ColorSizeID


	  --Update tm
	  --set tm.CurrentQty=ps.StockQty
	  --from tempStockAdjustment tm
	  --inner join InvTmpProductStockDetails ps
	  --on tm.Productid=ps.ProductID 
	  --and tm.LocationId=ps.LocationID

	   select * from tempStockAdjustment

IF OBJECT_ID('dbo.tempStockAdjustmentAdd', 'U') IS NOT NULL 
DROP TABLE dbo.tempStockAdjustmentAdd;

CREATE TABLE tempStockAdjustmentAdd
(ProductID bigint not null,
 ColorSizeId bigint not null,
 LocationID bigint not null,
 CurrentQty decimal(10,2) not null,
 Qty decimal(10,2) not null,
 UpdateQty decimal(10,2) not null,
 CostPrice  decimal(10,2) not null,
 SellingPrice decimal(10,2) not null,
 AverageCost  decimal(10,2) not null
)

INSERT INTO tempStockAdjustmentAdd(LocationID,ProductID,ColorSizeId,CurrentQty,Qty,UpdateQty,CostPrice,SellingPrice,AverageCost)
SELECT LocationID,ProductID,ColorSizeID,CurrentQty,Qty,(Qty-CurrentQty) as UpdateQty,CostPrice,SellingPrice,AverageCost
FROM tempStockAdjustment 
WHERE CurrentQty<Qty

select * from tempStockAdjustmentAdd

IF OBJECT_ID('dbo.tempStockAdjustmentReduce', 'U') IS NOT NULL 
DROP TABLE dbo.tempStockAdjustmentReduce;

CREATE TABLE tempStockAdjustmentReduce
(ProductID bigint not null,
 ColorSizeId bigint not null,
 LocationID bigint not null,
 CurrentQty decimal(10,2) not null,
 Qty decimal(10,2) not null,
 UpdateQty decimal(10,2) not null,
 CostPrice  decimal(10,2) not null,
 SellingPrice decimal(10,2) not null,
 AverageCost  decimal(10,2) not null
)

INSERT INTO tempStockAdjustmentReduce(LocationID,ProductID,ColorSizeId,CurrentQty,Qty,UpdateQty,CostPrice,SellingPrice,AverageCost)
SELECT LocationID,ProductID,ColorSizeID,CurrentQty,Qty,(CurrentQty-Qty) as UpdateQty,CostPrice,SellingPrice,AverageCost
FROM tempStockAdjustment 
WHERE CurrentQty>Qty

select * from tempStockAdjustmentReduce



