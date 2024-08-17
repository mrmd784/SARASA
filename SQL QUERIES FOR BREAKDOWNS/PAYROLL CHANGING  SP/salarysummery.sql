USE [Payroll]
GO

/****** Object:  StoredProcedure [dbo].[insert_SALARYSUMMERY_Sarasa]    Script Date: 12/06/2023 6:40:25 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--select * from SALARYSUMMERY
-- exec insert_SALARYSUMMERY_Sarasa 1,'202104','SARASA','2021-04-01','2021-04-30',1,'Aprial'


ALTER Proc [dbo].[insert_SALARYSUMMERY_Sarasa]
	
	(@loca int, @MONTHOFSALARY char(6),  @LOGONUSER char(20),@MonthBegin DateTime,@MonthEnd DateTime,@Reprocess int,@MonthName char (20))

	AS

	Begin Tran

	Declare @ErrorSave 		as int
	Declare @EMPID 		Numeric,
	@WORKINGDAYS 		[real],	
	@BASICSALARY 		[Real], 	
	@ALLOWANCE1 			[Real], 
	@ALLOWANCE1_A		[Real], 
	@ALLOWANCE1_NO		[Real], 
 	@ALLOWANCE2 			[Real],	 
	@ALLOWANCE3 			[Real],	 
	@ALLOWANCE4 			[Real],	 
	@ALLOWANCE5 			[Real],
	@ALLOWANCE6 			[Real],	 
	@ALLOWANCE7 			[Real],	 
	@ALLOWANCE8 			[Real],	 
	@ALLOWANCE9 			[Real],
	@ALLOWANCE10		[Real],
	@ALLOWANCE11		[Real], 	
	@ALLOWANCE12 		[Real],
	@ALLOWANCE13 		[Real],	
	@ALLOWANCE14 		[Real],	
	@ALLOWANCE15 		[Real],	
	@ALLOWANCE16 		[Real],	
	@ALLOWANCE17 		[Real],	
	@ALLOWANCE18 		[Real],	
	@ALLOWANCE19 		[Real],	
	@ALLOWANCE20		[Real],		 
	@DEDUCTION1 			[Real],	 
	@DEDUCTION2 			[Real],
	@DEDUCTION3 			[Real],	 
	@DEDUCTION4 			[Real],	
	@DEDUCTION5 			[Real],	 
	@DEDUCTION6 			[Real],	 
	@DEDUCTION7 			[Real],	 
	@DEDUCTION8 			[Real],	 
	@DEDUCTION9 			[Real],
	@DEDUCTION10 		[Real],
	@DEDUCTION11 		[Real],
	@DEDUCTION12 		[Real], 	
	@NoOfLate_hours		[Real],	
	@Late				[Real],	@SALARYADVANCE 		[Real], 		
	@EPF_EMPLOYEE 		[Real],	 
	@EPF_Comp 			[Real],	 
	@ETF 				[Real],	 
	@EPF_EMPLOYEE_Calculated 	[Real],	
	@EPF_Comp_Calculated 		[Real],	
	@ETF_Calculated 		[Real],	
	@TAX1 				[Real],	 
	@TAX2 				[Real],	 
	@TAX3 				[Real],	 
	@SALARYPAID 			[Real],	 
	@PAIDTYPE 			[int], 	
	@LoanID 			Numeric,		
	@NopayRate 			Real, 		
	@Deduction_StartMonth 		char(6),	 
	@AdvanceAmt 			Numeric(18,2),	 
	@OT_HOURS 			numeric(18,2),		 
	@noofWorkingDays 		Numeric(18,2),		
	@No_of_Leave_Days 		Numeric(18,2),	
	@No_OF_WorkinDaysOfMonth	Numeric(18,2), 	
	@Monthly_Installment 		Numeric(18,2), 	
	@LoanNo 			int,	 		
	@No_of_NoPAyDays		numeric(18,2),  
	@NoPAyAmount 			Numeric(18,2),	
	@OT_RATE 			Numeric(18,2),	
	@OT_Allowance 			Numeric(18,2),
	@OTRateINSysInfo 		REAL,		
	@AcctualOTHours		numeric(18,2),		
	@ThisDate 			Datetime,			
	@TotalSaturdays		Numeric(18,2),
	@TotalSaturdays_m		Numeric(18,2),		
	@TotalNormalDays 		Numeric(18,2),
	@TotalSundays_m		Numeric(18,2),
	@TotalSundays			Numeric(18,2),	
	@TotalHolidays			Numeric(18,2),	
	@TotalHolidays_m		Numeric(18,2),	
	@TypeofDayThisDate 		Char(50),			
	@OTRateThisDate 		Numeric(18,2),	
	@TotalHoldays 			Numeric(18,2),	
	@TotalOTHrs_NormalDay 	Numeric(18,2),
	@TotalOTHrs_Saturday 		Numeric(18,2),	
	@TotalOTHrs_SunDay 		Numeric(18,2),		
	@TotalOTHrs_Holiday 		Numeric(18,2),	
	@OTallowance_SaturDay 	Numeric(18,2),
	@OTallowance_Sunday 		Numeric(18,2),	
	@OTallowance_HoliDay 		Numeric(18,2),		
	@OTallowance_NormalDay 	Numeric(18,2),
	@NoOfWorkedDays_DayBasisSal	numeric(18,2),
	@PaymentMethod 		int,  --1-Monthly 2-Daily
	@PaidAmt		 	money,		      
	@PaidInstallments 		numeric(18,2),	 
	@Balance		 	money,		 
	@TotalAmt 			numeric(18,2),	
	@DEDUCTION 			numeric(18,2),		 
	@SearchID 			numeric(18,2),
	@DedStartdate 			char(6),  		      
	@PaidAmount			Numeric(18,2),			
	@BasicSalary2 			Numeric(18,2),	 
	@TotalAllowance 		Numeric(18,2),  
	@TotalDeductions 		Numeric(18,2),	 
	@TotalTax 			Numeric(18,2),
	@EPF_EMPLOYEE2 		numeric(18,2),   
	@EPF_Company2 		Numeric(18,2),	 
	@ETF2 				Numeric(18,2),
	@Allowance1_N			Numeric(18,2),	 
	@Allowance2_N 			Numeric(18,2),	 
	@Allowance3_N 			Numeric(18,2),	 
	@Allowance4_N 			Numeric(18,2),	
 	@Allowance5_N 			Numeric(18,2),	 
	@Allowance6_N 			Numeric(18,2),
 	@Allowance7_N 			Numeric(18,2),	 
	@Allowance8_N 			Numeric(18,2),	 
	@Allowance9_N 			Numeric(18,2),	 
	@Allowance10_N 		Numeric(18,2),
	@Allowance11_N		Numeric(18,2),	 
	@Allowance12_N 		Numeric(18,2),	 
	@Allowance13_N 		Numeric(18,2),	 
	@Allowance14_N 		Numeric(18,2),	
 	@Allowance15_N 		Numeric(18,2),	
	@Allowance16_N 		Numeric(18,2),


	@Allowance17_N		Numeric(18,2),	 
	@Allowance18_N 		Numeric(18,2),	 
	@Allowance19_N 		Numeric(18,2),	 
	@Allowance20_N 		Numeric(18,2), 	 
	@Ded1 				Numeric(18,2), 		 
	@Ded2 				Numeric(18,2),		 
	@Ded3 				Numeric(18,2),		 
	@Ded4 				Numeric(18,2),		 
	@Ded5 				Numeric(18,2),	 
	@Ded6 				Numeric(18,2),
 	@Ded7 				Numeric(18,2),		 
	@Ded8 				Numeric(18,2),		
 	@Ded9 				Numeric(18,2),		 
	@Ded10 			Numeric(18,2),
	@Loan1 			Numeric(18,2),		
 	@Loan2 			Numeric(18,2),		 
	@Loan3 			Numeric(18,2),
	@Loan1_N 			Numeric(18,2),		
 	@Loan2_N 			Numeric(18,2),		 
	@Loan3_N 			Numeric(18,2),
	@Standert_workingdate 		Numeric ,
 	@OTAllowed			int,	 	
	@EPFAllowed			int,		
	@No_of_fullday_worked 		Numeric(18,2) ,
	@Fixed_Allowance 		Numeric(18,2) ,	
	@Fixed_Allowance2				Numeric(18,2) ,	
	@LATE_HOURS  			Numeric(18,2), 
	@No_of_TakenLeave 		numeric(18,2),
	@No_of_ApprovedDays		numeric(18,2),
	@bsal 				Money,
	@Bdec 				Money,
	@EmployeType 			Int,
	@date 				Numeric(18,2),
	@NoOfLatehours 		Int,
	@TotLate 			Money,
	@DayilyRate  			Money,
	@PassRate 			Money,
	@OTRateDay			Money,
	@OTRateNight			Money,
	@WorkingDays_s 		Numeric(18,2),
	@Incentive			Money,
	@Emp_category			Int,
	@NoWeekDays			Numeric(18,2),
	@TotalAttendace		 	Numeric(18,2),
	@EmpPssRate			Int,
	@TotalSundays_e		Numeric(18,2),	
	@TotalHolidays_e		Numeric(18,2),
	@TOTAL_ALLOWANCE		Numeric(18,2),
	@TOTAL_DEDUCTION		Numeric(18,2),
	@TOTAL_ALLOWANCE_N		Numeric(18,2),
	@TOTAL_DEDUCTION_N		Numeric(18,2),
	@AllowanceETF			Numeric(18,2),
	@intCAll1 			Int,
	@intCAll2 			Int,
	@intCAll3 			Int,
	@intCAll4 			Int,
	@intCAll5 			Int,
	@intCAll6 			Int,
	@intCAll7 			Int,
	@intCAll8 			Int,
	@intCAll9 			Int,
	@ETFForAllowance		Numeric (18,2),
	@MedicalCom_PR		Numeric(18,2),
	@MedicalEMP_PR		Numeric(18,2),
	@MedicalCom_Amount		Numeric(18,2),
	@MedicalEMP_Amount		Numeric(18,2),
	@LoanTotalAmount		Numeric(18,2),
	@DepositAmount		Numeric(18,2),
	@DepositAmountLoan		Numeric(18,2),
	@EmpCode			Char(10),
	@AccId				Numeric,
	@PayTypeLoan			Int,
	@SalaryAr			Numeric(18,2),
	@LoanBalance			Numeric(18,2),
	@TotalForEPF	            	REAL,
	@intSalaryPaid1  		int,
	@SALARYPAID_N 		INT,
	@SalaryDe 			money,
	@year  				int,
	@month  			int,
	@payigMonth 			int,
	@OTMonth			Char(2),
	@OTAllowedHRS			int,
	@TaxAllow			int,
	@PaidAmountTax		Numeric(18,2),
	@WorkinDay			Numeric(18,2),
	@sex				int,
	@BasicForOT			NUMERIC(18,2),
	@AcctualWorkingHours		NUMERIC(18,2),
	@NoOfNightShiftDays		NUMERIC(18,2),
	@NoOfLeave			NUMERIC(18,2),
	@TotalWorkingHrs NUMERIC(18,2),      @AllowedWorkingHrs NUMERIC(18,2),   @NightDays NUMERIC(18,2),@WorkingAllowedHrs NUMERIC(18,2),@LeaveForAttendance NUMERIC(18,2),@AcctualDblWorkingHours NUMERIC(18,2),@SinOTAllowed NUMERIC(18,2),@DblOTAllowed NUMERIC(18,2) ,@TblOTAllowed NUMERIC(18,2) ,
	@SinOTHrs	Numeric(18,2),
	@DblOTHrs	Numeric(18,2),
	@TblOTHrs	Numeric(18,2),
	@SinOTAmount	Numeric(18,2),
	@DblOTAmount	Numeric(18,2),
	@TblOTAmount	Numeric(18,2),
	@PaidAmountBF Numeric(18,2),
	@MONTHOFSALARYNext char(6),
	@NextMonth datetime,
	@NoOf_Leavedays 	Numeric(18,2),
	@GROSS_SALARY Numeric(18,2)
----------------------------------------Common 


	exec  insert_AttendanceHead @MonthBegin,@MonthEnd,@Loca
            if @@Error <>0	set @ErrorSave =@@Error
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
	EXEC Insert_Loan_Repayment 	
	if @@Error <>0	set @ErrorSave =@@Error

	Delete from SALARYSUMMERY where Monthofsalary=@Monthofsalary and Loca=@Loca
	if @@Error <>0	set @ErrorSave =@@Error

	SELECT @Standert_workingdate=st_working_date FROM SystemInfo WHERE Loca=@Loca	
	if @@Error <>0	set @ErrorSave =@@Error

	SET @No_OF_WorkinDaysOfMonth = @Standert_workingdate
	SET @OT_RATE= 1.5
	SELECT @EPF_EMPLOYEE=EPF_Emp_Contn,@EPF_Comp=EPF_Comp_Contn,@ETF=ETF,@NopayRate=NoPay_Rate,@DayilyRate=Dayily,@PassRate=PassRate,@OTRateDay=OTRateDay,@OTRateNight=OTRateNight,@WorkingDays_s=WorkingDays,@Incentive=Incentive FROM SYSTEMINFO	WHERE Loca = @loca
	if @@Error <>0	set @ErrorSave =@@Error

	SET @Reprocess=0
	SELECT @OTRateINSysInfo=OTRate FROM SystemInfo WHERE Loca=@Loca	
	if @@Error <>0	set @ErrorSave =@@Error

	UPDATE salarysummery SET salarysummery.Active = '1' FROM salarysummery INNER JOIN employee ON salarysummery.empid =employee.Id WHERE salarysummery.monthofsalary=@MONTHOFSALARY and employee.active='0' and employee.Loca=@Loca
	if @@Error <>0	set @ErrorSave =@@Error
	
	DELETE FROM salarysummery WHERE salarysummery.Active = '1' and salarysummery.monthofsalary=@MONTHOFSALARY and salarysummery.Loca=@Loca
	if @@Error <>0	set @ErrorSave =@@Error

	delete from  dbo.AllowanceForEmp where allowanceid='0'
	if @@Error <>0	set @ErrorSave =@@Error

	delete from dbo.AllowanceFixForEmp where allowanceid='0'
	if @@Error <>0	set @ErrorSave =@@Error

	delete from dbo.DeductionForEmp where deductionid='0'
	if @@Error <>0	set @ErrorSave =@@Error

	delete from dbo.DeductionFixForEmp  where deductionid='0'
	if @@Error <>0	set @ErrorSave =@@Error
----------------------------------------STEP1

			Declare curEmployee Cursor Keyset For select ID,BSal,PaymentMethod ,OT_Allowed , EPF_allowed ,PaidType,Allowance1,Allowance2,Emp_category,EmpCode,TaxAllo,sex  From Employee Where Loca=@loca and Active=1 and Salary_Cal_Status=0 --and empcode='231'

			Open curEmployee
			Fetch First From curEmployee Into @EMPID ,@BASICSALARY, @PaymentMethod ,@OTAllowed ,@EPFAllowed,@PAIDTYPE,@Fixed_Allowance,@Fixed_Allowance2,@Emp_category,@EmpCode,@TaxAllow,@sex
			While @@Fetch_Status=0
				Begin
				
----------------------------------------STEP2

----------------------------------------GET TOTAL LEAVE DAYS FOR THIS EMPLOYEE
					SET @NoOfNightShiftDays=0
					SET @BasicForOT=@BASICSALARY
					SET @NoOfNightShiftDays=0 Set @intCAll1=0 set @intCAll2=0 set @intCAll3=0 set @intCAll4=0 set @intCAll5=0 set @intCAll6=0 set @intCAll7=0  set @intCAll8=0 set @intCAll9=0 set  @TotalSundays_e = 0
					SELECT @No_of_Leave_Days =ISNULL(SUM(NoofDays),0) FROM LeaveInput WHERE Approved='1' and EmployeeID=@EMPID AND StartDate >= @MonthBegin AND EndDate<=@MonthEnd and Loca=@Loca 
					SELECT  @noofWorkingDays =count(id) From Attendance Where Convert(Datetime,Working_date,103) Between  Convert(Datetime,@MonthBegin,103) and Convert(Datetime,@MonthEnd,103) and Emp_ID=@EmpID And Loca=@loca					
					SELECT  @TotalSundays_e   =Count(ATTENDANCE.[ID]) FROM ATTENDANCE INNER JOIN SHIFT ON ATTENDANCE.Shift=SHIFT.[ID] WHERE WeeklyType = 1  and Convert(Datetime,Working_date,103) Between  Convert(Datetime,@MonthBegin,103) and Convert(Datetime,@MonthEnd,103) and Emp_ID=@EmpID And ATTENDANCE.Loca=@loca--- and  TimeOut <> '1900-01-01 00:00:00.000'
				          	SELECT  @NoOfNightShiftDays =sum(NightShiftAllowed) From Attendance Where Convert(Datetime,Working_date,103) Between  Convert(Datetime,@MonthBegin,103) and Convert(Datetime,@MonthEnd,103) and Emp_ID=@EmpID And Loca=@loca and ( NightShiftAllowed='1' or NightShiftAllowed='2'	or NightShiftAllowed='3'	or NightShiftAllowed='4')				

					SELECT  @TotalHolidays_e =0					
					SELECT  @TotalSundays_m =0
					SELECT  @TotalHolidays_m =0					
					SELECT @SalaryAr =0
					SELECT @NoOfLeave=0
					SELECT @LeaveForAttendance=0
					SET @TotalWorkingHrs=0     SET  @AllowedWorkingHrs=0   SET  @NightDays=0 

					if @@Error <>0	set @ErrorSave =@@Error

----------------------------------------STEP3

----------------------------------------SELECT LOANS TO BE DEDUCTED
					set @DepositAmountLoan = 0
					set @Loan1=0 
					set @Loan2=0
					set @Loan3=0
					set  @DEDUCTION1=0		set  @DEDUCTION2=0		set  @DEDUCTION3=0		set  @DEDUCTION4=0		set  @DEDUCTION5=0		set  @DEDUCTION6=0		set  @DEDUCTION7=0		set  @DEDUCTION8=0		set  @DEDUCTION9=0		set  @DEDUCTION10=0
					Declare CurLoan Cursor Keyset for
						
						SELECT isnull(LoanSchedule.InstallmentValue,0) + isnull(LoanSchedule.InstallmentInterest,0) ,Loan.LoanNo,PayType From Loan , Loan_For_Employee , LoanSchedule  WHERE  Loan_For_Employee.LoanID =Loan.id and  Loan_For_Employee.id=LoanSchedule.Loan_For_EmplyeeID and    LoanSchedule.payigMonth= @MONTHOFSALARY   and  Loan_For_Employee.EmpID=@EMPID and Loan_For_Employee.Loca=@Loca 
						if @@Error <>0	set @ErrorSave =@@Error
						open 	CurLoan
						Fetch First From CurLoan into @Monthly_Installment,@LoanNo,@PayTypeLoan

						While @@Fetch_Status = 0
							Begin		
										IF @LoanNo=1		set @DEDUCTION1= isnull(@DEDUCTION1,0)+isnull(@Monthly_Installment,0)
										IF @LoanNo=2		set @DEDUCTION2= isnull(@DEDUCTION2,0)+isnull(@Monthly_Installment,0)
										IF @LoanNo=3		set @DEDUCTION3= isnull(@DEDUCTION3,0)+isnull(@Monthly_Installment,0)
										IF @LoanNo=4		set @DEDUCTION4= isnull(@DEDUCTION4,0)+isnull(@Monthly_Installment,0)
										IF @LoanNo=5		set @DEDUCTION5= isnull(@DEDUCTION5,0)+isnull(@Monthly_Installment,0)
										IF @LoanNo=6		set @DEDUCTION6= isnull(@DEDUCTION6,0)+isnull(@Monthly_Installment,0)
										IF @LoanNo=7		set @DEDUCTION7= isnull(@DEDUCTION7,0)+isnull(@Monthly_Installment,0)
										Fetch Next From CurLoan into @Monthly_Installment,@LoanNo,@PayTypeLoan
										if @@Error <>0	set @ErrorSave =@@Error
							End
						Close CurLoan
					Deallocate CurLoan					
					set @LoanTotalAmount = @DEDUCTION1+@DEDUCTION2+@DEDUCTION3+@DEDUCTION4+@DEDUCTION5+@DEDUCTION6+@DEDUCTION7
					set @Loan1=@LoanTotalAmount							

--Leave Days
set @NoOf_Leavedays=0
Set @NoOf_Leavedays=(select isnull(SUM(NoOfDays),0) from LeaveInput where (StartDate between '2023-03-01' and '2023-03-31') and EmployeeID=13 and Loca=01 and Approved=1 and MonthOfSalary='202303' and LeaveID not in(select id from LeaveMaster where LeaveCode='03'))
if @NoOf_Leavedays<0
Begin  
	Set @NoOf_Leavedays=0
End 

----------------------------------------GET ALLOWANCES
Set @AllowanceETF =0
Delete from AllowanceForEmp Where EmpCode=@EmpID and Loca=@Loca and Type='1'  and MonthOfSalary=@MonthOfSalary
if @@Error <>0	set @ErrorSave =@@Error

--if  @loca<>5
--Begin
--	Insert Into AllowanceForEmp  (EmpCode,AllowanceID,Amount ,BasicSalary,MonthOfSalary,AllowanceDate,ETFApproved,Loca,Type) Select EmpCode,AllowanceID,Amount,@BASICSALARY,@MONTHOFSALARY,AllowanceDate,ETFApproved,Loca,'1' from AllowanceFixForEmp Where EmpCode=@EmpID and Loca=@Loca and AllowanceID not in(select  id  from allowance where (allowancecode=03) and Loca=@loca)
--	if @@Error <>0	set @ErrorSave =@@Error
--End
--if  @loca=5
--Begin
--				Insert Into AllowanceForEmp  (EmpCode,AllowanceID,Amount ,BasicSalary,MonthOfSalary,AllowanceDate,ETFApproved,Loca,Type) Select EmpCode,AllowanceID,Amount,@BASICSALARY,@MONTHOFSALARY,AllowanceDate,ETFApproved,Loca,'1' from AllowanceFixForEmp Where EmpCode=@EmpID and Loca=@Loca and AllowanceID not in(select  id  from allowance where (allowancecode='01' or allowancecode='02') and Loca=@loca)
--				if @@Error <>0	set @ErrorSave =@@Error
--End
--// Attendance Allowance
if @No_of_Leave_Days>=1 and @No_of_Leave_Days<2
		Begin 
			Insert Into AllowanceForEmp  (EmpCode,AllowanceID,Amount ,BasicSalary,MonthOfSalary,AllowanceDate,ETFApproved,Loca,Type) Select EmpCode,AllowanceID,(Amount/2),@BASICSALARY,@MONTHOFSALARY,AllowanceDate,ETFApproved,Loca,'1' from AllowanceFixForEmp Where EmpCode=@EmpID and AllowanceID not in(select  id  from allowance where allowancecode='01' or AllowanceCode='02' or AllowanceCode='04')
			if @@Error <>0	set @ErrorSave =@@Error
		End 
	if @No_of_Leave_Days>=2
		Begin 
			Insert Into AllowanceForEmp  (EmpCode,AllowanceID,Amount ,BasicSalary,MonthOfSalary,AllowanceDate,ETFApproved,Loca,Type) Select EmpCode,AllowanceID,0,@BASICSALARY,@MONTHOFSALARY,AllowanceDate,ETFApproved,Loca,'1' from AllowanceFixForEmp Where EmpCode=@EmpID and AllowanceID not in(select  id  from allowance where (allowancecode='01' or allowancecode='02' or AllowanceCode='04'))
			if @@Error <>0	set @ErrorSave =@@Error
		End 
	
--//----------------


				
				SELECT @TOTAL_ALLOWANCE= isnull (SUM(Amount),0) FROM  AllowanceForEmp WHERE  (AllowanceForEmp.SalaryType = '1' or AllowanceForEmp.SalaryType = '0' ) and   (EmpCode =@EMPID) AND (Loca = @Loca) AND (MonthOfSalary =@MONTHOFSALARY)
				if @@Error <>0	set @ErrorSave =@@Error

				SELECT @AllowanceETF= isnull (SUM(Amount),0) FROM  AllowanceForEmp WHERE (EmpCode =@EMPID) AND (Loca = @Loca) AND (MonthOfSalary =@MONTHOFSALARY) AND (ETFApproved='1')				
				if @@Error <>0	set @ErrorSave =@@Error

				
----------------------------------------GET ALLOWANCES FIX
						Set @ALLOWANCE1=0	set @ALLOWANCE2=0	set @ALLOWANCE3=0	set @ALLOWANCE4=0	set @ALLOWANCE5=0	set @ALLOWANCE6=0	set @ALLOWANCE7=0	set @ALLOWANCE8=0	set @ALLOWANCE9=0	set @ALLOWANCE10=0
						Set @ALLOWANCE11=0	set @ALLOWANCE12=0	set @ALLOWANCE13=0	set @ALLOWANCE14=0	set @ALLOWANCE15=0	set @ALLOWANCE16=0	set @ALLOWANCE17=0	set @ALLOWANCE18=0	set @ALLOWANCE19=0	set @ALLOWANCE20=0
						If @@Error <>0	set @ErrorSave =@@Error

				SELECT @Allowance1=Allowance1,@Allowance2=Allowance2,@Allowance3=Allowance3,@Allowance4=Allowance4 from Employee where id=@empid AND (Loca = @Loca)
				if @@Error <>0	set @ErrorSave =@@Error


----------------------------------------GET TAX		
						SET @Tax1=0
						SET @Tax2=0 
						SET @Tax3=0 	

----------------------------------------GET DEDUCTION
					set  @DEDUCTION1=0		set  @DEDUCTION2=0		set  @DEDUCTION3=0		set  @DEDUCTION4=0		set  @DEDUCTION5=0		set  @DEDUCTION6=0		set  @DEDUCTION7=0		set  @DEDUCTION8=0		set  @DEDUCTION9=0		set  @DEDUCTION10=0
					if @@Error <>0	set @ErrorSave =@@Error					
				
----------------------------------------GET ADVANCE
					set @AdvanceAmt =0
					Select  @AdvanceAmt=isnull(sum(SALARYADVANCE),0) From SALARY_ADVANCE Where  MONTHOFSALARY=@MONTHOFSALARY and EmpID=@EmpID And Loca=@loca
					if @@Error <>0	set @ErrorSave =@@Error

----------------------------------------GET DEDUCTION	

					Delete from DeductionForEmp Where EmpCode=@EmpID and Loca=@Loca and Type='1' and MonthOfSalary=@MonthOfSalary
					if @@Error <>0	set @ErrorSave =@@Error

					Insert Into DeductionForEmp  (EmpCode,DeductionId,Amount ,BasicSalary,MonthOfSalary,DeductionDate,Loca,Type) Select EmpCode,DeductionId,Amount,@BASICSALARY,@MONTHOFSALARY,DeductionDate,Loca,'1' from DeductionFixForEmp Where EmpCode=@EmpID and Loca=@Loca
					if @@Error <>0	set @ErrorSave =@@Error
													
					SELECT @TOTAL_DEDUCTION= isnull (SUM(Amount),0) FROM  DeductionForEmp WHERE (EmpCode =@EMPID) AND (Loca = @Loca	) AND (MonthOfSalary =@MONTHOFSALARY)
					if @@Error <>0	set @ErrorSave =@@Error

----------------------------------------STEP4						
----------------------------------------GET NO PAY AMOUNT AND NO PAY DAYS		
				--SELECT @No_of_NoPAyDays =isnull(SUM(No_of_LeaveDays),0) FROM InputLeave WHERE EmpID=@EMPID  AND StartDate >= @MonthBegin AND EndDate<=@MonthEnd AND NoPay_Given=1 and Loca=@loca 
				
				--select @No_of_NoPAyDays= isnull(SUM(NoOfDays),0) from LeaveInput inner join LeaveMaster on LeaveMaster.id = LeaveInput.LeaveID where Discription='Nopay' and LeaveInput.Loca=@loca AND  EmployeeID=@EMPID AND  StartDate BETWEEN @MonthBegin AND @MonthEnd and DeleteStatus=0
				select @No_of_NoPAyDays= isnull(SUM(NoOfDays),0) from LeaveInput inner join LeaveMaster on LeaveMaster.id = LeaveInput.LeaveID where Discription='No Pay' and LeaveInput.Loca=@loca AND  EmployeeID=@EMPID AND  StartDate BETWEEN @MonthBegin AND @MonthEnd and DeleteStatus=0 and LeaveInput.StartDate not in(select AttendanceDate from calender  where DateType='11')
				if @@Error <>0	set @ErrorSave =@@Error

		--Gradiance Allowance Deduct
				Insert Into AllowanceForEmp  (EmpCode,AllowanceID,Amount ,BasicSalary,MonthOfSalary,AllowanceDate,ETFApproved,Loca,Type) Select EmpCode,AllowanceID,(Amount-((Amount/26)*@No_of_NoPAyDays)),@BASICSALARY,@MONTHOFSALARY,AllowanceDate,ETFApproved,Loca,'1' from AllowanceFixForEmp Where EmpCode=@EmpID and Loca=@loca and AllowanceID=5
				if @@Error <>0	set @ErrorSave =@@Error


				select @NoOfLeave= isnull(SUM(NoOfDays),0) from LeaveInput inner join LeaveMaster on LeaveMaster.id = LeaveInput.LeaveID where Discription<>'No Pay' and LeaveInput.Loca=@loca AND  EmployeeID=@EMPID AND  StartDate BETWEEN @MonthBegin AND @MonthEnd and DeleteStatus=0
				if @@Error <>0	set @ErrorSave =@@Error

if @loca=6
Begin
	set @No_of_NoPAyDays=0
End 
							Set @NoPAyAmount=@No_of_NoPAyDays*(@BASICSALARY+@ALLOWANCE1+@ALLOWANCE2) /26
							if @@Error <>0	set @ErrorSave =@@Error	
						--if @PaymentMethod = 2
						--	begin
						--		set @NoPAyAmount=0							
						--		set @NoPAyAmount =(@BASICSALARY+@Fixed_Allowance+@Fixed_Allowance2)-(((@BASICSALARY+@Fixed_Allowance+@Fixed_Allowance2)/30)*@noofWorkingDays)
						--		if @@Error <>0	set @ErrorSave =@@Error
						--	end							


-- exec insert_SALARYSUMMERY_Sarasa 1,'202301','SARASA','2023-01-01','2023-01-31',1,'January'
-------------------------------------------GET EPF,ETF	
			           SET @Bdec =@BASICSALARY				
						IF @EPFAllowed=1 ---EPF Allowed
							begin	
								SET @TotalForEPF = @BASICSALARY+@ALLOWANCE1+@ALLOWANCE2-@NoPAyAmount
								SET @EPF_EMPLOYEE_Calculated=@TotalForEPF*@EPF_EMPLOYEE
								SET @EPF_Comp_Calculated=@TotalForEPF*@EPF_Comp
								SET @ETF_Calculated=@TotalForEPF*@ETF				
								SET @MedicalCom_Amount = 0
								SET @MedicalEMP_Amount =0
								
								if @@Error <>0	set @ErrorSave =@@Error
							end
						else
							begin
								SET @EPF_EMPLOYEE_Calculated = 0
								SET @EPF_Comp_Calculated= 0
								SET @ETF_Calculated = 0
								SET @MedicalCom_Amount = 0
								SET @MedicalEMP_Amount =0
								SET @TotalForEPF = 0
								if @@Error <>0	set @ErrorSave =@@Error
							end	
set @TOTAL_DEDUCTION=isnull(@TOTAL_DEDUCTION,0)+isnull(@EPF_EMPLOYEE_Calculated,0)
----------------------------------------Calculate Night Shift Allowance


			if @NoOfNightShiftDays > 0
				begin
					set @ALLOWANCE3 =@NoOfNightShiftDays*@ALLOWANCE3

					set @NoOfNightShiftDays =isnull( @NoOfNightShiftDays,0)
				end
			else
				begin
					set @ALLOWANCE3 =0
				end

----------------------------------------Calculate Atteandnce Allowance
			if @@Error <>0	set @ErrorSave =@@Error

			
		
				
----------------------------------------Calculate Late		
			select  @NoOfLatehours= Sum(isnull(NoOfLate_hours,0))  From Attendance  Where Emp_ID=@EmpID and Attendance.Loca=@loca and Attendance.Working_Date Between @MonthBegin and @MonthEnd
			if @@Error <>0	set @ErrorSave =@@Error
			if @OTAllowed=1
			begin
				set @DEDUCTION1 =0 -- (@BASICSALARY/21600)*@NoOfLatehours
				
				if @@Error <>0	set @ErrorSave =@@Error	
			end	
			else
			begin
				set @DEDUCTION1 = 0
				if @@Error <>0	set @ErrorSave =@@Error	
			end	
				
			
----------------------------------------STEP7
----------------------------------------GET THE TOTAL SATURDAYS , SUNDAY, HOLYDAY  WORKED Details
					set @TotalSaturdays=0  		set @TotalSundays=0		set @TotalHoldays=0 		set @TotalNormalDays=0	set @OT_HOURS =0
					set @TotalOTHrs_Saturday=0      set @TotalOTHrs_Sunday=0 	set @TotalOTHrs_Holiday=0 	set @TotalOTHrs_NormalDay=0  set @AcctualOTHours=0
					set @OTallowance_SaturDay=0   set @OTallowance_SunDay=0	set @OTallowance_HoliDay=0	set @OTallowance_NormalDay= 0 	set @OT_Allowance=0
					set @AcctualDblWorkingHours = 0 set @TotalOTHrs_NormalDay=0 set @SinOTAllowed=0 set @DblOTAllowed=0 set @SinOTAllowed=0 set @DblOTAllowed=0
					if @@Error <>0	set @ErrorSave =@@Error

					set @OT_Allowance= 0
							set @SinOTHrs	= 0
							set @DblOTHrs	= 0
							set @TblOTHrs	= 0
							set @SinOTAmount	= 0
							set @DblOTAmount	= 0
							set @TblOTAmount	= 0

					if @OTAllowed=1
						begin						
   						 	set @OT_Allowance= 0
							set @SinOTHrs	= 0
							set @DblOTHrs	= 0
							set @TblOTHrs	= 0
							set @SinOTAmount	= 0
							set @DblOTAmount	= 0
							set @TblOTAmount	= 0
							SET @AcctualOTHours=0
							if @@Error <>0	set @ErrorSave =@@Error

							select  @OT_Allowance = Sum(isnull(OTALOWANCE,0))  From Attendance    Where Emp_ID=@EmpID and Attendance.Loca=@loca and Attendance.Working_Date Between @MonthBegin and @MonthEnd  
							select  @SinOTAmount = Sum(isnull(OTALOWANCE,0)), @OT_HOURS = Sum(isnull(NoOfOT_Hours,0)),@AcctualOTHours=Sum(isnull(AcctualOTHours,0)),@SinOTHrs = Sum(isnull(NoOfOT_Hours,0))  From Attendance    Where Emp_ID=@EmpID and Attendance.Loca=@loca and Attendance.Working_Date Between @MonthBegin and @MonthEnd  --and(TypeofDay=2 or TypeofDay=3 or TypeofDay=4 or TypeofDay=5 or TypeofDay=6 or TypeofDay=7)
							--select  @DblOTAmount = Sum(isnull(OTALOWANCE,0)), @DblOTHrs = Sum(isnull(AcctualOTHours,0))  From Attendance    Where Emp_ID=@EmpID and Attendance.Loca=@loca and Attendance.Working_Date Between @MonthBegin and @MonthEnd  and(TypeofDay=1 )
							--select  @TblOTAmount = Sum(isnull(OTALOWANCE,0)), @TblOTHrs = Sum(isnull(AcctualOTHours,0))  From Attendance    Where Emp_ID=@EmpID and Attendance.Loca=@loca and Attendance.Working_Date Between @MonthBegin and @MonthEnd  and(TypeofDay=8 or TypeofDay=9 or TypeofDay=10 or TypeofDay=11 or TypeofDay=12)
							if @@Error <>0	set @ErrorSave =@@Error

							
						end	
					else
						begin
							set @TotalSaturdays=0  		set @TotalSundays=0		set @TotalHoldays=0 		set @TotalNormalDays=0	set @OT_HOURS =0
							set @TotalOTHrs_Saturday=0      set @TotalOTHrs_Sunday=0 	set @TotalOTHrs_Holiday=0 	set @TotalOTHrs_NormalDay=0  set @AcctualOTHours=0
							set @OTallowance_SaturDay=0   set @OTallowance_SunDay=0	set @OTallowance_HoliDay=0	set @OTallowance_NormalDay= 0 	set @OT_Allowance=0
							set @AcctualDblWorkingHours = 0 set @SinOTAllowed=0 set @DblOTAllowed=0
							set @OT_Allowance= 0
							set @SinOTHrs	= 0
							set @DblOTHrs	= 0
							set @TblOTHrs	= 0
							set @SinOTAmount	= 0
							set @DblOTAmount	= 0
							set @TblOTAmount	= 0
						end

----------------------------------------STEP8
----------------------------------------GET THE TOTAL Loan Outstanding Update Details
						UPDATE Loan_For_Employee SET Loan_For_Employee.Paid_Amt = Loan_For_Employee.Paid_Amt + LoanSchedule.InstallmentValue ,
									     Loan_For_Employee.Balance_Amt = Loan_For_Employee.Balance_Amt - LoanSchedule.InstallmentValue,
									     Loan_For_Employee.PaidInstaltment = Loan_For_Employee.PaidInstaltment + 1
						FROM    Loan_For_Employee  Inner JOIN
						        LoanSchedule ON Loan_For_Employee.ID = LoanSchedule.Loan_For_EmplyeeID
						WHERE   (LoanSchedule.payigMonth = @MONTHOFSALARY) AND (Loan_For_Employee.LOCA =@loca) AND (Loan_For_Employee.Balance_Amt <> 0) AND
							(Loan_For_Employee.Deduction_StartMonth <= @MONTHOFSALARY) and (LoanSchedule.paid = '0') AND (Loan_For_Employee.EMPID =@EMPID )
							if @@Error <>0	set @ErrorSave =@@Error
						
						UPDATE LoanSchedule SET LoanSchedule.paid = '1'
						FROM    Loan_For_Employee  Inner JOIN
						        LoanSchedule ON Loan_For_Employee.ID = LoanSchedule.Loan_For_EmplyeeID
						WHERE   (LoanSchedule.payigMonth = @MONTHOFSALARY) AND (Loan_For_Employee.LOCA =@loca)  AND
							(Loan_For_Employee.Deduction_StartMonth <= @MONTHOFSALARY) and (LoanSchedule.paid = '0')	AND  (LoanSchedule.EMPID=@EMPID)
							if @@Error <>0	set @ErrorSave =@@Error
						Set @LoanBalance = 0 
						Select @LoanBalance=ISNULL(Sum(Balance_Amt),0) From dbo.Loan_For_Employee WHERE Loan_For_Employee.EMPID =@EMPID AND Loca=@Loca
						if @@Error <>0	set @ErrorSave =@@Error

----------------------------------------STEP7
----------------------------------------SAVE SALARY 
					IF  not exists(SELECT * FROM SALARYSUMMERY WHERE EmpID=@EMPID AND MONTHOFSALARY=@MONTHOFSALARY)
						BEGIN
	 						 SELECT @AdvanceAmt=SALARYADVANCE FROM SALARYSUMMERY WHERE EmpID=@EMPID AND MONTHOFSALARY=@MONTHOFSALARY
							 INSERT INTO [SALARYSUMMERY] 
								 ( [EMPID], [MONTHOFSALARY], [WORKINGDAYS], [BASICSALARY], [ALLOWANCE1], [ALLOWANCE2], [ALLOWANCE3],
								 [ALLOWANCE4], [ALLOWANCE5], [ALLOWANCE6], [ALLOWANCE7],[ALLOWANCE8],[ALLOWANCE9],[ALLOWANCE10],[ALLOWANCE11],[ALLOWANCE12],[ALLOWANCE13],[ALLOWANCE14],[ALLOWANCE15], [ALLOWANCE16],[ALLOWANCE17],[ALLOWANCE18],[ALLOWANCE19],[ALLOWANCE20],[DEDUCTION1], [DEDUCTION2],
								 [DEDUCTION3], [DEDUCTION4], [DEDUCTION5], [DEDUCTION6], [DEDUCTION7],  [DEDUCTION8],  [DEDUCTION9],  [DEDUCTION10],  [DEDUCTION11],  [DEDUCTION12], 
								 [SALARYADVANCE],
								 [EPF_EMPLOYEE], [EPF], [ETF], [TAX1], [TAX2], [TAX3], [SALARYPAID], [PAIDTYPE], [LASTMODIFIED], [LOGONUSER],Loca,Nopay,OT_Allowance,OT_Rate,OT_Hours, ACCTUAlOTHOURS,NoPayDays,
								Saturdays,Sundays,Total_Holidays,SAT_ACCTUAL_OT_HRS,SUN_ACCTUAL_OT_HRS,HOLIDAY_ACCTUAL_OT_HRS,WEEKDAY_ACCTUAL_OT_HRS,
								SAT_OT_ALLOWANCE,SUN_OT_ALLOWANCE,HOLIDAY_OT_ALLOWANCE,WEEKDAY_OT_ALLOWANCE,NORMAL_LEAVES ,LATE_HOURS,BASICSAl_deduct,[Loan1],[Loan2],[Loan3],TOTAL_ALLOWANCE,TOTAL_DEDUCTION,LoanBalance,TotalForEPF,LateMinte,sex,TotalWorkingHrs   ,   AllowedWorkingHrs   , NightDays ,ManthName,AcctualDblWorkingHours,SinOTHrs,DblOTHrs,TblOTHrs,SinOTAmount,DblOTAmount,TblOTAmount  ) 
 
							VALUES ( @EMPID, @MONTHOFSALARY, @noofWorkingDays, @BASICSALARY,
								 	isnull(@ALLOWANCE1,0), isnull(@ALLOWANCE2,0), isnull(@ALLOWANCE3,0),isnull(@ALLOWANCE4,0), isnull(@ALLOWANCE5,0),
									isnull(@ALLOWANCE6,0),	isnull(@ALLOWANCE7,0), isnull(@ALLOWANCE8,0),isnull(@ALLOWANCE9,0),isnull(@ALLOWANCE10,0),
									isnull(@ALLOWANCE11,0),isnull(@ALLOWANCE12,0),isnull(@ALLOWANCE13,0),isnull(@ALLOWANCE14,0),isnull(@ALLOWANCE15,0),
									isnull(@Allowance16,0),isnull(@Allowance17,0),isnull(@Allowance18,0),isnull(@Allowance19,0),isnull(@Allowance20,0) ,
									 isnull(@DEDUCTION1,0),  isnull(@DEDUCTION2,0),  isnull(@DEDUCTION3,0),  isnull(@DEDUCTION4,0),  isnull(@DEDUCTION5,0),  isnull(@DEDUCTION6,0),
									 isnull(@DEDUCTION7,0), isnull(@DEDUCTION8,0),  isnull(@DEDUCTION9,0),  isnull(@DEDUCTION10,0),  isnull(@DEDUCTION11,0),  isnull(@DEDUCTION12,0),  
									 isnull(@AdvanceAmt,0),  @EPF_EMPLOYEE_Calculated,
									@EPF_Comp_Calculated,  @ETF_Calculated,  @TAX1,  @TAX2, 	 @TAX3,  @SALARYPAID,  @PAIDTYPE ,  Cast(Cast(Current_timeStamp as char(12)) as smalldatetime),
									@LOGONUSER,@Loca,@NoPAyAmount,isnull(@OT_Allowance,0),isnull(@OT_RATE,0),isnull(@OT_HOURS,0) , isnull(@AcctualOTHours,0), @No_of_NoPAyDays,@TotalSaturdays,@TotalSundays,
									@TotalHoldays,isnull(@TotalOTHrs_Saturday,0),isnull(@TotalOTHrs_SunDay,0),isnull(@TotalOTHrs_Holiday,0),isnull(@TotalOTHrs_NormalDay,0),isnull(@OTallowance_SaturDay,0),
									isnull(@OTallowance_Sunday,0),isnull(@OTallowance_HoliDay,0),isnull(@OTallowance_NormalDay,0) , isnull(@No_of_Leave_Days,0) ,@LATE_HOURS,@Bdec,@Loan1,@Loan2,@Loan3,@TOTAL_ALLOWANCE,@TOTAL_DEDUCTION,@LoanBalance,@TotalForEPF,@NoOfLatehours,@sex	,@TotalWorkingHrs    ,  @AcctualOTHours   , @NoOfNightShiftDays,@MonthName,  isnull(@AcctualDblWorkingHours,0),isnull(@SinOTHrs,0),isnull(@DblOTHrs,0),isnull(@TblOTHrs,0),isnull(@SinOTAmount,0),isnull(@DblOTAmount,0),isnull(@TblOTAmount,0)  )
	
	
							if @@Error <>0	set @ErrorSave =@@Error
						END
					ELSE
----------------------------------------Update table
						BEGIN
							UPDATE SALARYSUMMERY SET [MONTHOFSALARY]=@MONTHOFSALARY,[WORKINGDAYS]=@noofWorkingDays,[BASICSALARY]=@BASICSALARY,
								[ALLOWANCE1]=isnull(@ALLOWANCE1,0)	,[ALLOWANCE2]=isnull(@ALLOWANCE2,0),[ALLOWANCE3]=isnull(@ALLOWANCE3,0),
								[ALLOWANCE4]=isnull(@ALLOWANCE4,0),[ALLOWANCE5]=isnull(@ALLOWANCE5,0),[ALLOWANCE6]=isnull(@ALLOWANCE6,0),
								[ALLOWANCE7]=isnull(@ALLOWANCE7,0),[ALLOWANCE8]=isnull(@ALLOWANCE8,0),[ALLOWANCE9]=isnull(@ALLOWANCE9,0),
								[ALLOWANCE10]=isnull(@ALLOWANCE10,0),[ALLOWANCE11]=isnull(@ALLOWANCE11,0),[ALLOWANCE12]=isnull(@ALLOWANCE12,0),
								[ALLOWANCE13]=isnull(@ALLOWANCE13,0),[ALLOWANCE14]=isnull(@ALLOWANCE14,0),[ALLOWANCE15]=isnull(@ALLOWANCE15,0),[ALLOWANCE16]=isnull(@Allowance16,0),[ALLOWANCE17]=isnull(@Allowance17,0),[ALLOWANCE18]=isnull(@Allowance18,0),[ALLOWANCE19]=isnull(@Allowance19,0),[ALLOWANCE20]=isnull(@Allowance20,0) ,
								[DEDUCTION1]=isnull(@DEDUCTION1,0),[DEDUCTION2]=isnull(@DEDUCTION2,0),[DEDUCTION3]=isnull(@DEDUCTION3,0),
								[DEDUCTION4]=isnull(@DEDUCTION4,0),[DEDUCTION5]=isnull(@DEDUCTION5,0),[DEDUCTION6]=isnull(@DEDUCTION6,0),[DEDUCTION7]=isnull(@DEDUCTION7,0),[DEDUCTION8]=isnull(@DEDUCTION8,0),[DEDUCTION9]=isnull(@DEDUCTION9,0),[DEDUCTION10]=isnull(@DEDUCTION10,0),[DEDUCTION11]=isnull(@DEDUCTION11,0),[DEDUCTION12]=isnull(@DEDUCTION12,0),
								[SALARYADVANCE]=isnull(@AdvanceAmt,0),[EPF_EMPLOYEE]=@EPF_EMPLOYEE_Calculated, [EPF]= @EPF_Comp_Calculated,[ETF]= @ETF_Calculated,[TAX1]=@TAX1,
								[TAX2]=@TAX2,[TAX3]=@TAX3,[SALARYPAID]=@SALARYPAID,[PAIDTYPE]=@PAIDTYPE,[LASTMODIFIED]=Cast(Cast(Current_timeStamp as char(12)) as smalldatetime),
								[LOGONUSER]=@LOGONUSER,Loca=@Loca,Nopay=@NopayAmount,OT_Allowance=isnull(@OT_Allowance,0),OT_Rate=@OT_RATE,OT_HOURS=isnull(@OT_HOURS,0) , ACCTUAlOTHOURS=isnull(@AcctualOTHours,0),NoPayDays=isnull( @No_of_NoPAyDays,0),
								Saturdays=@TotalSaturdays_m,Sundays=@TotalSundays_m,Total_Holidays=@TotalHolidays_m,SAT_ACCTUAL_OT_HRS=isnull(@TotalOTHrs_Saturday,0),SUN_ACCTUAL_OT_HRS=isnull(@TotalOTHrs_Sunday,0),
								HOLIDAY_ACCTUAL_OT_HRS=isnull(@TotalOTHrs_Holiday,0),WEEKDAY_ACCTUAL_OT_HRS=isnull(@TotalOTHrs_NormalDay,0),SAT_OT_ALLOWANCE=isnull(@OTallowance_SaturDay,0),
								SUN_OT_ALLOWANCE=isnull(@OTallowance_Sunday,0),HOLIDAY_OT_ALLOWANCE=isnull(@OTallowance_HoliDay,0),WEEKDAY_OT_ALLOWANCE=isnull(@OTallowance_NormalDay,0) ,NORMAL_LEAVES=@No_of_Leave_Days  , LATE_HOURS = @LATE_HOURS,BASICSAl_deduct=@Bdec,Loan1=@Loan1,Loan2=@Loan2,Loan3=@Loan3,NoOFLateHRS=@NoOfLatehours,ManthName=@MonthName ,Ch_WeekDays=@NoWeekDays,Ch_Holidays= @TotalHolidays_e,Ch_Sundays=@TotalSundays_e,IncentPrec=@EmpPssRate,TOTAL_ALLOWANCE	=@TOTAL_ALLOWANCE	,TOTAL_DEDUCTION=@TOTAL_DEDUCTION,	
								MediComAmount = isnull(@MedicalCom_Amount,0),  MediEMPAmount =isnull(@MedicalEmp_Amount,0),LoanBalance=@LoanBalance,TotalForEPF=@TotalForEPF,LateMinte=@NoOfLatehours,sex=@sex,TotalWorkingHrs = @AcctualWorkingHours,    AllowedWorkingHrs=@AcctualOTHours,    NightDays =isnull(@NoOfNightShiftDays,0),AcctualDblWorkingHours=  isnull(@AcctualDblWorkingHours,0),SinOTHrs=@SinOTHrs,DblOTHrs=@DblOTHrs,TblOTHrs=@TblOTHrs,SinOTAmount=@SinOTAmount,DblOTAmount=@DblOTAmount,TblOTAmount=isnull(@TblOTAmount,0)  
	 							 WHERE EmpID=@EMPID AND MONTHOFSALARY=@MONTHOFSALARY

 							if @@Error <>0	set @ErrorSave =@@Error
						END 

----------------------------------------STEP7
 
----------------------------------------Update the table with the deductions
			set @PaidAmount=0	set @BasicSalary2=0		set @TotalAllowance =0 		set @TotalDeductions =0	set @TotalTax =0 		set @EPF_EMPLOYEE2 =0 	set @EPF_Company2 =0
			set @ETF2 =0		set  @Allowance1_N =0		set @Allowance2_N =0 		set @Allowance3_N =0		set  @Allowance4_N =0		set  @Allowance5_N =0		set  @Allowance6_N = 0
			set @Allowance7_N =0	set @Allowance8_N =0		set  @Allowance9_N =0		set  @Allowance10_N =0	set @Ded1 =0			set @Ded2 =0			set @Ded3 =0	
			set @Ded4 =0		set @Ded5 =0			set @Ded6 =0			set  @Ded7 =0			set @Ded8 =0			set @Ded9 =0 			set @Ded10 =0 set @SALARYADVANCE=0

			SELECT @Allowance1_N=ALLOWANCE1,@Allowance2_N=ALLOWANCE2,@Allowance3_N=ALLOWANCE3,@Allowance4_N=ALLOWANCE4,@Allowance5_N=ALLOWANCE5,@Allowance6_N=ALLOWANCE6,@Allowance7_N=ALLOWANCE7,@Allowance8_N=ALLOWANCE8,@Allowance9_N=ALLOWANCE9,@Allowance10_N=ALLOWANCE10,@Allowance11_N=ALLOWANCE11,@Allowance12_N=ALLOWANCE12,@Allowance12_N=ALLOWANCE12,@Allowance13_N=ALLOWANCE13,@Allowance14_N=ALLOWANCE14,@Allowance15_N=ALLOWANCE15,@Allowance16_N=ALLOWANCE16,@Allowance17_N=ALLOWANCE17,@Allowance18_N=ALLOWANCE18,@Allowance19_N=ALLOWANCE19,@Allowance20_N=ALLOWANCE20 ,      				 @Ded1=DEDUCTION1,@Ded2=DEDUCTION2,@Ded3=DEDUCTION3,@Ded4=DEDUCTION4,@Ded5=DEDUCTION5,@Ded6=DEDUCTION6,@Ded7=DEDUCTION7,@Ded8=DEDUCTION8,@Ded9=DEDUCTION9,@Ded10=DEDUCTION10,
      				 @Tax1=TAX1,@Tax2=TAX2,@Tax3=TAX3,@BasicSalary2=BASICSALARY,@SALARYADVANCE=SALARYADVANCE,@EPF_Employee2=EPF_EMPLOYEE,@EPF_Company2=EPF,@ETF2=ETF,@Loan1_N=Loan1,@Loan1_N=Loan2,@Loan1_N=Loan3,@TOTAL_ALLOWANCE_N=TOTAL_ALLOWANCE,@TOTAL_DEDUCTION_N = TOTAL_DEDUCTION					  FROM SALARYSUMMERY WHERE EmpID=@EMPID AND MONTHOFSALARY=@MONTHOFSALARY			if @@Error <>0	set @ErrorSave =@@Error		

		SET @TotalAllowance = isnull(@Allowance1_N,0)+isnull(@Allowance2_N,0)+isnull(@TOTAL_ALLOWANCE_N,0)
		SET @TotalDeductions=isnull(@Ded1,0)+isnull(@Ded9,0)+isnull(@SALARYADVANCE,0)+isnull(@NoPAyAmount,0)+isnull(@Loan1,0)+isnull(@Loan2,0)+isnull(@Loan3,0)+isnull(@TOTAL_DEDUCTION_N,0)
		SET @TotalTax=isnull(@Tax1,0)+isnull(@Tax2,0)+isnull(@Tax3,0)
		SET @PaidAmount =((@BasicSalary2+@TotalAllowance+isnull(@OT_Allowance,0))) -((isnull(@TotalDeductions,0)+isnull(@TotalTax,0)+@EPF_EMPLOYEE_Calculated))	
		
		SET @PaidAmountTax= ((@BASICSALARY+@Allowance1+@Allowance5+@AllowanceETF)-isnull(@NoPAyAmount,0))+(isnull(@OT_Allowance,0)+@Allowance14+@Allowance4)

		Update SALARYSUMMERY set SALARYSUMMERY.DivisionID=Employee.DevisionCode, SALARYSUMMERY.DepartmentID=Employee.Department_ID FROM  SALARYSUMMERY INNER JOIN  Employee ON SALARYSUMMERY.EMPID = Employee.ID
		WHERE SALARYSUMMERY.MonthOfSalary=@MONTHOFSALARY and SALARYSUMMERY.Loca=@Loca
		if @@Error <>0	set @ErrorSave =@@Error


		set @Tax1 = 0
		if  @TaxAllow =1				
			begin
				if @PaidAmountTax >  '50000' and @PaidAmountTax<='91667'
					begin						
						set @Tax1 = 0	
						--set @Tax1 = (@PaidAmountTax*(4/100))-2000
						set @Tax1 = (@PaidAmountTax*0.04)-2000
						set @PaidAmount = @PaidAmount - @Tax1
						if @@Error <>0	set @ErrorSave =@@Error
					end
				else if @PaidAmountTax >  '91667' and @PaidAmountTax<='133333'
					begin						
						set @Tax1 = 0	

						--set @Tax1 = (@PaidAmountTax*(8/100))-5667
						set @Tax1 = (@PaidAmountTax*0.08)-5667
						set @PaidAmount = @PaidAmount - @Tax1
						if @@Error <>0	set @ErrorSave =@@Error
					end	
				else if @PaidAmountTax >  '133333' and @PaidAmountTax<='175000'
					begin						
						set @Tax1 = 0	
						--set @Tax1 = (@PaidAmountTax*(12/100))-11000
						set @Tax1 =(@PaidAmountTax*0.12)-11000
						set @PaidAmount = @PaidAmount - @Tax1
						if @@Error <>0	set @ErrorSave =@@Error
					end	
				else if @PaidAmountTax >  '175000' and @PaidAmountTax<='216667'
					begin
						print 4
						set @Tax1 = 0	
						--set @Tax1 = (@PaidAmountTax*(16/100))-18000
						set @Tax1 = (@PaidAmountTax*0.16)-18000
						set @PaidAmount = @PaidAmount - @Tax1
						if @@Error <>0	set @ErrorSave =@@Error
					end	
				else if @PaidAmountTax >  '216667' and @PaidAmountTax<='300000'
					begin						
						set @Tax1 = 0	
						--set @Tax1 = (@PaidAmountTax*(20/100))-26667
						set @Tax1 = (@PaidAmountTax*0.20)-26667
						set @PaidAmount = @PaidAmount - @Tax1
						if @@Error <>0	set @ErrorSave =@@Error
					end	
				else if @PaidAmountTax >  '300000' 
					begin						
						set @Tax1 = 0	
						--set @Tax1 = (@PaidAmountTax*(24/100))-38667
						set @Tax1 = (@PaidAmountTax*0.24)-38667
						set @PaidAmount = @PaidAmount - @Tax1
						if @@Error <>0	set @ErrorSave =@@Error
					end							
			end

			
		else
			begin
				set @Tax1 = 0
				
			end

		UPDATE SALARYSUMMERY SET SALARYPAID=@PaidAmount,DEDUCTION9=@Tax1 WHERE EmpID=@EMPID AND MONTHOFSALARY=@MONTHOFSALARY
		--// Broad forward Salary Balance
		if @PaidAmount<0
		Begin
			set @PaidAmountBF=-@PaidAmount
			if right(@MONTHOFSALARY,2)='12'
			Begin 
				set @MONTHOFSALARYNext= convert(Numeric(6,0),@MONTHOFSALARY)+89
				set @NextMonth=@MonthEnd+1
				
			End
				if right(@MONTHOFSALARY,2)<>'12'
				set @NextMonth=@MonthEnd+1
			Begin 
				set @MONTHOFSALARYNext= convert(Numeric(6,0),@MONTHOFSALARY)+1
				--set @MONTHOFSALARYNext= convert(char(20),(convert(Numeric(6,0),@MONTHOFSALARY)+89)
			End
			--set @MONTHOFSALARYNext=@MONTHOFSALARYNext+1
			exec Insert_Salary_Advance 0,@EMPID,@MONTHOFSALARYNext,@PaidAmountBF,1,'ADMIN', @BASICSALARY,@NextMonth,'BF'
		End
set @GROSS_SALARY=0
		
		
		if @@Error <>0	set @ErrorSave =@@Error
			--------------------Round Up Salary
			SELECT @Allowance1_N=ALLOWANCE1,@Allowance2_N=ALLOWANCE2,@Allowance3_N=ALLOWANCE3,@Allowance4_N=ALLOWANCE4,@Allowance5_N=ALLOWANCE5,@Allowance6_N=ALLOWANCE6,@Allowance7_N=ALLOWANCE7,@Allowance8_N=ALLOWANCE8,@Allowance9_N=ALLOWANCE9,@Allowance10_N=ALLOWANCE10,@Allowance11_N=ALLOWANCE11,@Allowance12_N=ALLOWANCE12,@Allowance12_N=ALLOWANCE12,@Allowance13_N=ALLOWANCE13,@Allowance14_N=ALLOWANCE14,@Allowance15_N=ALLOWANCE15,@Allowance16_N=ALLOWANCE16,@Allowance17_N=ALLOWANCE17,@Allowance18_N=ALLOWANCE18,@Allowance19_N=ALLOWANCE19,@Allowance20_N=ALLOWANCE20 ,      				 @Ded1=DEDUCTION1,@Ded2=DEDUCTION2,@Ded3=DEDUCTION3,@Ded4=DEDUCTION4,@Ded5=DEDUCTION5,@Ded6=DEDUCTION6,@Ded7=DEDUCTION7,@Ded8=DEDUCTION8,@Ded9=DEDUCTION9,@Ded10=DEDUCTION10,
      				 @Tax1=TAX1,@Tax2=TAX2,@Tax3=TAX3,@BasicSalary2=BASICSALARY,@SALARYADVANCE=SALARYADVANCE,@EPF_Employee2=EPF_EMPLOYEE,@EPF_Company2=EPF,@ETF2=ETF,@Loan1_N=Loan1,@Loan1_N=Loan2,@Loan1_N=Loan3,@TOTAL_ALLOWANCE_N=TOTAL_ALLOWANCE,@TOTAL_DEDUCTION_N = TOTAL_DEDUCTION					  FROM SALARYSUMMERY WHERE EmpID=@EMPID AND MONTHOFSALARY=@MONTHOFSALARY			if @@Error <>0	set @ErrorSave =@@Error

			SET @TotalAllowance = isnull(@Allowance1_N,0)+isnull(@Allowance2_N,0)+isnull(@TOTAL_ALLOWANCE_N,0)
set @GROSS_SALARY=@BasicSalary2+@TotalAllowance+@OT_Allowance
			
			SET @TotalDeductions=isnull(@Ded1,0)+isnull(@Ded9,0)+isnull(@SALARYADVANCE,0)+isnull(@NoPAyAmount,0)+isnull(@Loan1,0)+isnull(@Loan2,0)+isnull(@Loan3,0)+isnull(@TOTAL_DEDUCTION_N,0)
			SET @TotalTax=isnull(@Tax1,0)+isnull(@Tax2,0)+isnull(@Tax3,0)
			SET @PaidAmount =((@BasicSalary2+@TotalAllowance+isnull(@OT_Allowance,0))) -((isnull(@TotalDeductions,0)+isnull(@TotalTax,0)))	
			
			
			UPDATE SALARYSUMMERY SET SALARYPAID=@PaidAmount,SALARYPAID_N=@PaidAmount,GROSS_SALARY=@GROSS_SALARY,TOTAL_DEDUCTION=@TotalDeductions WHERE EmpID=@EMPID AND MONTHOFSALARY=@MONTHOFSALARY
			if @@Error <>0	set @ErrorSave =@@Error


		if @@Error <>0	set @ErrorSave =@@Error
		Fetch Next From curEmployee Into @EMPID,@BASICSALARY,@PaymentMethod  ,@OTAllowed ,@EPFAllowed,@PAIDTYPE, @Fixed_Allowance,@Fixed_Allowance2,@Emp_category,@EmpCode,@TaxAllow,@sex
	End
	Close curEmployee
	Deallocate curEmployee

	if @ErrorSave<> 0
      		 rollback transaction
	else
     		commit transaction






GO

