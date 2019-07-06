package root

import "github.com/Arimeka/anifag-com/internal/pkg/model"

type tagRepo interface {
	Get(id int, includes string) (*model.Tag, error)
}

type articlesRepo interface {
	ListByTag(tagID, page int, includes string) ([]*model.Article, error)
}
