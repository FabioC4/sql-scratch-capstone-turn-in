/* Fabio Cerullo - June 5 Cohort - Capstone Option 3 */


/* PART 1 - A Get familiar with CoolTShirts */

SELECT COUNT (DISTINCT utm_campaign) AS 'NUMBER OF CAMPAIGNS'
FROM page_visits;

SELECT COUNT (DISTINCT utm_source) AS 'NUMBER OF SOURCES'
FROM page_visits;

SELECT DISTINCT utm_source AS 'SOURCES', utm_campaign AS 'CAMPAIGNS'
FROM page_visits;

/* PART 1 - B What pages are on the CoolTShirts website? */

SELECT DISTINCT page_name AS 'PAGES'
FROM page_visits;

/* PART 2 - A How many first touches is each campaign responsible for? */

WITH first_touch AS (
    SELECT user_id,
        MIN(timestamp) as first_touch_at
    FROM page_visits
    GROUP BY user_id),
ft_attr AS (
  SELECT ft.user_id,
         ft.first_touch_at,
         pv.utm_source,
		     pv.utm_campaign
FROM first_touch AS 'ft'
JOIN page_visits AS 'pv'
    ON   ft.user_id = pv.user_id
    AND  ft.first_touch_at = pv.timestamp
)
SELECT ft_attr.utm_source AS 'SOURCE',
       ft_attr.utm_campaign AS 'CAMPAIGN',
       COUNT(*) AS 'FIRTS TOUCH NUMBER OF USERS'
FROM ft_attr
GROUP BY 1, 2
ORDER BY 3 DESC;

/* PART 2 - B How many last touches is each campaign responsible for? */

WITH last_touch AS (
    SELECT user_id,
        MAX(timestamp) as last_touch_at
    FROM page_visits
    GROUP BY user_id),
lt_attr AS (
  SELECT lt.user_id,
         lt.last_touch_at,
         pv.utm_source,
		     pv.utm_campaign
FROM last_touch AS 'lt'
JOIN page_visits AS 'pv'
    ON   lt.user_id = pv.user_id
    AND  lt.last_touch_at = pv.timestamp
)
SELECT lt_attr.utm_source AS 'SOURCE',
       lt_attr.utm_campaign AS 'CAMPAIGN',
       COUNT(*) AS 'LAST TOUCH NUMBER OF USERS'
FROM lt_attr
GROUP BY 1, 2
ORDER BY 3 DESC;

/* PART 2 - C How many visitors make a purchase? */

SELECT COUNT (DISTINCT user_id) AS 'USERS WHO PURCHASED'
FROM page_visits
WHERE page_name = '4 - purchase';

/* PART 2 - D How many last touches on the purchase page is each campaign responsible for? */

WITH last_touch AS (
    SELECT user_id,
           MAX(timestamp) as last_touch_at
    FROM page_visits
    WHERE page_name = '4 - purchase'
    GROUP BY user_id),
lt_attr AS (
  SELECT lt.user_id,
         lt.last_touch_at,
         pv.utm_source,
		     pv.utm_campaign
FROM last_touch AS 'lt'
JOIN page_visits AS 'pv'
    ON   lt.user_id = pv.user_id
    AND  lt.last_touch_at = pv.timestamp
)
SELECT lt_attr.utm_source AS 'SOURCE',
       lt_attr.utm_campaign AS 'CAMPAIGN',
       COUNT(*) AS 'USERS WHO PURCHASED'
FROM lt_attr
GROUP BY 1, 2
ORDER BY 3 DESC;

/* PART 2 - E What is the typical user journey? */

SELECT *
FROM page_visits
LIMIT 17;

SELECT user_id AS 'USER', page_name AS 'LAST PAGE VISITED'
FROM page_visits
GROUP BY 1
LIMIT 5;