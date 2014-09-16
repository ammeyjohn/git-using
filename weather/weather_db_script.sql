/*
* database
*/
CREATE DATABASE IF NOT EXISTS weather;


/*
* station
*/
CREATE TABLE IF NOT EXISTS station (
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	name NVARCHAR(50) NOT NULL,
	code VARCHAR(10) NOT NULL,
	url VARCHAR(100) NOT NULL,
	query_string VARCHAR(100)
) DEFAULT CHARSET=utf8;

/*
* weather
*/
CREATE TABLE IF NOT EXISTS weather (
	id      INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    time    DATETIME NOT NULL,
    temperature         FLOAT,
    dew_point           FLOAT,
    humidity            INT,
    sea_level_pressure  INT,
    visibility          FLOAT,
    wind_direction      VARCHAR(50),
    wind_speed          FLOAT,
    gust_speed          FLOAT,
    precipitation       FLOAT,
    events              VARCHAR(50),
    conditions          VARCHAR(50),
    wind_degrees        INT,
    date_utc            DATETIME
) DEFAULT CHARSET=utf8;
