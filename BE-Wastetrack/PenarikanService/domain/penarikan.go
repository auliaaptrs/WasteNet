package domain

import (
	"time"

	"gorm.io/gorm"
)

type Penarikan struct {
	gorm.Model
	NasabahID    string    `gorm:"type:char(50)" json:"id_nasabah"`
	BankID       string    `gorm:"type:char(50)" json:"id_bank"`
	NominalUang  float64   `gorm:"type:int" json:"nominal_uang"`
	Metode       string    `gorm:"type:char(50)" json:"metode"`
	Jadwal       time.Time `json:"jadwal"`
	BankRekening string    `gorm:"type:char(50)" json:"bank_rekening"`
	NoRek        string    `gorm:"type:char(50)" json:"norek"`
	Status       string    `gorm:"type:char(50);default:'Requested'" json:"status"`
}

type PenarikanRepository interface {
	AddRequestPenarikan(Penarikan Penarikan) (Penarikan, error)
	GetPenarikanByID(penarikanID uint) (Penarikan, error)
	UpdateStatusPenarikan(penarikanID uint, status string) error
	DonePenarikan(penarikanID uint, status string) error
	GetPenarikanDoneByNasabah(nasabahID string) ([]Penarikan, error)
	GetPenarikanRequestByNasabah(nasabahID string) ([]Penarikan, error)
	GetPenarikanAcceptedByNasabah(nasabahID string) ([]Penarikan, error)
	GetPenarikanDeclineByNasabah(nasabahID string) ([]Penarikan, error)
	GetPenarikanDoneByBankSampah(bankID string) ([]Penarikan, error)
	GetPenarikanRequestByBankSampah(bankID string) ([]Penarikan, error)
	GetPenarikanAcceptedByBankSampah(bankID string) ([]Penarikan, error)
	GetPenarikanDeclineByBankSampah(bankID string) ([]Penarikan, error)
}
