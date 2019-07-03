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
