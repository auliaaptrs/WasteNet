package routes

import (
	controllers "wastetrack/PenarikanService/controllers"

	"github.com/gin-gonic/gin"
)

func SetupPenarikanRoutes(router *gin.Engine, PenarikanController *controllers.PenarikanController) {
	PenarikanRoutes := router.Group("/Penarikan")
	{
		PenarikanRoutes.POST("/:nasabah_id/:bank_id", PenarikanController.AddRequestPenarikan)
		PenarikanRoutes.PUT("/:penarikan_id", PenarikanController.UpdateStatusPenarikan)
		PenarikanRoutes.PUT("/Done/:penarikan_id", PenarikanController.DonePenarikan)
		PenarikanRoutes.GET("/:penarikan_id", PenarikanController.GetPenarikanByID)
		PenarikanRoutes.GET("/DoneNasabah/:nasabah_id", PenarikanController.GetPenarikanDoneByNasabah)
		PenarikanRoutes.GET("/RequestNasabah/:nasabah_id", PenarikanController.GetPenarikanRequestByNasabah)
		PenarikanRoutes.GET("/AcceptedNasabah/:nasabah_id", PenarikanController.GetPenarikanAcceptedByNasabah)
		PenarikanRoutes.GET("/DeclineNasabah/:nasabah_id", PenarikanController.GetPenarikanDeclineByNasabah)
		PenarikanRoutes.GET("/DoneBank/:bank_id", PenarikanController.GetPenarikanDoneByBankSampah)
		PenarikanRoutes.GET("/RequestBank/:bank_id", PenarikanController.GetPenarikanRequestByBankSampah)
		PenarikanRoutes.GET("/AcceptedBank/:bank_id", PenarikanController.GetPenarikanAcceptedByBankSampah)
		PenarikanRoutes.GET("/DeclineBank/:bank_id", PenarikanController.GetPenarikanDeclineByBankSampah)
	}
}
