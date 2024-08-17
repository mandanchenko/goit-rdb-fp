CREATE TABLE IF NOT EXISTS countries (
    id INT AUTO_INCREMENT PRIMARY KEY,
    entity VARCHAR(50),
    code VARCHAR(10)
);

INSERT INTO countries(entity,code)
SELECT DISTINCT infectious_cases.Entity, infectious_cases.Code FROM infectious_cases;

CREATE TABLE IF NOT EXISTS norm_cases LIKE infectious_cases;

ALTER TABLE norm_cases
ADD COLUMN countries_id INT first;

ALTER TABLE norm_cases
ADD CONSTRAINT fk_countries_id
FOREIGN KEY (countries_id)
REFERENCES countries(id);

ALTER TABLE norm_cases
ADD COLUMN id INT AUTO_INCREMENT PRIMARY KEY first;

ALTER TABLE norm_cases
drop column Entity,
drop column Code;

INSERT INTO norm_cases
(
    `countries_id`,
    `Year`,
    `Number_yaws`,
    `polio_cases`,
    `cases_guinea_worm`,
    `Number_rabies`,
    `Number_malaria`,
    `Number_hiv`,
    `Number_tuberculosis`,
    `Number_smallpox`,
    `Number_cholera_cases`)
(
SELECT 
    `id`,
    `Year`,
    `Number_yaws`,
    `polio_cases`,
    `cases_guinea_worm`,
    `Number_rabies`,
    `Number_malaria`,
    `Number_hiv`,
    `Number_tuberculosis`,
    `Number_smallpox`,
    `Number_cholera_cases`
FROM infectious_cases
INNER JOIN countries ON infectious_cases.Entity=countries.entity AND infectious_cases.Code=countries.code);


