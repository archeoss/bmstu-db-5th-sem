-- Романов Семен Константинович, ИУ7-55Б
-- Вариант 3

DROP DATABASE IF EXISTS rk2;
CREATE DATABASE rk2;
\c rk2;

CREATE TABLE IF NOT EXISTS menu (
    id int primary key,
    name varchar(50),
    type_of_dish varchar(50),
    description varchar(255)
);

CREATE TABLE IF NOT EXISTS dishes (
    id int primary key,
    name varchar(50),
    description varchar(255),
    rating int
);

CREATE TABLE IF NOT EXISTS products (
    id int primary key,
    name varchar(50),
    production_date date,
    available_until date,
    man_name varchar(50)
);

CREATE TABLE IF NOT EXISTS products_dishes (
    products_id int,
    dish_id int,
    primary key (products_id, dish_id),
    foreign key (products_id) references products(id),
    foreign key (dish_id) references dishes(id)
);

CREATE TABLE IF NOT EXISTS menu_dishes (
    menu_id int,
    dish_id int,
    primary key (dish_id, menu_id),
    foreign key (dish_id) references dishes(id),
    foreign key (menu_id) references menu(id)
);

INSERT INTO menu (id, name, type_of_dish, description) VALUES (1, 'Menu1', 'type1', 'description1');
INSERT INTO menu (id, name, type_of_dish, description) VALUES (2, 'Menu2', 'type2', 'description2');
INSERT INTO menu (id, name, type_of_dish, description) VALUES (3, 'Menu3', 'type3', 'description3');
INSERT INTO menu (id, name, type_of_dish, description) VALUES (4, 'Menu4', 'type1', 'description4');
INSERT INTO menu (id, name, type_of_dish, description) VALUES (5, 'Menu5', 'type2', 'description5');
INSERT INTO menu (id, name, type_of_dish, description) VALUES (6, 'Menu6', 'type3', 'description1');
INSERT INTO menu (id, name, type_of_dish, description) VALUES (7, 'Menu7', 'type1', 'description2');
INSERT INTO menu (id, name, type_of_dish, description) VALUES (8, 'Menu8', 'type2', 'description3');
INSERT INTO menu (id, name, type_of_dish, description) VALUES (9, 'Menu9', 'type3', 'description4');
INSERT INTO menu (id, name, type_of_dish, description) VALUES (10, 'Menu10', 'type1', 'description5');


INSERT INTO dishes (id, name, description, rating) VALUES (1, 'dish1', 'description1', 1);
INSERT INTO dishes (id, name, description, rating) VALUES (2, 'dish2', 'description2', 2);
INSERT INTO dishes (id, name, description, rating) VALUES (3, 'dish3', 'description3', 6);
INSERT INTO dishes (id, name, description, rating) VALUES (4, 'dish4', 'description4', 8);
INSERT INTO dishes (id, name, description, rating) VALUES (5, 'dish5', 'description5', 5);
INSERT INTO dishes (id, name, description, rating) VALUES (6, 'dish6', 'description6', 6);
INSERT INTO dishes (id, name, description, rating) VALUES (7, 'dish7', 'description7', 7);
INSERT INTO dishes (id, name, description, rating) VALUES (8, 'dish8', 'description8', 8);
INSERT INTO dishes (id, name, description, rating) VALUES (9, 'dish9', 'description9', 9);
INSERT INTO dishes (id, name, description, rating) VALUES (10, 'dish10', 'description10', 10);


INSERT INTO products (id, name, production_date, available_until, man_name) VALUES (1, 'product1', '2019-01-01', '2019-01-01', 'man1');
INSERT INTO products (id, name, production_date, available_until, man_name) VALUES (2, 'product2', '2019-01-01', '2019-01-01', 'man2');
INSERT INTO products (id, name, production_date, available_until, man_name) VALUES (3, 'product3', '2019-01-01', '2019-01-01', 'man3');
INSERT INTO products (id, name, production_date, available_until, man_name) VALUES (4, 'product4', '2019-01-01', '2019-01-01', 'man4');
INSERT INTO products (id, name, production_date, available_until, man_name) VALUES (5, 'product5', '2019-01-01', '2019-01-01', 'man5');
INSERT INTO products (id, name, production_date, available_until, man_name) VALUES (6, 'product6', '2019-01-01', '2019-01-01', 'man6');
INSERT INTO products (id, name, production_date, available_until, man_name) VALUES (7, 'product7', '2019-01-01', '2019-01-01', 'man7');
INSERT INTO products (id, name, production_date, available_until, man_name) VALUES (8, 'product8', '2019-01-01', '2019-01-01', 'man8');
INSERT INTO products (id, name, production_date, available_until, man_name) VALUES (9, 'product9', '2019-01-01', '2019-01-01', 'man9');
INSERT INTO products (id, name, production_date, available_until, man_name) VALUES (10, 'product10', '2019-01-01', '2019-01-01', 'man10');

INSERT INTO products_dishes (products_id, dish_id) VALUES (1, 1);
INSERT INTO products_dishes (products_id, dish_id) VALUES (2, 2);
INSERT INTO products_dishes (products_id, dish_id) VALUES (3, 3);
INSERT INTO products_dishes (products_id, dish_id) VALUES (4, 4);
INSERT INTO products_dishes (products_id, dish_id) VALUES (5, 5);
INSERT INTO products_dishes (products_id, dish_id) VALUES (6, 6);
INSERT INTO products_dishes (products_id, dish_id) VALUES (7, 7);
INSERT INTO products_dishes (products_id, dish_id) VALUES (8, 8);
INSERT INTO products_dishes (products_id, dish_id) VALUES (9, 9);
INSERT INTO products_dishes (products_id, dish_id) VALUES (10, 10);
INSERT INTO products_dishes (products_id, dish_id) VALUES (1, 2);
INSERT INTO products_dishes (products_id, dish_id) VALUES (2, 3);
INSERT INTO products_dishes (products_id, dish_id) VALUES (3, 4);
INSERT INTO products_dishes (products_id, dish_id) VALUES (4, 5);
INSERT INTO products_dishes (products_id, dish_id) VALUES (5, 6);
INSERT INTO products_dishes (products_id, dish_id) VALUES (6, 7);
INSERT INTO products_dishes (products_id, dish_id) VALUES (7, 8);
INSERT INTO products_dishes (products_id, dish_id) VALUES (8, 9);
INSERT INTO products_dishes (products_id, dish_id) VALUES (9, 10);
INSERT INTO products_dishes (products_id, dish_id) VALUES (10, 1);


INSERT INTO menu_dishes (menu_id, dish_id) VALUES (1, 1);
INSERT INTO menu_dishes (menu_id, dish_id) VALUES (2, 2);
INSERT INTO menu_dishes (menu_id, dish_id) VALUES (3, 3);
INSERT INTO menu_dishes (menu_id, dish_id) VALUES (4, 4);
INSERT INTO menu_dishes (menu_id, dish_id) VALUES (5, 5);
INSERT INTO menu_dishes (menu_id, dish_id) VALUES (1, 2);
INSERT INTO menu_dishes (menu_id, dish_id) VALUES (2, 3);
INSERT INTO menu_dishes (menu_id, dish_id) VALUES (3, 4);
INSERT INTO menu_dishes (menu_id, dish_id) VALUES (4, 5);
INSERT INTO menu_dishes (menu_id, dish_id) VALUES (5, 6);
INSERT INTO menu_dishes (menu_id, dish_id) VALUES (6, 7);
INSERT INTO menu_dishes (menu_id, dish_id) VALUES (7, 8);
INSERT INTO menu_dishes (menu_id, dish_id) VALUES (8, 9);
INSERT INTO menu_dishes (menu_id, dish_id) VALUES (9, 10);
INSERT INTO menu_dishes (menu_id, dish_id) VALUES (10, 1);


-- Инструкция SELECT, использующая предикат сравнения с квантором
-- Вывести все блюда с рейтингом больше любого из блюда с id < 5

SELECT * FROM dishes WHERE rating > ALL (SELECT rating FROM dishes WHERE id < 5);

-- Инструкция SELECT, использующая агрегатные функции в выражениях столбцов
-- Подсчитывает среднюю оценку блюд в меню
SELECT menu.id, menu.name, menu.description, AVG(dishes.rating) AS avg_rating
FROM menu
         LEFT JOIN menu_dishes ON menu.id = menu_dishes.menu_id
         LEFT JOIN dishes ON menu_dishes.dish_id = dishes.id
GROUP BY menu.id, menu.name, menu.type_of_dish, menu.description;

-- Создание новой временной локальной таблицы из результирующего набора данных инструкции SELECT
-- Подсчитывает количество блюд в меню
CREATE TEMPORARY TABLE temp_table AS
    SELECT id, name, type_of_dish, description, COUNT(dish_id) AS count FROM menu
             LEFT JOIN menu_dishes ON menu.id = menu_dishes.menu_id
             GROUP BY id, name, type_of_dish, description;

SELECT * FROM temp_table;
DROP TABLE temp_table;

-- Создать хранимую процедуру без параметров, котороая в текущей базе данных обновляет все статистики для таблиц в схеме 'dbo' (в postgresql 'public').
-- Созданную процедуру протестировать.

-- вместо UPDATE STATISTICS в postgresql используется ANALYZE

CREATE OR REPLACE PROCEDURE update_statistics()
LANGUAGE plpgsql
AS $$
    #variable_conflict use_column
DECLARE
    table_name text;
BEGIN
    FOR table_name IN SELECT table_name FROM information_schema.tables WHERE table_schema = 'public'
    LOOP
        EXECUTE 'ANALYZE ' || table_name;
    END LOOP;
END;
$$;

CALL update_statistics();

SELECT schemaname, relname, last_analyze FROM pg_stat_all_tables where schemaname = 'public';


-- Создать хранимую процедуру с выходным параметром , которая удаляет все DDL тгриггеры  в текущей базе данныхю
-- Созданную процедуру протестировать.

CREATE OR REPLACE PROCEDURE delete_ddl_triggers()
LANGUAGE plpgsql
AS $$
    #variable_conflict use_column
DECLARE
    trigger_name text;
BEGIN
    FOR trigger_name IN SELECT trigger_name FROM information_schema.triggers WHERE trigger_schema = 'public' AND event_manipulation = 'DDL'
    LOOP
        EXECUTE 'DROP TRIGGER ' || trigger_name || ' ON ' || event_object_table;
    END LOOP;
END;
$$;

CALL delete_ddl_triggers();
