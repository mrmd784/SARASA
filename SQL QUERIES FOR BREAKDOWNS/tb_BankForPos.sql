USE [EasyWay]
GO
/****** Object:  Table [dbo].[tb_BankForPos]    Script Date: 2024-03-19 9:08:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tb_BankForPos](
	[Idx] [int] IDENTITY(1,1) NOT NULL,
	[IdNo] [int] NOT NULL,
	[Bank] [varchar](20) NOT NULL,
	[Rate] [decimal](18, 2) NOT NULL CONSTRAINT [DF_tb_BankForPos_Rate]  DEFAULT ((0)),
	[ErpId] [int] NOT NULL DEFAULT ((0))
) ON [PRIMARY]

GO
SET ANSI_PADDING ON
GO
SET IDENTITY_INSERT [dbo].[tb_BankForPos] ON 

INSERT [dbo].[tb_BankForPos] ([Idx], [IdNo], [Bank], [Rate], [ErpId]) VALUES (2, 1, N'SAMPATH BANK        ', CAST(0.00 AS Decimal(18, 2)), 0)
INSERT [dbo].[tb_BankForPos] ([Idx], [IdNo], [Bank], [Rate], [ErpId]) VALUES (3, 2, N'HNB                 ', CAST(0.00 AS Decimal(18, 2)), 0)
INSERT [dbo].[tb_BankForPos] ([Idx], [IdNo], [Bank], [Rate], [ErpId]) VALUES (4, 99, N'OTHER BANK', CAST(0.00 AS Decimal(18, 2)), 0)
INSERT [dbo].[tb_BankForPos] ([Idx], [IdNo], [Bank], [Rate], [ErpId]) VALUES (5, 4, N'PEOPLES             ', CAST(0.00 AS Decimal(18, 2)), 0)
INSERT [dbo].[tb_BankForPos] ([Idx], [IdNo], [Bank], [Rate], [ErpId]) VALUES (6, 6, N'HSBC                ', CAST(0.00 AS Decimal(18, 2)), 0)
INSERT [dbo].[tb_BankForPos] ([Idx], [IdNo], [Bank], [Rate], [ErpId]) VALUES (7, 7, N'STANDARD CHARTE     ', CAST(0.00 AS Decimal(18, 2)), 0)
INSERT [dbo].[tb_BankForPos] ([Idx], [IdNo], [Bank], [Rate], [ErpId]) VALUES (8, 8, N'BOC                 ', CAST(0.00 AS Decimal(18, 2)), 0)
INSERT [dbo].[tb_BankForPos] ([Idx], [IdNo], [Bank], [Rate], [ErpId]) VALUES (9, 9, N'SEYLAN              ', CAST(0.00 AS Decimal(18, 2)), 0)
INSERT [dbo].[tb_BankForPos] ([Idx], [IdNo], [Bank], [Rate], [ErpId]) VALUES (10, 10, N'NDB                 ', CAST(0.00 AS Decimal(18, 2)), 0)
INSERT [dbo].[tb_BankForPos] ([Idx], [IdNo], [Bank], [Rate], [ErpId]) VALUES (11, 11, N'NATIONS TRUST       ', CAST(0.00 AS Decimal(18, 2)), 0)
INSERT [dbo].[tb_BankForPos] ([Idx], [IdNo], [Bank], [Rate], [ErpId]) VALUES (12, 3, N'COMMERCIAL BANK     ', CAST(0.00 AS Decimal(18, 2)), 0)
INSERT [dbo].[tb_BankForPos] ([Idx], [IdNo], [Bank], [Rate], [ErpId]) VALUES (13, 10, N'NDB BANK            ', CAST(0.00 AS Decimal(18, 2)), 0)
SET IDENTITY_INSERT [dbo].[tb_BankForPos] OFF
