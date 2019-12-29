ALTER TABLE machine_pause_dash ADD date_ref_year int GENERATED ALWAYS AS (year(date_ref)) VIRTUAL NOT NULL;
ALTER TABLE machine_pause_dash ADD date_ref_month int GENERATED ALWAYS AS (month(date_ref)) VIRTUAL NOT NULL;
ALTER TABLE machine_pause_dash ADD date_ref_day int GENERATED ALWAYS AS (day(date_ref)) VIRTUAL NOT NULL;