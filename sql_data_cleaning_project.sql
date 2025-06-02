select *
from layoffs;

-- create copy of table
create table layoffs_staging
LIKE layoffs;

select *
From layoffs_staging;

insert layoffs_staging
select*
from layoffs;

-- add the row_num to modify the table
select *,
ROW_NUMBER () over (
partition by company, location, industry, total_laid_off, 
percentage_laid_off, 'date', stage, country, funds_raised_millions) as row_num
from layoffs_staging;
-- with is comes to error(some steps are added based on chatgpt advice)---verify notes
WITH duplicate_cte AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY company, location, industry, total_laid_off, 
                            percentage_laid_off, `date`, stage, country, funds_raised_millions
               ORDER BY company  -- Change to any existing column for consistent ordering
           ) AS row_num
    FROM layoffs_staging
);
ALTER TABLE layoffs_staging RENAME COLUMN `date` TO `layoff_date`;

-- try to change date into layoff_date to fix the error, but not fix
WITH duplicate_cte AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY company, location, industry, total_laid_off, 
                            percentage_laid_off, layoff_date, stage, country, funds_raised_millions
               ORDER BY company
           ) AS row_num
    FROM layoffs_staging
)

SELECT *
FROM duplicate_cte
WHERE row_num > 1;

SELECT *
FROM duplicate_cte
WHERE row_num > 1;

-- to check the version of our mysql
SELECT VERSION();


select*
from duplicate_cte
where row_num > 1;

select *
from layoffs_staging
where company='Oda';

-- 1. Delete the duplicate datas
Delete 
from layoffs_staging
where row_num>2;
DESCRIBE layoffs_staging;


-- delete above is not possible
-- for that create 2nd copy of dataset
CREATE TABLE `layoffs_staging2` (
    `company` TEXT,
    `location` TEXT,
    `industry` TEXT,
    `total_laid_off` INT,
    `percentage_laid_off` TEXT,
    `date` TEXT,
    `stage` TEXT,
    `country` TEXT,
    `funds_raised_millions` INT,
    `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select *
from layoffs_staging2;

insert into  layoffs_staging2
select *,
ROW_NUMBER () over (
partition by company, location, industry, total_laid_off, 
percentage_laid_off, 'date', stage, country, funds_raised_millions) as row_num
from layoffs_staging;
-- to set the safe of the datas
SET SQL_SAFE_UPDATES = 0;


-- finaly delete the duplicates
DELETE 
from layoffs_staging2
where row_num > 1;

-- 2. standarize the datas, 
select *
from layoffs_staging2;

-- --company
select company, trim(company)
from layoffs_staging2;

update layoffs_staging2
set company=trim(company);

-- --industry
select distinct(industry)
from layoffs_staging2;


select *
from layoffs_staging2
where industry like 'crypto%';

update layoffs_staging2
set industry=crypto
where industry like 'crypto%';

-- --country
select country, trim(TRAILING '.' from country)
from layoffs_staging2;

update layoffs_staging2
set country =trim(TRAILING '.' from country) 
where country like 'United States%';

-- --date
select `date`,
Str_to_date(`date`, '%m/%d/%Y')
from layoffs_staging2;

update layoffs_staging2
set `date`= Str_to_date(`date`, '%m/%d/%Y');

select *
from layoffs_staging2;

-- change the datatype of date from text to date
ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

-- 3. removing null values
-- --remove null in both total_laidoff, %laid offs,
-- atleast having one is ok..
select *
from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;

-- if we are confident and use in future can delete this 
delete
from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;

-industry
select *
from layoffs_staging2
where industry is null or industry ='';

select  *
from layoffs_staging2
where company='airbnb';

-- to know wt are all the same industry is there to join the 2 as 1 row, by joining the table itself

SELECT t1.industry, t2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
  ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry = '' )
  AND t2.industry IS NOT NULL ;
  
  -- to fill same industries  those same company , there is no blank only have null..
update layoffs_staging2 t1
set industry= null
where industry='';

-- update
update layoffs_staging2 t1
join layoffs_staging2 t2
on t1.company=t2.company
set t1.industry=t2.industry
WHERE (t1.industry IS NULL )
  AND t2.industry IS NOT NULL ;

select *
from layoffs_staging2;

-- remove unnecessary columns
alter table layoffs_staging2
drop column row_num;
