package usecases

import (
	"errors"
	"wastetrack/UserService/domain"
)

type TPSRUsecase struct {
	TPSRRepository domain.TPSRRepository
}

func (uc *TPSRUsecase) CreateTPSR(TPSR domain.TPSR) (domain.TPSR, error) {

	// Save to repository
	createdTPSR, err := uc.TPSRRepository.CreateTPSR(TPSR)
	if err != nil {
		return domain.TPSR{}, err
	}

	return createdTPSR, nil
}

func (uc *TPSRUsecase) GetTPSRByID(tps_id string) (domain.TPSR, error) {
	return uc.TPSRRepository.GetTPSRByID(tps_id)
}

func (uc *TPSRUsecase) UpdateTPSR(TPSID string, updatedTPSR domain.TPSR) (domain.TPSR, error) {
	// Pastikan TPSR ada di database
	_, err := uc.GetTPSRByID(TPSID)
	if err != nil {
		return domain.TPSR{}, errors.New("TPSR not found")
	}

	// Lanjutkan update jika TPSR ditemukan
	updated, err := uc.TPSRRepository.UpdateTPSR(TPSID, updatedTPSR)
	if err != nil {
		return domain.TPSR{}, errors.New("failed to update TPSR")
	}

	return updated, nil
}

func (uc *TPSRUsecase) UpdateTabungan(tps_id string, tabungan int) error {
	_, err := uc.TPSRRepository.GetTPSRByID(tps_id)
	if err != nil {
		return errors.New("TPSR not found")
	}

	// Update hanya kolom tabungan
	if err := uc.TPSRRepository.UpdateTabungan(tps_id, tabungan); err != nil {
		return errors.New("failed to update tabungan")
	}

	return nil
}

func (uc *TPSRUsecase) UpdateSampahTersimpan(tps_id string, sampah_tersimpan int) error {
	TPSR, err := uc.TPSRRepository.GetTPSRByID(tps_id)
	if err != nil {
		return errors.New("TPSR not found")
	}

	// Update hanya kolom sampah tersimpan
	if err := uc.TPSRRepository.UpdateSampahTersimpan(tps_id, sampah_tersimpan); err != nil {
		return errors.New("failed to update sampah tersimpan")
	}

	if sampah_tersimpan >= TPSR.Kapasitas {
		if err := uc.TPSRRepository.UpdateOverload(tps_id, 1); err != nil {
			return errors.New("failed to update overload status")
		}
	} else if TPSR.Overload && sampah_tersimpan < TPSR.Kapasitas {
		if err := uc.TPSRRepository.UpdateOverload(tps_id, 0); err != nil {
			return errors.New("failed to update overload status")
		}
	}

	return nil
}

func (uc *TPSRUsecase) DeleteTPSR(tps_id string) error {
	// Ensure the TPSR exists before attempting to delete
	_, err := uc.TPSRRepository.GetTPSRByID(tps_id)
	if err != nil {
		return errors.New("TPSR not found")
	}

	// Call the repository to delete the TPSR
	return uc.TPSRRepository.DeleteTPSR(tps_id)
}

func (uc *TPSRUsecase) CountTPSR(jenis string, provinsi string, kabupaten string, kecamatan string, kelurahan string) (int, error) {
	if kelurahan != "" {
		num, err := uc.TPSRRepository.CountTPSRinKelurahan(jenis, provinsi, kabupaten, kecamatan, kelurahan)
		if err != nil {
			return 0, errors.New("cannot get bank sampah")
		}

		return num, nil
	} else if kecamatan != "" {
		num, err := uc.TPSRRepository.CountTPSRinKecamatan(jenis, provinsi, kabupaten, kecamatan)
		if err != nil {
			return 0, errors.New("cannot get bank sampah")
		}

		return num, nil
	} else if kabupaten != "" {
		num, err := uc.TPSRRepository.CountTPSRinKabupaten(jenis, provinsi, kabupaten)
		if err != nil {
			return 0, errors.New("cannot get bank sampah")
		}

		return num, nil
	} else if provinsi != "" {
		num, err := uc.TPSRRepository.CountTPSRinProvinsi(jenis, provinsi)
		if err != nil {
			return 0, errors.New("cannot get bank sampah")
		}

		return num, nil
	} else {
		num, err := uc.TPSRRepository.CountTPSR(jenis)
		if err != nil {
			return 0, errors.New("cannot get bank sampah")
		}

		return num, nil
	}
}
