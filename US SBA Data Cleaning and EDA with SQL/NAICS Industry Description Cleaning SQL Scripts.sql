/****** data source https://www.sba.gov/document/support-table-size-standards ******/

 /****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [NAICS Codes]
      ,[NAICS Industry Description]
  FROM [PortfolioProject1].[dbo].[table_of_size_standards-all]

  --DROPING UNWANTED COLUMNS
  ALTER TABLE [table_of_size_standards-all]
  DROP COLUMN 
  [Size standards _in millions of dollars]
  ,[Size standards in number of employees]
  ,[Footnotes]; 

  SELECT *
  FROM [PortfolioProject1].[dbo].[table_of_size_standards-all];


  --SELECT [NAICS Industry Description]
  --FROM [PortfolioProject1].[dbo].[table_of_size_standards-all]
  --WHERE [NAICS Industry Description] LIKE '%Sector %'

  --SELECTING THE SECTOR 
  SELECT [NAICS Industry Description]
  FROM [PortfolioProject1].[dbo].[table_of_size_standards-all]
  WHERE [NAICS Codes] IS NULL 
  AND [NAICS Industry Description] LIKE '%Sector %';

  --EXTRACTING/SEPARATING DESCRIPTION FROM CODE ON THE NAICS Industry Description
  SELECT [NAICS Industry Description],
  IIF([NAICS Industry Description] LIKE '%–%', SUBSTRING([NAICS Industry Description], CHARINDEX('–',[NAICS Industry Description])+1, LEN([NAICS Industry Description])),'') Sector_Description,
--IIF([NAICS Industry Description] LIKE '%–%', SUBSTRING([NAICS Industry Description], 8, 2), '') Lookup_Codes,
  CASE WHEN [NAICS Industry Description] LIKE '%–%' THEN SUBSTRING([NAICS Industry Description], 8, 2) END Sector_Codes
  FROM [PortfolioProject1].[dbo].[table_of_size_standards-all]
  WHERE [NAICS Codes] IS NULL 
  AND [NAICS Industry Description] LIKE '%Sector %';

  --SELECTING RELEVANT DATA POINTS (ROWS WITH THAT HAS LOOKUP CODES IN IT) BY SUB-QUERRYING PREVIOUS CODE
  SELECT *
  FROM(
    SELECT [NAICS Industry Description],
--  IIF([NAICS Industry Description] LIKE '%–%', SUBSTRING([NAICS Industry Description], 8, 2), '') Lookup_Codes,
  CASE WHEN [NAICS Industry Description] LIKE '%–%' THEN LTRIM(SUBSTRING([NAICS Industry Description], CHARINDEX('–',[NAICS Industry Description])+1, LEN([NAICS Industry Description]))) END Sector_Description,
  CASE WHEN [NAICS Industry Description] LIKE '%–%' THEN SUBSTRING([NAICS Industry Description], 8, 2) END Sector_Codes
  FROM [PortfolioProject1].[dbo].[table_of_size_standards-all]
  WHERE [NAICS Codes] IS NULL 
  AND [NAICS Industry Description] LIKE '%Sector %'
  )MAIN
  WHERE 
  Sector_Codes !='';



  --DUMPING RESULTS OF THE EXTRACTED/SEPARATED Sector_Description and Sector_Codes IN A TABLE USING SELECT * INTO 
  --SELECT * INTO IS A GREAT OF MAKING COPIES OF THE DATA/RESULT SET INTO SQL SERVER WITHOUT CREATING THE TABLE FIRST
  --WHATEVER NAME IS PASSED AFTER INTO THIS QUERY CREATES A TABLE OF THAT NAME AND PASS THE RESULT TO THE TABLE
  SELECT *
  INTO sba_naics_sector_description_codes
  FROM(
    SELECT [NAICS Industry Description],
--  IIF([NAICS Industry Description] LIKE '%–%', SUBSTRING([NAICS Industry Description], 8, 2), '') Lookup_Codes,
  CASE WHEN [NAICS Industry Description] LIKE '%–%' THEN LTRIM(SUBSTRING([NAICS Industry Description], CHARINDEX('–',[NAICS Industry Description])+1, LEN([NAICS Industry Description]))) END Sector_Description,
  CASE WHEN [NAICS Industry Description] LIKE '%–%' THEN SUBSTRING([NAICS Industry Description], 8, 2) END Sector_Codes
  FROM [PortfolioProject1].[dbo].[table_of_size_standards-all]
  WHERE [NAICS Codes] IS NULL 
  AND [NAICS Industry Description] LIKE '%Sector %'
  )MAIN
  WHERE 
  Sector_Codes !='';