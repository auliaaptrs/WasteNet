package domain

import "time"

type SummaryTransaksi struct {
	Tanggal   time.Time `json:"tanggal"`
	Deskripsi string    `json:"deskripsi"`
	Nominal   int       `json:"nominal"`
}
