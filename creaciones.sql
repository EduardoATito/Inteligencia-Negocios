-----------------------------DIM OLYMPIC EDITIONS-------------------------------
create table dim_olympic_games(
    su_edition number generated always as identity,
    edition_id number,
    edition_name varchar2(3000),
    edition_year number,
    edition_city varchar2(3000),
    edition_start_date varchar2(3000),
    edition_end_date varchar2(3000),
    edition_competition_date varchar2(3000),
    edition_country_noc varchar2(100),
    edition_is_held varchar2(100)
);

ALTER TABLE dim_olympic_games ADD CONSTRAINT dim_olympic_games_pk PRIMARY KEY (su_edition) RELY;
ALTER TABLE dim_olympic_games ADD CONSTRAINT dim_olympic_games_uk UNIQUE (edition_id);

-----------------------------DIM MEDAL RESULTS------------------------------
create table dim_olympic_medal_results(
    su_result number generated always as identity,
    medal_result VARCHAR2(15),
    format_result VARCHAR2(15)
);

ALTER TABLE dim_olympic_medal_results ADD CONSTRAINT dim_medal_results_pk PRIMARY KEY (su_result) RELY;

--------------------------------DIM EVENTS---------------------------
create table dim_olympic_events(
    su_event number generated always as identity,
    event_id number,
    event_title varchar2(3000),
    event_sport varchar2(3000),
    event_date varchar2(3000),
    event_location varchar2(3000),
    event_participants varchar2(3000),
    event_format varchar2(3000),
    event_detail varchar2(3000)
);

ALTER TABLE dim_olympic_events ADD CONSTRAINT dim_olympic_events_pk PRIMARY KEY (su_event) RELY;
ALTER TABLE dim_olympic_events ADD CONSTRAINT dim_olympic_events_uk UNIQUE (event_id);

-----------------------------DIM ATHLETE BIO-------------------------------
create table dim_olympic_athlete_bio(
    su_athlete number,
    athlete_id number,
    athlete_name varchar2(3000),
    athlete_sex varchar2(50),
    athlete_born varchar2(3000),
    athlete_year_born number,
    athlete_height number,
    athlete_weight varchar2(3000),
    date_from date,
    date_to date,
    version number
);

ALTER TABLE dim_olympic_athlete_bio ADD CONSTRAINT dim_olympic_athlete_bio_pk PRIMARY KEY (su_athlete) RELY;

CREATE SEQUENCE OLYMPIC_ATHLETE_BIO_SEQ
  START WITH 1 
  INCREMENT BY 1 
  CACHE 10
  NOCYCLE;
  
---------------------------DIM NOCS---------------------------------

create table dim_olympic_nocs(
    su_noc number,
    noc_code varchar2(50),
    anoc_code varchar2(50),
    country_name varchar2(300),
    continent_name varchar2(300),
    is_active varchar2(50),
    date_from date,
    date_to date,
    version number
);

ALTER TABLE dim_olympic_nocs ADD CONSTRAINT dim_olympic_nocs_pk PRIMARY KEY (su_noc) RELY;

CREATE SEQUENCE OLYMPIC_NOCS_SEQ
  START WITH 1 
  INCREMENT BY 1 
  CACHE 10
  NOCYCLE;
  
---------------------------TABLAS DE HECHOS ATHLETE EVENTS RESULTS----------------------------------

create table fact_athlete_event_results(
    fk_event number constraint fact_athlete_event_event_results_event_nn not null,
    fk_edition number constraint fact_athlete_event_event_results_edition_nn not null,
    fk_result number constraint fact_athlete_event_event_results_result_nn not null,
    fk_athlete number constraint fact_athlete_event_event_results_athlete_nn not null,
    fk_noc number constraint fact_athlete_event_event_results_noc_nn not null
);
--Constraints
alter table fact_athlete_event_results
add constraint fact_aev_dim_olympic_events_fk
foreign key(fk_event)
references dim_olympic_events
rely disable novalidate;

alter table fact_athlete_event_results
add constraint fact_aev_dim_olympic_games_fk
foreign key(fk_edition)
references dim_olympic_games
rely disable novalidate;

alter table fact_athlete_event_results
add constraint fact_aev_dim_olympic_result_fk
foreign key(fk_result)
references dim_olympic_medal_results
rely disable novalidate;

alter table fact_athlete_event_results
add constraint fact_aev_dim_olympic_athlete_bio_fk
foreign key(fk_athlete)
references dim_olympic_athlete_bio
rely disable novalidate;

alter table fact_athlete_event_results
add constraint fact_aev_dim_olympic_nocs_fk
foreign key(fk_noc)
references dim_olympic_nocs
rely disable novalidate;

--Bitmaps

create bitmap index fact_athlete_event_results_fk_event_idx_bm 
on fact_athlete_event_results(fk_event);

create bitmap index fact_athlete_event_results_fk_edition_idx_bm 
on fact_athlete_event_results(fk_edition);

create bitmap index fact_athlete_event_results_fk_medal_result_idx_bm 
on fact_athlete_event_results(fk_result);

create bitmap index fact_athlete_event_results_fk_athlete_idx_bm 
on fact_athlete_event_results(fk_athlete);

create bitmap index fact_athlete_event_results_fk_noc_idx_bm 
on fact_athlete_event_results(fk_noc);

---------------------------TABLAS DE HECHOS OLYMPIC MEDALL TALLY----------------------------------
create table fact_olympic_medal_tally(
    fk_edition number constraint medal_tally_edition_nn not null,
    fk_noc number constraint medal_tally_noc_nn not null,
    gold number,
    silver number,
    bronze number,
    total number
);
--Constraints
alter table fact_olympic_medal_tally
add constraint fact_mtally_dim_olympic_games_fk
foreign key(fk_edition)
references dim_olympic_games
rely disable novalidate;

alter table fact_olympic_medal_tally
add constraint fact_mtally_dim_olympic_nocs_fk
foreign key(fk_noc)
references dim_olympic_nocs
rely disable novalidate;
--Bitmaps
create bitmap index fact_olympic_medal_tally_fk_edition_idx_bm 
on fact_olympic_medal_tally(fk_edition);

create bitmap index fact_olympic_medal_tally_fk_noc_idx_bm 
on fact_olympic_medal_tally(fk_noc);
