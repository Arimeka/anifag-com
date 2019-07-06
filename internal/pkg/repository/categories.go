package repository

import (
	"github.com/Arimeka/anifag-com/internal/pkg/model"
	"github.com/Arimeka/anifag-com/internal/pkg/repository/categories"

	"github.com/jinzhu/gorm"
)

// CategoriesRepository repository for commands to get categories
type CategoriesRepository struct {
	Client *gorm.DB
}

// Get article by ID
func (repo *CategoriesRepository) Get(id int, includes string) (*model.Category, error) {
	command := categories.Get{
		Base:     categories.NewBase(),
		ID:       id,
		Includes: includes,
	}

	err := command.Process(repo.Client)

	return command.Result, err
}
