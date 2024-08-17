USE [EASYWAY]
GO

/****** Object:  StoredProcedure [dbo].[SP_STOCK_VARIENCE_SAVE]    Script Date: 2024-03-01 11:40:35 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[SP_STOCK_VARIENCE_SAVE]
@LOCA VARCHAR(5),
@CODE1 VARCHAR(20),
@CODE2 VARCHAR(20),
@ID CHAR(3),
@TYPE INT,
@USERNAME VARCHAR(10),
@REFNO VARCHAR(10)
AS
Declare @CNo Int
Set @CNo=0
Select @CNo=Isnull(Max(CNo)+1,1) From tb_Stock_Backup Where CNo>=0
--If (@TYPE<>1)
--Begin
--	If @ID='OIT' Select @CODE1=MIN(Code),@CODE2=MAX(Code) FROM tb_TempSelect WHERE UserName=@USERNAME  AND [ID]='OIT' AND LocaCode=@LOCA 
--	If @ID='OSP' Select @CODE1=MIN(Item_Code),@CODE2=MAX(Item_Code) From tb_Item Where tb_Item.Cat_Code IN (SELECT Code FROM tb_TempSelect WHERE UserName=@USERNAME AND [ID]='OSP' AND LocaCode=@LOCA)
--	If @ID='OCT' Select @CODE1=MIN(Item_Code),@CODE2=MAX(Item_Code) From tb_Item Where tb_Item.Cat_Code IN (SELECT Code FROM tb_TempSelect WHERE UserName=@USERNAME AND [ID]='OCT' AND LocaCode=@LOCA)  
--	If @ID='OSC' Select @CODE1=MIN(Item_Code),@CODE2=MAX(Item_Code) From tb_Item Where tb_Item.SubCat_Code IN (SELECT Code FROM tb_TempSelect WHERE UserName=@USERNAME AND [ID]='OSC' AND LocaCode=@LOCA)  
--End

Update tb_Stock_Backup Set CNo=@CNo, StockCountRef=@REFNO Where CNo=0
Update tb_Stock_OpBal Set CNo=@CNo, StockCountRef=@REFNO Where CNo=0

Delete From tb_Stock_OpBal Where LocaCode=@Loca And CNo<=0 
Delete From tb_Stock_Backup Where LocaCode=@Loca And CNo<=0

GO

