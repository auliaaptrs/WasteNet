package domain

import (
	"time"

	"gorm.io/gorm"
)

// Users represents the user entity
type User struct {
	UserID    string         `gorm:"type:varchar(255);not null;uniqueIndex;primaryKey" json:"user_id"`
	Email     string         `gorm:"type:varchar(255);not null;uniqueIndex;" json:"email"`
	Password  string         `gorm:"type:text;not null" json:"password"`
	Role      string         `gorm:"type:varchar(50);not null" json:"role"`
	CreatedAt time.Time      `json:"created_at"`
	UpdatedAt time.Time      `json:"updated_at"`
	DeletedAt gorm.DeletedAt `gorm:"index" json:"-"`
}

type UserRepository interface {
	CreateUser(user User) (User, error)
	GetUserByEmail(email string) (User, error)
	GetUserByID(userID string) (User, error)
	UpdateUser(userID string, user User) (User, error)
	DeleteUser(userID string) error
	CountUsersThisMonth() (int64, error)
}
