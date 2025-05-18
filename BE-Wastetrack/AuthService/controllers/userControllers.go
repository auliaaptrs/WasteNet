package controllers

import (
	"net/http"
	"os"
	"time"
	"wastetrack/AuthService/domain"
	"wastetrack/AuthService/usecases"

	"github.com/gin-gonic/gin"
	"github.com/golang-jwt/jwt/v5"
	"golang.org/x/crypto/bcrypt"
)

type UserController struct {
	UserUsecase *usecases.UserUsecase
}

func (ac *UserController) CreateUser(c *gin.Context) {
	var UserRequest struct {
		Email    string `json:"email" binding:"required"`
		Password string `json:"password" binding:"required"`
		Role     string `json:"role" binding:"required"`
	}

	if err := c.ShouldBindJSON(&UserRequest); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	UserID, err := ac.UserUsecase.GenerateID(UserRequest.Role)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to create User"})
		return
	}

	hashPassword, err := bcrypt.GenerateFromPassword([]byte(UserRequest.Password), 10)

	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"error": "Failed to create user",
		})
	}

	User := domain.User{
		UserID:   UserID,
		Email:    UserRequest.Email,
		Password: string(hashPassword),
		Role:     UserRequest.Role,
	}

	createdUser, err := ac.UserUsecase.CreateUser(User)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to create User"})
		return
	}

	c.JSON(http.StatusCreated, createdUser)
}

func (ac *UserController) GetUserByEmail(c *gin.Context) {
	// Extract the User_id from the URL parameter
	email := c.Param("email")

	// Fetch the User from the usecase
	User, err := ac.UserUsecase.GetUserByEmail(email)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "User not found"})
		return
	}

	c.JSON(http.StatusOK, User)
}

func (ac *UserController) GetUserByID(c *gin.Context) {
	// Extract the User_id from the URL parameter
	user_id := c.Param("user_id")

	// Fetch the User from the usecase
	User, err := ac.UserUsecase.GetUserByID(user_id)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "User not found"})
		return
	}

	c.JSON(http.StatusOK, User)
}

func (ac *UserController) UpdateUser(c *gin.Context) {
	var UserRequest struct {
		Email    string `json:"email" binding:"required"`
		Password string `json:"password" binding:"required"`
	}

	// Bind JSON payload ke UserRequest
	if err := c.ShouldBindJSON(&UserRequest); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid input"})
		return
	}

	userID := c.Param("user_id")

	existingUser, err := ac.UserUsecase.GetUserByID(userID)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "User not found"})
		return
	}

	existingUser.Email = UserRequest.Email
	existingUser.Password = UserRequest.Password

	updatedUser, err := ac.UserUsecase.UpdateUser(userID, existingUser)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to update user"})
		return
	}

	c.JSON(http.StatusOK, updatedUser)
}

func (ac *UserController) DeleteUser(c *gin.Context) {
	user_id := c.Param("user_id")

	err := ac.UserUsecase.DeleteUser(user_id)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "User not found"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "User deleted successfully"})
}

func (ac *UserController) Login(c *gin.Context) {
	var UserRequest struct {
		Email    string `json:"email" binding:"required"`
		Password string `json:"password" binding:"required"`
	}

	if err := c.ShouldBindJSON(&UserRequest); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	User, err := ac.UserUsecase.GetUserByEmail(UserRequest.Email)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "User not found"})
		return
	}

	err = bcrypt.CompareHashAndPassword([]byte(User.Password), []byte(UserRequest.Password))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"error": "Invalid email or password",
		})
		return
	}

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, jwt.MapClaims{
		"sub": User.UserID,
		"exp": time.Now().Add(time.Hour * 24).Unix(),
	})

	tokenString, err := token.SignedString([]byte(os.Getenv("SECRET")))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"error": "cannot create token",
		})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"token": tokenString,
	})
}
