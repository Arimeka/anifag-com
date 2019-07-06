package category

import "github.com/Arimeka/anifag-com/internal/pkg/model"

type categoriesRepo interface {
	Get(id int, includes string) (*model.Category, error)
}

type articlesRepo interface {
	ListByCategory(categoryID, page int, includes string) ([]*model.Article, error)
}
