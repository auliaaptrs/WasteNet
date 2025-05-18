package domain

import (
	"gorm.io/gorm"
)

type SampahMasuk struct {
	gorm.Model
	NasabahID string  `gorm:"type:char(50)" json:"id_nasabah"`
	BankID    string  `gorm:"type:char(50)" json:"id_bank"`
	Produk    string  `gorm:"type:char(50)" json:"produk"`
	Brand     string  `gorm:"type:char(50)" json:"brand"`
	Berat     float64 `gorm:"type:float" json:"berat"`
	Harga     int     `gorm:"type:int" json:"harga"`
}

type SampahMasukRepository interface {
	AddTransaksiSampahMasuk(SampahMasuk SampahMasuk) (SampahMasuk, error)
	GetSampahMasukByBankSampah(bankID string) ([]SummaryTransaksi, error)
	GetSampahMasukByNasabah(nasabahID string) ([]SummaryTransaksi, error)
	GetSampahMasukByDate(bankID string, nasabahID string, date string) ([]SampahMasuk, error)
	GetBeratSampahByBankSampah(bankID string, month string) ([]SummaryBeratSampah, error)
	GetBeratSampahByNasabah(nasabahID string, month string) ([]SummaryBeratSampah, error)
}
