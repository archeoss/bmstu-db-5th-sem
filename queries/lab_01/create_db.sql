DROP DATABASE IF EXISTS military_base;
CREATE DATABASE military_base;
\c military_base;

CREATE TABLE IF NOT EXISTS soldiers (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    rank VARCHAR(50) NOT NULL,
    age INT NOT NULL,
    salary INT NOT NULL,
    arrival_date DATE NOT NULL,
    departure_date DATE
);

CREATE TABLE IF NOT EXISTS weapons(
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    classification VARCHAR(50) NOT NULL,
    caliber VARCHAR(50) NOT NULL,
    status VARCHAR(50) NOT NULL,
    produced DATE NOT NULL,
    last_check DATE NOT NULL,
    soldier_id INT,
    FOREIGN KEY (soldier_id) REFERENCES soldiers(id)
);

CREATE TABLE IF NOT EXISTS ammunition(
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    caliber VARCHAR(50) NOT NULL,
    type VARCHAR(50) NOT NULL,
    quantity INT DEFAULT 0,
    status VARCHAR(50) NOT NULL,
    soldier_id INT,
    FOREIGN KEY (soldier_id) REFERENCES soldiers(id)
);

CREATE TABLE IF NOT EXISTS vehicles(
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    status VARCHAR(50) NOT NULL,
    capacity INT NOT NULL,
    armored BOOLEAN NOT NULL,
    produced DATE NOT NULL,
    soldier_id INT,
    FOREIGN KEY (soldier_id) REFERENCES soldiers(id)
);
