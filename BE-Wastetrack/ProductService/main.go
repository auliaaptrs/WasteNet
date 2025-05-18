package main

import (
	"fmt"
	"log"
	"os"
	controllers "wastetrack/ProductService/controllers"
	migrations "wastetrack/ProductService/migrations"
	repositories "wastetrack/ProductService/repositories"
	routes "wastetrack/ProductService/routes"
	database "wastetrack/ProductService/seeders"

	//database "wastetrack/ProductService/seeders"
	usecases "wastetrack/ProductService/usecases"

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

	// dbName := "wastenet"
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
	// dsn = "root:@tcp(127.0.0.1:3306)/" + dbName + "?charset=utf8mb4&parseTime=True&loc=Local"
	// db, err = gorm.Open(mysql.Open(dsn), &gorm.Config{})
	// if err != nil {
	// 	log.Fatalf("Failed to connect to database: %v", err)
	// }

	// Run database migrations
	migrations.MigrateDB(db)
	database.SeedProducts(db)

	// Initialize repositories
	productRepo := &repositories.ProductRepository{DB: db}

	// Initialize use cases
	productUsecase := &usecases.ProductUsecase{ProductRepository: productRepo}

	// Initialize controllers
	productController := &controllers.ProductController{ProductUsecase: productUsecase}

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
	routes.SetupProductRoutes(router, productController)

	// Run the server
	log.Println("Server started on port 8080...")
	if err := router.Run(":8080"); err != nil {
		log.Fatalf("Failed to start the server: %v", err)
	}
}
