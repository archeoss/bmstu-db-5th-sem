package utils

var DESC = [...]string{
	"0. Выход",
	"*** TO OBJECT ***",
	"1. SELECT count(*) FROM military_base.soldiers;",
	"2. SELECT first_name, last_name, call_sign, name, caliber from military_base.soldiers join " +
		"(SELECT id, call_sign from military_base.squads) as ics on squad_id = ics.id join " +
		"(SELECT id, name, caliber from military_base.weapons) as nc on weapon_id = nc.id;",
	"3. SELECT cur_location, status, call_sign from military_base.squads where status LIKE '%Deploy%';",
	"4. SELECT first_name, last_name, rank, arrival_date FROM military_base.soldiers WHERE arrival_date BETWEEN '2002-01-01' AND '2006-12-31';",
	"5. SELECT name, count(*) as count, AVG(capacity) as avg FROM military_base.vehicles GROUP BY name;",
	"*** TO JSON ***",
	"6. Прочитать из JSON;",
	"7. Обновление JSON;",
	"8. Запись (добавление) в JSON;",
	"*** TO SQL ***",
	"9. Однотабличный запрос;",
	"10. Многотабличный запрос;",
	"11. Запрос на добавление;",
	"12. Запрос на удаление;",
	"13. Запрос на изменение;",
	"14. Запрос используя агрегатные функции;",
}
