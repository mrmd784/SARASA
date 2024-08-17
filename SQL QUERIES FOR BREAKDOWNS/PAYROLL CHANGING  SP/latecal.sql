USE [Payroll]
GO

/****** Object:  StoredProcedure [dbo].[NewLate_calculation_Sarasa]    Script Date: 12/06/2023 6:41:06 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER proc [dbo].[NewLate_calculation_Sarasa] (@Loca int ,@MonthBegin DateTime ,@MonthEnd DateTime )

as

Declare @ErrorSave  		Int,
 	@working_DAte 		DateTime,
 	@TimeIN 		DateTime,
	@TimeOut 		DateTime ,
	@TypeofDay 		Int,
	@ShiftID		Int,
 	@EMPID 		Numeric,
	@minOTHr_M		Int,
 	@OTStartTime_M 	Numeric,
 	@ShiftStartTime_M 	Numeric,
 	@ShiftEndTime_M 	Numeric,
 	@OTStartTime		DateTime,
 	@ShiftStartTime		DateTime,
 	@ShiftEndTime 		DateTime,
 	@TimeIN_M 		numeric,
 	@TimeOut_M 		numeric,
	@OTMinutes_1  		Int,
 	@OTMinutes_2 		Int,
 	@OTMinutes_Total 	Numeric(18,2),
	@AcctualOTHours_Total  Numeric(18,2),
 	@OTHours_Total  	Numeric(18,4),
 	@OTDAYRATE  		Real,
 	@CompanyOTRate	Real,
 	@AttendID 		Numeric,
 	@BSal			Numeric(18,4),
 	@OTAllowance 		Numeric(18,4),
 	@emp_type 		Numeric,
 	@DayStartTime		DateTime,
 	@DayEndTime 		DateTime,
 	@LateM 			Int,
 	@LateMo 		Int,
 	@LateEv 		Int,
 	@EmpType 		Int,
 	@EmployeeOFFDay 	Numeric,
 	@ShiftIDx 		Int,
 	@ShiftStartTimex	DateTime,
 	@ShiftEndTimex		DateTime,
 	@ShiftOTSTARTTIMEx	DateTime,
 	@ShiftOTENDTIMEx 	DateTime,
 	@ShiftStartTime_x	Numeric,
 	@ShiftEndTime_x	Numeric,
 	@OTStartTime_x	Numeric,
 	@Grade_id 		Int,
 	@NoOfLateHours 	Real,
 	@LeaveDays		Numeric(18,4),
 	@NoOfDays		Numeric(18,4),
 	@SunAlloAproved	Int,
 	@NoOfDaysFood		Numeric(18,2),
 	@NoOfWorkMin		Numeric(18,2),
 	@NoOfWorkHRS		Numeric(18,2),
 	@LateAproved		Int	,
 	@OTHRS		Numeric(18,2),
 	@MOT_Allowed 		Int,
 	@WorkinDay 		Numeric(18,2),
	@Mint    		Int,
 	@TempH		Int,
	@Working_Hours 	Numeric (18,4),
 	@OTWorking_Hours 	Int,
 	@SaturdayType  	Int,
 	@WeeklyType		Int

		
		Select @minOTHr_M = MinimumOTHr  , @CompanyOTRate = OTRATE From SystemInfo Where Loca=@Loca  
		if @@Error <>0  set @ErrorSave = @@Error

		Declare curAllEmployees Cursor Keyset For select id ,BSal ,emp_type,EmployeeOFFDay,Grade_id,MOT_Allowed  From employee Where Loca=@loca   and active=1 and  ( OT_Allowed=1 or MOT_Allowed=1) --and Salary_Cal_Status=0 
		Open curAllEmployees
		Fetch First From curAllEmployees into @EMPID, @BSal , @emp_type,@EmployeeOFFDay,@Grade_id,@MOT_Allowed
		While @@Fetch_status =0
		Begin			
			print 1
-------------------------GET TIME IN,TIME OUT DETAILS FOR THIS EMPLOYEE				
				Declare CurAttend Cursor  Keyset for SELECT  Attendance.ID, Attendance.Time_In, Attendance.TimeOut, Calender.DateType, Attendance.Working_Date, TypeOfDay.OTDATE_Rate, TypeOfDay.DayStartTime, TypeOfDay.DayEndTime, TypeOfDay.OTStartTime, ROSTER.ShiftID, SHIFT.StartTime, SHIFT.EndTime, SHIFT.OTSTARTTIME,  SHIFT.OTENDTIME,SaturdayType,WeeklyType FROM  TypeOfDay INNER JOIN   Calender ON TypeOfDay.ID = Calender.DateType INNER JOIN    Attendance ON Calender.AttendanceDate = Attendance.Working_Date AND Calender.Loca = Attendance.Loca INNER JOIN    ROSTER ON Attendance.Emp_ID = ROSTER.EmpID AND Attendance.Loca = ROSTER.Loca and Attendance.Working_Date = ROSTER.WorkingDate INNER JOIN     SHIFT ON ROSTER.ShiftID = SHIFT.ID AND ROSTER.Loca = SHIFT.Loca Where   TypeOfDay.id=CALENDER.DateType and  AttendanceDate=Working_Date AND Emp_ID=@EMPID  and Working_Date Between @MonthBegin and @MonthEnd and Attendance.Loca=@Loca ORDER BY Attendance.ID
				Open CurAttend
				Fetch First From CurAttend into  @AttendID , @TimeIN , @TimeOut , @TypeofDay ,  @working_DAte, @OTDAYRATE,@DayStartTime,@DayEndTime,@OTStartTime,@ShiftIDx,@ShiftStartTimex,@ShiftEndTimex,@ShiftOTSTARTTIMEx,@ShiftOTENDTIMEx,@SaturdayType,@WeeklyType
				While @@Fetch_Status=0
				Begin
					select  @TimeIN_M = datediff(n, '01/01/1900', ( @TimeIN - @working_DAte  ))
					select  @TimeOut_M = datediff(n, '01/01/1900', ( @TimeOut  - @working_DAte ))
					select  @ShiftStartTime_M = datediff(n, '01/01/1900', ( @DayStartTime - '01/01/1900' ))
					select  @ShiftEndTime_M = datediff(n, '01/01/1900', ( @DayEndTime  - '01/01/1900' ))
					select  @OTStartTime_M = datediff(n, '01/01/1900', ( @OTStartTime  - '01/01/1900' ))		
					select  @ShiftStartTime_x = datediff(n, '01/01/1900', ( @ShiftStartTimex - '01/01/1900' ))
					select  @ShiftEndTime_x = datediff(n, '01/01/1900', ( @ShiftEndTimex  - '01/01/1900' ))
					select  @OTStartTime_x = datediff(n, '01/01/1900', ( @ShiftOTSTARTTIMEx  - '01/01/1900' ))					
		
					set @OTMinutes_Total=0
					set @AcctualOTHours_Total=0
					set @OTMinutes_1=0
					set @OTMinutes_2=0
					set @OTHours_Total=0
					set @OTAllowance= 0
					set @LateM = 0
					set @NoOfDaysFood=0
					set @NoOfWorkHRS= 0
					set @NoOfWorkMin = 0
					set @NoOfDays = 0
					set @LateAproved = 0
					set @NoOfLateHours= 0
					set @LateMo = 0
					set @LateEv = 0
---------------------------------Calculate Working Hrs	

					if @TimeOut_M > @TimeIN_M
						begin
							set @NoOfWorkMin = (@TimeOut_M - @TimeIN_M)	
							if @@Error <>0  set @ErrorSave = @@Error	
						end
					else
						begin
							set @NoOfWorkMin = 0		
							if @@Error <>0  set @ErrorSave = @@Error								
						end
					print @NoOfWorkMin
					--set @OTWorking_Hours = convert (int,(@NoOfWorkMin/60))		
					if @@Error <>0  set @ErrorSave = @@Error	
			
		  			--set @Mint = @NoOfWorkMin- convert (int,(@NoOfWorkMin/60))*60
					if @@Error <>0  set @ErrorSave = @@Error	
	
					--set @NoOfWorkHRS=@OTWorking_Hours + (@Mint*0.01)		

					set @NoOfWorkHRS=@NoOfWorkMin/60
					if @@Error <>0  set @ErrorSave = @@Error	
					
					
---------------------------------Calculate Late Min								
				IF @TimeIN_M>=(@ShiftStartTime_x )
					begin
						set @LateMo= @TimeIN_M - @ShiftStartTime_x						
						set  @LateAproved = 1
						--if @LateMo<15 
						--begin
						--	set @LateMo=0
						--end
						
						if @@Error <>0  set @ErrorSave = @@Error												
					end
				else
					begin
						set @LateMo = 0
						set @NoOfLateHours= 0
						if @@Error <>0  set @ErrorSave = @@Error	
					end

				IF @TimeOut_M <  (@ShiftEndTime_x ) 
					begin
						set @LateEv= @ShiftEndTime_x - @TimeOut_M	
						set  @LateAproved = 1
						if @@Error <>0  set @ErrorSave = @@Error												
					end
				else
					begin
						set @LateEv = 0
						set @NoOfLateHours= 0
						if @@Error <>0  set @ErrorSave = @@Error	
					end
			
			IF (@WeeklyType = 1 or  @TypeofDay ='11') 
				begin
				set @LateM = 0
				if @@Error <>0  set @ErrorSave = @@Error	
				end
			else 
				begin
				set @LateM =@LateMo+@LateEv
				if @@Error <>0  set @ErrorSave = @@Error	
				end
--print @NoOfWorkHRS

			--if @NoOfWorkHRS < 30 and @NoOfWorkHRS >0 
			--	begin
			--		set @NoOfWorkHRS = @NoOfWorkHRS					
			--		if @@Error <>0  set @ErrorSave = @@Error	
			--	end
			--else
			--	begin
			--		set @NoOfWorkHRS = 0					
			--		if @@Error <>0  set @ErrorSave = @@Error	
			--	end

			if @LateM < 1440 and  @LateM>0
				begin					
					set @LateM= @LateM
					if @@Error <>0  set @ErrorSave = @@Error	
				end
			else
				begin					
					set @LateM = 0
					if @@Error <>0  set @ErrorSave = @@Error	
				end

		
					
	
				IF exists (Select  ID from InputLeave where EmpID = @EmpID and StartDate = @working_date and loca= @Loca )
					Begin
						set @LateM= 0
						if @@Error <>0  set @ErrorSave = @@Error	
					End			

				
				Update Attendance set WorkinDay=@WorkinDay,OTHRS=@OTHRS, LateAproved = @LateAproved ,NoOfLateHours=@NoOfLateHours,NoOfLate_hours= @LateM,NoOfWorkHRS=@NoOfWorkHRS,NoOfDays=@NoOfDays,TypeofDay=@TypeofDay   Where  ID =@AttendID	
				if @@Error <>0  set @ErrorSave = @@Error	
						
				Fetch next From CurAttend into  @AttendID , @TimeIN , @TimeOut , @TypeofDay ,  @working_DAte, @OTDAYRATE,@DayStartTime,@DayEndTime,@OTStartTime,@ShiftIDx,@ShiftStartTimex,@ShiftEndTimex,@ShiftOTSTARTTIMEx,@ShiftOTENDTIMEx,@SaturdayType,@WeeklyType
			
			end	
					
				close CurAttend
				deallocate CurAttend	
			
			Fetch Next From curAllEmployees into @EMPID,@BSal ,@emp_type,@EmployeeOFFDay,@Grade_id,@MOT_Allowed
		End

	Close curAllEmployees
	Deallocate curAllEmployees


--if @ErrorSave <> 0;
--  commit tran


GO

