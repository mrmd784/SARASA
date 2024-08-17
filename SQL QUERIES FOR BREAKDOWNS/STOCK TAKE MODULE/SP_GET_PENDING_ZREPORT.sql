USE [EASYWAY]
GO

/****** Object:  StoredProcedure [dbo].[SP_GET_PENDING_ZREPORT]    Script Date: 2024-03-01 11:37:54 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER Proc [dbo].[SP_GET_PENDING_ZREPORT]
@LocaCode Varchar(5),
@Status Int,
@RecDate	Datetime=Null,
@UnitNo	Varchar(5)='',
@ZNo Int=0
As
If (@Status)=1
Begin
	Select Loca,Convert(Datetime,Convert(Varchar,Recdate,103),103) As RecDate,UnitNo,ZNo,Sum(Case Iid When '001' Then Nett When '002' Then -Nett
	When '003' Then Nett When '004' Then -Nett When '006' Then -Nett Else 0 End) As Amount,IsNull(Upload,'F') As Upload
	From tbPosTransact 
	Where (IsNull(Upload,'F')='F' OR IsNull(Upload,'S')='S')
	And Loca=@LocaCode And SaleType='S' And Status=1
	Group By Loca,Convert(Datetime,Convert(Varchar,Recdate,103),103) ,UnitNo,ZNo,Upload
End
Else If (@Status)=2
Begin
	UPDATE tbPostransact SET UPLOAD='S' Where Loca=@LocaCode And Zno=@Zno And UnitNo=@UnitNo And Convert(Datetime,Convert(Varchar(11),RecDate,103),103)=@RecDate And (Isnull(Upload,'F')='F' Or Isnull(Upload,'F')='S')
	UPDATE tbPospayment SET UPLOAD='S' Where Loca=@LocaCode And Zno=@Zno And UnitNo=@UnitNo And Convert(Datetime,Convert(Varchar(11),SDate,103),103)=@RecDate And (Isnull(Upload,'F')='F' Or Isnull(Upload,'F')='S')
End
Else If (@Status)=3
Begin
	UPDATE tbPostransact SET UPLOAD='F' Where Loca=@LocaCode And Upload='S'
	UPDATE tbPospayment SET UPLOAD='F' Where Loca=@LocaCode  And  Upload='S'
End

GO

