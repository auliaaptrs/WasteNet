package controllers

import (
	"net/http"
	"wastetrack/UserService/domain"
	"wastetrack/UserService/usecases"

	"github.com/gin-gonic/gin"
)

type BankSampahController struct {
	BankSampahUsecase *usecases.BankSampahUsecase
}

func (ctr *BankSampahController) CreateBankSampah(c *gin.Context) {
	var BankSampahRequest struct {
		BankID    string `json:"bank_id" binding:"required"`
		NamaBank  string `json:"nama_bank" binding:"required"`
		NamaPJ    string `json:"nama_pj" binding:"required"`
		Telepon   string `json:"telepon" binding:"required"`
		Alamat    string `json:"alamat" binding:"required"`
		Kelurahan string `json:"kelurahan" binding:"required"`
		Kecamatan string `json:"kecamatan" binding:"required"`
		Kota      string `json:"kota" binding:"required"`
		Provinsi  string `json:"provinsi" binding:"required"`
		Kapasitas int    `json:"kapasitas" binding:"required"`
	}

	if err := c.ShouldBindJSON(&BankSampahRequest); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	BankSampah := domain.BankSampah{
		BankID:    BankSampahRequest.BankID,
		NamaBank:  BankSampahRequest.NamaBank,
		NamaPJ:    BankSampahRequest.NamaPJ,
		Alamat:    BankSampahRequest.Alamat,
		Telepon:   BankSampahRequest.Telepon,
		Kelurahan: BankSampahRequest.Kelurahan,
		Kecamatan: BankSampahRequest.Kecamatan,
		Kota:      BankSampahRequest.Kota,
		Provinsi:  BankSampahRequest.Provinsi,
		Kapasitas: BankSampahRequest.Kapasitas,
	}

	createdBankSampah, err := ctr.BankSampahUsecase.CreateBankSampah(BankSampah)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to create BankSampah"})
		return
	}

	c.JSON(http.StatusCreated, createdBankSampah)
}

func (ctr *BankSampahController) GetBankSampahByID(c *gin.Context) {
	// Extract the BankSampah_id from the URL parameter
	bank_id := c.Param("bank_id")

	// Fetch the BankSampah from the usecase
	BankSampah, err := ctr.BankSampahUsecase.GetBankSampahByID(bank_id)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "BankSampah not found"})
		return
	}

	c.JSON(http.StatusOK, BankSampah)
}

func (ctr *BankSampahController) UpdateBankSampah(c *gin.Context) {
	var BankSampahRequest struct {
		NamaBank  string `json:"nama_bank" binding:"required"`
		NamaPJ    string `json:"nama_pj" binding:"required"`
		Telepon   string `json:"telepon" binding:"required"`
		Alamat    string `json:"alamat" binding:"required"`
		Kelurahan string `json:"kelurahan" binding:"required"`
		Kecamatan string `json:"kecamatan" binding:"required"`
		Kota      string `json:"kota" binding:"required"`
		Provinsi  string `json:"provinsi" binding:"required"`
		Kapasitas int    `json:"kapasitas" binding:"required"`
	}

	// Bind JSON payload to BankSampahRequest
	if err := c.ShouldBindJSON(&BankSampahRequest); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid input"})
		return
	}

	// Extract ID from URL parameter and convert it to uint
	bank_id := c.Param("bank_id")

	existingBankSampah, err := ctr.BankSampahUsecase.GetBankSampahByID(bank_id)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "bank sampah not found"})
		return
	}

	existingBankSampah.NamaBank = BankSampahRequest.NamaBank
	existingBankSampah.NamaPJ = BankSampahRequest.NamaPJ
	existingBankSampah.Telepon = BankSampahRequest.Telepon
	existingBankSampah.Alamat = BankSampahRequest.Alamat
	existingBankSampah.Kelurahan = BankSampahRequest.Kelurahan
	existingBankSampah.Kecamatan = BankSampahRequest.Kecamatan
	existingBankSampah.Kota = BankSampahRequest.Kota
	existingBankSampah.Provinsi = BankSampahRequest.Provinsi
	existingBankSampah.Kapasitas = BankSampahRequest.Kapasitas

	updatedBankSampah, err := ctr.BankSampahUsecase.UpdateBankSampah(bank_id, existingBankSampah)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to update BankSampah"})
		return
	}

	c.JSON(http.StatusOK, updatedBankSampah)
}

func (ctr *BankSampahController) UpdateTabungan(c *gin.Context) {
	var BankSampahRequest struct {
		Nominal  int    `json:"nominal" binding:"required"`
		Kategori string `json:"kategori" binding:"required"`
	}

	if err := c.ShouldBindJSON(&BankSampahRequest); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid input"})
		return
	}

	bank_id := c.Param("bank_id")

	existingBankSampah, err := ctr.BankSampahUsecase.GetBankSampahByID(bank_id)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "bank sampah not found"})
		return
	}

	if BankSampahRequest.Kategori == "Masuk" {
		existingBankSampah.Tabungan += BankSampahRequest.Nominal
	} else {
		existingBankSampah.Tabungan -= BankSampahRequest.Nominal
	}

	if err := ctr.BankSampahUsecase.UpdateTabungan(bank_id, existingBankSampah.Tabungan); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Tabungan updated successfully"})
}

func (ctr *BankSampahController) UpdateSampahTersimpan(c *gin.Context) {
	var BankSampahRequest struct {
		Berat    int    `json:"berat" binding:"required"`
		Kategori string `json:"kategori" binding:"required"`
	}

	if err := c.ShouldBindJSON(&BankSampahRequest); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid input"})
		return
	}

	bank_id := c.Param("bank_id")

	existingBankSampah, err := ctr.BankSampahUsecase.GetBankSampahByID(bank_id)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "bank sampah not found"})
		return
	}

	if BankSampahRequest.Kategori == "Masuk" {
		existingBankSampah.SampahTersimpan += BankSampahRequest.Berat
	} else {
		existingBankSampah.SampahTersimpan -= BankSampahRequest.Berat
	}

	if err := ctr.BankSampahUsecase.UpdateSampahTersimpan(bank_id, existingBankSampah.SampahTersimpan); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Tabungan updated successfully"})
}

func (ctr *BankSampahController) DeleteBankSampah(c *gin.Context) {
	bank_id := c.Param("bank_id")

	err := ctr.BankSampahUsecase.DeleteBankSampah(bank_id)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "BankSampah not found"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "BankSampah deleted successfully"})
}

func (ctr *BankSampahController) GetAllNasabahs(c *gin.Context) {
	bank_id := c.Param("bank_id")

	Nasabahs, err := ctr.BankSampahUsecase.GetAllNasabahs(bank_id)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "BankSampah not found"})
		return
	}

	c.JSON(http.StatusOK, Nasabahs)
}

func (ctr *BankSampahController) GetTotalTabunganNasabah(c *gin.Context) {
	bank_id := c.Param("bank_id")

	TotalTabunganNasabah, err := ctr.BankSampahUsecase.GetTotalTabunganNasabah(bank_id)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "BankSampah not found"})
		return
	}

	c.JSON(http.StatusOK, TotalTabunganNasabah)
}

func (ctr *BankSampahController) GetUnitBanksByIndukID(c *gin.Context) {
	bank_id := c.Param("bank_id")

	BankSampahs, err := ctr.BankSampahUsecase.GetUnitBanksByIndukID(bank_id)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "BankSampah not found"})
		return
	}

	c.JSON(http.StatusOK, BankSampahs)
}

func (ctr *BankSampahController) AssignUnitToInduk(c *gin.Context) {
	unit_id := c.Param("unit_id")
	induk_id := c.Param("induk_id")

	err := ctr.BankSampahUsecase.AssignUnitToInduk(unit_id, induk_id)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Bank sampah unit cannot assigned"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "BankSampah assigned successfully"})
}

func (ctr *BankSampahController) GetBankWithInduk(c *gin.Context) {
	bank_id := c.Param("bank_id")

	BankSampah, err := ctr.BankSampahUsecase.GetBankWithInduk(bank_id)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "BankSampah not found"})
		return
	}

	c.JSON(http.StatusOK, BankSampah)
}

func (ctr *BankSampahController) CountBankSampah(c *gin.Context) {
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

	num, err := ctr.BankSampahUsecase.CountBankSampah(request.Jenis, request.Provinsi, request.Kabupaten, request.Kecamatan, request.Kelurahan)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "BankSampah not found"})
		return
	}

	c.JSON(http.StatusOK, num)
}
