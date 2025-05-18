package database

// import (
// 	"log"
// 	"wastetrack/UserService/domain"

// 	"gorm.io/gorm"
// )

// SeedProducts seeds the actors table with initial data
// func SeedProducts(db *gorm.DB) {
// 	products := []domain.Product{
// 		{NamaProduk: "Kardus"},
// 		{NamaProduk: "HVS Putih"},
// 		{NamaProduk: "PET Bening"},
// 	}

// 	if err := db.Create(&products).Error; err != nil {
// 		log.Fatalf("Failed to seed products table: %v", err)
// 	}
// 	log.Println("Products table seeded successfully")
// }
