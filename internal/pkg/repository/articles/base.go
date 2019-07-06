package articles

import (
	"github.com/Arimeka/anifag-com/internal/pkg/repository/scopes"

	"github.com/jinzhu/gorm"
)

// NewBase initialize base command
func NewBase() Base {
	return Base{
		Scopes: []func(db *gorm.DB) *gorm.DB{
			scopes.ArticleScopes.Published(),
			scopes.ArticlePreloads.Tags(),
			scopes.ArticlePreloads.Categories(),
		},
	}
}

// Base command methods
type Base struct {
	Scopes []func(db *gorm.DB) *gorm.DB
}
