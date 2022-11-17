\c military_base
DROP TABLE IF EXISTS soldiers_raw;
CREATE TEMP TABLE soldiers_raw (
    data jsonb
);

\copy soldiers_raw (data) FROM 'dbdata/soldiers.json';

DROP TABLE IF EXISTS soldiers_json;

CREATE TABLE soldiers_json (
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

ALTER TABLE soldiers_json ADD CONSTRAINT P_ID PRIMARY KEY (id);
ALTER TABLE soldiers_json ALTER COLUMN first_name SET NOT NULL;
ALTER TABLE soldiers_json ALTER COLUMN last_name SET NOT NULL;
ALTER TABLE soldiers_json ALTER COLUMN rank SET NOT NULL;
ALTER TABLE soldiers_json ALTER COLUMN age SET NOT NULL;
ALTER TABLE soldiers_json ALTER COLUMN salary SET NOT NULL;
ALTER TABLE soldiers_json ALTER COLUMN arrival_date SET NOT NULL;
ALTER TABLE soldiers_json ALTER COLUMN departure_date SET NOT NULL;

ALTER TABLE soldiers_json ALTER COLUMN weapon_id SET NOT NULL;
ALTER TABLE soldiers_json ALTER COLUMN ammunition_id SET NOT NULL;
ALTER TABLE soldiers_json ALTER COLUMN vehicle_id SET NOT NULL;
ALTER TABLE soldiers_json ALTER COLUMN squad_id SET NOT NULL;

ALTER TABLE soldiers_json ADD CONSTRAINT CH_AGES CHECK (age >= 18);
ALTER TABLE soldiers_json ADD CONSTRAINT CH_SALARY CHECK (salary > 500);
ALTER TABLE soldiers_json ADD CONSTRAINT CH_DEPARTURE CHECK (arrival_date <= departure_date);

INSERT INTO soldiers_json (id, first_name, last_name, rank, age, salary, arrival_date, departure_date, weapon_id, ammunition_id, vehicle_id, squad_id)
SELECT (data->>'id')::INT, data ->> 'first_name', data ->> 'last_name', data ->> 'rank', (data ->> 'age')::INT, (data ->> 'salary')::INT, (data ->> 'arrival_date')::DATE, (data ->> 'departure_date')::DATE, (data ->> 'weapon_id')::INT, (data ->> 'ammunition_id')::INT, (data ->> 'vehicle_id')::INT, (data ->> 'squad_id')::INT
FROM soldiers_raw;

-- INSERT INTO military_base.soldiers SELECT * from soldiers_json;

UPDATE military_base.soldiers SET first_name = soldiers_json.first_name, last_name = soldiers_json.last_name, rank = soldiers_json.rank, age = soldiers_json.age, salary = soldiers_json.salary, arrival_date = soldiers_json.arrival_date, departure_date = soldiers_json.departure_date, weapon_id = soldiers_json.weapon_id, ammunition_id = soldiers_json.ammunition_id, vehicle_id = soldiers_json.vehicle_id, squad_id = soldiers_json.squad_id
FROM soldiers_json
WHERE soldiers.id = soldiers_json.id;
