package controllers

import (
	"net/http"
	"strconv"
	"wastetrack/ProductService/usecases"

	"github.com/gin-gonic/gin"
)

type ProductController struct {
	ProductUsecase *usecases.ProductUsecase
}

func (ctr *ProductController) GetAllProducts(c *gin.Context) {
	products, err := ctr.ProductUsecase.GetAllProducts()
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "There is no product"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"data": products})
}

func (ctr *ProductController) AddProductPrice(c *gin.Context) {
	product_idStr := c.Param("product_id")
	bank_id := c.Param("bank_id")

	var HargaSampahRequest struct {
		Harga int `json:"harga" binding:"required"`
	}

	if err := c.ShouldBindJSON(&HargaSampahRequest); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid JSON input"})
		return
	}

	product_id, err := strconv.Atoi(product_idStr)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid product ID"})
		return
	}

	err = ctr.ProductUsecase.AddProductPrice(uint(product_id), bank_id, HargaSampahRequest.Harga)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Product price added successfully"})
}

func (ctr *ProductController) UpdateProductPrice(c *gin.Context) {
	var HargaSampahRequest struct {
		Harga int `json:"harga" binding:"required"`
	}

	if err := c.ShouldBindJSON(&HargaSampahRequest); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid input"})
		return
	}

	product_idStr := c.Param("product_id")
	bank_id := c.Param("bank_id")

	product_id, err := strconv.Atoi(product_idStr)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid product ID"})
		return
	}

	if err := ctr.ProductUsecase.UpdateHarga(uint(product_id), bank_id, HargaSampahRequest.Harga); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Harga updated successfully"})
}

func (ctr *ProductController) DeleteHarga(c *gin.Context) {
	product_idStr := c.Param("product_id")
	bank_id := c.Param("bank_id")

	product_id, err := strconv.Atoi(product_idStr)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid product ID"})
		return
	}

	err = ctr.ProductUsecase.DeleteHarga(uint(product_id), bank_id)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Product not found"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Product Price deleted successfully"})
}

func (ctr *ProductController) GetHargaSampahByBankID(c *gin.Context) {
	bank_id := c.Param("bank_id")

	HargaSampah, err := ctr.ProductUsecase.GetHargaSampahByBankID(bank_id)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Harga Sampah not found"})
		return
	}

	c.JSON(http.StatusOK, HargaSampah)
}
