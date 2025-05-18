package repository

import (
	"wastetrack/UserService/domain"

	"gorm.io/gorm"
)

type BankSampahRepository struct {
	DB *gorm.DB
}

var _ domain.BankSampahRepository = (*BankSampahRepository)(nil)

func (r *BankSampahRepository) CreateBankSampah(BankSampah domain.BankSampah) (domain.BankSampah, error) {
	if err := r.DB.Model(&domain.BankSampah{}).
		Create(&BankSampah).Error; err != nil {
		return domain.BankSampah{}, err
	}
	return BankSampah, nil
}

func (r *BankSampahRepository) GetBankSampahByID(bankID string) (domain.BankSampah, error) {
	var BankSampah domain.BankSampah
	if err := r.DB.Model(&domain.BankSampah{}).
		Where("bank_id = ?", bankID).
		First(&BankSampah).Error; err != nil {
		return domain.BankSampah{}, err
	}
	return BankSampah, nil
}

func (r *BankSampahRepository) UpdateBankSampah(bankID string, BankSampah domain.BankSampah) (domain.BankSampah, error) {
	BankSampah.BankID = bankID
	if err := r.DB.Model(&domain.BankSampah{}).
		Where("bank_id = ?", bankID).
		Updates(BankSampah).Error; err != nil {
		return domain.BankSampah{}, err
	}
	return BankSampah, nil
}

func (r *BankSampahRepository) UpdateTabungan(bankID string, tabungan int) error {
	if err := r.DB.Model(&domain.BankSampah{}).
		Where("bank_id = ?", bankID).
		Update("tabungan", tabungan).Error; err != nil {
		return err
	}
	return nil
}

func (r *BankSampahRepository) UpdateSampahTersimpan(bankID string, sampahTersimpan int) error {
	if err := r.DB.Model(&domain.BankSampah{}).
		Where("bank_id = ?", bankID).
		Update("sampah_tersimpan", sampahTersimpan).Error; err != nil {
		return err
	}
	return nil
}

func (r *BankSampahRepository) UpdateOverload(bankID string, status int) error {
	if err := r.DB.Model(&domain.BankSampah{}).
		Where("bank_id = ?", bankID).
		Update("overload", status).Error; err != nil {
		return err
	}
	return nil
}

func (r *BankSampahRepository) DeleteBankSampah(bankID string) error {
	if err := r.DB.Model(&domain.BankSampah{}).
		Where("bank_id = ?", bankID).
		Delete(&domain.BankSampah{}).Error; err != nil {
		return err
	}
	return nil
}

func (r *BankSampahRepository) GetBankSampahRecomByKelurahan(kelurahan string) (domain.BankSampah, error) {
	var BankSampah domain.BankSampah
	if err := r.DB.Model(&domain.BankSampah{}).
		Where("kelurahan = ? AND overload = ?", kelurahan, false).
		First(&BankSampah).Error; err != nil {
		return domain.BankSampah{}, err
	}
	return BankSampah, nil
}

func (r *BankSampahRepository) GetBankSampahRecomByKecamatan(kecamatan string) (domain.BankSampah, error) {
	var BankSampah domain.BankSampah
	if err := r.DB.Model(&domain.BankSampah{}).
		Where("kecamatan = ? AND overload = ?", kecamatan, false).
		First(&BankSampah).Error; err != nil {
		return domain.BankSampah{}, err
	}
	return BankSampah, nil
}

func (r *BankSampahRepository) GetBankSampahRecomByKota(kota string) (domain.BankSampah, error) {
	var BankSampah domain.BankSampah
	if err := r.DB.Model(&domain.BankSampah{}).
		Where("kota = ? AND overload = ?", kota, false).
		First(&BankSampah).Error; err != nil {
		return domain.BankSampah{}, err
	}
	return BankSampah, nil
}

func (r *BankSampahRepository) GetAllNasabahs(bankSampahID string) ([]domain.Nasabah, error) {
	var BankSampah domain.BankSampah

	if err := r.DB.Preload("Nasabahs").
		First(&BankSampah, "bank_id = ?", bankSampahID).Error; err != nil {
		return nil, err
	}

	return BankSampah.Nasabahs, nil
}

func (r *BankSampahRepository) GetTotalTabunganNasabah(bankSampahID string) (int, error) {
	var BankSampah domain.BankSampah
	var TotalTabunganNasabah int
	if err := r.DB.Preload("Nasabahs").First(&BankSampah, "bank_id = ?", bankSampahID).Error; err != nil {
		return 0, err
	}

	for _, nasabah := range BankSampah.Nasabahs {
		TotalTabunganNasabah += nasabah.Tabungan
	}
	return TotalTabunganNasabah, nil
}

func (r *BankSampahRepository) GetUnitBanksByIndukID(bankIndukID string) ([]domain.BankSampah, error) {
	var units []domain.BankSampah
	err := r.DB.
		Where("bank_induk_id = ?", bankIndukID).
		Find(&units).Error
	return units, err
}

func (r *BankSampahRepository) AssignUnitToInduk(unitID, indukID string) error {
	return r.DB.Model(&domain.BankSampah{}).
		Where("bank_id = ?", unitID).
		Update("bank_induk_id", indukID).Error
}

func (r *BankSampahRepository) GetBankWithInduk(bankID string) (domain.BankSampah, error) {
	var bank domain.BankSampah
	err := r.DB.Preload("BankInduk").
		Where("bank_id = ?", bankID).
		First(&bank).Error
	return bank, err
}

func (r *BankSampahRepository) CountBankSampah(jenis string) (int, error) {
	var count int64
	query := r.DB.Model(&domain.BankSampah{})

	if jenis == "unit" {
		query = query.Where("bank_id LIKE ?", "BNKU%")
	} else if jenis == "induk" {
		query = query.Where("bank_id LIKE ?", "BNKI%")
	}

	err := query.Count(&count).Error
	if err != nil {
		return 0, err
	}

	return int(count), nil
}

func (r *BankSampahRepository) CountBankSampahinProvinsi(jenis string, provinsi string) (int, error) {
	var count int64
	query := r.DB.Model(&domain.BankSampah{})

	if jenis == "unit" {
		query = query.Where("bank_id LIKE ?", "BNKU%")
	} else if jenis == "induk" {
		query = query.Where("bank_id LIKE ?", "BNKI%")
	}

	query = query.Where("provinsi = ?", provinsi)

	err := query.Count(&count).Error
	if err != nil {
		return 0, err
	}

	return int(count), nil
}

func (r *BankSampahRepository) CountBankSampahinKabupaten(jenis string, provinsi string, kabupaten string) (int, error) {
	var count int64
	query := r.DB.Model(&domain.BankSampah{})

	if jenis == "unit" {
		query = query.Where("bank_id LIKE ?", "BNKU%")
	} else if jenis == "induk" {
		query = query.Where("bank_id LIKE ?", "BNKI%")
	}

	query = query.Where("provinsi = ?", provinsi)
	query = query.Where("kota = ?", kabupaten)

	err := query.Count(&count).Error
	if err != nil {
		return 0, err
	}

	return int(count), nil
}

func (r *BankSampahRepository) CountBankSampahinKecamatan(jenis string, provinsi string, kabupaten string, kecamatan string) (int, error) {
	var count int64
	query := r.DB.Model(&domain.BankSampah{})

	if jenis == "unit" {
		query = query.Where("bank_id LIKE ?", "BNKU%")
	} else if jenis == "induk" {
		query = query.Where("bank_id LIKE ?", "BNKI%")
	}

	query = query.Where("provinsi = ?", provinsi)
	query = query.Where("kota = ?", kabupaten)
	query = query.Where("kecamatan = ?", kecamatan)

	err := query.Count(&count).Error
	if err != nil {
		return 0, err
	}

	return int(count), nil
}

func (r *BankSampahRepository) CountBankSampahinKelurahan(jenis string, provinsi string, kabupaten string, kecamatan string, kelurahan string) (int, error) {
	var count int64
	query := r.DB.Model(&domain.BankSampah{})

	if jenis == "unit" {
		query = query.Where("bank_id LIKE ?", "BNKU%")
	} else if jenis == "induk" {
		query = query.Where("bank_id LIKE ?", "BNKI%")
	}

	query = query.Where("provinsi = ?", provinsi)
	query = query.Where("kota = ?", kabupaten)
	query = query.Where("kecamatan = ?", kecamatan)
	query = query.Where("kelurahan = ?", kelurahan)

	err := query.Count(&count).Error
	if err != nil {
		return 0, err
	}

	return int(count), nil
}
