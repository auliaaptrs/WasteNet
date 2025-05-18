package routes

import (
	controllers "wastetrack/TransaksiService/controllers"

	"github.com/gin-gonic/gin"
)

func SetupTransaksiLainRoutes(router *gin.Engine, TransaksiLainController *controllers.TransaksiLainController) {
	TransaksiLainRoutes := router.Group("/TransaksiLain")
	{
		TransaksiLainRoutes.POST("/:bank_id", TransaksiLainController.AddTransaksiLain)
		TransaksiLainRoutes.GET("Pemasukan/:bank_id", TransaksiLainController.GetPemasukanLainByBankSampah)
		TransaksiLainRoutes.GET("Pengeluaran/:bank_id", TransaksiLainController.GetPengeluaranLainByBankSampah)
	}
}
