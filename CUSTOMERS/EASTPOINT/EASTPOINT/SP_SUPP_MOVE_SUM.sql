USE [EastPoint]
GO

/****** Object:  StoredProcedure [dbo].[SP_SUPP_MOVE_SUM]    Script Date: 2023-11-04 3:16:14 PM ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

ALTER Procedure [dbo].[SP_SUPP_MOVE_SUM]
@SuppCode		Varchar(10),
@Date1 		Datetime ,
@Date2 		Datetime,
@Loca			Char(5)
As

Truncate Table tb_StockMove

Insert Into tb_StockMove([ItemCode],[Descrip],[Scale],[Pack],[Qty],[StValue],[PQty],[PValue],[SQty],[SValue],[ClQty],[ClValue],[AdjQty],[RefCode],[Qty1],[StValue1],[PQty1],[PValue1],[SQty1],[SValue1],[ClQty1],[ClValue1],[AdjQty1]
,[Qty2],[StValue2],[PQty2],[PValue2],[SQty2],[SValue2],[ClQty2],[ClValue2],[AdjQty2],[Qty3],[StValue3],[PQty3],[PValue3],[SQty3],[SValue3],[ClQty3],[ClValue3],[AdjQty3])
Select Item_Code,Descrip,ConvertFactUnit,ConvertFact,0,0,0,0,0,0,0,0,0,L3_Code,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 From tb_Item Where Supp_Code=@SuppCode Order By L3_Code,Descrip

Create Table #tb_TmpMv (ItemCode Varchar(25),Qty Decimal(12,4),Amount Decimal(12,4),Iid Char(3))


Truncate Table #tb_TmpMv

Insert Into #tb_TmpMv (ItemCode,Qty,Amount,Iid) Select ItemCode,Isnull(Sum(Case [Id] When 'OPB' Then (PackSize*Qty) When 'PCH' Then (PackSize*Qty) 
When 'PRN' Then -(PackSize*Qty) When 'INV' Then -(PackSize*Qty) When 'MKR' Then (PackSize*Qty) When 'DMG' Then -(PackSize*Qty) 
When 'PRD' Then -(PackSize*Qty) When 'DSC' Then -(PackSize*Qty) When 'ADD' Then (PackSize*Qty) When 'TOG' Then -(PackSize*Qty) 
When 'IN1' Then (PackSize*Qty) When 'IN2' Then (PackSize*Qty) When 'AOD' Then -(PackSize*Qty) Else 0 End),0),0,'OPB'  From 
tb_Stock Where  Status=1 And LocaCode=@Loca And PDate < @Date1 And ItemCode In (Select ItemCode From tb_StockMove) Group By ItemCode

Insert Into #tb_TmpMv (ItemCode,Qty,Amount,Iid) Select ItemCode,Isnull(Sum(Case [Id] When 'OPB' Then (PackSize*Qty) When 'PCH' Then (PackSize*Qty) 
When 'PRN' Then -(PackSize*Qty) When 'INV' Then -(PackSize*Qty) When 'MKR' Then (PackSize*Qty) When 'DMG' Then -(PackSize*Qty) 
When 'PRD' Then -(PackSize*Qty) When 'DSC' Then -(PackSize*Qty) When 'ADD' Then (PackSize*Qty) When 'TOG' Then -(PackSize*Qty) 
When 'IN1' Then (PackSize*Qty) When 'IN2' Then (PackSize*Qty) When 'AOD' Then -(PackSize*Qty) Else 0 End),0),0,'CLB'  From 
tb_Stock Where  Status=1 And LocaCode=@Loca And PDate <= @Date2 And ItemCode In (Select ItemCode From tb_StockMove) Group By ItemCode


Insert Into #tb_TmpMv (ItemCode,Qty,Amount,Iid) Select ItemCode,Sum(Isnull(Case Id When 'PCH' Then PackSize*Qty  When 'PRN' Then -(PackSize*Qty) Else 0 End,0)),Sum(Isnull(Case Id When 'PCH' Then PackSize*Qty*RealCost  When 'PRN' Then -(PackSize*Qty*RealCost) Else 0 End,0)),'PCH' From tb_Stock
Where (Id='PCH' Or Id='PRN') And LocaCode='01' And Status=1 And PDate Between @Date1 And @Date2 And ItemCode In (Select ItemCode From tb_StockMove) Group By ItemCode

Insert Into #tb_TmpMv (ItemCode,Qty,Amount,Iid) Select ItemCode,Sum(Isnull(Case Id When 'INV' Then PackSize*Qty  When 'MKR' Then -(PackSize*Qty) Else 0 End,0)),Sum(Isnull(Case Id When 'INV' Then PackSize*Qty*RealCost  When 'MKR' Then -(PackSize*Qty*RealCost) Else 0 End,0)),'SAL' From tb_Stock
Where (Id='INV' Or Id='MKR') And LocaCode=@Loca And Status=1 And PDate Between @Date1 And @Date2 And ItemCode In (Select ItemCode From tb_StockMove) Group By ItemCode

Insert Into #tb_TmpMv (ItemCode,Qty,Amount,Iid) Select ItemCode,Isnull(Sum(Case [Id]   When 'TOG' Then -(PackSize*Qty) Else 0 End),0),0,'TOG'  From 
tb_Stock Where  Status=1 And LocaCode=@Loca And PDate <= @Date2 And ItemCode In (Select ItemCode From tb_StockMove) Group By ItemCode

Insert Into #tb_TmpMv (ItemCode,Qty,Amount,Iid) Select ItemCode,Isnull(Sum(Case [Id]   When 'DMG' Then -(PackSize*Qty) 
When 'PRD' Then -(PackSize*Qty) When 'DSC' Then -(PackSize*Qty) When 'ADD' Then (PackSize*Qty) Else 0 End),0),0,'ADJ'  From 
tb_Stock Where  Status=1 And LocaCode=@Loca And PDate <= @Date2 And ItemCode In (Select ItemCode From tb_StockMove) Group By ItemCode



Create Table #tb_TmpMv2 (ItemCode Varchar(25),Loca Char(5),Idx Int ,Iid Char(3))

Truncate table #tb_TmpMv2

Insert Into #tb_TmpMv2 (ItemCode,Loca,Idx,Iid) Select ItemCode,@Loca,Isnull(max(Idx),0),'OPB' From tb_PriceChange 
Where LocaCode=@Loca And (CType='ITC' Or CType='ITU' Or CType='PCH') And CDate < DateAdd(D, 1, @Date1)
And tb_PriceChange.ItemCode In (Select ItemCode From tb_StockMove) Group By ItemCode

Insert Into #tb_TmpMv2 (ItemCode,Loca,Idx,Iid) Select ItemCode,@Loca,Isnull(max(Idx),0),'CLB' From tb_PriceChange 
Where LocaCode=@Loca And (CType='ITC' Or CType='ITU' Or CType='PCH') And CDate < DateAdd(D, 1, @Date2)
And tb_PriceChange.ItemCode In (Select ItemCode From tb_StockMove) Group By ItemCode

Update #tb_TmpMv Set #tb_TmpMv.Amount=#tb_TmpMv.Qty*tb_PriceChange.NewCostPrice From (tb_PriceChange Join #tb_TmpMv2 On tb_PriceChange.ItemCode=#tb_TmpMv2.ItemCode And tb_PriceChange.LocaCode=#tb_TmpMv2.Loca And tb_PriceChange.Idx=#tb_TmpMv2.Idx)
Join #tb_TmpMv On #tb_TmpMv.ItemCode=tb_PriceChange.ItemCode Where #tb_TmpMv.Iid='OPB' And #tb_TmpMv2.Iid='OPB'

Update #tb_TmpMv Set #tb_TmpMv.Amount=#tb_TmpMv.Qty*tb_PriceChange.NewCostPrice From (tb_PriceChange Join #tb_TmpMv2 On tb_PriceChange.ItemCode=#tb_TmpMv2.ItemCode And tb_PriceChange.LocaCode=#tb_TmpMv2.Loca And tb_PriceChange.Idx=#tb_TmpMv2.Idx)
Join #tb_TmpMv On #tb_TmpMv.ItemCode=tb_PriceChange.ItemCode Where #tb_TmpMv.Iid='CLB' And #tb_TmpMv2.Iid='CLB'

Update #tb_TmpMv Set #tb_TmpMv.Amount=#tb_TmpMv.Qty*tb_PriceChange.NewCostPrice From (tb_PriceChange Join #tb_TmpMv2 On tb_PriceChange.ItemCode=#tb_TmpMv2.ItemCode And tb_PriceChange.LocaCode=#tb_TmpMv2.Loca And tb_PriceChange.Idx=#tb_TmpMv2.Idx)
Join #tb_TmpMv On #tb_TmpMv.ItemCode=tb_PriceChange.ItemCode Where #tb_TmpMv.Iid='TOG' And #tb_TmpMv2.Iid='CLB'


Truncate table #tb_TmpMv2
Drop table #tb_TmpMv2

Update tb_StockMove Set tb_StockMove.Qty=#tb_TmpMv.Qty,tb_StockMove.StValue=#tb_TmpMv.Amount From #tb_TmpMv Join tb_StockMove On tb_StockMove.ItemCode=#tb_TmpMv.ItemCode Where #tb_TmpMv.Iid='PCH'
Update tb_StockMove Set tb_StockMove.ClQty=#tb_TmpMv.Qty,tb_StockMove.ClValue=#tb_TmpMv.Amount From #tb_TmpMv Join tb_StockMove On tb_StockMove.ItemCode=#tb_TmpMv.ItemCode Where #tb_TmpMv.Iid='CLB'
Update tb_StockMove Set tb_StockMove.PQty=#tb_TmpMv.Qty,tb_StockMove.PValue=#tb_TmpMv.Amount From #tb_TmpMv Join tb_StockMove On tb_StockMove.ItemCode=#tb_TmpMv.ItemCode Where #tb_TmpMv.Iid='TOG'
Update tb_StockMove Set tb_StockMove.SQty=#tb_TmpMv.Qty,tb_StockMove.SValue=#tb_TmpMv.Amount From #tb_TmpMv Join tb_StockMove On tb_StockMove.ItemCode=#tb_TmpMv.ItemCode Where #tb_TmpMv.Iid='SAL'
Update tb_StockMove Set tb_StockMove.AdjQty=#tb_TmpMv.Qty From #tb_TmpMv Join tb_StockMove On tb_StockMove.ItemCode=#tb_TmpMv.ItemCode Where #tb_TmpMv.Iid='ADJ'

Truncate table #tb_TmpMv
Drop table #tb_TmpMv
GO

