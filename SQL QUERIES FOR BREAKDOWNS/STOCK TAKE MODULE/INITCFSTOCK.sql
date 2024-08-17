USE [EASYWAY]
GO

/****** Object:  StoredProcedure [dbo].[Sp_InitCFStock]    Script Date: 2024-03-01 11:33:56 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER Proc [dbo].[Sp_InitCFStock]
@Loca		Char(5)
As

Delete From tb_Stock_OpBal Where LocaCode=@Loca And CNo<=0 
Delete From tb_Stock_Backup Where LocaCode=@Loca And CNo<=0


GO

