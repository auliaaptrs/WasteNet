package repository

import (
	"wastetrack/UserService/domain"

	"gorm.io/gorm"
)

type NasabahRepository struct {
	DB *gorm.DB
}

var _ domain.NasabahRepository = (*NasabahRepository)(nil)

func (r *NasabahRepository) CreateNasabah(Nasabah domain.Nasabah) (domain.Nasabah, error) {
	if err := r.DB.Model(&domain.Nasabah{}).
		Create(&Nasabah).Error; err != nil {
		return domain.Nasabah{}, err
	}
	return Nasabah, nil
}

func (r *NasabahRepository) GetNasabahByID(userID string) (domain.Nasabah, error) {
	var nasabah domain.Nasabah
	if err := r.DB.Model(&domain.Nasabah{}).
		Preload("BankSampah").
		Where("user_id = ?", userID).
		First(&nasabah).Error; err != nil {
		return domain.Nasabah{}, err
	}
	return nasabah, nil
}

func (r *NasabahRepository) UpdateNasabah(userID string, Nasabah domain.Nasabah) (domain.Nasabah, error) {
	Nasabah.UserID = userID
	if err := r.DB.Model(&domain.Nasabah{}).
		Where("user_id = ?", userID).
		Updates(Nasabah).Error; err != nil {
		return domain.Nasabah{}, err
	}
	return Nasabah, nil
}

func (r *NasabahRepository) UpdateTabungan(userID string, tabungan int) error {
	if err := r.DB.Model(&domain.Nasabah{}).
		Where("user_id = ?", userID).
		Update("tabungan", tabungan).Error; err != nil {
		return err
	}
	return nil
}

func (r *NasabahRepository) DeleteNasabah(userID string) error {
	if err := r.DB.Model(&domain.Nasabah{}).
		Where("user_id = ?", userID).
		Delete(&domain.Nasabah{}).Error; err != nil {
		return err
	}
	return nil
}

func (r *NasabahRepository) UpdateBankSampahNasabah(userID string, bankSampahID string) error {
	if err := r.DB.Model(&domain.Nasabah{}).
		Where("user_id = ?", userID).
		Update("bank_sampah_id", bankSampahID).Error; err != nil {
		return err
	}

	return nil
}

func (r *NasabahRepository) CountNasabah(jenis string) (int, error) {
	var count int64
	query := r.DB.Model(&domain.Nasabah{})

	if jenis == "mandiri" {
		query = query.Where("user_id LIKE ?", "NSBM%")
	} else if jenis == "institusi" {
		query = query.Where("user_id LIKE ?", "NSBI%")
	} else if jenis == "tpsn" {
		query = query.Where("user_id LIKE ?", "TPSN%")
	} else {
		query = query.Where("user_id NOT LIKE ?", "TPSN%")
	}

	err := query.Count(&count).Error
	if err != nil {
		return 0, err
	}

	return int(count), nil
}

func (r *NasabahRepository) CountNasabahinProvinsi(jenis string, provinsi string) (int, error) {
	var count int64
	query := r.DB.Model(&domain.Nasabah{})

	if jenis == "mandiri" {
		query = query.Where("user_id LIKE ?", "NSBM%")
	} else if jenis == "institusi" {
		query = query.Where("user_id LIKE ?", "NSBI%")
	} else if jenis == "tpsn" {
		query = query.Where("user_id LIKE ?", "TPSN%")
	} else {
		query = query.Where("user_id NOT LIKE ?", "TPSN%")
	}

	query = query.Where("provinsi = ?", provinsi)

	err := query.Count(&count).Error
	if err != nil {
		return 0, err
	}

	return int(count), nil
}

func (r *NasabahRepository) CountNasabahinKabupaten(jenis string, provinsi string, kabupaten string) (int, error) {
	var count int64
	query := r.DB.Model(&domain.Nasabah{})

	if jenis == "mandiri" {
		query = query.Where("user_id LIKE ?", "NSBM%")
	} else if jenis == "institusi" {
		query = query.Where("user_id LIKE ?", "NSBI%")
	} else if jenis == "tpsn" {
		query = query.Where("user_id LIKE ?", "TPSN%")
	} else {
		query = query.Where("user_id NOT LIKE ?", "TPSN%")
	}

	query = query.Where("provinsi = ?", provinsi)
	query = query.Where("kota = ?", kabupaten)

	err := query.Count(&count).Error
	if err != nil {
		return 0, err
	}

	return int(count), nil
}

func (r *NasabahRepository) CountNasabahinKecamatan(jenis string, provinsi string, kabupaten string, kecamatan string) (int, error) {
	var count int64
	query := r.DB.Model(&domain.Nasabah{})

	if jenis == "mandiri" {
		query = query.Where("user_id LIKE ?", "NSBM%")
	} else if jenis == "institusi" {
		query = query.Where("user_id LIKE ?", "NSBI%")
	} else if jenis == "tpsn" {
		query = query.Where("user_id LIKE ?", "TPSN%")
	} else {
		query = query.Where("user_id NOT LIKE ?", "TPSN%")
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

func (r *NasabahRepository) CountNasabahinKelurahan(jenis string, provinsi string, kabupaten string, kecamatan string, kelurahan string) (int, error) {
	var count int64
	query := r.DB.Model(&domain.Nasabah{})

	if jenis == "mandiri" {
		query = query.Where("user_id LIKE ?", "NSBM%")
	} else if jenis == "institusi" {
		query = query.Where("user_id LIKE ?", "NSBI%")
	} else if jenis == "tpsn" {
		query = query.Where("user_id LIKE ?", "TPSN%")
	} else {
		query = query.Where("user_id NOT LIKE ?", "TPSN%")
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
