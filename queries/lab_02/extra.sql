-- Drop constaints first
-- Выбрать все отряды состоящих только из рядовых
INSERT INTO military_base.squads(id, cur_location, first_deploy, last_deploy, status, total_deploys, call_sign) VALUES (9999, 'Moscow', '2020-01-01', '2020-01-01', 'active', 1, 'Alpha');

INSERT INTO military_base.soldiers(first_name, last_name, rank, age, salary, arrival_date, departure_date, weapon_id, ammunition_id, vehicle_id, squad_id) VALUES ('Ivan', 'Ivanov', 'Private', 30, 1000, '2020-01-01', '2020-01-01', 1, 1, 1, 9999);
INSERT INTO military_base.soldiers(first_name, last_name, rank, age, salary, arrival_date, departure_date, weapon_id, ammunition_id, vehicle_id, squad_id) VALUES ('Ivan', 'Ivanov', 'Private', 30, 1000, '2020-01-01', '2020-01-01', 1, 1, 1, 9999);
INSERT INTO military_base.soldiers(first_name, last_name, rank, age, salary, arrival_date, departure_date, weapon_id, ammunition_id, vehicle_id, squad_id) VALUES ('Ivan', 'Ivanov', 'Private', 30, 1000, '2020-01-01', '2020-01-01', 1, 1, 1, 9999);
INSERT INTO military_base.soldiers(first_name, last_name, rank, age, salary, arrival_date, departure_date, weapon_id, ammunition_id, vehicle_id, squad_id) VALUES ('Ivan', 'Ivanov', 'Private', 30, 1000, '2020-01-01', '2020-01-01', 1, 1, 1, 9999);

SELECT * from military_base.squads where id not in (
    SELECT squad_id from military_base.soldiers where rank != 'Private'
) and id in (SELECT squad_id from military_base.soldiers where rank = 'Private');
