package articles

import (
	"github.com/Arimeka/anifag-com/internal/pkg/model"

	"github.com/jinzhu/gorm"
)

// ListByTag get list of articles from DB by tag ID
type ListByTag struct {
	Base

	TagID    int
	Page     int
	Includes string

	Result []*model.Article
}

// Process run command
func (command *ListByTag) Process(conn *gorm.DB) error {
	query := conn.
		Joins("INNER JOIN taggings ON taggings.taggable_id = articles.id AND taggings.tag_id = ?"+
			" AND taggings.taggable_type = 'Article'", command.TagID).
		Offset(5 * (command.Page - 1)).Limit(5)

	if len(command.Scopes) > 0 {
		query = query.Scopes(command.Scopes...)
	}

	result := query.Find(&command.Result)

	return result.Error
}
