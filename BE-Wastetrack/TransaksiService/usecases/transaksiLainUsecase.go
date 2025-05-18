package usecases

import (
	"wastetrack/TransaksiService/domain"
)

type TransaksiLainUsecase struct {
	TransaksiLainRepository domain.TransaksiLainRepository
}

func (uc *TransaksiLainUsecase) AddTransaksiLain(TransaksiLain domain.TransaksiLain) (domain.TransaksiLain, error) {
	createdRequest, err := uc.TransaksiLainRepository.AddTransaksiLain(TransaksiLain)
	if err != nil {
		return domain.TransaksiLain{}, err
	}

	return createdRequest, nil
}

func (uc *TransaksiLainUsecase) GetPemasukanLainByBankSampah(bank_id string) ([]domain.SummaryTransaksi, error) {
	return uc.TransaksiLainRepository.GetPemasukanLainByBankSampah(bank_id)
}

func (uc *TransaksiLainUsecase) GetPengeluaranLainByBankSampah(bank_id string) ([]domain.SummaryTransaksi, error) {
	return uc.TransaksiLainRepository.GetPengeluaranLainByBankSampah(bank_id)
}
