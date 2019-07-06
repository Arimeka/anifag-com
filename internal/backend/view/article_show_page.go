package view

import "github.com/Arimeka/anifag-com/internal/pkg/model"

// ArticleShowPage data for template article show page
type ArticleShowPage struct {
	Title       string
	Description string
	Article     *model.Article
}
