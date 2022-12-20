package utils

import (
	"database/sql"
	"fmt"
)

func PrintMenu() {
	for _, s := range DESC {
		fmt.Println(s)
	}
}

func GetCommandNumber() int {
	var command int
	fmt.Print("Введите команду: ")
	fmt.Println()
	_, err := fmt.Scan(&command)
	if err != nil {
		print("Error happened while scanning for command;")
	}

	return command
}

func PrintRows(rows *sql.Rows) {
	cols, _ := rows.Columns()
	vals := make([]interface{}, len(cols))
	for i := range cols {
		vals[i] = new(interface{})
	}
	for rows.Next() {
		rows.Scan(vals...)
		for _, v := range vals {
			fmt.Printf("%v ", *v.(*interface{}))
		}
		fmt.Println()
	}
}

func RowsToString(rows *sql.Rows) string {
	cols, _ := rows.Columns()
	vals := make([]interface{}, len(cols))
	var res string
	for i := range cols {
		vals[i] = new(interface{})
	}
	for rows.Next() {
		rows.Scan(vals...)
		for _, v := range vals {
			res += fmt.Sprintf("%v ", *v.(*interface{}))
		}
		res += "\n"
	}

	return res
}
