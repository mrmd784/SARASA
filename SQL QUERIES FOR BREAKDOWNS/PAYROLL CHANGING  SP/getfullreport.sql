USE [Payroll]
GO

/****** Object:  StoredProcedure [dbo].[Insert_GetFullReport]    Script Date: 12/06/2023 6:38:44 PM ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO




-- exec Insert_GetFullReport '202301',1



ALTER Proc [dbo].[Insert_GetFullReport](@MONTHOFSALARY char(6),@Loca int,@Selection int=0)

as

Begin Tran

Declare @ErrorSave as int,
	@RecNo as int
	
set @ErrorSave =0



set @RecNo= 1 

Delete from GetFullReport where Loca=@Loca
if @@Error <>0  set @ErrorSave =@@Error

Insert Into GetFullReport(EmpID,RowName,Amount,GroupID,Loca) SELECT EMPID,'Basic Salary',BASICSALARY,@RecNo,Loca FROM SALARYSUMMERY  WHERE MONTHOFSALARY=@MONTHOFSALARY AND  Loca=@Loca
if @@Error <>0  set @ErrorSave =@@Error

set @RecNo= @RecNo+1
if @@Error <>0  set @ErrorSave =@@Error

Insert Into GetFullReport(EmpID,RowName,Amount,GroupID,Loca) SELECT EMPID,'Budget Relief Allowance 01',ALLOWANCE1,@RecNo,Loca FROM SALARYSUMMERY  WHERE MONTHOFSALARY=@MONTHOFSALARY AND  Loca=@Loca
if @@Error <>0  set @ErrorSave =@@Error

set @RecNo= @RecNo+1
if @@Error <>0  set @ErrorSave =@@Error

Insert Into GetFullReport(EmpID,RowName,Amount,GroupID,Loca) SELECT EMPID,'Budget Relief Allowance 02',Allowance2,@RecNo,Loca FROM SALARYSUMMERY  WHERE MONTHOFSALARY=@MONTHOFSALARY AND  Loca=@Loca
if @@Error <>0  set @ErrorSave =@@Error

--set @RecNo= @RecNo+1
--if @@Error <>0  set @ErrorSave =@@Error

--Insert Into GetFullReport(EmpID,RowName,Amount,GroupID,Loca) SELECT EMPID,'Working Days',WORKINGDAYS,@RecNo,Loca FROM SALARYSUMMERY WHERE MONTHOFSALARY=@MONTHOFSALARY AND  Loca=@Loca
--if @@Error <>0  set @ErrorSave =@@Error

set @RecNo= @RecNo+1
if @@Error <>0  set @ErrorSave =@@Error

Insert Into GetFullReport(EmpID,RowName,Amount,GroupID,Loca) SELECT EMPID,'Nopay Days',NOPAYDAYS,@RecNo,Loca FROM SALARYSUMMERY WHERE MONTHOFSALARY=@MONTHOFSALARY AND  Loca=@Loca
if @@Error <>0  set @ErrorSave =@@Error

set @RecNo= @RecNo+1
if @@Error <>0  set @ErrorSave =@@Error

Insert Into GetFullReport(EmpID,RowName,Amount,GroupID,Loca) SELECT EMPID,'NoPay Amount',NOPAY,@RecNo,Loca FROM SALARYSUMMERY WHERE MONTHOFSALARY=@MONTHOFSALARY AND  Loca=@Loca
if @@Error <>0  set @ErrorSave =@@Error


set @RecNo= @RecNo+1
if @@Error <>0  set @ErrorSave =@@Error

Insert Into GetFullReport(EmpID,RowName,Amount,GroupID,Loca) SELECT EMPID,'Total For EPF',TotalForEPF,@RecNo,Loca FROM SALARYSUMMERY WHERE MONTHOFSALARY=@MONTHOFSALARY AND  Loca=@Loca
if @@Error <>0  set @ErrorSave =@@Error

set @RecNo= @RecNo+1
if @@Error <>0  set @ErrorSave =@@Error

Insert Into GetFullReport(EmpID,RowName,Amount,GroupID,Loca) SELECT EMPID,'Epf 8%',EPF_EMPLOYEE,@RecNo,Loca FROM SALARYSUMMERY WHERE MONTHOFSALARY=@MONTHOFSALARY AND  Loca=@Loca
if @@Error <>0  set @ErrorSave =@@Error

set @RecNo= @RecNo+1
if @@Error <>0  set @ErrorSave =@@Error

Insert Into GetFullReport(EmpID,RowName,Amount,GroupID,Loca) SELECT EMPID,'Normal OT Hrs',ACCTUAlOTHOURS,@RecNo,Loca FROM SALARYSUMMERY WHERE MONTHOFSALARY=@MONTHOFSALARY AND  Loca=@Loca
if @@Error <>0  set @ErrorSave =@@Error

set @RecNo= @RecNo+1
if @@Error <>0  set @ErrorSave =@@Error

Insert Into GetFullReport(EmpID,RowName,Amount,GroupID,Loca) SELECT EMPID,'Normal OT Amt.',OT_Allowance,@RecNo,Loca FROM SALARYSUMMERY WHERE MONTHOFSALARY=@MONTHOFSALARY AND  Loca=@Loca
if @@Error <>0  set @ErrorSave =@@Error

--set @RecNo= @RecNo+1
--if @@Error <>0  set @ErrorSave =@@Error

--Insert Into GetFullReport(EmpID,RowName,Amount,GroupID,Loca) SELECT EMPID,'Attendance Incentive',ALLOWANCE2,@RecNo,Loca FROM SALARYSUMMERY WHERE MONTHOFSALARY=@MONTHOFSALARY AND  Loca=@Loca
--if @@Error <>0  set @ErrorSave =@@Error

set @RecNo= @RecNo+1
if @@Error <>0  set @ErrorSave =@@Error

Insert Into GetFullReport(EmpID,RowName,Amount,GroupID,Loca) SELECT EmpCode,[Description],AMOUNT,@RecNo,AllowanceForEmp.Loca FROM AllowanceForEmp INNER JOIN Allowance ON AllowanceForEmp.AllowanceID = Allowance.ID   WHERE MONTHOFSALARY=@MONTHOFSALARY AND  AllowanceForEmp.Loca=@Loca
if @@Error <>0  set @ErrorSave =@@Error

set @RecNo= @RecNo+1
if @@Error <>0  set @ErrorSave =@@Error

Insert Into GetFullReport(EmpID,RowName,Amount,GroupID,Loca) SELECT EMPID,'Total Earnings',GROSS_SALARY,@RecNo,Loca FROM SALARYSUMMERY WHERE MONTHOFSALARY=@MONTHOFSALARY AND  Loca=@Loca
if @@Error <>0  set @ErrorSave =@@Error

set @RecNo= @RecNo+1
if @@Error <>0  set @ErrorSave =@@Error

Insert Into GetFullReport(EmpID,RowName,Amount,GroupID,Loca) SELECT EmpCode,[Description],AMOUNT,@RecNo,DeductionForEmp.Loca FROM DeductionForEmp INNER JOIN Deduction ON DeductionForEmp.DeductionID = Deduction.ID WHERE MONTHOFSALARY=@MONTHOFSALARY AND DeductionForEmp.Loca=@Loca
if @@Error <>0  set @ErrorSave =@@Error

set @RecNo =@RecNo+1
if @@Error <>0  set @ErrorSave =@@Error

Insert Into GetFullReport(EmpID,RowName,Amount,GroupID,Loca) SELECT EMPID,'Salary Advance',SALARYADVANCE,@RecNo,Loca FROM SALARYSUMMERY WHERE MONTHOFSALARY=@MONTHOFSALARY AND  Loca=@Loca
if @@Error <>0  set @ErrorSave =@@Error
/*
set @RecNo= @RecNo+1
if @@Error <>0  set @ErrorSave =@@Error*/

/*Insert Into GetFullReport(EmpID,RowName,Amount,GroupID,Loca) SELECT EMPID,'Total Night Days',NightDays,@RecNo,Loca FROM SALARYSUMMERY WHERE MONTHOFSALARY=@MONTHOFSALARY AND  Loca=@Loca
if @@Error <>0  set @ErrorSave =@@Error


set @RecNo= @RecNo+1
if @@Error <>0  set @ErrorSave =@@Error

Insert Into GetFullReport(EmpID,RowName,Amount,GroupID,Loca) SELECT EMPID,'Night Shift Incentive',ALLOWANCE3,@RecNo,Loca FROM SALARYSUMMERY WHERE MONTHOFSALARY=@MONTHOFSALARY AND  Loca=@Loca
if @@Error <>0  set @ErrorSave =@@Error

set @RecNo= @RecNo+1
if @@Error <>0  set @ErrorSave =@@Error*/


--set @RecNo =@RecNo + 1
--if @@Error <>0  set @ErrorSave =@@Error

--Insert Into GetFullReport(EmpID,RowName,Amount,GroupID,Loca) SELECT EMPID,'Salary Advance',SALARYADVANCE,@RecNo,Loca FROM SALARYSUMMERY WHERE MONTHOFSALARY=@MONTHOFSALARY AND  Loca=@Loca
--if @@Error <>0  set @ErrorSave =@@Error

--set @RecNo =@RecNo + 1
--if @@Error <>0  set @ErrorSave =@@Error

--Insert Into GetFullReport(EmpID,RowName,Amount,GroupID,Loca) SELECT EMPID,'Late Deduction',DEDUCTION1,@RecNo,Loca FROM SALARYSUMMERY WHERE MONTHOFSALARY=@MONTHOFSALARY AND  Loca=@Loca
--if @@Error <>0  set @ErrorSave =@@Error


--set @RecNo= @RecNo+1
--if @@Error <>0  set @ErrorSave =@@Error

--Insert Into GetFullReport(EmpID,RowName,Amount,GroupID,Loca) SELECT   LoanSchedule.EMPID,Loan.Description, LoanSchedule.InstallmentValue,@RecNo,Loan_For_Employee.Loca FROM  LoanSchedule INNER JOIN    Loan_For_Employee ON LoanSchedule.Loan_For_EmplyeeID = Loan_For_Employee.ID INNER JOIN    Loan ON Loan_For_Employee.LoanID = Loan.ID where Loan_For_Employee.Loca=@Loca and payigMonth =@MONTHOFSALARY
--if @@Error <>0  set @ErrorSave =@@Error

set @RecNo= @RecNo+1
if @@Error <>0  set @ErrorSave =@@Error


Insert Into GetFullReport(EmpID,RowName,Amount,GroupID,Loca) SELECT EMPID,'Total Deduction',Total_Deduction,@RecNo,Loca FROM SALARYSUMMERY WHERE MONTHOFSALARY=@MONTHOFSALARY AND  Loca=@Loca
if @@Error <>0  set @ErrorSave =@@Error

set @RecNo= @RecNo+1
if @@Error <>0  set @ErrorSave =@@Error

Insert Into GetFullReport(EmpID,RowName,Amount,GroupID,Loca) SELECT EMPID,'NET SALARY',SALARYPAID,@RecNo,Loca FROM SALARYSUMMERY WHERE MONTHOFSALARY=@MONTHOFSALARY AND  Loca=@Loca
if @@Error <>0  set @ErrorSave =@@Error

--set @RecNo= @RecNo+1
--if @@Error <>0  set @ErrorSave =@@Error

--Insert Into GetFullReport(EmpID,RowName,Amount,GroupID,Loca) SELECT EMPID,'Epf 8%',EPF_EMPLOYEE,@RecNo,Loca FROM SALARYSUMMERY WHERE MONTHOFSALARY=@MONTHOFSALARY AND  Loca=@Loca
--if @@Error <>0  set @ErrorSave =@@Error

set @RecNo= @RecNo+1
if @@Error <>0  set @ErrorSave =@@Error

Insert Into GetFullReport(EmpID,RowName,Amount,GroupID,Loca) SELECT Employee.ID,'Signature','0.00',@RecNo,SALARYSUMMERY.Loca FROM Employee INNER JOIN  SALARYSUMMERY ON Employee.id = SALARYSUMMERY.EMPID  where SALARYSUMMERY.Loca=@Loca and  MONTHOFSALARY=@MONTHOFSALARY
if @@Error <>0  set @ErrorSave =@@Error

set @RecNo= @RecNo+1
if @@Error <>0  set @ErrorSave =@@Error

Insert Into GetFullReport(EmpID,RowName,Amount,GroupID,Loca) SELECT EMPID,'Epf 12%',EPF,@RecNo,Loca FROM SALARYSUMMERY WHERE MONTHOFSALARY=@MONTHOFSALARY AND  Loca=@Loca
if @@Error <>0  set @ErrorSave =@@Error

set @RecNo= @RecNo+1
if @@Error <>0  set @ErrorSave =@@Error

Insert Into GetFullReport(EmpID,RowName,Amount,GroupID,Loca) SELECT EMPID,'Epf 3%',ETF,@RecNo,Loca FROM SALARYSUMMERY WHERE MONTHOFSALARY=@MONTHOFSALARY AND  Loca=@Loca
if @@Error <>0  set @ErrorSave =@@Error

set @RecNo= @RecNo+1
if @@Error <>0  set @ErrorSave =@@Error




UPDATE GetFullReport SET GetFullReport.AID = '1',GetFullReport.DepartmentID= SALARYSUMMERY.DepartmentID,GetFullReport.DivisionID= SALARYSUMMERY.DivisionID FROM GetFullReport INNER JOIN
                      SALARYSUMMERY ON GetFullReport.EmpID = SALARYSUMMERY.EMPID
where SALARYSUMMERY.Loca=@Loca and  MONTHOFSALARY=@MONTHOFSALARY 

DELETE FROM GetFullReport WHERE GetFullReport.AID = '0'
if @ErrorSave<> 0
       rollback transaction
else
     commit transaction
GO

