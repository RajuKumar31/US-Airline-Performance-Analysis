-- ============================================
-- Project  : U.S. Airline Performance Analysis
-- File     : 02_create_cleaned_view.sql
-- Purpose  : Create cleaned view excluding
--            cancelled and diverted flights
-- Author   : Raju Kumar S
-- Date     : June 2026
-- ============================================


CREATE VIEW flights_cleaned AS
SELECT
    year,
    month,
    day,

    CASE day_of_week
        WHEN 1 THEN 'Monday'
        WHEN 2 THEN 'Tuesday'
        WHEN 3 THEN 'Wednesday'
        WHEN 4 THEN 'Thursday'
        WHEN 5 THEN 'Friday'
        WHEN 6 THEN 'Saturday'
        WHEN 7 THEN 'Sunday'
    END AS day_name,

    airline,
    flight_number,
    tail_number,
    origin_airport,
    destination_airport,
    scheduled_departure,
    departure_time,

    COALESCE(departure_delay, 0)      AS departure_delay,
    COALESCE(arrival_delay, 0)        AS arrival_delay,
    COALESCE(air_system_delay, 0)     AS air_system_delay,
    COALESCE(security_delay, 0)       AS security_delay,
    COALESCE(airline_delay, 0)        AS airline_delay,
    COALESCE(late_aircraft_delay, 0)  AS late_aircraft_delay,
    COALESCE(weather_delay, 0)        AS weather_delay,

    taxi_out,
    taxi_in,
    wheels_off,
    wheels_on,
    scheduled_time,
    elapsed_time,
    air_time,
    distance,
    scheduled_arrival,
    arrival_time,
    cancelled,
    diverted,

    CASE
        WHEN departure_delay > 500 THEN 'Yes'
        ELSE 'No'
    END AS is_extreme_delay

FROM flights
WHERE cancelled = 0
AND diverted = 0;