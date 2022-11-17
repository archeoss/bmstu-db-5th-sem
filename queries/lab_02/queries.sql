--1. Инструкция SELECT, использующая предикат сравнения.
--Вывести список рядовых
SELECT first_name, last_name, rank FROM military_base.soldiers WHERE rank = 'Private';

--2. Инструкция SELECT, использующая предикат BETWEEN.
--Вывести список военнослужащих, которые прибыли в военную часть в между 2002 и 2006 годами.
SELECT first_name, last_name, rank, arrival_date FROM military_base.soldiers WHERE arrival_date BETWEEN '2002-01-01' AND '2006-12-31';

--3. Инструкция SELECT, использующая предикат LIKE.
--Вывести спиписок активных или готовых к размещению отрядов.
SELECT cur_location, status, call_sign from military_base.squads where status LIKE '%Deploy%';

--4. Инструкция SELECT, использующая предикат IN с вложенным подзапросом.
--Вывести список вооружения, к которому закончился боезапас
SELECT name, classification, caliber, status from military_base.weapons where caliber IN
                          (SELECT ammunition.caliber from military_base.ammunition where ammunition.quantity = 0);

--5. Инструкция SELECT, использующая предикат EXISTS с вложенным подзапросом.
--Вывести список военнослужащих, которые имеют на вооружении оружие калибра 9х19мм.
SELECT first_name, last_name, rank, weapon_id from military_base.soldiers where EXISTS
    (SELECT weapons.caliber from military_base.weapons where soldiers.weapon_id=weapons.id and weapons.caliber = '9x19mm');

--6. Инструкция SELECT, использующая предикат сравнения с квантором.
--Вывести список военнослужащих, зарплата которых меньше зарплаты меньше всех рядовых.
SELECT id, first_name, last_name, rank, salary from military_base.soldiers where
       rank != 'Private' and salary < ALL (SELECT salary from military_base.soldiers where rank = 'Private');
--7. Инструкция SELECT, использующая агрегатные функции в выражениях столбцов.
--Вывести срееднее значение зарплаты рядовых.
SELECT AVG(salary) AS Private_AVG
FROM ( SELECT rank, salary
       FROM military_base.soldiers where rank = 'Private') as rs;

--8. Инструкция SELECT, использующая скалярные подзапросы в выражениях столбцов.
--Вывести всех не рядовых солдат со средней зарплатой по части
SELECT first_name, last_name, rank, (SELECT AVG(salary) from military_base.soldiers where rank!='Private') as sal_AVG
FROM military_base.soldiers where rank != 'Private';

--9. Инструкция SELECT, использующая простое выражение CASE.
--Вывести список военнослужащих, распределив их на "В зоне БД" и "Вне зоны БД".
SELECT first_name, last_name, rank, (SELECT CASE
    WHEN status = 'Deployed' THEN 'В зоне БД'
    ELSE 'Вне зоны БД'
END as status
FROM military_base.squads where soldiers.squad_id = squads.id) as status
FROM military_base.soldiers;

--Перевод званий военнослужащих на русский язык
SELECT first_name, last_name, rank, CASE
        WHEN rank = 'Private' THEN 'Рядовой'
        WHEN rank = 'Corporal' THEN 'Капрал'
        WHEN rank = 'Sergeant' THEN 'Сержант'
        WHEN rank = 'Lieutenant' THEN 'Лейтенант'
        WHEN rank = 'Captain' THEN 'Капитан'
        WHEN rank = 'Major' THEN 'Майор'
        WHEN rank = 'Colonel' THEN 'Полковник'
        WHEN rank = 'First Sergeant' THEN 'Старшина'
        WHEN rank = 'Staff Sergeant' THEN 'Штаб-Сержант'
        WHEN rank = 'Master Sergeant' THEN 'Старший Сержант'
        WHEN rank = 'Sergeant Major' THEN 'Сержант-Майор'
        WHEN rank = 'Sergeant First Class' THEN 'Сержант первого класса'
        WHEN rank = 'Private First Class' THEN 'Рядовой первого класса'
        WHEN rank = 'Specialist' THEN 'Ефрейтор'
        ELSE 'Неизвестный'
    END AS rank_name
FROM military_base.soldiers;

--10. Инструкция SELECT, использующая поисковое выражение CASE.
--Вывести список военнослужащих, просчитав достаточный ли у них боезапас на текущий момент
SELECT first_name, last_name, rank, (SELECT CASE
        WHEN quantity < 30 THEN 'Критическая нехватка, Обратитесь в оружейную'
        WHEN quantity < 60 THEN 'Боезопас на исходе, Обратитесь в оружейную'
        WHEN quantity < 120 THEN 'Боезапас в норме'
        ELSE 'Боезапас превышает норму'
        END as status
    FROM military_base.ammunition where soldiers.ammunition_id = ammunition.id) as ammo_status
FROM military_base.soldiers;

--11. Создание новой временной локальной таблицы из результирующего набора данных инструкции SELECT.
--Временная таблица содержит список военнослужащих старше 40 лет
CREATE TEMP TABLE temp_soldiers AS (
    SELECT first_name, last_name, age, rank FROM military_base.soldiers WHERE age > 40
);

--12. Инструкция SELECT, использующая вложенные коррелированные подзапросы
-- в качестве производных таблиц в предложении FROM.
--Вывести список вооружения капралов
SELECT * FROM (SELECT name, classification, caliber, id from military_base.weapons JOIN (
    SELECT weapon_id, rank
    FROM military_base.soldiers
    WHERE rank = 'Corporal'
) as wp ON id = weapon_id) as ws;

--13. Инструкция SELECT, использующая вложенные подзапросы с уровнем
-- вложенности 3 и более.
-- Вывод списка отрядов, в которых есть хотя бы 1 боец с AP патронами
SELECT id, call_sign, cur_location FROM military_base.squads WHERE id IN (
    SELECT id FROM military_base.soldiers WHERE weapon_id IN (
        SELECT id FROM military_base.weapons WHERE caliber IN (
            SELECT caliber FROM military_base.ammunition WHERE ammunition.type = 'AP' and ammunition.id = ammunition_id
        )
    )
);

--14. Инструкция SELECT, консолидирующая данные с помощью предложения
-- GROUP BY, но без предложения HAVING
-- Вывести технику со средним количеством мест на единицу техники и их общее количество
SELECT name, count(*) as count, AVG(capacity) as avg FROM military_base.vehicles GROUP BY name;

--15. Инструкция SELECT, консолидирующая данные с помощью предложения
-- GROUP BY и предложения HAVING.
-- Вывести технику со средним количеством мест на единицу техники больше 25 и их общее количество
SELECT name, count(*) as count, AVG(capacity) as avg FROM military_base.vehicles GROUP BY name HAVING AVG(capacity) > 25;

--16. Однострочная инструкция INSERT, выполняющая вставку в таблицу одной строки значений.
INSERT INTO military_base.weapons (name, classification, caliber, status, produced, last_check)
VALUES (9999,'M4A1', 'Assault Rifle', '5.56x45mm', 'In Service', '2004-01-01', '2019-01-01');
-- INSERT INTO military_base.weapons (name, classification, caliber, status, produced, last_check)
-- VALUES ('M4A1', 'Assault Rifle', '5.56x45mm', 'In Service', '2004-01-01', '2019-01-01');
-- SELECT lastval();
--17. Многострочная инструкция INSERT, выполняющая вставку в таблицу
-- нескольких строк значений.
INSERT INTO military_base.ammunition(name, caliber, type, quantity, status)
SELECT name, caliber, type, quantity, status FROM military_base.ammunition WHERE status = 'In Active Zone';
--18. Простая инструкция UPDATE.
UPDATE military_base.vehicles SET status = 'In Stock' WHERE status = 'Missing';
--19. Инструкция UPDATE со скалярным подзапросом в предложении SET.
UPDATE military_base.soldiers SET salary = (SELECT AVG(salary) FROM military_base.soldiers)
WHERE salary < 1300;
--20. Простая инструкция DELETE.
DELETE FROM military_base.soldiers WHERE soldiers.age > 40;
--21. Инструкция DELETE с вложенным коррелированным подзапросом в предложении WHERE.
DELETE FROM military_base.soldiers WHERE departure_date IN
(SELECT departure_date FROM military_base.soldiers WHERE departure_date < '2007-01-01');
--22. Инструкция SELECT, использующая простое обобщенное табличное выражение
-- Найти количество патрон на единицу оружия калибра 5.56x45mm
WITH lst(amount, weapons) AS (
    SELECT sum(quantity), s FROM military_base.ammunition FULL JOIN (SELECT count(*) as s FROM military_base.weapons WHERE caliber='5.56x45mm') as wc on true group by s
)
SELECT amount/weapons as ammo_per_weapon FROM lst;
--23. Инструкция SELECT, использующая рекурсивное обобщенное табличное выражение.
-- Выводит все отряды, где 2 <= кол-во высадок <= 5
WITH RECURSIVE max_deploys(id, total_deploys, call_sign, level) AS (
    SELECT sq.id, sq.total_deploys, sq.call_sign, 0 as level FROM military_base.squads as sq
    where sq.total_deploys = 2
    UNION ALL
    SELECT sqi.id, sqi.total_deploys, sqi.call_sign, level + 1 FROM military_base.squads sqi
                                                                        INNER JOIN max_deploys md1 ON (sqi.total_deploys = md1.total_deploys + 1) and level < 3
)
SELECT id, total_deploys, call_sign, level FROM max_deploys GROUP BY id, total_deploys, call_sign, level;
--24. Оконные функции. Использование конструкций MIN/MAX/AVG OVER()

SELECT name, type, AVG(quantity) OVER(PARTITION BY name) avg_quantity, COUNT(name) OVER(PARTITION BY name) AS entries_amount FROM military_base.ammunition;
--25. Оконные фнкции для устранения дублей
CREATE TEMP TABLE tmp AS
SELECT name, type, AVG(quantity) OVER(PARTITION BY name) avg_quantity, COUNT(name) OVER(PARTITION BY name) AS entries_amount FROM military_base.ammunition;
WITH temp_deleted AS
         (DELETE FROM tmp RETURNING *),
     temp_inserted AS
         (SELECT name, type, avg_quantity, entries_amount, ROW_NUMBER() OVER(PARTITION BY name, type ORDER BY name, type) rownum FROM temp_deleted)
INSERT INTO tmp SELECT name, type, avg_quantity, entries_amount FROM temp_inserted WHERE rownum = 1;
SELECT * FROM tmp;
DROP TABLE tmp;
