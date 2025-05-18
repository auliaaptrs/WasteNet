package domain

import "gorm.io/gorm"

// HargaSampah represents the many-to-many relationship between Product and BankSampah
type HargaSampah struct {
	gorm.Model
	ProductID    uint    `gorm:"type:char(50);index" json:"product_id"`
	Product      Product `gorm:"foreignKey:ProductID"`
	BankSampahID string  `gorm:"type:char(50);index" json:"bank_id"`
	Harga        int     `gorm:"int;not null" json:"harga"`
}
