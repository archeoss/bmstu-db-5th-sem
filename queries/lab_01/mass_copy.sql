
\c military_base;

\copy soldiers FROM './dbdata/soldiers.csv' DELIMITER ',' CSV HEADER;

\copy weapons FROM './dbdata/weapons.csv' DELIMITER ',' CSV HEADER;

\copy ammunition FROM './dbdata/ammo.csv' DELIMITER ',' CSV HEADER;

\copy vehicles FROM './dbdata/vehicles.csv' DELIMITER ',' CSV HEADER;
