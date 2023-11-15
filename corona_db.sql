-- printing the whole table 
use corona_final_data;
select*
from data_corona;

-- finding the whole details of the state having high death ratio more than 1
select *
from data_corona
where Death_Ratio > 1
order by Deaths Desc;


-- taking the list of total confirmed cases and death from each states
SELECT 
    State,
    SUM(Total_Cases) AS total_confirmed_cases,
    SUM(Deaths) AS total_deaths
FROM data_corona
GROUP BY State;


-- finding the average affected population percentage for better analytics
SELECT 
AVG(Total_Cases * 100.0 / Population) AS Average_Affected_Population_Percentage 
FROM data_corona;


-- finding the recovery rate of first 5 states 
SELECT State, Active * 100.0 / Total_Cases AS Recovery_Rate 
FROM data_corona 
ORDER BY Recovery_Rate DESC LIMIT 5;


-- finding active discharges per population
WITH CTE AS (
    SELECT State, 
		   Discharged,
           Population, 
           CASE 
                WHEN Population = 0 THEN 0 
                ELSE (Discharged/ Population) 
           END AS Active_Discharges_Per_Population 
    FROM data_corona
)

SELECT State, 
       Discharged, 
       Population, 
       Active_Discharges_Per_Population 
FROM CTE
ORDER BY Active_Discharges_Per_Population ASC;


-- finding death ratio per population
WITH DEATH_RATIO_PER_POPULATION AS (
    SELECT State,
           CASE WHEN Population = 0 THEN 0 ELSE (Death_ratio / Population) END AS Death_Ratio_Per_Population
    FROM data_corona
)

SELECT State,
       Death_Ratio_Per_Population
FROM DEATH_RATIO_PER_POPULATION
ORDER BY Death_Ratio_Per_Population ASC;


-- Total active discharges by grouping state and taking the sum
WITH STATE_LEVEL_ACTIVE_DISCHARGES AS (
  SELECT State,
         SUM(Discharged) AS Total_Active_Discharges
  FROM data_corona
  GROUP BY State
)

SELECT State,
       MAX(Discharged) AS Highest_Active_Discharges
FROM STATE_LEVEL_ACTIVE_DISCHARGES;


-- finding the highest active cases along with corresponding discharges
SELECT
    State,
    Total_Cases,
    Active,
    Discharged
FROM
    data_corona
WHERE
    Active >= '500' AND Active <= '2000'
ORDER BY
    Active;


-- Taking data of zero active ratios
SELECT State, Active_Ratio
FROM data_corona
WHERE active_Ratio >= (
    SELECT AVG(Active_Ratio)
    FROM data_corona
)
ORDER BY Active_Ratio DESC
LIMIT 5;

-- 
SELECT
    state,
    Total_Cases,
    Active,
    Discharged,
    Deaths,
    Active  AS rendering
FROM data_corona
WHERE Total_Cases > 1000  
    AND Deaths BETWEEN '0' AND '1000' 
ORDER BY Total_Cases DESC
LIMIT 10;

