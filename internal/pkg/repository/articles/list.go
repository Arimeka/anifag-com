package articles

import (
	"github.com/Arimeka/anifag-com/internal/pkg/model"

	"github.com/jinzhu/gorm"
)

// List get list of articles from DB
type List struct {
	Base

	Page     int
	Includes string

	Result []*model.Article
}

// Process run command
func (command *List) Process(conn *gorm.DB) error {
	query := conn.Offset(5 * (command.Page - 1)).Limit(5)

	if len(command.Scopes) > 0 {
		query = query.Scopes(command.Scopes...)
	}

	result := query.Find(&command.Result)

	return result.Error
}
