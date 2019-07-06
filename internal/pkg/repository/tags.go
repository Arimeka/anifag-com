package repository

import (
	"github.com/Arimeka/anifag-com/internal/pkg/model"
	"github.com/Arimeka/anifag-com/internal/pkg/repository/tags"

	"github.com/jinzhu/gorm"
)

// TagsRepository repository for commands to get tags
type TagsRepository struct {
	Client *gorm.DB
}

// Get article by ID
func (repo *TagsRepository) Get(id int, includes string) (*model.Tag, error) {
	command := tags.Get{
		Base:     tags.NewBase(),
		ID:       id,
		Includes: includes,
	}

	err := command.Process(repo.Client)

	return command.Result, err
}
