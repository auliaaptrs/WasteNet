package controllers

import (
	"net/http"
	"wastetrack/TransaksiService/domain"
	"wastetrack/TransaksiService/usecases"

	"github.com/gin-gonic/gin"
)

type TransaksiLainController struct {
	TransaksiLainUsecase *usecases.TransaksiLainUsecase
}

func (ctr *TransaksiLainController) AddTransaksiLain(c *gin.Context) {
	bank_id := c.Param("bank_id")

	var TransaksiLainRequest struct {
		Kategori  string `json:"kategori" binding:"required"`
		Deskripsi string `json:"deskripsi" binding:"required"`
		Nominal   int    `json:"nominal" binding:"required"`
	}

	if err := c.ShouldBindJSON(&TransaksiLainRequest); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	TransaksiLain := domain.TransaksiLain{
		Kategori:  TransaksiLainRequest.Kategori,
		BankID:    bank_id,
		Deskripsi: TransaksiLainRequest.Deskripsi,
		Nominal:   TransaksiLainRequest.Nominal,
	}

	NewTransaksiLain, err := ctr.TransaksiLainUsecase.AddTransaksiLain(TransaksiLain)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusCreated, NewTransaksiLain)
}

func (ctr *TransaksiLainController) GetPengeluaranLainByBankSampah(c *gin.Context) {
	bank_id := c.Param("bank_id")

	Summary, err := ctr.TransaksiLainUsecase.GetPengeluaranLainByBankSampah(bank_id)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Sampah not found"})
		return
	}

	c.JSON(http.StatusOK, Summary)
}

func (ctr *TransaksiLainController) GetPemasukanLainByBankSampah(c *gin.Context) {
	bank_id := c.Param("bank_id")

	Summary, err := ctr.TransaksiLainUsecase.GetPemasukanLainByBankSampah(bank_id)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Sampah not found"})
		return
	}

	c.JSON(http.StatusOK, Summary)
}
