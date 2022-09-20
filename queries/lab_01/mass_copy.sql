/*psql -h localhost -p 5432 -U postgres -f mass_copy.sql */
\c military_base;
ALTER TABLE military_base.soldiers DROP CONSTRAINT F_AWID;
ALTER TABLE military_base.soldiers DROP CONSTRAINT F_AAID;
ALTER TABLE military_base.soldiers DROP CONSTRAINT F_AVID;

TRUNCATE TABLE military_base.weapons;
TRUNCATE TABLE military_base.ammunition;
TRUNCATE TABLE military_base.vehicles;
TRUNCATE TABLE military_base.soldiers;

ALTER TABLE military_base.soldiers ADD CONSTRAINT F_AWID FOREIGN KEY (weapon_id) REFERENCES military_base.weapons(id);
ALTER TABLE military_base.soldiers ADD CONSTRAINT F_AAID FOREIGN KEY (ammunition_id) REFERENCES military_base.ammunition(id);
ALTER TABLE military_base.soldiers ADD CONSTRAINT F_AVID FOREIGN KEY (vehicle_id) REFERENCES military_base.vehicles(id);

\copy military_base.weapons FROM './dbdata/weapons.csv' DELIMITER ',' CSV;

\copy military_base.ammunition FROM './dbdata/ammo.csv' DELIMITER ',' CSV;

\copy military_base.vehicles FROM './dbdata/vehicles.csv' DELIMITER ',' CSV;

\copy military_base.soldiers FROM './dbdata/soldiers.csv' DELIMITER ',' CSV;
