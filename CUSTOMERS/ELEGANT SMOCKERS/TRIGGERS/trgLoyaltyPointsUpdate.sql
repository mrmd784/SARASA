USE [Easyway]
GO

/****** Object:  Trigger [dbo].[trgLoyaltyPointsUpdate]    Script Date: 27/03/2024 4:57:07 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER [dbo].[trgLoyaltyPointsUpdate]
   ON [dbo].[tb_LoyaltyDet]
   AFTER INSERT
AS 
BEGIN

Update cl set cl.Points = lb.Points FROM tb_CustomerLoyalty cl
Inner Join vw_LoyaltyBal lb on  cl.CustCode = lb.CustCode

END

GO

