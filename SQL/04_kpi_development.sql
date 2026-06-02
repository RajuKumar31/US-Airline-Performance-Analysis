-- ============================================
-- Project  : U.S. Airline Performance Analysis
-- File     : 04_kpi_development.sql
-- Purpose  : KPI views for Power BI connection
-- Author   : Raju Kumar S
-- Date     : June 2026
-- ============================================


-- ----------------------
-- KPI 1: On-Time Performance Rate
-- ----------------------
CREATE VIEW kpi_otp_by_airline AS
SELECT
    a.airline                                               AS airline_name,
    COUNT(*)                                                AS total_flights,
    SUM(CASE WHEN f.arrival_delay <= 15 THEN 1 ELSE 0 END) AS on_time_flights,
    ROUND(
        SUM(CASE WHEN f.arrival_delay <= 15 THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*), 2)                             AS otp_rate_pct,
    CASE
        WHEN SUM(CASE WHEN f.arrival_delay <= 15 THEN 1 ELSE 0 END)
             * 100.0 / COUNT(*) >= 80 THEN 'Meeting Target'
        WHEN SUM(CASE WHEN f.arrival_delay <= 15 THEN 1 ELSE 0 END)
             * 100.0 / COUNT(*) >= 70 THEN 'Below Target'
        ELSE 'Critical'
    END                                                     AS performance_status
FROM flights_cleaned f
JOIN airlines a ON f.airline = a.iata_code
GROUP BY a.airline
ORDER BY otp_rate_pct DESC;


-- ----------------------
-- KPI 2: Cancellation Rate
-- ----------------------
CREATE VIEW kpi_cancellation_rate AS
SELECT
    a.airline                                       AS airline_name,
    COUNT(*)                                        AS total_flights,
    SUM(f.cancelled)                                AS total_cancellations,
    ROUND(
        SUM(f.cancelled) * 100.0 / COUNT(*), 2)    AS cancellation_rate_pct,
    CASE
        WHEN SUM(f.cancelled) * 100.0
             / COUNT(*) <= 1.5 THEN 'Acceptable'
        WHEN SUM(f.cancelled) * 100.0
             / COUNT(*) <= 3.0 THEN 'Elevated'
        ELSE 'Critical'
    END                                             AS cancellation_status
FROM flights f
JOIN airlines a ON f.airline = a.iata_code
GROUP BY a.airline
ORDER BY cancellation_rate_pct DESC;


-- ----------------------
-- KPI 3: Average Arrival Delay with Severity
-- ----------------------
CREATE VIEW kpi_delay_severity AS
SELECT
    a.airline                                   AS airline_name,
    ROUND(AVG(f.arrival_delay), 2)              AS avg_arrival_delay_min,
    ROUND(AVG(f.departure_delay), 2)            AS avg_departure_delay_min,
    ROUND(AVG(f.arrival_delay) -
          AVG(f.departure_delay), 2)            AS time_recovered_in_air,
    CASE
        WHEN AVG(f.arrival_delay) <= 5  THEN 'Excellent'
        WHEN AVG(f.arrival_delay) <= 10 THEN 'Good'
        WHEN AVG(f.arrival_delay) <= 15 THEN 'Fair'
        ELSE 'Poor'
    END                                         AS delay_severity
FROM flights_cleaned f
JOIN airlines a ON f.airline = a.iata_code
GROUP BY a.airline
ORDER BY avg_arrival_delay_min ASC;


-- ----------------------
-- KPI 4: Delay Cause Index by Airline
-- ----------------------
CREATE VIEW kpi_delay_causes AS
SELECT
    a.airline                                               AS airline_name,
    ROUND(AVG(f.airline_delay), 2)                          AS avg_carrier_delay,
    ROUND(AVG(f.weather_delay), 2)                          AS avg_weather_delay,
    ROUND(AVG(f.air_system_delay), 2)                       AS avg_nas_delay,
    ROUND(AVG(f.late_aircraft_delay), 2)                    AS avg_late_aircraft_delay,
    ROUND(AVG(f.security_delay), 2)                         AS avg_security_delay,
    ROUND(
        SUM(f.airline_delay) * 100.0 /
        NULLIF(SUM(f.airline_delay + f.weather_delay +
        f.air_system_delay + f.late_aircraft_delay +
        f.security_delay), 0), 2)                           AS carrier_delay_share_pct
FROM flights_cleaned f
JOIN airlines a ON f.airline = a.iata_code
GROUP BY a.airline
ORDER BY carrier_delay_share_pct DESC;


-- ----------------------
-- KPI 5: Airport Congestion Score
-- ----------------------
CREATE VIEW kpi_airport_congestion AS
SELECT
    f.origin_airport                            AS airport_code,
    ap.airport                                  AS airport_name,
    ap.city                                     AS city,
    ap.state                                    AS state,
    ap.latitude                                 AS latitude,
    ap.longitude                                AS longitude,
    COUNT(*)                                    AS total_departures,
    ROUND(AVG(f.departure_delay), 2)            AS avg_departure_delay,
    ROUND(AVG(f.taxi_out), 2)                   AS avg_taxi_out_min,
    ROUND(
        SUM(CASE WHEN f.departure_delay > 15
            THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*), 2)                  AS delayed_departure_rate_pct
FROM flights_cleaned f
JOIN airports ap ON f.origin_airport = ap.iata_code
GROUP BY
    f.origin_airport,
    ap.airport,
    ap.city,
    ap.state,
    ap.latitude,
    ap.longitude
HAVING COUNT(*) >= 1000
ORDER BY avg_departure_delay DESC;


-- ----------------------
-- KPI 6: Executive Airline Scorecard
-- ----------------------
CREATE VIEW kpi_executive_scorecard AS
SELECT
    a.airline                                               AS airline_name,
    COUNT(*)                                                AS total_flights,
    ROUND(
        SUM(CASE WHEN f.arrival_delay <= 15 THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*), 2)                             AS otp_rate_pct,
    ROUND(AVG(f.arrival_delay), 2)                          AS avg_arrival_delay,
    ROUND(AVG(f.departure_delay), 2)                        AS avg_departure_delay,
    ROUND(AVG(f.distance), 2)                               AS avg_route_distance,
    ROUND(
        SUM(f.airline_delay) * 100.0 /
        NULLIF(SUM(f.airline_delay + f.weather_delay +
        f.air_system_delay + f.late_aircraft_delay +
        f.security_delay), 0), 2)                           AS carrier_delay_share_pct,
    RANK() OVER (ORDER BY
        SUM(CASE WHEN f.arrival_delay <= 15 THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*) DESC)                            AS performance_rank
FROM flights_cleaned f
JOIN airlines a ON f.airline = a.iata_code
GROUP BY a.airline
ORDER BY performance_rank;


DROP VIEW kpi_airport_congestion;

CREATE VIEW kpi_airport_congestion AS
SELECT
    f.origin_airport                            AS airport_code,
    ap.airport                                  AS airport_name,
    ap.city                                     AS city,
    ap.state                                    AS state,
    ap.latitude                                 AS latitude,
    ap.longitude                                AS longitude,
    COUNT(*)                                    AS total_departures,
    ROUND(AVG(f.departure_delay), 2)            AS avg_departure_delay,
    ROUND(AVG(f.taxi_out), 2)                   AS avg_taxi_out_min,
    ROUND(
        SUM(CASE WHEN f.departure_delay > 15
            THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*), 2)                  AS delayed_departure_rate_pct
FROM flights_cleaned f
JOIN airports ap ON f.origin_airport = ap.iata_code
GROUP BY
    f.origin_airport,
    ap.airport,
    ap.city,
    ap.state,
    ap.latitude,
    ap.longitude
HAVING COUNT(*) >= 1000
ORDER BY avg_departure_delay DESC;


CREATE VIEW kpi_top_delayed_routes AS
SELECT
    origin_airport,
    destination_airport,
    COUNT(*)                            AS total_flights,
    ROUND(AVG(arrival_delay), 2)        AS avg_arrival_delay
FROM flights_cleaned
WHERE arrival_delay > 0
GROUP BY origin_airport, destination_airport
HAVING COUNT(*) >= 100
ORDER BY avg_arrival_delay DESC
LIMIT 10;