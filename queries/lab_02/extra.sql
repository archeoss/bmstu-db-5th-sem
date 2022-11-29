DROP TABLE Table1;
DROP TABLE Table2;
CREATE TABLE IF NOT EXISTS Table1 (
    id INT NOT NULL,
    var1 VARCHAR(255) NOT NULL,
    valid_from_dttm date,
    valid_to_dttm date
);

CREATE TABLE IF NOT EXISTS Table2 (
    id INT NOT NULL,
    var2 VARCHAR(255) NOT NULL,
    valid_from_dttm date,
    valid_to_dttm date
);

INSERT INTO table1 (id, var1, valid_from_dttm, valid_to_dttm)
VALUES (1, 'A', '2018-09-01', '2018-09-15'),
       (1, 'B', '2018-09-16', '2018-09-26'),
       (1, 'C', '2018-09-27', '5999-12-31'),
         (2, 'C', '2018-09-05', '2018-09-17'),
         (2, 'B', '2018-09-18', '2018-09-23'),
         (2, 'A', '2018-09-24', '5999-12-31'),
         (3, 'D', '2018-09-04', '2018-09-15'),
         (3, 'E', '2018-09-16', '2018-09-26'),
         (3, 'R', '2018-09-27', '5999-12-31');

INSERT INTO table2 (id, var2, valid_from_dttm, valid_to_dttm)
VALUES (1, 'A', '2018-09-01', '2018-09-18'),
       (1, 'B', '2018-09-19', '5999-12-31'),
       (2, 'C', '2018-09-02', '2018-09-19'),
       (2, 'B', '2018-09-20', '5999-12-31'),
       (3, 'D', '2018-09-01', '2018-09-18'),
       (3, 'E', '2018-09-19', '5999-12-31');

-- Выполнить версионное соединение двух талиц по полю id.

SELECT * from (SELECT t1.id, var1, var2, t1.valid_from_dttm, least(t1.valid_to_dttm, t2.valid_to_dttm) valid_to_dttm from Table2 t2 JOIN Table1 t1 on t1.id = t2.id and t1.valid_from_dttm = t2.valid_from_dttm) as "T2T1*"
UNION
SELECT * from (SELECT t1.id, var1, var2, greatest(t1.valid_from_dttm, t2.valid_from_dttm) valid_from_dttm, t1.valid_to_dttm from Table2 t2 JOIN Table1 t1 on t1.id = t2.id and t1.valid_to_dttm = t2.valid_to_dttm) as "*T2T1"
UNION
SELECT * from (SELECT t1.id, var1, var2, t2.valid_from_dttm, t1.valid_to_dttm from Table2 t2 JOIN Table1 t1 on t1.id = t2.id and t1.valid_to_dttm < t2.valid_to_dttm and t1.valid_to_dttm > t2.valid_from_dttm) as "*T2T1*"
UNION
SELECT * from (SELECT t1.id, var1, var2, t1.valid_from_dttm, t2.valid_to_dttm from Table2 t2 JOIN Table1 t1 on t1.id = t2.id and t2.valid_to_dttm < t1.valid_to_dttm and t2.valid_to_dttm > t1.valid_from_dttm) as "*T1T2*"
order by id, valid_from_dttm;
