package domain

import (
	"time"

	"gorm.io/gorm"
)

type TPSR struct {
	TPSID           string `gorm:"type:char(50);primaryKey" json:"tps_id"`
	NamaTPS         string `gorm:"type:varchar(255);not null" json:"nama_tps"`
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

	CreatedAt time.Time      `json:"created_at"`
	UpdatedAt time.Time      `json:"updated_at"`
	DeletedAt gorm.DeletedAt `gorm:"index" json:"-"`
}

type TPSRRepository interface {
	CreateTPSR(TPSR TPSR) (TPSR, error)
	GetTPSRByID(userID string) (TPSR, error)
	UpdateTPSR(userID string, TPSR TPSR) (TPSR, error)
	UpdateTabungan(userID string, tabungan int) error
	UpdateSampahTersimpan(userID string, sampahTersimpan int) error
	DeleteTPSR(userID string) error
	UpdateOverload(bankID string, status int) error
	CountTPSRinKelurahan(jenis string, provinsi string, kabupaten string, kecamatan string, kelurahan string) (int, error)
	CountTPSRinKecamatan(jenis string, provinsi string, kabupaten string, kecamatan string) (int, error)
	CountTPSRinKabupaten(jenis string, provinsi string, kabupaten string) (int, error)
	CountTPSRinProvinsi(jenis string, provinsi string) (int, error)
	CountTPSR(jenis string) (int, error)
}
