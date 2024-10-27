--Pregunta 6
--por rangos
SELECT
    at.athlete_sex AS gender,
    COUNT(DISTINCT CASE WHEN ga.edition_year BETWEEN 1896 AND 1912 THEN ft.fk_athlete END) AS "1896-1912",
    COUNT(DISTINCT CASE WHEN ga.edition_year BETWEEN 1912 AND 1924 THEN ft.fk_athlete END) AS "1912-1924",
    COUNT(DISTINCT CASE WHEN ga.edition_year BETWEEN 1924 AND 1936 THEN ft.fk_athlete END) AS "1924-1936",
    COUNT(DISTINCT CASE WHEN ga.edition_year BETWEEN 1936 AND 1948 THEN ft.fk_athlete END) AS "1936-1948",
    COUNT(DISTINCT CASE WHEN ga.edition_year BETWEEN 1948 AND 1960 THEN ft.fk_athlete END) AS "1948-1960",
    COUNT(DISTINCT CASE WHEN ga.edition_year BETWEEN 1960 AND 1972 THEN ft.fk_athlete END) AS "1960-1972",
    COUNT(DISTINCT CASE WHEN ga.edition_year BETWEEN 1972 AND 1984 THEN ft.fk_athlete END) AS "1972-1984",
    COUNT(DISTINCT CASE WHEN ga.edition_year BETWEEN 1984 AND 1996 THEN ft.fk_athlete END) AS "1984-1996",
    COUNT(DISTINCT CASE WHEN ga.edition_year BETWEEN 1996 AND 2008 THEN ft.fk_athlete END) AS "1996-2008",
    COUNT(DISTINCT CASE WHEN ga.edition_year BETWEEN 2008 AND 2022 THEN ft.fk_athlete END) AS "2008-2022"
FROM fact_athlete_event_results ft
JOIN dim_olympic_games ga ON ft.fk_edition = ga.su_edition
JOIN dim_olympic_athlete_bio at ON ft.fk_athlete = at.su_athlete
WHERE at.athlete_sex = 'Female'
GROUP BY at.athlete_sex
ORDER BY at.athlete_sex;
--por años
SELECT
    ga.edition_year,
    COUNT(DISTINCT ft.fk_athlete) AS n_mujeres_particpantes
FROM fact_athlete_event_results ft
JOIN dim_olympic_games ga ON ft.fk_edition = ga.su_edition
JOIN dim_olympic_athlete_bio at ON ft.fk_athlete = at.su_athlete
WHERE at.athlete_sex = 'Female'
GROUP BY ga.edition_year
ORDER BY ga.edition_year;

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
