package main

import (
	"app/query"
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
	db.Exec("SET search_path TO military_base")
	var jsonData query.JSON
	if err != nil {
		panic(err)
	}
	for {
		utils.PrintMenu()

		commandNum := utils.GetCommandNumber()
		if commandNum == 0 {
			break
		}
		if commandNum < 6 {
			res := query.ToObject(db, commandNum)
			utils.PrintRows(res)
		} else if commandNum < 9 {
			switch commandNum {
			case 6:
				fmt.Println("Введите имя файла:")
				filename := utils.ReadString()
				jsonData = query.ReadJSON(filename)
				fmt.Println(jsonData)
			case 7:
				if jsonData == nil {
					fmt.Println("Сначала загрузите данные")
					continue
				} else {
					fmt.Println("Введите имя файла:")
					filename := utils.ReadString()
					query.UpdateJSON(filename, jsonData)
				}
			case 8:
				if jsonData == nil {
					fmt.Println("Сначала загрузите данные")
					continue
				} else {
					fmt.Println("Введите имя файла:")
					filename := utils.ReadString()
					query.AppendJSON(filename, jsonData)
				}
			}
		} else if commandNum < 15 {
			res := query.ToSQL(db, commandNum)
			if res != nil {
				utils.PrintRows(res)
			}
		} else {
			fmt.Println("Неверная команда")
			continue
		}
	}
}
