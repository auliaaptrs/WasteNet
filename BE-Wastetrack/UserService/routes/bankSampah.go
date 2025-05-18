package routes

import (
	controllers "wastetrack/UserService/controllers"

	"github.com/gin-gonic/gin"
)

func SetupBankSampahRoutes(router *gin.Engine, BankSampahController *controllers.BankSampahController) {
	// BankSampah routes - these deal with BankSampah information
	BankSampahRoutes := router.Group("/BankSampah")
	{
		BankSampahRoutes.POST("/", BankSampahController.CreateBankSampah)               // Create a new BankSampah
		BankSampahRoutes.GET("/:bank_id", BankSampahController.GetBankSampahByID)       // Get BankSampah by BankSampah_id
		BankSampahRoutes.PUT("/:bank_id", BankSampahController.UpdateBankSampah)        // Update BankSampah by BankSampah_id
		BankSampahRoutes.PUT("/:bank_id/Tabungan", BankSampahController.UpdateTabungan) // Update tabungan BankSampah by BankSampah_id
		BankSampahRoutes.PUT("/:bank_id/SampahTersimpan", BankSampahController.UpdateSampahTersimpan)
		BankSampahRoutes.DELETE("/:bank_id", BankSampahController.DeleteBankSampah) // Delete BankSampah by BankSampah_id
		BankSampahRoutes.GET("/:bank_id/Nasabahs", BankSampahController.GetAllNasabahs)
		BankSampahRoutes.GET("/:bank_id/Units", BankSampahController.GetUnitBanksByIndukID)
		BankSampahRoutes.PUT("/Assign/:unit_id/:induk_id", BankSampahController.AssignUnitToInduk)
		BankSampahRoutes.GET("/:bank_id/Induk", BankSampahController.GetBankWithInduk)
		BankSampahRoutes.GET("/:bank_id/TabunganNasabah", BankSampahController.GetTotalTabunganNasabah)
		BankSampahRoutes.POST("/CountBankSampah", BankSampahController.CountBankSampah)
	}
}
