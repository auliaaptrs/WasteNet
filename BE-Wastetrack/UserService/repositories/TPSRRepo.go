package repository

import (
	"wastetrack/UserService/domain"

	"gorm.io/gorm"
)

type TPSRRepository struct {
	DB *gorm.DB
}

var _ domain.TPSRRepository = (*TPSRRepository)(nil)

func (r *TPSRRepository) CreateTPSR(TPSR domain.TPSR) (domain.TPSR, error) {
	if err := r.DB.Model(&domain.TPSR{}).
		Create(&TPSR).Error; err != nil {
		return domain.TPSR{}, err
	}
	return TPSR, nil
}

func (r *TPSRRepository) GetTPSRByID(TPSID string) (domain.TPSR, error) {
	var TPSR domain.TPSR
	if err := r.DB.Model(&domain.TPSR{}).
		Where("tps_id = ?", TPSID).
		First(&TPSR).Error; err != nil {
		return domain.TPSR{}, err
	}
	return TPSR, nil
}

func (r *TPSRRepository) UpdateTPSR(TPSID string, TPSR domain.TPSR) (domain.TPSR, error) {
	TPSR.TPSID = TPSID
	if err := r.DB.Model(&domain.TPSR{}).
		Where("tps_id = ?", TPSID).
		Updates(TPSR).Error; err != nil {
		return domain.TPSR{}, err
	}
	return TPSR, nil
}

func (r *TPSRRepository) UpdateTabungan(TPSID string, tabungan int) error {
	if err := r.DB.Model(&domain.TPSR{}).
		Where("tps_id = ?", TPSID).
		Update("tabungan", tabungan).Error; err != nil {
		return err
	}
	return nil
}

func (r *TPSRRepository) UpdateSampahTersimpan(TPSID string, sampahTersimpan int) error {
	if err := r.DB.Model(&domain.TPSR{}).
		Where("tps_id = ?", TPSID).
		Update("sampah_tersimpan", sampahTersimpan).Error; err != nil {
		return err
	}
	return nil
}

func (r *TPSRRepository) UpdateOverload(TPSID string, status int) error {
	if err := r.DB.Model(&domain.TPSR{}).
		Where("tps_id = ?", TPSID).
		Update("overload", status).Error; err != nil {
		return err
	}
	return nil
}

func (r *TPSRRepository) DeleteTPSR(TPSID string) error {
	if err := r.DB.Model(&domain.TPSR{}).
		Where("tps_id = ?", TPSID).
		Delete(&domain.TPSR{}).Error; err != nil {
		return err
	}
	return nil
}

func (r *TPSRRepository) CountTPSR(jenis string) (int, error) {
	var count int64
	query := r.DB.Model(&domain.TPSR{})

	err := query.Count(&count).Error
	if err != nil {
		return 0, err
	}

	return int(count), nil
}

func (r *TPSRRepository) CountTPSRinProvinsi(jenis string, provinsi string) (int, error) {
	var count int64
	query := r.DB.Model(&domain.TPSR{})

	query = query.Where("provinsi = ?", provinsi)

	err := query.Count(&count).Error
	if err != nil {
		return 0, err
	}

	return int(count), nil
}

func (r *TPSRRepository) CountTPSRinKabupaten(jenis string, provinsi string, kabupaten string) (int, error) {
	var count int64
	query := r.DB.Model(&domain.TPSR{})

	query = query.Where("provinsi = ?", provinsi)
	query = query.Where("kota = ?", kabupaten)

	err := query.Count(&count).Error
	if err != nil {
		return 0, err
	}

	return int(count), nil
}

func (r *TPSRRepository) CountTPSRinKecamatan(jenis string, provinsi string, kabupaten string, kecamatan string) (int, error) {
	var count int64
	query := r.DB.Model(&domain.TPSR{})

	query = query.Where("provinsi = ?", provinsi)
	query = query.Where("kota = ?", kabupaten)
	query = query.Where("kecamatan = ?", kecamatan)

	err := query.Count(&count).Error
	if err != nil {
		return 0, err
	}

	return int(count), nil
}

func (r *TPSRRepository) CountTPSRinKelurahan(jenis string, provinsi string, kabupaten string, kecamatan string, kelurahan string) (int, error) {
	var count int64
	query := r.DB.Model(&domain.TPSR{})

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
