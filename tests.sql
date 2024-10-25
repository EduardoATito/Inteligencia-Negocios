--Pregunta 6
SELECT
    at.athlete_sex AS gender,
    COUNT(CASE WHEN ga.edition_year BETWEEN 1896 AND 1912 THEN 1 END) AS "1896-1912",
    COUNT(CASE WHEN ga.edition_year BETWEEN 1896 AND 1924 THEN 1 END) AS "1896-1924",
    COUNT(CASE WHEN ga.edition_year BETWEEN 1896 AND 1936 THEN 1 END) AS "1896-1936",
    COUNT(CASE WHEN ga.edition_year BETWEEN 1896 AND 1948 THEN 1 END) AS "1896-1948",
    COUNT(CASE WHEN ga.edition_year BETWEEN 1896 AND 1960 THEN 1 END) AS "1896-1960",
    COUNT(CASE WHEN ga.edition_year BETWEEN 1896 AND 1972 THEN 1 END) AS "1896-1972",
    COUNT(CASE WHEN ga.edition_year BETWEEN 1896 AND 1984 THEN 1 END) AS "1896-1984",
    COUNT(CASE WHEN ga.edition_year BETWEEN 1896 AND 1996 THEN 1 END) AS "1896-1996",
    COUNT(CASE WHEN ga.edition_year BETWEEN 1896 AND 2008 THEN 1 END) AS "1896-2008",
    COUNT(CASE WHEN ga.edition_year BETWEEN 1896 AND 2022 THEN 1 END) AS "1896-2018"
FROM fact_athlete_event_results ft
JOIN dim_olympic_games ga ON ft.fk_edition = ga.su_edition
JOIN dim_olympic_athlete_bio at ON ft.fk_athlete = at.su_athlete
AND at.athlete_sex IS NOT NULL
GROUP BY at.athlete_sex
ORDER BY at.athlete_sex;

--Pregunta 7
SELECT
    ev.event_sport AS sport,
    COUNT(CASE WHEN ga.edition_year BETWEEN 1896 AND 1924 THEN 1 END) AS "1896-1924",
    COUNT(CASE WHEN ga.edition_year BETWEEN 1924 AND 1952 THEN 1 END) AS "1924-1952",
    COUNT(CASE WHEN ga.edition_year BETWEEN 1952 AND 1980 THEN 1 END) AS "1952-1980",
    COUNT(CASE WHEN ga.edition_year BETWEEN 1980 AND 2008 THEN 1 END) AS "1980-2008",
    -- Columna de diferencia
    (COUNT(CASE WHEN ga.edition_year BETWEEN 1980 AND 2008 THEN 1 END) - 
     COUNT(CASE WHEN ga.edition_year BETWEEN 1896 AND 1924 THEN 1 END)) AS diff
FROM fact_athlete_event_results ft
JOIN dim_olympic_events ev ON ft.fk_event = ev.su_event 
JOIN dim_olympic_games ga ON ft.fk_edition = ga.su_edition
WHERE ev.event_sport IS NOT NULL
GROUP BY ev.event_sport
ORDER BY diff desc;

--Pregunta 1
SELECT 
    '1896-1930' AS "Year Range",
    SUM(fa.gold) AS gold,
    SUM(fa.silver) AS silver,
    SUM(fa.bronze) AS bronze,
    SUM(fa.total) AS total
FROM 
    fact_olympic_medal_tally fa
JOIN 
    dim_olympic_nocs no ON (fa.fk_noc = no.su_noc)
JOIN 
    dim_olympic_games ga ON (fa.fk_edition = ga.su_edition)
WHERE 
    no.country_name LIKE 'Chile' 
    AND ga.edition_year BETWEEN 1896 AND 1930

UNION ALL

SELECT 
    '1930-1960' AS "Year Range",
    SUM(fa.gold) AS gold,
    SUM(fa.silver) AS silver,
    SUM(fa.bronze) AS bronze,
    SUM(fa.total) AS total
FROM 
    fact_olympic_medal_tally fa
JOIN 
    dim_olympic_nocs no ON (fa.fk_noc = no.su_noc)
JOIN 
    dim_olympic_games ga ON (fa.fk_edition = ga.su_edition)
WHERE 
    no.country_name LIKE 'Chile' 
    AND ga.edition_year BETWEEN 1930 AND 1960

UNION ALL

SELECT 
    '1960-2024' AS "Year Range",
    SUM(fa.gold) AS gold,
    SUM(fa.silver) AS silver,
    SUM(fa.bronze) AS bronze,
    SUM(fa.total) AS total
FROM 
    fact_olympic_medal_tally fa
JOIN 
    dim_olympic_nocs no ON (fa.fk_noc = no.su_noc)
JOIN 
    dim_olympic_games ga ON (fa.fk_edition = ga.su_edition)
WHERE 
    no.country_name LIKE 'Chile' 
    AND ga.edition_year BETWEEN 1960 AND 2008;
