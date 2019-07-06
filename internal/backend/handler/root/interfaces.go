package root

import (
	"github.com/Arimeka/anifag-com/internal/backend/view"
	"github.com/Arimeka/anifag-com/internal/pkg/model"
)

type controller interface {
	Articles(pageNumber int) ([]*model.Article, error)
}

type renderer interface {
	Render(*view.RootPage) ([]byte, error)
}
