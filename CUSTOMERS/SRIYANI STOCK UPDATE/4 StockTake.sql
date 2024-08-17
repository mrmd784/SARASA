
DECLARE @LocationID INT
DECLARE @ZDate DATE
DECLARE @TempLocationID INT

SET @Zdate= '2018-05-04'
SET @LocationID = 2;
SET @TempLocationID = 2;

IF OBJECT_ID('dbo.tempStockAdjustment', 'U') IS NOT NULL 
  DROP TABLE dbo.tempStockAdjustment;

CREATE TABLE tempStockAdjustment
(ProductID bigint not null,
 LocationID bigint not null,
 CurrentQty decimal(10,2) not null,
 Qty decimal(10,2) not null,
 CostPrice  decimal(10,2) not null,
 SellingPrice decimal(10,2) not null,
 AverageCost  decimal(10,2) not null
)


INSERT INTO tempStockAdjustment
(LocationID,ProductID,CurrentQty,Qty,CostPrice,SellingPrice,AverageCost)
SELECT  @LocationID,pm.InvProductMasterID,0 as CurrentQty,0 as Qty,
pm.CostPrice as CostPrice,pm.SellingPrice as sellingPrice,
pm.AverageCost as AvarageCost
from InvProductMaster pm


update tempStockAdjustment
set qty=sumQty, 
CostPrice= MaxCostPrice,
SellingPrice=MaxSellingPrice,
AverageCost= MaxAverageCost
	  FROM (select td.Productid,@LocationID as LocationID,isnull(SUM(case td.DocumentID when 1 then td.Qty when 2 then -td.Qty else 0 end),0) AS SumQty
	,isnull(max(td.cost),0) as MaxCostPrice,isnull(max(td.Price),0) as MaxSellingPrice
	 ,isnull(max(td.cost),0) as MaxAverageCost
	 from TransactionDet td   
	  WHERE td.DocumentID in(1,2) AND [Status]=1
	AND SaleTypeID=1 AND BillTypeID=1 AND TransStatus=1
	AND CAST(td.Zdate AS Date)=@ZDate  AND td.LocationID=@TempLocationID
	  GROUP BY td.Productid,td.LocationID)
	  Grouped where Grouped.ProductID= tempStockAdjustment.Productid
	  and Grouped.LocationID=tempStockAdjustment.LocationID
	  

	  Update tm
	  set tm.CurrentQty=ps.Qty
	  from tempStockAdjustment tm
	  inner join InvTmpProductStockDetails ps
	  on tm.Productid=ps.InvProductMasterID 
	  and tm.LocationId=ps.LocationID

	   select * from tempStockAdjustment

IF OBJECT_ID('dbo.tempStockAdjustmentAdd', 'U') IS NOT NULL 
DROP TABLE dbo.tempStockAdjustmentAdd;

CREATE TABLE tempStockAdjustmentAdd
(ProductID bigint not null,
 LocationID bigint not null,
 CurrentQty decimal(10,2) not null,
 Qty decimal(10,2) not null,
 UpdateQty decimal(10,2) not null,
 CostPrice  decimal(10,2) not null,
 SellingPrice decimal(10,2) not null,
 AverageCost  decimal(10,2) not null
)

INSERT INTO tempStockAdjustmentAdd(LocationID,ProductID,CurrentQty,Qty,UpdateQty,CostPrice,SellingPrice,AverageCost)
SELECT LocationID,ProductID,CurrentQty,Qty,(Qty-CurrentQty) as UpdateQty,CostPrice,SellingPrice,AverageCost
FROM tempStockAdjustment 
WHERE CurrentQty<Qty

select * from tempStockAdjustmentAdd

IF OBJECT_ID('dbo.tempStockAdjustmentReduce', 'U') IS NOT NULL 
DROP TABLE dbo.tempStockAdjustmentReduce;

CREATE TABLE tempStockAdjustmentReduce
(ProductID bigint not null,
 LocationID bigint not null,
 CurrentQty decimal(10,2) not null,
 Qty decimal(10,2) not null,
 UpdateQty decimal(10,2) not null,
 CostPrice  decimal(10,2) not null,
 SellingPrice decimal(10,2) not null,
 AverageCost  decimal(10,2) not null
)

INSERT INTO tempStockAdjustmentReduce(LocationID,ProductID,CurrentQty,Qty,UpdateQty,CostPrice,SellingPrice,AverageCost)
SELECT LocationID,ProductID,CurrentQty,Qty,(CurrentQty-Qty) as UpdateQty,CostPrice,SellingPrice,AverageCost
FROM tempStockAdjustment 
WHERE CurrentQty>Qty

select * from tempStockAdjustmentReduce



