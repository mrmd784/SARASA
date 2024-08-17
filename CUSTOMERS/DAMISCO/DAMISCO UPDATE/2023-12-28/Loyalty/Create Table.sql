USE [ERP]
GO

/****** Object:  Table [dbo].[InvLoyaltyPromotionTransaction]    Script Date: 2023-12-28 03:41:17 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[InvLoyaltyPromotionTransaction](
	[InvLoyaltyPromotionTransactionID] [bigint] IDENTITY(1,1) NOT NULL,
	[CustomerID] [bigint] NOT NULL,
	[Receipt] [nvarchar](15) NOT NULL,
	[Amount] [decimal](18, 2) NOT NULL,
	[LocationID] [int] NOT NULL,
	[DocumentDate] [datetime] NOT NULL,
	[UnitNo] [int] NOT NULL,
	[CashierID] [bigint] NOT NULL,
	[DiscPer] [decimal](18, 2) NOT NULL,
	[DiscAmt] [decimal](18, 2) NOT NULL,
	[Zno] [bigint] NOT NULL,
	[RefNo] [nvarchar](50) NULL,
	[InvoiceNo] [nvarchar](100) NULL,
	[PromotionID] [bigint] NOT NULL,
 CONSTRAINT [PK_InvLoyaltyPromotionTransaction] PRIMARY KEY CLUSTERED 
(
	[InvLoyaltyPromotionTransactionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


