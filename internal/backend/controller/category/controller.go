package category

import "github.com/Arimeka/anifag-com/internal/pkg/model"

// Controller for tag page
// Contains methods to get records for tag page
type Controller struct {
	ArticlesRepository   articlesRepo
	CategoriesRepository categoriesRepo
}

// Articles gets list of articles
func (c Controller) Articles(categoryID int, page int) ([]*model.Article, error) {
	return c.ArticlesRepository.ListByCategory(categoryID, page, "tags,categories")
}

// Tag gets tag by ID
func (c Controller) Category(id int) (*model.Category, error) {
	return c.CategoriesRepository.Get(id, "")
}
