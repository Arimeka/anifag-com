package article

import (
	"bytes"
	"text/template"

	"github.com/Arimeka/anifag-com/internal/backend/view"
)

// HTML render html for article show page
type HTML struct {
	Template *template.Template
}

// Render run rendering
func (renderer *HTML) Render(viewData *view.ArticleShowPage) ([]byte, error) {
	var result bytes.Buffer

	err := renderer.Template.Execute(&result, viewData)

	return result.Bytes(), err
}
