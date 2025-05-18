package usecases

import (
	"errors"
	"wastetrack/ProductService/domain"
)

// ProductUsecase contains methods related to Products
type ProductUsecase struct {
	ProductRepository domain.ProductRepository
}

func (uc *ProductUsecase) GetAllProducts() ([]domain.Product, error) {
	_, err := uc.ProductRepository.GetAllProducts()
	if err != nil {
		return nil, errors.New("product not found")
	}

	return uc.ProductRepository.GetAllProducts()
}

func (uc *ProductUsecase) AddProductPrice(productID uint, bankID string, harga int) error {
	_, err := uc.ProductRepository.GetProductByID(productID)
	if err != nil {
		return err
	}

	exists, err := uc.ProductRepository.CheckHargaSampahExists(productID, bankID)
	if err != nil {
		return err
	}
	if exists {
		return errors.New("product already set for this bank")
	}

	if err := uc.ProductRepository.AddProductPrice(productID, bankID, harga); err != nil {
		return err
	}

	return nil
}

func (uc *ProductUsecase) UpdateHarga(productID uint, bankID string, harga int) error {
	_, err := uc.ProductRepository.CheckHargaSampahExists(productID, bankID)
	if err != nil {
		return errors.New("HargaSampah not found")
	}

	if err := uc.ProductRepository.UpdateHarga(productID, bankID, harga); err != nil {
		return errors.New("failed to update price")
	}

	return nil
}

func (uc *ProductUsecase) DeleteHarga(productID uint, bankID string) error {
	_, err := uc.ProductRepository.CheckHargaSampahExists(productID, bankID)
	if err != nil {
		return errors.New("HargaSampah not found")
	}

	return uc.ProductRepository.DeleteHarga(productID, bankID)
}

func (uc *ProductUsecase) GetHargaSampahByBankID(bank_id string) ([]domain.HargaSampah, error) {
	hargaSampah, err := uc.ProductRepository.GetHargaSampahByBankID(bank_id)
	if err != nil {
		return nil, errors.New("there is no harga sampah")
	}

	return hargaSampah, nil
}
