package domain

import (
	"gorm.io/gorm"
)

type SampahKeluar struct {
	gorm.Model
	BankID string  `gorm:"type:char(50)" json:"id_bank"`
	Tujuan string  `gorm:"type:char(50)" json:"tujuan"`
	Produk string  `gorm:"type:char(50)" json:"produk"`
	Brand  string  `gorm:"type:char(50)" json:"brand"`
	Berat  float64 `gorm:"type:float" json:"berat"`
	Harga  int     `gorm:"type:int" json:"harga"`
}

type SampahKeluarRepository interface {
	AddTransaksiSampahKeluar(SampahKeluar SampahKeluar) (SampahKeluar, error)
	GetSampahKeluarByBankSampah(bankID string) ([]SummaryTransaksi, error)
	GetSampahKeluarByDate(bankID string, date string) ([]SampahKeluar, error)
	GetBeratSampahByBankSampah(bankID string, month string) ([]SummaryBeratSampah, error)
}
