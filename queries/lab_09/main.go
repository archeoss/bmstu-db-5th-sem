package main

import (
	"app/utils"
	"fmt"
	"github.com/go-redis/redis/v8"
	"github.com/jackc/pgpassfile"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
	"os"
)

func main() {
	configPath, err := os.UserConfigDir()
	if err != nil {
		panic(err)
	}
	passfile, err := pgpassfile.ReadPassfile(configPath + "/pgpass.conf")
	if err != nil {
		panic(err)
	}

	password := passfile.FindPassword("localhost", "5432", "military_base", "postgres")
	dsn := fmt.Sprintf("host=localhost user=postgres password=%s dbname=military_base port=5432", password)
	db, err := gorm.Open(postgres.Open(dsn), &gorm.Config{})
	db.Exec("SET search_path TO military_base")
	if err != nil {
		panic(err)
	}

	//ctx := context.Background()

	rdb := redis.NewClient(&redis.Options{
		Addr:     "localhost:6379",
		Password: "", // no password set
		DB:       0,  // use default DB
	})
	for {
		utils.PrintMenu()

		commandNum := utils.GetCommandNumber()
		switch commandNum {
		case 0:
			break
		case 1:
			utils.GetTopSalary(rdb, db)
		case 2:
			utils.CompareTime(db)

		default:
			fmt.Println("Unknown command")
		}
	}
}
