  select SUM(Qty) from tempStockAdjustment

  
  
  --With Excel  Import 
  
  --update ts
  --set ts.Qty+=t.qty
  --from tempStockAdjustment ts
  --inner join StockZuziHatton$1 t
  --on ts.ProductID =t.productid
  
  
  
   select pm.ProductCode,pm.ProductName,d.DepartmentName,c.CategoryName
   ,sc.SubCategoryName, sc2.SubCategory2Name
   ,t.CurrentQty,t.Qty,(t.CurrentQty-t.Qty) as Variance 
   ,(t.Qty*t.SellingPrice) as SellingValue,(t.Qty*t.CostPrice
   ) as CostValue
   from tempStockAdjustment t 
   inner join InvProductMaster pm
   on t.ProductID=pm.InvProductMasterID
   inner join InvDepartment d
   on pm.DepartmentID=d.InvDepartmentID
   inner join InvCategory c
   on pm.CategoryID=c.InvCategoryID
   inner join InvSubCategory sc
   on pm.SubCategoryID=sc.InvSubCategoryID
    inner join InvSubCategory2 sc2
   on pm.SubCategory2ID=sc2.InvSubCategory2ID
   