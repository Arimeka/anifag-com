package root

import "github.com/Arimeka/anifag-com/internal/pkg/model"

// Controller for tag page
// Contains methods to get records for tag page
type Controller struct {
	ArticlesRepository articlesRepo
	TagsRepository     tagRepo
}

// Articles gets list of articles
func (c Controller) Articles(tagID int, page int) ([]*model.Article, error) {
	return c.ArticlesRepository.ListByTag(tagID, page, "tags,categories")
}

// Tag gets tag by ID
func (c Controller) Tag(id int) (*model.Tag, error) {
	return c.TagsRepository.Get(id, "")
}
