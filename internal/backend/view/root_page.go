package view

import "github.com/Arimeka/anifag-com/internal/pkg/model"

// RootPage data for template root page
type RootPage struct {
	Title       string
	Description string
	Articles    []*model.Article
	NextPage    string
	PrevPage    string
}
