DROP TABlE parking_violation;
DROP TABlE film_permit;
DROP TABLE nyc_zip_codes;

CREATE TABLE parking_violation (
    summons_number TEXT,
    plate_id TEXT,
    registration_state TEXT,
    plate_type TEXT,
    issue_date TEXT,
    violation_code TEXT,
    vehicle_body_type TEXT,
    vehicle_make TEXT,
    issuing_agency TEXT,
    street_code1 TEXT,
    street_code2 TEXT,
    street_code3 TEXT,
    vehicle_expiration_date TEXT,
    violation_location TEXT,
    violation_precinct TEXT,
    issuer_precinct TEXT,
    issuer_code TEXT,
    issuer_command TEXT,
    issuer_squad TEXT,
    violation_time TEXT,
    time_first_observed TEXT,
    violation_county TEXT,
    violation_in_front_of_or_opposite TEXT,
    house_number TEXT,
    street_name TEXT,
    intersecting_street TEXT,
    date_first_observed TEXT,
    law_section TEXT,
    sub_division TEXT,
    violation_legal_code TEXT,
    days_parking_in_effect TEXT,
    from_hours_in_effect TEXT,
    to_hours_in_effect TEXT,
    vehicle_color TEXT,
    unregistered_vehicle TEXT,
    vehicle_year TEXT,
    meter_number TEXT,
    feet_from_curb TEXT,
    violation_post_code TEXT,
    violation_description TEXT,
    no_standing_or_stopping_violation TEXT,
    hydrant_violation TEXT,
    double_parking_violation TEXT
);

CREATE TABLE film_permit (
    event_id INT,
    event_type TEXT,
    start_date_time TEXT,
    end_date_time TEXT,
    entered_on TEXT,
    event_agency TEXT,
    parking_held TEXT,
    borough TEXT,
    community_board TEXT,
    police_precinct TEXT,
    category TEXT,
    sub_category_name TEXT,
    country TEXT,
    zip_code TEXT
);

CREATE TABLE nyc_zip_codes (
    borough TEXT,
    zip_code TEXT
);

\copy parking_violation FROM '/tmp/parking_violation.csv' DELIMITER ',' CSV HEADER;
\copy film_permit FROM '/tmp/film_permit.csv' DELIMITER ',' CSV HEADER;
\copy nyc_zip_codes FROM '/tmp/nyc_zip_codes.csv' DELIMITER ',' CSV HEADER;
