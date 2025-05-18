package usecases

import (
	"errors"
	"fmt"
	"time"
	"wastetrack/AuthService/domain"
)

// UserUsecase contains methods related to Users
type UserUsecase struct {
	UserRepository domain.UserRepository
}

func (uc *UserUsecase) CreateUser(User domain.User) (domain.User, error) {

	// Save to repository
	createdUser, err := uc.UserRepository.CreateUser(User)
	if err != nil {
		return domain.User{}, err
	}

	return createdUser, nil
}

func (uc *UserUsecase) GetUserByEmail(email string) (domain.User, error) {
	return uc.UserRepository.GetUserByEmail(email)
}

func (uc *UserUsecase) GetUserByID(user_id string) (domain.User, error) {
	return uc.UserRepository.GetUserByID(user_id)
}

func (uc *UserUsecase) UpdateUser(user_id string, updatedUser domain.User) (domain.User, error) {
	return uc.UserRepository.UpdateUser(user_id, updatedUser)
}

func (uc *UserUsecase) DeleteUser(user_id string) error {
	// Ensure the User exists before attempting to delete
	_, err := uc.UserRepository.GetUserByID(user_id)
	if err != nil {
		return errors.New("user not found")
	}

	// Call the repository to delete the User
	return uc.UserRepository.DeleteUser(user_id)
}

func (uc *UserUsecase) GenerateID(role string) (string, error) {
	var userID string

	now := time.Now()

	year := now.Format("06")
	month := now.Format("01")

	number, err := uc.UserRepository.CountUsersThisMonth()
	if err != nil {
		return "", errors.New("cannot create user")
	}

	number += 1

	switch role {
	case "Nasabah Mandiri":
		userID = fmt.Sprintf("NSBM-%s%s%04d", year, month, number)
	case "Nasabah Institusi":
		userID = fmt.Sprintf("NSBI-%s%s%04d", year, month, number)
	case "Bank Sampah Unit":
		userID = fmt.Sprintf("BNKU-%s%s%04d", year, month, number)
	case "Bank Sampah Induk":
		userID = fmt.Sprintf("BNKI-%s%s%04d", year, month, number)
	case "TPS Non 3R":
		userID = fmt.Sprintf("TPSN-%s%s%04d", year, month, number)
	case "TPS 3R":
		userID = fmt.Sprintf("TPSR-%s%s%04d", year, month, number)
	}

	return userID, nil
}
