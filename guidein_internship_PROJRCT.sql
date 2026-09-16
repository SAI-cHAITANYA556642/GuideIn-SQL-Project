/* ============================================================
   GUIDEIN INTERNSHIP PROJECT
   MYSQL - COMPLETE SQL SCRIPT
   ============================================================ */


/* ============================================================
   1. CREATE DATABASE
   ============================================================ */

CREATE DATABASE guidein_analysis;



USE guidein_analysis;




/* ============================================================
   2. DROP TABLE IF ALREADY EXISTS
   ============================================================ */

DROP TABLE IF EXISTS guidein_dataset;


/* ============================================================
   3. CREATE TABLE
   ============================================================ */

CREATE TABLE guidein_dataset (
    user_id INT PRIMARY KEY,
    visit_date DATE,
    visited INT,
    registered INT,
    logged_in INT,
    subscribed INT,
    service TEXT,
    source TEXT,
    device TEXT
);


/* ============================================================
   4. IMPORT CSV DATA
   ============================================================ */

LOAD DATA LOCAL INFILE 'F:/guidein_project/guidein_internship_dataset.csv'
INTO TABLE guidein_dataset
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


/* ============================================================
   5. VIEW ALL DATA
   ============================================================ */

SELECT *
FROM guidein_dataset;


/* ============================================================
   6. VIEW FIRST 500 RECORDS
   ============================================================ */

SELECT *
FROM guidein_dataset
LIMIT 500;


/* ============================================================
   7. CHECK TOTAL NUMBER OF RECORDS
   ============================================================ */

SELECT
    COUNT(*) AS total_records
FROM guidein_dataset;


/* ============================================================
   8. CHECK DISTINCT USERS
   ============================================================ */

SELECT
    COUNT(DISTINCT user_id) AS total_users
FROM guidein_dataset;


/* ============================================================
   9. CHECK DUPLICATE USER IDs
   ============================================================ */

SELECT
    user_id,
    COUNT(*) AS duplicate_count
FROM guidein_dataset
GROUP BY user_id
HAVING COUNT(*) > 1;


/* ============================================================
   10. CHECK NULL VALUES
   ============================================================ */

SELECT
    SUM(CASE WHEN user_id IS NULL THEN 1 ELSE 0 END) AS null_user_id,
    SUM(CASE WHEN visit_date IS NULL THEN 1 ELSE 0 END) AS null_visit_date,
    SUM(CASE WHEN visited IS NULL THEN 1 ELSE 0 END) AS null_visited,
    SUM(CASE WHEN registered IS NULL THEN 1 ELSE 0 END) AS null_registered,
    SUM(CASE WHEN logged_in IS NULL THEN 1 ELSE 0 END) AS null_logged_in,
    SUM(CASE WHEN subscribed IS NULL THEN 1 ELSE 0 END) AS null_subscribed,
    SUM(CASE WHEN service IS NULL THEN 1 ELSE 0 END) AS null_service,
    SUM(CASE WHEN source IS NULL THEN 1 ELSE 0 END) AS null_source,
    SUM(CASE WHEN device IS NULL THEN 1 ELSE 0 END) AS null_device
FROM guidein_dataset;


/* ============================================================
   11. CHECK DATE RANGE
   ============================================================ */

SELECT
    MIN(visit_date) AS first_visit_date,
    MAX(visit_date) AS last_visit_date
FROM guidein_dataset;


/* ============================================================
   12. TOTAL FUNNEL USERS
   ============================================================ */

SELECT

    COUNT(DISTINCT user_id) AS total_users,

    SUM(
        CASE
            WHEN visited = 1 THEN 1
            ELSE 0
        END
    ) AS visited_users,

    SUM(
        CASE
            WHEN registered = 1 THEN 1
            ELSE 0
        END
    ) AS registered_users,

    SUM(
        CASE
            WHEN logged_in = 1 THEN 1
            ELSE 0
        END
    ) AS logged_in_users,

    SUM(
        CASE
            WHEN subscribed = 1 THEN 1
            ELSE 0
        END
    ) AS subscribed_users

FROM guidein_dataset;


/* ============================================================
   13. VISIT → REGISTER CONVERSION
   ============================================================ */

SELECT

    ROUND(
        SUM(
            CASE
                WHEN registered = 1 THEN 1
                ELSE 0
            END
        ) * 100.0
        /
        NULLIF(
            SUM(
                CASE
                    WHEN visited = 1 THEN 1
                    ELSE 0
                END
            ),
            0
        ),
        2
    ) AS visit_to_register_conversion

FROM guidein_dataset;


/* ============================================================
   14. REGISTER → LOGIN CONVERSION
   ============================================================ */

SELECT

    ROUND(
        SUM(
            CASE
                WHEN logged_in = 1 THEN 1
                ELSE 0
            END
        ) * 100.0
        /
        NULLIF(
            SUM(
                CASE
                    WHEN registered = 1 THEN 1
                    ELSE 0
                END
            ),
            0
        ),
        2
    ) AS register_to_login_conversion

FROM guidein_dataset;


/* ============================================================
   15. LOGIN → SUBSCRIBE CONVERSION
   ============================================================ */

SELECT

    ROUND(
        SUM(
            CASE
                WHEN subscribed = 1 THEN 1
                ELSE 0
            END
        ) * 100.0
        /
        NULLIF(
            SUM(
                CASE
                    WHEN logged_in = 1 THEN 1
                    ELSE 0
                END
            ),
            0
        ),
        2
    ) AS login_to_subscribe_conversion

FROM guidein_dataset;


/* ============================================================
   16. COMPLETE FUNNEL + CONVERSION RATES
   ============================================================ */

SELECT

    COUNT(DISTINCT user_id) AS total_users,

    SUM(CASE WHEN visited = 1 THEN 1 ELSE 0 END) AS visitors,

    SUM(CASE WHEN registered = 1 THEN 1 ELSE 0 END) AS registrations,

    SUM(CASE WHEN logged_in = 1 THEN 1 ELSE 0 END) AS logins,

    SUM(CASE WHEN subscribed = 1 THEN 1 ELSE 0 END) AS subscriptions,

    ROUND(
        SUM(CASE WHEN registered = 1 THEN 1 ELSE 0 END)
        * 100.0 /
        NULLIF(SUM(CASE WHEN visited = 1 THEN 1 ELSE 0 END),0),
        2
    ) AS visit_to_register_rate,

    ROUND(
        SUM(CASE WHEN logged_in = 1 THEN 1 ELSE 0 END)
        * 100.0 /
        NULLIF(SUM(CASE WHEN registered = 1 THEN 1 ELSE 0 END),0),
        2
    ) AS register_to_login_rate,

    ROUND(
        SUM(CASE WHEN subscribed = 1 THEN 1 ELSE 0 END)
        * 100.0 /
        NULLIF(SUM(CASE WHEN logged_in = 1 THEN 1 ELSE 0 END),0),
        2
    ) AS login_to_subscribe_rate

FROM guidein_dataset;


/* ============================================================
   17. OVERALL SUBSCRIPTION RATE
   ============================================================ */

SELECT

    ROUND(
        SUM(CASE WHEN subscribed = 1 THEN 1 ELSE 0 END)
        * 100.0 /
        NULLIF(COUNT(*),0),
        2
    ) AS overall_subscription_rate

FROM guidein_dataset;


/* ============================================================
   18. USERS WHO VISITED BUT DID NOT REGISTER
   ============================================================ */

SELECT *
FROM guidein_dataset
WHERE visited = 1
AND registered = 0;


/* ============================================================
   19. USERS WHO REGISTERED BUT DID NOT LOGIN
   ============================================================ */

SELECT *
FROM guidein_dataset
WHERE registered = 1
AND logged_in = 0;


/* ============================================================
   20. USERS WHO LOGGED IN BUT DID NOT SUBSCRIBE
   ============================================================ */

SELECT *
FROM guidein_dataset
WHERE logged_in = 1
AND subscribed = 0;


/* ============================================================
   21. USERS WHO COMPLETED FULL FUNNEL
   ============================================================ */

SELECT *
FROM guidein_dataset
WHERE visited = 1
AND registered = 1
AND logged_in = 1
AND subscribed = 1;


/* ============================================================
   22. FUNNEL STAGE FOR EACH USER
   ============================================================ */

SELECT

    user_id,
    visit_date,
    service,
    source,
    device,

    CASE
        WHEN subscribed = 1 THEN 'Subscribed'
        WHEN logged_in = 1 THEN 'Logged In'
        WHEN registered = 1 THEN 'Registered'
        WHEN visited = 1 THEN 'Visited'
        ELSE 'No Activity'
    END AS funnel_stage

FROM guidein_dataset;


/* ============================================================
   23. FUNNEL STAGE COUNT
   ============================================================ */

SELECT

    CASE
        WHEN subscribed = 1 THEN 'Subscribed'
        WHEN logged_in = 1 THEN 'Logged In'
        WHEN registered = 1 THEN 'Registered'
        WHEN visited = 1 THEN 'Visited'
        ELSE 'No Activity'
    END AS funnel_stage,

    COUNT(*) AS users

FROM guidein_dataset

GROUP BY funnel_stage;


/* ============================================================
   24. DAILY VISITORS
   ============================================================ */

SELECT

    visit_date,
    COUNT(*) AS total_visitors

FROM guidein_dataset

WHERE visited = 1

GROUP BY visit_date

ORDER BY visit_date;


/* ============================================================
   25. DAILY REGISTRATIONS
   ============================================================ */

SELECT

    visit_date,
    SUM(CASE WHEN registered = 1 THEN 1 ELSE 0 END)
    AS registrations

FROM guidein_dataset

GROUP BY visit_date

ORDER BY visit_date;


/* ============================================================
   26. DAILY LOGINS
   ============================================================ */

SELECT

    visit_date,
    SUM(CASE WHEN logged_in = 1 THEN 1 ELSE 0 END)
    AS logins

FROM guidein_dataset

GROUP BY visit_date

ORDER BY visit_date;


/* ============================================================
   27. DAILY SUBSCRIPTIONS
   ============================================================ */

SELECT

    visit_date,
    SUM(CASE WHEN subscribed = 1 THEN 1 ELSE 0 END)
    AS subscriptions

FROM guidein_dataset

GROUP BY visit_date

ORDER BY visit_date;


/* ============================================================
   28. MONTHLY USERS
   ============================================================ */

SELECT

    DATE_FORMAT(visit_date, '%Y-%m') AS month,

    COUNT(*) AS total_users

FROM guidein_dataset

GROUP BY DATE_FORMAT(visit_date, '%Y-%m')

ORDER BY month;


/* ============================================================
   29. MONTHLY VISITORS
   ============================================================ */

SELECT

    DATE_FORMAT(visit_date, '%Y-%m') AS month,

    SUM(CASE WHEN visited = 1 THEN 1 ELSE 0 END)
    AS visitors

FROM guidein_dataset

GROUP BY DATE_FORMAT(visit_date, '%Y-%m')

ORDER BY month;


/* ============================================================
   30. MONTHLY REGISTRATIONS
   ============================================================ */

SELECT

    DATE_FORMAT(visit_date, '%Y-%m') AS month,

    SUM(CASE WHEN registered = 1 THEN 1 ELSE 0 END)
    AS registrations

FROM guidein_dataset

GROUP BY DATE_FORMAT(visit_date, '%Y-%m')

ORDER BY month;


/* ============================================================
   31. MONTHLY LOGINS
   ============================================================ */

SELECT

    DATE_FORMAT(visit_date, '%Y-%m') AS month,

    SUM(CASE WHEN logged_in = 1 THEN 1 ELSE 0 END)
    AS logins

FROM guidein_dataset

GROUP BY DATE_FORMAT(visit_date, '%Y-%m')

ORDER BY month;


/* ============================================================
   32. MONTHLY SUBSCRIPTIONS
   ============================================================ */

SELECT

    DATE_FORMAT(visit_date, '%Y-%m') AS month,

    SUM(CASE WHEN subscribed = 1 THEN 1 ELSE 0 END)
    AS subscriptions

FROM guidein_dataset

GROUP BY DATE_FORMAT(visit_date, '%Y-%m')

ORDER BY month;


/* ============================================================
   33. MONTHLY FUNNEL ANALYSIS
   ============================================================ */

SELECT

    DATE_FORMAT(visit_date, '%Y-%m') AS month,

    COUNT(*) AS total_users,

    SUM(CASE WHEN visited = 1 THEN 1 ELSE 0 END)
    AS visitors,

    SUM(CASE WHEN registered = 1 THEN 1 ELSE 0 END)
    AS registrations,

    SUM(CASE WHEN logged_in = 1 THEN 1 ELSE 0 END)
    AS logins,

    SUM(CASE WHEN subscribed = 1 THEN 1 ELSE 0 END)
    AS subscriptions

FROM guidein_dataset

GROUP BY DATE_FORMAT(visit_date, '%Y-%m')

ORDER BY month;


/* ============================================================
   34. SERVICE ANALYSIS
   ============================================================ */

SELECT

    service,
    COUNT(*) AS total_visits

FROM guidein_dataset

GROUP BY service

ORDER BY total_visits DESC;


/* ============================================================
   35. SERVICE-WISE VISITORS
   ============================================================ */

SELECT

    service,

    SUM(CASE WHEN visited = 1 THEN 1 ELSE 0 END)
    AS visitors

FROM guidein_dataset

GROUP BY service

ORDER BY visitors DESC;


/* ============================================================
   36. SERVICE-WISE REGISTRATIONS
   ============================================================ */

SELECT

    service,

    SUM(CASE WHEN registered = 1 THEN 1 ELSE 0 END)
    AS registrations

FROM guidein_dataset

GROUP BY service

ORDER BY registrations DESC;


/* ============================================================
   37. SERVICE-WISE LOGINS
   ============================================================ */

SELECT

    service,

    SUM(CASE WHEN logged_in = 1 THEN 1 ELSE 0 END)
    AS logins

FROM guidein_dataset

GROUP BY service

ORDER BY logins DESC;


/* ============================================================
   38. SERVICE-WISE SUBSCRIPTIONS
   ============================================================ */

SELECT

    service,

    SUM(CASE WHEN subscribed = 1 THEN 1 ELSE 0 END)
    AS subscriptions

FROM guidein_dataset

GROUP BY service

ORDER BY subscriptions DESC;


/* ============================================================
   39. COMPLETE SERVICE-WISE FUNNEL
   ============================================================ */

SELECT

    service,

    COUNT(*) AS total_users,

    SUM(CASE WHEN visited = 1 THEN 1 ELSE 0 END)
    AS visitors,

    SUM(CASE WHEN registered = 1 THEN 1 ELSE 0 END)
    AS registrations,

    SUM(CASE WHEN logged_in = 1 THEN 1 ELSE 0 END)
    AS logins,

    SUM(CASE WHEN subscribed = 1 THEN 1 ELSE 0 END)
    AS subscriptions,

    ROUND(
        SUM(CASE WHEN registered = 1 THEN 1 ELSE 0 END)
        * 100.0 /
        NULLIF(SUM(CASE WHEN visited = 1 THEN 1 ELSE 0 END),0),
        2
    ) AS visit_to_register_rate,

    ROUND(
        SUM(CASE WHEN logged_in = 1 THEN 1 ELSE 0 END)
        * 100.0 /
        NULLIF(SUM(CASE WHEN registered = 1 THEN 1 ELSE 0 END),0),
        2
    ) AS register_to_login_rate,

    ROUND(
        SUM(CASE WHEN subscribed = 1 THEN 1 ELSE 0 END)
        * 100.0 /
        NULLIF(SUM(CASE WHEN logged_in = 1 THEN 1 ELSE 0 END),0),
        2
    ) AS login_to_subscribe_rate

FROM guidein_dataset

GROUP BY service

ORDER BY subscriptions DESC;


/* ============================================================
   40. SOURCE ANALYSIS
   ============================================================ */

SELECT

    source,
    COUNT(*) AS total_users

FROM guidein_dataset

GROUP BY source

ORDER BY total_users DESC;


/* ============================================================
   41. SOURCE-WISE VISITORS
   ============================================================ */

SELECT

    source,

    SUM(CASE WHEN visited = 1 THEN 1 ELSE 0 END)
    AS visitors

FROM guidein_dataset

GROUP BY source

ORDER BY visitors DESC;


/* ============================================================
   42. SOURCE-WISE REGISTRATIONS
   ============================================================ */

SELECT

    source,

    SUM(CASE WHEN registered = 1 THEN 1 ELSE 0 END)
    AS registrations

FROM guidein_dataset

GROUP BY source

ORDER BY registrations DESC;


/* ============================================================
   43. SOURCE-WISE SUBSCRIPTIONS
   ============================================================ */

SELECT

    source,

    SUM(CASE WHEN subscribed = 1 THEN 1 ELSE 0 END)
    AS subscriptions

FROM guidein_dataset

GROUP BY source

ORDER BY subscriptions DESC;


/* ============================================================
   44. COMPLETE SOURCE-WISE FUNNEL
   ============================================================ */

SELECT

    source,

    COUNT(*) AS total_users,

    SUM(CASE WHEN visited = 1 THEN 1 ELSE 0 END)
    AS visitors,

    SUM(CASE WHEN registered = 1 THEN 1 ELSE 0 END)
    AS registrations,

    SUM(CASE WHEN logged_in = 1 THEN 1 ELSE 0 END)
    AS logins,

    SUM(CASE WHEN subscribed = 1 THEN 1 ELSE 0 END)
    AS subscriptions,

    ROUND(
        SUM(CASE WHEN registered = 1 THEN 1 ELSE 0 END)
        * 100.0 /
        NULLIF(SUM(CASE WHEN visited = 1 THEN 1 ELSE 0 END),0),
        2
    ) AS visit_to_register_rate,

    ROUND(
        SUM(CASE WHEN subscribed = 1 THEN 1 ELSE 0 END)
        * 100.0 /
        NULLIF(SUM(CASE WHEN visited = 1 THEN 1 ELSE 0 END),0),
        2
    ) AS overall_subscription_rate

FROM guidein_dataset

GROUP BY source

ORDER BY subscriptions DESC;


/* ============================================================
   45. DEVICE ANALYSIS
   ============================================================ */

SELECT

    device,
    COUNT(*) AS total_users

FROM guidein_dataset

GROUP BY device

ORDER BY total_users DESC;


/* ============================================================
   46. DEVICE-WISE FUNNEL
   ============================================================ */

SELECT

    device,

    COUNT(*) AS total_users,

    SUM(CASE WHEN visited = 1 THEN 1 ELSE 0 END)
    AS visitors,

    SUM(CASE WHEN registered = 1 THEN 1 ELSE 0 END)
    AS registrations,

    SUM(CASE WHEN logged_in = 1 THEN 1 ELSE 0 END)
    AS logins,

    SUM(CASE WHEN subscribed = 1 THEN 1 ELSE 0 END)
    AS subscriptions

FROM guidein_dataset

GROUP BY device

ORDER BY total_users DESC;


/* ============================================================
   47. DEVICE CONVERSION RATE
   ============================================================ */

SELECT

    device,

    ROUND(
        SUM(CASE WHEN registered = 1 THEN 1 ELSE 0 END)
        * 100.0 /
        NULLIF(SUM(CASE WHEN visited = 1 THEN 1 ELSE 0 END),0),
        2
    ) AS visit_to_register_rate,

    ROUND(
        SUM(CASE WHEN logged_in = 1 THEN 1 ELSE 0 END)
        * 100.0 /
        NULLIF(SUM(CASE WHEN registered = 1 THEN 1 ELSE 0 END),0),
        2
    ) AS register_to_login_rate,

    ROUND(
        SUM(CASE WHEN subscribed = 1 THEN 1 ELSE 0 END)
        * 100.0 /
        NULLIF(SUM(CASE WHEN logged_in = 1 THEN 1 ELSE 0 END),0),
        2
    ) AS login_to_subscribe_rate

FROM guidein_dataset

GROUP BY device;


/* ============================================================
   48. SERVICE + SOURCE ANALYSIS
   ============================================================ */

SELECT

    service,
    source,

    COUNT(*) AS total_users,

    SUM(CASE WHEN registered = 1 THEN 1 ELSE 0 END)
    AS registrations,

    SUM(CASE WHEN logged_in = 1 THEN 1 ELSE 0 END)
    AS logins,

    SUM(CASE WHEN subscribed = 1 THEN 1 ELSE 0 END)
    AS subscriptions

FROM guidein_dataset

GROUP BY service, source

ORDER BY subscriptions DESC;


/* ============================================================
   49. SERVICE + DEVICE ANALYSIS
   ============================================================ */

SELECT

    service,
    device,

    COUNT(*) AS total_users,

    SUM(CASE WHEN registered = 1 THEN 1 ELSE 0 END)
    AS registrations,

    SUM(CASE WHEN logged_in = 1 THEN 1 ELSE 0 END)
    AS logins,

    SUM(CASE WHEN subscribed = 1 THEN 1 ELSE 0 END)
    AS subscriptions

FROM guidein_dataset

GROUP BY service, device

ORDER BY subscriptions DESC;


/* ============================================================
   50. SOURCE + DEVICE ANALYSIS
   ============================================================ */

SELECT

    source,
    device,

    COUNT(*) AS total_users,

    SUM(CASE WHEN registered = 1 THEN 1 ELSE 0 END)
    AS registrations,

    SUM(CASE WHEN logged_in = 1 THEN 1 ELSE 0 END)
    AS logins,

    SUM(CASE WHEN subscribed = 1 THEN 1 ELSE 0 END)
    AS subscriptions

FROM guidein_dataset

GROUP BY source, device

ORDER BY subscriptions DESC;


/* ============================================================
   51. MOBILE USERS
   ============================================================ */

SELECT *
FROM guidein_dataset
WHERE device = 'Mobile';


/* ============================================================
   52. MOBILE SUBSCRIBERS
   ============================================================ */

SELECT *
FROM guidein_dataset
WHERE device = 'Mobile'
AND subscribed = 1;


/* ============================================================
   53. DESKTOP SUBSCRIBERS
   ============================================================ */

SELECT *
FROM guidein_dataset
WHERE device = 'Desktop'
AND subscribed = 1;


/* ============================================================
   54. SUBSCRIBED USERS BY SERVICE
   ============================================================ */

SELECT

    service,

    COUNT(*) AS subscribed_users

FROM guidein_dataset

WHERE subscribed = 1

GROUP BY service

ORDER BY subscribed_users DESC;


/* ============================================================
   55. SUBSCRIBED USERS BY SOURCE
   ============================================================ */

SELECT

    source,

    COUNT(*) AS subscribed_users

FROM guidein_dataset

WHERE subscribed = 1

GROUP BY source

ORDER BY subscribed_users DESC;


/* ============================================================
   56. SUBSCRIBED USERS BY DEVICE
   ============================================================ */

SELECT

    device,

    COUNT(*) AS subscribed_users

FROM guidein_dataset

WHERE subscribed = 1

GROUP BY device

ORDER BY subscribed_users DESC;


/* ============================================================
   57. MOST ACTIVE SERVICE
   ============================================================ */

SELECT

    service,
    COUNT(*) AS total_users

FROM guidein_dataset

GROUP BY service

ORDER BY total_users DESC

LIMIT 1;


/* ============================================================
   58. MOST ACTIVE SOURCE
   ============================================================ */

SELECT

    source,
    COUNT(*) AS total_users

FROM guidein_dataset

GROUP BY source

ORDER BY total_users DESC

LIMIT 1;


/* ============================================================
   59. MOST USED DEVICE
   ============================================================ */

SELECT

    device,
    COUNT(*) AS total_users

FROM guidein_dataset

GROUP BY device

ORDER BY total_users DESC

LIMIT 1;


/* ============================================================
   60. MAIN PROJECT QUERY
   ============================================================ */

SELECT

    service,
    source,
    device,

    COUNT(*) AS total_users,

    SUM(CASE WHEN visited = 1 THEN 1 ELSE 0 END)
    AS visitors,

    SUM(CASE WHEN registered = 1 THEN 1 ELSE 0 END)
    AS registrations,

    SUM(CASE WHEN logged_in = 1 THEN 1 ELSE 0 END)
    AS logins,

    SUM(CASE WHEN subscribed = 1 THEN 1 ELSE 0 END)
    AS subscriptions,

    ROUND(
        SUM(CASE WHEN registered = 1 THEN 1 ELSE 0 END)
        * 100.0 /
        NULLIF(SUM(CASE WHEN visited = 1 THEN 1 ELSE 0 END),0),
        2
    ) AS visit_to_register_rate,

    ROUND(
        SUM(CASE WHEN logged_in = 1 THEN 1 ELSE 0 END)
        * 100.0 /
        NULLIF(SUM(CASE WHEN registered = 1 THEN 1 ELSE 0 END),0),
        2
    ) AS register_to_login_rate,

    ROUND(
        SUM(CASE WHEN subscribed = 1 THEN 1 ELSE 0 END)
        * 100.0 /
        NULLIF(SUM(CASE WHEN logged_in = 1 THEN 1 ELSE 0 END),0),
        2
    ) AS login_to_subscribe_rate

FROM guidein_dataset

GROUP BY
    service,
    source,
    device

ORDER BY subscriptions DESC;


/* ============================================================
   END OF GUIDEIN MYSQL PROJECT
   ============================================================ */