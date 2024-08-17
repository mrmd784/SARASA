
 IF OBJECT_ID('tempCurrentStockTake') IS NOT NULL
  DROP TABLE tempCurrentStockTake

IF OBJECT_ID('dbo.tempStockAdjustment', 'U') IS NOT NULL 
  DROP TABLE dbo.tempStockAdjustment;

  IF OBJECT_ID('dbo.tempStockAdjustmentAdd', 'U') IS NOT NULL 
DROP TABLE dbo.tempStockAdjustmentAdd;

IF OBJECT_ID('dbo.tempStockAdjustmentReduce', 'U') IS NOT NULL 
DROP TABLE dbo.tempStockAdjustmentReduce;

IF OBJECT_ID('tempCurrentStockTakeGroup') IS NOT NULL
  DROP TABLE tempCurrentStockTakeGroup	

  IF OBJECT_ID('tempCurrentStockTakeNew') IS NOT NULL
  DROP TABLE tempCurrentStockTakeNew

