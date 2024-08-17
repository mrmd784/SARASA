INSERT INTO [dbo].[tempStocktake]
           ([ProductID]
           ,[LocationID]
           ,[CurrentQty]
           ,[Qty]
           ,[CostPrice]
           ,[SellingPrice]
           ,[AverageCost])

select td.Productid,4 as LocationID,isnull(SUM(case td.DocumentID when 1 then td.Qty when 2 then -td.Qty else 0 end),0) AS SumQty
	,isnull(td.cost,0) GCostPrice,isnull(td.Price,0) as GSellingPrice
	 ,isnull(max(td.AvgCost),0) as MaxAverageCost
	 from TransactionDet td   
	  WHERE td.DocumentID in(1,2) AND [Status]=3
	AND SaleTypeID=1 AND BillTypeID=1 AND TransStatus=3
	AND CAST(td.Zdate AS Date)= '2023-06-09'   AND td.LocationID=4 
	  GROUP BY td.Productid,td.LocationID,td.cost,td.Price