package routes

import (
	controllers "wastetrack/TransaksiService/controllers"

	"github.com/gin-gonic/gin"
)

func SetupSampahKeluarRoutes(router *gin.Engine, SampahKeluarController *controllers.SampahKeluarController) {
	SampahKeluarRoutes := router.Group("/SampahKeluar")
	{
		SampahKeluarRoutes.POST("/:bank_id", SampahKeluarController.AddTransaksiSampahKeluar)
		SampahKeluarRoutes.GET("/:bank_id", SampahKeluarController.GetSampahKeluarByBankSampah)
		SampahKeluarRoutes.GET("/:bank_id/:date", SampahKeluarController.GetSampahKeluarByDate)
		SampahKeluarRoutes.GET("/:bank_id/BeratSampah/:month", SampahKeluarController.GetBeratSampahByBankSampah) //sampah masuk group by product, by tahun-bulan by bank sampah sum berat
	}
}
