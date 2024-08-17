Insert Into  EasyWayNew.Dbo.tbPosTransact
([ItemCode],[RefCode],[Descrip],[Cost],[Price],[Qty],[Amount],[IDI1],[IDis1],[IDiscount1],[IDI2],[IDis2],[IDiscount2],[IDI3],[IDis3],[IDiscount3],[IDI4],[IDis4],[IDiscount4],[IDI5],[IDis5],[IDiscount5],[Rate]
,[SDStat],[SDNo],[SDID],[SDIs],[SDiscount],[Tax],[Nett],[Loca],[IId],[Receipt],[Salesman],[Cust],[Cashier],[StartTime],[EndTime],[RecDate],[BillType],[Unit],[UnitNo],[RowNo],[CDate],[Status],[PackSize],[ExpDate],[ItemType],[ConFact],[PackScale]
,[UpdateBy],[RecallStat],[SaleType],[RecallNo],[Pcs],[Invoice],[PriceLevel],[InvSerial],[Zno],[Insertdate],[upload])
Select
 [ItemCode],[RefCode],[Descrip],[Cost],[Price],[Qty],[Amount],[IDI1],[IDis1],[IDiscount1],[IDI2],[IDis2],[IDiscount2],[IDI3],[IDis3],[IDiscount3],[IDI4],[IDis4],[IDiscount4],[IDI5],[IDis5],[IDiscount5],[Rate]
,[SDStat],[SDNo],[SDID],[SDIs],[SDiscount],[Tax],[Nett],'33',[IId],[Receipt],[Salesman],[Cust],[Cashier],[StartTime],[EndTime],[recdate],[BillType],[Unit],[UnitNo],[RowNo],[CDate],[Status],[PackSize],[ExpDate],[ItemType],[ConFact],[PackScale]
,[UpdateBy],[RecallStat],[SaleType],[RecallNo],[Pcs],[Invoice],'1',[InvSerial],'1' ,[recdate],'A'
From spos_data.dbo.tbPosTransact  

select * from tbPosTransact where Upload='A'





