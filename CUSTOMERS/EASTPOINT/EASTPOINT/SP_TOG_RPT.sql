USE [EastPoint]
GO

/****** Object:  StoredProcedure [dbo].[SP_TOG_RPT]    Script Date: 2023-11-04 5:00:03 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[SP_TOG_RPT] 

@ID varchar(10),
@FromSuppCode varchar(20) = '',
@ToSuppCode varchar(20) = '',
@FromSerialNo varchar(20) = '',
@ToSerialNo varchar(20) = '',
@FromDate datetime,
@ToDate datetime,
@UserId varchar(10) = '',
@LocaCode varchar(5) = '',
@Range varchar(10),
@Selection varchar(10),
@ItemWiseSummary tinyint = 0

AS
   IF @ID = 'Accept'
   BEGIN
      IF @Range = 'None'
      BEGIN
         IF @Selection = 'All'
         BEGIN
            IF @ItemWiseSummary = 0
            BEGIN
               SELECT Idx,SerialNo,Loca_Code,RefNo,TDate,Type,DilDate,FromLoca,ToLoca,(case [Fromloca] when '02' then -TotalCostValue else +TotalCostValue end) as TotalCostValue ,(case Fromloca when '02' then -TotalRetValue else +TotalRetValue end) as TotalRetValue,Id,Status,TrDate
			   ,UserName ,tb_Location.loca_code,tb_Location.loca_name as ref_code FROM tb_TogSumm_Acc INNER JOIN tb_Location ON tb_TogSumm_Acc.ToLoca = tb_Location.Loca_Code WHERE tb_TogSumm_Acc.Status = 1 
			   AND tb_TogSumm_Acc.[Id] = 'TOG' AND tb_TogSumm_Acc.SerialNo IN (SELECT DISTINCT SERIALNO FROM tb_TogDet_Acc WHERE Status = 1 AND [Id] = 'TOG' AND AcQty > 0)
            END
            ELSE
            BEGIN
               SELECT vw_AccptTrnItemSumm.*, tb_Location.Loca_Name AS toLocaName FROM vw_AccptTrnItemSumm INNER JOIN tb_Location ON vw_AccptTrnItemSumm.ToLoca = tb_Location.Loca_Code
               WHERE vw_AccptTrnItemSumm.SerialNo IN (SELECT DISTINCT REFNO FROM tb_TogDet_Acc WHERE Status = 1 AND [Id] = 'TOG' AND AcQty > 0)
            END
         END
         ELSE
         IF @Selection = 'Range'
         BEGIN
            IF @ItemWiseSummary = 0
            BEGIN
               SELECT * FROM tb_TogSumm_Acc INNER JOIN tb_Location ON tb_TogSumm_Acc.ToLoca = tb_Location.Loca_Code
               WHERE tb_TogSumm_Acc.Status = 1 AND tb_TogSumm_Acc.[Id] = 'TOG'  AND tb_TogSumm_Acc.SerialNo 
			   IN (SELECT DISTINCT SERIALNO FROM tb_TogDet_Acc WHERE Status = 1 AND [Id] = 'TOG' AND FromLoca BETWEEN @FromSuppCode AND @ToSuppCode AND AcQty > 0)
            END
            ELSE
            BEGIN
               SELECT vw_AccptTrnItemSumm.*, tb_Location.Loca_Name AS toLocaName
               FROM vw_AccptTrnItemSumm INNER JOIN tb_Location ON vw_AccptTrnItemSumm.ToLoca = tb_Location.Loca_Code
               WHERE vw_AccptTrnItemSumm.SerialNo 
			   IN (SELECT DISTINCT REFNO FROM tb_TogDet_Acc WHERE Status = 1 AND [Id] = 'TOG' AND FromLoca BETWEEN @FromSuppCode AND @ToSuppCode AND AcQty > 0)
            END
         END
         ELSE
         IF @Selection = 'Selected'
         BEGIN
            IF @ItemWiseSummary = 0
            BEGIN
               SELECT * FROM tb_TogSumm_Acc INNER JOIN tb_Location ON tb_TogSumm_Acc.ToLoca = tb_Location.Loca_Code
               WHERE tb_TogSumm_Acc.Status = 1 AND tb_TogSumm_Acc.[Id] = 'TOG' AND tb_TogSumm_Acc.SerialNo IN (SELECT DISTINCT SERIALNO FROM tb_TogDet_Acc
			   WHERE Status = 1 AND [Id] = 'TOG' AND AcQty > 0) AND FromLoca IN (SELECT Code FROM tb_TempSelect WHERE Username = @UserId)
            END
            ELSE
            BEGIN
               SELECT vw_AccptTrnItemSumm.*, tb_Location.Loca_Name AS toLocaName FROM vw_AccptTrnItemSumm INNER JOIN tb_Location ON vw_AccptTrnItemSumm.ToLoca = tb_Location.Loca_Code
               WHERE vw_AccptTrnItemSumm.SerialNo IN (SELECT DISTINCT REFNO FROM tb_TogDet_Acc WHERE Status = 1 AND [Id] = 'TOG' AND AcQty > 0)
			   AND vw_AccptTrnItemSumm.FromLoca IN (SELECT Code FROM tb_TempSelect WHERE Username = @UserId)
            END
         END
      END
      -----
      ELSE
      IF @Range = 'Serial'
      BEGIN
         IF @Selection = 'All'
         BEGIN
            IF @ItemWiseSummary = 0
            BEGIN
               SELECT * FROM tb_TogSumm_Acc INNER JOIN tb_Location ON tb_TogSumm_Acc.ToLoca = tb_Location.Loca_Code WHERE tb_TogSumm_Acc.Status = 1 AND tb_TogSumm_Acc.[Id] = 'TOG'
               AND tb_TogSumm_Acc.SerialNo IN (SELECT DISTINCT SERIALNO FROM tb_TogDet_Acc WHERE Status = 1 AND [Id] = 'TOG' AND AcQty > 0 AND SerialNo BETWEEN @FromSerialNo AND @ToSerialNo)
            END
            ELSE
            BEGIN
               SELECT vw_AccptTrnItemSumm.*, tb_Location.Loca_Name AS toLocaName FROM vw_AccptTrnItemSumm INNER JOIN tb_Location ON vw_AccptTrnItemSumm.ToLoca = tb_Location.Loca_Code
               WHERE vw_AccptTrnItemSumm.SerialNo IN (SELECT DISTINCT REFNO FROM tb_TogDet_Acc WHERE Status = 1 AND [Id] = 'TOG' AND AcQty > 0 AND SerialNo BETWEEN @FromSerialNo AND @ToSerialNo)
            END
         END
         ELSE
         IF @Selection = 'Range'
         BEGIN
            IF @ItemWiseSummary = 0
            BEGIN
               SELECT * FROM tb_TogSumm_Acc INNER JOIN tb_Location ON tb_TogSumm_Acc.ToLoca = tb_Location.Loca_Code 
			   WHERE tb_TogSumm_Acc.Status = 1 AND tb_TogSumm_Acc.[Id] = 'TOG'  AND tb_TogSumm_Acc.SerialNo 
			   IN (SELECT DISTINCT SERIALNO FROM tb_TogDet_Acc WHERE Status = 1 AND [Id] = 'TOG' AND AcQty > 0 AND FromLoca BETWEEN @FromSuppCode AND @ToSuppCode AND SerialNo BETWEEN @FromSerialNo AND @ToSerialNo)
            END
            ELSE
            BEGIN
               SELECT vw_AccptTrnItemSumm.*, tb_Location.Loca_Name AS toLocaName FROM vw_AccptTrnItemSumm INNER JOIN tb_Location ON vw_AccptTrnItemSumm.ToLoca = tb_Location.Loca_Code
               WHERE vw_AccptTrnItemSumm.SerialNo IN (SELECT DISTINCT REFNO FROM tb_TogDet_Acc WHERE Status = 1 AND [Id] = 'TOG' AND AcQty > 0 AND FromLoca BETWEEN @FromSuppCode AND @ToSuppCode AND SerialNo BETWEEN @FromSerialNo AND @ToSerialNo)
            END
         END
         ELSE
         IF @Selection = 'Selected'
         BEGIN
            IF @ItemWiseSummary = 0
            BEGIN
               SELECT * FROM tb_TogSumm_Acc INNER JOIN tb_Location ON tb_TogSumm_Acc.ToLoca = tb_Location.Loca_Code WHERE tb_TogSumm_Acc.Status = 1 AND tb_TogSumm_Acc.[Id] = 'TOG'
               AND tb_TogSumm_Acc.SerialNo IN (SELECT DISTINCT SERIALNO FROM tb_TogDet_Acc WHERE Status = 1 AND [Id] = 'TOG' AND AcQty > 0 AND SerialNo BETWEEN @FromSerialNo AND @ToSerialNo)
               AND FromLoca IN (SELECT Code FROM tb_TempSelect WHERE Username = @UserId)
            END
            ELSE
            BEGIN
               SELECT vw_AccptTrnItemSumm.*, tb_Location.Loca_Name AS toLocaName FROM vw_AccptTrnItemSumm INNER JOIN tb_Location ON vw_AccptTrnItemSumm.ToLoca = tb_Location.Loca_Code
               WHERE vw_AccptTrnItemSumm.SerialNo IN (SELECT DISTINCT REFNO FROM tb_TogDet_Acc
               WHERE Status = 1 AND [Id] = 'TOG' AND AcQty > 0 AND SerialNo BETWEEN @FromSerialNo AND @ToSerialNo)
               AND vw_AccptTrnItemSumm.FromLoca IN (SELECT Code FROM tb_TempSelect WHERE Username = @UserId)
            END
         END
      END
      ELSE
      IF @Range = 'Date'
      BEGIN
         IF @Selection = 'All'
         BEGIN
            IF @ItemWiseSummary = 0
            BEGIN
               SELECT * FROM tb_TogSumm_Acc INNER JOIN tb_Location ON tb_TogSumm_Acc.ToLoca = tb_Location.Loca_Code WHERE tb_TogSumm_Acc.Status = 1 AND tb_TogSumm_Acc.[Id] = 'TOG' 
			   AND tb_TogSumm_Acc.SerialNo IN (SELECT DISTINCT SERIALNO FROM tb_TogDet_Acc WHERE Status = 1 AND [Id] = 'TOG' AND AcQty > 0 AND Tdate BETWEEN @FromDate AND @ToDate)
            END
            ELSE
            BEGIN
               SELECT  vw_AccptTrnItemSumm.*, tb_Location.Loca_Name AS toLocaName FROM vw_AccptTrnItemSumm INNER JOIN tb_Location  ON vw_AccptTrnItemSumm.ToLoca = tb_Location.Loca_Code
               WHERE vw_AccptTrnItemSumm.SerialNo IN (SELECT DISTINCT REFNO FROM tb_TogDet_Acc WHERE Status = 1 AND [Id] = 'TOG' AND AcQty > 0 AND Tdate BETWEEN @FromDate AND @ToDate)
            END
         END
         ELSE
         IF @Selection = 'Range'
         BEGIN
            IF @ItemWiseSummary = 0
            BEGIN
               SELECT * FROM tb_TogSumm_Acc INNER JOIN tb_Location ON tb_TogSumm_Acc.ToLoca = tb_Location.Loca_Code WHERE tb_TogSumm_Acc.Status = 1 AND tb_TogSumm_Acc.[Id] = 'TOG'
               AND tb_TogSumm_Acc.SerialNo IN (SELECT DISTINCT SerialNo FROM tb_TogDet_Acc WHERE Status = 1 AND [Id] = 'TOG' AND AcQty > 0 AND Tdate BETWEEN @FromDate AND @ToDate AND FromLoca BETWEEN @FromSuppCode AND @ToSuppCode)
            END
            ELSE
            BEGIN
               SELECT vw_AccptTrnItemSumm.*, tb_Location.Loca_Name AS toLocaName FROM vw_AccptTrnItemSumm INNER JOIN tb_Location ON vw_AccptTrnItemSumm.ToLoca = tb_Location.Loca_Code
               WHERE vw_AccptTrnItemSumm.SerialNo IN (SELECT DISTINCT REFNO FROM tb_TogDet_Acc WHERE Status = 1 AND [Id] = 'TOG' AND AcQty > 0 AND Tdate BETWEEN @FromDate AND @ToDate AND FromLoca BETWEEN @FromSuppCode AND @ToSuppCode)
            END
         END
         ELSE
         IF @Selection = 'Selected'
         BEGIN
            IF @ItemWiseSummary = 0
            BEGIN
               SELECT * FROM tb_TogSumm_Acc INNER JOIN tb_Location ON tb_TogSumm_Acc.ToLoca = tb_Location.Loca_Code WHERE tb_TogSumm_Acc.Status = 1 AND tb_TogSumm_Acc.[Id] = 'TOG'  
               AND tb_TogSumm_Acc.SerialNo IN (SELECT DISTINCT SERIALNO FROM tb_TogDet_Acc WHERE Status = 1 AND [Id] = 'TOG' AND AcQty > 0 AND Tdate BETWEEN @FromDate AND @ToDate)
			   AND FromLoca IN (SELECT Code FROM tb_TempSelect WHERE Username = @UserId)
            END
            ELSE
            BEGIN
               SELECT vw_AccptTrnItemSumm.*,  tb_Location.Loca_Name AS toLocaName FROM vw_AccptTrnItemSumm INNER JOIN tb_Location  ON vw_AccptTrnItemSumm.ToLoca = tb_Location.Loca_Code
               WHERE vw_AccptTrnItemSumm.SerialNo IN (SELECT DISTINCT  REFNO FROM tb_TogDet_Acc WHERE Status = 1 AND [Id] = 'TOG' AND AcQty > 0 AND Tdate BETWEEN @FromDate AND @ToDate)
               AND vw_AccptTrnItemSumm.FromLoca IN (SELECT Code FROM tb_TempSelect WHERE Username = @UserId)
            END
         END
      END
   END
   ELSE
   -------------------------------End Of Accept------------------------
   IF @ID = 'Transit'
   BEGIN
   Print 'ID'+ @ID + 'Range'+ @Range
      IF @Range = 'None' 
      BEGIN
         IF @Selection = 'All' 
         BEGIN
		 Print 'Range'+ @Range + 'Selection'+ @Selection
            IF @ItemWiseSummary = 0
            BEGIN
               SELECT * FROM tb_TogSumm INNER JOIN tb_Location ON tb_TogSumm.ToLoca = tb_Location.Loca_Code WHERE tb_TogSumm.Status = 1 AND tb_TogSumm.[Id] = 'TOG'
			   AND tb_TogSumm.SerialNo IN (SELECT DISTINCT SerialNo FROM tb_TogDet WHERE Status = 1 AND [Id] = 'TOG' AND Qty > AcQty)
            END
            ELSE
            BEGIN
               SELECT vw_TrnItemSumm.*, tb_Location.Loca_Name AS toLocaName FROM vw_TrnItemSumm INNER JOIN tb_Location ON vw_TrnItemSumm.ToLoca = tb_Location.Loca_Code
               WHERE vw_TrnItemSumm.SerialNo IN (SELECT DISTINCT SerialNo  FROM tb_TogDet WHERE Status = 1 AND [Id] = 'TOG' AND Qty > AcQty)
            END
         END
         ELSE
         IF @Selection = 'Range' 
         BEGIN
		 Print 'Range'+ @Range + 'Selection'+ @Selection
            IF @ItemWiseSummary = 0
            BEGIN
               SELECT *  FROM tb_TogSumm INNER JOIN tb_Location  ON tb_TogSumm.ToLoca = tb_Location.Loca_Code WHERE tb_TogSumm.Status = 1 AND tb_TogSumm.[Id] = 'TOG'
               AND tb_TogSumm.SerialNo IN (SELECT DISTINCT SerialNo FROM tb_TogDet WHERE Status = 1 AND [Id] = 'TOG' AND FromLoca BETWEEN @FromSuppCode AND @ToSuppCode AND Qty > AcQty)
            END
            ELSE
            BEGIN
               SELECT vw_TrnItemSumm.*, tb_Location.Loca_Name AS toLocaName FROM vw_TrnItemSumm INNER JOIN tb_Location ON vw_TrnItemSumm.ToLoca = tb_Location.Loca_Code
               WHERE vw_TrnItemSumm.SerialNo IN (SELECT DISTINCT SerialNo FROM tb_TogDet WHERE Status = 1 AND [Id] = 'TOG' AND FromLoca BETWEEN @FromSuppCode AND @ToSuppCode AND Qty > AcQty)
            END
         END
         ELSE
         IF @Selection = 'Selected'
         BEGIN
		 Print 'Range'+ @Range + 'Selection'+ @Selection
            IF @ItemWiseSummary = 0
            BEGIN
               SELECT * FROM tb_TogSumm INNER JOIN tb_Location  ON tb_TogSumm.ToLoca = tb_Location.Loca_Code WHERE tb_TogSumm.Status = 1 AND tb_TogSumm.[Id] = 'TOG'
               AND tb_TogSumm.SerialNo IN (SELECT DISTINCT SerialNo FROM tb_TogDet WHERE Status = 1 AND [Id] = 'TOG' AND Qty > AcQty) 
			   AND FromLoca IN (SELECT Code FROM tb_TempSelect WHERE Username = @UserId)
            END
            ELSE
            BEGIN
               SELECT vw_TrnItemSumm.*, tb_Location.Loca_Name AS toLocaName FROM vw_TrnItemSumm INNER JOIN tb_Location ON vw_TrnItemSumm.ToLoca = tb_Location.Loca_Code
               WHERE vw_TrnItemSumm.SerialNo IN (SELECT DISTINCT SerialNo FROM tb_TogDet WHERE Status = 1 AND [Id] = 'TOG'  AND Qty > AcQty)
               AND vw_TrnItemSumm.FromLoca IN (SELECT Code FROM tb_TempSelect WHERE Username = @UserId)
            END
         END
      END
      -----
      ELSE
      IF @Range = 'Serial'
      BEGIN
         IF @Selection = 'All'
         BEGIN
		 Print 'Range'+ @Range + 'Selection'+ @Selection
            IF @ItemWiseSummary = 0
            BEGIN
               SELECT * FROM tb_TogSumm INNER JOIN tb_Location ON tb_TogSumm.ToLoca = tb_Location.Loca_Code WHERE tb_TogSumm.Status = 1 AND tb_TogSumm.[Id] = 'TOG' 
			   AND tb_TogSumm.SerialNo IN (SELECT DISTINCT SerialNo FROM tb_TogDet WHERE Status = 1 AND [Id] = 'TOG' AND Qty > AcQty  AND SerialNo BETWEEN @FromSerialNo AND @ToSerialNo)
            END
            ELSE
            BEGIN
               SELECT vw_TrnItemSumm.*, tb_Location.Loca_Name AS toLocaName FROM vw_TrnItemSumm INNER JOIN tb_Location  ON vw_TrnItemSumm.ToLoca = tb_Location.Loca_Code
			   WHERE vw_TrnItemSumm.SerialNo IN (SELECT DISTINCT SerialNo FROM tb_TogDet WHERE Status = 1 AND [Id] = 'TOG' AND Qty > AcQty AND SerialNo BETWEEN @FromSerialNo AND @ToSerialNo)
            END
         END
         ELSE
         IF @Selection = 'Range'
         BEGIN
		 Print 'Range'+ @Range + 'Selection'+ @Selection
            IF @ItemWiseSummary = 0
            BEGIN
               SELECT * FROM tb_TogSumm INNER JOIN tb_Location ON tb_TogSumm.ToLoca = tb_Location.Loca_Code WHERE tb_TogSumm.Status = 1 AND tb_TogSumm.[Id] = 'TOG' 
			   AND tb_TogSumm.SerialNo IN (SELECT DISTINCT SerialNo FROM tb_TogDet WHERE Status = 1 AND [Id] = 'TOG' AND Qty > AcQty AND FromLoca BETWEEN @FromSuppCode AND @ToSuppCode AND SerialNo BETWEEN @FromSerialNo AND @ToSerialNo)
            END
            ELSE
            BEGIN
               SELECT vw_TrnItemSumm.*, tb_Location.Loca_Name AS toLocaName FROM vw_TrnItemSumm INNER JOIN tb_Location ON vw_TrnItemSumm.ToLoca = tb_Location.Loca_Code
               WHERE vw_TrnItemSumm.SerialNo IN (SELECT DISTINCT SerialNo FROM tb_TogDet WHERE Status = 1 AND [Id] = 'TOG' AND Qty > AcQty
               AND FromLoca BETWEEN @FromSuppCode AND @ToSuppCode AND SerialNo BETWEEN @FromSerialNo AND @ToSerialNo)
            END
         END
         ELSE
         IF @Selection = 'Selected'
         BEGIN
		 Print 'Range'+ @Range + 'Selection'+ @Selection
            IF @ItemWiseSummary = 0
            BEGIN
               SELECT * FROM tb_TogSumm INNER JOIN tb_Location ON tb_TogSumm.ToLoca = tb_Location.Loca_Code
               WHERE tb_TogSumm.Status = 1 AND tb_TogSumm.[Id] = 'TOG'
               AND tb_TogSumm.SerialNo IN (SELECT DISTINCT SerialNo FROM tb_TogDet WHERE Status = 1 AND [Id] = 'TOG' AND Qty > AcQty AND SerialNo BETWEEN @FromSerialNo AND @ToSerialNo) 
			   AND FromLoca IN (SELECT Code FROM tb_TempSelect WHERE Username = @UserId)
            END
            ELSE
            BEGIN
               SELECT vw_TrnItemSumm.*, tb_Location.Loca_Name AS toLocaName FROM vw_TrnItemSumm INNER JOIN tb_Location  ON vw_TrnItemSumm.ToLoca = tb_Location.Loca_Code
               WHERE vw_TrnItemSumm.SerialNo IN (SELECT DISTINCT SerialNo FROM tb_TogDet  WHERE Status = 1 AND [Id] = 'TOG' AND Qty > AcQty AND SerialNo BETWEEN @FromSerialNo AND @ToSerialNo) 
			   AND vw_TrnItemSumm.FromLoca IN (SELECT Code FROM tb_TempSelect WHERE Username = @UserId)
            END
         END
      END
      ELSE
      IF @Range = 'Date'
      BEGIN
         IF @Selection = 'All'
         BEGIN
		 Print 'Range'+ @Range + 'Selection'+ @Selection
            IF @ItemWiseSummary = 0
            BEGIN
               SELECT *  FROM tb_TogSumm INNER JOIN tb_Location ON tb_TogSumm.ToLoca = tb_Location.Loca_Code WHERE tb_TogSumm.Status = 1 AND tb_TogSumm.[Id] = 'TOG' 
			   AND tb_TogSumm.SerialNo IN (SELECT DISTINCT SerialNo FROM tb_TogDet  WHERE Status = 1 AND [Id] = 'TOG' AND Qty > AcQty AND Tdate BETWEEN @FromDate AND @ToDate)
            END
            ELSE
            BEGIN
               SELECT vw_TrnItemSumm.*, tb_Location.Loca_Name AS toLocaName FROM vw_TrnItemSumm INNER JOIN tb_Location  ON vw_TrnItemSumm.ToLoca = tb_Location.Loca_Code
               WHERE vw_TrnItemSumm.SerialNo IN (SELECT DISTINCT SerialNo FROM tb_TogDet WHERE Status = 1 AND [Id] = 'TOG' AND Qty > AcQty AND Tdate BETWEEN @FromDate AND @ToDate)
            END
         END
         ELSE
         IF @Selection = 'Range'
         BEGIN
		 Print 'Range'+ @Range + 'Selection'+ @Selection
            IF @ItemWiseSummary = 0
            BEGIN
               SELECT * FROM tb_TogSumm INNER JOIN tb_Location  ON tb_TogSumm.ToLoca = tb_Location.Loca_Code WHERE tb_TogSumm.Status = 1 AND tb_TogSumm.[Id] = 'TOG'
               AND tb_TogSumm.SerialNo IN (SELECT DISTINCT SerialNo FROM tb_TogDet  WHERE Status = 1 AND [Id] = 'TOG' AND Qty > AcQty AND Tdate BETWEEN @FromDate AND @ToDate AND FromLoca BETWEEN @FromSuppCode AND @ToSuppCode)
            END
            ELSE
            BEGIN
               SELECT vw_TrnItemSumm.*, tb_Location.Loca_Name AS toLocaName FROM vw_TrnItemSumm INNER JOIN tb_Location  ON vw_TrnItemSumm.ToLoca = tb_Location.Loca_Code
               WHERE vw_TrnItemSumm.SerialNo IN (SELECT DISTINCT SerialNo FROM tb_TogDet
               WHERE Status = 1 AND [Id] = 'TOG' AND Qty > AcQty AND Tdate BETWEEN @FromDate AND @ToDate AND FromLoca BETWEEN @FromSuppCode AND @ToSuppCode)
            END
         END
         ELSE
         IF @Selection = 'Selected'
         BEGIN
		 Print 'Range'+ @Range + 'Selection'+ @Selection
            IF @ItemWiseSummary = 0
            BEGIN
               SELECT * FROM tb_TogSumm INNER JOIN tb_Location ON tb_TogSumm.ToLoca = tb_Location.Loca_Code WHERE tb_TogSumm.Status = 1 AND tb_TogSumm.[Id] = 'TOG'
               AND tb_TogSumm.SerialNo IN (SELECT DISTINCT SerialNo FROM tb_TogDet WHERE Status = 1 AND [Id] = 'TOG' AND Qty > AcQty AND Tdate BETWEEN @FromDate AND @ToDate)
			   AND FromLoca IN (SELECT Code FROM tb_TempSelect WHERE Username = @UserId)
            END
            ELSE
            BEGIN
               SELECT vw_TrnItemSumm.*, tb_Location.Loca_Name AS toLocaName FROM vw_TrnItemSumm INNER JOIN tb_Location ON vw_TrnItemSumm.ToLoca = tb_Location.Loca_Code 
			   WHERE vw_TrnItemSumm.SerialNo IN (SELECT DISTINCT SerialNo FROM tb_TogDet WHERE Status = 1 AND [Id] = 'TOG'
               AND Qty > AcQty AND Tdate BETWEEN @FromDate AND @ToDate) AND vw_TrnItemSumm.FromLoca IN (SELECT Code FROM tb_TempSelect WHERE Username = @UserId)
            END
         END
      END
   END
GO

