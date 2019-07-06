package root

import "github.com/Arimeka/anifag-com/internal/pkg/model"

type repo interface {
	Get(id int, includes string) (*model.Article, error)
}
