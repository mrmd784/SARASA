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

SELECT  1 as LocationID,pm.InvProductMasterID,0 as CurrentQty,0 as Qty,
pm.CostPrice as CostPrice,pm.SellingPrice as SellingPrice,
pm.AverageCost as AvarageCost 
from InvProductMaster pm 
  
--With Excel  Import 
  
update ts
set ts.Qty=t.HO
from tempStockAdjustment ts
inner join STOCK0628 t
on ts.ProductID =t.F3


select * from tempStockAdjustment
select sum(CurrentQty) from tempStockAdjustment
select sum(Qty) from tempStockAdjustment

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

