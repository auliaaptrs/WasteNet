package repository

import (
	"time"
	"wastetrack/AuthService/domain"

	"gorm.io/gorm"
)

type UserRepository struct {
	DB *gorm.DB
}

var _ domain.UserRepository = (*UserRepository)(nil)

func (r *UserRepository) CreateUser(User domain.User) (domain.User, error) {
	if err := r.DB.Create(&User).Error; err != nil {
		return domain.User{}, err
	}
	return User, nil
}

func (r *UserRepository) GetUserByEmail(email string) (domain.User, error) {
	var user domain.User
	if err := r.DB.Where("email = ?", email).First(&user).Error; err != nil {
		return domain.User{}, err
	}
	return user, nil
}

func (r *UserRepository) GetUserByID(user_id string) (domain.User, error) {
	var User domain.User
	if err := r.DB.Where("user_id = ?", user_id).First(&User).Error; err != nil {
		return domain.User{}, err
	}
	return User, nil
}

func (r *UserRepository) UpdateUser(user_id string, User domain.User) (domain.User, error) {
	if err := r.DB.Model(&domain.User{}).Where("user_id = ?", user_id).Updates(User).Error; err != nil {
		return domain.User{}, err
	}
	return User, nil
}

func (r *UserRepository) DeleteUser(user_id string) error {
	if err := r.DB.Model(&domain.User{}).Where("user_id = ?", user_id).Delete(&domain.User{}).Error; err != nil {
		return err
	}
	return nil
}

func (r *UserRepository) CountUsersThisMonth() (int64, error) {
	var count int64

	now := time.Now()
	start := time.Date(now.Year(), now.Month(), 1, 0, 0, 0, 0, time.UTC)
	end := start.AddDate(0, 1, 0)

	err := r.DB.Unscoped().Model(&domain.User{}).
		Where("created_at >= ? AND created_at < ?", start, end).
		Count(&count).Error

	return count, err
}
