USE [Payroll]
GO

/****** Object:  StoredProcedure [dbo].[Insert_LeaveAutoUpdate]    Script Date: 12/06/2023 6:40:00 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--exec Insert_LeaveAutoUpdate '2023/03/01','2023/03/31',1
ALTER PROCEDURE [dbo].[Insert_LeaveAutoUpdate]
	(@StartDate DateTime,
	@EndDate DateTime,
	@Loca int)
AS 

BEGIN TRAN
Declare @EmpId Int,
	@CalenderDate DateTime,
	@MonthlyAllowedLeave Numeric(18,2),
	@CompanyLeaveID Numeric(18,2),
	@TakenLeave Numeric(18,2),
	@MonthOfSalary Char(10),
	@OutSerialNo Int,
	@NopayLeaveID Numeric(18,2),
	@Holyday int
	

	DELETE from LeaveInput where DeleteStatus=1

	DECLARE curCalender CURSOR KEYSET FOR SELECT AttendanceDate FROM  Calender WHERE Loca=@Loca and AttendanceDate between  @StartDate and @EndDate ORDER BY AttendanceDate
	OPEN 	curCalender	
		FETCH FIRST FROM  curCalender INTO @CalenderDate
		WHILE @@Fetch_Status = 0		
		BEGIN	
			
			set @Holyday=(select DateType from Calender where AttendanceDate=@CalenderDate)
				
			Delete from LeaveInput WHERE ProcessType='1' AND Loca=@Loca and StartDate  between  @CalenderDate and @CalenderDate  

			DECLARE curEmployee CURSOR KEYSET FOR SELECT Employee.ID FROM  Employee LEFT OUTER JOIN  Attendance ON Employee.id = Attendance.Emp_ID AND Attendance.Working_Date = @CalenderDate Where (Attendance.EMP_id Is Null) And (Employee.Active = 1) and Employee.Loca =@Loca order by Employee.empcode
			OPEN 	curEmployee	
				FETCH FIRST FROM  curEmployee INTO @EmpId
				WHILE @@Fetch_Status = 0		
				BEGIN						
					set @MonthOfSalary = right((year(@CalenderDate) + 10000) ,4 )+ right (( month(@CalenderDate)+100),2)
								
					--Get Company Leave ID
					SET @CompanyLeaveID=0
					SELECT @CompanyLeaveID=Isnull(ID,0)  FROM LeaveMaster WHERE Discription='Company' AND Loca=@Loca	
					--SELECT @CompanyLeaveID=Isnull(Sum(ID),0)  FROM LeaveMaster WHERE Discription='Company' AND Loca=@Loca
					
					SET @NopayLeaveID= 0
					SELECT @NopayLeaveID=Isnull(ID,5)  FROM LeaveMaster WHERE Discription='No Pay' AND Loca=@Loca	
					--SELECT @NopayLeaveID=Isnull(Sum(ID),0)  FROM LeaveMaster WHERE Discription='Nopay' AND Loca=@Loca	

					IF exists(SELECT * FROM LeaveAllocation WHERE LeaveID=@NopayLeaveID AND Loca=@Loca and EmployeeID=@EmpId )
						BEGIN
							SET @MonthlyAllowedLeave=0
							
						END
					else
						BEGIN
							Insert into LeaveAllocation(EmployeeID,LeaveID,AllowedLeave, Loca) Values (@EmpId,@NopayLeaveID,'31',@Loca)
							
						END					
	
					--Monthly Allowed Leave
					SET @MonthlyAllowedLeave=0
					--Print @CompanyLeaveID
					--SELECT @MonthlyAllowedLeave=AllowedLeave  FROM LeaveAllocation WHERE LeaveID=@CompanyLeaveID AND Loca=@Loca and EmployeeID=@EmpId
				
					--Monthly Taken Leave
					SET @TakenLeave= 0
					
					--SELECT @TakenLeave=Isnull(Sum(NoOfDays),0)  FROM LeaveInput WHERE  Loca=@Loca and StartDate  between  @StartDate and @EndDate and EmployeeID=@EmpId and LeaveID<>2
		--exec Insert_LeaveAutoUpdate '2023/01/01','2023/01/31',1

		IF not exists(SELECT * FROM LeaveInput WHERE  Loca=@Loca and EmployeeID=@EmpId and StartDate=@CalenderDate )
		BEGIN	
		print 'sarasa'
		print @MonthlyAllowedLeave 
		print @TakenLeave					
					if @Holyday<>8 and @Holyday<>10 and @Holyday<>11 and @Holyday<>1
					Begin
						INSERT INTO LeaveInput(SerialNo,LeaveID, EmployeeID, StartDate, EndDate,MonthOfSalary,  NoOfDays, LeaveMethodID, Remark,Loca,Approved,ProcessType,LeaveType)  
							VALUES (0,@NopayLeaveID,@EmpId,@CalenderDate,@CalenderDate,@MonthOfSalary,'1','1','No Pay Auto',@Loca,'1','1',1)
					End
		END		
				FETCH NEXT FROM curEmployee INTO @EmpId
				End
			CLOSE curEmployee
			DEALLOCATE curEmployee		
		
		FETCH NEXT FROM curCalender INTO @CalenderDate
		End
	CLOSE curCalender
	DEALLOCATE curCalender

IF @@ERROR<>0
	ROLLBACK TRAN
ELSE
	COMMIT TRAN


GO

