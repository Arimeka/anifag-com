package repository

import (
	"github.com/Arimeka/anifag-com/internal/pkg/model"
	"github.com/Arimeka/anifag-com/internal/pkg/repository/articles"
	"github.com/Arimeka/anifag-com/internal/pkg/repository/scopes"

	"github.com/jinzhu/gorm"
)

// ArticlesRepository repository for commands to get articles
type ArticlesRepository struct {
	Client *gorm.DB
}

// Feed get list of articles
func (repo *ArticlesRepository) Feed(page int, includes string) ([]*model.Article, error) {
	command := articles.List{
		Base:     articles.NewBase(),
		Page:     page,
		Includes: includes,
	}
	command.Scopes = append(command.Scopes, scopes.ArticleScopes.Ordered())

	err := command.Process(repo.Client)

	return command.Result, err
}

// ListByTag get list of articles by tag ID
func (repo *ArticlesRepository) ListByTag(tagID, page int, includes string) ([]*model.Article, error) {
	command := articles.ListByTag{
		Base:     articles.NewBase(),
		TagID:    tagID,
		Page:     page,
		Includes: includes,
	}
	command.Scopes = append(command.Scopes, scopes.ArticleScopes.Ordered())

	err := command.Process(repo.Client)

	return command.Result, err
}

// ListByCategory get list of articles by category ID
func (repo *ArticlesRepository) ListByCategory(categoryID, page int, includes string) ([]*model.Article, error) {
	command := articles.ListByCategory{
		Base:       articles.NewBase(),
		CategoryID: categoryID,
		Page:       page,
		Includes:   includes,
	}
	command.Scopes = append(command.Scopes, scopes.ArticleScopes.Ordered())

	err := command.Process(repo.Client)

	return command.Result, err
}

// Get article by ID
func (repo *ArticlesRepository) Get(id int, includes string) (*model.Article, error) {
	command := articles.Get{
		Base:     articles.NewBase(),
		ID:       id,
		Includes: includes,
	}

	err := command.Process(repo.Client)

	return command.Result, err
}
