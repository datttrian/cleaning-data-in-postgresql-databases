SELECT
  -- Add 0s to ensure violation_location is 4 characters in length
  LPAD(violation_location, 4, '0') AS violation_location,
  -- Replace 'P-U' with 'TRK' in vehicle_body_type column
  REPLACE(vehicle_body_type, 'P-U', 'TRK') AS vehicle_body_type,
  -- Ensure only first letter capitalized in street_name
  INITCAP(street_name) AS street_name
FROM
  parking_violation;

SELECT
  summons_number,
  CASE
    WHEN summons_number IN (
      SELECT
        summons_number
      FROM
        parking_violation
      WHERE
        -- Match violation_time for morning values
        violation_time SIMILAR TO '\d\d\d\dA'
    ) -- Value when pattern matched
    THEN 1 -- Value when pattern not matched
    ELSE 0
  END AS morning
FROM
  parking_violation;

SELECT
  summons_number,
  -- Replace uppercase letters in plate_id with dash
  REGEXP_REPLACE(plate_id, '[A-Z]', '-', 'g')
FROM
  parking_violation;

-- added/edited
CREATE EXTENSION fuzzystrmatch;

SELECT
  summons_number,
  vehicle_color
FROM
  parking_violation
WHERE
  -- Match SOUNDEX codes of vehicle_color and 'GRAY'
  DIFFERENCE(vehicle_color, 'GRAY') = 4;

UPDATE
  parking_violation
SET
  -- Update vehicle_color to `GRAY`
  vehicle_color = 'GRAY'
WHERE
  summons_number IN (
    SELECT
      summons_number
    FROM
      parking_violation
    WHERE
      DIFFERENCE(vehicle_color, 'GRAY') = 4
      AND -- Filter out records that have GR as vehicle_color
      vehicle_color != 'GR'
  );

SELECT
  summons_number,
  vehicle_color,
  -- Include the DIFFERENCE() value for each color
  DIFFERENCE(vehicle_color, 'RED') AS "red",
  DIFFERENCE(vehicle_color, 'BLUE') AS "blue",
  DIFFERENCE(vehicle_color, 'YELLOW') AS "yellow"
FROM
  parking_violation
WHERE
  (
    -- Condition records on DIFFERENCE() value of 4
    DIFFERENCE(vehicle_color, 'RED') = 4
    OR DIFFERENCE(vehicle_color, 'BLUE') = 4
    OR DIFFERENCE(vehicle_color, 'YELLOW') = 4
  )
SELECT
  summons_number,
  vehicle_color,
  DIFFERENCE(vehicle_color, 'RED') AS "red",
  DIFFERENCE(vehicle_color, 'BLUE') AS "blue",
  DIFFERENCE(vehicle_color, 'YELLOW') AS "yellow"
FROM
  parking_violation
WHERE
  (
    DIFFERENCE(vehicle_color, 'RED') = 4
    OR DIFFERENCE(vehicle_color, 'BLUE') = 4
    OR DIFFERENCE(vehicle_color, 'YELLOW') = 4 -- Exclude records with 'BL' and 'BLA' vehicle colors
  )
  AND vehicle_color NOT SIMILAR TO 'BL|BLA' -- added/edited
  CREATE TABLE red_blue_yellow AS
SELECT
  summons_number,
  vehicle_color,
  DIFFERENCE(vehicle_color, 'RED') AS "red",
  DIFFERENCE(vehicle_color, 'BLUE') AS "blue",
  DIFFERENCE(vehicle_color, 'YELLOW') AS "yellow"
FROM
  parking_violation
WHERE
  (
    DIFFERENCE(vehicle_color, 'RED') = 4
    OR DIFFERENCE(vehicle_color, 'BLUE') = 4
    OR DIFFERENCE(vehicle_color, 'YELLOW') = 4 -- Exclude records with 'BL' and 'BLA' vehicle colors
  )
  AND vehicle_color NOT SIMILAR TO 'BL|BLA'
UPDATE
  parking_violation pv
SET
  vehicle_color = CASE
    -- Complete conditions and results
    WHEN red = 4 THEN 'RED'
    WHEN blue = 4 THEN 'BLUE'
    WHEN yellow = 4 THEN 'YELLOW'
  END
FROM
  red_blue_yellow rby
WHERE
  rby.summons_number = pv.summons_number;

SELECT
  *
FROM
  parking_violation
LIMIT
  10;

SELECT
  -- Add 0s to ensure each event_id is 10 digits in length
  LPAD(CAST(event_id AS TEXT), 10, '0') as event_id,
  -- added/edited
  parking_held
FROM
  film_permit;

SELECT
  LPAD(CAST(event_id AS TEXT), 10, '0') as event_id,
  -- added/edited
  -- Fix capitalization in parking_held column
  INITCAP(parking_held) as parking_held
FROM
  film_permit;

SELECT
  LPAD(CAST(event_id AS TEXT), 10, '0') as event_id,
  -- added/edited
  -- Replace consecutive spaces with a single space
  REGEXP_REPLACE(INITCAP(parking_held), ' +', ' ', 'g') as parking_held
FROM
  film_permit;

UPDATE
  parking_violation
SET
  -- Replace NULL vehicle_body_type values with `Unknown`
  vehicle_body_type = COALESCE(vehicle_body_type, 'Unknown');

SELECT
  COUNT(*)
FROM
  parking_violation
WHERE
  vehicle_body_type = 'Unknown';

SELECT
  -- Define the SELECT list: issuing_agency and num_missing
  issuing_agency,
  COUNT(*) AS num_missing
FROM
  parking_violation
WHERE
  -- Restrict the results to NULL vehicle_body_type values
  vehicle_body_type IS NULL -- Group results by issuing_agency
GROUP BY
  issuing_agency -- Order results by num_missing in descending order
ORDER BY
  num_missing DESC;

SELECT
  summons_number,
  -- Use ROW_NUMBER() to define duplicate column
  ROW_NUMBER() OVER(
    PARTITION BY plate_id,
    issue_date,
    violation_time,
    house_number,
    street_name -- Modify ROW_NUMBER() value to define duplicate column
  ) - 1 AS duplicate,
  plate_id,
  issue_date,
  violation_time,
  house_number,
  street_name
FROM
  parking_violation;

SELECT
  -- Include all columns 
  *
FROM
  (
    SELECT
      summons_number,
      ROW_NUMBER() OVER(
        PARTITION BY plate_id,
        issue_date,
        violation_time,
        house_number,
        street_name
      ) - 1 AS duplicate,
      plate_id,
      issue_date,
      violation_time,
      house_number,
      street_name
    FROM
      parking_violation
  ) sub
WHERE
  -- Only return records where duplicate is 1 or more
  duplicate > 0;

SELECT
  -- Include SELECT list columns
  summons_number,
  MIN(fee) AS fee
FROM
  parking_violation
GROUP BY
  -- Define column for GROUP BY
  summons_number
HAVING
  -- Restrict to summons numbers with count greater than 1
  COUNT(*) > 1;

SELECT
  summons_number,
  plate_id,
  registration_state
FROM
  parking_violation
WHERE
  -- Define the pattern to use for matching
  registration_state NOT SIMILAR TO '[A-Z]{2}';

SELECT
  summons_number,
  plate_id,
  plate_type
FROM
  parking_violation
WHERE
  -- Define the pattern to use for matching
  plate_type NOT SIMILAR TO '[A-Z]{3}';

SELECT
  summons_number,
  plate_id,
  vehicle_make
FROM
  parking_violation
WHERE
  -- Define the pattern to use for matching
  vehicle_make NOT SIMILAR TO '[A-Z/\s]+';

SELECT
  -- Define the columns to return from the query
  summons_number,
  plate_id,
  vehicle_year
FROM
  parking_violation
WHERE
  -- Define the range constraint for invalid vehicle years
  vehicle_year NOT BETWEEN 1970
  AND 2021;

SELECT
  -- Specify return columns
  summons_number,
  violation_time,
  from_hours_in_effect,
  to_hours_in_effect
FROM
  parking_violation
WHERE
  -- Condition on values outside of the restricted range
  violation_time NOT BETWEEN from_hours_in_effect
  AND to_hours_in_effect;

SELECT
  summons_number,
  violation_time,
  from_hours_in_effect,
  to_hours_in_effect
FROM
  parking_violation
WHERE
  -- Exclude results with overnight restrictions
  from_hours_in_effect < to_hours_in_effect
  AND violation_time NOT BETWEEN from_hours_in_effect
  AND to_hours_in_effect;

SELECT
  summons_number,
  violation_time,
  from_hours_in_effect,
  to_hours_in_effect
FROM
  parking_violation
WHERE
  -- Ensure from hours greater than to hours
  from_hours_in_effect > to_hours_in_effect
  AND -- Ensure violation_time less than from hours
  violation_time < from_hours_in_effect
  AND -- Ensure violation_time greater than to hours
  violation_time > to_hours_in_effect;

-- Select all zip codes from the borough of Manhattan
SELECT
  zip_code
FROM
  nyc_zip_codes
WHERE
  borough = 'Manhattan';

SELECT
  event_id,
  CASE
    WHEN zip_code IN (
      SELECT
        zip_code
      FROM
        nyc_zip_codes
      WHERE
        borough = 'Manhattan'
    ) THEN 'Manhattan' -- Match Brooklyn zip codes
    WHEN zip_code IN (
      SELECT
        zip_code
      FROM
        nyc_zip_codes
      WHERE
        borough = 'Brooklyn'
    ) THEN 'Brooklyn' -- Match Bronx zip codes
    WHEN zip_code IN (
      SELECT
        zip_code
      FROM
        nyc_zip_codes
      WHERE
        borough = 'Bronx'
    ) THEN 'Bronx' -- Match Queens zip codes
    WHEN zip_code IN (
      SELECT
        zip_code
      FROM
        nyc_zip_codes
      WHERE
        borough = 'Queens'
    ) THEN 'Queens' -- Match Staten Island zip codes
    WHEN zip_code IN (
      SELECT
        zip_code
      FROM
        nyc_zip_codes
      WHERE
        borough = 'Staten Island'
    ) THEN 'Staten Island' -- Use default for non-matching zip_code
    ELSE NULL
  END as borough
FROM
  film_permit
SELECT
  CASE
    WHEN -- Use true when column value is 'F'
    violation_in_front_of_or_opposite = 'F' THEN true
    WHEN -- Use false when column value is 'O'
    violation_in_front_of_or_opposite = 'O' THEN false
    ELSE NULL
  END AS is_violation_in_front
FROM
  parking_violation;

SELECT
  -- Define the range_size from the max and min summons number
  MAX(summons_number :: BIGINT) - MIN(summons_number :: BIGINT) AS range_size
FROM
  parking_violation;

SELECT
  -- Replace '0' with NULL
  NULLIF(date_first_observed, '0') AS date_first_observed
FROM
  parking_violation;

SELECT
  -- Convert date_first_observed into DATE
  DATE(NULLIF(date_first_observed, '0')) AS date_first_observed
FROM
  parking_violation;

SELECT
  summons_number,
  -- Convert issue_date to a DATE
  DATE(issue_date) AS issue_date,
  -- Convert date_first_observed to a DATE
  CASE
    -- added/edited
    WHEN date_first_observed = '0' THEN NULL
    ELSE DATE(date_first_observed)
  END AS date_first_observed
FROM
  parking_violation;

SELECT
  summons_number,
  -- Display issue_date using the YYYYMMDD format
  TO_CHAR(issue_date, 'YYYYMMDD') AS issue_date,
  -- Display date_first_observed using the YYYYMMDD format
  TO_CHAR(date_first_observed, 'YYYYMMDD') AS date_first_observed
FROM
  (
    SELECT
      summons_number,
      DATE(issue_date) AS issue_date,
      CASE
        -- added/edited
        WHEN date_first_observed <> '0' THEN DATE(date_first_observed)
        ELSE NULL
      END AS date_first_observed
    FROM
      parking_violation
  ) sub
SELECT
  -- Convert violation_time to a TIMESTAMP
  TO_TIMESTAMP(
    -- added/edited
    CASE
      WHEN violation_time ~ '^00' THEN REPLACE(
        REPLACE('12' || SUBSTR(violation_time, 3), 'A', 'AM'),
        'P',
        'PM'
      )
      ELSE REPLACE(REPLACE(violation_time, 'A', 'AM'), 'P', 'PM')
    END,
    'HH12MIPM'
  ) :: TIME AS violation_time
FROM
  parking_violation
WHERE
  -- Exclude NULL violation_time and invalid formats
  violation_time IS NOT NULL -- added/edited
  AND violation_time ~ '^(0[1-9]|1[0-2])[0-5][0-9][AP]$';

+ magic_args = "sql" -- added/edited
SELECT
  -- Populate column with violation_time hours
  EXTRACT(
    'hour'
    FROM
      violation_time
  ) AS hour,
  COUNT(*)
FROM
  (
    SELECT
      -- Convert violation_time to a TIMESTAMP
      TO_TIMESTAMP(
        -- added/edited
        CASE
          WHEN violation_time ~ '^00' THEN REPLACE(
            REPLACE('12' || SUBSTR(violation_time, 3), 'A', 'AM'),
            'P',
            'PM'
          )
          ELSE REPLACE(REPLACE(violation_time, 'A', 'AM'), 'P', 'PM')
        END,
        'HH12MIPM'
      ) :: TIME AS violation_time
    FROM
      parking_violation
    WHERE
      -- Exclude NULL violation_time and invalid formats
      violation_time IS NOT NULL -- added/edited
      AND violation_time ~ '^(0[1-9]|1[0-2])[0-5][0-9][AP]$'
  ) sub
GROUP BY
  hour
ORDER BY
  hour
SELECT
  -- Convert issue_date to a DATE value
  DATE(issue_date) AS issue_date
FROM
  parking_violation;

SELECT
  -- Create issue_day from the day value of issue_date
  EXTRACT(
    'day'
    FROM
      issue_date
  ) AS issue_day,
  -- Include the count of violations for each day
  COUNT(*)
FROM
  (
    SELECT
      -- Convert issue_date to a `DATE` value
      DATE(issue_date) AS issue_date
    FROM
      parking_violation
  ) sub
GROUP BY
  issue_day
ORDER BY
  issue_day;

SELECT
  summons_number,
  -- Convert violation_time to a TIMESTAMP
  TO_TIMESTAMP(violation_time, 'HH12MIPM') :: TIME as violation_time,
  -- Convert to_hours_in_effect to a TIMESTAMP
  TO_TIMESTAMP(to_hours_in_effect, 'HH12MIPM') :: TIME as to_hours_in_effect
FROM
  parking_violation
WHERE
  -- Exclude all day parking restrictions
  NOT (
    from_hours_in_effect = '1200AM'
    AND to_hours_in_effect = '1159PM'
  );

SELECT
  summons_number,
  -- Create column for hours between to_hours_in_effect and violation_time
  EXTRACT(
    'hour'
    FROM
      to_hours_in_effect - violation_time
  ) AS hours,
  -- Create column for minutes between to_hours_in_effect and violation_time
  EXTRACT(
    'minute'
    FROM
      to_hours_in_effect - violation_time
  ) AS minutes
FROM
  (
    SELECT
      summons_number,
      TO_TIMESTAMP(violation_time, 'HH12MIPM') :: time as violation_time,
      TO_TIMESTAMP(to_hours_in_effect, 'HH12MIPM') :: time as to_hours_in_effect
    FROM
      parking_violation
    WHERE
      NOT (
        from_hours_in_effect = '1200AM'
        AND to_hours_in_effect = '1159PM'
      )
  ) sub
SELECT
  -- Return the count of records
  COUNT(*)
FROM
  time_differences
WHERE
  -- Include records with a hours value of 0
  hours = 0
  AND -- Include records with a minutes value of at most 59
  minutes <= 59;

SELECT
  -- Combine street_name, ' & ', and intersecting_street
  street_name || ' & ' || intersecting_street AS corner
FROM
  parking_violation;

SELECT
  -- Include the corner in results
  corner,
  -- Include the total number of violations occurring at corner
  COUNT(*)
FROM
  (
    SELECT
      -- Concatenate street_name, ' & ', and intersecting_street
      street_name || ' & ' || intersecting_street AS corner
    FROM
      parking_violation
  ) sub
WHERE
  -- Exclude corner values that are NULL
  corner IS NOT NULL
GROUP BY
  corner
ORDER BY
  count DESC
SELECT
  -- Concatenate issue_date and violation_time columns
  CONCAT(issue_date, ' ', violation_time) AS violation_datetime
FROM
  parking_violation;

SELECT
  -- Convert violation_time to TIMESTAMP
  TO_TIMESTAMP(violation_datetime, 'MM/DD/YYYY HH12MIAM') AS violation_datetime
FROM
  (
    SELECT
      CONCAT(issue_date, ' ', violation_time) AS violation_datetime
    FROM
      parking_violation
  ) sub;

SELECT
  -- Convert violation_time to TIMESTAMP
  TO_TIMESTAMP(violation_datetime, 'MM/DD/YYYY HH12:MIAM') AS violation_datetime
FROM
  (
    SELECT
      CONCAT(
        issue_date,
        ' ',
        REPLACE(REPLACE(violation_time, 'A', 'AM'), 'P', 'PM')
      ) AS violation_datetime
    FROM
      parking_violation
  ) sub;

SELECT
  -- Define hour column
  SUBSTRING(
    violation_time
    FROM
      1 FOR 2
  ) AS hour
FROM
  parking_violation;

SELECT
  SUBSTRING(
    violation_time
    FROM
      1 FOR 2
  ) AS hour,
  -- Define minute column
  SUBSTRING(
    violation_time
    FROM
      3 FOR 2
  ) AS minute
FROM
  parking_violation;

SELECT
  -- Find the position of first '-'
  STRPOS(house_number, '-') AS dash_position
FROM
  parking_violation;

SELECT
  house_number,
  -- Extract the substring after '-'
  SUBSTRING(
    -- Specify the column of the original house number
    house_number -- Calculate the position that is 1 beyond '-'
    FROM
      STRPOS(house_number, '-') + 1 -- Calculate number characters from dash to end of string
      FOR LENGTH(house_number) - STRPOS(house_number, '-')
  ) AS new_house_number
FROM
  parking_violation;

SELECT
  -- Split house_number using '-' as the delimiter
  SPLIT_PART(house_number, '-', 2) AS new_house_number
FROM
  parking_violation
WHERE
  violation_county = 'Q';

SELECT
  -- Specify SELECT list columns
  street_address,
  violation_county,
  REGEXP_SPLIT_TO_TABLE(days_parking_in_effect, '') AS daily_parking_restriction
FROM
  parking_restriction;

SELECT
  -- Label daily parking restrictions for locations by day
  ROW_NUMBER() OVER(
    PARTITION BY street_address,
    violation_county
    ORDER BY
      street_address,
      violation_county
  ) AS day_number,
  *
FROM
  (
    SELECT
      street_address,
      violation_county,
      REGEXP_SPLIT_TO_TABLE(days_parking_in_effect, '') AS daily_parking_restriction
    FROM
      parking_restriction
  ) sub;

SELECT
  -- Include the violation code in results
  violation_code,
  -- Include the issuing agency in results
  issuing_agency,
  -- Number of records with violation code/issuing agency
  COUNT(*)
FROM
  parking_violation
WHERE
  -- Restrict the results to the agencies of interest
  issuing_agency IN ('P', 'S', 'K', 'V')
GROUP BY
  -- Define GROUP BY columns to ensure correct pair count
  violation_code,
  issuing_agency
ORDER BY
  violation_code,
  issuing_agency;

SELECT
  violation_code,
  -- Define the "Police" column
  COUNT(issuing_agency) FILTER (
    WHERE
      issuing_agency = 'P'
  ) AS "Police",
  -- Define the "Sanitation" column
  COUNT(issuing_agency) FILTER (
    WHERE
      issuing_agency = 'S'
  ) AS "Sanitation",
  -- Define the "Parks" column
  COUNT(issuing_agency) FILTER (
    WHERE
      issuing_agency = 'K'
  ) AS "Parks",
  -- Define the "Transportation" column
  COUNT(issuing_agency) FILTER (
    WHERE
      issuing_agency = 'V'
  ) AS "Transportation"
FROM
  parking_violation
GROUP BY
  violation_code
ORDER BY
  violation_code CREATE
  OR REPLACE TEMP VIEW cb_categories AS
SELECT
  -- Split community board values
  REGEXP_SPLIT_TO_TABLE(community_board, ', ') AS community_board,
  category
FROM
  film_permit
WHERE
  -- Restrict the categories in results
  category IN ('Film', 'Television', 'Documentary');

-- View cb_categories
SELECT
  *
FROM
  cb_categories;

SELECT
  -- Convert community_board data type
  CAST(community_board AS INTEGER) AS community_board,
  -- Define pivot table columns
  COUNT(category) FILTER (
    WHERE
      category = 'Film'
  ) AS "Film",
  COUNT(category) FILTER (
    WHERE
      category = 'Television'
  ) AS "Television",
  COUNT(category) FILTER (
    WHERE
      category = 'Documentary'
  ) AS "Documentary"
FROM
  (
    -- added/edited
    SELECT
      community_board,
      category
    FROM
      cb_categories
    WHERE
      community_board ~ '^[0-9]+$'
  ) AS filtered_cb_categories
GROUP BY
  community_board
ORDER BY
  community_board;
