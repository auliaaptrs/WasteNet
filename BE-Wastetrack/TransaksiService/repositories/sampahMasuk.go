package repository

import (
	"wastetrack/TransaksiService/domain"

	"gorm.io/gorm"
)

type SampahMasukRepository struct {
	DB *gorm.DB
}

var _ domain.SampahMasukRepository = (*SampahMasukRepository)(nil)

func (r *SampahMasukRepository) AddTransaksiSampahMasuk(SampahMasuk domain.SampahMasuk) (domain.SampahMasuk, error) {
	if err := r.DB.Model(&domain.SampahMasuk{}).
		Create(&SampahMasuk).Error; err != nil {
		return domain.SampahMasuk{}, err
	}
	return SampahMasuk, nil
}

func (r *SampahMasukRepository) GetSampahMasukByBankSampah(bankID string) ([]domain.SummaryTransaksi, error) {
	var summaries []domain.SummaryTransaksi

	err := r.DB.
		Model(&domain.SampahMasuk{}).
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

func (r *SampahMasukRepository) GetSampahMasukByNasabah(nasabahID string) ([]domain.SummaryTransaksi, error) {
	var summaries []domain.SummaryTransaksi

	err := r.DB.
		Model(&domain.SampahMasuk{}).
		Select("DATE(created_at) as tanggal, SUM(harga) as nominal").
		Where("nasabah_id = ?", nasabahID).
		Group("DATE(created_at)").
		Order("tanggal DESC").
		Scan(&summaries).Error

	if err != nil {
		return nil, err
	}

	return summaries, nil
}

func (r *SampahMasukRepository) GetSampahMasukByDate(bankID string, nasabahID string, date string) ([]domain.SampahMasuk, error) {
	var sampahMasuk []domain.SampahMasuk

	err := r.DB.
		Model(&domain.SampahMasuk{}).
		Where("bank_id = ? AND nasabah_id = ? AND DATE(created_at) = ?", bankID, nasabahID, date).
		Find(&sampahMasuk).Error

	if err != nil {
		return nil, err
	}

	return sampahMasuk, nil
}

func (r *SampahMasukRepository) GetBeratSampahByBankSampah(bankID string, month string) ([]domain.SummaryBeratSampah, error) {
	var summaries []domain.SummaryBeratSampah

	err := r.DB.
		Model(&domain.SampahMasuk{}).
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

func (r *SampahMasukRepository) GetBeratSampahByNasabah(nasabahID string, month string) ([]domain.SummaryBeratSampah, error) {
	var summaries []domain.SummaryBeratSampah

	err := r.DB.
		Model(&domain.SampahMasuk{}).
		Select("produk, SUM(berat) as total_berat").
		Where("nasabah_id = ? AND DATE_FORMAT(created_at, '%Y-%m') = ?", nasabahID, month).
		Group("produk").
		Order("produk ASC").
		Scan(&summaries).Error

	if err != nil {
		return nil, err
	}

	return summaries, nil
}
