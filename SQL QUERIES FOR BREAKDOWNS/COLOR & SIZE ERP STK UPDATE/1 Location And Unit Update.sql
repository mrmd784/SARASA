update TransactionDet
set LocationID=2000,UnitNo=400
where LocationID=2 and cast(zdate as date)='2019-01-28'
and Unitno=4


update PaymentDet
set LocationID=2000,UnitNo=400
where LocationID=2 and cast(zdate as date)='2019-01-28'
and Unitno=4