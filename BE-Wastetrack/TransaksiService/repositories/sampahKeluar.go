package repository

import (
	"wastetrack/TransaksiService/domain"

	"gorm.io/gorm"
)

type SampahKeluarRepository struct {
	DB *gorm.DB
}

var _ domain.SampahKeluarRepository = (*SampahKeluarRepository)(nil)

func (r *SampahKeluarRepository) AddTransaksiSampahKeluar(SampahKeluar domain.SampahKeluar) (domain.SampahKeluar, error) {
	if err := r.DB.Model(&domain.SampahKeluar{}).
		Create(&SampahKeluar).Error; err != nil {
		return domain.SampahKeluar{}, err
	}
	return SampahKeluar, nil
}

func (r *SampahKeluarRepository) GetSampahKeluarByBankSampah(bankID string) ([]domain.SummaryTransaksi, error) {
	var summaries []domain.SummaryTransaksi

	err := r.DB.
		Model(&domain.SampahKeluar{}).
		Select("DATE(created_at) as tanggal, SUM(harga) as nominal").
		Where("bank_id = ?", bankID).
		Group("DATE(created_at)").
		Order("tanggal DESC").
		Scan(&summaries).Error

	if err != nil {
		return nil, err
	}

	return summaries, nil
}

func (r *SampahKeluarRepository) GetSampahKeluarByDate(bankID string, date string) ([]domain.SampahKeluar, error) {
	var sampahKeluar []domain.SampahKeluar

	err := r.DB.
		Model(&domain.SampahKeluar{}).
		Where("bank_id = ? AND DATE(created_at) = ?", bankID, date).
		Find(&sampahKeluar).Error

	if err != nil {
		return nil, err
	}

	return sampahKeluar, nil
}

func (r *SampahKeluarRepository) GetBeratSampahByBankSampah(bankID string, month string) ([]domain.SummaryBeratSampah, error) {
	var summaries []domain.SummaryBeratSampah

	err := r.DB.
		Model(&domain.SampahKeluar{}).
		Select("produk, SUM(berat) as total_berat").
		Where("bank_id = ? AND DATE_FORMAT(created_at, '%Y-%m') = ?", bankID, month).
		Group("produk").
		Order("produk ASC").
		Scan(&summaries).Error

	if err != nil {
		return nil, err
	}

	return summaries, nil
}
