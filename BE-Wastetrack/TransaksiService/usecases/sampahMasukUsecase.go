package usecases

import (
	"wastetrack/TransaksiService/domain"
)

type SampahMasukUsecase struct {
	SampahMasukRepository domain.SampahMasukRepository
}

func (uc *SampahMasukUsecase) AddTransaksiSampahMasuk(SampahMasuk domain.SampahMasuk) (domain.SampahMasuk, error) {
	createdRequest, err := uc.SampahMasukRepository.AddTransaksiSampahMasuk(SampahMasuk)
	if err != nil {
		return domain.SampahMasuk{}, err
	}

	return createdRequest, nil
}

func (uc *SampahMasukUsecase) GetSampahMasukByBankSampah(bank_id string) ([]domain.SummaryTransaksi, error) {
	return uc.SampahMasukRepository.GetSampahMasukByBankSampah(bank_id)
}

func (uc *SampahMasukUsecase) GetSampahMasukByNasabah(bank_id string) ([]domain.SummaryTransaksi, error) {
	return uc.SampahMasukRepository.GetSampahMasukByNasabah(bank_id)
}

func (uc *SampahMasukUsecase) GetSampahMasukByDate(bank_id string, nasabah_id string, date string) ([]domain.SampahMasuk, error) {
	return uc.SampahMasukRepository.GetSampahMasukByDate(bank_id, nasabah_id, date)
}

func (uc *SampahMasukUsecase) GetBeratSampahByBankSampah(bank_id string, month string) ([]domain.SummaryBeratSampah, error) {
	return uc.SampahMasukRepository.GetBeratSampahByBankSampah(bank_id, month)
}

func (uc *SampahMasukUsecase) GetBeratSampahByNasabah(nasabah_id string, month string) ([]domain.SummaryBeratSampah, error) {
	return uc.SampahMasukRepository.GetBeratSampahByNasabah(nasabah_id, month)
}
