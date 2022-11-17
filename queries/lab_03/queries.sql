-- 1. Скалаярная функция
-- Средння ЗП.
CREATE OR REPLACE FUNCTION military_base.avgSalary() RETURNS FLOAT language plpgsql AS $$
BEGIN
    RETURN (SELECT AVG(salary) FROM military_base.soldiers);
END;
$$;

CREATE OR REPLACE FUNCTION military_base.avgSalaryByRank(dstrank VARCHAR) RETURNS FLOAT language plpgsql AS $$
BEGIN
    RETURN (SELECT AVG(salary) FROM military_base.soldiers WHERE dstrank = soldiers.rank);
END;
$$;

SELECT military_base.avgSalary(), military_base.avgSalaryByRank('Private');

-- 2. Подставляемая табличная функция
-- Оружие всех солдат со званием dstrank
CREATE TABLE foo (
    id int,
name varchar,
classification varchar,
caliber varchar);
CREATE OR REPLACE FUNCTION military_base.weaponsByRankTable(_tbl_type ANYELEMENT, dstrank VARCHAR) RETURNS SETOF ANYELEMENT language plpgsql AS $$
    #variable_conflict use_column
BEGIN
    RETURN QUERY SELECT * FROM (SELECT id, name, classification, caliber from military_base.weapons JOIN (
        SELECT weapon_id, rank
        FROM military_base.soldiers
        WHERE rank = dstrank
    ) as wp ON weapons.id = weapon_id) as ws;
END;
$$;

SELECT * from military_base.weaponsByRankTable(NULL::foo, 'Corporal');

-- 3. Многооператорная табличная функция
-- Все бойцы находящиеся в зоне боевых действий
CREATE OR REPLACE FUNCTION military_base.inCombat() RETURNS TABLE(first_name VARCHAR, last_name VARCHAR, rank VARCHAR, status text) language plpgsql AS $$
    #variable_conflict use_column
declare
    BEGIN
    RETURN QUERY (SELECT first_name, last_name, rank, (SELECT CASE
                WHEN status = 'Deployed' THEN 'A'
                ELSE 'B'
                END as status
        FROM military_base.squads where soldiers.squad_id = squads.id) as status
    FROM military_base.soldiers);
END;
$$;

SELECT * from military_base.inCombat();

-- 4. Рекурсивная функция
-- Выводит все отряды, где low_bound <= кол-во высадок <= high_bound
CREATE OR REPLACE FUNCTION military_base.recursiveSoldiers(low_bound int, range int) RETURNS TABLE(id int, total_deploys int, call_sign varchar, level int) language plpgsql AS $$
    #variable_conflict use_column
BEGIN
    RETURN QUERY WITH RECURSIVE max_deploys(id, total_deploys, call_sign, level) AS (
        SELECT sq.id, sq.total_deploys, sq.call_sign, 0 as level FROM military_base.squads as sq
        where sq.total_deploys = low_bound
        UNION ALL
        SELECT sqi.id, sqi.total_deploys, sqi.call_sign, level + 1 FROM military_base.squads sqi
                INNER JOIN max_deploys md1 ON (sqi.total_deploys = md1.total_deploys + 1) and level < range
    )
    SELECT id, total_deploys, call_sign, level FROM max_deploys GROUP BY id, total_deploys, call_sign, level;
END;
$$;
DROP FUNCTION military_base.recursivesoldiers(integer,integer);
SELECT * from military_base.recursiveSoldiers(2, 3);

-- 5. Хранимая процедура с параметрами
-- Разжалует всех до рядоввых в отряде с id = squadID
CREATE OR REPLACE PROCEDURE military_base.derankToPrivates(squadID int) language plpgsql AS $$
BEGIN
    UPDATE military_base.soldiers SET rank = 'Private' WHERE squad_id = squadID;
END;
$$;

CALL military_base.derankToPrivates(1);

-- 6.  Рекурсивную хранимую процедуру или хранимую процедур с рекурсивным ОТВ
-- Выводит количество отрядов, в пределах low_bound <= кол-во высадок <= high_bound

CREATE OR REPLACE PROCEDURE military_base.recursiveSoldiersProc(low_bound int, high_bound int) language plpgsql AS $$
    #variable_conflict use_column
    DECLARE
        counter int;
        total_deploys int;
BEGIN
        SELECT total_deploys, count(call_sign)from military_base.squads sq
        where sq.total_deploys = low_bound
        group by total_deploys
        INTO total_deploys, counter;
    RAISE NOTICE 'Total squads with % deploys: %', total_deploys, counter;
    IF low_bound < high_bound THEN
        CALL military_base.recursiveSoldiersProc(low_bound + 1, high_bound);
    END IF;
END;
$$;
CALL military_base.recursiveSoldiersProc(2, 5);

-- 7. Хранимая процедура с курсором
-- Выводит зарплаты солдат в отряде с id = squadID
CREATE OR REPLACE PROCEDURE military_base.fetch_salary_by_squad(squadID int) language plpgsql AS $$
DECLARE
    cur CURSOR FOR SELECT id, first_name, last_name, salary FROM military_base.soldiers WHERE squad_id = squadID;
    row RECORD;
BEGIN
    OPEN cur;
    LOOP
        FETCH cur INTO row;
        EXIT WHEN NOT FOUND;
        RAISE NOTICE 'Soldier % % % has salary %', row.first_name, row.last_name, row.id, row.salary;
    end loop;
    CLOSE cur;
end;
$$;

CALL military_base.fetch_salary_by_squad(2);

-- 8. Хранимую процедуру доступа к метаданным
-- Информация о БД
CREATE OR REPLACE PROCEDURE military_base.fetch_table_info() language plpgsql AS $$
DECLARE
    cur CURSOR FOR SELECT table_name, column_name, data_type from information_schema.columns WHERE table_schema = 'military_base';
    row RECORD;
BEGIN
    open cur;
    LOOP
        FETCH cur INTO row;
        EXIT WHEN NOT FOUND;
        RAISE NOTICE 'Table % has column % of type %', row.table_name, row.column_name, row.data_type;
    end loop;
    CLOSE cur;
END;
$$;

CALL military_base.fetch_table_info();

-- 9. Триггер AFTER
-- Если при добавлении нет даты прибытия, то ставит текущую дату
CREATE OR REPLACE FUNCTION military_base.update_soldier_rank() RETURNS trigger language plpgsql AS $$
BEGIN
    UPDATE military_base.soldiers
        SET arrival_date = CURRENT_DATE WHERE
            id = NEW.id AND arrival_date IS NULL;
    RETURN NEW;
END;
$$;
CREATE OR REPLACE TRIGGER update_soldier_rank AFTER INSERT OR UPDATE ON military_base.soldiers FOR ROW EXECUTE PROCEDURE military_base.update_soldier_rank();
DROP TRIGGER update_soldier_rank ON military_base.soldiers;

INSERT INTO military_base.soldiers (first_name, last_name, rank, squad_id) VALUES ('John', 'Doe', 'Private', 1);
DELETE FROM military_base.soldiers WHERE first_name = 'John' AND last_name = 'Doe' AND rank = 'Private';

-- 10. Триггер INSTEAD OF
-- Добавляет новую запись в таблицу, если количество занятых мест в отряде меньше 12;

CREATE OR REPLACE FUNCTION military_base.check_squad_size() RETURNS trigger language plpgsql AS $$
BEGIN
    IF (SELECT COUNT(*) FROM military_base.soldiers WHERE squad_id = NEW.squad_id) < 12 THEN
        INSERT INTO military_base.soldiers (first_name, last_name, rank, squad_id) VALUES (NEW.first_name, NEW.last_name, NEW.rank, NEW.squad_id);
        RAISE NOTICE 'Inserted % % % %; Squad is % soldiers size', NEW.first_name, NEW.last_name, NEW.rank, NEW.squad_id, COUNT(*);
        RETURN NEW;
    ELSE
        RAISE NOTICE 'Cant insert % % % %; Squad is full', NEW.first_name, NEW.last_name, NEW.rank, NEW.squad_id;
        RAISE EXCEPTION 'Squad is full';
    END IF;
END;
$$;

CREATE OR REPLACE VIEW military_base.soldiers_view AS SELECT * FROM military_base.soldiers LIMIT 12;
CREATE OR REPLACE TRIGGER check_squad_size INSTEAD OF INSERT ON military_base.soldiers_view FOR EACH ROW EXECUTE PROCEDURE military_base.check_squad_size();

INSERT INTO military_base.soldiers_view (first_name, last_name, rank, squad_id) VALUES ('John', 'Doe', 'Private', 1);

-- ЗАЩИТА
-- Функция, которая выводит необходимое для отрядов тип патронов

CREATE OR REPLACE FUNCTION military_base.get_ammo_for_squads() RETURNS TABLE(id int, call_sign varchar, ammo varchar) language plpgsql AS $$
    #variable_conflict use_column
BEGIN
    RETURN QUERY SELECT squad_id, squads.call_sign, weapons.caliber from military_base.soldiers join military_base.weapons on soldiers.weapon_id = weapons.id JOIN military_base.squads on soldiers.squad_id = squads.id GROUP BY squad_id, weapons.caliber, call_sign ORDER BY squad_id;
END;
$$;
SELECT * FROM military_base.get_ammo_for_squads();
