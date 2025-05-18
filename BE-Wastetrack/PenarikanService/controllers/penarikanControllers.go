package controllers

import (
	"net/http"
	"strconv"
	"time"
	"wastetrack/PenarikanService/domain"
	"wastetrack/PenarikanService/usecases"

	"github.com/gin-gonic/gin"
)

type PenarikanController struct {
	PenarikanUsecase *usecases.PenarikanUsecase
}

func (ctr *PenarikanController) AddRequestPenarikan(c *gin.Context) {
	nasabah_id := c.Param("nasabah_id")
	bank_id := c.Param("bank_id")

	var PenarikanRequest struct {
		NominalUang  float64   `json:"nominal_uang" binding:"required"`
		Metode       string    `json:"metode" binding:"required"`
		Jadwal       time.Time `json:"jadwal" binding:"required"`
		BankRekening string    `json:"bank_rekening"`
		NoRek        string    `json:"norek"`
	}

	if err := c.ShouldBindJSON(&PenarikanRequest); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	Penarikan := domain.Penarikan{
		NasabahID:    nasabah_id,
		BankID:       bank_id,
		NominalUang:  PenarikanRequest.NominalUang,
		Metode:       PenarikanRequest.Metode,
		Jadwal:       PenarikanRequest.Jadwal,
		BankRekening: PenarikanRequest.BankRekening,
		NoRek:        PenarikanRequest.NoRek,
	}

	createdRequest, err := ctr.PenarikanUsecase.AddRequestPenarikan(Penarikan)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusCreated, createdRequest)
}

func (ctr *PenarikanController) UpdateStatusPenarikan(c *gin.Context) {
	penarikan_idStr := c.Param("penarikan_id")

	penarikan_id, err := strconv.Atoi(penarikan_idStr)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid product ID"})
		return
	}

	var PenarikanRequest struct {
		Status string `json:"status" binding:"required"`
	}

	if err := c.ShouldBindJSON(&PenarikanRequest); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid input"})
		return
	}

	if err := ctr.PenarikanUsecase.UpdateStatusPenarikan(uint(penarikan_id), PenarikanRequest.Status); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Status updated successfully"})
}

func (ctr *PenarikanController) DonePenarikan(c *gin.Context) {
	penarikan_idStr := c.Param("penarikan_id")

	penarikan_id, err := strconv.Atoi(penarikan_idStr)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid product ID"})
		return
	}

	Status := "Done"

	if err := ctr.PenarikanUsecase.DonePenarikan(uint(penarikan_id), Status); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Penarikan done successfully"})
}

func (ctr *PenarikanController) GetPenarikanByID(c *gin.Context) {
	penarikan_idStr := c.Param("penarikan_id")

	penarikan_id, err := strconv.Atoi(penarikan_idStr)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid product ID"})
		return
	}

	Penarikan, err := ctr.PenarikanUsecase.GetPenarikanByID(uint(penarikan_id))
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Penarikan not found"})
		return
	}

	c.JSON(http.StatusOK, Penarikan)
}

func (ctr *PenarikanController) GetPenarikanDoneByNasabah(c *gin.Context) {
	nasabah_id := c.Param("nasabah_id")

	Penarikans, err := ctr.PenarikanUsecase.GetPenarikanDoneByNasabah(nasabah_id)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Penarikan not found"})
		return
	}

	c.JSON(http.StatusOK, Penarikans)
}

func (ctr *PenarikanController) GetPenarikanRequestByNasabah(c *gin.Context) {
	nasabah_id := c.Param("nasabah_id")

	Penarikans, err := ctr.PenarikanUsecase.GetPenarikanRequestByNasabah(nasabah_id)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Penarikan not found"})
		return
	}

	c.JSON(http.StatusOK, Penarikans)
}

func (ctr *PenarikanController) GetPenarikanAcceptedByNasabah(c *gin.Context) {
	nasabah_id := c.Param("nasabah_id")

	Penarikans, err := ctr.PenarikanUsecase.GetPenarikanAcceptedByNasabah(nasabah_id)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Penarikan not found"})
		return
	}

	c.JSON(http.StatusOK, Penarikans)
}

func (ctr *PenarikanController) GetPenarikanDeclineByNasabah(c *gin.Context) {
	nasabah_id := c.Param("nasabah_id")

	Penarikans, err := ctr.PenarikanUsecase.GetPenarikanDeclineByNasabah(nasabah_id)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Penarikan not found"})
		return
	}

	c.JSON(http.StatusOK, Penarikans)
}

func (ctr *PenarikanController) GetPenarikanDoneByBankSampah(c *gin.Context) {
	bank_id := c.Param("bank_id")

	Penarikans, err := ctr.PenarikanUsecase.GetPenarikanDoneByBankSampah(bank_id)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Penarikan not found"})
		return
	}

	c.JSON(http.StatusOK, Penarikans)
}

func (ctr *PenarikanController) GetPenarikanRequestByBankSampah(c *gin.Context) {
	bank_id := c.Param("bank_id")

	Penarikans, err := ctr.PenarikanUsecase.GetPenarikanRequestByBankSampah(bank_id)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Penarikan not found"})
		return
	}

	c.JSON(http.StatusOK, Penarikans)
}

func (ctr *PenarikanController) GetPenarikanAcceptedByBankSampah(c *gin.Context) {
	bank_id := c.Param("bank_id")

	Penarikans, err := ctr.PenarikanUsecase.GetPenarikanAcceptedByBankSampah(bank_id)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Penarikan not found"})
		return
	}

	c.JSON(http.StatusOK, Penarikans)
}

func (ctr *PenarikanController) GetPenarikanDeclineByBankSampah(c *gin.Context) {
	bank_id := c.Param("bank_id")

	Penarikans, err := ctr.PenarikanUsecase.GetPenarikanDeclineByBankSampah(bank_id)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Penarikan not found"})
		return
	}

	c.JSON(http.StatusOK, Penarikans)
}
