package controllers

import (
	"net/http"
	"wastetrack/UserService/domain"
	"wastetrack/UserService/usecases"

	"github.com/gin-gonic/gin"
)

type NasabahController struct {
	NasabahUsecase    *usecases.NasabahUsecase
	BankSampahUsecase *usecases.BankSampahUsecase
}

func (ctr *NasabahController) CreateNasabah(c *gin.Context) {
	var NasabahRequest struct {
		UserID    string `json:"user_id" binding:"required"`
		Institusi string `json:"institusi"`
		Nama      string `json:"nama" binding:"required"`
		Telepon   string `json:"telepon" binding:"required"`
		Alamat    string `json:"alamat" binding:"required"`
		Kelurahan string `json:"kelurahan" binding:"required"`
		Kecamatan string `json:"kecamatan" binding:"required"`
		Kota      string `json:"kota" binding:"required"`
		Provinsi  string `json:"provinsi" binding:"required"`
	}

	if err := c.ShouldBindJSON(&NasabahRequest); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	Nasabah := domain.Nasabah{
		UserID:    NasabahRequest.UserID,
		Institusi: NasabahRequest.Institusi,
		Nama:      NasabahRequest.Nama,
		Telepon:   NasabahRequest.Telepon,
		Alamat:    NasabahRequest.Alamat,
		Kelurahan: NasabahRequest.Kelurahan,
		Kecamatan: NasabahRequest.Kecamatan,
		Kota:      NasabahRequest.Kota,
		Provinsi:  NasabahRequest.Provinsi,
	}

	createdNasabah, err := ctr.NasabahUsecase.CreateNasabah(Nasabah)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to create Nasabah"})
		return
	}

	c.JSON(http.StatusCreated, createdNasabah)
}

func (ctr *NasabahController) GetNasabahByID(c *gin.Context) {
	// Extract the Nasabah_id from the URL parameter
	user_id := c.Param("user_id")

	// Fetch the Nasabah from the usecase
	Nasabah, err := ctr.NasabahUsecase.GetNasabahByID(user_id)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Nasabah not found"})
		return
	}

	c.JSON(http.StatusOK, Nasabah)
}

func (ctr *NasabahController) UpdateNasabah(c *gin.Context) {
	var NasabahRequest struct {
		Institusi string `json:"institusi"`
		Nama      string `json:"nama" binding:"required"`
		Telepon   string `json:"telepon" binding:"required"`
		Alamat    string `json:"alamat" binding:"required"`
		Kelurahan string `json:"kelurahan" binding:"required"`
		Kecamatan string `json:"kecamatan" binding:"required"`
		Kota      string `json:"kota" binding:"required"`
		Provinsi  string `json:"provinsi" binding:"required"`
	}

	if err := c.ShouldBindJSON(&NasabahRequest); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	userID := c.Param("user_id")

	existingNasabah, err := ctr.NasabahUsecase.GetNasabahByID(userID)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Nasabah not found"})
		return
	}

	existingNasabah.Institusi = NasabahRequest.Institusi
	existingNasabah.Nama = NasabahRequest.Nama
	existingNasabah.Telepon = NasabahRequest.Telepon
	existingNasabah.Alamat = NasabahRequest.Alamat
	existingNasabah.Kelurahan = NasabahRequest.Kelurahan
	existingNasabah.Kecamatan = NasabahRequest.Kecamatan
	existingNasabah.Kota = NasabahRequest.Kota
	existingNasabah.Provinsi = NasabahRequest.Provinsi

	updatedNasabah, err := ctr.NasabahUsecase.UpdateNasabah(userID, existingNasabah)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to update Nasabah"})
		return
	}

	c.JSON(http.StatusOK, updatedNasabah)
}

func (ctr *NasabahController) UpdateTabungan(c *gin.Context) {
	var NasabahRequest struct {
		Tabungan int `json:"tabungan" binding:"required"`
	}

	if err := c.ShouldBindJSON(&NasabahRequest); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid input"})
		return
	}

	userID := c.Param("user_id")

	if err := ctr.NasabahUsecase.UpdateTabungan(userID, NasabahRequest.Tabungan); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Tabungan updated successfully"})
}

func (ctr *NasabahController) DeleteNasabah(c *gin.Context) {
	user_id := c.Param("user_id")

	err := ctr.NasabahUsecase.DeleteNasabah(user_id)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Nasabah not found"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Nasabah deleted successfully"})
}

func (ctr *NasabahController) GetBankSampahRecom(c *gin.Context) {
	user_id := c.Param("user_id")

	Nasabah, err := ctr.NasabahUsecase.GetNasabahByID(user_id)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Nasabah not found"})
		return
	}

	kelurahan := Nasabah.Kelurahan

	BankSampah, err := ctr.BankSampahUsecase.GetBankSampahRecomByKelurahan(kelurahan)
	if err == nil {
		c.JSON(http.StatusOK, BankSampah)
		return
	}

	kecamatan := Nasabah.Kecamatan

	BankSampah, err = ctr.BankSampahUsecase.GetBankSampahRecomByKecamatan(kecamatan)
	if err == nil {
		c.JSON(http.StatusOK, BankSampah)
		return
	}

	kota := Nasabah.Kota

	BankSampah, err = ctr.BankSampahUsecase.GetBankSampahRecomByKota(kota)
	if err == nil {
		c.JSON(http.StatusOK, BankSampah)
		return
	}

	c.JSON(http.StatusNotFound, gin.H{"error": "Bank Sampah Not Found"})
}

func (ctr *NasabahController) UpdateBankSampah(c *gin.Context) {
	user_id := c.Param("user_id")
	bank_id := c.Param("bank_id")

	if err := ctr.NasabahUsecase.UpdateBankSampah(user_id, bank_id); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Bank Sampah updated successfully"})

}

func (ctr *NasabahController) CountNasabah(c *gin.Context) {
	var request struct {
		Jenis     string `json:"jenis" binding:"required"`
		Provinsi  string `json:"provinsi"`
		Kabupaten string `json:"kabupaten"`
		Kecamatan string `json:"kecamatan"`
		Kelurahan string `json:"kelurahan"`
	}

	if err := c.ShouldBindJSON(&request); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request format"})
		return
	}

	num, err := ctr.NasabahUsecase.CountNasabah(request.Jenis, request.Provinsi, request.Kabupaten, request.Kecamatan, request.Kelurahan)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "BankSampah not found"})
		return
	}

	c.JSON(http.StatusOK, num)
}
