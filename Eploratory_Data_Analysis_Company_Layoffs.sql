-- Eploratory Data Analysis

SELECT *
FROM layoffs_staging2;


SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;


SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;


SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;


SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2;

# MIN(`date`), MAX(`date`)
'2020-03-11', '2023-03-06'


SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

-- top 2 
# industry, SUM(total_laid_off)
'Consumer', '45182'
'Retail', '43613'
-- makes sense considering covid

SELECT *
FROM layoffs_staging2;

 
SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

-- top 4
# country, SUM(total_laid_off)
'United States', '256559'
'India', '35993'
'Netherlands', '17220'
'Sweden', '11264'


SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

-- TOTAL laid off is rising

# YEAR(`date`), SUM(total_laid_off)
'2023', '125677'
'2022', '160661'
'2021', '15823'
'2020', '80998'
NULL, '500'

SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;

-- Top 5

# stage, SUM(total_laid_off)
'Post-IPO', '204132'
'Unknown', '40716'
'Acquired', '27576'
'Series C', '20017'
'Series D', '19225'


SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;

-- Progression of lay-off - Rolling sum

SELECT SUBSTRING(`date`,6,2) AS `MONTH`, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY `MONTH`
;

-- just the month isnt as acurate wont be good when using rolling sum
-- change to year and month

SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC
;

-- layoffs now sorted per month and year
-- Rolling sum
WITH Rolling_Total AS
(
SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC
)
SELECT `MONTH`, total_off,
SUM(total_off) OVER(ORDER BY `MONTH`) AS rolling_total
FROM Rolling_Total;


SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;


SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;




WITH company_year (company, years, total_laid_off) AS
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
), Company_year_rank AS 
(SELECT *, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM company_year
WHERE years IS NOT NULL)
SELECT *
FROM Company_year_rank
WHERE Ranking <= 5
;

-- following results show top 5 companies to lay off employees for each year

# company, years, total_laid_off, Ranking
'Uber', '2020', '7525', '1'
'Booking.com', '2020', '4375', '2'
'Groupon', '2020', '2800', '3'
'Swiggy', '2020', '2250', '4'
'Airbnb', '2020', '1900', '5'
'Bytedance', '2021', '3600', '1'
'Katerra', '2021', '2434', '2'
'Zillow', '2021', '2000', '3'
'Instacart', '2021', '1877', '4'
'WhiteHat Jr', '2021', '1800', '5'
'Meta', '2022', '11000', '1'
'Amazon', '2022', '10150', '2'
'Cisco', '2022', '4100', '3'
'Peloton', '2022', '4084', '4'
'Carvana', '2022', '4000', '5'
'Philips', '2022', '4000', '5'
'Google', '2023', '12000', '1'
'Microsoft', '2023', '10000', '2'
'Ericsson', '2023', '8500', '3'
'Amazon', '2023', '8000', '4'
'Salesforce', '2023', '8000', '4'
'Dell', '2023', '6650', '5'


-- Workout how many ppl were in the company originally total laid off / percentage laid off