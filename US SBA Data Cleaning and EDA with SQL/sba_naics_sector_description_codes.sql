/****** Script for SelectTopNRows command from SSMS  ******/
SELECT [NAICS Industry Description]
      ,[Sector_Description]
      ,[Sector_Codes]
  FROM [PortfolioProject1].[dbo].[sba_naics_sector_description_codes]
  ORDER BY Sector_Codes



  INSERT INTO [dbo].[sba_naics_sector_description_codes]
  VALUES 
  ('Sector 31 – 33 – Manufacturing', 'Manufacturing', 32),
  ('Sector 31 – 33 – Manufacturing', 'Manufacturing', 33),
  ('Sector 44 - 45 – Retail Trade',  'Retail Trade', 45),
  ('Sector 48 - 49 – Transportation and Warehousing', 'Transportation and Warehousing', 49)

  UPDATE sba_naics_sector_description_codes
  SET Sector_Description = 'Manufacturing'
  WHERE Sector_Codes = 31