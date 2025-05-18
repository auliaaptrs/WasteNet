package usecases

import (
	"errors"
	"wastetrack/UserService/domain"
)

// NasabahUsecase contains methods related to Nasabahs
type NasabahUsecase struct {
	NasabahRepository domain.NasabahRepository
}

func (uc *NasabahUsecase) CreateNasabah(Nasabah domain.Nasabah) (domain.Nasabah, error) {

	// Save to repository
	createdNasabah, err := uc.NasabahRepository.CreateNasabah(Nasabah)
	if err != nil {
		return domain.Nasabah{}, err
	}

	return createdNasabah, nil
}

func (uc *NasabahUsecase) GetNasabahByID(user_id string) (domain.Nasabah, error) {
	return uc.NasabahRepository.GetNasabahByID(user_id)
}

func (uc *NasabahUsecase) UpdateNasabah(userID string, updatedNasabah domain.Nasabah) (domain.Nasabah, error) {
	// Pastikan nasabah ada di database
	_, err := uc.GetNasabahByID(userID)
	if err != nil {
		return domain.Nasabah{}, errors.New("nasabah not found")
	}

	// Lanjutkan update jika nasabah ditemukan
	updated, err := uc.NasabahRepository.UpdateNasabah(userID, updatedNasabah)
	if err != nil {
		return domain.Nasabah{}, errors.New("failed to update nasabah")
	}

	return updated, nil
}

func (uc *NasabahUsecase) UpdateTabungan(user_id string, tabungan int) error {
	_, err := uc.NasabahRepository.GetNasabahByID(user_id)
	if err != nil {
		return errors.New("nasabah not found")
	}

	// Update hanya kolom tabungan
	if err := uc.NasabahRepository.UpdateTabungan(user_id, tabungan); err != nil {
		return errors.New("failed to update tabungan")
	}

	return nil
}

func (uc *NasabahUsecase) DeleteNasabah(user_id string) error {
	// Ensure the Nasabah exists before attempting to delete
	_, err := uc.NasabahRepository.GetNasabahByID(user_id)
	if err != nil {
		return errors.New("nasabah not found")
	}

	// Call the repository to delete the Nasabah
	return uc.NasabahRepository.DeleteNasabah(user_id)
}

func (uc *NasabahUsecase) UpdateBankSampah(user_id string, bank_id string) error {
	_, err := uc.NasabahRepository.GetNasabahByID(user_id)
	if err != nil {
		return errors.New("nasabah not found")
	}

	if err := uc.NasabahRepository.UpdateBankSampahNasabah(user_id, bank_id); err != nil {
		return errors.New("failed to update bank sampah")
	}

	return nil
}

func (uc *NasabahUsecase) CountNasabah(jenis string, provinsi string, kabupaten string, kecamatan string, kelurahan string) (int, error) {
	if kelurahan != "" {
		num, err := uc.NasabahRepository.CountNasabahinKelurahan(jenis, provinsi, kabupaten, kecamatan, kelurahan)
		if err != nil {
			return 0, errors.New("cannot get bank sampah")
		}

		return num, nil
	} else if kecamatan != "" {
		num, err := uc.NasabahRepository.CountNasabahinKecamatan(jenis, provinsi, kabupaten, kecamatan)
		if err != nil {
			return 0, errors.New("cannot get bank sampah")
		}

		return num, nil
	} else if kabupaten != "" {
		num, err := uc.NasabahRepository.CountNasabahinKabupaten(jenis, provinsi, kabupaten)
		if err != nil {
			return 0, errors.New("cannot get bank sampah")
		}

		return num, nil
	} else if provinsi != "" {
		num, err := uc.NasabahRepository.CountNasabahinProvinsi(jenis, provinsi)
		if err != nil {
			return 0, errors.New("cannot get bank sampah")
		}

		return num, nil
	} else {
		num, err := uc.NasabahRepository.CountNasabah(jenis)
		if err != nil {
			return 0, errors.New("cannot get bank sampah")
		}

		return num, nil
	}
}
