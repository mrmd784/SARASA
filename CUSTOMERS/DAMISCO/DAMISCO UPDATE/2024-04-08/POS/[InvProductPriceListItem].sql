USE [SPOSDATA]
GO

/****** Object:  Table [dbo].[InvProductPriceListItem]    Script Date: 24/08/2023 10:12:32 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[InvProductPriceListItem](
	[InvProductPriceListItemID] [bigint] IDENTITY(1,1) NOT NULL,
	[InvProductPriceListID] [int] NOT NULL,
	[InvProductPriceListItemName] [nvarchar](max) NOT NULL,
	[ProductID] [bigint] NOT NULL,
	[PriceMargin] [decimal](18, 2) NOT NULL,
	[GroupOfCompanyID] [int] NOT NULL,
	[CreatedUser] [nvarchar](50) NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedUser] [nvarchar](50) NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[DataTransfer] [int] NOT NULL,
 CONSTRAINT [PK_dbo.InvProductPriceListItem] PRIMARY KEY CLUSTERED 
(
	[InvProductPriceListItemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


