package routes

import (
	controllers "wastetrack/UserService/controllers"

	"github.com/gin-gonic/gin"
)

func SetupNasabahRoutes(router *gin.Engine, NasabahController *controllers.NasabahController) {
	// Nasabah routes - these deal with Nasabah information
	NasabahRoutes := router.Group("/Nasabah")
	{
		NasabahRoutes.POST("/", NasabahController.CreateNasabah)                  // Create a new Nasabah
		NasabahRoutes.GET("/:user_id", NasabahController.GetNasabahByID)          // Get Nasabah by Nasabah_id
		NasabahRoutes.PUT("/:user_id", NasabahController.UpdateNasabah)           // Update Nasabah by Nasabah_id
		NasabahRoutes.PUT("/:user_id/Tabungan", NasabahController.UpdateTabungan) // Update tabungan nasabah by Nasabah_id
		NasabahRoutes.DELETE("/:user_id", NasabahController.DeleteNasabah)        // Delete Nasabah by Nasabah_id
		NasabahRoutes.GET("/:user_id/BankSampahRecommendation", NasabahController.GetBankSampahRecom)
		NasabahRoutes.PUT("/:user_id/BankSampah/:bank_id", NasabahController.UpdateBankSampah)
		NasabahRoutes.POST("/CountNasabah", NasabahController.CountNasabah)
	}
}
