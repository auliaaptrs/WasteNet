package main

import (
	"fmt"
	"log"
	"os"
	controllers "wastetrack/AuthService/controllers"
	migrations "wastetrack/AuthService/migrations"
	repositories "wastetrack/AuthService/repositories"
	routes "wastetrack/AuthService/routes"
	usecases "wastetrack/AuthService/usecases"

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
	// // Drop database if exist
	// err = db.Exec("DROP DATABASE IF EXISTS " + dbName).Error
	// if err != nil {
	// 	log.Fatalf("Failed to drop database: %v", err)
	// }
	// log.Printf("Database %s dropped successfully.", dbName)

	// // Create new database
	// err = db.Exec("CREATE DATABASE IF NOT EXISTS " + dbName).Error
	// if err != nil {
	// 	log.Fatalf("Failed to create database: %v", err)
	// }
	// log.Printf("Database %s created successfully.", dbName)

	// dsn = "root:@tcp(127.0.0.1:3306)/" + dbName + "?charset=utf8mb4&parseTime=True&loc=Local"
	// db, err = gorm.Open(mysql.Open(dsn), &gorm.Config{})
	// if err != nil {
	// 	log.Fatalf("Failed to connect to database: %v", err)
	// }

	// Run database migrations
	migrations.MigrateDB(db)
	//database.SeedProducts(db)

	// Initialize repositories
	userRepo := &repositories.UserRepository{DB: db}

	// Initialize use cases
	userUsecase := &usecases.UserUsecase{UserRepository: userRepo}

	// Initialize controllers
	userController := &controllers.UserController{UserUsecase: userUsecase}

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
	routes.SetupUserRoutes(router, userController)

	// Run the server
	log.Println("Server started on port 8080...")
	if err := router.Run(":8080"); err != nil {
		log.Fatalf("Failed to start the server: %v", err)
	}
}
