CREATE TABLE applestore_description_combined AS
SELECT * FROM appleStore_description1
UNION ALL
SELECT * FROM appleStore_description2
UNION ALL
SELECT * FROM appleStore_description3
UNION ALL
SELECT * FROM appleStore_description4

**EXPLORATORY DATA ANALYSIS**

--The number of unique apps in both tables 

SELECT cOUNT(DISTINCT id) AS unique_app_ids
FROM AppleStore

SELECT COUNT(DISTINCT id) AS unique_app_ids
FROM applestore_description_combined

--Checking for any missing values in key fields

SELECT COUNT(*) AS missing_values
FROM AppleStore
WHERE track_name IS NULL OR user_rating IS NULL OR prime_genre IS NULL

SELECT COUNT(*) AS missing_values
FROM applestore_description_combined
WHERE app_desc IS NULL

--The number of apps per genre

SELECT prime_genre, COUNT(*) AS num_apps
FROM AppleStore
GROUP BY prime_genre
ORDER BY num_apps DESC

--Overview of app's ratings

SELECT min(user_rating) AS min_rating,
       max(user_rating) AS max_rating,
       avg(user_rating) AS avg_rating
FROM AppleStore

--Distribution of app prices

SELECT (price/2)*2 AS price_bin_start,
       ((price/2)*2)+2 AS price_bin_end,
       COUNT(*) AS num_apps
FROM AppleStore
GROUP BY price_bin_start
ORDER BY price_bin_start

**DATA ANALYSIS**

--Determining whether paid apps have higher ratings than free apps

SELECT CASE
        WHEN price > 0 THEN 'Paid'
        ELSE 'Free'
    END AS app_type,
    avg(user_rating) AS avg_rating
FROM AppleStore
GROUP BY app_type

--Checking whether apps with more supported languages have higher ratings

SELECT CASE
        WHEN lang_num < 10 THEN '<10 languages'
        WHEN lang_num BETWEEN 10 AND 30 THEN '10-30 languages'
        ELSE '>30 languages'
    END AS language_bucket,
    avg(user_rating) AS avg_rating
FROM AppleStore
GROUP BY language_bucket
ORDER BY avg_rating DESC

--Genres with low ratings

SELECT prime_genre,
       avg(user_rating) AS avg_rating
FROM AppleStore
GROUP BY prime_genre
Order BY avg_rating ASC
LIMIT 10

--Checking if there is correlation between the length of the app description and the user rating

SELECT CASE
        WHEN length(b.app_desc) <500 THEN 'Short'
        WHEN length(b.app_desc) BETWEEN 500 AND 1000 THEN 'Medium'
        ELSE 'Long'
    END AS description_length_bucket,
    avg(a.user_rating) As average_rating
FROm AppleStore AS a
JOIN applestore_description_combined AS b
ON a.id = b.id
GROUP BY description_length_bucket
ORDER BY average_rating DESC

--Top rated apps in each genre 

SELECT prime_genre,
       track_name,
       user_rating
FROM (
    SELECT prime_genre,
         track_name,
         user_rating,
         RANK() OVER(PARTITION BY prime_genre ORDER BY user_rating DESC, rating_count_tot DESC) AS rank
    FROM AppleStore
    ) AS a 
WHERe a.rank = 1










