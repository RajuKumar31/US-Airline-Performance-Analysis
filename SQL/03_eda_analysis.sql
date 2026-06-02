-- ============================================
-- Project  : U.S. Airline Performance Analysis
-- File     : 03_eda_analysis.sql
-- Purpose  : Exploratory Data Analysis Queries
-- Author   : Raju Kumar S
-- Date     : June 2026
-- ============================================


-- ----------------------
-- EDA 1: Overall Performance Snapshot
-- ----------------------
SELECT
    COUNT(*)                                            AS total_flights,
    ROUND(AVG(departure_delay), 2)                      AS avg_departure_delay,
    ROUND(AVG(arrival_delay), 2)                        AS avg_arrival_delay,
    SUM(CASE WHEN arrival_delay <= 15 THEN 1 ELSE 0 END)AS on_time_flights,
    ROUND(
        SUM(CASE WHEN arrival_delay <= 15 THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*), 2)                          AS on_time_rate_pct,
    ROUND(SUM(distance) / 1000000.0, 2)                 AS total_distance_million_miles
FROM flights_cleaned;


-- ----------------------
-- EDA 2: Airline Performance Ranking
-- ----------------------
SELECT
    a.airline                                           AS airline_name,
    COUNT(*)                                            AS total_flights,
    ROUND(AVG(f.departure_delay), 2)                    AS avg_dep_delay,
    ROUND(AVG(f.arrival_delay), 2)                      AS avg_arr_delay,
    ROUND(
        SUM(CASE WHEN f.arrival_delay <= 15 THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*), 2)                          AS on_time_rate_pct,
    ROUND(AVG(f.distance), 2)                           AS avg_route_distance
FROM flights_cleaned f
JOIN airlines a ON f.airline = a.iata_code
GROUP BY a.airline
ORDER BY on_time_rate_pct DESC;


-- ----------------------
-- EDA 3: Monthly Delay Trend
-- ----------------------
SELECT
    month,
    COUNT(*)                            AS total_flights,
    ROUND(AVG(arrival_delay), 2)        AS avg_arrival_delay,
    ROUND(AVG(departure_delay), 2)      AS avg_departure_delay,
    ROUND(
        SUM(CASE WHEN arrival_delay <= 15 THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*), 2)          AS on_time_rate_pct
FROM flights_cleaned
GROUP BY month
ORDER BY month;


-- ----------------------
-- EDA 4: Delay by Day of Week
-- ----------------------
SELECT
    day_name,
    COUNT(*)                            AS total_flights,
    ROUND(AVG(arrival_delay), 2)        AS avg_arrival_delay,
    ROUND(
        SUM(CASE WHEN arrival_delay <= 15 THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*), 2)          AS on_time_rate_pct
FROM flights_cleaned
GROUP BY day_name
ORDER BY avg_arrival_delay ASC;


-- ----------------------
-- EDA 5: Top 10 Most Delayed Routes
-- ----------------------
SELECT
    origin_airport,
    destination_airport,
    COUNT(*)                            AS total_flights,
    ROUND(AVG(arrival_delay), 2)        AS avg_arrival_delay,
    ROUND(AVG(departure_delay), 2)      AS avg_departure_delay
FROM flights_cleaned
WHERE arrival_delay > 0
GROUP BY origin_airport, destination_airport
HAVING COUNT(*) >= 100
ORDER BY avg_arrival_delay DESC
LIMIT 10;


-- ----------------------
-- EDA 6: Delay Cause Breakdown
-- ----------------------
SELECT
    ROUND(AVG(airline_delay), 2)            AS avg_airline_delay,
    ROUND(AVG(weather_delay), 2)            AS avg_weather_delay,
    ROUND(AVG(air_system_delay), 2)         AS avg_air_system_delay,
    ROUND(AVG(late_aircraft_delay), 2)      AS avg_late_aircraft_delay,
    ROUND(AVG(security_delay), 2)           AS avg_security_delay,
    ROUND(
        SUM(airline_delay) * 100.0 /
        NULLIF(SUM(airline_delay + weather_delay +
        air_system_delay + late_aircraft_delay +
        security_delay), 0), 2)             AS airline_delay_share_pct,
    ROUND(
        SUM(weather_delay) * 100.0 /
        NULLIF(SUM(airline_delay + weather_delay +
        air_system_delay + late_aircraft_delay +
        security_delay), 0), 2)             AS weather_delay_share_pct
FROM flights_cleaned;