package domain

import (
	"gorm.io/gorm"
)

type TransaksiLain struct {
	gorm.Model
	BankID    string `gorm:"type:char(50)" json:"id_bank"`
	Kategori  string `gorm:"type:char(50)" json:"kategori"`
	Deskripsi string `gorm:"type:char(50)" json:"deskripsi"`
	Nominal   int    `gorm:"type:int" json:"nominal"`
}

type TransaksiLainRepository interface {
	AddTransaksiLain(TransaksiLain TransaksiLain) (TransaksiLain, error)
	GetPemasukanLainByBankSampah(bankID string) ([]SummaryTransaksi, error)
	GetPengeluaranLainByBankSampah(bankID string) ([]SummaryTransaksi, error)
}
