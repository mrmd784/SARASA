USE [Spos_Data]
GO

/****** Object:  Table [dbo].[tbItemDetails]    Script Date: 2024-06-05 10:13:06 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tbItemDetails](
	[ItemCode] [nvarchar](20) NULL,
	[CategoryName] [nvarchar](50) NULL,
	[SubCategoryName] [nvarchar](50) NULL,
	[BrandName] [nvarchar](50) NULL,
	[Warrenty] [nvarchar](50) NULL
) ON [PRIMARY]

GO

