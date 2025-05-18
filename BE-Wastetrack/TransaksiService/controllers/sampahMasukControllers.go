package controllers

import (
	"net/http"
	"wastetrack/TransaksiService/domain"
	"wastetrack/TransaksiService/usecases"

	"github.com/gin-gonic/gin"
)

type SampahMasukController struct {
	SampahMasukUsecase *usecases.SampahMasukUsecase
}

func (ctr *SampahMasukController) AddTransaksiSampahMasuk(c *gin.Context) {
	bank_id := c.Param("bank_id")

	var SampahMasukRequest struct {
		NasabahID string  `json:"nasabah_id" binding:"required"`
		Produk    string  `json:"produk" binding:"required"`
		Brand     string  `json:"brand" binding:"required"`
		Berat     float64 `json:"berat" binding:"required"`
		Harga     int     `json:"harga" binding:"required"`
	}

	if err := c.ShouldBindJSON(&SampahMasukRequest); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	SampahMasuk := domain.SampahMasuk{
		NasabahID: SampahMasukRequest.NasabahID,
		BankID:    bank_id,
		Produk:    SampahMasukRequest.Produk,
		Brand:     SampahMasukRequest.Brand,
		Berat:     SampahMasukRequest.Berat,
		Harga:     SampahMasukRequest.Harga,
	}

	NewSampahMasuk, err := ctr.SampahMasukUsecase.AddTransaksiSampahMasuk(SampahMasuk)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusCreated, NewSampahMasuk)
}

func (ctr *SampahMasukController) GetSampahMasukByBankSampah(c *gin.Context) {
	bank_id := c.Param("bank_id")

	Summary, err := ctr.SampahMasukUsecase.GetSampahMasukByBankSampah(bank_id)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Sampah not found"})
		return
	}

	c.JSON(http.StatusOK, Summary)
}

func (ctr *SampahMasukController) GetSampahMasukByNasabah(c *gin.Context) {
	nasabah_id := c.Param("nasabah_id")

	Summary, err := ctr.SampahMasukUsecase.GetSampahMasukByNasabah(nasabah_id)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Sampah not found"})
		return
	}

	c.JSON(http.StatusOK, Summary)
}

func (ctr *SampahMasukController) GetSampahMasukByDate(c *gin.Context) {
	bank_id := c.Param("bank_id")
	nasabah_id := c.Param("nasabah_id")
	date := c.Param("date")

	DaftarSampahMasuk, err := ctr.SampahMasukUsecase.GetSampahMasukByDate(bank_id, nasabah_id, date)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Sampah not found"})
		return
	}

	c.JSON(http.StatusOK, DaftarSampahMasuk)
}

func (ctr *SampahMasukController) GetBeratSampahByBankSampah(c *gin.Context) {
	bank_id := c.Param("bank_id")
	month := c.Param("month")

	DaftarBeratSampah, err := ctr.SampahMasukUsecase.GetBeratSampahByBankSampah(bank_id, month)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Sampah not found"})
		return
	}

	c.JSON(http.StatusOK, DaftarBeratSampah)
}

func (ctr *SampahMasukController) GetBeratSampahByNasabah(c *gin.Context) {
	nasabah_id := c.Param("nasabah_id")
	month := c.Param("month")

	DaftarBeratSampah, err := ctr.SampahMasukUsecase.GetBeratSampahByNasabah(nasabah_id, month)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Sampah not found"})
		return
	}

	c.JSON(http.StatusOK, DaftarBeratSampah)
}
