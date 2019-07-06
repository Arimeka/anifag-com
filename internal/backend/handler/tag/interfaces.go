package tag

import (
	"github.com/Arimeka/anifag-com/internal/backend/view"
	"github.com/Arimeka/anifag-com/internal/pkg/model"
)

type controller interface {
	Tag(id int) (*model.Tag, error)
	Articles(tagID int, page int) ([]*model.Article, error)
}

type renderer interface {
	Render(*view.RootPage) ([]byte, error)
}
