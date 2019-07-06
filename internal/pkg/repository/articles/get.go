package articles

import (
	"github.com/Arimeka/anifag-com/internal/pkg/model"

	"github.com/jinzhu/gorm"
)

// Get get article by ID
type Get struct {
	Base

	ID       int
	Includes string

	Result *model.Article
}

// Process run command
func (command *Get) Process(conn *gorm.DB) error {
	command.Result = new(model.Article)

	query := conn.Where("id = ?", command.ID)

	if len(command.Scopes) > 0 {
		query = query.Scopes(command.Scopes...)
	}

	result := query.Find(&command.Result)

	return result.Error
}
