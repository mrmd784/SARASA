DECLARE @CompanyID INT
DECLARE @LocationID INT
DECLARE @CostCentreID INT
DECLARE @DocumentID INT = 1505
DECLARE @groupofCompanyId INT 
DECLARE @documentNo NVARCHAR(15)
DECLARE @LocationCode NVARCHAR(02)
DECLARE @StockAdjustmentHeaderID INT 
DECLARE @documentdate DATETIME
DECLARE @DocID varchar(10)
DECLARE @StockAdjustmentMode INT


DECLARE @ZDate DATE
DECLARE @Zno BIGINT
DECLARE @UnitNo BIGINT


SET @Zdate= '2024-04-25'
SET @LocationID=1;
SET @CostCentreID = 1;


SELECT  @CompanyID = CompanyId FROM dbo.Company 

SELECT @groupofCompanyId = GroupOfCompanyID FROM dbo.GroupOfCompany WHERE IsActive = 1;
SET @DocID = @DocumentID

SELECT @LocationCode=LocationCode from Location Where LocationID=@LocationID

SET @documentNo = 'STAM' + @LocationCode + '000000002';
SET @StockAdjustmentMode=2;


INSERT INTO [dbo].[InvStockAdjustmentHeader]
           ([StockAdjustmentHeaderID]
           ,[CompanyID]
           ,[LocationID]
           ,[CostCentreID]
           ,[DocumentID]
           ,[DocumentNo]
           ,[DocumentDate]
           ,[TotalCostValue]
           ,[TotalSellingtValue]
           ,[TotalQty]
           ,[ReferenceDocumentID]
           ,[ReferenceDocumentNo]
           ,[ReferenceNo]
           ,[StockAdjustmentMode]
           ,[StockAdjustmentLayer]
           ,[Narration]
           ,[Remark]
           ,[DocumentStatus]
           ,[IsDelete]
           ,[GroupOfCompanyID]
           ,[CreatedUser]
           ,[CreatedDate]
           ,[ModifiedUser]
           ,[ModifiedDate]
           ,[DataTransfer])
     VALUES
           (0
           ,@CompanyID
           ,@LocationID
           ,1
           ,@DocumentID
           ,@documentNo
           ,@Zdate
           ,0--<TotalCostValue, decimal(18,2),>
           ,0--<TotalSellingtValue, decimal(18,2),>
           ,0--<TotalQty, decimal(18,0),>
           ,0--<ReferenceDocumentID, int,>
           ,0--<ReferenceDocumentNo, nvarchar(20),>
           ,''--<ReferenceNo, nvarchar(20),>
           ,@StockAdjustmentMode--<StockAdjustmentMode, int,>
           ,0--<StockAdjustmentLayer, int,>
           ,''--<Narration, nvarchar(500),>
           ,'Stock Take 2024'--<Remark, nvarchar(150),>
           ,1
           ,0
           ,@groupofCompanyId
           ,'SARASA' 
           ,@Zdate
           ,'SARASA' 
           ,@Zdate
           ,0)


SELECT @StockAdjustmentHeaderID = InvStockAdjustmentHeaderID, @documentdate = DocumentDate FROM InvStockAdjustmentHeader WHERE DocumentNo = @documentNo;

IF(@StockAdjustmentMode=1)
BEGIN
INSERT INTO [dbo].[InvStockAdjustmentDetail]
           ([StockAdjustmentDetailID]
           ,[InvStockAdjustmentHeaderID]
           ,[CompanyID]
           ,[LocationID]
           ,[CostCentreID]
           ,[ProductID]
           ,[InvProductColorSizeID]
           ,[DocumentID]
           ,[DocumentNo]
           ,[DocumentDate]
           ,[StockAdjustmentMode]
           ,[CurrentQty]
           ,[BatchQty]
           ,[OrderQty]
           ,[ExcessQty]
           ,[ShortageQty]
           ,[OverWriteQty]
           ,[AverageCost]
           ,[AverageCostExcessQuantity]
           ,[AverageCostShortageQuantity]
           ,[AverageCostCurrentQuantity]
           ,[BatchNo]
           ,[BaseUnitID]
           ,[ConvertFactor]
           ,[ExpiryDate]
           ,[CostPrice]
           ,[SellingPrice]
           ,[UnitOfMeasureID]
           ,[CostValue]
           ,[SellingValue]
           ,[LineNo]
           ,[DocumentStatus]
           ,[IsDelete]
           ,[GroupOfCompanyID]
           ,[CreatedUser]
           ,[CreatedDate]
           ,[ModifiedUser]
           ,[ModifiedDate]
           ,[DataTransfer])
  
  SELECT
           0--<StockAdjustmentDetailID, bigint,>
           ,@StockAdjustmentHeaderID--<InvStockAdjustmentHeaderID, bigint,>
           ,@CompanyID--<CompanyID, int,>
           ,@LocationID--<LocationID, int,>
           ,1--<CostCentreID, int,>
           ,sta.ProductID --<ProductID, bigint,>
           ,0--<InvProductColorSizeID, bigint,>
           ,@DocumentID--<DocumentID, int,>
           ,@documentNo--<DocumentNo, nvarchar(20),>
           ,@ZDate--<DocumentDate, datetime,>
           ,@StockAdjustmentMode--<StockAdjustmentMode, int,>
           ,sta.CurrentQty--<CurrentQty, decimal(18,0),>
           ,0--<BatchQty, decimal(18,0),>
           ,sta.UpdateQty--<OrderQty, decimal(18,0),>
           ,sta.UpdateQty--<ExcessQty, decimal(18,0),>
           ,0--<ShortageQty, decimal(18,0),>
           ,0--<OverWriteQty, decimal(18,0),>
           ,sta.AverageCost--<AverageCost, decimal(18,2),>
           ,0--<AverageCostExcessQuantity, decimal(18,2),>
           ,0--<AverageCostShortageQuantity, decimal(18,2),>
           ,0--<AverageCostCurrentQuantity, decimal(18,2),>
           ,'*DEFAULT_BATCH*'--<BatchNo, nvarchar(50),>
           ,1--<BaseUnitID, bigint,>
           ,1--<ConvertFactor, decimal(18,2),>
           ,GetDate()--<ExpiryDate, datetime,>
           ,sta.CostPrice--<CostPrice, decimal(18,2),>
           ,sta.SellingPrice--<SellingPrice, decimal(18,2),>
           ,1--<UnitOfMeasureID, bigint,>
           ,0--<CostValue, decimal(18,2),>
           ,0--<SellingValue, decimal(18,2),>
           ,0--<LineNo, bigint,>
           ,1--<DocumentStatus, int,>
           ,0--<IsDelete, bit,>
           ,@groupofCompanyId--<GroupOfCompanyID, int,>
           ,'SARASA' 
           ,@Zdate
           ,'SARASA' 
           ,@Zdate
           ,0
		   	FROM tempStockAdjustmentAdd sta  

	
	UPDATE InvStockAdjustmentHeader SET TotalQty=isnull(SumQty,0),
                              TotalSellingtValue=isnull(TotalSellingPrice,0),
                              TotalCostValue=isnull(TotalCostPrice,0)
FROM (select sum(UpdateQty) as SumQty,sum(UpdateQty*CostPrice) as TotalCostPrice,sum(UpdateQty*SellingPrice) as TotalSellingPrice from 
tempStockAdjustmentAdd)  
Grouped WHERE InvStockAdjustmentHeader.DocumentNo=@documentNo

	
			 


declare @i int  = 0
update InvStockAdjustmentDetail
set [LineNo]  = @i , @i = @i + 1,
CostValue=(CostPrice*OrderQty),
SellingValue=(SellingPrice*OrderQty),
AverageCostExcessQuantity=(AverageCost*OrderQty)
where DocumentNo=@documentNo


END
ELSE
BEGIN
INSERT INTO [dbo].[InvStockAdjustmentDetail]
           ([StockAdjustmentDetailID]
           ,[InvStockAdjustmentHeaderID]
           ,[CompanyID]
           ,[LocationID]
           ,[CostCentreID]
           ,[ProductID]
           ,[InvProductColorSizeID]
           ,[DocumentID]
           ,[DocumentNo]
           ,[DocumentDate]
           ,[StockAdjustmentMode]
           ,[CurrentQty]
           ,[BatchQty]
           ,[OrderQty]
           ,[ExcessQty]
           ,[ShortageQty]
           ,[OverWriteQty]
           ,[AverageCost]
           ,[AverageCostExcessQuantity]
           ,[AverageCostShortageQuantity]
           ,[AverageCostCurrentQuantity]
           ,[BatchNo]
           ,[BaseUnitID]
           ,[ConvertFactor]
           ,[ExpiryDate]
           ,[CostPrice]
           ,[SellingPrice]
           ,[UnitOfMeasureID]
           ,[CostValue]
           ,[SellingValue]
           ,[LineNo]
           ,[DocumentStatus]
           ,[IsDelete]
           ,[GroupOfCompanyID]
           ,[CreatedUser]
           ,[CreatedDate]
           ,[ModifiedUser]
           ,[ModifiedDate]
           ,[DataTransfer])
  
  SELECT
           0--<StockAdjustmentDetailID, bigint,>
           ,@StockAdjustmentHeaderID--<InvStockAdjustmentHeaderID, bigint,>
           ,@CompanyID--<CompanyID, int,>
           ,@LocationID--<LocationID, int,>
           ,1--<CostCentreID, int,>
           ,star.ProductID --<ProductID, bigint,>
           ,0--<InvProductColorSizeID, bigint,>
           ,@DocumentID--<DocumentID, int,>
           ,@documentNo--<DocumentNo, nvarchar(20),>
           ,@ZDate--<DocumentDate, datetime,>
           ,@StockAdjustmentMode--<StockAdjustmentMode, int,>
           ,star.CurrentQty--<CurrentQty, decimal(18,0),>
           ,0--<BatchQty, decimal(18,0),>
           ,star.UpdateQty--<OrderQty, decimal(18,0),>
           ,0--<ExcessQty, decimal(18,0),>
           ,star.UpdateQty--<ShortageQty, decimal(18,0),>
           ,0--<OverWriteQty, decimal(18,0),>
           ,star.AverageCost--<AverageCost, decimal(18,2),>
           ,0--<AverageCostExcessQuantity, decimal(18,2),>
           ,0--<AverageCostShortageQuantity, decimal(18,2),>
           ,0--<AverageCostCurrentQuantity, decimal(18,2),>
           ,'*DEFAULT_BATCH*'--<BatchNo, nvarchar(50),>
           ,1--<BaseUnitID, bigint,>
           ,1--<ConvertFactor, decimal(18,2),>
           ,GetDate()--<ExpiryDate, datetime,>
           ,star.CostPrice--<CostPrice, decimal(18,2),>
           ,star.SellingPrice--<SellingPrice, decimal(18,2),>
           ,1--<UnitOfMeasureID, bigint,>
           ,0--<CostValue, decimal(18,2),>
           ,0--<SellingValue, decimal(18,2),>
           ,0--<LineNo, bigint,>
           ,1--<DocumentStatus, int,>
           ,0--<IsDelete, bit,>
           ,@groupofCompanyId--<GroupOfCompanyID, int,>
           ,'SARASA' 
           ,@Zdate
           ,'SARASA' 
           ,@Zdate
           ,0
		   	FROM tempStockAdjustmentReduce star  

	
	UPDATE InvStockAdjustmentHeader SET TotalQty=isnull(SumQty,0),
                              TotalSellingtValue=isnull(TotalSellingPrice,0),
                              TotalCostValue=isnull(TotalCostPrice,0)
FROM (select sum(UpdateQty) as SumQty,sum(UpdateQty*CostPrice) as TotalCostPrice,sum(UpdateQty*SellingPrice) as TotalSellingPrice from 
tempStockAdjustmentReduce)  
Grouped WHERE InvStockAdjustmentHeader.DocumentNo=@documentNo
				 

declare @j int  = 0
update InvStockAdjustmentDetail
set [LineNo]  = @j , @j = @j + 1,
CostValue=(CostPrice*OrderQty),
SellingValue=(SellingPrice*OrderQty),
AverageCostShortageQuantity=(AverageCost*OrderQty)
where DocumentNo=@documentNo

END






