package routes

import (
	controllers "wastetrack/TransaksiService/controllers"

	"github.com/gin-gonic/gin"
)

func SetupSampahMasukRoutes(router *gin.Engine, SampahMasukController *controllers.SampahMasukController) {
	SampahMasukRoutes := router.Group("/SampahMasuk")
	{
		SampahMasukRoutes.POST("/:bank_id", SampahMasukController.AddTransaksiSampahMasuk)
		SampahMasukRoutes.GET("/BankSampah/:bank_id", SampahMasukController.GetSampahMasukByBankSampah)
		SampahMasukRoutes.GET("/Nasabah/:nasabah_id", SampahMasukController.GetSampahMasukByNasabah)
		SampahMasukRoutes.GET("/:bank_id/:nasabah_id/:date", SampahMasukController.GetSampahMasukByDate)
		SampahMasukRoutes.GET("/BankSampah/:bank_id/BeratSampah/:month", SampahMasukController.GetBeratSampahByBankSampah) //sampah masuk group by product, by tahun-bulan by bank sampah sum berat
		SampahMasukRoutes.GET("/Nasabah/:nasabah_id/BeratSampah/:month", SampahMasukController.GetBeratSampahByNasabah)    //sampah masuk group by product, by tahun-bulan by nasabah sum berat
	}
}
