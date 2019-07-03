package scopes

import (
	"github.com/jinzhu/gorm"
)

// ArticleScopes gorm scopes for articles
var ArticleScopes = articleScopes{}

type articleScopes struct{}

// Published return not drafted articles
func (scope articleScopes) Published() func(db *gorm.DB) *gorm.DB {
	return func(db *gorm.DB) *gorm.DB {
		return db.Where("NOT articles.draft")
	}
}

// Ordered return records ordered by created_at DESC
func (scope articleScopes) Ordered() func(db *gorm.DB) *gorm.DB {
	return func(db *gorm.DB) *gorm.DB {
		return db.Order("articles.created_at DESC")
	}
}
