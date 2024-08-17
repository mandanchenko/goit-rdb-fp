/**3. Робота з Number_rabies**/
select countries_id,
    avg(Number_rabies) as averege_rabies,
    min(Number_rabies) as minsmal_rabies,
    max(Number_rabies) as maximal_rabies,
    sum(Number_rabies) as summ_rabies
from norm_cases
where Number_rabies <> '' and Number_rabies is not null
group by countries_id
order by averege_rabies DESC
limit 10;

/**4. Робота з датами**/
ALTER TABLE norm_cases
ADD COLUMN first_day DATE AFTER Year;

ALTER TABLE norm_cases
ADD COLUMN cur_date DATE AFTER first_day;

ALTER TABLE norm_cases
ADD COLUMN year_dif INT AFTER cur_date;

SET SQL_SAFE_UPDATES = 0;
UPDATE norm_cases
SET 
    first_day = STR_TO_DATE(CONCAT(Year, '-01-01'), '%Y-%m-%d'),
    cur_date = CURDATE(),
    year_dif = TIMESTAMPDIFF(YEAR, first_day, cur_date)
WHERE Year is not NULL;
SET SQL_SAFE_UPDATES = 1;

SELECT Year, first_day, cur_date, year_dif FROM norm_cases;

/**5. Функція**/
DROP FUNCTION IF EXISTS CalculateYears;
DELIMITER //

CREATE FUNCTION CalculateYears(input_year year)
RETURNS INT
DETERMINISTIC 
NO SQL

BEGIN
    RETURN TIMESTAMPDIFF(YEAR, STR_TO_DATE(CONCAT(input_year, '-01-01'), '%Y-%m-%d'), CURDATE());
END //

DELIMITER ;

ALTER TABLE norm_cases
ADD COLUMN year_dif_func INT AFTER year_dif;

SET SQL_SAFE_UPDATES = 0;
UPDATE norm_cases
SET 
    year_dif_func = CalculateYears(Year);
SET SQL_SAFE_UPDATES = 1;

SELECT Year, cur_date, year_dif, year_dif_func FROM norm_cases;
