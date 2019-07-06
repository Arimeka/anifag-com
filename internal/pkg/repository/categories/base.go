package categories

import (
	"github.com/jinzhu/gorm"
)

// NewBase initialize base command
func NewBase() Base {
	return Base{
		Scopes: []func(db *gorm.DB) *gorm.DB{},
	}
}

// Base command methods
type Base struct {
	Scopes []func(db *gorm.DB) *gorm.DB
}
