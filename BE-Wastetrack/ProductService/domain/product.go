package domain

import (
	"gorm.io/gorm"
)

type Product struct {
	gorm.Model
	NamaProduk   string        `gorm:"type:varchar(255);not null"`
	ImageURL     string        `gorm:"type:varchar(255);not null"`
	HargaSampahs []HargaSampah `gorm:"foreignKey:ProductID"`
}

type ProductRepository interface {
	GetAllProducts() ([]Product, error)
	GetProductByID(id uint) (Product, error)
	AddProductPrice(productID uint, bankID string, harga int) error
	RemoveProductPrice(id uint) error
	CheckHargaSampahExists(productID uint, bankID string) (bool, error)
	UpdateHarga(productID uint, bankID string, harga int) error
	DeleteHarga(productID uint, bankID string) error
	GetHargaSampahByBankID(bankID string) ([]HargaSampah, error)
}
