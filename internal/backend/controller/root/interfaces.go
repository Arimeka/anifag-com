package root

import "github.com/Arimeka/anifag-com/internal/pkg/model"

type repo interface {
	Feed(page int, includes string) ([]*model.Article, error)
}
