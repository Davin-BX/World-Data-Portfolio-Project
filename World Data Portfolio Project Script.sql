--Exploring the Data from the Various Tables

SELECT *
FROM PortfolioProject..cost_of_living col
JOIN PortfolioProject..richest_countries rco
	ON col.country = rco.country
JOIN PortfolioProject..tourism tou
	ON rco.country = tou.country
JOIN PortfolioProject..unemployment une
	ON tou.country = une.country
JOIN PortfolioProject..corruption cor
	ON une.country = cor.country

--Looking at Unemployment Rate VS GDP per Capita (Prosperity of a Country)

SELECT une.country, unemployment_rate, gdp_per_capita
FROM PortfolioProject..unemployment une
JOIN PortfolioProject..richest_countries rco
	ON une.country = rco.country
ORDER BY gdp_per_capita ASC

--Looking at Annual Income by Country
SELECT country, annual_income
FROM PortfolioProject..corruption

--Looking at the Impact of Tourism on the Prosperity of The United States, Norway, Italy, Japan, and South Korea

SELECT rco.country, rco.gdp_per_capita, tou.percentage_of_gdp, SUM(CAST(tou.percentage_of_gdp AS FLOAT))/100*NULLIF(SUM(CAST(rco.gdp_per_capita AS FLOAT)), 0) AS TouristGDPImpact
FROM PortfolioProject..richest_countries rco
JOIN PortfolioProject..tourism tou
	ON rco.country = tou.country
WHERE rco.country IN ('United States', 'Norway', 'Italy', 'Japan', 'South Korea')
GROUP BY rco.country, rco.gdp_per_capita, tou.percentage_of_gdp
ORDER BY rco.gdp_per_capita DESC

--Identifying countries based on GDP per Capita VS Unemployment Rate

SELECT rco.country, rco.gdp_per_capita, une.unemployment_rate
FROM PortfolioProject..richest_countries rco
JOIN PortfolioProject..unemployment une
	ON rco.country = une.country
ORDER BY rco.gdp_per_capita ASC

--Identify the Most Prosperous Country and the Least Prosporous Country

WITH GDP_Stats AS (
    SELECT 
        MAX(CAST(gdp_per_capita AS FLOAT)) AS MaximumGDP,
        MIN(CAST(gdp_per_capita AS FLOAT)) AS MinimumGDP
    FROM PortfolioProject..richest_countries
)
SELECT 
    Country,
    gdp_per_capita
FROM 
    PortfolioProject..richest_countries
WHERE 
    gdp_per_capita = (SELECT MaximumGDP FROM GDP_Stats)
    OR gdp_per_capita = (SELECT MinimumGDP FROM GDP_Stats)

--Organizing all the World Data for Organizational and Analytical Purposes

SELECT *
FROM PortfolioProject..unemployment

DROP TABLE IF EXISTS #GlobalInformation
CREATE TABLE #GlobalInformation
(
Country nvarchar(255),
Annual_income numeric,
Cost_Living_Index numeric,
GDP_per_Capita numeric,
Unemployment_rate numeric,
Corruption_index numeric,
)

SELECT *
FROM #GlobalInformation

INSERT INTO #GlobalInformation
SELECT cor.country, cor.annual_income, col.cost_index, rco.gdp_per_capita, une.unemployment_rate, cor.corruption_index
FROM PortfolioProject..cost_of_living col
JOIN PortfolioProject..richest_countries rco
	ON col.country = rco.country
JOIN PortfolioProject..unemployment une
	ON rco.country = une.country
JOIN PortfolioProject..corruption cor
	ON une.country = cor.country
WHERE cor.country IS NOT NULL

--Identifying the Relationship Between Annual Income, Cost of Living Index, Corruption, GDP Per Capita, and Unemployment

SELECT 
    CASE 
        WHEN Relationship_Income_Costliving > 0.7 THEN 'High correlation'
		WHEN Relationship_Income_Costliving >= 0.3 AND Relationship_Income_Costliving <= 0.7 THEN 'Medium correlation'
        WHEN Relationship_Income_Costliving > 0 AND Relationship_Income_Costliving < 0.3 THEN 'Low correlation'
		WHEN Relationship_Income_Costliving < 0 AND Relationship_Income_Costliving > -0.3 THEN 'Negative Low correlation'
		WHEN Relationship_Income_Costliving <= -0.3 AND Relationship_Income_Costliving >= -0.7 THEN 'Negative Medium correlation'
		WHEN Relationship_Income_Costliving < -0.7 THEN 'Negative High correlation'
        ELSE 'No correlation'
    END AS Income_Costliving_Correl_Category, Relationship_Income_Costliving,
    CASE 
        WHEN Relationship_Income_GDP > 0.7 THEN 'High correlation'
		WHEN Relationship_Income_GDP >= 0.3 AND Relationship_Income_GDP <= 0.7 THEN 'Medium correlation'
        WHEN Relationship_Income_GDP > 0 AND Relationship_Income_GDP < 0.3 THEN 'Low correlation'
		WHEN Relationship_Income_GDP < 0 AND Relationship_Income_GDP > -0.3 THEN 'Negative Low correlation'
		WHEN Relationship_Income_GDP <= -0.3 AND Relationship_Income_GDP >= -0.7 THEN 'Negative Medium correlation'
		WHEN Relationship_Income_GDP < -0.7 THEN 'Negative High correlation'
        ELSE 'No correlation'
    END AS Income_GDP_Correl_Category, Relationship_Income_GDP,
    CASE 
        WHEN Relationship_Income_Unemployment > 0.7 THEN 'High correlation'
		WHEN Relationship_Income_Unemployment >= 0.3 AND Relationship_Income_Unemployment <= 0.7 THEN 'Medium correlation'
        WHEN Relationship_Income_Unemployment > 0 AND Relationship_Income_Unemployment < 0.3 THEN 'Low correlation'
		WHEN Relationship_Income_Unemployment < 0 AND Relationship_Income_Unemployment > -0.3 THEN 'Negative Low correlation'
		WHEN Relationship_Income_Unemployment <= -0.3 AND Relationship_Income_Unemployment >= -0.7 THEN 'Negative Medium correlation'
		WHEN Relationship_Income_Unemployment < -0.7 THEN 'Negative High correlation'
        ELSE 'No correlation'
    END AS Income_Unemployment_Correl_Category, Relationship_Income_Unemployment,
	CASE 
        WHEN Relationship_Income_Corruption > 0.7 THEN 'High correlation'
		WHEN Relationship_Income_Corruption >= 0.3 AND Relationship_Income_Corruption <= 0.7 THEN 'Medium correlation'
        WHEN Relationship_Income_Corruption > 0 AND Relationship_Income_Corruption < 0.3 THEN 'Low correlation'
		WHEN Relationship_Income_Corruption < 0 AND Relationship_Income_Corruption > -0.3 THEN 'Negative Low correlation'
		WHEN Relationship_Income_Corruption <= -0.3 AND Relationship_Income_Corruption >= -0.7 THEN 'Negative Medium correlation'
		WHEN Relationship_Income_Corruption < -0.7 THEN 'Negative High correlation'
        ELSE 'No correlation'
    END AS Income_Corruption_Correl_Category, Relationship_Income_Corruption,
	CASE 
        WHEN Relationship_Costliving_GDP > 0.7 THEN 'High correlation'
		WHEN Relationship_Costliving_GDP >= 0.3 AND Relationship_Costliving_GDP <= 0.7 THEN 'Medium correlation'
        WHEN Relationship_Costliving_GDP > 0 AND Relationship_Costliving_GDP < 0.3 THEN 'Low correlation'
		WHEN Relationship_Costliving_GDP < 0 AND Relationship_Costliving_GDP > -0.3 THEN 'Negative Low correlation'
		WHEN Relationship_Costliving_GDP <= -0.3 AND Relationship_Costliving_GDP >= -0.7 THEN 'Negative Medium correlation'
		WHEN Relationship_Costliving_GDP < -0.7 THEN 'Negative High correlation'
        ELSE 'No correlation'
    END AS Costliving_GDP_Correl_Category, Relationship_Costliving_GDP,
	CASE 
        WHEN Relationship_Costliving_Unemployment > 0.7 THEN 'High correlation'
		WHEN Relationship_Costliving_Unemployment >= 0.3 AND Relationship_Costliving_Unemployment <= 0.7 THEN 'Medium correlation'
        WHEN Relationship_Costliving_Unemployment > 0 AND Relationship_Costliving_Unemployment < 0.3 THEN 'Low correlation'
		WHEN Relationship_Costliving_Unemployment < 0 AND Relationship_Costliving_Unemployment > -0.3 THEN 'Negative Low correlation'
		WHEN Relationship_Costliving_Unemployment <= -0.3 AND Relationship_Costliving_Unemployment >= -0.7 THEN 'Negative Medium correlation'
		WHEN Relationship_Costliving_Unemployment < -0.7 THEN 'Negative High correlation'
        ELSE 'No correlation'
    END AS Costliving_Unemployment_Correl_Category, Relationship_Costliving_Unemployment,
	CASE 
        WHEN Relationship_Costliving_Corruption > 0.7 THEN 'High correlation'
		WHEN Relationship_Costliving_Corruption >= 0.3 AND Relationship_Costliving_Corruption <= 0.7 THEN 'Medium correlation'
        WHEN Relationship_Costliving_Corruption > 0 AND Relationship_Costliving_Corruption < 0.3 THEN 'Low correlation'
		WHEN Relationship_Costliving_Corruption < 0 AND Relationship_Costliving_Corruption > -0.3 THEN 'Negative Low correlation'
		WHEN Relationship_Costliving_Corruption <= -0.3 AND Relationship_Costliving_Corruption >= -0.7 THEN 'Negative Medium correlation'
		WHEN Relationship_Costliving_Corruption < -0.7 THEN 'Negative High correlation'
        ELSE 'No correlation'
    END AS Costliving_Corruption_Correl_Category, Relationship_Costliving_Corruption,
	CASE 
        WHEN Relationship_GDP_Unemployment > 0.7 THEN 'High correlation'
		WHEN Relationship_GDP_Unemployment >= 0.3 AND Relationship_GDP_Unemployment <= 0.7 THEN 'Medium correlation'
        WHEN Relationship_GDP_Unemployment > 0 AND Relationship_GDP_Unemployment < 0.3 THEN 'Low correlation'
		WHEN Relationship_GDP_Unemployment < 0 AND Relationship_GDP_Unemployment > -0.3 THEN 'Negative Low correlation'
		WHEN Relationship_GDP_Unemployment <= -0.3 AND Relationship_GDP_Unemployment >= -0.7 THEN 'Negative Medium correlation'
		WHEN Relationship_GDP_Unemployment < -0.7 THEN 'Negative High correlation'
        ELSE 'No correlation'
    END AS GDP_Unemployment_Correl_Category, Relationship_GDP_Unemployment,
	CASE 
        WHEN Relationship_GDP_Corruption > 0.7 THEN 'High correlation'
		WHEN Relationship_GDP_Corruption >= 0.3 AND Relationship_GDP_Corruption <= 0.7 THEN 'Medium correlation'
        WHEN Relationship_GDP_Corruption > 0 AND Relationship_GDP_Corruption < 0.3 THEN 'Low correlation'
		WHEN Relationship_GDP_Corruption < 0 AND Relationship_GDP_Corruption > -0.3 THEN 'Negative Low correlation'
		WHEN Relationship_GDP_Corruption <= -0.3 AND Relationship_GDP_Corruption >= -0.7 THEN 'Negative Medium correlation'
		WHEN Relationship_GDP_Corruption < -0.7 THEN 'Negative High correlation'
        ELSE 'No correlation'
    END AS GDP_Corruption_Correl_Category, Relationship_GDP_Corruption,
	CASE 
        WHEN Relationship_Unemployment_Corrupt > 0.7 THEN 'High correlation'
		WHEN Relationship_Unemployment_Corrupt >= 0.3 AND Relationship_Unemployment_Corrupt <= 0.7 THEN 'Medium correlation'
        WHEN Relationship_Unemployment_Corrupt > 0 AND Relationship_Unemployment_Corrupt < 0.3 THEN 'Low correlation'
		WHEN Relationship_Unemployment_Corrupt < 0 AND Relationship_Unemployment_Corrupt > -0.3 THEN 'Negative Low correlation'
		WHEN Relationship_Unemployment_Corrupt <= -0.3 AND Relationship_Unemployment_Corrupt >= -0.7 THEN 'Negative Medium correlation'
		WHEN Relationship_Unemployment_Corrupt < -0.7 THEN 'Negative High correlation'
        ELSE 'No correlation'
    END AS Unemployment_Corrupt_Correl_Category, Relationship_GDP_Corruption
FROM (
SELECT 
    ROUND((COUNT(*) * SUM(a * b) - SUM(a) * SUM(b)) /
    (SQRT((COUNT(*) * SUM(a * a) - SUM(a) * SUM(a)) * (COUNT(*) * SUM(b * b) - SUM(b) * SUM(b)))), 2) AS Relationship_Income_Costliving,
	ROUND((COUNT(*) * SUM(a * c) - SUM(a) * SUM(c)) /
    (SQRT((COUNT(*) * SUM(a * a) - SUM(a) * SUM(a)) * (COUNT(*) * SUM(c * c) - SUM(c) * SUM(c)))), 2) AS Relationship_Income_GDP,
	ROUND((COUNT(*) * SUM(a * d) - SUM(a) * SUM(d)) /
    (SQRT((COUNT(*) * SUM(a * a) - SUM(a) * SUM(a)) * (COUNT(*) * SUM(d * d) - SUM(d) * SUM(d)))), 2) AS Relationship_Income_Unemployment,
	ROUND((COUNT(*) * SUM(a * e) - SUM(a) * SUM(e)) /
    (SQRT((COUNT(*) * SUM(a * a) - SUM(a) * SUM(a)) * (COUNT(*) * SUM(e * e) - SUM(e) * SUM(e)))), 2) AS Relationship_Income_Corruption,
	ROUND((COUNT(*) * SUM(b * c) - SUM(b) * SUM(c)) /
    (SQRT((COUNT(*) * SUM(b * b) - SUM(b) * SUM(b)) * (COUNT(*) * SUM(c * c) - SUM(c) * SUM(c)))), 2) AS Relationship_Costliving_GDP,
	ROUND((COUNT(*) * SUM(b * d) - SUM(b) * SUM(d)) /
    (SQRT((COUNT(*) * SUM(b * b) - SUM(b) * SUM(b)) * (COUNT(*) * SUM(d * d) - SUM(d) * SUM(d)))), 2) AS Relationship_Costliving_Unemployment,
	ROUND((COUNT(*) * SUM(b * e) - SUM(b) * SUM(e)) /
    (SQRT((COUNT(*) * SUM(b * b) - SUM(b) * SUM(b)) * (COUNT(*) * SUM(e * e) - SUM(e) * SUM(e)))), 2) AS Relationship_Costliving_Corruption,
	ROUND((COUNT(*) * SUM(c * d) - SUM(c) * SUM(d)) /
    (SQRT((COUNT(*) * SUM(c * c) - SUM(c) * SUM(c)) * (COUNT(*) * SUM(d * d) - SUM(d) * SUM(d)))), 2) AS Relationship_GDP_Unemployment,
	ROUND((COUNT(*) * SUM(c * e) - SUM(c) * SUM(e)) /
    (SQRT((COUNT(*) * SUM(c * c) - SUM(c) * SUM(c)) * (COUNT(*) * SUM(e * e) - SUM(e) * SUM(e)))), 2) AS Relationship_GDP_Corruption,
	ROUND((COUNT(*) * SUM(d * e) - SUM(d) * SUM(e)) /
    (SQRT((COUNT(*) * SUM(d * d) - SUM(d) * SUM(d)) * (COUNT(*) * SUM(e * e) - SUM(e) * SUM(e)))), 2) AS Relationship_Unemployment_Corrupt
FROM (
    SELECT 
        Annual_income AS a, 
        Cost_Living_Index AS b,
		GDP_per_Capita AS c,
		Unemployment_rate AS d,
		Corruption_index AS e
    FROM #GlobalInformation
) AS subquery
) AS Correlation_result