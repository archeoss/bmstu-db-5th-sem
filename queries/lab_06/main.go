package main

import (
	"app/utils"
	"fmt"
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
	if err != nil {
		panic(err)
	}
	for {
		utils.PrintMenu()

		command := utils.GetCommand()
		if command == "EXIT" {
			break
		}
		rows, err := db.Raw(command).Rows()
		if err != nil {
			panic(err)
		}

		utils.PrintRows(rows)
	}
}
