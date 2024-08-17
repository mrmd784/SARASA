USE [Payroll]
GO

/****** Object:  StoredProcedure [dbo].[NewOT_calculation_Sarasa]    Script Date: 12/06/2023 6:40:46 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--exec NewOT_calculation_Sarasa 1,'2021/04/01','2021/04/30'
	

--// Dresmo OT Calculation

ALTER proc [dbo].[NewOT_calculation_Sarasa] (@Loca int ,@MonthBegin DateTime ,@MonthEnd DateTime )
	
AS



Declare @ErrorSave  			Int,
 	@working_DAte 			Datetime,
 	@TimeIN 			Datetime,
 	@TimeOut 			Datetime ,
	@TypeofDay 			Int,
	@ShiftID			Int,
 	@EMPID 			Numeric,
 	@minOTHr_M			Int,
 	@OTStartTime_M 		Numeric,
 	@ShiftStartTime_M 		Numeric,
 	@ShiftEndTime_M 		Numeric,
 	@OTStartTime			Datetime,
 	@ShiftStartTime			Datetime,
 	@ShiftEndTime 			Datetime,
 	@TimeIN_M 			Numeric,
 	@TimeOut_M 			Numeric,
 	@OTMinutes_1  			Int,
 	@OTMinutes_2 			Int,
 	@OTMinutes_Total 		Numeric(18,4),
 	@AcctualOTHours_Total_D  	Numeric(18,2),
 	@AcctualOTHours_Total_F  	Numeric(18,2),
 	@OTHours_Total_D      		Numeric(18,4),
 	@AcctualOTHours_Total  		Numeric(18,4),
 	@OTHours_Total  		Numeric(18,4),
	@OTDAYRATE  			Real,
 	@CompanyOTRate		Real,
 	@AttendID 			Numeric,
 	@BSal				Numeric(18,4),
	@OTAllowance 			Numeric(18,4),
 	@emp_type 			Numeric,
 	@DayStartTime			Datetime,
 	@DayEndTime 			Datetime,
 	@LateM 				Int,
 	@EmpType 			Int,
 	@EmployeeOFFDay 		Numeric,
 	@ShiftIDx 			Int,
 	@ShiftStartTimex		DateTime,
 	@ShiftEndTimex			Datetime,
 	@ShiftOTSTARTTIMEx		Datetime,
 	@ShiftOTENDTIMEx 		Datetime,
 	@ShiftStartTime_x		Numeric,
 	@ShiftEndTime_x		Numeric,
 	@OTStartTime_x		Numeric,
 	@Grade_id 			Int,
 	@LeaveDays			Numeric(18,4),
 	@MOT_Allowed			Int,
 	@Allowance1 			Numeric(18,4),
 	@Allowance2 			Numeric(18,4),
 	@NoOfWorkMin			Numeric(18,4),
 	@NoOfWorkHRS			Numeric(18,4),
	@Mint    			Int,
 	@TempH			Int,
 	@Working_min 			Numeric (18,4),
	@Working_Hours 		Numeric  (18,4),
	@OTHRS			Numeric(18,2),
 	@OTWorking_Hours 		Int,
 	@SinOTHrs			Numeric  (18,4),
 	@DblOTHrs			Numeric  (18,4),
	@TblOTHrs			Numeric  (18,4),	
 	@SaturdayType  		Int,
 	@WeeklyType			Int,
 	@EPF_Allowed 			Int,
	@OTMin 			Real	,
	@SinMin 			Real	,
	@AppWorkingDays		Numeric  (18,4),
	@OTAllowed			int,
	@AllowedOThRS		Numeric  (18,4),
	@ShiftManagementID int

		
		select @minOTHr_M = MinimumOTHr  , @CompanyOTRate = OTRATE From SystemInfo Where Loca=@Loca    -- Get Min OT Hours As minutes
		if @@Error <>0  set @ErrorSave = @@Error
		
		Declare curAllEmployees Cursor Keyset For select id ,BSal ,emp_type,EmployeeOFFDay,Grade_id,MOT_Allowed,Allowance1,Allowance2,EPF_Allowed,OT_Allowed,ShiftManagementID From employee Where Loca=@loca  and  ( OT_Allowed=1 or MOT_Allowed=1) and active=1 --and empcode='3'
		Open curAllEmployees
		Fetch First From curAllEmployees into @EMPID, @BSal , @emp_type,@EmployeeOFFDay,@Grade_id,@MOT_Allowed,@Allowance1,@Allowance2,@EPF_Allowed,@OTAllowed,@ShiftManagementID
		While @@Fetch_status =0
		Begin			
			Update attendance set attendance.typeofday=calender.DateType from attendance inner join calender on attendance.Working_Date=calender.AttendanceDate and attendance.Loca=calender.Loca where attendance.Working_Date  Between @MonthBegin and @MonthEnd
			if @@Error <>0  set @ErrorSave = @@Error

			
-------------------------GET TIME IN,TIME OUT DETAILS FOR THIS EMPLOYEE	
		
				Declare CurAttend Cursor  Keyset for SELECT  Attendance.ID, Attendance.Time_In, Attendance.TimeOut, Calender.DateType, Attendance.Working_Date, TypeOfDay.OTDATE_Rate, TypeOfDay.DayStartTime, TypeOfDay.DayEndTime, TypeOfDay.OTStartTime, ROSTER.ShiftID, SHIFT.StartTime, SHIFT.EndTime, SHIFT.OTSTARTTIME,  SHIFT.OTENDTIME, SHIFT.SaturdayType, SHIFT.WeeklyType,shift.AllowedOThRS FROM  TypeOfDay INNER JOIN   Calender ON TypeOfDay.ID = Calender.DateType INNER JOIN    Attendance ON Calender.AttendanceDate = Attendance.Working_Date AND Calender.Loca = Attendance.Loca INNER JOIN    ROSTER ON Attendance.Emp_ID = ROSTER.EmpID AND Attendance.Loca = ROSTER.Loca and Attendance.Working_Date = ROSTER.WorkingDate INNER JOIN     SHIFT ON ROSTER.ShiftID = SHIFT.ID AND ROSTER.Loca = SHIFT.Loca Where   TypeOfDay.id=CALENDER.DateType and  AttendanceDate=Working_Date AND Emp_ID=@EMPID  and Working_Date Between @MonthBegin and @MonthEnd and Attendance.Loca=@Loca ORDER BY Attendance.ID
				Open CurAttend
				Fetch First From CurAttend into				@AttendID ,			@TimeIN ,		@TimeOut ,				@TypeofDay ,	@working_DAte,			@OTDAYRATE,				@DayStartTime			,@DayEndTime,			@OTStartTime,			@ShiftIDx,	@ShiftStartTimex,@ShiftEndTimex,@ShiftOTSTARTTIMEx,@ShiftOTENDTIMEx,@SaturdayType,			@WeeklyType,	@AllowedOThRS
				While @@Fetch_Status=0
				Begin
				select  @TimeIN_M = datediff(n, '01/01/1900', ( @TimeIN - @working_DAte  ))--//Punch IN Time (Minit)
				select  @TimeOut_M = datediff(n, '01/01/1900', ( @TimeOut  - @working_DAte ))--//Punch OUT Time (Minit)
					--if @TimeOut_M>1320
					--begin
					--	SET @TimeOut_M=1320
					--end
				select  @ShiftStartTime_M = datediff(n, '01/01/1900', ( @DayStartTime - '01/01/1900' ))
				select  @ShiftEndTime_M = datediff(n, '01/01/1900', ( @DayEndTime  - '01/01/1900' ))
				select  @OTStartTime_M = datediff(n, '01/01/1900', ( @OTStartTime  - '01/01/1900' ))	

				select  @ShiftStartTime_x = datediff(n, '01/01/1900', ( @ShiftStartTimex - '01/01/1900' ))
				select  @ShiftEndTime_x = datediff(n, '01/01/1900', ( @ShiftEndTimex  - '01/01/1900' ))
				select  @OTStartTime_x = datediff(n, '01/01/1900', ( @ShiftOTSTARTTIMEx  - '01/01/1900' ))	
				
				set @LeaveDays=(select isnull(LeaveType,0) from InputLeave where StartDate<= @working_DAte and EndDate>= @working_DAte and Approved=1 and Loca=@Loca and EmpID=@EMPID)
		
				set @OTMinutes_Total=0
				set @AcctualOTHours_Total=0
				set @OTMinutes_1=0
				set @OTMinutes_2=0
				set @OTHours_Total=0
				set @OTAllowance= 0
				set @LateM = 0
				set @NoOfWorkHRS = 0
				set @NoOfWorkMin=0
				set @SinOTHrs	=0
				set @DblOTHrs	=0
				set @OTMin=0
				set @SinMin=0
				set @TblOTHrs= 0	
			
	
			Update Attendance set Attendance.Shift =Roster.shiftID from Attendance INNER JOIN ROSTER ON Attendance.Emp_ID = ROSTER.EmpID AND Attendance.Working_Date = ROSTER.WorkingDate AND Attendance.Loca = ROSTER.Loca WHERE Attendance.EMP_ID=@EMPID AND Attendance.WORKING_DATE =@working_DAte
			if @@Error <>0  set @ErrorSave = @@Error



-------------------------OT First Part  Roster
			if @Grade_id =0	
				begin--//	@Grade_id
						
					if @ShiftStartTime_x<>@ShiftEndTime_x	
						begin
							if @TimeIN_M <=  @ShiftStartTime_x and  @TimeIN_M >=  @OTStartTime_x  
								set @OTMinutes_1  = @ShiftStartTime_x- @TimeIN_M	--floor( @ShiftStartTime_x- @TimeIN_M)--// Morning OT
			
							else if @TimeIN_M <=  @ShiftStartTime_x and  @TimeIN_M <  @OTStartTime_x  
								set @OTMinutes_1 = @ShiftStartTime_x- @TimeIN_M		--floor(@ShiftStartTime_x- @TimeIN_M )				
							else 
								set @OTMinutes_1 = 0
						end
						
---//  IN OT Brake The 30 MIN 
					if  (@OTMinutes_1)-((@OTMinutes_1/30)*30)	>24
						Begin
							set @OTMinutes_1=((@OTMinutes_1/30)*30)+30
						End
					else
						Begin
							set @OTMinutes_1=((@OTMinutes_1/30)*30)
						End
---//  IN OT Brake The 30 MIN --End
	
	
	--Out OT
	
	
	
						
					if @TimeOut_M >  @ShiftEndTime_x 	and  @ShiftStartTime_x<>  @ShiftEndTime_x
					
						if @Timein_M > @ShiftEndTime_x
							begin
							set @OTMinutes_2  =  @TimeOut_M -  @Timein_M		--floor( @TimeOut_M -  @Timein_M)
							end
						else
							Begin							
							set @OTMinutes_2  = @TimeOut_M -  @OTStartTime_x	--floor( @TimeOut_M -  @OTStartTime_x)
								--if   @TimeIN_M-@ShiftStartTime_x>0
								--Begin
								--set @OTMinutes_2=@OTMinutes_-(@TimeIN_M-@ShiftStartTime_x)
								--End
							End	
					else
				
	
						if @ShiftManagementID>0--=34--47
						BEGIN	--//@ShiftManagementID---Showroom
							 --IF @WeeklyType = 1  or @TypeofDay ='8' or   @TypeofDay ='123' or  @TypeofDay ='10' or @TypeofDay ='11' 

	
	
	-- Sunday,poyaday,m.holiday,com.holiday
							 IF @WeeklyType = 1  or  @TypeofDay =1 or  @TypeofDay =8 or @TypeofDay =10 or  @TypeofDay =11
								Begin
								if @Timein_M > @ShiftStartTime_x
									begin 
									
										set @OTMinutes_2  = @TimeOut_M -  @Timein_M			--floor( @TimeOut_M -  @Timein_M)											
									end
								else
									begin
									
										set @OTMinutes_2  =@TimeOut_M -  @ShiftStartTime_x	--floor( @TimeOut_M -  @ShiftStartTime_x)															
										--if   @TimeIN_M-@ShiftStartTime_x>0
										--	Begin
										--	set @OTMinutes_2=@OTMinutes_2-(@TimeIN_M-@ShiftStartTime_x)
										--	End

									end	
								End
						END--//@ShiftManagementID---Showroom
				
				end--//	@Grade_id
				
	--print 'THUSHARA'
	--print @OTMinutes_2
	---- exec NewOT_calculation_Sarasa 1,'2021/04/18','2021/04/18'	
					if @MOT_Allowed  = 1
						begin
							set @OTMinutes_1 =@OTMinutes_1	
							if @@Error <>0  set @ErrorSave = @@Error						
						end		
					else
						begin
							set @OTMinutes_1 =0	
							if @@Error <>0  set @ErrorSave = @@Error						
						end

					if @OTAllowed  =1
						begin
							set @OTMinutes_2 =@OTMinutes_2	
							if @@Error <>0  set @ErrorSave = @@Error						
						end		
					else
						begin
							set @OTMinutes_2 =0	
							if @@Error <>0  set @ErrorSave = @@Error						
						end		
---//  OUT OT Brake The 30 MIN 	
				
				if(@OTMinutes_2>=60)
					begin
						set @OTMinutes_2=(@OTMinutes_2/30)*30							
					end	
				Else
					Begin
						Set @OTMinutes_2=0
					End
						
---//  OUT OT Brake The 30 MIN ---End					
					
					set @OTMinutes_Total = @OTMinutes_1 + @OTMinutes_2							
					if @@Error <>0  set @ErrorSave = @@Error

					

					if @OTMinutes_Total > 0
						begin
							set @OTMinutes_Total = @OTMinutes_Total
							if @@Error <>0  set @ErrorSave = @@Error				
						end	
					else
						begin
							set @OTMinutes_Total = 0
							if @@Error <>0  set @ErrorSave = @@Error				
						end	
					
					--set @AcctualOTHours_Total_D = floor(@OTMinutes_Total /15)/4
					set @AcctualOTHours_Total_D = @OTMinutes_Total/60
					if @@Error <>0  set @ErrorSave = @@Error	

					if @AcctualOTHours_Total_D > 24 
						set @AcctualOTHours_Total_D = 24
						if @@Error <>0  set @ErrorSave = @@Error	
					else						
						set @AcctualOTHours_Total_D =@AcctualOTHours_Total_D					
						if @@Error <>0  set @ErrorSave = @@Error	
					

					 if @AcctualOTHours_Total_D >@AllowedOThRS	
						begin
							set @AcctualOTHours_Total_D = @AllowedOThRS
							if @@Error <>0  set @ErrorSave = @@Error	
						end
					else
						begin
							set @AcctualOTHours_Total_D = @AcctualOTHours_Total_D
							if @@Error <>0  set @ErrorSave = @@Error	
						end

----//  
--if @AcctualOTHours_Total_D-(convert(int,@AcctualOTHours_Total_D))<=0.4
--	Begin 
--		set @AcctualOTHours_Total_D=convert(int,@AcctualOTHours_Total_D)
--	End
--else if (@AcctualOTHours_Total_D-(convert(int,@AcctualOTHours_Total_D)))>0.4 and (@AcctualOTHours_Total_D-(convert(int,@AcctualOTHours_Total_D)))<=0.9
--	Begin 
--		set @AcctualOTHours_Total_D=convert(int,@AcctualOTHours_Total_D)+0.5
--	End
--else if (@AcctualOTHours_Total_D-(convert(int,@AcctualOTHours_Total_D)))>0.9 
--	Begin 
--		set @AcctualOTHours_Total_D=convert(int,@AcctualOTHours_Total_D)+1
--	End
----//

				
				
				IF    @TypeofDay ='1' or @TypeofDay ='8'  or @TypeofDay ='10' 	 or @TypeofDay ='11'
							BEGIN
								set @OTHours_Total_D = @AcctualOTHours_Total_D *1.5
								set @SinOTHrs	=0
								set @DblOTHrs	=0
								set @TblOTHrs=@OTHours_Total_D							
								if @@Error <>0  set @ErrorSave = @@Error
							END
				else
				
					BEGIN
							set @OTHours_Total_D = @AcctualOTHours_Total_D*1.5
							set @SinOTHrs	=0
							set @DblOTHrs	=0
							set @TblOTHrs= 0																	
							if @@Error <>0  set @ErrorSave = @@Error
					END
	
	--if @loca<>4 and @loca<>5
	--Begin
	--	set @OTAllowance = (@OTHours_Total_D ) * ((@BSal+@Allowance1+@Allowance2)/240)						
	--	if @@Error <>0  set @ErrorSave = @@Error
	--end
					
Update Attendance set acctualothours =0, NoOfOT_Hours = 0 ,OTALOWANCE =0 ,otrate=0,SinOTHrs=0,DblOTHrs=0,OTMinutes_Total=0,TblOTHrs=0 Where  ID =@AttendID
					
	--if @loca=4 or @loca=5
	Begin
		set @OTAllowance = (@OTHours_Total_D ) * ((@BSal+@Allowance1+@Allowance2)/208)						
		if @@Error <>0  set @ErrorSave = @@Error
	end				
						
				
					
					Update Attendance set acctualothours =@AcctualOTHours_Total_D, NoOfOT_Hours = @OTHours_Total_D ,OTALOWANCE =@OTAllowance ,otrate=1.5,shift=@ShiftIDx,SinOTHrs=@OTHours_Total_D,DblOTHrs=0,OTMinutes_Total=0,TblOTHrs=0 Where  ID =@AttendID
					if @@Error <>0  set @ErrorSave = @@Error			
						
				Fetch next From CurAttend into  @AttendID , @TimeIN , @TimeOut , @TypeofDay ,  @working_DAte, @OTDAYRATE,@DayStartTime,@DayEndTime,@OTStartTime,@ShiftIDx,@ShiftStartTimex,@ShiftEndTimex,@ShiftOTSTARTTIMEx,@ShiftOTENDTIMEx,@SaturdayType,@WeeklyType,@AllowedOThRS
			end						
				close CurAttend
				deallocate CurAttend				
			Fetch Next From curAllEmployees into @EMPID,@BSal ,@emp_type,@EmployeeOFFDay,@Grade_id,@MOT_Allowed,@Allowance1,@Allowance2,@EPF_Allowed,@OTAllowed,@ShiftManagementID
		End

	Close curAllEmployees
	Deallocate curAllEmployees
/**/




GO

