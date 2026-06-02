-- ============================================
-- Project  : U.S. Airline Performance Analysis
-- File     : 01_create_tables.sql
-- Purpose  : Create raw tables for all 3 datasets
-- Author   : Raju Kumar S
-- Date     : June 2026
-- ============================================


CREATE TABLE airlines (
    IATA_CODE VARCHAR(10),
    AIRLINE   VARCHAR(100)
);


CREATE TABLE airports (
    IATA_CODE  VARCHAR(10),
    AIRPORT    VARCHAR(200),
    CITY       VARCHAR(100),
    STATE      VARCHAR(50),
    COUNTRY    VARCHAR(50),
    LATITUDE   DECIMAL(10,5),
    LONGITUDE  DECIMAL(10,5)
);


CREATE TABLE flights (
    YEAR                 INT,
    MONTH                INT,
    DAY                  INT,
    DAY_OF_WEEK          INT,
    AIRLINE              VARCHAR(10),
    FLIGHT_NUMBER        INT,
    TAIL_NUMBER          VARCHAR(20),
    ORIGIN_AIRPORT       VARCHAR(10),
    DESTINATION_AIRPORT  VARCHAR(10),
    SCHEDULED_DEPARTURE  INT,
    DEPARTURE_TIME       DECIMAL(6,2),
    DEPARTURE_DELAY      DECIMAL(6,2),
    TAXI_OUT             DECIMAL(6,2),
    WHEELS_OFF           DECIMAL(6,2),
    SCHEDULED_TIME       DECIMAL(6,2),
    ELAPSED_TIME         DECIMAL(6,2),
    AIR_TIME             DECIMAL(6,2),
    DISTANCE             DECIMAL(8,2),
    WHEELS_ON            DECIMAL(6,2),
    TAXI_IN              DECIMAL(6,2),
    SCHEDULED_ARRIVAL    INT,
    ARRIVAL_TIME         DECIMAL(6,2),
    ARRIVAL_DELAY        DECIMAL(6,2),
    DIVERTED             INT,
    CANCELLED            INT,
    CANCELLATION_REASON  VARCHAR(5),
    AIR_SYSTEM_DELAY     DECIMAL(6,2),
    SECURITY_DELAY       DECIMAL(6,2),
    AIRLINE_DELAY        DECIMAL(6,2),
    LATE_AIRCRAFT_DELAY  DECIMAL(6,2),
    WEATHER_DELAY        DECIMAL(6,2)
);