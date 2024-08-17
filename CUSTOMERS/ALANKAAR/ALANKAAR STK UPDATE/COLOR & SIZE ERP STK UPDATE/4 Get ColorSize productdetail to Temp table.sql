declare 
@CompanyId INT=1,
@SelectedLocationID INT=1,
@GivenDate DATETIME ='2023-10-28',
--@FromId BIGINT,
--@ToId BIGINT,
@FromCode VARCHAR(20)='0',
@ToCode VARCHAR(20)='z',
@UserId BIGINT=1,
@UniqueId BIGINT=1,
@CreatedUser VARCHAR(30)='SARASA'

-- CREATE TABLE InvTmpProductStockDetailsColorSize USING A SCRIPT OF InvTmpProductStockDetails TABLE
-- ALLOW NULL TO THE COLUMNS IF HAVE TO
INSERT INTO InvTmpProductStockDetailsColorSize (CompanyId, LocationId, GivenDate
,ProductID, ProductCode, ProductName, CostPrice, SellingPrice, AverageCost, DepartmentID, 
CategoryID, SubCategoryID, SubCategory2ID, SupplierID, StockQty, UserId, IsDelete, GroupOfCompanyID
,CreatedUser, CreatedDate, ModifiedUser, ModifiedDate, DataTransfer,ColorSizeID)

SELECT @CompanyId,@SelectedLocationID,@GivenDate
, pm.InvProductMasterID, pm.ProductCode, pm.ProductName, pm.CostPrice, pm.SellingPrice, pm.AverageCost, pm.DepartmentID,
pm.CategoryID, pm.SubCategoryID, pm.SubCategory2ID, pm.SupplierID, 0, @UserId, 0, 1
,@CreatedUser, GETDATE(), @CreatedUser, GETDATE(), 0,cs.InvProductColorSizeID 
FROM InvProductMaster pm INNER JOIN InvDepartment d ON pm.DepartmentID = d.InvDepartmentID  
INNER JOIN InvProductColorSize cs on pm.InvProductMasterID=cs.InvProductMasterID
WHERE d.DepartmentCode Between @FromCode And @ToCode AND pm.IsCountable = 1 and pm.IsColorSize=1