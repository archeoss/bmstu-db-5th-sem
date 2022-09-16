DROP DATABASE IF EXISTS military_base;
CREATE DATABASE military_base;
\c military_base;

CREATE TABLE IF NOT EXISTS soldiers (
    id SERIAL UNIQUE,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    rank VARCHAR(50),
    age INT,
    salary INT,
    arrival_date DATE,
    departure_date DATE
);

CREATE TABLE IF NOT EXISTS weapons(
    id SERIAL,
    name VARCHAR(50),
    classification VARCHAR(50),
    caliber VARCHAR(50),
    status VARCHAR(50),
    produced DATE,
    last_check DATE,
    attached_soldier_id INT
);

CREATE TABLE IF NOT EXISTS ammunition(
    id SERIAL,
    name VARCHAR(50),
    caliber VARCHAR(50),
    type VARCHAR(50),
    quantity INT DEFAULT 0,
    status VARCHAR(50),
    attached_soldier_id INT
);

CREATE TABLE IF NOT EXISTS vehicles(
    id SERIAL,
    name VARCHAR(50),
    status VARCHAR(50),
    capacity INT,
    armored BOOLEAN,
    produced DATE,
    attached_soldier_id INT
);
