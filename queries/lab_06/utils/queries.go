package utils

var DESC = [...]string{
	"0. Выход",
	"1. Выполнить скалярный запрос;",
	"2. Выполнить запрос с несколькими соединениями (JOIN);",
	"3. Выполнить запрос с ОТВ(CTE) и оконными функциями;",
	"4. Выполнить запрос к метаданным;",
	"5. Вызвать скалярную функцию (написанную в третьей лабораторной работе);",
	"6. Вызвать многооператорную или табличную функцию (написанную в третьей лабораторной работе);",
	"7. Вызвать хранимую процедуру (написанную в третьей лабораторной работе);",
	"8. Вызвать системную функцию или процедуру;",
	"9. Создать таблицу в базе данных, соответствующую тематике БД;",
	"10. Выполнить вставку данных в созданную таблицу с использованием инструкции INSERT или COPY",
	"11. TEST <10>",
	"12. DROP TABLE <10>",
}

var QUERY = map[int]string{
	0: "EXIT",
	1: "SELECT count(*) FROM military_base.soldiers;",
	2: "SELECT first_name, last_name, call_sign, name, caliber from military_base.soldiers join (SELECT id, call_sign from military_base.squads) as ics on squad_id = ics.id join (SELECT id, name, caliber from military_base.weapons) as nc on weapon_id = nc.id;",
	3: "WITH lst(weapon_name, caliber, ammo_amount, weapon_amount) AS" +
		"(SELECT weapons.name, weapons.caliber,cnt , COUNT(weapons.name)" +
		"FROM military_base.weapons join (SELECT caliber, SUM(ammunition.quantity) cnt from military_base.ammunition GROUP BY caliber) as cc on weapons.caliber = cc.caliber GROUP BY weapons.caliber, weapons.name, cnt) SELECT weapon_name, caliber, ammo_amount, weapon_amount, ammo_amount/weapon_amount as ammo_per_weapon FROM lst;",
	4:  "SELECT table_name, column_name, data_type from information_schema.columns WHERE table_schema = 'military_base';",
	5:  "SELECT * from military_base.avgSalary();",
	6:  "SELECT * FROM military_base.inCombat();",
	7:  "CALL military_base.derankToPrivates(1);",
	8:  "SELECT pg_sleep(5);",
	9:  "CREATE TABLE IF NOT EXISTS military_base.provisions (id SERIAL PRIMARY KEY, name VARCHAR(255) NOT NULL, amount INT NOT NULL);",
	10: "INSERT INTO military_base.provisions (name, amount) VALUES ('bread', 100), ('water', 100), ('ammo', 100);",
	11: "SELECT * FROM military_base.provisions;",
	12: "DROP TABLE military_base.provisions;",
}
