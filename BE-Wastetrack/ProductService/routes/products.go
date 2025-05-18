package routes

import (
	controllers "wastetrack/ProductService/controllers"

	"github.com/gin-gonic/gin"
)

func SetupProductRoutes(router *gin.Engine, ProductController *controllers.ProductController) {
	// Product routes - these deal with Product information
	ProductRoutes := router.Group("/Product")
	{
		ProductRoutes.GET("/", ProductController.GetAllProducts)
		ProductRoutes.POST("/:product_id/:bank_id", ProductController.AddProductPrice)
		ProductRoutes.PUT("/:product_id/:bank_id", ProductController.UpdateProductPrice)
		ProductRoutes.DELETE("/:product_id/:bank_id", ProductController.DeleteHarga)
		ProductRoutes.GET("/:bank_id", ProductController.GetHargaSampahByBankID)
	}
}
