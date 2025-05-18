package migrations

import (
	"log"
	"wastetrack/ProductService/domain"

	"gorm.io/gorm"
)

func MigrateDB(db *gorm.DB) {
	log.Println("Starting database migration...")

	err := db.AutoMigrate(
		&domain.Product{},
		&domain.HargaSampah{},
	)

	if err != nil {
		log.Fatalf("Failed to migrate genres table: %v", err)
	}

	log.Println("Database migration completed successfully.")
}
