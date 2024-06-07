DROP TABlE parking_violation;
DROP TABlE film_permit;

CREATE TABLE parking_violation (
    summons_number BIGINT PRIMARY KEY,
    plate_id VARCHAR(10),
    registration_state VARCHAR(2),
    plate_type VARCHAR(3),
    issue_date DATE,
    violation_code INT,
    vehicle_body_type VARCHAR(10),
    vehicle_make VARCHAR(20),
    issuing_agency VARCHAR(1),
    street_code1 INT,
    street_code2 INT,
    street_code3 INT,
    vehicle_expiration_date INT,
    violation_location VARCHAR(4),
    violation_precinct INT,
    issuer_precinct INT,
    issuer_code INT,
    issuer_command VARCHAR(50),
    issuer_squad VARCHAR(50),
    violation_time VARCHAR(5),
    time_first_observed VARCHAR(5),
    violation_county VARCHAR(50),
    violation_in_front_of_or_opposite VARCHAR(10),
    house_number VARCHAR(10),
    street_name VARCHAR(50),
    intersecting_street VARCHAR(50),
    date_first_observed INT,
    law_section INT,
    sub_division VARCHAR(10),
    violation_legal_code VARCHAR(10),
    days_parking_in_effect VARCHAR(50),
    from_hours_in_effect VARCHAR(5),
    to_hours_in_effect VARCHAR(5),
    vehicle_color VARCHAR(10),
    unregistered_vehicle BOOLEAN,
    vehicle_year INT,
    meter_number VARCHAR(10),
    feet_from_curb INT,
    violation_post_code VARCHAR(10),
    violation_description TEXT,
    no_standing_or_stopping_violation BOOLEAN,
    hydrant_violation BOOLEAN,
    double_parking_violation BOOLEAN
);

CREATE TABLE film_permit (
    event_id VARCHAR(6),
    event_type VARCHAR(255),
    start_date_time TIMESTAMP,
    end_date_time TIMESTAMP,
    entered_on TIMESTAMP,
    event_agency VARCHAR(255),
    parking_held TEXT,
    borough VARCHAR(255),
    community_board VARCHAR(255),
    police_precinct VARCHAR(255),
    category VARCHAR(255),
    sub_category_name VARCHAR(255),
    country VARCHAR(255),
    zip_code VARCHAR(255)
);

\copy parking_violation FROM '/tmp/parking_violation.csv' DELIMITER ',' CSV HEADER;
\copy film_permit FROM '/tmp/film_permit.csv' DELIMITER ',' CSV HEADER;