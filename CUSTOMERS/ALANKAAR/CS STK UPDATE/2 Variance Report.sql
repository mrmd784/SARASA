  select SUM(Qty) from tempStockAdjustment

  
  
  --With Excel  Import 
  
  --update ts
  --set ts.Qty+=t.qty
  --from tempStockAdjustment ts
  --inner join StockZuziHatton$1 t
  --on ts.ProductID =t.productid
  --select * from stock20240509
  -- Need to add color Size Table (Inner join InvProductColorSize)
 
   select pm.ProductCode,pm.ProductName,d.DepartmentName,c.CategoryName
   ,sc.SubCategoryName, sc2.SubCategory2Name,t.InvProductColorSizeID,pc.ColorSizeCode,pc.ColorSizeName
   ,t.CurrentQty,t.Qty,(t.CurrentQty-t.Qty) as Variance 
   ,(t.Qty*t.SellingPrice) as SellingValue,(t.Qty*t.CostPrice
   ) as CostValue into stock20240509
   from tempStockAdjustment t 
   inner join InvProductMaster pm
   on t.ProductID=pm.InvProductMasterID
    left join InvProductColorSize pc
   on t.InvProductColorSizeID=pc.InvProductColorSizeID
   inner join InvDepartment d
   on pm.DepartmentID=d.InvDepartmentID
   inner join InvCategory c
   on pm.CategoryID=c.InvCategoryID
   inner join InvSubCategory sc
   on pm.SubCategoryID=sc.InvSubCategoryID
    inner join InvSubCategory2 sc2
   on pm.SubCategory2ID=sc2.InvSubCategory2ID
   
   --select * from stock2024 where ProductCode='010300000058'
   --   select sum(Qty) from stock2024 
   --      select SUM(CurrentQty) from stock2024  where ProductCode='010300000058'
   ----
   --where Variance<>0 order by Qty
   
   --select * from InvProductColorSize
   