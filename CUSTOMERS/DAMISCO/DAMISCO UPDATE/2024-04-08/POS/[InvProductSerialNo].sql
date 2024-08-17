USE [SPOSDATA]
GO

/****** Object:  Table [dbo].[InvProductSerialNo]    Script Date: 12/09/2023 2:28:25 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[InvProductSerialNo](
	[InvProductSerialNoID] [bigint] IDENTITY(1,1) NOT NULL,
	[ProductSerialNoID] [bigint] NOT NULL,
	[GroupOfCompanyID] [int] NOT NULL,
	[CompanyID] [int] NOT NULL,
	[LocationID] [int] NOT NULL,
	[CostCentreID] [int] NOT NULL,
	[ProductID] [bigint] NOT NULL,
	[BatchNo] [nvarchar](40) NULL,
	[UnitOfMeasureID] [bigint] NOT NULL,
	[ExpiryDate] [datetime] NULL,
	[SerialNo] [nvarchar](max) NOT NULL,
	[SerialNoStatus] [int] NOT NULL,
	[DocumentStatus] [int] NOT NULL,
	[CreatedUser] [nvarchar](50) NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedUser] [nvarchar](50) NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[DataTransfer] [int] NOT NULL,
 CONSTRAINT [PK_dbo.InvProductSerialNo] PRIMARY KEY CLUSTERED 
(
	[InvProductSerialNoID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


