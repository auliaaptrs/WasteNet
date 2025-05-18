package repository

import (
	"wastetrack/ProductService/domain"

	"gorm.io/gorm"
)

type ProductRepository struct {
	DB *gorm.DB
}

var _ domain.ProductRepository = (*ProductRepository)(nil)

func (r *ProductRepository) GetAllProducts() ([]domain.Product, error) {
	var products []domain.Product

	if err := r.DB.Find(&products).Error; err != nil {
		return nil, err
	}

	return products, nil
}

func (r *ProductRepository) AddProductPrice(productID uint, bankID string, harga int) error {
	if err := r.DB.Model(&domain.HargaSampah{}).
		Create(&domain.HargaSampah{
			ProductID:    productID,
			BankSampahID: bankID,
			Harga:        harga,
		}).Error; err != nil {
		return err
	}
	return nil
}

func (r *ProductRepository) RemoveProductPrice(id uint) error {
	if err := r.DB.Model(&domain.HargaSampah{}).
		Where("id = ?", id).
		Delete(&domain.HargaSampah{}).Error; err != nil {
		return err
	}
	return nil
}

func (r *ProductRepository) GetProductByID(id uint) (domain.Product, error) {
	var Product domain.Product
	if err := r.DB.Model(&domain.Product{}).
		Where("id = ?", id).
		First(&Product).Error; err != nil {
		return domain.Product{}, err
	}
	return Product, nil
}

func (r *ProductRepository) CheckHargaSampahExists(productID uint, bankID string) (bool, error) {
	var count int64
	err := r.DB.Model(&domain.HargaSampah{}).
		Where("product_id = ? AND bank_sampah_id = ?", productID, bankID).
		Count(&count).Error
	if err != nil {
		return false, err
	}
	return count > 0, nil
}

func (r *ProductRepository) UpdateHarga(productID uint, bankID string, harga int) error {
	if err := r.DB.Model(&domain.HargaSampah{}).
		Where("product_id = ? AND bank_sampah_id = ?", productID, bankID).
		Update("harga", harga).Error; err != nil {
		return err
	}
	return nil
}

func (r *ProductRepository) DeleteHarga(productID uint, bankID string) error {
	if err := r.DB.Model(&domain.HargaSampah{}).
		Where("product_id = ? AND bank_sampah_id = ?", productID, bankID).
		Delete(&domain.HargaSampah{}).Error; err != nil {
		return err
	}
	return nil
}

func (r *ProductRepository) GetHargaSampahByBankID(bankID string) ([]domain.HargaSampah, error) {
	var hargaSampah []domain.HargaSampah
	err := r.DB.
		Preload("Product").
		Where("bank_sampah_id = ?", bankID).
		Find(&hargaSampah).Error

	return hargaSampah, err
}
