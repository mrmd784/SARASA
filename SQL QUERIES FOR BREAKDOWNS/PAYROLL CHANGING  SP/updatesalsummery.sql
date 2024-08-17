USE [Payroll]
GO

/****** Object:  StoredProcedure [dbo].[update_SALARYSUMMERY]    Script Date: 12/06/2023 6:41:37 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO




/****** Object:  Stored Procedure dbo.update_SALARYSUMMERY    Script Date: 11/29/04 11:08:28 AM ******/


ALTER PROCEDURE [dbo].[update_SALARYSUMMERY]
	(@MONTHOFSALARY 	[char](6),
	 @LOGONUSER_38 	[char](20),
	 @Loca_39 	[int])

AS 

Begin Tran

Declare @ModDate datetime
set @ModDate=getdate()

UPDATE [SALARYSUMMERY] 

SET -- [MONTHOFSALARY]	 = '',
	 [WORKINGDAYS]	 = 0,
	 [BASICSALARY]	 = 0,
	 [OT_HOURS]	 = 0,
	 [OT_RATE]	 = 0,
	 [OT_Allowance]	 = 0,
	 [ALLOWANCE1]	 = 0,
	 [ALLOWANCE2]	 = 0,
	 [ALLOWANCE3]	 = 0,
	 [ALLOWANCE4]	 = 0,
	 [ALLOWANCE5]	 = 0,
	 [ALLOWANCE6]	 = 0,
	 [ALLOWANCE7]	 = 0,
	 [NOPAY]	 = 0,
	 [DEDUCTION1]	 = 0,
	 [DEDUCTION2]	 = 0,
	 [DEDUCTION3]	 = 0,
	 [DEDUCTION4]	 = 0,
	 [DEDUCTION5]	 = 0,
	 [DEDUCTION6]	 = 0,
	 [DEDUCTION7]	 = 0,
--	 [DEDUCTION8]	 = 0,
--	 [DEDUCTION9]	 = 0,
--	 [DEDUCTION10]	 = 0,
	 [EPF_EMPLOYEE]	 = 0,
	 [EPF]	 = 0,
	 [ETF]	 = 0,
	 [TAX1]	 = 0,
	 [TAX2]	 = 0,
	 [TAX3]	 = 0,
	 [SALARYPAID]	 = 0,
	 [PAIDTYPE]	 = 0,
	 [LASTMODIFIED]	 = @ModDate,
	 [LOGONUSER]	 = @LOGONUSER_38,
	 [Loca]	 = @Loca_39 

WHERE 
	( [MONTHOFSALARY]	 = @MONTHOFSALARY) and [Loca]	 = @Loca_39 


--Delete records whose salary advance and Allowance8,9,10  are  not enetered

delete SALARYSUMMERY WHERE MONTHOFSALARY=ltrim(rtrim(@MONTHOFSALARY)) and [Loca]= @Loca_39 and SALARYADVANCE<1 and Allowance8<1 And Allowance9<1 And Allowance10<1

if @@ERROR<>0 
	RollBack Tran
else
	Commit Tran


GO

