package controllers

import (
	"net/http"
	"wastetrack/UserService/domain"
	"wastetrack/UserService/usecases"

	"github.com/gin-gonic/gin"
)

type TPSRController struct {
	TPSRUsecase *usecases.TPSRUsecase
}

func (ctr *TPSRController) CreateTPSR(c *gin.Context) {
	var TPSRRequest struct {
		TPSID     string `json:"tps_id" binding:"required"`
		NamaTPS   string `json:"nama_tps" binding:"required"`
		NamaPJ    string `json:"nama_pj" binding:"required"`
		Telepon   string `json:"telepon" binding:"required"`
		Alamat    string `json:"alamat" binding:"required"`
		Kelurahan string `json:"kelurahan" binding:"required"`
		Kecamatan string `json:"kecamatan" binding:"required"`
		Kota      string `json:"kota" binding:"required"`
		Provinsi  string `json:"provinsi" binding:"required"`
		Kapasitas int    `json:"kapasitas" binding:"required"`
	}

	if err := c.ShouldBindJSON(&TPSRRequest); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	TPSR := domain.TPSR{
		TPSID:     TPSRRequest.TPSID,
		NamaTPS:   TPSRRequest.NamaTPS,
		NamaPJ:    TPSRRequest.NamaPJ,
		Alamat:    TPSRRequest.Alamat,
		Telepon:   TPSRRequest.Telepon,
		Kelurahan: TPSRRequest.Kelurahan,
		Kecamatan: TPSRRequest.Kecamatan,
		Kota:      TPSRRequest.Kota,
		Provinsi:  TPSRRequest.Provinsi,
		Kapasitas: TPSRRequest.Kapasitas,
	}

	createdTPSR, err := ctr.TPSRUsecase.CreateTPSR(TPSR)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to create TPSR"})
		return
	}

	c.JSON(http.StatusCreated, createdTPSR)
}

func (ctr *TPSRController) GetTPSRByID(c *gin.Context) {
	// Extract the TPSR_id from the URL parameter
	tps_id := c.Param("tps_id")

	// Fetch the TPSR from the usecase
	TPSR, err := ctr.TPSRUsecase.GetTPSRByID(tps_id)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "TPSR not found"})
		return
	}

	c.JSON(http.StatusOK, TPSR)
}

func (ctr *TPSRController) UpdateTPSR(c *gin.Context) {
	var TPSRRequest struct {
		NamaTPS   string `json:"nama_tps" binding:"required"`
		NamaPJ    string `json:"nama_pj" binding:"required"`
		Telepon   string `json:"telepon" binding:"required"`
		Alamat    string `json:"alamat" binding:"required"`
		Kelurahan string `json:"kelurahan" binding:"required"`
		Kecamatan string `json:"kecamatan" binding:"required"`
		Kota      string `json:"kota" binding:"required"`
		Provinsi  string `json:"provinsi" binding:"required"`
		Kapasitas int    `json:"kapasitas" binding:"required"`
	}

	// Bind JSON payload to TPSRRequest
	if err := c.ShouldBindJSON(&TPSRRequest); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid input"})
		return
	}

	// Extract ID from URL parameter and convert it to uint
	tps_id := c.Param("tps_id")

	existingTPSR, err := ctr.TPSRUsecase.GetTPSRByID(tps_id)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "tps not found"})
		return
	}

	existingTPSR.NamaTPS = TPSRRequest.NamaTPS
	existingTPSR.NamaPJ = TPSRRequest.NamaPJ
	existingTPSR.Telepon = TPSRRequest.Telepon
	existingTPSR.Alamat = TPSRRequest.Alamat
	existingTPSR.Kelurahan = TPSRRequest.Kelurahan
	existingTPSR.Kecamatan = TPSRRequest.Kecamatan
	existingTPSR.Kota = TPSRRequest.Kota
	existingTPSR.Provinsi = TPSRRequest.Provinsi
	existingTPSR.Kapasitas = TPSRRequest.Kapasitas

	updatedTPSR, err := ctr.TPSRUsecase.UpdateTPSR(tps_id, existingTPSR)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to update TPSR"})
		return
	}

	c.JSON(http.StatusOK, updatedTPSR)
}

func (ctr *TPSRController) UpdateTabungan(c *gin.Context) {
	var TPSRRequest struct {
		Nominal  int    `json:"nominal" binding:"required"`
		Kategori string `json:"kategori" binding:"required"`
	}

	if err := c.ShouldBindJSON(&TPSRRequest); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid input"})
		return
	}

	tps_id := c.Param("tps_id")

	existingTPSR, err := ctr.TPSRUsecase.GetTPSRByID(tps_id)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "tps not found"})
		return
	}

	if TPSRRequest.Kategori == "Masuk" {
		existingTPSR.Tabungan += TPSRRequest.Nominal
	} else {
		existingTPSR.Tabungan -= TPSRRequest.Nominal
	}

	if err := ctr.TPSRUsecase.UpdateTabungan(tps_id, existingTPSR.Tabungan); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Tabungan updated successfully"})
}

func (ctr *TPSRController) UpdateSampahTersimpan(c *gin.Context) {
	var TPSRRequest struct {
		Berat    int    `json:"berat" binding:"required"`
		Kategori string `json:"kategori" binding:"required"`
	}

	if err := c.ShouldBindJSON(&TPSRRequest); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid input"})
		return
	}

	tps_id := c.Param("tps_id")

	existingTPSR, err := ctr.TPSRUsecase.GetTPSRByID(tps_id)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "tps not found"})
		return
	}

	if TPSRRequest.Kategori == "Masuk" {
		existingTPSR.SampahTersimpan += TPSRRequest.Berat
	} else {
		existingTPSR.SampahTersimpan -= TPSRRequest.Berat
	}

	if err := ctr.TPSRUsecase.UpdateSampahTersimpan(tps_id, existingTPSR.SampahTersimpan); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Tabungan updated successfully"})
}

func (ctr *TPSRController) DeleteTPSR(c *gin.Context) {
	tps_id := c.Param("tps_id")

	err := ctr.TPSRUsecase.DeleteTPSR(tps_id)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "TPSR not found"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "TPSR deleted successfully"})
}

func (ctr *TPSRController) CountTPSR(c *gin.Context) {
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

	num, err := ctr.TPSRUsecase.CountTPSR(request.Jenis, request.Provinsi, request.Kabupaten, request.Kecamatan, request.Kelurahan)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "BankSampah not found"})
		return
	}

	c.JSON(http.StatusOK, num)
}
