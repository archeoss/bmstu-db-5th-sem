package models

import (
	"time"
)

type Soldiers struct {
	//gorm.Model
	ID            int `gorm:"column:id;primaryKey"`
	FirstName     string
	LastName      string
	Rank          string
	Age           int
	Salary        int
	ArrivalDate   time.Time
	DepartureDate time.Time
	WeaponID      int
	AmmunitionID  int
	VehicleID     int
	SquadID       int
}

type Weapons struct {
	//gorm.Model
	ID             int `gorm:"column:id;primaryKey"`
	Name           string
	Classification string
	Caliber        string
	Status         string
	Produced       time.Time
	LastCheck      time.Time
}

type Ammunition struct {
	//gorm.Model
	ID       int `gorm:"column:id;primaryKey"`
	Name     string
	Caliber  string
	Type     string
	Quantity int
	Status   string
}

type Vehicles struct {
	//gorm.Model
	ID       int `gorm:"column:id;primaryKey"`
	Name     string
	Status   string
	Capacity int
	Armored  bool
	Produced time.Time
}

type Squads struct {
	//gorm.Model
	ID           int `gorm:"column:id;primaryKey"`
	CurLocation  string
	FirstDeploy  time.Time
	LastDeploy   time.Time
	Status       string
	TotalDeploys int
	CallSign     string
}
