/*psql -h localhost -p 5432 -U postgres -f mass_copy.sql */
\c military_base;
-- ALTER TABLE military_base.soldiers DROP CONSTRAINT F_AWID;
-- ALTER TABLE military_base.soldiers DROP CONSTRAINT F_AAID;
-- ALTER TABLE military_base.soldiers DROP CONSTRAINT F_AVID;

TRUNCATE TABLE military_base.soldiers;
TRUNCATE TABLE military_base.weapons CASCADE;
TRUNCATE TABLE military_base.ammunition CASCADE;
TRUNCATE TABLE military_base.vehicles CASCADE;
TRUNCATE TABLE military_base.squads CASCADE;

-- ALTER TABLE military_base.soldiers ADD CONSTRAINT F_AWID FOREIGN KEY (weapon_id) REFERENCES military_base.weapons(id);
-- ALTER TABLE military_base.soldiers ADD CONSTRAINT F_AAID FOREIGN KEY (ammunition_id) REFERENCES military_base.ammunition(id);
-- ALTER TABLE military_base.soldiers ADD CONSTRAINT F_AVID FOREIGN KEY (vehicle_id) REFERENCES military_base.vehicles(id);

\copy military_base.weapons(name,classification,caliber,status,produced,last_check) FROM './dbdata/weapons.csv' DELIMITER ',' CSV;

\copy military_base.ammunition(name,caliber,type,quantity,status) FROM './dbdata/ammo.csv' DELIMITER ',' CSV;

\copy military_base.vehicles(name,status,capacity,armored,produced) FROM './dbdata/vehicles.csv' DELIMITER ',' CSV;

\copy military_base.squads(cur_location,first_deploy,last_deploy,status,total_deploys,call_sign) FROM './dbdata/squads.csv' DELIMITER ',' CSV;

\copy military_base.soldiers(first_name,last_name,rank,age,salary,arrival_date,departure_date,weapon_id,ammunition_id,vehicle_id,squad_id) FROM './dbdata/soldiers.csv' DELIMITER ',' CSV;
