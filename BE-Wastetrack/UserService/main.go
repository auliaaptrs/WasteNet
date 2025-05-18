package main

import (
	"fmt"
	"log"
	"os"
	controllers "wastetrack/UserService/controllers"
	migrations "wastetrack/UserService/migrations"
	repositories "wastetrack/UserService/repositories"
	routes "wastetrack/UserService/routes"
	usecases "wastetrack/UserService/usecases"

	"github.com/gin-gonic/gin"
	"github.com/joho/godotenv"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

func main() {

	// dsn := "host=34.136.106.131 user=postgres password='ae]j0N|thlMeP5+6' dbname=wastenet port=5432 sslmode=disable"
	// db, err := gorm.Open(postgres.Open(dsn), &gorm.Config{})
	// if err != nil {
	// 	log.Fatalf("Failed to connect to database: %v", err)
	// }
	err := godotenv.Load()
	if err != nil {
		log.Fatal("Error loading .env file")
	}

	// Build DSN from env variables
	dsn := fmt.Sprintf(
		"host=%s user=%s password=%s dbname=%s port=%s sslmode=%s",
		os.Getenv("DB_HOST"),
		os.Getenv("DB_USER"),
		os.Getenv("DB_PASSWORD"),
		os.Getenv("DB_NAME"),
		os.Getenv("DB_PORT"),
		os.Getenv("DB_SSLMODE"),
	)

	// dsn := "root:@tcp(127.0.0.1:3306)/?charset=utf8mb4&parseTime=True&loc=Local"
	db, err := gorm.Open(postgres.Open(dsn), &gorm.Config{})
	if err != nil {
		log.Fatalf("Failed to connect to database: %v", err)
	}

	// terminateConn := fmt.Sprintf(
	// 	`SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname='%s';`, dbName)
	// if err := db.Exec(terminateConn).Error; err != nil {
	// 	log.Fatalf("Failed to terminate connections: %v", err)
	// }

	dropAllTablesSQL := `
    DO $$
    DECLARE
        r RECORD;
    BEGIN
        FOR r IN (SELECT tablename FROM pg_tables WHERE schemaname = 'public') LOOP
            EXECUTE 'DROP TABLE IF EXISTS ' || quote_ident(r.tablename) || ' CASCADE';
        END LOOP;
    END $$;
    `

	if err := db.Exec(dropAllTablesSQL).Error; err != nil {
		log.Fatalf("Gagal menghapus semua tabel: %v", err)
	}

	// Run database migrations
	migrations.MigrateDB(db)
	//database.SeedProducts(db)

	// Initialize repositories
	nasabahRepo := &repositories.NasabahRepository{DB: db}
	bankSampahRepo := &repositories.BankSampahRepository{DB: db}
	TPSRRepo := &repositories.TPSRRepository{DB: db}

	// Initialize use cases
	nasabahUsecase := &usecases.NasabahUsecase{NasabahRepository: nasabahRepo}
	bankSampahUsecase := &usecases.BankSampahUsecase{BankSampahRepository: bankSampahRepo}
	TPSRUsecase := &usecases.TPSRUsecase{TPSRRepository: TPSRRepo}

	// Initialize controllers
	nasabahController := &controllers.NasabahController{NasabahUsecase: nasabahUsecase, BankSampahUsecase: bankSampahUsecase}
	bankSampahController := &controllers.BankSampahController{BankSampahUsecase: bankSampahUsecase}
	TPSRController := &controllers.TPSRController{TPSRUsecase: TPSRUsecase}

	// Set up Gin router
	router := gin.Default()

	// Add CORS middleware
	router.Use(func(c *gin.Context) {
		c.Writer.Header().Set("Access-Control-Allow-Origin", "http://localhost:3000")
		c.Writer.Header().Set("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS")
		c.Writer.Header().Set("Access-Control-Allow-Headers", "Content-Type")

		if c.Request.Method == "OPTIONS" {
			c.AbortWithStatus(204)
			return
		}

		c.Next()
	})

	// Set up routes
	routes.SetupNasabahRoutes(router, nasabahController)
	routes.SetupBankSampahRoutes(router, bankSampahController)
	routes.SetupTPSRRoutes(router, TPSRController)

	// Run the server
	log.Println("Server started on port 8080...")
	if err := router.Run(":8080"); err != nil {
		log.Fatalf("Failed to start the server: %v", err)
	}
}
