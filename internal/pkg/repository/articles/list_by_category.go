package articles

import (
	"github.com/Arimeka/anifag-com/internal/pkg/model"

	"github.com/jinzhu/gorm"
)

// ListByCategory get list of articles from DB by category ID
type ListByCategory struct {
	Base

	CategoryID int
	Page       int
	Includes   string

	Result []*model.Article
}

// Process run command
func (command *ListByCategory) Process(conn *gorm.DB) error {
	query := conn.
		Joins("INNER JOIN cat_associations ON cat_associations.article_id = articles.id AND"+
			" cat_associations.category_id = ?", command.CategoryID).
		Offset(5 * (command.Page - 1)).Limit(5)

	if len(command.Scopes) > 0 {
		query = query.Scopes(command.Scopes...)
	}

	result := query.Find(&command.Result)

	return result.Error
}
