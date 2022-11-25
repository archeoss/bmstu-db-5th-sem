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

func GetCommand(command int) string {
	if command < 0 || command >= len(QUERY) {
		return "RAISE NOTICE 'Incorrect command';"
	}

	return QUERY[command]
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
