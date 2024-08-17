USE [Spos_Data]
GO

/****** Object:  StoredProcedure [dbo].[spDiscountUpdateSubTotProm]    Script Date: 06/09/2023 12:07:06 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[spDiscountUpdateSubTotProm]
@p_Loca 		CHAR(5),
@p_UnitNo 		Char(3),
@p_Receipt 		CHAR(10),
@p_BillType		CHAR(1),
@p_Cashier 		CHAR(15),
@p_ItemCode		CHAR(25),
@p_Descrip 		CHAR(40),
@p_IID  		CHAR(3),
@p_Amount 		FLOAT,
@p_SDId 		INT,
@p_SDPcnt 		CHAR(10),
@p_Discount		FLOAT,
@p_Sman 		CHAR(10),
@p_Cust 		CHAR(15),
@p_PromId		INT,
@p_Loyalty 		CHAR(15),
@p_Floca		Varchar(5),
@p_Table		Varchar(10),
@p_OrderNo		Varchar(15),
@p_OrderBy		Varchar(15),
@p_BirthDay		Varchar(11),
@p_AnivDay		Varchar(11)
AS
Declare @l_RowNo INT
Declare @l_DisNo INT
Declare @l_DiscType CHAR(1)
Declare @l_Error INT
Declare @PromId Int
Declare @IsLoyalty Char(1)

Set @l_RowNo=0
Set @l_DisNo=0
Set @l_DiscType='S'
Set @l_Error=0

SELECT @p_Amount=ISNULL(SUM(Case When Iid='001' Or Iid='003' Then ((Qty*Price)-(IDiscount1 + IDiscount2 + IDiscount3 + IDiscount4 + IDiscount5)+Tax) When Iid='002' Or Iid='004' Then -((Qty*Price)-(IDiscount1 + IDiscount2 + IDiscount3 + IDiscount4 + IDiscount5)+Tax)	When Iid='006' Then -Nett Else 0  End),0)
FROM tbXItem Where Loca= @p_Loca And Receipt=@p_Receipt And UnitNo=@p_UnitNo And SaleType='S' And (RecallStat='F' Or (RecallStat='T' And SDStat='F')) And ItemCode Not In (Select ItemCode From tbItem Where NoDiscount='1')

Create Table #tbTempPromo (PromoId Int,DiscountP Decimal(12,4),Discount Decimal(12,4),PType Int,Loyalty Int)
Truncate Table #tbTempPromo

--Insert Into #tbTempPromo (PromoId,DiscountP,PType,Discount,Loyalty) 
--Select PromId,0,0,0,0 FROM tbXItem Where Loca=@p_Loca And Receipt=@p_Receipt And UnitNo=@p_UnitNo And PromId>0 and PromId not in (select PromId from tbPromotionMaster where PromType in(9,10))

If (Not Exists(Select * From #tbTempPromo) And @p_Amount<>0) --Auto Discount All
Begin
	If (@p_PromId=0) --If User Not Specify Which Promotion To Apply
	Begin
		
		select * into #tempXitem
		from tbxitem where (promid in
		(select PromId from tbpromotionmaster where promid not in (Select PromId from tbPromotionMaster Where Status=1 And 
		Convert(Datetime,Convert(Varchar(11),Getdate(),103),103) Between DateFrom And DateTo
		And Convert(Varchar(5),Getdate(),108) Between TimeFrom And TimeTo And (BillTotal<=@p_Amount) And PromType In (1,2,6,7,8,9,10)
		))or PromId not in(select distinct PromId from tbPromotionMaster)) and PromId<>0
		
		update x
		set Nett=temp.Nett+(
			case when temp.IDI1=6 then temp.IDiscount1
				 when temp.IDI2=6 then temp.IDiscount2
				 when temp.IDI3=6 then temp.IDiscount3
				 when temp.IDI4=6 then temp.IDiscount4
				 when temp.IDI5=6 then temp.IDiscount5
			end
		),
		Rate=temp.Rate+(
			case when temp.IDI1=6 then temp.IDiscount1/temp.Qty
				 when temp.IDI2=6 then temp.IDiscount2/temp.Qty
				 when temp.IDI3=6 then temp.IDiscount3/temp.Qty
				 when temp.IDI4=6 then temp.IDiscount4/temp.Qty
				 when temp.IDI5=6 then temp.IDiscount5/temp.Qty
			end
		)
		,IDI1=case when temp.IDI1=6 then 0 else temp.IDI1 end
		,IDI2=case when temp.IDI2=6 then 0 else temp.IDI2 end
		,IDI3=case when temp.IDI3=6 then 0 else temp.IDI3 end
		,IDI4=case when temp.IDI4=6 then 0 else temp.IDI4 end
		,IDI5=case when temp.IDI5=6 then 0 else temp.IDI5 end
		,IDis1=case when temp.IDI1=6 then '' else temp.IDis1 end
		,IDis2=case when temp.IDI2=6 then '' else temp.IDis2 end
		,IDis3=case when temp.IDI3=6 then '' else temp.IDis3 end
		,IDis4=case when temp.IDI4=6 then '' else temp.IDis4 end
		,IDis5=case when temp.IDI5=6 then '' else temp.IDis5 end
		,IDiscount1=case when temp.IDI1=6 then 0 else temp.IDiscount1 end
		,IDiscount2=case when temp.IDI2=6 then 0 else temp.IDiscount2 end
		,IDiscount3=case when temp.IDI3=6 then 0 else temp.IDiscount3 end
		,IDiscount4=case when temp.IDI4=6 then 0 else temp.IDiscount4 end
		,IDiscount5=case when temp.IDI5=6 then 0 else temp.IDiscount5 end
		,PromId=0
		
		 from tbxitem x 
		 join #tempXitem temp on 
		 x.ItemCode=temp.ItemCode and x.RowNo=temp.RowNo and x.RefCode=temp.RefCode
		 and x.Receipt=temp.Receipt and x.Loca=temp.Loca and x.UnitNo=temp.UnitNo
	
		Truncate Table #tbTempPromo
		Insert Into #tbTempPromo (PromoId,DiscountP,PType,Discount,Loyalty) Select 
		PromId,PromDiscount,PromType,0,OnlyLoyalty from tbPromotionMaster Where Status=1 And 
		Convert(Datetime,Convert(Varchar(11),Getdate(),103),103) Between DateFrom And DateTo
		And Convert(Varchar(5),Getdate(),108) Between TimeFrom And TimeTo And (BillTotal<=@p_Amount or PromType=12) And PromType In (1,2,6,7,8,9,10,12)
		

		If Exists(Select PromId From tbXitem Where Iid In ('001','002','003','004','006') And PromId In 
		(Select PromoId  From #tbTempPromo Where PType=1)) Delete From #tbTempPromo Where PType=1

		Delete From #tbTempPromo Where PromoId In (Select PromId From tbXitem Where Iid In ('001','002','003','004','006') and PromId not in (select PromId from tbPromotionMaster where PromType in(9,10,12)))

		Update #tbTempPromo Set Discount=DiscountP*@p_Amount/100

		---Promotion For Item Level From 1st qty
		Select p.PromId,Sum(Case Iid When '001' Then i.Nett*p.PromDiscount/100 Else -(i.Nett*p.PromDiscount/100) End) As Discount
		Into #Temp from tbXitem i Join tbItemsGet p On p.ItemCode=i.ItemCode Where i.Iid In ('001','002') And i.PromId=0
		And i.Loca=@p_Loca And i.Receipt=@p_Receipt And i.UnitNo=@p_UnitNo
		And p.PromId Not In (Select PromId From tbItemsBuy) And p.PromId In (Select PromoId From #tbTempPromo)
		Group By p.PromId 
	
		Update #tbTempPromo Set #tbTempPromo.Discount=#Temp.Discount From #tbTempPromo Join #Temp On #tbTempPromo.PromoId=#Temp.PromId
		Truncate Table #Temp
		Drop Table #Temp
		--End
		If (@p_Loyalty='') Delete From #tbTempPromo Where Loyalty=1 Or PType In (6,7)

		--If (@p_IsCreditCard=0) Delete From #tbTempPromo Where PType=5

		if (Right(Rtrim(Replace(Convert(Varchar,Getdate(),111),'/','-')),5)<>Right(Rtrim(@p_BirthDay),5) Or Left(@p_BirthDay,4)='1900') Delete From #tbTempPromo Where PType=6

		if (Right(Rtrim(Replace(Convert(Varchar,Getdate(),111),'/','-')),5)<>Right(Rtrim(@p_AnivDay),5) Or Left(@p_AnivDay,4)='1900') Delete From #tbTempPromo Where PType=7

		if Exists(Select Top 1 * From tbXitem Where Iid In ('001','002','003','004','006') And PromId>0)
		Begin
			Delete From #tbTempPromo Where PType Not In (6,7,9,10,12)
		End

		--delete birthday promo if previously given
		if Exists(Select Top 1 * From tbPostransact Where PromId in (select PromId from #tbTempPromo where PType=6) and SDID=6 and Cust=@p_Cust)
		Begin
			Delete From #tbTempPromo Where PType=6
		End
		
		select x.ItemCode,x.RefCode,x.Price,t.PromoId,b.ForOtherGoods,b.TotalPromItemsQty-ISNULL(SUM(case when x.promid=b.PromId then Qty else 0 end),0) RemainingQty into #temp12 
		from tbXitem x 
			join tbItemsBuy b on x.ItemCode=b.ItemCode and (x.PromId=0)-- or x.PromId=b.PromId)
			join #tbTempPromo t on b.PromId=t.PromoId 
			where  x.Iid In ('001','002') And x.SDStat='F'-- and t.PromoId=@PromId
			And x.ItemCode Not In(Select ItemCode From tbItem Where NODiscount=1)
			and Loca=@p_Loca And Receipt=@p_Receipt And UnitNo=@p_UnitNo 
			group by x.ItemCode,x.RefCode,x.Price,b.TotalPromItemsQty,t.PromoId,b.ForOtherGoods
		
		--discount for same item below given qty
		while(exists(select * from #tbTempPromo where PType=12) and exists(select * from #temp12))
		begin
			
			select top 1 @PromId=PromoId from #tbTempPromo where PType=12 order by Loyalty desc
			
				SELECT @p_Amount=ISNULL(SUM(Case When Iid='001' Or Iid='003' Then ((Qty*Price)-(IDiscount1 + IDiscount2 + IDiscount3 + 
				IDiscount4 + IDiscount5)+Tax) When Iid='002' Or Iid='004' Then -((Qty*Price)-(IDiscount1 + IDiscount2 + IDiscount3 + 
				IDiscount4 + IDiscount5)+Tax)	When Iid='006' Then -Nett Else 0  End),0)
				FROM tbXItem Where Loca= @p_Loca And Receipt=@p_Receipt And UnitNo=@p_UnitNo And SaleType='S' And 
				(RecallStat='F' Or (RecallStat='T' And SDStat='F')) 
				And ItemCode Not In (Select ItemCode From tbItem Where NoDiscount='1')
				And ItemCode not in (select ItemCode from #temp12 where ForOtherGoods=1 and PromoId=@PromId)

				if exists(select * from tbPromotionMaster where PromId=@PromId and BillTotal<=@p_Amount)
				begin
					
					IF OBJECT_ID('tempdb.dbo.#promoItemsQty', 'U') IS NOT NULL
						DROP TABLE #promoItemsQty; 
					select x.ItemCode,isnull(sum(Qty),0) existQty,TotalPromItemsQty eligibleQty into #promoItemsQty
					from tbXitem x 
					join tbItemsBuy b on x.ItemCode=b.ItemCode and (x.PromId=0)-- or x.PromId=b.PromId)
					join #tbTempPromo t on b.PromId=t.PromoId
					where x.Iid In ('001') And x.SDStat='F' and t.PromoId=@PromId
					And x.ItemCode Not In(Select ItemCode From tbItem Where NODiscount=1)
					--And x.ItemCode Not In (Select ItemCode From tbItemLoyaltyTmp where PromId=t.PromoId ) 
					and Loca=@p_Loca And Receipt=@p_Receipt And UnitNo=@p_UnitNo 
					group by x.ItemCode,TotalPromItemsQty
					
					IF OBJECT_ID('tempdb.dbo.#promoForEachRow', 'U') IS NOT NULL
						DROP TABLE #promoForEachRow; 
					select x.ItemCode,Qty existQty,0 eligibleQty,RowNo into #promoForEachRow
					from tbXitem x 
					join tbItemsBuy b on x.ItemCode=b.ItemCode and (x.PromId=0)-- or x.PromId=b.PromId)
					join #tbTempPromo t on b.PromId=t.PromoId
					where x.Iid In ('001') And x.SDStat='F' and t.PromoId=@PromId
					And x.ItemCode Not In(Select ItemCode From tbItem Where NODiscount=1)
					--And x.ItemCode Not In (Select ItemCode From tbItemLoyaltyTmp where PromId=t.PromoId ) 
					and Loca=@p_Loca And Receipt=@p_Receipt And UnitNo=@p_UnitNo 
					

					declare @cur_Itemcode varchar(20),@cur_ExistsQty float,@cur_RowNo int

					declare cur cursor for select ItemCode,existQty,RowNo from #promoForEachRow
					open cur
					fetch cur into @cur_Itemcode,@cur_ExistsQty,@cur_RowNo

					while @@FETCH_STATUS=0
					begin
						declare @qtyNeedToAppy float
						declare @qtyNeedToAppyForRow float

						select @qtyNeedToAppy=eligibleQty from #promoItemsQty where ItemCode=@cur_Itemcode

						if(@cur_ExistsQty>@qtyNeedToAppy)
							set @qtyNeedToAppyForRow=@qtyNeedToAppy
						else
							set @qtyNeedToAppyForRow=@cur_ExistsQty

												
						update #promoForEachRow set eligibleQty=@qtyNeedToAppyForRow where RowNo=@cur_RowNo

						update #promoItemsQty set eligibleQty=eligibleQty-@qtyNeedToAppyForRow where ItemCode=@cur_Itemcode
					
						fetch cur into @cur_Itemcode,@cur_ExistsQty,@cur_RowNo
					end
					close cur
					deallocate cur
					

					update x set 
						IDI5 = (case when not(IDI4=0) then 6 else 0 end),
						IDI4 = (case when not(IDI3=0) then 6 else 0 end),
						IDI3 = (case when not(IDI2=0) then 6 else 0 end),
						IDI2 = (case when not(IDI1=0) then 6 else 0 end),
						IDI1 = (case when (IDI1=0) then 6 else IDI1 end),
						IDis5 = (case when (not(IDI4=0) and not(TotalPromItemsValue=0)) then CONVERT(varchar,cast(b.TotalPromItemsValue as float))+'%' else '' end),
						IDis4 = (case when (not(IDI3=0) and not(TotalPromItemsValue=0)) then CONVERT(varchar,cast(b.TotalPromItemsValue as float))+'%' else '' end),
						IDis3 = (case when (not(IDI2=0) and not(TotalPromItemsValue=0)) then CONVERT(varchar,cast(b.TotalPromItemsValue as float))+'%' else '' end),
						IDis2 = (case when (not(IDI1=0) and not(TotalPromItemsValue=0)) then CONVERT(varchar,cast(b.TotalPromItemsValue as float))+'%' else '' end),
						IDis1 = (case when ((IDI1=0) and not(TotalPromItemsValue=0)) then CONVERT(varchar,cast(b.TotalPromItemsValue as float))+'%' else IDis1 end),
						IDiscount5 = (case when not(IDI4=0) then (case when not(TotalPromItemsValue=0) then (case when x.Qty>r.eligibleQty then r.eligibleQty else x.Qty end)*b.TotalPromItemsValue*(x.Rate/100) when not(DisAmount=0) then (case when x.Qty>r.eligibleQty then r.eligibleQty else x.Qty end)*b.DisAmount else 0 end) else 0 end),
						IDiscount4 = (case when not(IDI3=0) then (case when not(TotalPromItemsValue=0) then (case when x.Qty>r.eligibleQty then r.eligibleQty else x.Qty end)*b.TotalPromItemsValue*(x.Rate/100) when not(DisAmount=0) then (case when x.Qty>r.eligibleQty then r.eligibleQty else x.Qty end)*b.DisAmount else 0 end) else 0 end),
						IDiscount3 = (case when not(IDI2=0) then (case when not(TotalPromItemsValue=0) then (case when x.Qty>r.eligibleQty then r.eligibleQty else x.Qty end)*b.TotalPromItemsValue*(x.Rate/100) when not(DisAmount=0) then (case when x.Qty>r.eligibleQty then r.eligibleQty else x.Qty end)*b.DisAmount else 0 end) else 0 end),
						IDiscount2 = (case when not(IDI1=0) then (case when not(TotalPromItemsValue=0) then (case when x.Qty>r.eligibleQty then r.eligibleQty else x.Qty end)*b.TotalPromItemsValue*(x.Rate/100) when not(DisAmount=0) then (case when x.Qty>r.eligibleQty then r.eligibleQty else x.Qty end)*b.DisAmount else 0 end) else 0 end),
						IDiscount1 = (case when (IDI1=0) then (case when not(TotalPromItemsValue=0) then (case when x.Qty>r.eligibleQty then r.eligibleQty else x.Qty end)*b.TotalPromItemsValue*(x.Rate/100) when not(DisAmount=0) then (case when x.Qty>r.eligibleQty then r.eligibleQty else x.Qty end)*b.DisAmount else 0 end) else IDiscount1 end),
						Rate=x.Rate-(case when (b.TotalPromItemsValue>0) then (b.TotalPromItemsValue*x.Rate/100) else b.DisAmount end),
						Nett=x.Nett-(case when (b.TotalPromItemsValue>0) then (b.TotalPromItemsValue*(case when x.Qty>r.eligibleQty then r.eligibleQty else x.Qty end)*x.Rate/100) else (case when x.Qty>r.eligibleQty then r.eligibleQty else x.Qty end)*b.DisAmount end),
						PromId=@PromId
					from tbXitem x 
					join tbItemsBuy b on x.ItemCode=b.ItemCode and (x.PromId=0)-- or x.PromId=b.PromId)
					join #tbTempPromo t on b.PromId=t.PromoId
					join #promoForEachRow r on x.RowNo=r.RowNo
					where x.Iid In ('001') And x.SDStat='F' and t.PromoId=@PromId  and not(r.eligibleQty=0)
					And x.ItemCode Not In(Select ItemCode From tbItem Where NODiscount=1)
					--And x.ItemCode Not In (Select ItemCode From tbItemLoyaltyTmp where PromId=t.PromoId ) 
					and Loca=@p_Loca And Receipt=@p_Receipt And UnitNo=@p_UnitNo 
					


				end

			delete from #tbTempPromo where PromoId=@PromId
		end

		select b.* into #temp10 
		from tbXitem x 
			join tbItemsBuy b on x.ItemCode=b.ItemCode and (x.PromId=0)-- or x.PromId=b.PromId)
			join #tbTempPromo t on b.PromId=t.PromoId 
			where x.Qty>b.PromItemQty and x.Iid In ('001','002') And x.SDStat='F'-- and t.PromoId=@PromId
			And x.ItemCode Not In(Select ItemCode From tbItem Where NODiscount=1)
			and Loca=@p_Loca And Receipt=@p_Receipt And UnitNo=@p_UnitNo 
			
		select x.*,b.TotalPromItemsQty into #tempx10 
		from tbXitem x 
			join tbItemsBuy b on x.ItemCode=b.ItemCode --and (x.PromId=0)-- or x.PromId=b.PromId)
			join #tbTempPromo t on b.PromId=t.PromoId 
			where x.Qty>b.PromItemQty and x.Iid In ('001') And x.SDStat='F'-- and t.PromoId=@PromId
			And x.ItemCode Not In(Select ItemCode From tbItem Where NODiscount=1)
			and Loca=@p_Loca And Receipt=@p_Receipt And UnitNo=@p_UnitNo 
			
		--discount for same item above given qty
		while(exists(select * from #tbTempPromo where PType=10) and exists(select * from #temp10) and exists(select 1 from #tempx10 having sum(qty)>=max(TotalPromItemsQty)))
		begin
			select top 1 @PromId=PromoId from #tbTempPromo where PType=10 order by Loyalty desc

			update x set 
				IDI5 = (case when not(IDI4=0) then 6 else 0 end),
				IDI4 = (case when not(IDI3=0) then 6 else 0 end),
				IDI3 = (case when not(IDI2=0) then 6 else 0 end),
				IDI2 = (case when not(IDI1=0) then 6 else 0 end),
				IDI1 = (case when (IDI1=0) then 6 else IDI1 end),
				IDis5 = (case when (not(IDI4=0) and not(TotalPromItemsValue=0)) then CONVERT(varchar,cast(b.TotalPromItemsValue as float))+'%' else '' end),
				IDis4 = (case when (not(IDI3=0) and not(TotalPromItemsValue=0)) then CONVERT(varchar,cast(b.TotalPromItemsValue as float))+'%' else '' end),
				IDis3 = (case when (not(IDI2=0) and not(TotalPromItemsValue=0)) then CONVERT(varchar,cast(b.TotalPromItemsValue as float))+'%' else '' end),
				IDis2 = (case when (not(IDI1=0) and not(TotalPromItemsValue=0)) then CONVERT(varchar,cast(b.TotalPromItemsValue as float))+'%' else '' end),
				IDis1 = (case when ((IDI1=0) and not(TotalPromItemsValue=0)) then CONVERT(varchar,cast(b.TotalPromItemsValue as float))+'%' else IDis1 end),
				IDiscount5 = (case when not(IDI4=0) then (case when not(TotalPromItemsValue=0) then x.Qty*b.TotalPromItemsValue*(x.Rate/100) when not(DisAmount=0) then x.Qty*b.DisAmount else 0 end) else 0 end),
				IDiscount4 = (case when not(IDI3=0) then (case when not(TotalPromItemsValue=0) then x.Qty*b.TotalPromItemsValue*(x.Rate/100) when not(DisAmount=0) then x.Qty*b.DisAmount else 0 end) else 0 end),
				IDiscount3 = (case when not(IDI2=0) then (case when not(TotalPromItemsValue=0) then x.Qty*b.TotalPromItemsValue*(x.Rate/100) when not(DisAmount=0) then x.Qty*b.DisAmount else 0 end) else 0 end),
				IDiscount2 = (case when not(IDI1=0) then (case when not(TotalPromItemsValue=0) then x.Qty*b.TotalPromItemsValue*(x.Rate/100) when not(DisAmount=0) then x.Qty*b.DisAmount else 0 end) else 0 end),
				IDiscount1 = (case when (IDI1=0) then (case when not(TotalPromItemsValue=0) then x.Qty*b.TotalPromItemsValue*(x.Rate/100) when not(DisAmount=0) then x.Qty*b.DisAmount else 0 end) else IDiscount1 end),
				Rate=x.Rate-(case when (b.TotalPromItemsValue>0) then (b.TotalPromItemsValue*x.Rate/100) else b.DisAmount end),
				Nett=x.Nett-(case when (b.TotalPromItemsValue>0) then (b.TotalPromItemsValue*x.Qty*x.Rate/100) else x.Qty*b.DisAmount end),
				PromId=@PromId
			from tbXitem x 
			join tbItemsBuy b on x.ItemCode=b.ItemCode and (x.PromId=0)-- or x.PromId=b.PromId)
			join #tbTempPromo t on b.PromId=t.PromoId
			where x.Qty>b.PromItemQty and x.Iid In ('001','002') And x.SDStat='F' and t.PromoId=@PromId
			And x.ItemCode Not In(Select ItemCode From tbItem Where NODiscount=1)
			--And x.ItemCode Not In (Select ItemCode From tbItemLoyaltyTmp where PromId=t.PromoId ) 
			and Loca=@p_Loca And Receipt=@p_Receipt And UnitNo=@p_UnitNo 


			
			SELECT @p_Amount=ISNULL(SUM(Case When Iid='001' Or Iid='003' Then ((Qty*Price)-(IDiscount1 + IDiscount2 + IDiscount3 + 
			IDiscount4 + IDiscount5)+Tax) When Iid='002' Or Iid='004' Then -((Qty*Price)-(IDiscount1 + IDiscount2 + IDiscount3 + 
			IDiscount4 + IDiscount5)+Tax)	When Iid='006' Then -Nett Else 0  End),0)
			FROM tbXItem Where Loca= @p_Loca And Receipt=@p_Receipt And UnitNo=@p_UnitNo And SaleType='S' And 
			(RecallStat='F' Or (RecallStat='T' And SDStat='F')) And ItemCode Not In (Select ItemCode From tbItem Where NoDiscount='1')

			delete from #tbTempPromo where PromoId=@PromId
		end

		select b.* into #temp9 from tbXitem x 
			join tbItemsBuy b on x.ItemCode=b.ItemCode and (x.PromId=0 or x.PromId=b.PromId)
			join #tbTempPromo t on b.PromId=t.PromoId 
			where x.IId='001' And x.SDStat='F' --and t.PromoId=@PromId
			And x.ItemCode Not In(Select ItemCode From tbItem Where NODiscount=1)
			and Loca=@p_Loca And Receipt=@p_Receipt And UnitNo=@p_UnitNo 

		--discount for Ax qty on given products
		while(exists(select * from #tbTempPromo where PType=9) and exists(select * from #temp9))
		begin
			select top 1 @PromId=PromoId from #tbTempPromo where PType=9 
			and PromoId in (select buy.PromId from tbItemsBuy buy join tbXitem x on buy.ItemCode=x.ItemCode
			where Loca=@p_Loca And Receipt=@p_Receipt And UnitNo=@p_UnitNo )
			order by Loyalty desc

			declare @discountableQty	decimal(12,4)=0
			declare @Qty				decimal(12,4)=0
			declare @remainToGiveQty	decimal(12,4)=0
			declare @discount			decimal(12,4)=0
			declare @itemcode			varchar(30)
			declare @Rate				float
			declare @Nett				float
			declare @qtyBundle			decimal(12,4)
			declare @rowNo				int
			
			select @discountableQty=ISNULL(SUM(
				case 
					when x.PromId=@PromId then
						case 
							when x.IDI1=6 then x.Qty-(x.IDiscount1/b.TotalPromItemsValue)
							when x.IDI2=6 then x.Qty-(x.IDiscount2/b.TotalPromItemsValue)
							when x.IDI3=6 then x.Qty-(x.IDiscount3/b.TotalPromItemsValue)
							when x.IDI4=6 then x.Qty-(x.IDiscount4/b.TotalPromItemsValue)
							when x.IDI5=6 then x.Qty-(x.IDiscount5/b.TotalPromItemsValue)
						end
					when x.PromId=0 then x.Qty
				end
			),0),
			@qtyBundle=max(b.TotalPromItemsQty)
			from tbXitem x 
			join tbItemsBuy b on x.ItemCode=b.ItemCode and (x.PromId=0 or x.PromId=b.PromId)
			join #tbTempPromo t on b.PromId=t.PromoId 
			where x.IId='001' And x.SDStat='F' and t.PromoId=@PromId
			And x.ItemCode Not In(Select ItemCode From tbItem Where NODiscount=1)
			and Loca=@p_Loca And Receipt=@p_Receipt And UnitNo=@p_UnitNo 
			
			set @remainToGiveQty=@discountableQty-(@discountableQty%@qtyBundle)

			while @discountableQty>=@qtyBundle and @remainToGiveQty>0
			begin
				
				select top 1 @Qty=(
						case 
							when x.PromId=@PromId then
								case 
									when x.IDI1=6 then x.Qty-(x.IDiscount1/b.TotalPromItemsValue)
									when x.IDI2=6 then x.Qty-(x.IDiscount2/b.TotalPromItemsValue)
									when x.IDI3=6 then x.Qty-(x.IDiscount3/b.TotalPromItemsValue)
									when x.IDI4=6 then x.Qty-(x.IDiscount4/b.TotalPromItemsValue)
									when x.IDI5=6 then x.Qty-(x.IDiscount5/b.TotalPromItemsValue)
								end
							when x.PromId=0 then x.Qty
						end
					), @itemcode=x.ItemCode,@discount=b.TotalPromItemsValue,@rowNo=x.RowNo
				
				from tbXitem x 
				join tbItemsBuy b on x.ItemCode=b.ItemCode and (x.PromId=0 or x.PromId=b.PromId)
				join #tbTempPromo t on b.PromId=t.PromoId 
				where x.IId='001' And x.SDStat='F' and t.PromoId=@PromId
				And x.ItemCode Not In(Select ItemCode From tbItem Where NODiscount=1)
				and Loca=@p_Loca And Receipt=@p_Receipt And UnitNo=@p_UnitNo 
				and (ISNULL(
					case 
						when x.PromId=@PromId then
							case 
								when x.IDI1=6 then x.Qty-(x.IDiscount1/b.TotalPromItemsValue)
								when x.IDI2=6 then x.Qty-(x.IDiscount2/b.TotalPromItemsValue)
								when x.IDI3=6 then x.Qty-(x.IDiscount3/b.TotalPromItemsValue)
								when x.IDI4=6 then x.Qty-(x.IDiscount4/b.TotalPromItemsValue)
								when x.IDI5=6 then x.Qty-(x.IDiscount5/b.TotalPromItemsValue)
							end
						when x.PromId=0 then x.Qty
					end,0))>0
				order by Qty

				if(@remainToGiveQty<@Qty) set @Qty=@remainToGiveQty
					
				select @p_Discount=@Qty*@discount,@Rate=(price-@discount) from tbXitem where ItemCode=@ItemCode and RowNo=@rowNo and Loca=@p_Loca And Receipt=@p_Receipt And UnitNo=@p_UnitNo and iid='001'
				select @Nett=(Nett-@p_Discount) from tbXitem where ItemCode=@ItemCode and RowNo=@rowNo and Loca=@p_Loca And Receipt=@p_Receipt And UnitNo=@p_UnitNo and iid='001'
							
				IF (EXISTS (SELECT * FROM tbXItem WHERE Loca=@p_Loca And Receipt=@p_Receipt And UnitNo=@p_UnitNo And ItemCode=@ItemCode and RowNo=@rowNo And SDStat='F' And (IDI1=6 or IDI1=0) )) 
					Begin
					Update tbXItem Set IDI1=6,IDiscount1=IDiscount1+@p_Discount,Rate=@Rate,Nett=@Nett,PromId=@PromId
					WHERE Loca=@p_Loca And Receipt=@p_Receipt And UnitNo=@p_UnitNo And ItemCode=@ItemCode and RowNo=@rowNo And SDStat='F' 
					If @@Error <> 0  Set @l_Error=@@Error
					End
				ELSE IF (EXISTS (SELECT * FROM tbXItem WHERE Loca=@p_Loca And Receipt=@p_Receipt And UnitNo=@p_UnitNo And ItemCode=@ItemCode and RowNo=@rowNo And SDStat='F' And (IDI2=6 or IDI2=0) )) 
					Begin
					Update tbXItem Set IDI2=6,IDiscount2=IDiscount2+@p_Discount,Rate=@Rate,Nett=@Nett,PromId=@PromId
					WHERE Loca=@p_Loca And Receipt=@p_Receipt And UnitNo=@p_UnitNo And ItemCode=@ItemCode and RowNo=@rowNo And SDStat='F'
					If @@Error <> 0  Set @l_Error=@@Error
					End
				ELSE IF (EXISTS (SELECT * FROM tbXItem WHERE Loca=@p_Loca And Receipt=@p_Receipt And UnitNo=@p_UnitNo And ItemCode=@ItemCode and RowNo=@rowNo And SDStat='F' And (IDI3=6 or IDI3=0) )) 
					Begin
					Update tbXItem Set IDI3=6,IDiscount3=IDiscount3+@p_Discount,Rate=@Rate,Nett=@Nett,PromId=@PromId
					WHERE Loca=@p_Loca And Receipt=@p_Receipt And UnitNo=@p_UnitNo And ItemCode=@ItemCode and RowNo=@rowNo And SDStat='F'
					If @@Error <> 0  Set @l_Error=@@Error
					End
				ELSE IF (EXISTS (SELECT * FROM tbXItem WHERE Loca=@p_Loca And Receipt=@p_Receipt And UnitNo=@p_UnitNo And ItemCode=@ItemCode and RowNo=@rowNo And SDStat='F' And (IDI4=6 or IDI4=0) )) 
					Begin
					Update tbXItem Set IDI4=6,IDiscount4=IDiscount4+@p_Discount,Rate=@Rate,Nett=@Nett,PromId=@PromId
					WHERE Loca=@p_Loca And Receipt=@p_Receipt And UnitNo=@p_UnitNo And ItemCode=@ItemCode and RowNo=@rowNo And SDStat='F'
					If @@Error <> 0  Set @l_Error=@@Error
					End
				ELSE IF (EXISTS (SELECT * FROM tbXItem WHERE Loca=@p_Loca And Receipt=@p_Receipt And UnitNo=@p_UnitNo And ItemCode=@ItemCode and RowNo=@rowNo And SDStat='F' And (IDI5=6 or IDI5=0) )) 
					BEgin
					Update tbXItem Set IDI5=6,IDiscount5=IDiscount5+@p_Discount,Rate=@Rate,Nett=@Nett,PromId=@PromId
					WHERE Loca=@p_Loca And Receipt=@p_Receipt And UnitNo=@p_UnitNo And ItemCode=@ItemCode and RowNo=@rowNo And SDStat='F'
					If @@Error <> 0  Set @l_Error=@@Error
					End


				set @remainToGiveQty=@remainToGiveQty-@Qty
				
				SELECT @p_Amount=ISNULL(SUM(Case When Iid='001' Or Iid='003' Then ((Qty*Price)-(IDiscount1 + IDiscount2 + IDiscount3 + 
				IDiscount4 + IDiscount5)+Tax) When Iid='002' Or Iid='004' Then -((Qty*Price)-(IDiscount1 + IDiscount2 + IDiscount3 + 
				IDiscount4 + IDiscount5)+Tax)	When Iid='006' Then -Nett Else 0  End),0)
				FROM tbXItem Where Loca= @p_Loca And Receipt=@p_Receipt And UnitNo=@p_UnitNo And SaleType='S' And 
				(RecallStat='F' Or (RecallStat='T' And SDStat='F')) And ItemCode Not In (Select ItemCode From tbItem Where NoDiscount='1')
			end
			delete from #tbTempPromo where PromoId=@PromId
		end

		--Update Item Wise Promotion Discount
		--If (Exists(Select * From #tbTempPromo Where PType=2))
		--Begin
		--	Select Top 1 @PromId=PromoId,@p_Discount=DiscountP,@IsLoyalty=Isnull(Loyalty,'0') from #tbTempPromo Where PType=2 
		--	Order By Discount Desc
		--	Update i Set i.IDi1=6,i.IDis1=p.PromDiscount,i.IDiscount1=i.Amount*p.PromDiscount/100,
		--	i.Nett=i.Amount-(i.Amount*p.PromDiscount/100) from tbXitem i Join tbItemsGet p On p.ItemCode=i.ItemCode 
		--	Where i.Iid In ('001','002') And i.PromId=0
		--	And i.Loca=@p_Loca And i.Receipt=@p_Receipt And i.UnitNo=@p_UnitNo
		--	And p.PromId =@PromId

		--	SELECT @p_Amount=ISNULL(SUM(Case When Iid='001' Or Iid='003' Then ((Qty*Price)-(IDiscount1 + IDiscount2 + IDiscount3 + 
		--	IDiscount4 + IDiscount5)+Tax) When Iid='002' Or Iid='004' Then -((Qty*Price)-(IDiscount1 + IDiscount2 + IDiscount3 + 
		--	IDiscount4 + IDiscount5)+Tax)	When Iid='006' Then -Nett Else 0  End),0)
		--	FROM tbXItem Where Loca= @p_Loca And Receipt=@p_Receipt And UnitNo=@p_UnitNo And SaleType='S' And 
		--	(RecallStat='F' Or (RecallStat='T' And SDStat='F')) And ItemCode Not In (Select ItemCode From tbItem Where NoDiscount='1')

		--End			

		--Update Wedding Aniversary Discount
		If (Exists(Select * From #tbTempPromo Where PType=7))
		Begin
			Select Top 1 @PromId=PromoId,@p_Discount=DiscountP,@IsLoyalty=Isnull(Loyalty,'0') from #tbTempPromo Where PType=7 
			Order By Discount Desc
			Set @p_SDId=6
			Set @p_SDPcnt=Rtrim(Convert(Varchar(10),@p_Discount))+'%'
			Set @p_Discount=@p_Discount/100*@p_Amount			
			Set @p_Descrip='ANIVERSARY WISHES' + ' ' + Rtrim(@p_SDPcnt)
			Select @l_RowNo=ISNULL(MAX(RowNo)+1,1) FROM tbXItem Where Loca=@p_Loca And Receipt=@p_Receipt And UnitNo=@p_UnitNo

			
			Select @l_DisNo=ISNULL(MAX(SDNo)+1,1)  FROM tbXItem Where Loca=@p_Loca And Receipt=@p_Receipt And UnitNo=@p_UnitNo

			
			IF (EXISTS(SELECT * FROM tbXItem WHERE Receipt=@p_Receipt And Loca=@p_Loca And UnitNo=@p_UnitNo And SaleType='G' 
			And (Iid='001' Or Iid='002' Or Iid='003' Or Iid='004' Or Iid='006'))) SET @l_DiscType='G'

			
			INSERT INTO tbXItem(ItemCode,  RefCode,  Descrip,  Cost,  Price,  Qty,  Amount,  IDI1,  IDis1,
				IDiscount1,  IDI2,  IDis2,  IDiscount2,  IDI3,  IDis3,  IDiscount3,  IDI4,
				IDis4,  IDiscount4,  IDI5,  IDis5,  IDiscount5,  Rate,  SDStat,  SDNo,
				SDID,  SDIs,  SDiscount,  Tax,  Nett,  Loca,  IId,  Receipt,  Salesman,
				Cust,  Cashier,  StartTime,EndTime,  RecDate,  BillType,  Unit,  UnitNo,RowNo,
				RecallStat,SaleType,RecallNo,PromId,FLoca,TableNo,TerminalNo,OrderNo,OrderBy)
				VALUES (	@p_ItemCode,'',@p_Descrip,0,0,1,@p_Amount,0,'',0
				,0,'',0,0,'',0,0,'',0,0,'',0,@p_Discount,'F',@l_DisNo,@p_SDId,@p_SDPcnt,@p_Discount,0,@p_Discount,@p_Loca
				,@p_IID,@p_Receipt,@p_Sman ,@p_Cust,@p_Cashier,Getdate(),Getdate(),GetDate(),@p_BillType,'NOS',@p_UnitNo,@l_RowNo,
				'F',@l_DiscType,'',@PromId,@p_Floca,@p_Table,@p_UnitNo,@p_OrderNo,@p_OrderBy)

			UPDATE tbXItem Set SDiscount=(SDiscount+((Nett-SDiscount)*(@p_Discount/@p_Amount))) Where Loca=@p_Loca And 
			Receipt=@p_Receipt And UnitNo=@p_UnitNo And RecallStat='F' And (Iid='001' or Iid='002' Or Iid='003' Or Iid='004')
			And ItemCode Not In(Select ItemCode From tbItem Where NODiscount=1)

			UPDATE tbXItem Set SDStat=CASE WHEN SDStat='F' THEN 'T' ELSE '*' END Where Loca=@p_Loca And Receipt=@p_Receipt And 
			UnitNo=@p_UnitNo And RecallStat='F'
			Set @p_Amount=@p_Amount- @p_Discount
		End			
		
		--Update Birthday Discount
		If (Exists(Select * From #tbTempPromo Where PType=6))
		Begin
			Select Top 1 @PromId=PromoId,@p_Discount=DiscountP,@IsLoyalty=Isnull(Loyalty,'0') from #tbTempPromo Where PType=6 
			Order By Discount Desc
			Set @p_SDId=6
			Set @p_SDPcnt=Rtrim(Convert(Varchar(10),@p_Discount))+'%'
			Set @p_Discount=@p_Discount/100*@p_Amount
			
			Set @p_Descrip='BIRTH DAY WISHES' + ' ' + Rtrim(@p_SDPcnt)

			Select @l_RowNo=ISNULL(MAX(RowNo)+1,1) FROM tbXItem Where Loca=@p_Loca And Receipt=@p_Receipt And UnitNo=@p_UnitNo

			
			Select @l_DisNo=ISNULL(MAX(SDNo)+1,1)  FROM tbXItem Where Loca=@p_Loca And Receipt=@p_Receipt And UnitNo=@p_UnitNo

			
			IF (EXISTS(SELECT * FROM tbXItem WHERE Receipt=@p_Receipt And Loca=@p_Loca And UnitNo=@p_UnitNo And SaleType='G' 
			And (Iid='001' Or Iid='002' Or Iid='003' Or Iid='004' Or Iid='006'))) SET @l_DiscType='G'

			
			INSERT INTO tbXItem(ItemCode,  RefCode,  Descrip,  Cost,  Price,  Qty,  Amount,  IDI1,  IDis1,
				IDiscount1,  IDI2,  IDis2,  IDiscount2,  IDI3,  IDis3,  IDiscount3,  IDI4,
				IDis4,  IDiscount4,  IDI5,  IDis5,  IDiscount5,  Rate,  SDStat,  SDNo,
				SDID,  SDIs,  SDiscount,  Tax,  Nett,  Loca,  IId,  Receipt,  Salesman,
				Cust,  Cashier,  StartTime,EndTime,  RecDate,  BillType,  Unit,  UnitNo,RowNo,
				RecallStat,SaleType,RecallNo,PromId,FLoca,TableNo,TerminalNo,OrderNo,OrderBy)
				VALUES (	@p_ItemCode,'',@p_Descrip,0,0,1,@p_Amount,0,'',0
				,0,'',0,0,'',0,0,'',0,0,'',0,@p_Discount,'F',@l_DisNo,@p_SDId,@p_SDPcnt,@p_Discount,0,@p_Discount,@p_Loca
				,@p_IID,@p_Receipt,@p_Sman ,@p_Cust,@p_Cashier,Getdate(),Getdate(),GetDate(),@p_BillType,'NOS',@p_UnitNo,@l_RowNo,
				'F',@l_DiscType,'',@PromId,@p_Floca,@p_Table,@p_UnitNo,@p_OrderNo,@p_OrderBy)
			If @@Error <> 0  Set @l_Error=@@Error
			UPDATE tbXItem Set SDiscount=(SDiscount+((Nett-SDiscount)*(@p_Discount/@p_Amount))) Where Loca=@p_Loca And 
			Receipt=@p_Receipt And UnitNo=@p_UnitNo And RecallStat='F' And (Iid='001' or Iid='002' Or Iid='003' Or Iid='004')
			And ItemCode Not In(Select ItemCode From tbItem Where NODiscount=1)

			UPDATE tbXItem Set SDStat=CASE WHEN SDStat='F' THEN 'T' ELSE '*' END Where Loca=@p_Loca And Receipt=@p_Receipt 
			And UnitNo=@p_UnitNo And RecallStat='F'
			Set @p_Amount=@p_Amount- @p_Discount
		End
		
		--Sub Totoal Discount For If Purchase Items Form Given Collection
		If (Exists(Select * From #tbTempPromo Where PType=8 ))
		Begin
			Declare @ItemCount Int=0
			Declare @BillCount Int=0
			 
			Select Top 1 @PromId=PromoId,@p_Discount=DiscountP,@IsLoyalty=Isnull(Loyalty,'0') from #tbTempPromo Where 
			PType=8 Order By Discount Desc
			
			Select @ItemCount=Isnull(Max(TotalPromItemsQty),0) From tbItemsBuy Where PromId=@PromId
			Select @BillCount= Isnull(Count(Distinct ItemCode) ,0) FROM tbXItem Where Loca=@p_Loca And Receipt=@p_Receipt And UnitNo=@p_UnitNo
			And Iid ='001' And Qty>0 And ItemCode In (Select ItemCode From tbItemsBuy Where PromId=@PromId)
			If  (@BillCount>=@ItemCount)
			Begin
				Set @p_SDId=6
				Set @p_SDPcnt=Rtrim(Convert(Varchar(10),@p_Discount))+'%'
				Set @p_Discount=@p_Discount/100*@p_Amount
				
				Select @p_Descrip=Rtrim(Descrip) + ' ' + Rtrim(@p_SDPcnt)  From tbDiscountType Where Did=@p_SDId

				Select @l_RowNo=ISNULL(MAX(RowNo)+1,1) FROM tbXItem Where Loca=@p_Loca And Receipt=@p_Receipt And UnitNo=@p_UnitNo

				Select @l_DisNo=ISNULL(MAX(SDNo)+1,1)  FROM tbXItem Where Loca=@p_Loca And Receipt=@p_Receipt And UnitNo=@p_UnitNo

				IF (EXISTS(SELECT * FROM tbXItem WHERE Receipt=@p_Receipt And Loca=@p_Loca And UnitNo=@p_UnitNo And SaleType='G' 
				And (Iid='001' Or Iid='002' Or Iid='003' Or Iid='004' Or Iid='006'))) SET @l_DiscType='G'

				INSERT INTO tbXItem(ItemCode,  RefCode,  Descrip,  Cost,  Price,  Qty,  Amount,  IDI1,  IDis1,
					IDiscount1,  IDI2,  IDis2,  IDiscount2,  IDI3,  IDis3,  IDiscount3,  IDI4,
					IDis4,  IDiscount4,  IDI5,  IDis5,  IDiscount5,  Rate,  SDStat,  SDNo,
					SDID,  SDIs,  SDiscount,  Tax,  Nett,  Loca,  IId,  Receipt,  Salesman,
					Cust,  Cashier,  StartTime,EndTime,  RecDate,  BillType,  Unit,  UnitNo,RowNo,
					RecallStat,SaleType,RecallNo,PromId,FLoca,TableNo,TerminalNo,OrderNo,OrderBy)
					VALUES (	@p_ItemCode,'',@p_Descrip,0,0,1,@p_Amount,0,'',0
					,0,'',0,0,'',0,0,'',0,0,'',0,@p_Discount,'F',@l_DisNo,@p_SDId,@p_SDPcnt,@p_Discount,0,@p_Discount,@p_Loca
					,@p_IID,@p_Receipt,@p_Sman ,@p_Cust,@p_Cashier,Getdate(),Getdate(),GetDate(),@p_BillType,'NOS',@p_UnitNo,@l_RowNo,
					'F',@l_DiscType,'',@PromId,@p_Floca,@p_Table,@p_UnitNo,@p_OrderNo,@p_OrderBy)

				UPDATE tbXItem Set SDiscount=(SDiscount+((Nett-SDiscount)*(@p_Discount/@p_Amount))) Where Loca=@p_Loca And 
				Receipt=@p_Receipt And UnitNo=@p_UnitNo And RecallStat='F' And (Iid='001' or Iid='002' Or Iid='003' Or Iid='004')
				And ItemCode Not In(Select ItemCode From tbItem Where NODiscount=1)

				UPDATE tbXItem Set SDStat=CASE WHEN SDStat='F' THEN 'T' ELSE '*' END Where Loca=@p_Loca And Receipt=@p_Receipt 
				And UnitNo=@p_UnitNo And RecallStat='F'

				Set @p_Amount=@p_Amount- @p_Discount
			End
		End

		--Sub Totoal Discount Promotion
		If (Exists(Select * From #tbTempPromo Where PType=1))
		Begin
			Select Top 1 @PromId=PromoId,@p_Discount=DiscountP,@IsLoyalty=Isnull(Loyalty,'0') from #tbTempPromo Where 
			(PType=1 Or PType=5) Order By Discount Desc
			
			Set @p_SDId=6
			Set @p_SDPcnt=Rtrim(Convert(Varchar(10),@p_Discount))+'%'
			Set @p_Discount=@p_Discount/100*@p_Amount
			
			Select @p_Descrip=Rtrim(Descrip) + ' ' + Rtrim(@p_SDPcnt)  From tbDiscountType Where Did=@p_SDId

			Select @l_RowNo=ISNULL(MAX(RowNo)+1,1) FROM tbXItem Where Loca=@p_Loca And Receipt=@p_Receipt And UnitNo=@p_UnitNo

			Select @l_DisNo=ISNULL(MAX(SDNo)+1,1)  FROM tbXItem Where Loca=@p_Loca And Receipt=@p_Receipt And UnitNo=@p_UnitNo

			IF (EXISTS(SELECT * FROM tbXItem WHERE Receipt=@p_Receipt And Loca=@p_Loca And UnitNo=@p_UnitNo And SaleType='G' 
			And (Iid='001' Or Iid='002' Or Iid='003' Or Iid='004' Or Iid='006'))) SET @l_DiscType='G'

			INSERT INTO tbXItem(ItemCode,  RefCode,  Descrip,  Cost,  Price,  Qty,  Amount,  IDI1,  IDis1,
				IDiscount1,  IDI2,  IDis2,  IDiscount2,  IDI3,  IDis3,  IDiscount3,  IDI4,
				IDis4,  IDiscount4,  IDI5,  IDis5,  IDiscount5,  Rate,  SDStat,  SDNo,
				SDID,  SDIs,  SDiscount,  Tax,  Nett,  Loca,  IId,  Receipt,  Salesman,
				Cust,  Cashier,  StartTime,EndTime,  RecDate,  BillType,  Unit,  UnitNo,RowNo,
				RecallStat,SaleType,RecallNo,PromId,FLoca,TableNo,TerminalNo,OrderNo,OrderBy)
				VALUES (	@p_ItemCode,'',@p_Descrip,0,0,1,@p_Amount,0,'',0
				,0,'',0,0,'',0,0,'',0,0,'',0,@p_Discount,'F',@l_DisNo,@p_SDId,@p_SDPcnt,@p_Discount,0,@p_Discount,@p_Loca
				,@p_IID,@p_Receipt,@p_Sman ,@p_Cust,@p_Cashier,Getdate(),Getdate(),GetDate(),@p_BillType,'NOS',@p_UnitNo,@l_RowNo,
				'F',@l_DiscType,'',@PromId,@p_Floca,@p_Table,@p_UnitNo,@p_OrderNo,@p_OrderBy)

			UPDATE tbXItem Set SDiscount=(SDiscount+((Nett-SDiscount)*(@p_Discount/@p_Amount))) Where Loca=@p_Loca And 
			Receipt=@p_Receipt And UnitNo=@p_UnitNo And RecallStat='F' And (Iid='001' or Iid='002' Or Iid='003' Or Iid='004')
			And ItemCode Not In(Select ItemCode From tbItem Where NODiscount=1)

			UPDATE tbXItem Set SDStat=CASE WHEN SDStat='F' THEN 'T' ELSE '*' END Where Loca=@p_Loca And Receipt=@p_Receipt 
			And UnitNo=@p_UnitNo And RecallStat='F'

			Set @p_Amount=@p_Amount- @p_Discount
		End
		Truncate Table #tbTempPromo		
	End
	Else --Credit Card Promotion
	Begin
		if (@p_Discount>0)
		Begin 
			Select * from tbPromotionMaster Where PromId=@p_PromId
			Select @IsLoyalty=Isnull(OnlyLoyalty,0) from tbPromotionMaster Where PromId=@p_PromId
			If Not (@IsLoyalty=1 And @p_Loyalty='')
			Begin
				Select @IsLoyalty,@p_Loyalty,@p_PromId
				SELECT @p_Amount=ISNULL(SUM(Case When Iid='001' Or Iid='003' Then ((Qty*Price)-(IDiscount1 + IDiscount2 + 
				IDiscount3 + IDiscount4 + IDiscount5)+Tax) When Iid='002' Or Iid='004' Then -((Qty*Price)-(IDiscount1 + 
				IDiscount2 + IDiscount3 + IDiscount4 + IDiscount5)+Tax)	When Iid='006' Then -Nett Else 0  End),0)
				FROM tbXItem Where Loca= @p_Loca And Receipt=@p_Receipt And UnitNo=@p_UnitNo And (SaleType='S' or SaleType='G')
				-- And (RecallStat='F' Or (RecallStat='T' And SDStat='F')) And ItemCode Not In (Select ItemCode From tbItem Where NoDiscount='1')

				Set @PromId=@p_PromId		
				Set @p_SDId=3
				Set @p_SDPcnt=Rtrim(Convert(Varchar(10),@p_Discount))+'%'
				Set @p_Discount=@p_Discount/100*@p_Amount
				Select @p_Descrip=Rtrim(Descrip) + ' ' + Rtrim(@p_SDPcnt)  From tbDiscountType Where Did=@p_SDId

				Select @l_RowNo=ISNULL(MAX(RowNo)+1,1) FROM tbXItem Where Loca=@p_Loca And Receipt=@p_Receipt And UnitNo=@p_UnitNo

				Select @l_DisNo=ISNULL(MAX(SDNo)+1,1)  FROM tbXItem Where Loca=@p_Loca And Receipt=@p_Receipt And UnitNo=@p_UnitNo

				IF (EXISTS(SELECT * FROM tbXItem WHERE Receipt=@p_Receipt And Loca=@p_Loca And UnitNo=@p_UnitNo And SaleType='G' 
				And (Iid='001' Or Iid='002' Or Iid='003' Or Iid='004' Or Iid='006'))) SET @l_DiscType='G'

				INSERT INTO tbXItem(ItemCode,  RefCode,  Descrip,  Cost,  Price,  Qty,  Amount,  IDI1,  IDis1,
					IDiscount1,  IDI2,  IDis2,  IDiscount2,  IDI3,  IDis3,  IDiscount3,  IDI4,
					IDis4,  IDiscount4,  IDI5,  IDis5,  IDiscount5,  Rate,  SDStat,  SDNo,
					SDID,  SDIs,  SDiscount,  Tax,  Nett,  Loca,  IId,  Receipt,  Salesman,
					Cust,  Cashier,  StartTime,EndTime,  RecDate,  BillType,  Unit,  UnitNo,RowNo,
					RecallStat,SaleType,RecallNo,PromId,FLoca,TableNo,TerminalNo,OrderNo,OrderBy)
					VALUES (	@p_ItemCode,'',@p_Descrip,0,0,1,@p_Amount,0,'',0
					,0,'',0,0,'',0,0,'',0,0,'',0,@p_Discount,'F',@l_DisNo,@p_SDId,@p_SDPcnt,@p_Discount,0,@p_Discount,@p_Loca
					,@p_IID,@p_Receipt,@p_Sman ,@p_Cust,@p_Cashier,Getdate(),Getdate(),GetDate(),@p_BillType,'NOS',@p_UnitNo,@l_RowNo,
					'F',@l_DiscType,'',@PromId,@p_Floca,@p_Table,@p_UnitNo,@p_OrderNo,@p_OrderBy)

				UPDATE tbXItem Set SDiscount=(SDiscount+((Nett-SDiscount)*(@p_Discount/@p_Amount))) 
				Where Loca=@p_Loca And Receipt=@p_Receipt And UnitNo=@p_UnitNo And RecallStat='F' And 
				(Iid='001' or Iid='002' Or Iid='003' Or Iid='004') --And BillType=@p_BillType 
				And ItemCode Not In(Select ItemCode From tbItem Where NODiscount=1)

				UPDATE tbXItem Set SDStat=CASE WHEN SDStat='F' THEN 'T' ELSE '*' END Where Loca=@p_Loca And Receipt=@p_Receipt 
				And UnitNo=@p_UnitNo And RecallStat='F' --And ItemCode Not In(Select ItemCode From tbItem Where NODiscount=1)
			End
		End
	End
End
Else If (Exists(Select * From #tbTempPromo) And @p_Amount<>0) --Only Birthday & Aniversary Discount
Begin	
	Truncate Table #tbTempPromo
	Insert Into #tbTempPromo (PromoId,DiscountP,PType,Discount,Loyalty) Select 
	PromId,PromDiscount,PromType,0,OnlyLoyalty from tbPromotionMaster Where Status=1 And 
	Convert(Datetime,Convert(Varchar(11),Getdate(),103),103) Between DateFrom And DateTo
	And Convert(Varchar(5),Getdate(),108) Between TimeFrom And TimeTo And BillTotal<=@p_Amount And PromType In (6,7)

	Delete From #tbTempPromo Where PromoId In (Select PromId From tbXitem Where Iid In ('001','002','003','004','006'))

	Update #tbTempPromo Set Discount=DiscountP*@p_Amount/100
	If (@p_Loyalty='') Delete From #tbTempPromo Where Loyalty=1 Or PType In (6,7)
	if (Right(Rtrim(Replace(Convert(Varchar,Getdate(),111),'/','-')),5)<>Right(Rtrim(@p_BirthDay),5) Or Left(@p_BirthDay,4)='1900') Delete From #tbTempPromo Where PType=6

	if (Right(Rtrim(Replace(Convert(Varchar,Getdate(),111),'/','-')),5)<>Right(Rtrim(@p_AnivDay),5) Or Left(@p_AnivDay,4)='1900') Delete From #tbTempPromo Where PType=7
	
	--delete birthday promo if previously given
	if Exists(Select Top 1 * From tbPostransact Where PromId in (select PromId from #tbTempPromo where PType=6) and SDID=6 and Cust=@p_Cust)
	Begin
		Delete From #tbTempPromo Where PType =6
	End

	--Update Wedding Aniversary Discount
	If (Exists(Select * From #tbTempPromo Where PType=7))
	Begin
		Select Top 1 @PromId=PromoId,@p_Discount=DiscountP,@IsLoyalty=Isnull(Loyalty,'0') from #tbTempPromo Where PType=7 Order By Discount Desc
		Set @p_SDId=6
		Set @p_SDPcnt=Rtrim(Convert(Varchar(10),@p_Discount))+'%'
		Set @p_Discount=@p_Discount/100*@p_Amount			
		Set @p_Descrip='ANIVERSARY WISHES' + ' ' + Rtrim(@p_SDPcnt)
		Select @l_RowNo=ISNULL(MAX(RowNo)+1,1) FROM tbXItem Where Loca=@p_Loca And Receipt=@p_Receipt And UnitNo=@p_UnitNo

		
		Select @l_DisNo=ISNULL(MAX(SDNo)+1,1)  FROM tbXItem Where Loca=@p_Loca And Receipt=@p_Receipt And UnitNo=@p_UnitNo

		
		IF (EXISTS(SELECT * FROM tbXItem WHERE Receipt=@p_Receipt And Loca=@p_Loca And UnitNo=@p_UnitNo And SaleType='G' And (Iid='001' Or Iid='002' Or Iid='003' Or Iid='004' Or Iid='006'))) SET @l_DiscType='G'

		
		INSERT INTO tbXItem(ItemCode,  RefCode,  Descrip,  Cost,  Price,  Qty,  Amount,  IDI1,  IDis1,
			IDiscount1,  IDI2,  IDis2,  IDiscount2,  IDI3,  IDis3,  IDiscount3,  IDI4,
			IDis4,  IDiscount4,  IDI5,  IDis5,  IDiscount5,  Rate,  SDStat,  SDNo,
			SDID,  SDIs,  SDiscount,  Tax,  Nett,  Loca,  IId,  Receipt,  Salesman,
			Cust,  Cashier,  StartTime,EndTime,  RecDate,  BillType,  Unit,  UnitNo,RowNo,
			RecallStat,SaleType,RecallNo,PromId,FLoca,TableNo,TerminalNo,OrderNo,OrderBy)
			VALUES (	@p_ItemCode,'',@p_Descrip,0,0,1,@p_Amount,0,'',0
			,0,'',0,0,'',0,0,'',0,0,'',0,@p_Discount,'F',@l_DisNo,@p_SDId,@p_SDPcnt,@p_Discount,0,@p_Discount,@p_Loca
			,@p_IID,@p_Receipt,@p_Sman ,@p_Cust,@p_Cashier,Getdate(),Getdate(),GetDate(),@p_BillType,'NOS',@p_UnitNo,@l_RowNo,
			'F',@l_DiscType,'',@PromId,@p_Floca,@p_Table,@p_UnitNo,@p_OrderNo,@p_OrderBy)

		UPDATE tbXItem Set SDiscount=(SDiscount+((Nett-SDiscount)*(@p_Discount/@p_Amount))) Where Loca=@p_Loca And Receipt=@p_Receipt And UnitNo=@p_UnitNo And RecallStat='F' And (Iid='001' or Iid='002' Or Iid='003' Or Iid='004')
		And ItemCode Not In(Select ItemCode From tbItem Where NODiscount=1)

		UPDATE tbXItem Set SDStat=CASE WHEN SDStat='F' THEN 'T' ELSE '*' END Where Loca=@p_Loca And Receipt=@p_Receipt And UnitNo=@p_UnitNo And RecallStat='F'
		Set @p_Amount=@p_Amount- @p_Discount
	End			
		
	--Update Birthday Discount
	If (Exists(Select * From #tbTempPromo Where PType=6))
	Begin
		Select Top 1 @PromId=PromoId,@p_Discount=DiscountP,@IsLoyalty=Isnull(Loyalty,'0') from #tbTempPromo Where PType=6 Order By Discount Desc
		Set @p_SDId=6
		Set @p_SDPcnt=Rtrim(Convert(Varchar(10),@p_Discount))+'%'
		Set @p_Discount=@p_Discount/100*@p_Amount		
		Set @p_Descrip='BIRTH DAY WISHES' + ' ' + Rtrim(@p_SDPcnt)
		Select @l_RowNo=ISNULL(MAX(RowNo)+1,1) FROM tbXItem Where Loca=@p_Loca And Receipt=@p_Receipt And UnitNo=@p_UnitNo		
		Select @l_DisNo=ISNULL(MAX(SDNo)+1,1)  FROM tbXItem Where Loca=@p_Loca And Receipt=@p_Receipt And UnitNo=@p_UnitNo		
		IF (EXISTS(SELECT * FROM tbXItem WHERE Receipt=@p_Receipt And Loca=@p_Loca And UnitNo=@p_UnitNo And SaleType='G' And (Iid='001' Or Iid='002' Or Iid='003' Or Iid='004' Or Iid='006'))) SET @l_DiscType='G'		
		INSERT INTO tbXItem(ItemCode,  RefCode,  Descrip,  Cost,  Price,  Qty,  Amount,  IDI1,  IDis1,
			IDiscount1,  IDI2,  IDis2,  IDiscount2,  IDI3,  IDis3,  IDiscount3,  IDI4,
			IDis4,  IDiscount4,  IDI5,  IDis5,  IDiscount5,  Rate,  SDStat,  SDNo,
			SDID,  SDIs,  SDiscount,  Tax,  Nett,  Loca,  IId,  Receipt,  Salesman,
			Cust,  Cashier,  StartTime,EndTime,  RecDate,  BillType,  Unit,  UnitNo,RowNo,
			RecallStat,SaleType,RecallNo,PromId,FLoca,TableNo,TerminalNo,OrderNo,OrderBy)
			VALUES (	@p_ItemCode,'',@p_Descrip,0,0,1,@p_Amount,0,'',0
			,0,'',0,0,'',0,0,'',0,0,'',0,@p_Discount,'F',@l_DisNo,@p_SDId,@p_SDPcnt,@p_Discount,0,@p_Discount,@p_Loca
			,@p_IID,@p_Receipt,@p_Sman ,@p_Cust,@p_Cashier,Getdate(),Getdate(),GetDate(),@p_BillType,'NOS',@p_UnitNo,@l_RowNo,
			'F',@l_DiscType,'',@PromId,@p_Floca,@p_Table,@p_UnitNo,@p_OrderNo,@p_OrderBy)
		If @@Error <> 0  Set @l_Error=@@Error
		UPDATE tbXItem Set SDiscount=(SDiscount+((Nett-SDiscount)*(@p_Discount/@p_Amount))) Where Loca=@p_Loca And Receipt=@p_Receipt And UnitNo=@p_UnitNo And RecallStat='F' And (Iid='001' or Iid='002' Or Iid='003' Or Iid='004')
		And ItemCode Not In(Select ItemCode From tbItem Where NODiscount=1)

		UPDATE tbXItem Set SDStat=CASE WHEN SDStat='F' THEN 'T' ELSE '*' END Where Loca=@p_Loca And Receipt=@p_Receipt And UnitNo=@p_UnitNo And RecallStat='F'
		Set @p_Amount=@p_Amount- @p_Discount
	End
	
End
Drop Table #tbTempPromo




GO

