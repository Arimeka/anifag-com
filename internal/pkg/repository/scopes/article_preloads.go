package scopes

import "github.com/jinzhu/gorm"

// ArticlePreloads preloads for article
var ArticlePreloads = articlePreloads{}

type articlePreloads struct{}

// Tags preload tags
func (i articlePreloads) Tags() func(db *gorm.DB) *gorm.DB {
	return func(db *gorm.DB) *gorm.DB {
		return db.Preload("Tags", func(db *gorm.DB) *gorm.DB {
			return db.Where("taggings.taggable_type = 'Article'")
		})
	}
}

// Categories preload categories
func (i articlePreloads) Categories() func(db *gorm.DB) *gorm.DB {
	return func(db *gorm.DB) *gorm.DB {
		return db.Preload("Categories")
	}
}
