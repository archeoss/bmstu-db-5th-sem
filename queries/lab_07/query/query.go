package query

import (
	"app/models"
	"database/sql"
	"encoding/json"
	"fmt"
	"gorm.io/gorm"
	"io"
	"log"
	"os"
	"time"
)

type JSON []map[string]interface{}

type DB struct {
	*gorm.DB
}

//type Result interface {
//	[]models.Soldiers | []models.Weapons | []models.Ammunition | []models.Vehicles | []models.Squads
//}

func ToObject(db *gorm.DB, command int) *sql.Rows {
	//result := map[string]models.Soldiers{}
	var result *sql.Rows
	var err error
	var soldiers []models.Soldiers
	var vehicles []models.Vehicles
	var squads []models.Squads
	switch command {
	case 1:
		result, err = db.Find(&soldiers).Select("count(*)").Rows()
	case 2:
		result, err = db.Find(&soldiers).Select("first_name, last_name, call_sign, name, caliber").
			Joins("join (SELECT id, call_sign from military_base.squads) as ics on squad_id = ics.id").
			Joins("join (SELECT id, name, caliber from military_base.weapons) as nc on weapon_id = nc.id").
			Rows()
		//result = reflect.ValueOf(soldiers).Interface().(V)
	case 3:
		result, err = db.Find(&squads, "status LIKE '%Deploy%'").Select("cur_location, status, call_sign").Rows()
	case 4:
		result, err = db.Model(&soldiers).Select("first_name, last_name, rank, arrival_date").Where("arrival_date BETWEEN '2002-01-01' AND '2006-12-31'").Rows()
	case 5:
		result, err = db.Model(&vehicles).Select(" name, count(*) as count, AVG(capacity) as avg").Group("name").Rows()
	}

	if err != nil {
		return nil
	}

	return result
}

// Прочитать данные из JSON-файла
func ReadJSON(filename string) JSON {
	file, err := os.Open(filename)
	if err != nil {
		log.Fatal(err)
	}
	defer file.Close()
	bytes, _ := io.ReadAll(file)
	//decoder := json.NewDecoder(file)
	//err = decoder.Decode(&data)
	//if err != nil {
	//	fmt.Println("test")
	//	log.Fatal(err)
	//}
	var res []map[string]interface{}
	//fmt.Println(string(bytes))
	err = json.Unmarshal([]byte(string(bytes)), &res)

	if err != nil {
		fmt.Println(err)
		return nil
	}
	//fmt.Println(res)

	return res
}

// Обновить даныее в JSON-файле
func UpdateJSON(filename string, data JSON) {
	file, err := os.Create(filename)
	if err != nil {
		log.Fatal(err)
	}
	defer file.Close()
	encoder := json.NewEncoder(file)
	err = encoder.Encode(data)
	if err != nil {
		log.Fatal(err)
	}
}

// Добавить данные в JSON-файл
func AppendJSON(filename string, data JSON) {
	file, err := os.OpenFile(filename, os.O_APPEND|os.O_WRONLY, 0600)
	if err != nil {
		log.Fatal(err)
	}
	defer file.Close()
	encoder := json.NewEncoder(file)
	err = encoder.Encode(data)
	if err != nil {
		log.Fatal(err)
	}
}

func ToSQL(db *gorm.DB, command int) *sql.Rows {
	var soldiers []models.Soldiers
	var vehicles []models.Vehicles
	var result *sql.Rows
	var err error
	switch command {
	// Однотабличный запрос
	case 9:
		result, err = db.Find(&soldiers).Rows()
		if err != nil {
			return nil
		}
	// Многотабличный запрос
	case 10:
		result, err = db.Find(&soldiers).Select("first_name, last_name, call_sign, name, caliber").
			Joins("join (SELECT id, call_sign from military_base.squads) as ics on squad_id = ics.id").
			Joins("join (SELECT id, name, caliber from military_base.weapons) as nc on weapon_id = nc.id").
			Rows()
		if err != nil {
			return nil
		}
	// Запрос на добавление
	case 11:
		result, err = db.Create(&models.Weapons{
			Name:           "Test",
			Classification: "Test",
			Caliber:        "Test",
			Status:         "test",
			Produced:       time.Now(),
			LastCheck:      time.Now(),
		}).Rows()
		fmt.Println(err, "test")
		if err != nil {
			return nil
		}
	// Запрос на удаление
	case 12:
		result, err = db.Delete(&models.Soldiers{}, "first_name = ?", "Adolf").Rows()
		if err != nil {
			return nil
		}
	// Запрос на изменение
	case 13:
		result, err = db.Model(&models.Soldiers{}).Where("id = ?", 2).Update("first_name", "Vasya").Rows()
		if err != nil {
			return nil
		}
	// Запрос используя агрегатные функции
	case 14:
		result, err = db.Model(&vehicles).Select(" name, count(*) as count, AVG(capacity) as avg").Group("name").Rows()
		if err != nil {
			return nil
		}
	}

	return result
}
