package routes

import (
	controllers "wastetrack/UserService/controllers"

	"github.com/gin-gonic/gin"
)

func SetupTPSRRoutes(router *gin.Engine, TPSRController *controllers.TPSRController) {
	// TPSR routes - these deal with TPSR information
	TPSRRoutes := router.Group("/TPSR")
	{
		TPSRRoutes.POST("/", TPSRController.CreateTPSR)                    // Create a new TPSR
		TPSRRoutes.GET("/:tps_id", TPSRController.GetTPSRByID)             // Get TPSR by TPSR_id
		TPSRRoutes.PUT("/:tps_id", TPSRController.UpdateTPSR)              // Update TPSR by TPSR_id
		TPSRRoutes.PUT("/:tps_id/Tabungan", TPSRController.UpdateTabungan) // Update tabungan TPSR by TPSR_id
		TPSRRoutes.PUT("/:tps_id/SampahTersimpan", TPSRController.UpdateSampahTersimpan)
		TPSRRoutes.DELETE("/:tps_id", TPSRController.DeleteTPSR) // Delete TPSR by TPSR_id
		TPSRRoutes.POST("/CountTPSR", TPSRController.CountTPSR)
	}
}
