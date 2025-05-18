package usecases

import (
	"errors"
	"wastetrack/PenarikanService/domain"
)

// PenarikanUsecase contains methods related to Penarikan
type PenarikanUsecase struct {
	PenarikanRepository domain.PenarikanRepository
}

func (uc *PenarikanUsecase) AddRequestPenarikan(Penarikan domain.Penarikan) (domain.Penarikan, error) {
	createdRequest, err := uc.PenarikanRepository.AddRequestPenarikan(Penarikan)
	if err != nil {
		return domain.Penarikan{}, err
	}

	return createdRequest, nil
}

func (uc *PenarikanUsecase) GetPenarikanByID(penarikan_id uint) (domain.Penarikan, error) {
	return uc.PenarikanRepository.GetPenarikanByID(penarikan_id)
}

func (uc *PenarikanUsecase) UpdateStatusPenarikan(penarikan_id uint, status string) error {
	_, err := uc.PenarikanRepository.GetPenarikanByID(penarikan_id)
	if err != nil {
		return errors.New("penarikan not found")
	}

	if err := uc.PenarikanRepository.UpdateStatusPenarikan(penarikan_id, status); err != nil {
		return errors.New("failed to update status")
	}

	return nil
}

func (uc *PenarikanUsecase) DonePenarikan(penarikan_id uint, status string) error {
	_, err := uc.PenarikanRepository.GetPenarikanByID(penarikan_id)
	if err != nil {
		return errors.New("penarikan not found")
	}

	if err := uc.PenarikanRepository.DonePenarikan(penarikan_id, status); err != nil {
		return errors.New("failed to update status")
	}

	return nil
}

func (uc *PenarikanUsecase) GetPenarikanDoneByNasabah(nasabah_id string) ([]domain.Penarikan, error) {
	return uc.PenarikanRepository.GetPenarikanDoneByNasabah(nasabah_id)
}

func (uc *PenarikanUsecase) GetPenarikanRequestByNasabah(nasabah_id string) ([]domain.Penarikan, error) {
	return uc.PenarikanRepository.GetPenarikanRequestByNasabah(nasabah_id)
}

func (uc *PenarikanUsecase) GetPenarikanAcceptedByNasabah(nasabah_id string) ([]domain.Penarikan, error) {
	return uc.PenarikanRepository.GetPenarikanAcceptedByNasabah(nasabah_id)
}

func (uc *PenarikanUsecase) GetPenarikanDeclineByNasabah(nasabah_id string) ([]domain.Penarikan, error) {
	return uc.PenarikanRepository.GetPenarikanDeclineByNasabah(nasabah_id)
}

func (uc *PenarikanUsecase) GetPenarikanDoneByBankSampah(bank_id string) ([]domain.Penarikan, error) {
	return uc.PenarikanRepository.GetPenarikanDoneByBankSampah(bank_id)
}

func (uc *PenarikanUsecase) GetPenarikanRequestByBankSampah(bank_id string) ([]domain.Penarikan, error) {
	return uc.PenarikanRepository.GetPenarikanRequestByBankSampah(bank_id)
}

func (uc *PenarikanUsecase) GetPenarikanAcceptedByBankSampah(bank_id string) ([]domain.Penarikan, error) {
	return uc.PenarikanRepository.GetPenarikanAcceptedByBankSampah(bank_id)
}

func (uc *PenarikanUsecase) GetPenarikanDeclineByBankSampah(bank_id string) ([]domain.Penarikan, error) {
	return uc.PenarikanRepository.GetPenarikanDeclineByBankSampah(bank_id)
}
