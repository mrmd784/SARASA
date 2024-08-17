select * from tempStocktake

INSERT INTO [dbo].[tempStocktake]
           ([ProductID]
           ,[LocationID]
           ,[CurrentQty]
           ,[Qty]
           ,[CostPrice]
           ,[SellingPrice]
           ,[AverageCost])

select 
pm.InvProductMasterID [ProductID]
           ,4 [LocationID]
           ,0 [CurrentQty]
           ,[Qty]
           ,[CostPrice]
           ,st.[SellingPrice]
           ,[AverageCost]
from StockTake st
inner join InvProductMaster pm on pm.ProductCode=st.ProductCode