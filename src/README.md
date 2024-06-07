# Cleaning Data in PostgreSQL Databases


```python
pip install sqlalchemy psycopg2 ipython-sql
```

    Defaulting to user installation because normal site-packages is not writeable
    Requirement already satisfied: sqlalchemy in /home/vscode/.local/lib/python3.12/site-packages (2.0.30)
    Requirement already satisfied: psycopg2 in /home/vscode/.local/lib/python3.12/site-packages (2.9.9)
    Requirement already satisfied: ipython-sql in /home/vscode/.local/lib/python3.12/site-packages (0.5.0)
    Requirement already satisfied: typing-extensions>=4.6.0 in /home/vscode/.local/lib/python3.12/site-packages (from sqlalchemy) (4.12.1)
    Requirement already satisfied: greenlet!=0.4.17 in /home/vscode/.local/lib/python3.12/site-packages (from sqlalchemy) (3.0.3)
    Requirement already satisfied: prettytable in /home/vscode/.local/lib/python3.12/site-packages (from ipython-sql) (3.10.0)
    Requirement already satisfied: ipython in /home/vscode/.local/lib/python3.12/site-packages (from ipython-sql) (8.25.0)
    Requirement already satisfied: sqlparse in /home/vscode/.local/lib/python3.12/site-packages (from ipython-sql) (0.5.0)
    Requirement already satisfied: six in /home/vscode/.local/lib/python3.12/site-packages (from ipython-sql) (1.16.0)
    Requirement already satisfied: ipython-genutils in /home/vscode/.local/lib/python3.12/site-packages (from ipython-sql) (0.2.0)
    Requirement already satisfied: decorator in /home/vscode/.local/lib/python3.12/site-packages (from ipython->ipython-sql) (5.1.1)
    Requirement already satisfied: jedi>=0.16 in /home/vscode/.local/lib/python3.12/site-packages (from ipython->ipython-sql) (0.19.1)
    Requirement already satisfied: matplotlib-inline in /home/vscode/.local/lib/python3.12/site-packages (from ipython->ipython-sql) (0.1.7)
    Requirement already satisfied: prompt-toolkit<3.1.0,>=3.0.41 in /home/vscode/.local/lib/python3.12/site-packages (from ipython->ipython-sql) (3.0.46)
    Requirement already satisfied: pygments>=2.4.0 in /home/vscode/.local/lib/python3.12/site-packages (from ipython->ipython-sql) (2.18.0)
    Requirement already satisfied: stack-data in /home/vscode/.local/lib/python3.12/site-packages (from ipython->ipython-sql) (0.6.3)
    Requirement already satisfied: traitlets>=5.13.0 in /home/vscode/.local/lib/python3.12/site-packages (from ipython->ipython-sql) (5.14.3)
    Requirement already satisfied: pexpect>4.3 in /home/vscode/.local/lib/python3.12/site-packages (from ipython->ipython-sql) (4.9.0)
    Requirement already satisfied: wcwidth in /home/vscode/.local/lib/python3.12/site-packages (from prettytable->ipython-sql) (0.2.13)
    Requirement already satisfied: parso<0.9.0,>=0.8.3 in /home/vscode/.local/lib/python3.12/site-packages (from jedi>=0.16->ipython->ipython-sql) (0.8.4)
    Requirement already satisfied: ptyprocess>=0.5 in /home/vscode/.local/lib/python3.12/site-packages (from pexpect>4.3->ipython->ipython-sql) (0.7.0)
    Requirement already satisfied: executing>=1.2.0 in /home/vscode/.local/lib/python3.12/site-packages (from stack-data->ipython->ipython-sql) (2.0.1)
    Requirement already satisfied: asttokens>=2.1.0 in /home/vscode/.local/lib/python3.12/site-packages (from stack-data->ipython->ipython-sql) (2.4.1)
    Requirement already satisfied: pure-eval in /home/vscode/.local/lib/python3.12/site-packages (from stack-data->ipython->ipython-sql) (0.2.2)
    Note: you may need to restart the kernel to use updated packages.



```python
%load_ext sql
%sql postgresql://postgres:postgres@localhost/local
%config SqlMagic.autolimit = 10
```

    The sql extension is already loaded. To reload it, use:
      %reload_ext sql


## Data Cleaning Basics

### Applying functions for string cleaning

Throughout this course, we will be using a dataset with 5000 New York
City parking violation records stored in the `parking_violation` table.

A service to provide parking violation recipients with a hard copy of
the violation is being re-designed. For proper formatting of the output
of the information on the report, some fields needs to be changed from
the database representation. The changes are as follows:

- For proper text alignment on the form, `violation_location` values
  must be 4 characters in length.
- All `P-U` (pick-up truck) values in the `vehicle_body_type` column
  should use a general `TRK` value.
- Only the first letter in each word in the `street_name` column should
  be capitalized.

The `LPAD()`, `REPLACE()`, and `INITCAP()` functions will be used to
effect these changes.

**Instructions**

- Add `'0'` to the beginning of any `violation_location` that is less
  than **4 digits** in length using the `LPAD()` function.
- Replace `'P-U'` with `'TRK'` in values within the `vehicle_body_type`
  column using the `REPLACE()` function.
- Ensure that only the first letter of words in the `street_name` column
  are capitalized using the `INITCAP()` function.

**Answer**


```sql
%%sql
SELECT
  -- Add 0s to ensure violation_location is 4 characters in length
  LPAD(violation_location, 4, '0') AS violation_location,
  -- Replace 'P-U' with 'TRK' in vehicle_body_type column
  REPLACE(vehicle_body_type, 'P-U', 'TRK') AS vehicle_body_type,
  -- Ensure only first letter capitalized in street_name
  INITCAP(street_name) AS street_name
FROM
  parking_violation;
```

     * postgresql://postgres:***@localhost/local
    5000 rows affected.





<table>
    <thead>
        <tr>
            <th>violation_location</th>
            <th>vehicle_body_type</th>
            <th>street_name</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>0026</td>
            <td>SDN</td>
            <td>Old Broadway</td>
        </tr>
        <tr>
            <td>0026</td>
            <td>SDN</td>
            <td>W 126 Street</td>
        </tr>
        <tr>
            <td>0026</td>
            <td>SUBN</td>
            <td>W 125 St</td>
        </tr>
        <tr>
            <td>0026</td>
            <td>SDN</td>
            <td>W 125 St</td>
        </tr>
        <tr>
            <td>0026</td>
            <td>None</td>
            <td>St Nicholas Avenue</td>
        </tr>
        <tr>
            <td>0026</td>
            <td>SUBN</td>
            <td>W 125 St</td>
        </tr>
        <tr>
            <td>0026</td>
            <td>SUBN</td>
            <td>W 126 St</td>
        </tr>
        <tr>
            <td>0026</td>
            <td>SUBN</td>
            <td>W 125 St</td>
        </tr>
        <tr>
            <td>0026</td>
            <td>SUBN</td>
            <td>W 126 St</td>
        </tr>
        <tr>
            <td>0026</td>
            <td>SDN</td>
            <td>Saint Nicholas Ave</td>
        </tr>
    </tbody>
</table>



### Classifying parking violations by time of day

There have been some concerns raised that parking violations are not
being issued uniformly throughout the day. You have been tasked with
associating parking violations with the time of day of issuance. You
determine that the simplest approach to completing this task is to
create a new column named `morning`. This field will be populated with
(the integer) `1` if the violation was issued in the morning (between
12:00 AM and 11:59 AM), and, (the integer) `0`, otherwise. The time of
issuance is recorded in the `violation_time` column of the
`parking_violation` table. This column consists of 4 digits followed by
an `A` (for `AM`) or `P` (for `PM`).

In this exercise, you will populate the `morning` column by matching
patterns for `violation_time`s occurring in the morning.

**Instructions**

- Use the regular expression pattern `'\d\d\d\dA'` in the sub-query to
  match `violation_time` values consisting of 4 consecutive digits
  (`\d`) followed by an uppercase `A`.
- Edit the `CASE` clause to populate the `morning` column with `1`
  (integer without quotes) when the regular expression is matched.
- Edit the `CASE` clause to populate the `morning` column with `0`
  (integer without quotes) when the regular expression is not matched.

**Answer**



```sql
%%sql
SELECT 
	summons_number, 
    CASE WHEN 
    	summons_number IN (
          SELECT 
  			summons_number 
  		  FROM 
  			parking_violation 
  		  WHERE 
            -- Match violation_time for morning values
  			violation_time SIMILAR TO '\d\d\d\dA'
    	)
        -- Value when pattern matched
        THEN 1 
        -- Value when pattern not matched
        ELSE 0 
    END AS morning 
FROM 
	parking_violation;
```

     * postgresql://postgres:***@localhost/local
    5000 rows affected.





<table>
    <thead>
        <tr>
            <th>summons_number</th>
            <th>morning</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>1447152396</td>
            <td>1</td>
        </tr>
        <tr>
            <td>1447152402</td>
            <td>1</td>
        </tr>
        <tr>
            <td>1447152554</td>
            <td>1</td>
        </tr>
        <tr>
            <td>1447152580</td>
            <td>1</td>
        </tr>
        <tr>
            <td>1447152724</td>
            <td>1</td>
        </tr>
        <tr>
            <td>1447152992</td>
            <td>0</td>
        </tr>
        <tr>
            <td>1447153315</td>
            <td>0</td>
        </tr>
        <tr>
            <td>1447153327</td>
            <td>0</td>
        </tr>
        <tr>
            <td>1447153340</td>
            <td>1</td>
        </tr>
        <tr>
            <td>1447153352</td>
            <td>0</td>
        </tr>
    </tbody>
</table>



### Masking identifying information with regular expressions

Regular expressions can also be used to replace patterns in strings
using `REGEXP_REPLACE()`. The function is similar to the `REPLACE()`
function. Its signature is
`REGEXP_REPLACE(source, pattern, replace, flags)`.

- `pattern` is the string pattern to match in the `source` string.
- `replace` is the replacement string to use in place of the pattern.
- `flags` is an optional string used to control matching.

For example, `REGEXP_REPLACE(xyz, '\d', '_', 'g')` would replace any
digit character (`\d`) in the column `xyz` with an underscore (`_`). The
`g` ("global") flag ensures every match is replaced.

To protect parking violation recipients' privacy in a new web report,
all letters in the `plate_id` column must be replaced with a dash (`-`)
to mask the true license plate number.

**Instructions**

- Use `REGEXP_REPLACE()` to replace all uppercase letters (`A` to `Z`)
  in the `plate_id` column with a dash character (`-`) so that masked
  license plate numbers can be used in the report.

**Answer**



```sql
%%sql
SELECT 
	summons_number,
	-- Replace uppercase letters in plate_id with dash
	REGEXP_REPLACE(plate_id, '[A-Z]', '-', 'g') 
FROM 
	parking_violation;
```

     * postgresql://postgres:***@localhost/local
    5000 rows affected.





<table>
    <thead>
        <tr>
            <th>summons_number</th>
            <th>regexp_replace</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>1447152396</td>
            <td>---2661</td>
        </tr>
        <tr>
            <td>1447152402</td>
            <td>---6523</td>
        </tr>
        <tr>
            <td>1447152554</td>
            <td>---6954</td>
        </tr>
        <tr>
            <td>1447152580</td>
            <td>---1641</td>
        </tr>
        <tr>
            <td>1447152724</td>
            <td>---8069</td>
        </tr>
        <tr>
            <td>1447152992</td>
            <td>---5242</td>
        </tr>
        <tr>
            <td>1447153315</td>
            <td>---3470</td>
        </tr>
        <tr>
            <td>1447153327</td>
            <td>---9640</td>
        </tr>
        <tr>
            <td>1447153340</td>
            <td>---1769</td>
        </tr>
        <tr>
            <td>1447153352</td>
            <td>---2184</td>
        </tr>
    </tbody>
</table>



### Matching inconsistent color names

From the sample of records in the `parking_violation` table, it is clear
that the `vehicle_color` values are not consistent. For example,
`'GRY'`, `'GRAY'`, and `'GREY'` are all used to describe a gray vehicle.
In order to consistently represent this color, it is beneficial to use a
single value. Fortunately, the `DIFFERENCE()` function can be used to
accomplish this goal.

In this exercise, you will use the `DIFFERENCE()` function to return
records that contain a `vehicle_color` value that closely matches the
string `'GRAY'`. The `fuzzystrmatch` module has already been enabled for
you.

**Instructions**

- Use the `DIFFERENCE()` function to find `parking_violation` records
  having a `vehicle_color` with a Soundex code that matches the Soundex
  code for `'GRAY'`. Recall that the `DIFFERENCE()` function accepts
  string values (**not** Soundex codes) as parameter arguments.

**Answer**



```sql
%%sql
-- added/edited
CREATE EXTENSION fuzzystrmatch;
```

     * postgresql://postgres:***@localhost/local
    (psycopg2.errors.DuplicateObject) extension "fuzzystrmatch" already exists
    
    [SQL: -- added/edited
    CREATE EXTENSION fuzzystrmatch;]
    (Background on this error at: https://sqlalche.me/e/20/f405)



```sql
%%sql
SELECT
  summons_number,
  vehicle_color
FROM
  parking_violation
WHERE
  -- Match SOUNDEX codes of vehicle_color and 'GRAY'
  DIFFERENCE(vehicle_color, 'GRAY') = 4;
```

     * postgresql://postgres:***@localhost/local
    791 rows affected.





<table>
    <thead>
        <tr>
            <th>summons_number</th>
            <th>vehicle_color</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>1447152396</td>
            <td>GRY</td>
        </tr>
        <tr>
            <td>1447153819</td>
            <td>GR</td>
        </tr>
        <tr>
            <td>1447155877</td>
            <td>GRAY</td>
        </tr>
        <tr>
            <td>1447222775</td>
            <td>GREY</td>
        </tr>
        <tr>
            <td>1447247929</td>
            <td>GR</td>
        </tr>
        <tr>
            <td>1447261707</td>
            <td>GRAY</td>
        </tr>
        <tr>
            <td>1447261720</td>
            <td>GRAY</td>
        </tr>
        <tr>
            <td>1447261781</td>
            <td>GRAY</td>
        </tr>
        <tr>
            <td>1447270228</td>
            <td>GRY</td>
        </tr>
        <tr>
            <td>1447275470</td>
            <td>GRAY</td>
        </tr>
    </tbody>
</table>



### Standardizing color names

In the previous exercise, the `DIFFERENCE()` function was used to
identify colors that closely matched our desired representation of the
color `GRAY`. However, this approach retained a number of records where
the `vehicle_color` value may or may not be gray. Specifically, the
string `GR` (green) has the same Soundex code as the string `GRAY`.
Fortunately, records with these `vehicle_color` values can be excluded
from the set of records that should be changed.

In this exercise, you will assign a consistent gray `vehicle_color`
value by identifying similar strings that represent the same color.
Again, the `fuzzystrmatch` module has already been installed for you.

**Instructions**

- Complete the `SET` clause to assign `'GRAY'` as the `vehicle_color`
  for records with a `vehicle_color` value having a matching Soundex
  code to the Soundex code for `'GRAY'`.
- Update the `WHERE` clause of the subquery so that the `summons_number`
  values returned **exclude** `summons_number` values from records with
  `'GR'` as the `vehicle_color` value.

**Answer**



```sql
%%sql
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
        DIFFERENCE(vehicle_color, 'GRAY') = 4 AND
        -- Filter out records that have GR as vehicle_color
        vehicle_color != 'GR'
);
```

     * postgresql://postgres:***@localhost/local
    740 rows affected.





    []



### Standardizing multiple colors

After the success of standardizing the naming of `GRAY`-colored
vehicles, you decide to extend this approach to additional colors. The
primary colors `RED`, `BLUE`, and `YELLOW` will be used for extending
the color name standardization approach. In this exercise, you will:

- Find `vehicle_color` values that are similar to `RED`, `BLUE`, or
  `YELLOW`.
- Handle both the ambiguous `vehicle_color` value `BL` and the
  incorrectly identified `vehicle_color` value `BLA` using pattern
  matching.
- Update the `vehicle_color` values with strong similarity to `RED`,
  `BLUE`, or `YELLOW` to the standard string values.

**Instructions**

- Generate columns (`red`, `blue`, `yellow`) storing the `DIFFERENCE()`
  value for each `vehicle_color` compared to the strings `RED`, `BLUE`,
  and `YELLOW`.
- Restrict the returned records to those with a `DIFFERENCE()` value of
  `4` for one of `RED`, `BLUE`, or `YELLOW`.

**Answer**



```sql
%%sql
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
		DIFFERENCE(vehicle_color, 'RED') = 4 OR
		DIFFERENCE(vehicle_color, 'BLUE') = 4 OR
		DIFFERENCE(vehicle_color, 'YELLOW') = 4
	)
```

     * postgresql://postgres:***@localhost/local
    748 rows affected.





<table>
    <thead>
        <tr>
            <th>summons_number</th>
            <th>vehicle_color</th>
            <th>red</th>
            <th>blue</th>
            <th>yellow</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>1447155294</td>
            <td>RD</td>
            <td>4</td>
            <td>2</td>
            <td>2</td>
        </tr>
        <tr>
            <td>1447169335</td>
            <td>BLUE</td>
            <td>2</td>
            <td>4</td>
            <td>3</td>
        </tr>
        <tr>
            <td>1447171275</td>
            <td>RED</td>
            <td>4</td>
            <td>2</td>
            <td>2</td>
        </tr>
        <tr>
            <td>1447171287</td>
            <td>BLUE</td>
            <td>2</td>
            <td>4</td>
            <td>3</td>
        </tr>
        <tr>
            <td>1447184294</td>
            <td>BLU</td>
            <td>2</td>
            <td>4</td>
            <td>3</td>
        </tr>
        <tr>
            <td>1447209140</td>
            <td>RED</td>
            <td>4</td>
            <td>2</td>
            <td>2</td>
        </tr>
        <tr>
            <td>1447248739</td>
            <td>BLA</td>
            <td>2</td>
            <td>4</td>
            <td>3</td>
        </tr>
        <tr>
            <td>1447261744</td>
            <td>BLUE</td>
            <td>2</td>
            <td>4</td>
            <td>3</td>
        </tr>
        <tr>
            <td>1447273680</td>
            <td>BLU</td>
            <td>2</td>
            <td>4</td>
            <td>3</td>
        </tr>
        <tr>
            <td>1447293149</td>
            <td>BLU</td>
            <td>2</td>
            <td>4</td>
            <td>3</td>
        </tr>
    </tbody>
</table>







```sql
%%sql
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
		DIFFERENCE(vehicle_color, 'RED') = 4 OR
		DIFFERENCE(vehicle_color, 'BLUE') = 4 OR
		DIFFERENCE(vehicle_color, 'YELLOW') = 4
    -- Exclude records with 'BL' and 'BLA' vehicle colors
	) AND vehicle_color NOT SIMILAR TO 'BL|BLA'
```

     * postgresql://postgres:***@localhost/local
    598 rows affected.





<table>
    <thead>
        <tr>
            <th>summons_number</th>
            <th>vehicle_color</th>
            <th>red</th>
            <th>blue</th>
            <th>yellow</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>1447155294</td>
            <td>RD</td>
            <td>4</td>
            <td>2</td>
            <td>2</td>
        </tr>
        <tr>
            <td>1447169335</td>
            <td>BLUE</td>
            <td>2</td>
            <td>4</td>
            <td>3</td>
        </tr>
        <tr>
            <td>1447171275</td>
            <td>RED</td>
            <td>4</td>
            <td>2</td>
            <td>2</td>
        </tr>
        <tr>
            <td>1447171287</td>
            <td>BLUE</td>
            <td>2</td>
            <td>4</td>
            <td>3</td>
        </tr>
        <tr>
            <td>1447184294</td>
            <td>BLU</td>
            <td>2</td>
            <td>4</td>
            <td>3</td>
        </tr>
        <tr>
            <td>1447209140</td>
            <td>RED</td>
            <td>4</td>
            <td>2</td>
            <td>2</td>
        </tr>
        <tr>
            <td>1447261744</td>
            <td>BLUE</td>
            <td>2</td>
            <td>4</td>
            <td>3</td>
        </tr>
        <tr>
            <td>1447273680</td>
            <td>BLU</td>
            <td>2</td>
            <td>4</td>
            <td>3</td>
        </tr>
        <tr>
            <td>1447293149</td>
            <td>BLU</td>
            <td>2</td>
            <td>4</td>
            <td>3</td>
        </tr>
        <tr>
            <td>1447295250</td>
            <td>RD</td>
            <td>4</td>
            <td>2</td>
            <td>2</td>
        </tr>
    </tbody>
</table>




```sql
%%sql
-- added/edited
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
		DIFFERENCE(vehicle_color, 'RED') = 4 OR
		DIFFERENCE(vehicle_color, 'BLUE') = 4 OR
		DIFFERENCE(vehicle_color, 'YELLOW') = 4
    -- Exclude records with 'BL' and 'BLA' vehicle colors
	) AND vehicle_color NOT SIMILAR TO 'BL|BLA'
```

     * postgresql://postgres:***@localhost/local
    (psycopg2.errors.DuplicateTable) relation "red_blue_yellow" already exists
    
    [SQL: -- added/edited
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
    		DIFFERENCE(vehicle_color, 'RED') = 4 OR
    		DIFFERENCE(vehicle_color, 'BLUE') = 4 OR
    		DIFFERENCE(vehicle_color, 'YELLOW') = 4
        -- Exclude records with 'BL' and 'BLA' vehicle colors
    	) AND vehicle_color NOT SIMILAR TO 'BL|BLA']
    (Background on this error at: https://sqlalche.me/e/20/f405)






```sql
%%sql
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
    
SELECT * FROM parking_violation LIMIT 10;
```

     * postgresql://postgres:***@localhost/local
    598 rows affected.
    10 rows affected.





<table>
    <thead>
        <tr>
            <th>summons_number</th>
            <th>plate_id</th>
            <th>registration_state</th>
            <th>plate_type</th>
            <th>issue_date</th>
            <th>violation_code</th>
            <th>vehicle_body_type</th>
            <th>vehicle_make</th>
            <th>issuing_agency</th>
            <th>street_code1</th>
            <th>street_code2</th>
            <th>street_code3</th>
            <th>vehicle_expiration_date</th>
            <th>violation_location</th>
            <th>violation_precinct</th>
            <th>issuer_precinct</th>
            <th>issuer_code</th>
            <th>issuer_command</th>
            <th>issuer_squad</th>
            <th>violation_time</th>
            <th>time_first_observed</th>
            <th>violation_county</th>
            <th>violation_in_front_of_or_opposite</th>
            <th>house_number</th>
            <th>street_name</th>
            <th>intersecting_street</th>
            <th>date_first_observed</th>
            <th>law_section</th>
            <th>sub_division</th>
            <th>violation_legal_code</th>
            <th>days_parking_in_effect</th>
            <th>from_hours_in_effect</th>
            <th>to_hours_in_effect</th>
            <th>vehicle_color</th>
            <th>unregistered_vehicle</th>
            <th>vehicle_year</th>
            <th>meter_number</th>
            <th>feet_from_curb</th>
            <th>violation_post_code</th>
            <th>violation_description</th>
            <th>no_standing_or_stopping_violation</th>
            <th>hydrant_violation</th>
            <th>double_parking_violation</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>1447152402</td>
            <td>JCV6523</td>
            <td>NY</td>
            <td>PAS</td>
            <td>2019-06-28</td>
            <td>20</td>
            <td>SDN</td>
            <td>TOYOT</td>
            <td>P</td>
            <td>36290</td>
            <td>27390</td>
            <td>13113</td>
            <td>20210109</td>
            <td>0026</td>
            <td>26</td>
            <td>26</td>
            <td>964055</td>
            <td>0026</td>
            <td>0000</td>
            <td>1011A</td>
            <td>None</td>
            <td>NY</td>
            <td>F</td>
            <td>545</td>
            <td>W 126 STREET</td>
            <td>None</td>
            <td>0</td>
            <td>408</td>
            <td>D1</td>
            <td>None</td>
            <td>BBBBBBB</td>
            <td>ALL</td>
            <td>ALL</td>
            <td>GY</td>
            <td>False</td>
            <td>0</td>
            <td>-</td>
            <td>0</td>
            <td>None</td>
            <td>None</td>
            <td>None</td>
            <td>None</td>
            <td>None</td>
        </tr>
        <tr>
            <td>1447152554</td>
            <td>GMK6954</td>
            <td>NY</td>
            <td>PAS</td>
            <td>2019-06-16</td>
            <td>19</td>
            <td>SUBN</td>
            <td>BMW</td>
            <td>P</td>
            <td>36270</td>
            <td>11710</td>
            <td>27390</td>
            <td>20190720</td>
            <td>0026</td>
            <td>26</td>
            <td>26</td>
            <td>927590</td>
            <td>0026</td>
            <td>0000</td>
            <td>0107A</td>
            <td>None</td>
            <td>None</td>
            <td>F</td>
            <td>509</td>
            <td>W 125 ST</td>
            <td>None</td>
            <td>0</td>
            <td>408</td>
            <td>F1</td>
            <td>None</td>
            <td>BBBBBBB</td>
            <td>ALL</td>
            <td>ALL</td>
            <td>BLK</td>
            <td>False</td>
            <td>2019</td>
            <td>-</td>
            <td>0</td>
            <td>None</td>
            <td>None</td>
            <td>None</td>
            <td>None</td>
            <td>None</td>
        </tr>
        <tr>
            <td>1447152580</td>
            <td>JGX1641</td>
            <td>NY</td>
            <td>PAS</td>
            <td>2019-06-24</td>
            <td>19</td>
            <td>SDN</td>
            <td>AUDI</td>
            <td>P</td>
            <td>36270</td>
            <td>11710</td>
            <td>27390</td>
            <td>20210408</td>
            <td>0026</td>
            <td>26</td>
            <td>26</td>
            <td>927590</td>
            <td>0026</td>
            <td>0000</td>
            <td>0300A</td>
            <td>None</td>
            <td>None</td>
            <td>F</td>
            <td>501</td>
            <td>W 125 ST</td>
            <td>None</td>
            <td>0</td>
            <td>408</td>
            <td>F2</td>
            <td>None</td>
            <td>BBBBBBB</td>
            <td>ALL</td>
            <td>ALL</td>
            <td>BLK</td>
            <td>False</td>
            <td>2015</td>
            <td>-</td>
            <td>0</td>
            <td>None</td>
            <td>None</td>
            <td>None</td>
            <td>None</td>
            <td>None</td>
        </tr>
        <tr>
            <td>1447152724</td>
            <td>GDM8069</td>
            <td>NY</td>
            <td>COM</td>
            <td>2019-07-06</td>
            <td>48</td>
            <td>None</td>
            <td>None</td>
            <td>P</td>
            <td>31190</td>
            <td>36310</td>
            <td>36330</td>
            <td>20210109</td>
            <td>0026</td>
            <td>26</td>
            <td>26</td>
            <td>963447</td>
            <td>0026</td>
            <td>0000</td>
            <td>0653A</td>
            <td>None</td>
            <td>NY</td>
            <td>F</td>
            <td>341</td>
            <td>ST NICHOLAS AVENUE</td>
            <td>None</td>
            <td>0</td>
            <td>408</td>
            <td>F1</td>
            <td>None</td>
            <td>BBBBBBB</td>
            <td>ALL</td>
            <td>ALL</td>
            <td>None</td>
            <td>False</td>
            <td>0</td>
            <td>-</td>
            <td>0</td>
            <td>None</td>
            <td>None</td>
            <td>None</td>
            <td>None</td>
            <td>None</td>
        </tr>
        <tr>
            <td>1447152992</td>
            <td>HXH5242</td>
            <td>NY</td>
            <td>PAS</td>
            <td>2019-06-14</td>
            <td>46</td>
            <td>SUBN</td>
            <td>NISSA</td>
            <td>P</td>
            <td>36270</td>
            <td>11710</td>
            <td>27390</td>
            <td>20200321</td>
            <td>0026</td>
            <td>26</td>
            <td>26</td>
            <td>963451</td>
            <td>0026</td>
            <td>0000</td>
            <td>0515P</td>
            <td>None</td>
            <td>NY</td>
            <td>F</td>
            <td>564</td>
            <td>W 125 ST</td>
            <td>None</td>
            <td>0</td>
            <td>408</td>
            <td>C</td>
            <td>None</td>
            <td>BBBBBBB</td>
            <td>ALL</td>
            <td>ALL</td>
            <td>GY</td>
            <td>False</td>
            <td>0</td>
            <td>-</td>
            <td>0</td>
            <td>None</td>
            <td>None</td>
            <td>None</td>
            <td>None</td>
            <td>None</td>
        </tr>
        <tr>
            <td>1447153315</td>
            <td>HXM3470</td>
            <td>NY</td>
            <td>PAS</td>
            <td>2019-06-14</td>
            <td>40</td>
            <td>SUBN</td>
            <td>TOYOT</td>
            <td>P</td>
            <td>36290</td>
            <td>11710</td>
            <td>27390</td>
            <td>20200130</td>
            <td>0026</td>
            <td>26</td>
            <td>26</td>
            <td>959203</td>
            <td>0026</td>
            <td>0000</td>
            <td>0524P</td>
            <td>None</td>
            <td>NY</td>
            <td>O</td>
            <td>504</td>
            <td>W 126 ST</td>
            <td>None</td>
            <td>0</td>
            <td>408</td>
            <td>F1</td>
            <td>None</td>
            <td>BBBBBBB</td>
            <td>ALL</td>
            <td>ALL</td>
            <td>BK</td>
            <td>False</td>
            <td>2005</td>
            <td>-</td>
            <td>1</td>
            <td>None</td>
            <td>None</td>
            <td>None</td>
            <td>None</td>
            <td>None</td>
        </tr>
        <tr>
            <td>1447153327</td>
            <td>GWH9640</td>
            <td>NY</td>
            <td>PAS</td>
            <td>2019-06-14</td>
            <td>46</td>
            <td>SUBN</td>
            <td>HONDA</td>
            <td>P</td>
            <td>36270</td>
            <td>11710</td>
            <td>27390</td>
            <td>20210326</td>
            <td>0026</td>
            <td>26</td>
            <td>26</td>
            <td>959203</td>
            <td>0026</td>
            <td>0000</td>
            <td>0601P</td>
            <td>None</td>
            <td>NY</td>
            <td>F</td>
            <td>515</td>
            <td>W 125 ST</td>
            <td>None</td>
            <td>0</td>
            <td>408</td>
            <td>E2</td>
            <td>None</td>
            <td>BBBBBBB</td>
            <td>ALL</td>
            <td>ALL</td>
            <td>GY</td>
            <td>False</td>
            <td>2003</td>
            <td>-</td>
            <td>0</td>
            <td>None</td>
            <td>None</td>
            <td>None</td>
            <td>None</td>
            <td>None</td>
        </tr>
        <tr>
            <td>1447153340</td>
            <td>HKB1769</td>
            <td>NY</td>
            <td>PAS</td>
            <td>2019-06-28</td>
            <td>40</td>
            <td>SUBN</td>
            <td>TOYOT</td>
            <td>P</td>
            <td>36290</td>
            <td>11710</td>
            <td>27390</td>
            <td>20200901</td>
            <td>0026</td>
            <td>26</td>
            <td>26</td>
            <td>959203</td>
            <td>0026</td>
            <td>0000</td>
            <td>0935A</td>
            <td>None</td>
            <td>NY</td>
            <td>O</td>
            <td>504</td>
            <td>W 126 ST</td>
            <td>None</td>
            <td>0</td>
            <td>408</td>
            <td>D</td>
            <td>None</td>
            <td>BBBBBBB</td>
            <td>ALL</td>
            <td>ALL</td>
            <td>GY</td>
            <td>False</td>
            <td>2004</td>
            <td>-</td>
            <td>0</td>
            <td>None</td>
            <td>None</td>
            <td>None</td>
            <td>None</td>
            <td>None</td>
        </tr>
        <tr>
            <td>1447153352</td>
            <td>GDH2184</td>
            <td>ME</td>
            <td>PAS</td>
            <td>2019-07-06</td>
            <td>48</td>
            <td>SDN</td>
            <td>DODGE</td>
            <td>P</td>
            <td>31190</td>
            <td>40404</td>
            <td>40404</td>
            <td>0</td>
            <td>0026</td>
            <td>26</td>
            <td>26</td>
            <td>959205</td>
            <td>0026</td>
            <td>0000</td>
            <td>1217P</td>
            <td>None</td>
            <td>NY</td>
            <td>F</td>
            <td>361</td>
            <td>SAINT NICHOLAS AVE</td>
            <td>None</td>
            <td>0</td>
            <td>408</td>
            <td>E9</td>
            <td>None</td>
            <td>BBBBBBB</td>
            <td>ALL</td>
            <td>ALL</td>
            <td>ORANG</td>
            <td>False</td>
            <td>0</td>
            <td>-</td>
            <td>0</td>
            <td>None</td>
            <td>None</td>
            <td>None</td>
            <td>None</td>
            <td>None</td>
        </tr>
        <tr>
            <td>1447153649</td>
            <td>JCA5331</td>
            <td>NY</td>
            <td>PAS</td>
            <td>2019-07-01</td>
            <td>46</td>
            <td>SDN</td>
            <td>ACURA</td>
            <td>P</td>
            <td>36270</td>
            <td>11710</td>
            <td>27390</td>
            <td>20200829</td>
            <td>0026</td>
            <td>26</td>
            <td>26</td>
            <td>957363</td>
            <td>0026</td>
            <td>0000</td>
            <td>0049A</td>
            <td>None</td>
            <td>NY</td>
            <td>F</td>
            <td>515</td>
            <td>W 125 ST</td>
            <td>None</td>
            <td>0</td>
            <td>408</td>
            <td>F1</td>
            <td>None</td>
            <td>BBBBBBB</td>
            <td>ALL</td>
            <td>ALL</td>
            <td>WH</td>
            <td>False</td>
            <td>0</td>
            <td>-</td>
            <td>0</td>
            <td>None</td>
            <td>None</td>
            <td>None</td>
            <td>None</td>
            <td>None</td>
        </tr>
    </tbody>
</table>



### Formatting text for colleagues

A website to monitor filming activity in New York City is being
constructed based on film permit applications stored in `film_permit`.
This website will include information such as an `event_id`, parking
restrictions required for the filming (`parking_held`), and the purpose
of the filming.

Your task is to deliver data to the web development team that will not
require the team to perform further cleaning. `event_id` values will
need to be padded with `0`s in order to have a uniform length,
capitalization for parking will need to be modified to only capitalize
the initial letter of a word, and extra spaces from parking descriptions
will need to be removed. The `REGEXP_REPLACE()` function (introduced in
one of the previous exercises) will be used to clean the extra spaces.

**Instructions**

- Use the `LPAD()` function to complete the query so that each
  `event_id` is always 10 digits in length with preceding 0s added for
  any `event_id` less than 10 digits.

**Answer**



```sql
%%sql
SELECT 
	-- Add 0s to ensure each event_id is 10 digits in length
	LPAD(event_id, 10, '0') as event_id, 
    parking_held 
FROM 
    film_permit;
```

     * postgresql://postgres:***@localhost/local
    4999 rows affected.





<table>
    <thead>
        <tr>
            <th>event_id</th>
            <th>parking_held</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>0000446040</td>
            <td>THOMPSON STREET between PRINCE STREET and SPRING STREET,  SPRING STREET between WOOSTER STREET and 6TH AVENUE,  SPRING STREET between THOMPSON STREET and 6TH AVENUE,  6TH AVENUE between VANDAM STREET and BROOME STREET,  SULLIVAN STREET between WEST HOUSTON STREET and PRINCE STREET,  PRINCE STREET between SULLIVAN STREET and 6 AVENUE</td>
        </tr>
        <tr>
            <td>0000446168</td>
            <td>MARBLE HILL AVENUE between WEST  227 STREET and WEST  225 STREET,  WEST  228 STREET between ADRIAN AVENUE and MARBLE HILL AVENUE</td>
        </tr>
        <tr>
            <td>0000186438</td>
            <td>LAUREL HILL BLVD between REVIEW AVENUE and RUST ST,  REVIEW AVE between VAN DAM STREET and LAUREL HILL BOULEVARD,  59 ROAD between 60 LANE and 61 STREET,  59 ROAD between 60 LANE and 61 STREET,  61 STREET between 59 ROAD and FRESH POND ROAD,  FRESH POND ROAD between 59 AVENUE and 59 DRIVE,  59 DRIVE between FRESH POND ROAD and 63 STREET,  59 DRIVE between FRESH POND ROAD and 64 STREET</td>
        </tr>
        <tr>
            <td>0000445255</td>
            <td>JORALEMON STREET between BOERUM PLACE and COURT STREET</td>
        </tr>
        <tr>
            <td>0000128794</td>
            <td>WEST   31 STREET between 7 AVENUE and 8 AVENUE,  8 AVENUE between WEST   31 STREET and WEST   33 STREET</td>
        </tr>
        <tr>
            <td>0000043547</td>
            <td>EAGLE STREET between FRANKLIN STREET and WEST STREET,  WEST STREET between EAGLE STREET and FREEMAN STREET,  FREEMAN STREET between WEST STREET and FRANKLIN STREET</td>
        </tr>
        <tr>
            <td>0000066846</td>
            <td>8 AVENUE between LINCOLN PLACE and BERKELEY PLACE</td>
        </tr>
        <tr>
            <td>0000104342</td>
            <td>WEST   44 STREET between BROADWAY and 6 AVENUE</td>
        </tr>
        <tr>
            <td>0000244863</td>
            <td>BRONXDALE AVENUE between MORRIS PARK AVENUE and VAN NEST AVENUE,  MORRIS PARK AVENUE between BRONXDALE AVENUE and FOWLER AVENUE</td>
        </tr>
        <tr>
            <td>0000446379</td>
            <td>JANE STREET between WASHINGTON STREET and GREENWICH STREET</td>
        </tr>
    </tbody>
</table>







```sql
%%sql
SELECT 
	LPAD(event_id, 10, '0') as event_id, 
    -- Fix capitalization in parking_held column
    INITCAP(parking_held) as parking_held
FROM 
    film_permit;
```

     * postgresql://postgres:***@localhost/local
    4999 rows affected.





<table>
    <thead>
        <tr>
            <th>event_id</th>
            <th>parking_held</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>0000446040</td>
            <td>Thompson Street Between Prince Street And Spring Street,  Spring Street Between Wooster Street And 6th Avenue,  Spring Street Between Thompson Street And 6th Avenue,  6th Avenue Between Vandam Street And Broome Street,  Sullivan Street Between West Houston Street And Prince Street,  Prince Street Between Sullivan Street And 6 Avenue</td>
        </tr>
        <tr>
            <td>0000446168</td>
            <td>Marble Hill Avenue Between West  227 Street And West  225 Street,  West  228 Street Between Adrian Avenue And Marble Hill Avenue</td>
        </tr>
        <tr>
            <td>0000186438</td>
            <td>Laurel Hill Blvd Between Review Avenue And Rust St,  Review Ave Between Van Dam Street And Laurel Hill Boulevard,  59 Road Between 60 Lane And 61 Street,  59 Road Between 60 Lane And 61 Street,  61 Street Between 59 Road And Fresh Pond Road,  Fresh Pond Road Between 59 Avenue And 59 Drive,  59 Drive Between Fresh Pond Road And 63 Street,  59 Drive Between Fresh Pond Road And 64 Street</td>
        </tr>
        <tr>
            <td>0000445255</td>
            <td>Joralemon Street Between Boerum Place And Court Street</td>
        </tr>
        <tr>
            <td>0000128794</td>
            <td>West   31 Street Between 7 Avenue And 8 Avenue,  8 Avenue Between West   31 Street And West   33 Street</td>
        </tr>
        <tr>
            <td>0000043547</td>
            <td>Eagle Street Between Franklin Street And West Street,  West Street Between Eagle Street And Freeman Street,  Freeman Street Between West Street And Franklin Street</td>
        </tr>
        <tr>
            <td>0000066846</td>
            <td>8 Avenue Between Lincoln Place And Berkeley Place</td>
        </tr>
        <tr>
            <td>0000104342</td>
            <td>West   44 Street Between Broadway And 6 Avenue</td>
        </tr>
        <tr>
            <td>0000244863</td>
            <td>Bronxdale Avenue Between Morris Park Avenue And Van Nest Avenue,  Morris Park Avenue Between Bronxdale Avenue And Fowler Avenue</td>
        </tr>
        <tr>
            <td>0000446379</td>
            <td>Jane Street Between Washington Street And Greenwich Street</td>
        </tr>
    </tbody>
</table>







```sql
%%sql
SELECT 
	LPAD(event_id, 10, '0') as event_id, 
    -- Replace consecutive spaces with a single space
    REGEXP_REPLACE(INITCAP(parking_held), ' +', ' ', 'g')  as parking_held
FROM 
    film_permit;
```

     * postgresql://postgres:***@localhost/local
    4999 rows affected.





<table>
    <thead>
        <tr>
            <th>event_id</th>
            <th>parking_held</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>0000446040</td>
            <td>Thompson Street Between Prince Street And Spring Street, Spring Street Between Wooster Street And 6th Avenue, Spring Street Between Thompson Street And 6th Avenue, 6th Avenue Between Vandam Street And Broome Street, Sullivan Street Between West Houston Street And Prince Street, Prince Street Between Sullivan Street And 6 Avenue</td>
        </tr>
        <tr>
            <td>0000446168</td>
            <td>Marble Hill Avenue Between West 227 Street And West 225 Street, West 228 Street Between Adrian Avenue And Marble Hill Avenue</td>
        </tr>
        <tr>
            <td>0000186438</td>
            <td>Laurel Hill Blvd Between Review Avenue And Rust St, Review Ave Between Van Dam Street And Laurel Hill Boulevard, 59 Road Between 60 Lane And 61 Street, 59 Road Between 60 Lane And 61 Street, 61 Street Between 59 Road And Fresh Pond Road, Fresh Pond Road Between 59 Avenue And 59 Drive, 59 Drive Between Fresh Pond Road And 63 Street, 59 Drive Between Fresh Pond Road And 64 Street</td>
        </tr>
        <tr>
            <td>0000445255</td>
            <td>Joralemon Street Between Boerum Place And Court Street</td>
        </tr>
        <tr>
            <td>0000128794</td>
            <td>West 31 Street Between 7 Avenue And 8 Avenue, 8 Avenue Between West 31 Street And West 33 Street</td>
        </tr>
        <tr>
            <td>0000043547</td>
            <td>Eagle Street Between Franklin Street And West Street, West Street Between Eagle Street And Freeman Street, Freeman Street Between West Street And Franklin Street</td>
        </tr>
        <tr>
            <td>0000066846</td>
            <td>8 Avenue Between Lincoln Place And Berkeley Place</td>
        </tr>
        <tr>
            <td>0000104342</td>
            <td>West 44 Street Between Broadway And 6 Avenue</td>
        </tr>
        <tr>
            <td>0000244863</td>
            <td>Bronxdale Avenue Between Morris Park Avenue And Van Nest Avenue, Morris Park Avenue Between Bronxdale Avenue And Fowler Avenue</td>
        </tr>
        <tr>
            <td>0000446379</td>
            <td>Jane Street Between Washington Street And Greenwich Street</td>
        </tr>
    </tbody>
</table>



## Missing, Duplicate, and Invalid Data

### Using a fill-in value

The sedan body type is the most frequently occurring `vehicle_body_type`
in the sample parking violations. For this reason, you propose changing
all `NULL`-valued `vehicle_body_type` records in the
`parking_violations` table to `SDN`. Discussions with your team result
in a decision to use a value other than `SDN` as a fill-in value. The
body type can be determined by looking up the vehicle using its license
plate number. A license plate number is present in most
`parking_violation` records. Rather than using the most frequent value
to replace `NULL` `vehicle_body_type` values, a placeholder value of
`Unknown` will be used. The actual body type will be updated as license
plate lookup data is gathered.

In this exercise, you will replace `NULL` `vehicle_body_type` values
with the string `Unknown`.

**Instructions**

- Use `COALESCE()` to replace any `vehicle_body_type` that is `NULL`
  with the string value `Unknown` in the `parking_violation` table.

**Answer**



```sql
%%sql
UPDATE
  parking_violation
SET
  -- Replace NULL vehicle_body_type values with `Unknown`
  vehicle_body_type = COALESCE(vehicle_body_type, 'Unknown');

SELECT COUNT(*) FROM parking_violation WHERE vehicle_body_type = 'Unknown';
```

     * postgresql://postgres:***@localhost/local
    5000 rows affected.
    1 rows affected.





<table>
    <thead>
        <tr>
            <th>count</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>179</td>
        </tr>
    </tbody>
</table>



### Analyzing incomplete records

In an effort to reduce the number of missing `vehicle_body_type` values
going forward, your team has decided to embark on a campaign to educate
issuing agencies on the need for complete data. However, each campaign
will be customized for individual agencies.

In this exercise, your goal is to use the current missing data values to
prioritize these campaigns. You will write a query which outputs the
issuing agencies along with the number of records attributable to that
agency with a `NULL` `vehicle_body_type`. These records will be listed
in descending order to determine the order in which education campaigns
should be developed.

**Instructions**

- Specify two columns for the query results: `issuing_agency` and
  `num_missing` (the number of missing vehicle body types for the
  issuing agency).
- Restrict the results such that only `NULL` values for
  `vehicle_body_type` are counted.
- Group the results by `issuing_agency`.
- Order the results by `num_missing` in *descending* order.

**Answer**



```sql
%%sql
SELECT
  -- Define the SELECT list: issuing_agency and num_missing
  issuing_agency,
  COUNT(*) AS num_missing
FROM
  parking_violation
WHERE
  -- Restrict the results to NULL vehicle_body_type values
  vehicle_body_type IS NULL
  -- Group results by issuing_agency
GROUP BY
  issuing_agency
  -- Order results by num_missing in descending order
ORDER BY
  num_missing DESC;
```

     * postgresql://postgres:***@localhost/local
    4 rows affected.





<table>
    <thead>
        <tr>
            <th>issuing_agency</th>
            <th>num_missing</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>P</td>
            <td>144</td>
        </tr>
        <tr>
            <td>X</td>
            <td>25</td>
        </tr>
        <tr>
            <td>K</td>
            <td>6</td>
        </tr>
        <tr>
            <td>S</td>
            <td>4</td>
        </tr>
    </tbody>
</table>



### Duplicate parking violations

There have been a number of complaints indicating that some New York
residents have been receiving multiple parking tickets for a single
violation. This is resulting in the affected residents having to incur
additional legal fees for a single incident. There is justifiable anger
about this situation. You have been tasked with identifying records that
reflect this duplication of violations.

In this exercise, using `ROW_NUMBER()`, you will find
`parking_violation` records that contain the same `plate_id`,
`issue_date`, `violation_time`, `house_number`, and `street_name`,
indicating that multiple tickets were issued for the same violation.

**Instructions**

- Use `ROW_NUMBER()` with columns `plate_id`, `issue_date`,
  `violation_time`, `house_number`, and `street_name` to define the
  duplicate window.
- Subtract `1` from the value returned by `ROW_NUMBER()` to define the
  `duplicate` column.

**Answer**



```sql
%%sql
SELECT
  	summons_number,
    -- Use ROW_NUMBER() to define duplicate column
  	ROW_NUMBER() OVER(
        PARTITION BY 
            plate_id, 
          	issue_date, 
          	violation_time, 
          	house_number, 
          	street_name
    -- Modify ROW_NUMBER() value to define duplicate column
      ) - 1 AS duplicate, 
    plate_id, 
    issue_date, 
    violation_time, 
    house_number, 
    street_name 
FROM 
	parking_violation;
```

     * postgresql://postgres:***@localhost/local
    5000 rows affected.





<table>
    <thead>
        <tr>
            <th>summons_number</th>
            <th>duplicate</th>
            <th>plate_id</th>
            <th>issue_date</th>
            <th>violation_time</th>
            <th>house_number</th>
            <th>street_name</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>1449776220</td>
            <td>0</td>
            <td>G11LHN</td>
            <td>2019-06-22</td>
            <td>0245A</td>
            <td>210</td>
            <td>WASHINGTON AVE</td>
        </tr>
        <tr>
            <td>1447011338</td>
            <td>0</td>
            <td>G14GBZ</td>
            <td>2019-06-30</td>
            <td>0416P</td>
            <td>6</td>
            <td>WEST 72 ST</td>
        </tr>
        <tr>
            <td>1434030386</td>
            <td>0</td>
            <td>G31KZC</td>
            <td>2019-06-14</td>
            <td>0905A</td>
            <td>1061</td>
            <td>HALL PLACE</td>
        </tr>
        <tr>
            <td>1446484129</td>
            <td>0</td>
            <td>G442853</td>
            <td>2019-07-06</td>
            <td>0635P</td>
            <td>1591</td>
            <td>GRAND CONCOURSE</td>
        </tr>
        <tr>
            <td>1447104134</td>
            <td>0</td>
            <td>G47GYK</td>
            <td>2019-06-20</td>
            <td>0825A</td>
            <td>210</td>
            <td>E 102 ST</td>
        </tr>
        <tr>
            <td>1453986935</td>
            <td>0</td>
            <td>G51FER</td>
            <td>2019-06-27</td>
            <td>0310P</td>
            <td>62</td>
            <td>WALL ST</td>
        </tr>
        <tr>
            <td>1454213700</td>
            <td>0</td>
            <td>G52LHB</td>
            <td>2019-07-04</td>
            <td>1210P</td>
            <td>None</td>
            <td>E/O ALBERMARLE RD</td>
        </tr>
        <tr>
            <td>1452146184</td>
            <td>0</td>
            <td>G54KYP</td>
            <td>2019-06-28</td>
            <td>0928A</td>
            <td>407</td>
            <td>W 146TH ST</td>
        </tr>
        <tr>
            <td>1446710105</td>
            <td>0</td>
            <td>G5535J</td>
            <td>2019-06-14</td>
            <td>1215P</td>
            <td>1135</td>
            <td>EAST 229TH STREET</td>
        </tr>
        <tr>
            <td>1418499006</td>
            <td>0</td>
            <td>G5535J</td>
            <td>2019-07-10</td>
            <td>1024A</td>
            <td>2500</td>
            <td>CROTONA AVE</td>
        </tr>
    </tbody>
</table>







```sql
%%sql
SELECT 
	-- Include all columns 
	*
FROM (
	SELECT
  		summons_number,
  		ROW_NUMBER() OVER(
        	PARTITION BY 
            	plate_id, 
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
```

     * postgresql://postgres:***@localhost/local
    52 rows affected.





<table>
    <thead>
        <tr>
            <th>summons_number</th>
            <th>duplicate</th>
            <th>plate_id</th>
            <th>issue_date</th>
            <th>violation_time</th>
            <th>house_number</th>
            <th>street_name</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>1448411579</td>
            <td>1</td>
            <td>GEW9007</td>
            <td>2019-06-30</td>
            <td>0258P</td>
            <td>172-61</td>
            <td>BAISLEY BLVD</td>
        </tr>
        <tr>
            <td>1410920458</td>
            <td>1</td>
            <td>GEX3870</td>
            <td>2019-06-20</td>
            <td>1030P</td>
            <td>1520</td>
            <td>GRAND CONCOURSE</td>
        </tr>
        <tr>
            <td>1446413159</td>
            <td>1</td>
            <td>GFD4777</td>
            <td>2019-06-30</td>
            <td>1214P</td>
            <td>3543</td>
            <td>WAYNE AVE</td>
        </tr>
        <tr>
            <td>1448947790</td>
            <td>1</td>
            <td>GKX9331</td>
            <td>2019-06-29</td>
            <td>1030P</td>
            <td>None</td>
            <td>S/W C/O W 45 ST</td>
        </tr>
        <tr>
            <td>1452062158</td>
            <td>1</td>
            <td>GR8C1VIC</td>
            <td>2019-06-14</td>
            <td>0315P</td>
            <td>None</td>
            <td>RIVERBANK STATE PARK</td>
        </tr>
        <tr>
            <td>1449470622</td>
            <td>1</td>
            <td>GUC5106</td>
            <td>2019-07-03</td>
            <td>1035P</td>
            <td>1060</td>
            <td>BEACH AVE</td>
        </tr>
        <tr>
            <td>1451262115</td>
            <td>1</td>
            <td>GWC4311</td>
            <td>2019-06-30</td>
            <td>0728P</td>
            <td>None</td>
            <td>SURF AVE</td>
        </tr>
        <tr>
            <td>1452186868</td>
            <td>1</td>
            <td>GXL4110</td>
            <td>2019-06-30</td>
            <td>0548P</td>
            <td>170 01</td>
            <td>118 RD</td>
        </tr>
        <tr>
            <td>1449142590</td>
            <td>1</td>
            <td>HAT3306</td>
            <td>2019-06-26</td>
            <td>0938A</td>
            <td>811</td>
            <td>E 219 ST</td>
        </tr>
        <tr>
            <td>1454273847</td>
            <td>1</td>
            <td>HDC7519</td>
            <td>2019-07-02</td>
            <td>0447A</td>
            <td>811</td>
            <td>HICKS ST</td>
        </tr>
    </tbody>
</table>



### Resolving impartial duplicates

The `parking_violation` dataset has been modified to include a `fee`
column indicating the fee for the violation. This column would be useful
for keeping track of New York City parking ticket revenue. However, due
to duplicated violation records, revenue calculations based on the
dataset would not be accurate. These duplicate records only differ based
on the value in the `fee` column. All other column values are shared in
the duplicated records. A decision has been made to use the minimum
`fee` to resolve the ambiguity created by these duplicates.

Identify the 3 duplicated `parking_violation` records and use the
`MIN()` function to determine the `fee` that will be used after removing
the duplicate records.

**Instructions**

- Return the `summons_number` and the minimum `fee` for duplicated
  records.
- Group the results by `summons_number`.
- Restrict the results to records having a `summons_number` **count**
  that is greater than 1.

**Answer**



```sql
%%sql
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
```

### Detecting invalid values with regular expressions

In the video exercise, we saw that there are a number of ways to detect
invalid values in our data. In this exercise, we will use regular
expressions to identify records with invalid values in the
`parking_violation` table.

A couple of regular expression patterns that will be useful in this
exercise are `c{n}` and `c+`. `c{n}` matches strings which contain the
character `c` repeated `n` times. For example, `x{4}` would match the
pattern `xxxx`. `c+` matches strings which contain the character `c`
repeated **one or more** times. This pattern would match strings
including `xxxx` as well as `x` and `xx`.

**Instructions**

- Write a query returning records with a `registration_state` that does
  **not** match **two** consecutive **uppercase** letters.

<!-- -->

- Write a query that returns records containing a `plate_type` that does
  **not** match **three** consecutive uppercase letters.

<!-- -->

- Write a query returning records with a `vehicle_make` not including an
  uppercase letter, a forward slash (`/`), or a space (`\s`).

**Answer**



```sql
%%sql
SELECT
  summons_number,
  plate_id,
  registration_state
FROM
  parking_violation
WHERE
  -- Define the pattern to use for matching
  registration_state NOT SIMILAR TO '[A-Z]{2}';

```





```sql
%%sql
SELECT
  summons_number,
  plate_id,
  plate_type
FROM
  parking_violation
WHERE
  -- Define the pattern to use for matching
  plate_type NOT SIMILAR TO '[A-Z]{3}';

```





```sql
%%sql
SELECT
  summons_number,
  plate_id,
  vehicle_make
FROM
  parking_violation
WHERE
  -- Define the pattern to use for matching
  vehicle_make NOT SIMILAR TO '[A-Z/\s]+';

```

     * postgresql://postgres:***@localhost/local
    1 rows affected.





<table>
    <thead>
        <tr>
            <th>summons_number</th>
            <th>plate_id</th>
            <th>vehicle_make</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>1452167760</td>
            <td>JA81VK</td>
            <td>1</td>
        </tr>
    </tbody>
</table>



### Identifying out-of-range vehicle model years

Type constraints are useful for restricting the type of data that can be
stored in a table column. However, there are limitations to how
thoroughly these constraints can prevent invalid data from entering the
column. Range constraints are useful when the goal is to identify column
values that are included in a range of values or excluded from a range
of values. Using type constraints when defining a table followed by
checking column values with range constraints are a powerful approach to
ensuring the integrity of data.

In this exercise, you will use a `BETWEEN` clause to build a range
constraint to identify invalid vehicle model years in the
`parking_violation` table. Valid vehicle model years for this dataset
are considered to be between 1970 and 2021.

**Instructions**

- Write a query that returns the `summons_number`, `plate_id`, and
  `vehicle_year` for records in the `parking_violation` table containing
  a `vehicle_year` outside of the range 1970-2021.

**Answer**



```sql
%%sql
SELECT
  -- Define the columns to return from the query
  summons_number,
  plate_id,
  vehicle_year
FROM
  parking_violation
WHERE
  -- Define the range constraint for invalid vehicle years
  vehicle_year NOT BETWEEN 1970 AND 2021;

```

     * postgresql://postgres:***@localhost/local
    1189 rows affected.





<table>
    <thead>
        <tr>
            <th>summons_number</th>
            <th>plate_id</th>
            <th>vehicle_year</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>1447152402</td>
            <td>JCV6523</td>
            <td>0</td>
        </tr>
        <tr>
            <td>1447152724</td>
            <td>GDM8069</td>
            <td>0</td>
        </tr>
        <tr>
            <td>1447184282</td>
            <td>JET2379</td>
            <td>0</td>
        </tr>
        <tr>
            <td>1449253015</td>
            <td>JDY2603</td>
            <td>0</td>
        </tr>
        <tr>
            <td>1449291508</td>
            <td>IHBN76</td>
            <td>0</td>
        </tr>
        <tr>
            <td>1449291673</td>
            <td>KRKG91</td>
            <td>0</td>
        </tr>
        <tr>
            <td>1449331956</td>
            <td>KXJ3298</td>
            <td>0</td>
        </tr>
        <tr>
            <td>1449335275</td>
            <td>KNZ7563</td>
            <td>0</td>
        </tr>
        <tr>
            <td>1449335299</td>
            <td>JEF4708</td>
            <td>0</td>
        </tr>
        <tr>
            <td>1449352844</td>
            <td>KGP285</td>
            <td>0</td>
        </tr>
    </tbody>
</table>



### Identifying invalid parking violations

The `parking_violation` table has three columns populated by related
time values. The `from_hours_in_effect` column indicates the start time
when parking restrictions are enforced at the location where the
violation occurred. The `to_hours_in_effect` column indicates the ending
time for enforcement of parking restrictions. The `violation_time`
indicates the time at which the violation was recorded. In order to
ensure the validity of parking tickets, an audit is being performed to
identify tickets given outside of the restricted parking hours.

In this exercise, you will use the parking restriction time range
defined by `from_hours_in_effect` and `to_hours_in_effect` to identify
parking tickets with an invalid `violation_time`.

**Instructions**

- Complete the `SELECT` query to return the `summons_number`,
  `violation_time`, `from_hours_in_effect`, and `to_hours_in_effect` for
  `violation_time` values, in that order, outside of the restricted
  range.

**Answer**



```sql
%%sql
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
  violation_time NOT BETWEEN from_hours_in_effect AND to_hours_in_effect;

```





```sql
%%sql
SELECT 
  summons_number, 
  violation_time, 
  from_hours_in_effect, 
  to_hours_in_effect 
FROM 
  parking_violation 
WHERE 
  -- Exclude results with overnight restrictions
  from_hours_in_effect < to_hours_in_effect AND 
  violation_time NOT BETWEEN from_hours_in_effect AND to_hours_in_effect;

```

### Invalid violations with overnight parking restrictions

In the previous exercise, you identified `parking_violation` records
with `violation_time` values that were outside of the restricted parking
times. The query for identifying these records was restricted to
violations that occurred at locations without overnight restrictions. A
modified query can be constructed to capture invalid violation times
that include overnight parking restrictions. The parking violations in
the dataset satisfying this criteria will be identified in this
exercise.

For example, this query will identify that a record with a
`from_hours_in_effect` value of `10:00 PM`, a `to_hours_in_effect` value
of `10:00 AM`, and a `violation_time` of `4:00 PM` is an invalid record.

**Instructions**

- Add a condition to the `SELECT` query that ensures the returned
  records contain a `from_hours_in_effect` value that is greater than
  the `to_hours_in_effect` value.
- Add a condition that ensures the `violation_time` is less than the
  `from_hours_in_effect`.
- Add a condition that ensures the `violation_time` is greater than the
  `to_hours_in_effect`.

**Answer**



```sql
%%sql
SELECT
  summons_number,
  violation_time,
  from_hours_in_effect,
  to_hours_in_effect
FROM
  parking_violation
WHERE
  -- Ensure from hours greater than to hours
  from_hours_in_effect > to_hours_in_effect AND
  -- Ensure violation_time less than from hours
  violation_time < from_hours_in_effect AND
  -- Ensure violation_time greater than to hours
  violation_time > to_hours_in_effect;

```

### Recovering deleted data

While maintenance of the film permit data was taking place, a mishap
occurred where the column storing the New York City borough was deleted.
While the data was backed up the previous day, additional permit
applications were processed between the time the backup was made and
when the borough column was removed. In an attempt to recover the
borough values while preserving the new data, you decide to use some
data cleaning skills that you have learned to rectify the situation.

Fortunately, a table mapping zip codes and boroughs is available
(`nyc_zip_codes`). You will use the zip codes from the `film_permit`
table to re-populate the borough column values. This will be done
utilizing five sub-queries to specify which of the five boroughs to use
in the new `borough` column.

**Instructions**

- Define 1 subquery (of the 5) that will be used to select `zip_codes` from the `nyc_zip_codes` table that are in the `borough` of `Manhattan`.
- Complete the `CASE` statement sub-queries so that the `borough` column is populated by the correct `borough` name when the `zip_code` is matched.
- Use `NULL` to indicate that the `zip_code` value is not associated to any borough for later investigation.

**Answer**



```sql
%%sql
-- Select all zip codes from the borough of Manhattan
SELECT zip_code FROM nyc_zip_codes WHERE borough = 'Manhattan';

```





```sql
%%sql
SELECT 
	event_id,
	CASE 
      WHEN zip_code IN (SELECT zip_code FROM nyc_zip_codes WHERE borough = 'Manhattan') THEN 'Manhattan' 
      -- Match Brooklyn zip codes
      WHEN zip_code IN (SELECT zip_code FROM nyc_zip_codes WHERE borough = 'Brooklyn') THEN 'Brooklyn'
      -- Match Bronx zip codes
      WHEN zip_code IN (SELECT zip_code FROM nyc_zip_codes WHERE borough = 'Bronx') THEN 'Bronx'
      -- Match Queens zip codes
      WHEN zip_code IN (SELECT zip_code FROM nyc_zip_codes WHERE borough = 'Queens') THEN 'Queens'
      -- Match Staten Island zip codes
      WHEN zip_code IN (SELECT zip_code FROM nyc_zip_codes WHERE borough = 'Staten Island') THEN 'Staten Island'
      -- Use default for non-matching zip_code
      ELSE NULL 
    END as borough
FROM
	film_permit

```

## Converting Data

### Type conversion with a CASE clause

One of the `parking_violation` attributes included for each record is
the vehicle's location with respect to the street address of the
violation. An `'F'` value in the `violation_in_front_of_or_opposite`
column indicates the vehicle was in front of the recorded address. A
`'O'` value indicates the vehicle was on the opposite side of the
street. The column uses the `TEXT` type to represent the column values.
The same information could be captured using a `BOOLEAN`
(`true`/`false`) value which uses less memory.

In this exercise, you will convert `violation_in_front_of_or_opposite`
to a `BOOLEAN` column named `is_violation_in_front` using a `CASE`
clause. This column is `true` for records that occur in front of the
recorded address and `false` for records that occur opposite of the
recorded address.

**Instructions**

- Include one case condition that sets the value of
  `is_violation_in_front` to `true` when the
  `violation_in_front_of_or_opposite` value is equal to `'F'` for the
  record.
- Include another case condition that sets the value of
  `is_violation_in_front` to `false` when the
  `violation_in_front_of_or_opposite` value is equal to `'O'` for the
  record.

**Answer**



```sql
%%sql
SELECT
  CASE WHEN
          -- Use true when column value is 'F'
          violation_in_front_of_or_opposite = 'F' THEN true
       WHEN
          -- Use false when column value is 'O'
          violation_in_front_of_or_opposite = 'O' THEN false
       ELSE
          NULL
  END AS is_violation_in_front
FROM
  parking_violation;

```

### Applying aggregate functions to converted values

As demonstrated in the video exercise, converting a column's value from
`TEXT` to a number allows for calculations to be performed using
aggregation functions. The `summons_number` is of type `TEXT` in the
`parking_violation` dataset. The maximum (using `MAX(summons_number)`)
and minimum (using `MIN(summons_number)`) of the `TEXT` representation
`summons_number` can be calculated. If you, however, want to know the
size of the range (max - min) of `summon_number` values , this
calculation is not possible because the operation of subtraction on
`TEXT` types is not defined. First, converting `summons_number` to a
`BIGINT` will resolve this problem.

In this exercise, you will calculate the size of the range of
`summons_number` values as the difference between the maximum and
minimum `summons_number`.

**Instructions**

- Define the `range_size` for `summons_number` as the difference between
  the maximum `summons_number` and the minimum of the `summons_number`
  using the `summons_number` column after converting to the `BIGINT`
  type.

**Answer**



```sql
%%sql
SELECT
  -- Define the range_size from the max and min summons number
  MAX(summons_number::BIGINT) - MIN(summons_number::BIGINT) AS range_size
FROM
  parking_violation;

```

### Cleaning invalid dates

The `date_first_observed` column in the `parking_violation` dataset
represents the date when the parking violation was first observed by the
individual recording the violation. Unfortunately, not all
`date_first_observed` values were recorded properly. Some records
contain a `'0'` value for this column. A `'0'` value cannot be
interpreted as a `DATE` automatically as its meaning in this context is
ambiguous. The column values require cleaning to enable conversion to a
proper `DATE` column.

In this exercise, you will convert the `date_first_observed` value of
records with a `'0'` `date_first_observed` value into `NULL` values
using the `NULLIF()` function, so that the field can be represented as a
proper date.

**Instructions**

- Replace `'0'` values in the `date_first_observed` using the `NULLIF()`
  function.
- Convert the `TEXT` values in the `date_first_observed` column (with `NULL` in place of `'0'`) into `DATE` values.

**Answer**



```sql
%%sql
SELECT
  -- Replace '0' with NULL
  NULLIF(date_first_observed, '0') AS date_first_observed
FROM
  parking_violation;

```





```sql
%%sql
SELECT
  -- Convert date_first_observed into DATE
  DATE(NULLIF(date_first_observed, '0')) AS date_first_observed
FROM
  parking_violation;

```

### Converting and displaying dates

The `parking_violation` dataset with which we have been working has two
date columns where dates are represented in different formats:
`issue_date` and `date_first_observed`. This is the case because these
columns were imported into the database table as `TEXT` types. Using the
`DATE` formatting approaches covered in the video exercise, it is
possible to convert the dates from `TEXT` values into proper `DATE`
columns and then output the dates in a consistent format.

In this exercise, you will use `DATE()` to convert
`vehicle_expiration_date` and `issue_date` into `DATE` types and
`TO_CHAR()` to display each value in the `YYYYMMDD` format.

**Instructions**

- Convert the `TEXT` columns `issue_date` and `date_first_observed` to
  `DATE` types.
- Use the `TO_CHAR()` function to display the `issue_date` and `date_first_observed` `DATE` columns in the `YYYYMMDD` format.

**Answer**



```sql
%%sql
SELECT
  summons_number,
  -- Convert issue_date to a DATE
  DATE(issue_date) AS issue_date,
  -- Convert date_first_observed to a DATE
  DATE(date_first_observed) AS date_first_observed
FROM
  parking_violation;

```





```sql
%%sql
SELECT
  summons_number,
  -- Display issue_date using the YYYYMMDD format
  TO_CHAR(issue_date, 'YYYYMMDD') AS issue_date,
  -- Display date_first_observed using the YYYYMMDD format
  TO_CHAR(date_first_observed, 'YYYYMMDD') AS date_first_observed
FROM (
  SELECT
    summons_number,
    DATE(issue_date) AS issue_date,
    DATE(date_first_observed) AS date_first_observed
  FROM
    parking_violation
) sub

```

### Extracting hours from a time value

Your team has been tasked with generating a summary report to better
understand the hour of the day when most parking violations are
occurring. The `violation_time` field has been imported into the
database using strings consisting of the hour (in 12-hour format), the
minutes, and AM/PM designation for each violation. An example time
stored in this field is `'1225AM'`. **Note the lack of a colon and space
in this format**.

Use the `TO_TIMESTAMP()` function and the proper format string to
convert the `violation_time` into a `TIMESTAMP`, extract the hour from
the `TIME` component of this `TIMESTAMP`, and provide a count of all
parking violations by hour issued. The given conversion to a `TIME`
value is performed because `violation_time` values do not include date
information.

**Instructions**

- Convert `violation_time` to a `TIMESTAMP` using the `TO_TIMESTAMP()`
  function and a format string including 12-hour format (`HH12`),
  minutes (`MI`), and meridian indicator (`AM` or `PM`). `::TIME`
  converts the resulting timestamp value to a `TIME`.
- Exclude records with a `NULL`-valued `violation_time`.
- Use the `EXTRACT()` function to complete the query such that the first column of the resulting records is populated by the hour of the `violation_time`.

**Answer**



```sql
%%sql
SELECT
  -- Convert violation_time to a TIMESTAMP
  TO_TIMESTAMP(violation_time, 'HH12MIPM')::TIME AS violation_time
FROM
  parking_violation
WHERE
  -- Exclude NULL violation_time
  violation_time IS NOT NULL;

```





```sql
%%sql
SELECT
  -- Populate column with violation_time hours
  EXTRACT('hour' FROM violation_time) AS hour,
  COUNT(*)
FROM (
    SELECT
      TO_TIMESTAMP(violation_time, 'HH12MIPM')::TIME as violation_time
    FROM
      parking_violation
    WHERE
      violation_time IS NOT NULL
) sub
GROUP BY
  hour
ORDER BY
  hour

```

### A parking violation report by day of the month

Hearing anecdotal evidence that parking tickets are more likely to be
given out at the end of the month compared to during the month, you have
been tasked with preparing data to get a sense of the distribution of
tickets by day of the month. While the date on which the violation
occurred is included in the `parking_violation` dataset, it is currently
represented as a string date. While this presents an obstacle for
producing the data required, you feel confident in your ability to get
the data in the format that you need.

In this exercise, you will convert the strings representing the
`issue_date` into proper PostgreSQL `DATE` values. From this
representation of the data, you will extract the day of the month
required to produce the distribution of violations by month day.

**Instructions**

- Use one of the techniques introduced in this chapter to convert a
  string representing a date into a PostgreSQL `DATE` to convert
  `issue_date` into a `DATE` value.
- Extract the `day` from each `issue_date` returned by the subquery to create a column named `issue_day`.
- Include a second column providing the count for every day in which a violation occurred.

**Answer**



```sql
%%sql
SELECT
  -- Convert issue_date to a DATE value
  DATE(issue_date) AS issue_date
FROM
  parking_violation;

```





```sql
%%sql
SELECT
  -- Create issue_day from the day value of issue_date
  EXTRACT('day' FROM issue_date) AS issue_day,
  -- Include the count of violations for each day
  COUNT(*)
FROM (
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

```

### Risky parking behavior

The `parking_violation` table contains many parking violation details.
However, it's unclear what causes an individual to violate parking
restrictions. One hypothesis is that violators attempt to park in
restricted areas just before the parking restrictions end. You have been
asked to investigate this phenomenon. You first need to contend with the
fact that times in the `parking_violation` table are represented as
strings.

In this exercise, you will convert `violation_time`, and
`to_hours_in_effect` to `TIMESTAMP` values for violations that took
place in locations with partial day restrictions, calculate the interval
between the `violation_time` and `to_hours_in_effect` for these records,
and identify the records where the `violation_time` is less than 1 hour
before `to_hours_in_effect`.

**Instructions**

- Convert `violation_time` and `to_hours_in_effect` to `TIMESTAMP`
  values using `TO_TIMESTAMP()` and the appropriate format string.
  `::TIME` converts the value to a `TIME`.
- Exclude locations having **both** a `from_hours_in_effect` value of
  `1200AM` and a `to_hours_in_effect` value of `1159PM`.
- Use the `EXTRACT()` function to create two columns representing the number of hours and minutes, respectively, between `violation_time` and `to_hours_in_effect`.

**Answer**



```sql
%%sql
SELECT
  summons_number,
  -- Convert violation_time to a TIMESTAMP
  TO_TIMESTAMP(violation_time, 'HH12MIPM')::TIME as violation_time,
  -- Convert to_hours_in_effect to a TIMESTAMP
  TO_TIMESTAMP(to_hours_in_effect, 'HH12MIPM')::TIME as to_hours_in_effect
FROM
  parking_violation
WHERE
  -- Exclude all day parking restrictions
  NOT (from_hours_in_effect = '1200AM' AND to_hours_in_effect = '1159PM');

```





```sql
%%sql
SELECT
  summons_number,
  -- Create column for hours between to_hours_in_effect and violation_time
  EXTRACT('hour' FROM to_hours_in_effect - violation_time) AS hours,
  -- Create column for minutes between to_hours_in_effect and violation_time
  EXTRACT('minute' FROM to_hours_in_effect - violation_time) AS minutes
FROM (
  SELECT
    summons_number,
    TO_TIMESTAMP(violation_time, 'HH12MIPM')::time as violation_time,
    TO_TIMESTAMP(to_hours_in_effect, 'HH12MIPM')::time as to_hours_in_effect
  FROM
    parking_violation
  WHERE
    NOT (from_hours_in_effect = '1200AM' AND to_hours_in_effect = '1159PM')
) sub

```





```sql
%%sql
SELECT
  -- Return the count of records
  COUNT(*)
FROM
  time_differences
WHERE
  -- Include records with a hours value of 0
  hours = 0 AND
  -- Include records with a minutes value of at most 59
  minutes <= 59;

```

## Transforming Data

### Tallying corner parking violations

The `parking_violation` table has two columns (`street_name` and
`intersecting_street`) with New York City streets. When the values for
both columns are not `NULL`, this indicates that the violation occurred
on a corner where two streets intersect. In an effort to identify street
corners that tend to be the location of frequent parking violations, you
have been tasked with identifying which violations occurred on a street
corner and the total number of violations at each corner.

In this exercise, you will concatenate the `street_name` and
`intersecting_street` columns to create a new `corner` column. Then all
parking violations occurring at a corner will be tallied by a SQL query.

**Instructions**

- Combine `street_name`, `' & '` (an ampersand surrounded by two
  spaces), and `intersecting_street` to create a column named `corner`.
  Write the query such that records without an `intersecting_street`
  value have `NULL` column entries.
- Use the `corner` query that you just completed to generate a column with the `corner` value and a second column with the total number of violations occurring at each corner.
- Exclude `corner` values that are `NULL`.

**Answer**



```sql
%%sql
SELECT
  -- Combine street_name, ' & ', and intersecting_street
  street_name || ' & ' || intersecting_street AS corner
FROM
  parking_violation;

```





```sql
%%sql
SELECT
  -- Include the corner in results
  corner,
  -- Include the total number of violations occurring at corner
  COUNT(*)
FROM (
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

```

### Creating a TIMESTAMP with concatenation

In a previous exercise, the `violation_time` column in the
`parking_violation` table was used to check that the recorded
`violation_time` is within the violation location's restricted times.
This presented a challenge in cases where restricted parking took place
overnight because, for these records, the `from_hours_in_effect` time is
later than the `to_hours_in_effect` time. This issue could be eliminated
by including a date in addition to the time of a violation.

In this exercise, you will begin the process of simplifying the
identification of overnight violations through the creation of the
`violation_datetime` column populated with `TIMESTAMP` values. This will
be accomplished by concatenating `issue_date` and `violation_time` and
converting the resulting strings to `TIMESTAMP` values.

**Instructions**

- Concatenate the `issue_date` column, a space character (`' '`), and
  the `violation_time` column to create a `violation_datetime` column in
  the query results.
- Complete the query so that the `violation_datetime` strings returned by the subquery are converted into proper `TIMESTAMP` values using the format string `MM/DD/YYYY HH12MIAM`.


**Answer**



```sql
%%sql
SELECT
  -- Concatenate issue_date and violation_time columns
  CONCAT(issue_date, ' ', violation_time) AS violation_datetime
FROM
  parking_violation;

```





```sql
%%sql
SELECT
  -- Convert violation_time to TIMESTAMP
  TO_TIMESTAMP(violation_datetime, 'MM/DD/YYYY HH12MIAM') AS violation_datetime
FROM (
  SELECT
    CONCAT(issue_date, ' ', violation_time) AS violation_datetime
  FROM
    parking_violation
) sub;

```

### Extracting time units with SUBSTRING()

In a previous exercise, you separated the interval between the
`violation_time` and `to_hours_in_effect` columns into their constituent
`hour` and `minute` time units. Some pre-cleaning of these values was
done behind the scenes to make the values more amenable for conversion
because of inconsistencies in the recording of these values. The
functions explored in this lesson provide an approach to extract values
from strings.

In this exercise, you will use `SUBSTRING()` to extract the hour and
minute units from time strings. This is an alternative approach to
extracting time units removing the need to convert the string to a
`TIMESTAMP` value to extract the time unit as was done previously.

**Instructions**

- Define the `hour` column as the substring starting at the 1st position
  in `violation_time` and extending 2 characters in length.
- Add a definition for the `minute` column in the results as the substring starting at the 3rd position in `violation_time` and extending 2 characters in length.

**Answer**



```sql
%%sql
SELECT
  -- Define hour column
  SUBSTRING(violation_time FROM 1 FOR 2) AS hour
FROM
  parking_violation;

```





```sql
%%sql
SELECT
  SUBSTRING(violation_time FROM 1 FOR 2) AS hour,
  -- Define minute column
  SUBSTRING(violation_time FROM 3 FOR 2) AS minute
FROM
  parking_violation;

```

### Extracting house numbers from a string

Addresses for the Queens borough of New York City are unique in that
[they often include
dashes](https://gothamist.com/news/does-queens-still-need-hyphenated-addresses)
in the house number component of the street address. For example, for
the address `86-16 60 Ave`, the house number is `16`, and `86` refers to
the closest cross street. Therefore, if we want the `house_number` to
strictly represent the house number where a parking violation occurred,
we need to extract the digits after the dash (`-`) to represent this
value.

In this exercise, you will use `STRPOS()`, `SUBSTRING()`, and `LENGTH()`
to extract the specific house number from Queens street addresses.

**Instructions**

- Write a query that returns the position in the `house_number` column
  where the first dash character (`-`) location is found or 0 if the
  `house_number` does not contain a dash (`-`).
- Complete the query such that `new_house_number` contains just the Queens house number. The house number begins **1 position beyond** the position containing a dash (`-`) and extends to the end of the original `house_number` value.

**Answer**



```sql
%%sql
SELECT
  -- Find the position of first '-'
  STRPOS(house_number, '-') AS dash_position
FROM
  parking_violation;

```





```sql
%%sql
SELECT
  house_number,
  -- Extract the substring after '-'
  SUBSTRING(
    -- Specify the column of the original house number
    house_number
    -- Calculate the position that is 1 beyond '-'
    FROM STRPOS(house_number, '-') + 1
    -- Calculate number characters from dash to end of string
    FOR LENGTH(house_number) - STRPOS(house_number, '-')
  ) AS new_house_number
FROM
  parking_violation;

```

### Splitting house numbers with a delimiter

In the previous exercise, you used `STRPOS()`, `LENGTH()`, and
`SUBSTRING()` to separate the actual house number for Queens addresses
from the value representing a cross street. In the video exercise, you
learned how strings can be split into parts based on a delimiter string
value.

In this exercise, you will extract the house number for Queens addresses
using the `SPLIT_PART()` function.

**Instructions**

- Write a query that returns the part of the `house_number` value after
  the dash character (`'-'`) (if a dash character is present in the
  column value) as the column `new_house_number`.

**Answer**



```sql
%%sql
SELECT
  -- Split house_number using '-' as the delimiter
  SPLIT_PART(house_number, '-', 2) AS new_house_number
FROM
  parking_violation
WHERE
  violation_county = 'Q';

```

### Mapping parking restrictions

You are interested in building a mobile parking recommendation app for
New York City. The goal is to use the `parking_violation` dataset to map
parking restrictions to a driver's location. Parking restrictions are
stored in the `days_parking_in_effect` column in a format that consists
of a string of 7 characters. Each position in the string represents a
day of the week (Monday-Sunday). A `B` indicates parking is restricted
and a `Y` indicates parking is allowed. A colleague has organized the
data from `parking_violation` by creating a table named
`parking_restrictions`, which includes the `street_address`,
`violation_county`, and `days_parking_in_effect`.

In this exercise, you will use `REGEXP_SPLIT_TO_TABLE()` and
`ROW_NUMBER()` to associate each street address to its parking
availability.

**Instructions**

- Use `REGEXP_SPLIT_TO_TABLE()` with the empty-string (`''`) as a
  `delimiter` to split `days_parking_in_effect` into a single
  availability symbol (`B` or `Y`).
- Include `street_address` and `violation_county` as columns so that
  each row contains these associated values.
- Use the `ROW_NUMBER()` function to enumerate each combination of `street_address` and `violation_county` values with a number from 1 (Monday) to 7 (Sunday) corresponding to the `daily_parking_restriction` values.


**Answer**



```sql
%%sql
SELECT
  -- Specify SELECT list columns
  street_address,
  violation_county,
  REGEXP_SPLIT_TO_TABLE(days_parking_in_effect, '') AS daily_parking_restriction
FROM
  parking_restriction;

```





```sql
%%sql
SELECT
  -- Label daily parking restrictions for locations by day
  ROW_NUMBER() OVER(
    PARTITION BY
        street_address, violation_county
    ORDER BY
        street_address, violation_county
  ) AS day_number,
  *
FROM (
  SELECT
    street_address,
    violation_county,
    REGEXP_SPLIT_TO_TABLE(days_parking_in_effect, '') AS daily_parking_restriction
  FROM
    parking_restriction
) sub;

```

### Selecting data for a pivot table

In an effort to get a better understanding of which agencies are
responsible for different types of parking violations, you have been
tasked with creating a report providing these details. This report will
focus on four issuing agencies: `Police Department` (`P`),
`Department of Sanitation` (`S`), `Parks Department` (`K`), and
`Department of Transportation` (`V`). All of the records required to
create such a report are present in the `parking_violations` table. An
`INTEGER` `violation_code` and `CHAR` `issuing_agency` is recorded for
every `parking_violation`.

In this exercise, you will write a `SELECT` query that provides the
underlying data for your report: the parking violation code, the issuing
agency code, and the total number of records with each pair of values.

**Instructions**

- Include `violation_code` and `issuing_agency` in the `SELECT` list for
  the query.
- For each `violation_code` and `issuing_agency` pair, include the
  number of records containing the pair in the `SELECT` list.
- Restrict the results to the agencies of interest based on their
  single-character code (`P`, `S`, `K`, `V`).

**Answer**



```sql
%%sql
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
	violation_code, issuing_agency
ORDER BY 
	violation_code, issuing_agency;

```

### Using FILTER to create a pivot table

In the previous exercise, you wrote a query that provided information on
the number of parking violations (by their numerical code) issued by
each of four agencies. The results contained all of the desired
information but were presented in a format that included a duplicate
display of each `violation_code` up to four times (for every
`issuing_agency` selected) in the results. A more compact representation
of the same data can be achieved through the creation of a pivot table.

In this exercise, you will write a query using the `FILTER` clause to
produce results in a pivot table format. This improved presentation of
the data can more easily be used in the report for parking violations
issued by each of the four agencies of interest.

**Instructions**

- Define the `Police` column as the number of records for each
  `violation_code` with an `issuing_agency` value of `P`.
- Define the `Sanitation` column as the number of records for each
  `violation_code` with an `issuing_agency` value of `S`.
- Define the `Parks` column as the number of records for each
  `violation_code` with an `issuing_agency` value of `K`.
- Define the `Transportation` column as the number of records for each
  `violation_code` with an `issuing_agency` value of `V`.

**Answer**



```sql
%%sql
SELECT 
	violation_code,
    -- Define the "Police" column
	COUNT(issuing_agency) FILTER (WHERE issuing_agency = 'P') AS "Police",
    -- Define the "Sanitation" column
	COUNT(issuing_agency) FILTER (WHERE issuing_agency = 'S') AS "Sanitation",
    -- Define the "Parks" column
	COUNT(issuing_agency) FILTER (WHERE issuing_agency = 'K') AS "Parks",
    -- Define the "Transportation" column
	COUNT(issuing_agency) FILTER (WHERE issuing_agency = 'V') AS "Transportation"
FROM 
	parking_violation 
GROUP BY 
	violation_code
ORDER BY 
	violation_code

```

### Aggregating film categories

For the final exercise in this course, let's return to the `film_permit`
table. It contains a `community_board` `TEXT` column composed of a
comma-separated list of integers. There is interest in doing an analysis
of the types of film permits that are being provided for each community
board. However, the representation of community boards (`INTEGER`s in a
`TEXT` column) makes this difficult. By using techniques learned in this
chapter, the data can be transformed to allow for such an analysis.

In this exercise, you will first create a (temporary) `VIEW` that
represents the `community_board` values individually for two permit
categories. A `VIEW` is a named query that can be used like a `TABLE`
once created. You will use this `VIEW` in a subquery for aggregating the
results in a pivot table.

**Instructions**

- Use `REGEXP_SPLIT_TO_TABLE()` to split `community_board` into multiple
  **rows** using a comma (`','`) followed by a space character (`' '`)
  as the **2-character** delimiter.
- Restrict the `category` values to `'Film'`, `'Television'`, and
  `'Documentary'`.
- Convert `community_board` values to `INTEGER` so that `community_board` values are listed in ascending order.
- Define the `Film`, `Television`, and `Documentary` pivot table columns as the number of permits of each type for each community board.

**Answer**



```sql
%%sql
CREATE OR REPLACE TEMP VIEW cb_categories AS  
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
SELECT * FROM cb_categories;

```





```sql
%%sql
SELECT
	-- Convert community_board data type
	CAST(community_board AS INTEGER) AS community_board,
    -- Define pivot table columns
	COUNT(category) FILTER(where category = 'Film') AS "Film",
    COUNT(category) FILTER(where category = 'Television') AS "Television",
	COUNT(category) FILTER(where category = 'Documentary') AS "Documentary"
FROM
	cb_categories
GROUP BY 
	community_board
ORDER BY 
	community_board;

```
