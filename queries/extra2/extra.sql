DROP TABLE Table1;

CREATE TABLE IF NOT EXISTS Table1 (
    id INT NOT NULL,
    FIO VARCHAR(255) NOT NULL,
    date_of_status date,
    status VARCHAR(60)
);

INSERT INTO table1 (id, FIO, date_of_status, status)
VALUES ( 1, 'Иванов Иван Иванович','2022-12-12', 'Работа offline'),
       ( 1, 'Иванов Иван Иванович','2022-12-13', 'Работа offline'),
       ( 1, 'Иванов Иван Иванович','2022-12-14', 'Больничный'),
       ( 1, 'Иванов Иван Иванович','2022-12-15', 'Больничный'),
       ( 1, 'Иванов Иван Иванович','2022-12-16', 'Удаленная работа'),
       ( 2, 'Петров Петр Петрович','2022-12-12', 'Работа offline'),
       ( 2, 'Петров Петр Петрович','2022-12-13', 'Работа offline'),
       ( 2, 'Петров Петр Петрович','2022-12-14', 'Удаленная работа'),
       ( 2, 'Петров Петр Петрович','2022-12-15', 'Удаленная работа'),
       ( 2, 'Петров Петр Петрович','2022-12-16', 'Работа offline');

-- Выполнить версионное соединение двух талиц по полю id.

SELECT fio, status, min(date_of_status) as date_from,
       max(date_of_status) as date_to
FROM (SELECT ROW_NUMBER() OVER(
    PARTITION BY id, fio, status
    ORDER BY date_of_status
    ) AS i, fio, status, date_of_status
      from Table1) as T
group by fio, status, date_of_status - make_interval(days => i::int) order by fio, date_from;

-- SELECT ROW_NUMBER() OVER(
--     PARTITION BY id, fio, status
--     ORDER BY date_of_status
--     ) AS i, fio, status, date_of_status
-- from Table1;