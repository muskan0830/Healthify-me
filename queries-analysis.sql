SELECT * FROM sales_call

SELECT COUNT(*) FROM sales_call;

SELECT DISTINCT(india_vs_nri) FROM sales_call;
SELECT DISTINCT(medicalconditionflag) FROM sales_call;
SELECT DISTINCT(funnel) FROM sales_call;
SELECT DISTINCT(event_type) FROM sales_call;
SELECT DISTINCT(current_status) FROM sales_call;
SELECT DISTINCT(booked_flag) FROM sales_call;
SELECT DISTINCT(target_class) FROM sales_call;
SELECT DISTINCT(payment) FROM sales_call;


--1. What are the key factors influencing successful bookings, and how do they vary between Indian and NRI users?

SELECT india_vs_nri,
       (COUNT(*) * 100.0)/(SELECT COUNT(*) FROM sales_call) AS Percentage
FROM sales_call
WHERE booked_flag = 'Booked'
GROUP BY india_vs_nri;
-- 87% booked : Indians, 12%: NRI

--2. Is there a correlation between the presence of medical conditions and booking success?

SELECT medicalconditionflag,
       (COUNT(*) * 100.0)/(SELECT COUNT(*) FROM sales_call) AS Percentage
FROM sales_call
WHERE booked_flag = 'Booked'
GROUP BY medicalconditionflag;
-- 61%:No, 38%: Yes

--3. Can we identify patterns in the funnel stages that lead to higher conversion rates?

SELECT funnel,
       (COUNT(*) * 100.0)/(SELECT COUNT(*) FROM sales_call) AS Percentage
FROM sales_call
WHERE booked_flag = 'Booked'
GROUP BY funnel;
--56.6%:FT, 43%:Bot

--4. Are there specific times or slots that result in higher booking success?
SELECT
    EXTRACT(MONTH FROM handled_time) AS handled_month,
    COUNT(*) * 100.0 / (SELECT COUNT(*) FROM sales_call) AS month_percentage
FROM
    sales_call
WHERE
    booked_flag = 'Booked'
GROUP BY
    handled_month
ORDER BY
    month_percentage DESC;
-- maximum booked in january: 53% and december 46%


SELECT
    EXTRACT(DOW FROM handled_time) AS handled_weekday,
    COUNT(*) * 100.0 / (SELECT COUNT(*) FROM sales_call) AS weekday_percentage
FROM
    sales_call
WHERE
    booked_flag = 'Booked'
GROUP BY
    handled_weekday
ORDER BY
    weekday_percentage DESC;
--Monday maximum:16%, saturday: 15%

SELECT
    EXTRACT(DAY FROM handled_time) AS handled_day,
    COUNT(*) * 100.0 / (SELECT COUNT(*) FROM sales_call) AS day_percentage
FROM
    sales_call
WHERE
    booked_flag = 'Booked'
GROUP BY
    handled_day
ORDER BY
    day_percentage DESC;
-- 3rd day of the month : 4% , 4th day, 7th, 5th day i.e. first week of the month

SELECT
    EXTRACT(HOUR FROM handled_time) AS handled_hour,
    COUNT(*) * 100.0 / (SELECT COUNT(*) FROM sales_call) AS hour_percentage
FROM
    sales_call
WHERE
    booked_flag = 'Booked'
GROUP BY
    handled_hour
ORDER BY
    hour_percentage DESC;
-- 11 A.M. : 11%, 10 AM: 10%, 12 PM,14,15: 9%
--, 16 PM:8%

--5. What role does the expertise of the assigned expert play in successful bookings?
SELECT target_class,
       (COUNT(*) * 100.0)/(SELECT COUNT(*) FROM sales_call) AS Percentage
FROM sales_call
WHERE booked_flag = 'Booked'
GROUP BY target_class
ORDER BY 2 DESC;
-- Most booked by C: 36% then A: 28%



-- PAYMENT/ conversion success
--conversion rate
SELECT
    ROUND((COUNT(CASE WHEN payment = 1 THEN 1 END) * 100.0) / COUNT(*),0) AS conversion_rate
FROM
    sales_call;
-- 5%

--1. NRI V/S INDIANS
SELECT
    india_vs_nri,
    ROUND((COUNT(*) * 100.0) / (SELECT COUNT(*) FROM sales_call WHERE payment = 1), 2) AS Percentage
FROM
    sales_call
WHERE
    payment = 1
GROUP BY
    india_vs_nri;
-- 82% indians, 17.5% NRI

--2. MEDICAL HISTORY
SELECT medicalconditionflag,
       ROUND((COUNT(*) * 100.0) / (SELECT COUNT(*) FROM sales_call WHERE payment = 1), 2) AS Percentage
FROM sales_call
WHERE payment = 1
GROUP BY medicalconditionflag;
-- 52.65%:No, 47.35%: Yes

--3. Funnel
SELECT funnel,
       ROUND((COUNT(*) * 100.0) / (SELECT COUNT(*) FROM sales_call WHERE payment = 1), 2) AS Percentage
FROM sales_call
WHERE payment = 1
GROUP BY funnel;
--58% BOT, 41% FT(Free Trial)

--4. DURATION AND CONVERSION
SELECT
    EXTRACT(MONTH FROM handled_time) AS handled_month,
    ROUND((COUNT(*) * 100.0) / (SELECT COUNT(*) FROM sales_call WHERE payment = 1), 2) AS month_percentage
FROM
    sales_call
WHERE
    payment = 1
GROUP BY
    handled_month
ORDER BY
    month_percentage DESC;
-- maximum in january: 53% and december 47%


SELECT
    EXTRACT(DOW FROM handled_time) AS handled_weekday,
    ROUND((COUNT(*) * 100.0) / (SELECT COUNT(*) FROM sales_call WHERE payment = 1), 2) AS weekday_percentage
FROM
    sales_call
WHERE
    payment = 1
GROUP BY
    handled_weekday
ORDER BY
    weekday_percentage DESC;
--Tuesday maximum:17%, Wednesday-saturday: 15%

SELECT
    EXTRACT(DAY FROM handled_time) AS handled_day,
    ROUND((COUNT(*) * 100.0) / (SELECT COUNT(*) FROM sales_call WHERE payment = 1), 2) AS day_percentage
FROM
    sales_call
WHERE
    payment = 1
GROUP BY
    handled_day
ORDER BY
    day_percentage DESC;
-- 4th,7th day of the month : 5% ,  5th, 1st day i.e. first week of the month

SELECT
    EXTRACT(HOUR FROM handled_time) AS handled_hour,
    ROUND((COUNT(*) * 100.0) / (SELECT COUNT(*) FROM sales_call WHERE payment = 1), 2) AS hour_percentage
FROM
    sales_call
WHERE
    payment = 1
GROUP BY
    handled_hour
ORDER BY
    hour_percentage DESC;
-- 10 A.M. : 11%, 11 AM: 10%, 12 PM,14: 9% i.e. morning: 10-12 or 14-18 evening


--4. Target class
SELECT target_class,
       ROUND((COUNT(*) * 100.0) / (SELECT COUNT(*) FROM sales_call WHERE payment = 1), 2) AS Percentage
FROM sales_call
WHERE payment = 1
GROUP BY target_class
ORDER BY 2 DESC;
-- A: 39%, C: 28%