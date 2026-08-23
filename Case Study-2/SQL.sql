
-- Joining the two tables
SELECT 
     A.User_id,
     A.`First_Name`,
     A.Surname,
     A.Email,
     A.Gender,
     A.Race,
     A.Age,
     A.Province,
     A.`Social_Media_Handle`,
     B.`Channel_2`,
     B.`Record_Date_2`,
     B.`Duration_2`
     FROM workspace.brighttv.user_profile A
     JOIN workspace.brighttv.viewership B
     ON A.User_id = B.User_id0; 


--Creating a new joined table

    CREATE TABLE brighttv_joined AS
     SELECT 
     A.User_id,
     A.`First_Name`,
     A.Surname,
     A.Email,
     A.Gender,
     A.Race,
     A.Age,
     A.Province,
     A.`Social_Media_Handle`,
     B.`Channel_2`,
     B.`Record_Date_2`,
     B.`Duration_2`
     FROM workspace.brighttv.user_profile A
     JOIN workspace.brighttv.viewership B
     ON A.User_id = B.User_id0; 


--Verifying Data
     SELECT*
FROM workspace.default.brighttv_joined
LIMIT 10;

--Check duplicates

SELECT *,
     COUNT (*) AS duplicate_count
FROM workspace.default.brighttv_joined
GROUP BY ALL
HAVING COUNT (*) > 1;

-- Total rows in the joined table before cleaning
SELECT COUNT(*) AS total_rows
FROM workspace.default.brighttv_joined;


 SELECT DISTINCT *
 FROM workspace.default.brighttv_joined;

 -- Nulls by column, to see where they're coming from
    SUM(CASE WHEN Province IS NULL THEN 1 ELSE 0 END) AS null_province,
    SUM(CASE WHEN Gender IS NULL THEN 1 ELSE 0 END) AS null_gender,
    SUM(CASE WHEN Channel_2 IS NULL THEN 1 ELSE 0 END) AS null_channel,
    SUM(CASE WHEN Duration_2 IS NULL THEN 1 ELSE 0 END) AS null_duration,
    SUM(CASE WHEN Record_Date_2 IS NULL THEN 1 ELSE 0 END) AS null_date
FROM workspace.default.brighttv_joined;


SELECT *
 FROM workspace.default.brighttv_joined
 WHERE Province IS NULL;


........................................................................................

--User Trends
SELECT 
     COUNT(DISTINCT User_id) As total_users
FROM workspace.default.brighttv_joined;

---Users by province

SELECT 
     Province,
     COUNT(DISTINCT User_id) As total_users
FROM workspace.default.brighttv_joined
GROUP BY Province
ORDER BY total_users DESC;

--User by Gender

SELECT 
     Gender,
     COUNT(DISTINCT User_id) As total_users
FROM workspace.default.brighttv_joined
GROUP BY Gender

--order by total_users DESC; 
SELECT 
     Gender,
     COUNT (*) AS records
     FROM workspace.default.brighttv_joined
     GROUP BY Gender
     ORDER BY records DESC;


--Total Usage 
SELECT
    COUNT(DISTINCT User_id) AS total_users
FROM workspace.default.brighttv_joined;

--Total Sessions

SELECT 
COUNT(*) AS total_sessions
FROM workspace.default.brighttv_joined;

--Sessions by Channel
SELECT 
     channel_2,
     COUNT(*) AS total_sessions
FROM workspace.default.brighttv_joined
GROUP BY Channel_2
ORDER BY total_sessions DESC;


--Total Viewing duration by channel
SELECT 
Channel_2,
SUM(Duration_2) AS total_duration
FROM workspace.default.brighttv_joined
GROUP BY Channel_2
ORDER BY total_duration DESC;

--Average session duration by Channel
SELECT 
     Channel_2,
     AVG(Duration_2) AS average_session_duration
FROM workspace.default.brighttv_joined
GROUP BY Channel_2
ORDER BY average_session_duration DESC;

--Consumption by Gender

SELECT
     Gender,
     COUNT(*) AS sessions,
     SUM(Duration_2) AS total_duration,
     AVG(Duration_2) AS average_duration
FROM workspace.default.brighttv_joined
GROUP BY Gender
ORDER BY total_duration DESC;

--comsumption by age

SELECT
     Age,
     COUNT(*) AS sessions,
     SUM(Duration_2) AS total_duration,
     AVG(Duration_2) AS average_duration
FROM workspace.default.brighttv_joined
GROUP BY Age
ORDER BY total_duration DESC;

--Consumption by Province

SELECT
     Province,
     COUNT(*) AS sessions,
     SUM(Duration_2) AS total_duration,
     AVG(Duration_2) AS average_duration
FROM workspace.default.brighttv_joined
GROUP BY Province
ORDER BY total_duration DESC;

--Consumption by Channel AND Gender

SELECT
     Gender,
     Channel_2,
     COUNT(*) AS sessions,
     SUM(Duration_2) AS total_duration,
     AVG(Duration_2) AS average_duration
FROM workspace.default.brighttv_joined
GROUP BY Gender, Channel_2
ORDER BY total_duration DESC;

--Days with Low Consumption

SELECT
    Record_Date_2,
    COUNT(*) AS total_sessions,
    SUM(Duration_2) AS total_duration
FROM brighttv_joined
GROUP BY Record_Date_2
ORDER BY total_sessions ASC;

--string into a proper timestamp
SELECT
    Record_Date_2,
    TO_TIMESTAMP(SPLIT_PART(Record_Date_2, '.', 1), 'M/d/yyyy H:mm') AS record_datetime_utc
FROM workspace.default.brighttv_joined;

--convert UTC → SA time
SELECT
    Record_Date_2,
    TO_TIMESTAMP(SPLIT_PART(Record_Date_2, '.', 1), 'M/d/yyyy H:mm') AS record_datetime_utc,
    TO_TIMESTAMP(SPLIT_PART(Record_Date_2, '.', 1), 'M/d/yyyy H:mm') + INTERVAL 2 HOURS AS record_datetime_sast
FROM workspace.default.brighttv_joined;


SELECT
    Record_Date_2,
    DATE(record_datetime_sast)      AS record_date_sast,
    HOUR(record_datetime_sast)      AS record_hour_sast,
    DAYOFWEEK(record_datetime_sast) AS day_of_week_sast,   -- 1=Sunday, 7=Saturday
    DATE_FORMAT(record_datetime_sast, 'EEEE') AS day_name_sast
FROM ( SELECT
        Record_Date_2,
        TO_TIMESTAMP(SPLIT_PART(Record_Date_2, '.', 1), 'M/d/yyyy H:mm') + INTERVAL 2 HOURS AS record_datetime_sast
    FROM workspace.default.brighttv_joined);

.............................................................................
SELECT
    User_id,
    Gender,
    Age,
    Province,
    Channel_2,
    DATE(record_datetime_sast)                AS record_date_sast,
    HOUR(record_datetime_sast)                 AS record_hour_sast,
    DATE_FORMAT(record_datetime_sast, 'EEEE')  AS day_name_sast,
    COUNT(*)         AS total_sessions,
    COUNT(DISTINCT User_id) AS total_users,
    SUM(Duration_2)  AS total_duration,
    AVG(Duration_2)  AS average_duration

FROM (SELECT DISTINCT
        User_id,
        Gender,
        Age,
        Province,
        Channel_2,
        Duration_2,
        TO_TIMESTAMP(SPLIT_PART(Record_Date_2, '.', 1), 'M/d/yyyy H:mm')
            + INTERVAL 2 HOURS AS record_datetime_sast
    FROM workspace.default.brighttv_joined
    WHERE Province IS NOT NULL
      AND Duration_2 IS NOT NULL
      AND Record_Date_2 IS NOT NULL) cleaned_data
GROUP BY
    User_id,
    Gender,
    Age,
    Province,
    Channel_2,
    DATE(record_datetime_sast),
    HOUR(record_datetime_sast),
    DATE_FORMAT(record_datetime_sast, 'EEEE')
ORDER BY total_duration DESC;