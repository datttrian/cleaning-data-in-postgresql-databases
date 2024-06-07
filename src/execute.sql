SELECT
  -- Add 0s to ensure violation_location is 4 characters in length
  LPAD(CAST(violation_location AS TEXT), 4, '0') AS violation_location,
  -- Replace 'P-U' with 'TRK' in vehicle_body_type column
  REPLACE(vehicle_body_type, 'P-U', 'TRK') AS vehicle_body_type,
  -- Ensure only first letter capitalized in street_name
  INITCAP(street_name) AS street_name
FROM
  parking_violation;
