package repository

import (
	"wastetrack/TransaksiService/domain"

	"gorm.io/gorm"
)

type TransaksiLainRepository struct {
	DB *gorm.DB
}

var _ domain.TransaksiLainRepository = (*TransaksiLainRepository)(nil)

func (r *TransaksiLainRepository) AddTransaksiLain(TransaksiLain domain.TransaksiLain) (domain.TransaksiLain, error) {
	if err := r.DB.Model(&domain.TransaksiLain{}).
		Create(&TransaksiLain).Error; err != nil {
		return domain.TransaksiLain{}, err
	}
	return TransaksiLain, nil
}

func (r *TransaksiLainRepository) GetPemasukanLainByBankSampah(bankID string) ([]domain.SummaryTransaksi, error) {
	var summaries []domain.SummaryTransaksi

	err := r.DB.
		Model(&domain.TransaksiLain{}).
		Select("DATE(created_at) as tanggal, deskripsi, nominal").
		Where("bank_id = ? AND kategori = ?", bankID, "Pemasukan").
		Order("tanggal DESC").
		Scan(&summaries).Error

	if err != nil {
		return nil, err
	}

	return summaries, nil
}

func (r *TransaksiLainRepository) GetPengeluaranLainByBankSampah(bankID string) ([]domain.SummaryTransaksi, error) {
	var summaries []domain.SummaryTransaksi

	err := r.DB.
		Model(&domain.TransaksiLain{}).
		Select("DATE(created_at) as tanggal, deskripsi, nominal").
		Where("bank_id = ? AND kategori = ?", bankID, "Pengeluaran").
		Order("tanggal DESC").
		Scan(&summaries).Error

	if err != nil {
		return nil, err
	}

	return summaries, nil
}
