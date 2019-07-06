package category

import (
	"github.com/Arimeka/anifag-com/internal/backend/view"
	"github.com/Arimeka/anifag-com/internal/pkg/model"
)

type controller interface {
	Category(id int) (*model.Category, error)
	Articles(category int, page int) ([]*model.Article, error)
}

type renderer interface {
	Render(*view.RootPage) ([]byte, error)
}
