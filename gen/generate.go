package main

import (
	"encoding/csv"
	"fmt"
	"math/rand"
	"os"
	"strconv"
	"strings"
	"time"
)

const FIELDS = 10000

func genDate() string {
	return strconv.Itoa(rand.Intn(20)+2000) + "-" + strconv.Itoa(rand.Intn(12)+1) + "-" + strconv.Itoa(rand.Intn(28)+1)
}

func genSlice(n int) []int {
	s := make([]int, n)
	for i := range s {
		s[i] = i + 1
	}

	return s
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

func generateDB() {
	soldiers_list := make([]string, FIELDS)
	squads := genSlice(FIELDS / 10)
	nums_Weapon := genSlice(FIELDS)
	nums_Vehicle := genSlice(FIELDS)
	nums_Ammo := genSlice(FIELDS)

	rand.Seed(time.Now().UnixNano())
	rand.Shuffle(len(nums_Weapon), func(i, j int) { nums_Weapon[i], nums_Weapon[j] = nums_Weapon[j], nums_Weapon[i] })
	rand.Shuffle(len(nums_Ammo), func(i, j int) { nums_Ammo[i], nums_Ammo[j] = nums_Ammo[j], nums_Ammo[i] })
	rand.Shuffle(len(nums_Vehicle), func(i, j int) { nums_Vehicle[i], nums_Vehicle[j] = nums_Vehicle[j], nums_Vehicle[i] })
	rand.Shuffle(len(squads), func(i, j int) { squads[i], squads[j] = squads[j], squads[i] })

	soldiersFile, err := os.Open("assets/soldiers.csv")
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}

	csvReader := csv.NewReader(soldiersFile)
	firstName, err := csvReader.Read()
	lastName, err := csvReader.Read()
	rank, err := csvReader.Read()
	soldiersFile.Close()
	fmt.Println(minDate("2017-12-07", "2017-7-08"))
	f, err := os.Create("../queries/lab_01/dbdata/soldiers.csv")
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
	csvWriter := csv.NewWriter(f)
	//csvWriter.Write([]string{""})
	for i := 0; i < FIELDS; i++ {
		i_firstName := rand.Intn(len(firstName))
		i_lastName := rand.Intn(len(lastName))
		i_rank := rand.Intn(len(rank))
		soldiers_list[i] = lastName[i_lastName]
		date1, date2 := genDate(), genDate()
		record := []string{ /*strconv.Itoa(i + 1), */ firstName[i_firstName], lastName[i_lastName], rank[i_rank], strconv.Itoa(rand.Intn(25) + 20), strconv.Itoa(rand.Intn(1000) + 1000), minDate(date1, date2), maxDate(date1, date2), strconv.Itoa(nums_Weapon[i]), strconv.Itoa(nums_Ammo[i]), strconv.Itoa(nums_Vehicle[i]), strconv.Itoa(squads[i%(FIELDS/10)])}
		csvWriter.Write(record)
		csvWriter.Flush()
	}

	miscFile, err := os.Open("assets/mis.csv")
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
	csvReader = csv.NewReader(miscFile)
	misc, err := csvReader.Read()
	miscFile.Close()

	ammunitionFile, err := os.Open("assets/ammunition.csv")
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}

	csvReader = csv.NewReader(ammunitionFile)
	ammo, err := csvReader.Read()
	calibers, err := csvReader.Read()
	types, err := csvReader.Read()
	ammunitionFile.Close()

	f, err = os.Create("../queries/lab_01/dbdata/ammo.csv")
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
	csvWriter = csv.NewWriter(f)
	//csvWriter.Write([]string{""})
	for i := 0; i < FIELDS; i++ {
		i_misc := rand.Intn(len(misc))
		i_ammo := rand.Intn(len(ammo))
		record := []string{ /*strconv.Itoa(i + 1), */ ammo[i_ammo], calibers[i_ammo], types[i_ammo], strconv.Itoa(rand.Intn(5) * 30), misc[i_misc]}
		csvWriter.Write(record)
		csvWriter.Flush()
	}

	weaponsFile, err := os.Open("assets/weapons.csv")
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}

	csvReader = csv.NewReader(weaponsFile)
	name, err := csvReader.Read()
	class, err := csvReader.Read()
	caliber, err := csvReader.Read()
	weaponsFile.Close()

	f, err = os.Create("../queries/lab_01/dbdata/weapons.csv")
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
	csvWriter = csv.NewWriter(f)
	//csvWriter.Write([]string{""})
	for i := 0; i < FIELDS; i++ {
		i_weapon := rand.Intn(len(name))
		i_misc := rand.Intn(len(misc))
		date1, date2 := genDate(), genDate()
		record := []string{ /*strconv.Itoa(i + 1), */ name[i_weapon], class[i_weapon], caliber[i_weapon], misc[i_misc], minDate(date1, date2), maxDate(date1, date2)}
		csvWriter.Write(record)
		csvWriter.Flush()
	}

	vehiclesFile, err := os.Open("assets/vehicles.csv")
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}

	csvReader = csv.NewReader(vehiclesFile)
	vehicles, err := csvReader.Read()
	vehiclesFile.Close()

	f, err = os.Create("../queries/lab_01/dbdata/vehicles.csv")
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
	csvWriter = csv.NewWriter(f)
	//csvWriter.Write([]string{""})

	for i := 0; i < FIELDS; i++ {
		i_vehicles := rand.Intn(len(vehicles))
		i_misc := rand.Intn(len(misc))
		record := []string{ /*strconv.Itoa(i + 1), */ vehicles[i_vehicles], misc[i_misc], strconv.Itoa(rand.Intn(50) + 1), strconv.Itoa(rand.Intn(2)), genDate()}

		csvWriter.Write(record)
		csvWriter.Flush()
	}

	squadsFile, err := os.Open("assets/squads.csv")
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}

	csvReader = csv.NewReader(squadsFile)
	locations, err := csvReader.Read()
	stats, err := csvReader.Read()
	call_signs, err := csvReader.Read()
	weaponsFile.Close()

	f, err = os.Create("../queries/lab_01/dbdata/squads.csv")
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
	csvWriter = csv.NewWriter(f)
	//csvWriter.Write([]string{""})
	for i := 0; i < FIELDS/10; i++ {
		i_loc := rand.Intn(len(locations))
		i_stat := rand.Intn(len(stats))
		i_call := rand.Intn(len(call_signs))
		date1, date2 := genDate(), genDate()
		record := []string{ /*strconv.Itoa(i + 1), */ locations[i_loc], minDate(date1, date2), maxDate(date1, date2), stats[i_stat], strconv.Itoa(rand.Intn(25)), call_signs[i_call]}
		csvWriter.Write(record)
		csvWriter.Flush()
	}
}

func main() {
	generateDB()
}
