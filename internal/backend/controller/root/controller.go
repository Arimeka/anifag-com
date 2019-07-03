package root

import "github.com/Arimeka/anifag-com/internal/pkg/model"

// Controller for root page
// Contains methods to get records for root page
type Controller struct {
	Repository repo
}

// Articles gets list of articles
func (c Controller) Articles(pageNumber int) ([]*model.Article, error) {
	return c.Repository.Feed(pageNumber, "tags,categories")
}
