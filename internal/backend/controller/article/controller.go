package root

import "github.com/Arimeka/anifag-com/internal/pkg/model"

// Controller for article show page
type Controller struct {
	Repository repo
}

// Article gets article by ID
func (c Controller) Article(id int) (*model.Article, error) {
	return c.Repository.Get(id, "tags,categories")
}
