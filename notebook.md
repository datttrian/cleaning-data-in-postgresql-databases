# Cleaning Data in PostgreSQL Databases

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

```{python}

```

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

```{python}

```

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

```{python}

```

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

```{python}

```

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

```{python}

```

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

```{python}

```

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

```{python}

```

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

```{python}

```

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

```{python}

```

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

```{python}

```

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

```{python}

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

```{python}

```

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

```{python}

```

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

```{python}

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

```{python}

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

```{python}

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

```{python}

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

**Answer**

```{python}

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

**Answer**

```{python}

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

**Answer**

```{python}

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

**Answer**

```{python}

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

**Answer**

```{python}

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

**Answer**

```{python}

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

**Answer**

```{python}

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

**Answer**

```{python}

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

**Answer**

```{python}

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

```{python}

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

**Answer**

```{python}

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

```{python}

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

```{python}

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

**Answer**

```{python}

```

