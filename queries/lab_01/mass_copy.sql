/*psql -h localhost -p 5432 -U postgres -f mass_copy.sql */
\c military_base;
SELECT * FROM soldiers;
ALTER TABLE weapons DROP CONSTRAINT F_AWID;
ALTER TABLE ammunition DROP CONSTRAINT F_AAID;
ALTER TABLE vehicles DROP CONSTRAINT F_AVID;

TRUNCATE TABLE weapons;
TRUNCATE TABLE ammunition;
TRUNCATE TABLE vehicles;
TRUNCATE TABLE soldiers;

ALTER TABLE ammunition ADD CONSTRAINT F_AAID FOREIGN KEY (attached_soldier_id) REFERENCES soldiers(id);
ALTER TABLE vehicles ADD CONSTRAINT F_AVID FOREIGN KEY (attached_soldier_id) REFERENCES soldiers(id);
ALTER TABLE weapons ADD CONSTRAINT F_AWID FOREIGN KEY (attached_soldier_id) REFERENCES soldiers(id);

\copy soldiers FROM './dbdata/soldiers.csv' DELIMITER ',' CSV HEADER;

\copy weapons FROM './dbdata/weapons.csv' DELIMITER ',' CSV HEADER;

\copy ammunition FROM './dbdata/ammo.csv' DELIMITER ',' CSV HEADER;

\copy vehicles FROM './dbdata/vehicles.csv' DELIMITER ',' CSV HEADER;
