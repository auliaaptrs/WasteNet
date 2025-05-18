package domain

import (
	"time"

	"gorm.io/gorm"
)

// Users represents the user entity
type Nasabah struct {
	UserID       string         `gorm:"type:char(50);primaryKey" json:"user_id"`
	Institusi    string         `gorm:"type:varchar(255);not null;default:mandiri" json:"institusi"`
	Nama         string         `gorm:"type:varchar(255);not null" json:"nama"`
	Telepon      string         `gorm:"type:varchar(15);not null" json:"telepon"`
	Alamat       string         `gorm:"type:varchar(255);not null" json:"alamat"`
	Kelurahan    string         `gorm:"type:varchar(255);not null" json:"kelurahan"`
	Kecamatan    string         `gorm:"type:varchar(255);not null" json:"kecamatan"`
	Kota         string         `gorm:"type:varchar(255);not null" json:"kota"`
	Provinsi     string         `gorm:"type:varchar(255);not null" json:"provinsi"`
	Tabungan     int            `gorm:"type:int;not null;default:0" json:"tabungan"`
	BankSampahID *string        `gorm:"type:char(50)" json:"bank_sampah_id"`
	BankSampah   BankSampah     `gorm:"foreignKey:BankSampahID;constraint:OnUpdate:CASCADE,OnDelete:SET NULL" json:"bank_sampah"`
	CreatedAt    time.Time      `json:"created_at"`
	UpdatedAt    time.Time      `json:"updated_at"`
	DeletedAt    gorm.DeletedAt `gorm:"index" json:"-"`
}

type NasabahRepository interface {
	CreateNasabah(Nasabah Nasabah) (Nasabah, error)
	GetNasabahByID(userID string) (Nasabah, error)
	UpdateNasabah(userID string, Nasabah Nasabah) (Nasabah, error)
	UpdateTabungan(userID string, tabungan int) error
	DeleteNasabah(userID string) error
	UpdateBankSampahNasabah(userID string, bankSampahID string) error
	CountNasabahinKelurahan(jenis string, provinsi string, kabupaten string, kecamatan string, kelurahan string) (int, error)
	CountNasabahinKecamatan(jenis string, provinsi string, kabupaten string, kecamatan string) (int, error)
	CountNasabahinKabupaten(jenis string, provinsi string, kabupaten string) (int, error)
	CountNasabahinProvinsi(jenis string, provinsi string) (int, error)
	CountNasabah(jenis string) (int, error)
}
