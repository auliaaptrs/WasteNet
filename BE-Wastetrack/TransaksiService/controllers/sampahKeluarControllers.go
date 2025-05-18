package controllers

import (
	"net/http"
	"wastetrack/TransaksiService/domain"
	"wastetrack/TransaksiService/usecases"

	"github.com/gin-gonic/gin"
)

type SampahKeluarController struct {
	SampahKeluarUsecase *usecases.SampahKeluarUsecase
}

func (ctr *SampahKeluarController) AddTransaksiSampahKeluar(c *gin.Context) {
	bank_id := c.Param("bank_id")

	var SampahKeluarRequest struct {
		Tujuan string  `json:"tujuan" binding:"required"`
		Produk string  `json:"produk" binding:"required"`
		Brand  string  `json:"brand" binding:"required"`
		Berat  float64 `json:"berat" binding:"required"`
		Harga  int     `json:"harga" binding:"required"`
	}

	if err := c.ShouldBindJSON(&SampahKeluarRequest); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	SampahKeluar := domain.SampahKeluar{
		Tujuan: SampahKeluarRequest.Tujuan,
		BankID: bank_id,
		Produk: SampahKeluarRequest.Produk,
		Brand:  SampahKeluarRequest.Brand,
		Berat:  SampahKeluarRequest.Berat,
		Harga:  SampahKeluarRequest.Harga,
	}

	NewSampahKeluar, err := ctr.SampahKeluarUsecase.AddTransaksiSampahKeluar(SampahKeluar)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusCreated, NewSampahKeluar)
}

func (ctr *SampahKeluarController) GetSampahKeluarByBankSampah(c *gin.Context) {
	bank_id := c.Param("bank_id")

	Summary, err := ctr.SampahKeluarUsecase.GetSampahKeluarByBankSampah(bank_id)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Sampah not found"})
		return
	}

	c.JSON(http.StatusOK, Summary)
}

func (ctr *SampahKeluarController) GetSampahKeluarByDate(c *gin.Context) {
	bank_id := c.Param("bank_id")
	date := c.Param("date")

	DaftarSampahKeluar, err := ctr.SampahKeluarUsecase.GetSampahKeluarByDate(bank_id, date)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Sampah not found"})
		return
	}

	c.JSON(http.StatusOK, DaftarSampahKeluar)
}

func (ctr *SampahKeluarController) GetBeratSampahByBankSampah(c *gin.Context) {
	bank_id := c.Param("bank_id")
	month := c.Param("month")

	DaftarBeratSampah, err := ctr.SampahKeluarUsecase.GetBeratSampahByBankSampah(bank_id, month)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Sampah not found"})
		return
	}

	c.JSON(http.StatusOK, DaftarBeratSampah)
}
