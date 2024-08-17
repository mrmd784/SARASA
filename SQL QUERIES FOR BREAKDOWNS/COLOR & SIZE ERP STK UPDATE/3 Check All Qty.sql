select td.Productid,2 as LocationID,UnitNo,isnull(SUM(case td.DocumentID when 1 then td.Qty when 2 then -td.Qty else 0 end),0) AS SumQty
	,isnull(td.cost,0) GCostPrice,isnull(td.Price,0) as GSellingPrice
	 ,isnull(max(td.AvgCost),0) as MaxAverageCost into #t1
	 from TransactionDet td   
	  WHERE td.DocumentID in(1,2) AND [Status]=1
	AND SaleTypeID=1 AND BillTypeID=1 AND TransStatus=1
	AND CAST(td.Zdate AS Date) in ('2019-01-28')   AND td.LocationID=2000

	  GROUP BY td.Productid,td.LocationID,UnitNo,td.cost,td.Price
	  
	  
	  
	  select UnitNo/100,SUM(SumQty) from #t1
	  group by UnitNo order by unitno
	  
	  
	  	  select SUM(SumQty) from #t1
	  drop table #t1
	  
	  
