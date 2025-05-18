package database

import (
	"log"
	"wastetrack/ProductService/domain"

	"gorm.io/gorm"
)

func SeedProducts(db *gorm.DB) {
	products := []domain.Product{
		{NamaProduk: "Kardus"},
		{NamaProduk: "HVS Putih"},
		{NamaProduk: "PET Bening"},
		{NamaProduk: "Kertas Buram", ImageURL: "https://storage.googleapis.com/wastenet_products_image/Kertas%20-%20Buram.png"},
		{NamaProduk: "Kertas Duplek", ImageURL: "https://storage.googleapis.com/wastenet_products_image/Kertas%20-%20Duplek.png"},
		{NamaProduk: "Kertas HVS", ImageURL: "https://storage.googleapis.com/wastenet_products_image/Kertas%20-%20HVS.png"},
		{NamaProduk: "Kertas Kardus", ImageURL: "https://storage.googleapis.com/wastenet_products_image/Kertas%20-%20Kardus.png"},
		{NamaProduk: "Kertas Lainnya", ImageURL: "https://storage.googleapis.com/wastenet_products_image/Kertas%20-%20Lainnya.png"},
		{NamaProduk: "Logam ALuminium", ImageURL: "https://storage.googleapis.com/wastenet_products_image/Logam%20-%20Alumunium.png"},
		{NamaProduk: "Logam Besi", ImageURL: "https://storage.googleapis.com/wastenet_products_image/Logam%20-%20Besi.png"},
		{NamaProduk: "Logam Kuningan", ImageURL: "https://storage.googleapis.com/wastenet_products_image/Logam%20-%20Kuningan.png"},
		{NamaProduk: "Logam Lainnya", ImageURL: "https://storage.googleapis.com/wastenet_products_image/Logam%20-%20Lainnya.png"},
		{NamaProduk: "Logam Perunggu", ImageURL: "https://storage.googleapis.com/wastenet_products_image/Logam%20-%20Perunggu.png"},
		{NamaProduk: "Logam Tembaga", ImageURL: "https://storage.googleapis.com/wastenet_products_image/Logam%20-%20Tembaga.png"},
		{NamaProduk: "Minyak Jelantah", ImageURL: "https://storage.googleapis.com/wastenet_products_image/Minyak%20Jelantah.png"},
		{NamaProduk: "Organik Lainnya", ImageURL: "https://storage.googleapis.com/wastenet_products_image/Organik%20-%20Lainnya.png"},
		{NamaProduk: "Organik Sampah Mudah Terurai", ImageURL: "https://storage.googleapis.com/wastenet_products_image/Organik%20-%20Sampah%20Mudah%20Terurai.png"},
		{NamaProduk: "Plastik PET", ImageURL: "https://storage.googleapis.com/wastenet_products_image/Plastik%20-%201-PET.png"},
		{NamaProduk: "Plastik HDPE", ImageURL: "https://storage.googleapis.com/wastenet_products_image/Plastik%20-%202-HDPE.png"},
		{NamaProduk: "Plastik PVC", ImageURL: "https://storage.googleapis.com/wastenet_products_image/Plastik%20-%203-PVC.png"},
		{NamaProduk: "Plastik PP", ImageURL: "https://storage.googleapis.com/wastenet_products_image/Plastik%20-%205-PP.png"},
		{NamaProduk: "Plastik EPS", ImageURL: "https://storage.googleapis.com/wastenet_products_image/Plastik%20-%206-EPS.png"},
		{NamaProduk: "Plastik PS", ImageURL: "https://storage.googleapis.com/wastenet_products_image/Plastik%20-%206-PS.png"},
		{NamaProduk: "Plastik Lainnya", ImageURL: "https://storage.googleapis.com/wastenet_products_image/Plastik%20-%207-Plastik%20Lainnya.png"},
		{NamaProduk: "Produk Rumah Tangga B3", ImageURL: "https://storage.googleapis.com/wastenet_products_image/Produk%20Rumah%20Tangga%20B3_Limbah%20B3.png"},
		{NamaProduk: "Produk Kemasan B3", ImageURL: "https://storage.googleapis.com/wastenet_products_image/Produk_Kemasan%20B3_Limbah%20B3%20Lainnya.png"},
		{NamaProduk: "Elektronik Air Conditioner", ImageURL: "https://storage.googleapis.com/wastenet_products_image/Sampah%20Elektronik%20-%20Air%20Conditioning%20(AC).png"},
		{NamaProduk: "Elektronik Baterai Aki", ImageURL: "https://storage.googleapis.com/wastenet_products_image/Sampah%20Elektronik%20-%20Baterai_Aki.png"},
		{NamaProduk: "Elektronik Handphone", ImageURL: "https://storage.googleapis.com/wastenet_products_image/Sampah%20Elektronik%20-%20Handphone%20(HP).png"},
		{NamaProduk: "Elektronik Kipas Angin", ImageURL: "https://storage.googleapis.com/wastenet_products_image/Sampah%20Elektronik%20-%20Kipas%20Angin.png"},
		{NamaProduk: "Elektronik Kulkas", ImageURL: "https://storage.googleapis.com/wastenet_products_image/Sampah%20Elektronik%20-%20Kulkas.png"},
		{NamaProduk: "Elektronik Lainnya", ImageURL: "https://storage.googleapis.com/wastenet_products_image/Sampah%20Elektronik%20-%20Lainnya.png"},
	}

	if err := db.Create(&products).Error; err != nil {
		log.Fatalf("Failed to seed products table: %v", err)
	}
	log.Println("Products table seeded successfully")
}
