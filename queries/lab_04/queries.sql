CREATE EXTENSION plpython3u;
-- 1. Скалярная функция
-- Количесвто дней на базе
CREATE OR REPLACE FUNCTION military_base.days_on_base(date_start DATE, date_end DATE)
RETURNS INT LANGUAGE plpython3u AS $$
    return (int(date_end[:4]) - int(date_start[:4])) * 365 +\
             (int(date_end[5:7]) - int(date_start[5:7])) * 30 +\
              int(date_end[8:10]) - int(date_start[8:10])
$$;

SELECT id, first_name, last_name, military_base.days_on_base(arrival_date, departure_date) AS days_on_base from military_base.soldiers;

-- 2. Пользовательская агрегатная функция
-- Среднее количество дней на базе всех солдат
CREATE OR REPLACE FUNCTION avg_days_on_base()
RETURNS varchar LANGUAGE plpython3u AS $$
    query = "SELECT military_base.days_on_base(arrival_date, departure_date) as days_on_base FROM military_base.soldiers;"
    h = plpy.prepare(query)
    cursor = plpy.cursor(h)
    dsum = 0
    dlen = 0
    try:
        for row in cursor:
            dsum += row['days_on_base']
            dlen += 1
    finally:
        return dsum / dlen
$$;
DROP FUNCTION avg_days_on_base();
SELECT avg_days_on_base() AS avg_days_on_base;
SELECT first_name, last_name, call_sign, name, caliber from military_base.soldiers join (SELECT id, call_sign from military_base.squads) as ics on squad_id = ics.id join (SELECT id, name, caliber from military_base.weapons) as nc on weapon_id = nc.id;
-- 3. Определяемая пользователем табличная функция
-- Выводит всех солдат ранга rank
CREATE OR REPLACE FUNCTION military_base.soldiers_by_rank(rank varchar)
RETURNS TABLE(id int, first_name varchar, last_name varchar, rank varchar, arrival_date date, departure_date date) LANGUAGE plpython3u AS $$
    query = "SELECT * FROM military_base.soldiers WHERE soldiers.rank = '%s';" % rank
    h = plpy.prepare(query)
    cursor = plpy.cursor(h)
    try:
        return list(cursor)
    except Exception as e:
        cursor.close()
        plpy.error(e)
        return []
$$;
DROP FUNCTION military_base.soldiers_by_rank(rank varchar);
SELECT * FROM military_base.soldiers_by_rank('Private');

-- 4. Хранимая процедура
-- Добавление в таблицу солдат
CREATE OR REPLACE FUNCTION military_base.add_soldier(first_name varchar, last_name varchar, rank varchar, arrival_date date, departure_date date)
RETURNS void LANGUAGE plpython3u AS $$
    query = "INSERT INTO military_base.soldiers (first_name, last_name, rank, arrival_date, departure_date) VALUES ('%s', '%s', '%s', '%s', '%s');" % (first_name, last_name, rank, arrival_date, departure_date)
    try:
        plpy.notice("test")
        plpy.execute(query)
    except Exception as e:
        plpy.error(e)
$$;
DROP FUNCTION military_base.add_soldier(first_name varchar, last_name varchar, rank varchar, arrival_date date, departure_date date);
SELECT military_base.add_soldier('John', 'Doe', 'Private First Class', '2019-01-01', '2019-01-02');

-- 5. Триггер
-- При добавлении в таблицу, проверяет количество дней пребывания солдата на базе
CREATE OR REPLACE FUNCTION military_base.update_soldier()
RETURNS trigger LANGUAGE plpython3u AS $$
    query = "SELECT military_base.days_on_base(arrival_date, departure_date) as days_on_base FROM military_base.soldiers WHERE id = %s;" % TD['new']['id']
    try:
        res = plpy.execute(query)
    except Exception as e:
        plpy.error(e)
    if TD['new']['rank'] == 'Private' and res[0]['days_on_base'] > 365:
        plpy.notice('Soldier %s %s is ready for promotion' % (TD['new']['first_name'], TD['new']['last_name']))
    else:
        plpy.notice('Private %s %s is ready for deploy' % (TD['new']['first_name'], TD['new']['last_name']))
$$;
DROP TRIGGER IF EXISTS update_soldier ON military_base.soldiers;
CREATE TRIGGER update_soldier AFTER INSERT ON military_base.soldiers FOR EACH ROW EXECUTE PROCEDURE military_base.update_soldier();

INSERT INTO military_base.soldiers (first_name, last_name, rank, arrival_date, departure_date) VALUES ('John', 'Doe', 'Private', '2019-01-01', '2019-01-02');

DELETE FROM military_base.soldiers where first_name = 'Joe' and last_name = 'Doe';

-- 6. Определяемый пользователем тип данных
-- Возвращает id вооружния солдата
CREATE TYPE military_base.equipment_set AS (
    weapon_id int,
    ammunition_id int
);

CREATE OR REPLACE FUNCTION military_base.get_equipment_set(soldier_id int)
RETURNS military_base.equipment_set LANGUAGE plpython3u AS $$
    query = "SELECT * FROM military_base.soldiers WHERE id = %d;" % soldier_id
    h = plpy.prepare(query)
    cursor = plpy.cursor(h)

    try:
        return list(cursor)[0]
    except Exception as e:
        cursor.close()
        plpy.error(e)
        return []
$$;
DROP FUNCTION military_base.get_equipment_set(soldier_id int);
SELECT * FROM military_base.get_equipment_set(1);



-- Защита
-- Такую функцию, которую без питона ну никак
CREATE TABLE public.res (
    id int, first_name text, last_name text, vehicle_id int, vehicle_name text
);
DROP TABLE public.res;

CREATE OR REPLACE FUNCTION soldiers_on_vehicles()
    RETURNS SETOF res LANGUAGE plpython3u AS $$
    queryA = "SELECT id, first_name, last_name FROM military_base.soldiers;"
    queryB = "SELECT id, name, capacity FROM military_base.vehicles ORDER BY capacity DESC;"
    hA = plpy.prepare(queryA)
    cursorA = plpy.cursor(hA)
    hB = plpy.prepare(queryB)
    cursorB = plpy.cursor(hB)
    res = list()
    remaining_capacity = 0
    for row in cursorA:
        if remaining_capacity == 0:
            vehicle = cursorB.fetch(1)[0]
            if vehicle is None:
                break
            remaining_capacity = vehicle['capacity']
        dest = dict(row)
        dest.update({'vehicle_id': vehicle['id']})
        dest.update({'vehicle_name': vehicle['name']})
        res.append(dest)
        remaining_capacity -= 1
    return res
$$;
DROP FUNCTION soldiers_on_vehicles();
SELECT * from soldiers_on_vehicles() AS soldiers_on_vehicles;

SELECT id, name, capacity FROM military_base.vehicles ORDER BY capacity;