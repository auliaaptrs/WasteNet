package domain

import (
	"time"

	"gorm.io/gorm"
)

// Users represents the user entity
type BankSampah struct {
	BankID          string `gorm:"type:char(50);primaryKey" json:"bank_id"`
	NamaBank        string `gorm:"type:varchar(255);not null" json:"nama_bank"`
	NamaPJ          string `gorm:"type:varchar(255);not null" json:"nama_pj"`
	Telepon         string `gorm:"type:varchar(15);not null" json:"telepon"`
	Alamat          string `gorm:"type:varchar(255);not null" json:"alamat"`
	Kelurahan       string `gorm:"type:varchar(255);not null" json:"kelurahan"`
	Kecamatan       string `gorm:"type:varchar(255);not null" json:"kecamatan"`
	Kota            string `gorm:"type:varchar(255);not null" json:"kota"`
	Provinsi        string `gorm:"type:varchar(255);not null" json:"provinsi"`
	Tabungan        int    `gorm:"type:int;not null;default:0" json:"tabungan"`
	Kapasitas       int    `gorm:"type:int;not null;" json:"kapasitas"`
	SampahTersimpan int    `gorm:"type:int;not null;default:0" json:"sampah_tersimpan"`
	Overload        bool   `gorm:"type:boolean;default:false" json:"overload"`

	BankIndukID *string      `gorm:"type:char(50);index" json:"bank_induk_id,omitempty"`
	BankInduk   *BankSampah  `gorm:"foreignKey:BankIndukID" json:"bank_induk,omitempty"`
	UnitBanks   []BankSampah `gorm:"foreignKey:BankIndukID" json:"unit_banks,omitempty"`

	Nasabahs []Nasabah `gorm:"foreignKey:BankSampahID" json:"nasabahs"`

	CreatedAt time.Time      `json:"created_at"`
	UpdatedAt time.Time      `json:"updated_at"`
	DeletedAt gorm.DeletedAt `gorm:"index" json:"-"`
}

type BankSampahRepository interface {
	CreateBankSampah(BankSampah BankSampah) (BankSampah, error)
	GetBankSampahByID(userID string) (BankSampah, error)
	UpdateBankSampah(userID string, BankSampah BankSampah) (BankSampah, error)
	UpdateTabungan(userID string, tabungan int) error
	UpdateSampahTersimpan(userID string, sampahTersimpan int) error
	DeleteBankSampah(userID string) error
	GetBankSampahRecomByKelurahan(kelurahan string) (BankSampah, error)
	GetBankSampahRecomByKecamatan(kelurahan string) (BankSampah, error)
	GetBankSampahRecomByKota(kota string) (BankSampah, error)
	GetAllNasabahs(bankSampahID string) ([]Nasabah, error)
	GetTotalTabunganNasabah(bankSampahID string) (int, error)
	GetUnitBanksByIndukID(bankIndukID string) ([]BankSampah, error)
	AssignUnitToInduk(unitID, indukID string) error
	GetBankWithInduk(bankID string) (BankSampah, error)
	UpdateOverload(bankID string, status int) error
	CountBankSampahinKelurahan(jenis string, provinsi string, kabupaten string, kecamatan string, kelurahan string) (int, error)
	CountBankSampahinKecamatan(jenis string, provinsi string, kabupaten string, kecamatan string) (int, error)
	CountBankSampahinKabupaten(jenis string, provinsi string, kabupaten string) (int, error)
	CountBankSampahinProvinsi(jenis string, provinsi string) (int, error)
	CountBankSampah(jenis string) (int, error)
}
