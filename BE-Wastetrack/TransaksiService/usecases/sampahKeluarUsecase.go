package usecases

import (
	"wastetrack/TransaksiService/domain"
)

type SampahKeluarUsecase struct {
	SampahKeluarRepository domain.SampahKeluarRepository
}

func (uc *SampahKeluarUsecase) AddTransaksiSampahKeluar(SampahKeluar domain.SampahKeluar) (domain.SampahKeluar, error) {
	createdRequest, err := uc.SampahKeluarRepository.AddTransaksiSampahKeluar(SampahKeluar)
	if err != nil {
		return domain.SampahKeluar{}, err
	}

	return createdRequest, nil
}

func (uc *SampahKeluarUsecase) GetSampahKeluarByBankSampah(bank_id string) ([]domain.SummaryTransaksi, error) {
	return uc.SampahKeluarRepository.GetSampahKeluarByBankSampah(bank_id)
}

func (uc *SampahKeluarUsecase) GetSampahKeluarByDate(bank_id string, date string) ([]domain.SampahKeluar, error) {
	return uc.SampahKeluarRepository.GetSampahKeluarByDate(bank_id, date)
}

func (uc *SampahKeluarUsecase) GetBeratSampahByBankSampah(bank_id string, month string) ([]domain.SummaryBeratSampah, error) {
	return uc.SampahKeluarRepository.GetBeratSampahByBankSampah(bank_id, month)
}
