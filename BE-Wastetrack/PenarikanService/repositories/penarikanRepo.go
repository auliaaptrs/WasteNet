package repository

import (
	"wastetrack/PenarikanService/domain"

	"gorm.io/gorm"
)

type PenarikanRepository struct {
	DB *gorm.DB
}

var _ domain.PenarikanRepository = (*PenarikanRepository)(nil)

func (r *PenarikanRepository) AddRequestPenarikan(Penarikan domain.Penarikan) (domain.Penarikan, error) {
	if err := r.DB.Model(&domain.Penarikan{}).
		Create(&Penarikan).Error; err != nil {
		return domain.Penarikan{}, err
	}
	return Penarikan, nil
}

func (r *PenarikanRepository) GetPenarikanByID(penarikanID uint) (domain.Penarikan, error) {
	var penarikan domain.Penarikan
	if err := r.DB.Model(&domain.Penarikan{}).
		Where("id = ?", penarikanID).
		First(&penarikan).Error; err != nil {
		return domain.Penarikan{}, err
	}
	return penarikan, nil
}

func (r *PenarikanRepository) UpdateStatusPenarikan(penarikanID uint, status string) error {
	if err := r.DB.Model(&domain.Penarikan{}).
		Where("id = ?", penarikanID).
		Update("status", status).Error; err != nil {
		return err
	}
	return nil
}

func (r *PenarikanRepository) DonePenarikan(penarikanID uint, status string) error {
	if err := r.DB.Model(&domain.Penarikan{}).
		Where("id = ?", penarikanID).
		Update("status", status).Error; err != nil {
		return err
	}
	return nil
}

func (r *PenarikanRepository) GetPenarikanDoneByNasabah(nasabahID string) ([]domain.Penarikan, error) {
	var histori_penarikan []domain.Penarikan
	err := r.DB.
		Where("nasabah_id = ? AND status = ?", nasabahID, "Done").
		Find(&histori_penarikan).Error
	return histori_penarikan, err
}

func (r *PenarikanRepository) GetPenarikanRequestByNasabah(nasabahID string) ([]domain.Penarikan, error) {
	var histori_penarikan []domain.Penarikan
	err := r.DB.
		Where("nasabah_id = ? AND status = ?", nasabahID, "Requested").
		Find(&histori_penarikan).Error
	return histori_penarikan, err
}

func (r *PenarikanRepository) GetPenarikanAcceptedByNasabah(nasabahID string) ([]domain.Penarikan, error) {
	var histori_penarikan []domain.Penarikan
	err := r.DB.
		Where("nasabah_id = ? AND status = ?", nasabahID, "Accepted").
		Find(&histori_penarikan).Error
	return histori_penarikan, err
}

func (r *PenarikanRepository) GetPenarikanDeclineByNasabah(nasabahID string) ([]domain.Penarikan, error) {
	var histori_penarikan []domain.Penarikan
	err := r.DB.
		Where("nasabah_id = ? AND status = ?", nasabahID, "Decline").
		Find(&histori_penarikan).Error
	return histori_penarikan, err
}

func (r *PenarikanRepository) GetPenarikanDoneByBankSampah(bankID string) ([]domain.Penarikan, error) {
	var histori_penarikan []domain.Penarikan
	err := r.DB.
		Where("bank_id = ? AND status = ?", bankID, "Done").
		Find(&histori_penarikan).Error
	return histori_penarikan, err
}

func (r *PenarikanRepository) GetPenarikanRequestByBankSampah(bankID string) ([]domain.Penarikan, error) {
	var histori_penarikan []domain.Penarikan
	err := r.DB.
		Where("bank_id = ? AND status = ?", bankID, "Requested").
		Find(&histori_penarikan).Error
	return histori_penarikan, err
}

func (r *PenarikanRepository) GetPenarikanAcceptedByBankSampah(bankID string) ([]domain.Penarikan, error) {
	var histori_penarikan []domain.Penarikan
	err := r.DB.
		Where("bank_id = ? AND status = ?", bankID, "Accepted").
		Find(&histori_penarikan).Error
	return histori_penarikan, err
}

func (r *PenarikanRepository) GetPenarikanDeclineByBankSampah(bankID string) ([]domain.Penarikan, error) {
	var histori_penarikan []domain.Penarikan
	err := r.DB.
		Where("bank_id = ? AND status = ?", bankID, "Decline").
		Find(&histori_penarikan).Error
	return histori_penarikan, err
}
