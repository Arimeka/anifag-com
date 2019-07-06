package categories

import (
	"github.com/Arimeka/anifag-com/internal/pkg/model"

	"github.com/jinzhu/gorm"
)

// Get get category by ID
type Get struct {
	Base

	ID       int
	Includes string

	Result *model.Category
}

// Process run command
func (command *Get) Process(conn *gorm.DB) error {
	command.Result = new(model.Category)

	query := conn.Where("id = ?", command.ID)

	if len(command.Scopes) > 0 {
		query = query.Scopes(command.Scopes...)
	}

	result := query.Find(&command.Result)

	return result.Error
}
