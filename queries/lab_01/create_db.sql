DROP DATABASE IF EXISTS military_base;
CREATE DATABASE military_base;
\c military_base;
-- USE military_base;
-- CREATE SCHEMA military_base;
SET search_path = military_base;
CREATE SCHEMA military_base;
CREATE TABLE IF NOT EXISTS military_base.soldiers (
    id SERIAL,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    rank VARCHAR(50),
    age INT,
    salary INT,
    arrival_date DATE,
    departure_date DATE,
    weapon_id INT,
    ammunition_id INT,
    vehicle_id INT,
    squad_id INT
);

CREATE TABLE IF NOT EXISTS military_base.weapons(
    id SERIAL,
    name VARCHAR(50),
    classification VARCHAR(50),
    caliber VARCHAR(50),
    status VARCHAR(50),
    produced DATE,
    last_check DATE
);

CREATE TABLE IF NOT EXISTS military_base.squads(
    id SERIAL,
    cur_location VARCHAR(50),
    first_deploy DATE,
    last_deploy DATE,
    status VARCHAR(50),
    total_deploys INT,
    call_sign VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS military_base.ammunition(
    id SERIAL,
    name VARCHAR(50),
    caliber VARCHAR(50),
    type VARCHAR(50),
    quantity INT DEFAULT 0,
    status VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS military_base.vehicles(
    id SERIAL,
    name VARCHAR(50),
    status VARCHAR(50),
    capacity INT,
    armored BOOLEAN,
    produced DATE
);
