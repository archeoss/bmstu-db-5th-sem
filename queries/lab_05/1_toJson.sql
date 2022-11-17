\c military_base;

\t on
\o ./dbdata/soldiers.json
SELECT row_to_json(r) FROM military_base.soldiers r;
\o

\o ./dbdata/weapons.json
SELECT row_to_json(r) FROM military_base.weapons r;
\o

\o ./dbdata/vehicles.json
SELECT row_to_json(r) FROM military_base.vehicles r;
\o

\o ./dbdata/ammunition.json
SELECT row_to_json(r) FROM military_base.ammunition r;
\o

\o ./dbdata/squads.json
SELECT row_to_json(r) FROM military_base.squads r;
\o
\t off
