CREATE TABLE airlines (
    iata_code VARCHAR(10),
    airline VARCHAR(100)
);

CREATE TABLE airports (
    iata_code VARCHAR(10),
    airport VARCHAR(255),
    city VARCHAR(100),
    state VARCHAR(50),
    country VARCHAR(50),
    latitude NUMERIC,
    longitude NUMERIC
);

CREATE TABLE flights (
    year INT,
    month INT,
    day INT,
    day_of_week INT,
    airline VARCHAR(10),
    flight_number INT,
    tail_number VARCHAR(20),

    origin_airport VARCHAR(10),
    destination_airport VARCHAR(10),

    scheduled_departure INT,
    departure_time INT,
    departure_delay NUMERIC,

    taxi_out NUMERIC,
    wheels_off INT,
    scheduled_time NUMERIC,
    elapsed_time NUMERIC,
    air_time NUMERIC,
    distance INT,

    wheels_on INT,
    taxi_in NUMERIC,

    scheduled_arrival INT,
    arrival_time INT,
    arrival_delay NUMERIC,

    diverted INT,
    cancelled INT,
    cancellation_reason VARCHAR(5),

    air_system_delay NUMERIC,
    security_delay NUMERIC,
    airline_delay NUMERIC,
    late_aircraft_delay NUMERIC,
    weather_delay NUMERIC
);

-- Adding flight date column

ALTER TABLE flights
ADD COLUMN flight_date DATE;


UPDATE flights
SET flight_date =
MAKE_DATE(year, month, day);

-- Checking flight date column

SELECT
    flight_date
FROM flights
LIMIT 5;


-- Adding cancellation reason descriptions

ALTER TABLE flights
ADD COLUMN cancellation_reason_desc VARCHAR(50);


UPDATE flights
SET cancellation_reason_desc =
CASE
    WHEN cancellation_reason = 'A' THEN 'Airline/Carrier'
    WHEN cancellation_reason = 'B' THEN 'Weather'
    WHEN cancellation_reason = 'C' THEN 'National Air System'
    WHEN cancellation_reason = 'D' THEN 'Security'
    ELSE NULL
END;

-- Verifying cancellation reason descriptions

SELECT
    cancellation_reason,
    cancellation_reason_desc
FROM flights
WHERE cancellation_reason IS NOT NULL
LIMIT 10;

-- Checking missing values in important columns

SELECT
    COUNT(*) AS total_flights,

    COUNT(arrival_delay) AS arrival_delay_count,
    COUNT(departure_delay) AS departure_delay_count,

    COUNT(cancellation_reason) AS cancellation_reason_count,

    COUNT(weather_delay) AS weather_delay_count,
    COUNT(airline_delay) AS airline_delay_count

FROM flights;


-- Total flights, cancelled flights, and diversion summary

SELECT
    COUNT(*) AS total_flights,

    SUM(cancelled) AS total_cancelled_flights,

    ROUND(
        SUM(cancelled) * 100.0 / COUNT(*),
        2
    ) AS cancellation_rate_percent,

    SUM(diverted) AS total_diverted_flights

FROM flights;


-- Average, minimum, and maximum delays

SELECT
    ROUND(AVG(arrival_delay), 2) AS avg_arrival_delay,

    ROUND(AVG(departure_delay), 2) AS avg_departure_delay,

    MIN(arrival_delay) AS min_arrival_delay,
    MAX(arrival_delay) AS max_arrival_delay,

    MIN(departure_delay) AS min_departure_delay,
    MAX(departure_delay) AS max_departure_delay

FROM flights
WHERE cancelled = 0;


-- Cancellation reasons distribution

SELECT
    cancellation_reason_desc,

    COUNT(*) AS cancelled_flights,

    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER(),
        2
    ) AS percentage

FROM flights
WHERE cancelled = 1

GROUP BY cancellation_reason_desc
ORDER BY cancelled_flights DESC;


-- Airline performance analysis

SELECT
    a.airline,

    COUNT(*) AS total_flights,

    ROUND(
        AVG(
            CASE
                WHEN f.cancelled = 0
                THEN f.arrival_delay
            END
        ),
        2
    ) AS avg_arrival_delay,

    ROUND(
        AVG(
            CASE
                WHEN f.cancelled = 0
                THEN f.departure_delay
            END
        ),
        2
    ) AS avg_departure_delay,

    ROUND(
        SUM(f.cancelled) * 100.0 / COUNT(*),
        2
    ) AS cancellation_rate_percent

FROM flights f

LEFT JOIN airlines a
ON f.airline = a.iata_code

GROUP BY a.airline

ORDER BY avg_arrival_delay DESC;


-- On-Time Performance (OTP) by airline
-- Flights arriving within 15 minutes

SELECT
    a.airline,

    COUNT(*) AS total_flights,

    SUM(
        CASE
            WHEN f.arrival_delay <= 15
            THEN 1
            ELSE 0
        END
    ) AS on_time_flights,

    ROUND(
        SUM(
            CASE
                WHEN f.arrival_delay <= 15
                THEN 1
                ELSE 0
            END
        ) * 100.0
        /
        COUNT(*),
        2
    ) AS otp_rate_percent

FROM flights f

LEFT JOIN airlines a
ON f.airline = a.iata_code

WHERE f.cancelled = 0

GROUP BY a.airline

ORDER BY otp_rate_percent DESC;


-- Top 10 airports with highest average departure delay

SELECT
    origin_airport,

    COUNT(*) AS total_flights,

    ROUND(
        AVG(departure_delay),
        2
    ) AS avg_departure_delay

FROM flights

WHERE cancelled = 0

GROUP BY origin_airport

HAVING COUNT(*) > 1000

ORDER BY avg_departure_delay DESC

LIMIT 10;


-- Top busiest airports by total flights

SELECT
    origin_airport,

    COUNT(*) AS total_flights

FROM flights

GROUP BY origin_airport

ORDER BY total_flights DESC

LIMIT 10;


-- Monthly OTP analysis

SELECT
    month,

    COUNT(*) AS total_flights,

    ROUND(
        AVG(arrival_delay),
        2
    ) AS avg_arrival_delay,

    ROUND(
        SUM(
            CASE
                WHEN arrival_delay <= 15
                THEN 1
                ELSE 0
            END
        ) * 100.0
        /
        COUNT(*),
        2
    ) AS otp_rate_percent

FROM flights

WHERE cancelled = 0

GROUP BY month

ORDER BY month;


-- OTP and cancellation trends by day of week

SELECT
    day_of_week,

    COUNT(*) AS total_flights,

    ROUND(
        AVG(arrival_delay),
        2
    ) AS avg_arrival_delay,

    ROUND(
        SUM(
            CASE
                WHEN arrival_delay <= 15
                THEN 1
                ELSE 0
            END
        ) * 100.0
        /
        COUNT(*),
        2
    ) AS otp_rate_percent,

    ROUND(
        SUM(cancelled) * 100.0
        /
        COUNT(*),
        2
    ) AS cancellation_rate_percent

FROM flights

GROUP BY day_of_week

ORDER BY day_of_week;


-- Delay type contribution analysis

SELECT
    ROUND(AVG(airline_delay), 2) AS avg_airline_delay,

    ROUND(AVG(weather_delay), 2) AS avg_weather_delay,

    ROUND(AVG(air_system_delay), 2) AS avg_air_system_delay,

    ROUND(AVG(security_delay), 2) AS avg_security_delay,

    ROUND(AVG(late_aircraft_delay), 2) AS avg_late_aircraft_delay

FROM flights;


-- Creating integrated analytical view for Power BI

CREATE OR REPLACE VIEW vw_flight_analysis AS

SELECT

    f.year,
    f.month,
    f.day,
    f.day_of_week,
    f.flight_date,

    f.airline,
    a.airline AS airline_name,

    f.flight_number,
    f.tail_number,

    f.origin_airport,
    ao.airport AS origin_airport_name,
    ao.city AS origin_city,
    ao.state AS origin_state,

    f.destination_airport,
    ad.airport AS destination_airport_name,
    ad.city AS destination_city,
    ad.state AS destination_state,

    f.scheduled_departure,
    f.departure_time,
    f.departure_delay,

    f.scheduled_arrival,
    f.arrival_time,
    f.arrival_delay,

    f.distance,

    f.cancelled,
    f.cancellation_reason,
    f.cancellation_reason_desc,

    f.diverted,

    f.air_system_delay,
    f.security_delay,
    f.airline_delay,
    f.late_aircraft_delay,
    f.weather_delay

FROM flights f

LEFT JOIN airlines a
ON f.airline = a.iata_code

LEFT JOIN airports ao
ON f.origin_airport = ao.iata_code

LEFT JOIN airports ad
ON f.destination_airport = ad.iata_code;