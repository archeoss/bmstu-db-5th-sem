package main

import (
	"encoding/csv"
	"encoding/json"
	"fmt"
	"math/rand"
	"os"
	"strconv"
	"strings"
	"time"
)

type Weapons struct {
	//gorm.Model
	ID             int `gorm:"column:id;primaryKey"`
	Name           string
	Classification string
	Caliber        string
	Status         string
	Produced       string
	LastCheck      string
}

var weapom_names = [...]string{
	"AK-74",
	"M4A1",
	"MP5",
	"MP7",
	"MP9",
	"FAL",
	"FN SCAR",
	"FN F2000",
	"P90",
	"UMP45",
	"UMP9",
	"PP-19",
	"PP-2000",
	"SAIGA-12",
}

var STATUS = [...]string{
	"Missing",
	"In Stock",
	"On Maintenance",
	"In Active Zone",
	"Non-functional",
}

const FIELDS = 10

func genDate() string {
	return strconv.Itoa(rand.Intn(20)+2000) + "-" + strconv.Itoa(rand.Intn(12)+1) + "-" + strconv.Itoa(rand.Intn(28)+1)
}

func maxDate(a, b string) string {
	date1 := strings.Split(a, "-")
	date2 := strings.Split(b, "-")
	for i := 0; i < len(date1); i++ {
		d1, err1 := strconv.Atoi(date1[i])
		d2, err2 := strconv.Atoi(date2[i])
		if err1 != nil || err2 != nil {
			panic("Error in minDate")
		}
		if d1 > d2 {
			return a
		} else if d1 < d2 {
			return b
		}
	}

	return a
}

func minDate(a, b string) string {
	date1 := strings.Split(a, "-")
	date2 := strings.Split(b, "-")
	for i := 0; i < len(date1); i++ {
		d1, err1 := strconv.Atoi(date1[i])
		d2, err2 := strconv.Atoi(date2[i])
		if err1 != nil || err2 != nil {
			panic("Error in minDate")
		}
		if d1 < d2 {
			return a
		} else if d1 > d2 {
			return b
		}
	}

	return a
}

func GenRandomWeapons() []byte {
	marshal := []byte("[")
	var err error
	weaponsFile, err := os.Open("weapons.csv")
	misc := STATUS
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
	csvReader := csv.NewReader(weaponsFile)
	name, err := csvReader.Read()
	class, err := csvReader.Read()
	caliber, err := csvReader.Read()
	weaponsFile.Close()

	for i := 0; i < FIELDS; i++ {
		i_weapon := rand.Intn(len(name))
		i_misc := rand.Intn(len(misc))
		date1, date2 := genDate(), genDate()
		weapon := Weapons{
			//ID:             i,
			Name:           name[i_weapon],
			Classification: class[i_weapon],
			Caliber:        caliber[i_weapon],
			Status:         misc[i_misc],
			Produced:       minDate(date1, date2),
			LastCheck:      maxDate(date1, date2),
		}
		var m []byte
		m, err = json.Marshal(weapon)
		if err != nil {
			return []byte{}
		}
		marshal = append(marshal, m...)
		if i < FIELDS - 1 {
			marshal = append(marshal, []byte(",\n")...)
		}
	}
	marshal = append(marshal, []byte("]\n")...)

	return marshal 
}

func main() {
	file_id := 0
	table := "weapons"
	for {
		var t = time.Now()
		file, err := os.Create(fmt.Sprintf("/opt/nifi/tmp/%d_%s_%s.json", file_id, table, t))
		if err != nil {
			return
		}
		_, err = file.Write(GenRandomWeapons())
		if err != nil {
			return
		}
		time.Sleep(20 * time.Second)
	}
}
