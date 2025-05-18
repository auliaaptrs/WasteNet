package routes

import (
	controllers "wastetrack/AuthService/controllers"

	"github.com/gin-gonic/gin"
)

func SetupUserRoutes(router *gin.Engine, UserController *controllers.UserController) {
	UserRoutes := router.Group("/Users")
	{
		UserRoutes.POST("/", UserController.CreateUser)
		UserRoutes.POST("/login", UserController.Login)
		UserRoutes.GET("/Email/:email", UserController.GetUserByEmail)
		UserRoutes.GET("/ID/:user_id", UserController.GetUserByID)
		UserRoutes.PUT("/:user_id", UserController.UpdateUser)
		UserRoutes.DELETE("/:user_id", UserController.DeleteUser)
	}
}
