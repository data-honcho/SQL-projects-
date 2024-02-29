/****** data source = https://data.sba.gov/dataset/ppp-foia ******/  

/******NB sba_data_table comprises of all 13 public_150k_plus_230930.csv files from the data source that were merged into 1******/

/****** Script for SelectTopNRows command from SSMS  ******/
SELECT *
  FROM [PortfolioProject1].[dbo].[sba_data_table];

  --SUMMARY OF ALL LOANS APPROVED BY THE sba                                                                        table 1 csv
  SELECT 
  COUNT(LoanNumber) Number_of_Approved,
  SUM(InitialApprovalAmount) Approved_Amount,
  AVG(InitialApprovalAmount) Average_1oan_size
  FROM [PortfolioProject1].[dbo].[sba_data_table];


    --SUMMARY OF DIFFERENCES IN LOANS APPROVED IN 2020 AND 2021 by sba by year using set operator                   table 2 csv
  SELECT 
  YEAR(DateApproved) YearApproved,
  COUNT(LoanNumber) Number_of_Approved,
  SUM(InitialApprovalAmount) Approved_Amount,
  AVG(InitialApprovalAmount) Average_1oan_size
  FROM [PortfolioProject1].[dbo].[sba_data_table]
  WHERE 
  YEAR (DateApproved) = 2020
  GROUP BY 
  YEAR(DateApproved)

  UNION  

  SELECT 
  YEAR(DateApproved) YearApproved,
  COUNT(LoanNumber) Number_of_Approved,
  SUM(InitialApprovalAmount) Approved_Amount,
  AVG(InitialApprovalAmount) Average_1oan_size
  FROM [PortfolioProject1].[dbo].[sba_data_table]
  WHERE 
  YEAR (DateApproved) = 2021
  GROUP BY 
  YEAR(DateApproved)


  --ANALYZING THE ORIGINATING LENDERS WHO WERE INVOLVED IN HELPING SMALL BUSINESS GET LOANS IN THE 2 YEARS            table 3 csv
  SELECT 
  COUNT(DISTINCT OriginatingLender) OriginatingLender,
  YEAR (DateApproved) DateApproved,
  COUNT(LoanNumber) Number_of_Approved,
  SUM(InitialApprovalAmount) Approved_Amount,
  AVG(InitialApprovalAmount) Average_1oan_size
  FROM [PortfolioProject1].[dbo].[sba_data_table]
  WHERE 
  YEAR (DateApproved) = 2020
  GROUP BY 
  YEAR (DateApproved)

  UNION

  SELECT 
  COUNT(DISTINCT OriginatingLender) OriginatingLender,
  YEAR (DateApproved) DateApproved,
  COUNT(LoanNumber) Number_of_Approved,
  SUM(InitialApprovalAmount) Approved_Amount,
  AVG(InitialApprovalAmount) Average_1oan_size
  FROM [PortfolioProject1].[dbo].[sba_data_table]
  WHERE 
  YEAR (DateApproved) = 2021
  GROUP BY 
  YEAR (DateApproved);


  --ANALYZING TOP 15 ORIGINATING LENDERS BY LOAN COUNT, TOTAL AMOUNT AND AVERAGE IN 2020 AND 2021                        table 4 csv
  SELECT TOP 15
  OriginatingLender,
  COUNT(LoanNumber) Number_of_Approved,
  SUM(InitialApprovalAmount) Approved_Amount,
  AVG(InitialApprovalAmount) Average_1oan_size
  FROM [PortfolioProject1].[dbo].[sba_data_table]
  WHERE 
  YEAR (DateApproved) = 2020
  GROUP BY 
  OriginatingLender
  ORDER BY 3 DESC;

  
  
  SELECT TOP 15
  OriginatingLender,
  COUNT(LoanNumber) Number_of_Approved,
  SUM(InitialApprovalAmount) Approved_Amount,
  AVG(InitialApprovalAmount) Average_1oan_size
  FROM [PortfolioProject1].[dbo].[sba_data_table]
  WHERE 
  YEAR (DateApproved) = 2021
  GROUP BY 
  OriginatingLender
  ORDER BY 3 DESC;

  --ANALYZING THE TOP INDUSTRY THAT RECEIVED PPP LOANS IT IN 2020 AND 2021											table 5 csv
  SELECT TOP 20
  s.Sector_Description,
  COUNT(LoanNumber) Number_of_Approved,
  SUM(InitialApprovalAmount) Approved_Amount,
  AVG(InitialApprovalAmount) Average_1oan_size
  FROM [PortfolioProject1].[dbo].[sba_data_table] d
  INNER JOIN [PortfolioProject1].[dbo].[sba_naics_sector_description_codes] s
  ON LEFT (d.NAICSCode, 2) = (s.Sector_Codes)
  WHERE 
  YEAR (DateApproved) = 2020
  GROUP BY 
  s.Sector_Description
  ORDER BY 3 DESC;
  
  
  SELECT TOP 20
  s.Sector_Description,
  COUNT(LoanNumber) Number_of_Approved,
  SUM(InitialApprovalAmount) Approved_Amount,
  AVG(InitialApprovalAmount) Average_1oan_size
  FROM [PortfolioProject1].[dbo].[sba_data_table] d
  INNER JOIN [PortfolioProject1].[dbo].[sba_naics_sector_description_codes] s
  ON LEFT (d.NAICSCode, 2) = (s.Sector_Codes)
  WHERE 
  YEAR (DateApproved) = 2021
  GROUP BY 
  s.Sector_Description
  ORDER BY 3 DESC;


  --ANALYZING PERCENTAGE EACH INDUSTRY HAD GOTTEN AS LOAN																	table 6 csv
  WITH CTE AS
  (
    SELECT TOP 20
  s.Sector_Description,
  COUNT(LoanNumber) Number_of_Approved,
  SUM(InitialApprovalAmount) Approved_Amount,
  AVG(InitialApprovalAmount) Average_1oan_size
  FROM [PortfolioProject1].[dbo].[sba_data_table] d
  INNER JOIN [PortfolioProject1].[dbo].[sba_naics_sector_description_codes] s
  ON LEFT (d.NAICSCode, 2) = (s.Sector_Codes)
  WHERE 
  YEAR (DateApproved) = 2020
  GROUP BY 
  s.Sector_Description
  --ORDER BY 3 DESC;
  )
  SELECT Sector_Description, Number_of_Approved, Approved_Amount, Average_1oan_size,
  Approved_Amount/SUM(Approved_Amount) OVER() * 100 LoanPercentByInd
  FROM CTE 
  ORDER BY 
  Approved_Amount DESC



    WITH CTE AS
  (
    SELECT TOP 20
  s.Sector_Description,
  COUNT(LoanNumber) Number_of_Approved,
  SUM(InitialApprovalAmount) Approved_Amount,
  AVG(InitialApprovalAmount) Average_1oan_size
  FROM [PortfolioProject1].[dbo].[sba_data_table] d
  INNER JOIN [PortfolioProject1].[dbo].[sba_naics_sector_description_codes] s
  ON LEFT (d.NAICSCode, 2) = (s.Sector_Codes)
  WHERE 
  YEAR (DateApproved) = 2021
  GROUP BY 
  s.Sector_Description
  --ORDER BY 3 DESC;
  )
  SELECT Sector_Description, Number_of_Approved, Approved_Amount, Average_1oan_size,
  Approved_Amount/SUM(Approved_Amount) OVER() * 100 LoanPercentByInd
  FROM CTE 
  ORDER BY 
  Approved_Amount DESC;


  --ANALYSING THE AMOUNT OF PPP LOAN IN 2020 THAT HAS BEEN FULLY FORGIVEN														table 7 csv
  SELECT 
  COUNT(LoanNumber) Number_of_Approved,
  SUM(CurrentApprovalAmount) Current_Approved_Amount,
  AVG(CurrentApprovalAmount) Current_Average_Loan_Size,
  SUM(ForgivenessAmount) Amount_Forgiven,
  SUM(ForgivenessAmount)/SUM(CurrentApprovalAmount) * 100 Percent_Forgiven
  FROM [PortfolioProject1].[dbo].[sba_data_table]
  WHERE 
  YEAR (DateApproved) = 2020
  ORDER BY 3 DESC
  
  
  SELECT 
  COUNT(LoanNumber) Number_of_Approved,
  SUM(CurrentApprovalAmount) Current_Approved_Amount,
  AVG(CurrentApprovalAmount) Current_Average_Loan_Size,
  SUM(ForgivenessAmount) Amount_Forgiven,
  SUM(ForgivenessAmount)/SUM(CurrentApprovalAmount) * 100 Percent_Forgiven
  FROM [PortfolioProject1].[dbo].[sba_data_table]
  WHERE 
  YEAR (DateApproved) = 2021
  ORDER BY 3 DESC;
  


  --ANALYSING TOTAL AMOUNT OF PPP LOAN THAT HAS BEEN FULLY FORGIVEN														table 8 csv
   SELECT 
  COUNT(LoanNumber) Number_of_Approved,
  SUM(CurrentApprovalAmount) Current_Approved_Amount,
  AVG(CurrentApprovalAmount) Current_Average_Loan_Size,
  SUM(ForgivenessAmount) Amount_Forgiven,
  SUM(ForgivenessAmount)/SUM(CurrentApprovalAmount) * 100 Percent_Forgiven
  FROM [PortfolioProject1].[dbo].[sba_data_table];


  --ANALYZING YEAR AND MONTH WITH HIGHEST PPP LOANS APPROVED
  YEAR (DateApproved) Year_Approved,
  MONTH (DateApproved) Month_Approved,
  COUNT(LoanNumber) Number_of_Approved,
  SUM(InitialApprovalAmount) Total-Net_Dollars,
  AVG(InitialApprovalAmount) Average_1oan_size
  FROM [PortfolioProject1].[dbo].[sba_data_table]
  GROUP BY 
  YEAR (DateApproved),
  MONTH(DateApproved) 
  ORDER BY 4 DESC;
  
