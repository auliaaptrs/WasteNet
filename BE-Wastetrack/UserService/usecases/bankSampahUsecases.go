package usecases

import (
	"errors"
	"wastetrack/UserService/domain"
)

// BankSampahUsecase contains methods related to BankSampahs
type BankSampahUsecase struct {
	BankSampahRepository domain.BankSampahRepository
}

func (uc *BankSampahUsecase) CreateBankSampah(BankSampah domain.BankSampah) (domain.BankSampah, error) {

	// Save to repository
	createdBankSampah, err := uc.BankSampahRepository.CreateBankSampah(BankSampah)
	if err != nil {
		return domain.BankSampah{}, err
	}

	return createdBankSampah, nil
}

func (uc *BankSampahUsecase) GetBankSampahByID(bank_id string) (domain.BankSampah, error) {
	return uc.BankSampahRepository.GetBankSampahByID(bank_id)
}

func (uc *BankSampahUsecase) GetBankSampahRecomByKelurahan(kelurahan string) (domain.BankSampah, error) {
	return uc.BankSampahRepository.GetBankSampahRecomByKelurahan(kelurahan)
}

func (uc *BankSampahUsecase) GetBankSampahRecomByKecamatan(kecamatan string) (domain.BankSampah, error) {
	return uc.BankSampahRepository.GetBankSampahRecomByKecamatan(kecamatan)
}

func (uc *BankSampahUsecase) GetBankSampahRecomByKota(kota string) (domain.BankSampah, error) {
	return uc.BankSampahRepository.GetBankSampahRecomByKota(kota)
}

func (uc *BankSampahUsecase) UpdateBankSampah(bankID string, updatedBankSampah domain.BankSampah) (domain.BankSampah, error) {
	// Pastikan BankSampah ada di database
	_, err := uc.GetBankSampahByID(bankID)
	if err != nil {
		return domain.BankSampah{}, errors.New("BankSampah not found")
	}

	// Lanjutkan update jika BankSampah ditemukan
	updated, err := uc.BankSampahRepository.UpdateBankSampah(bankID, updatedBankSampah)
	if err != nil {
		return domain.BankSampah{}, errors.New("failed to update BankSampah")
	}

	return updated, nil
}

func (uc *BankSampahUsecase) UpdateTabungan(bank_id string, tabungan int) error {
	_, err := uc.BankSampahRepository.GetBankSampahByID(bank_id)
	if err != nil {
		return errors.New("BankSampah not found")
	}

	// Update hanya kolom tabungan
	if err := uc.BankSampahRepository.UpdateTabungan(bank_id, tabungan); err != nil {
		return errors.New("failed to update tabungan")
	}

	return nil
}

func (uc *BankSampahUsecase) UpdateSampahTersimpan(bank_id string, sampah_tersimpan int) error {
	BankSampah, err := uc.BankSampahRepository.GetBankSampahByID(bank_id)
	if err != nil {
		return errors.New("BankSampah not found")
	}

	// Update hanya kolom sampah tersimpan
	if err := uc.BankSampahRepository.UpdateSampahTersimpan(bank_id, sampah_tersimpan); err != nil {
		return errors.New("failed to update sampah tersimpan")
	}

	if sampah_tersimpan >= BankSampah.Kapasitas {
		if err := uc.BankSampahRepository.UpdateOverload(bank_id, 1); err != nil {
			return errors.New("failed to update overload status")
		}
	} else if BankSampah.Overload && sampah_tersimpan < BankSampah.Kapasitas {
		if err := uc.BankSampahRepository.UpdateOverload(bank_id, 0); err != nil {
			return errors.New("failed to update overload status")
		}
	}

	return nil
}

func (uc *BankSampahUsecase) DeleteBankSampah(bank_id string) error {
	// Ensure the BankSampah exists before attempting to delete
	_, err := uc.BankSampahRepository.GetBankSampahByID(bank_id)
	if err != nil {
		return errors.New("BankSampah not found")
	}

	// Call the repository to delete the BankSampah
	return uc.BankSampahRepository.DeleteBankSampah(bank_id)
}

func (uc *BankSampahUsecase) GetAllNasabahs(bank_id string) ([]domain.Nasabah, error) {
	_, err := uc.BankSampahRepository.GetBankSampahByID(bank_id)
	if err != nil {
		return nil, errors.New("BankSampah not found")
	}

	return uc.BankSampahRepository.GetAllNasabahs(bank_id)
}

func (uc *BankSampahUsecase) GetTotalTabunganNasabah(bank_id string) (int, error) {
	_, err := uc.BankSampahRepository.GetBankSampahByID(bank_id)
	if err != nil {
		return 0, errors.New("BankSampah not found")
	}

	return uc.BankSampahRepository.GetTotalTabunganNasabah(bank_id)
}

func (uc *BankSampahUsecase) GetUnitBanksByIndukID(bankInduk_id string) ([]domain.BankSampah, error) {
	_, err := uc.BankSampahRepository.GetBankSampahByID(bankInduk_id)
	if err != nil {
		return nil, errors.New("BankSampah not found")
	}

	return uc.BankSampahRepository.GetUnitBanksByIndukID(bankInduk_id)
}

func (uc *BankSampahUsecase) AssignUnitToInduk(unit_id string, induk_id string) error {
	return uc.BankSampahRepository.AssignUnitToInduk(unit_id, induk_id)
}

func (uc *BankSampahUsecase) GetBankWithInduk(bank_id string) (domain.BankSampah, error) {
	_, err := uc.BankSampahRepository.GetBankSampahByID(bank_id)
	if err != nil {
		return domain.BankSampah{}, errors.New("BankSampah not found")
	}

	return uc.BankSampahRepository.GetBankWithInduk(bank_id)
}

func (uc *BankSampahUsecase) CountBankSampah(jenis string, provinsi string, kabupaten string, kecamatan string, kelurahan string) (int, error) {
	if kelurahan != "" {
		num, err := uc.BankSampahRepository.CountBankSampahinKelurahan(jenis, provinsi, kabupaten, kecamatan, kelurahan)
		if err != nil {
			return 0, errors.New("cannot get bank sampah")
		}

		return num, nil
	} else if kecamatan != "" {
		num, err := uc.BankSampahRepository.CountBankSampahinKecamatan(jenis, provinsi, kabupaten, kecamatan)
		if err != nil {
			return 0, errors.New("cannot get bank sampah")
		}

		return num, nil
	} else if kabupaten != "" {
		num, err := uc.BankSampahRepository.CountBankSampahinKabupaten(jenis, provinsi, kabupaten)
		if err != nil {
			return 0, errors.New("cannot get bank sampah")
		}

		return num, nil
	} else if provinsi != "" {
		num, err := uc.BankSampahRepository.CountBankSampahinProvinsi(jenis, provinsi)
		if err != nil {
			return 0, errors.New("cannot get bank sampah")
		}

		return num, nil
	} else {
		num, err := uc.BankSampahRepository.CountBankSampah(jenis)
		if err != nil {
			return 0, errors.New("cannot get bank sampah")
		}

		return num, nil
	}
}
