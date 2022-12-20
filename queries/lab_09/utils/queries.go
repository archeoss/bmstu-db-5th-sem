package utils

import (
	"context"
	"fmt"
	"github.com/go-redis/redis/v8"
	"gorm.io/gorm"
	"time"
)

var DESC = [...]string{
	"0. Выход",
	"1. Топ 10 зарплат на военной базе;",
	"2. Сравнительный анализ",
}

// GetTopSalary Написать запрос, получающий статистическую информацию на основе
// данных БД. Например, получение топ 10 самых покупаемых товаров или
// получение количества проданных деталей в каждом регионе.
func GetTopSalary(rdb *redis.Client, db *gorm.DB) string {
	ctx := context.Background()
	val, err := rdb.Get(ctx, "topSalary").Result()
	if err != nil {
		fmt.Println("Error, couldn't read")
		return ""
	}
	if val != "" {
		return val
	}
	rows, err := db.Raw("SELECT first_name, last_name, salary from military_base.soldiers ORDER BY salary LIMIT 10").Rows()
	res := RowsToString(rows)
	rdb.Set(ctx, "topSalary", res, 0)

	return res
}

func queryDB(db *gorm.DB) {
	time.Sleep(time.Second * 5)
	_, err := db.
		Raw("SELECT name, count(*) as count, AVG(capacity) as avg FROM military_base.vehicles GROUP BY name;").
		Rows()
	if err != nil {
		fmt.Println("Error during queryDB")
		return
	}
	fmt.Println("queryDB complete")
}

func queryRedis(rdb *redis.Client, db *gorm.DB) {
	time.Sleep(time.Second * 5)
	ctx := context.Background()
	val, err := rdb.Get(ctx, "vehiclesGroup").Result()
	if err != nil {
		fmt.Println("Error, couldn't read")
		return
	}
	if val != "" {
		fmt.Println("queryRedis complete")
		return
	}
	rows, err := db.
		Raw("SELECT name, count(*) as count, AVG(capacity) as avg FROM military_base.vehicles GROUP BY name;").
		Rows()
	res := RowsToString(rows)
	rdb.Set(ctx, "vehiclesGroup", res, 0)
	fmt.Println("queryRedis complete (raw sql)")
	//return res
}

// Провести сравнительный анализ времени выполнения запросов и сформировать графики зависимости:
//  1. Без изменения данных в БД
//  2. При добавлении новых строк каждые 10 секунд
//  3. При удалении строк каждые 10 секунд
//  4. При изменении строк каждые 10 секунд

func changeDB(db *gorm.DB) {
	time.Sleep(time.Second * 10)
	_, err := db.
		Raw("UPDATE military_base.vehicles SET capacity = 100 WHERE id = 1;").
		Rows()
	if err != nil {
		fmt.Println("Error during changeDB")
		return
	}
	fmt.Println("changeDB complete")
}

func changeRedis(rdb *redis.Client, db *gorm.DB) {
	time.Sleep(time.Second * 10)
	ctx := context.Background()
	val, err := rdb.Get(ctx, "vehiclesGroup").Result()
	if err != nil {
		fmt.Println("Error, couldn't read")
		return
	}
	if val != "" {
		fmt.Println("changeRedis complete")
		return
	}
	rows, err := db.
		Raw("UPDATE military_base.vehicles SET capacity = 100 WHERE id = 1;").
		Rows()
	res := RowsToString(rows)
	rdb.Set(ctx, "vehiclesGroup", res, 0)
	fmt.Println("changeRedis complete (raw sql)")
	//return res
}

func deleteDB(db *gorm.DB) {
	time.Sleep(time.Second * 10)
	_, err := db.
		Raw("DELETE FROM military_base.vehicles WHERE id = 1;").
		Rows()
	if err != nil {
		fmt.Println("Error during deleteDB")
		return
	}
	fmt.Println("deleteDB complete")
}

func deleteRedis(rdb *redis.Client, db *gorm.DB) {
	time.Sleep(time.Second * 10)
	ctx := context.Background()
	val, err := rdb.Get(ctx, "vehiclesGroup").Result()
	if err != nil {
		fmt.Println("Error, couldn't read")
		return
	}
	if val != "" {
		fmt.Println("deleteRedis complete")
		return
	}
	rows, err := db.
		Raw("DELETE FROM military_base.vehicles WHERE id = 1;").
		Rows()
	res := RowsToString(rows)
	rdb.Set(ctx, "vehiclesGroup", res, 0)
	fmt.Println("deleteRedis complete (raw sql)")
	//return res
}

func insertDB(db *gorm.DB) {
	time.Sleep(time.Second * 10)
	_, err := db.
		Raw("INSERT INTO military_base.vehicles (name, capacity) VALUES ('tank', 100);").
		Rows()
	if err != nil {
		fmt.Println("Error during insertDB")
		return
	}
	fmt.Println("insertDB complete")
}

func insertRedis(rdb *redis.Client, db *gorm.DB) {
	time.Sleep(time.Second * 10)
	ctx := context.Background()
	val, err := rdb.Get(ctx, "vehiclesGroup").Result()
	if err != nil {
		fmt.Println("Error, couldn't read")
		return
	}
	if val != "" {
		fmt.Println("insertRedis complete")
		return
	}
	rows, err := db.
		Raw("INSERT INTO military_base.vehicles (name, capacity) VALUES ('tank', 100);").
		Rows()
	res := RowsToString(rows)
	rdb.Set(ctx, "vehiclesGroup", res, 0)
	fmt.Println("insertRedis complete (raw sql)")
	//return res
}

func CompareTime(db *gorm.DB) {
	rdb := redis.NewClient(&redis.Options{
		Addr:     "localhost :6379",
		Password: "", // no password set
		DB:       0,  // use default DB
	})
	ctx := context.Background()
	rdb.FlushDB(ctx)
	// 1. Без изменения данных в БД
	fmt.Println("1. Без изменения данных в БД")
	start := time.Now()
	queryDB(db)
	elapsed := time.Since(start)
	fmt.Println("Time elapsed: ", elapsed)
	start = time.Now()
	queryRedis(rdb, db)
	elapsed = time.Since(start)
	fmt.Println("Time elapsed: ", elapsed)
	// 2. При добавлении новых строк каждые 10 секунд
	fmt.Println("2. При добавлении новых строк каждые 10 секунд")
	go insertDB(db)
	go insertRedis(rdb, db)
	start = time.Now()
	queryDB(db)
	elapsed = time.Since(start)
	fmt.Println("Time elapsed: ", elapsed)
	start = time.Now()
	queryRedis(rdb, db)
	elapsed = time.Since(start)
	fmt.Println("Time elapsed: ", elapsed)
	// 3. При удалении строк каждые 10 секунд
	fmt.Println("3. При удалении строк каждые 10 секунд")
	go deleteDB(db)
	go deleteRedis(rdb, db)
	start = time.Now()
	queryDB(db)
	elapsed = time.Since(start)
	fmt.Println("Time elapsed: ", elapsed)
	start = time.Now()
	queryRedis(rdb, db)
	elapsed = time.Since(start)
	fmt.Println("Time elapsed: ", elapsed)
	// 4. При изменении строк каждые 10 секунд
	fmt.Println("4. При изменении строк каждые 10 секунд")
	go changeDB(db)
	go changeRedis(rdb, db)
	start = time.Now()
	queryDB(db)
	elapsed = time.Since(start)
	fmt.Println("Time elapsed: ", elapsed)
	start = time.Now()
	queryRedis(rdb, db)
	elapsed = time.Since(start)
	fmt.Println("Time elapsed: ", elapsed)
}
