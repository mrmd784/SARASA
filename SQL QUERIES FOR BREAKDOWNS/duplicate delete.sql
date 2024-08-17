WITH CTE ([ItemCode],[CSCode] ,[LocaCode]
        
,DuplicateCount)
AS
(
  SELECT [ItemCode],[CSCode] ,[LocaCode]
,
  ROW_NUMBER() OVER(PARTITION BY [ItemCode],[CSCode] ,[LocaCode]

   ORDER BY [ItemCode],[CSCode] ,[LocaCode]
) AS DuplicateCount
  FROM dbo.tb_Colour_Size
)
DELETE
FROM CTE
WHERE DuplicateCount > 1


select *
FROM CTE
WHERE DuplicateCount > 1

--DELETE
--FROM CTE
--WHERE DuplicateCount > 1
