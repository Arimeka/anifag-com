package article

import (
	"github.com/Arimeka/anifag-com/internal/backend/view"
	"github.com/Arimeka/anifag-com/internal/pkg/model"
)

type controller interface {
	Article(id int) (*model.Article, error)
}

type renderer interface {
	Render(*view.ArticleShowPage) ([]byte, error)
}
