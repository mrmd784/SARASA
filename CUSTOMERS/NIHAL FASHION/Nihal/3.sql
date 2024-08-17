
--INSERT INTO [dbo].[tempStockAdjustment]
--           ([ProductID]
--           ,[LocationID]
--           ,[CurrentQty]
--           ,[Qty]
--           ,[CostPrice]
--           ,[SellingPrice]
--           ,[AverageCost])



--select 
--[ProductID]
--           ,[LocationID]
--           ,[CurrentQty]
--           ,SUM(qty) [Qty]
--           ,[CostPrice]
--           ,[SellingPrice]
--           ,[AverageCost]
-- from tempStocktake
--group by ProductID,LocationID,currentqty,SellingPrice,CostPrice,AverageCost


select * from [tempStockAdjustment]



----- please get the givendate report

  Update tm
	  set tm.CurrentQty=ps.StockQty
	  from tempStockAdjustment tm
	  inner join InvTmpProductStockDetails ps
	  on tm.Productid=ps.ProductID 
	  and tm.LocationId=ps.LocationID








 
--update t set t.Qty=t1.qty,t.SellingPrice=t1.SellingPrice,t.CostPrice=t1.CostPrice from tempStockAdjustment t
-- inner join TempNavi t1 on t.ProductID=t1.ProductID
-- and 
-- t.LocationID=t1.LocationID


select productid,locationid,sum(Qty) as Qty,max(CostPrice) CostPrice,max(SellingPrice) SellingPrice,Max(AverageCost) as AverageCost into TempNavi from tempStockAdjustment
group by productid,locationid

