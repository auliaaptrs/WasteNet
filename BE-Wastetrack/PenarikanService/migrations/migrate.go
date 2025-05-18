package migrations

import (
	"log"
	"wastetrack/PenarikanService/domain"

	"gorm.io/gorm"
)

func MigrateDB(db *gorm.DB) {
	log.Println("Starting database migration...")

	err := db.AutoMigrate(
		&domain.Penarikan{},
	)

	if err != nil {
		log.Fatalf("Failed to migrate genres table: %v", err)
	}

	log.Println("Database migration completed successfully.")
}
