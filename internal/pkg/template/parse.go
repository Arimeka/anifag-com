package template

import (
	"fmt"
	"path/filepath"
	"text/template"
)

// Parse parsing template by name
func Parse(name string) (*template.Template, error) {
	path, err := filepath.Abs(fmt.Sprintf("./web/static/html/%s.html", name))
	if err != nil {
		return nil, err
	}

	funcMap := template.FuncMap{
		"seoDescription": seoDescription,
		"seoTitle":       seoTitle,
		"currentYear":    currentYear,
	}

	return template.New(filepath.Base(path)).Funcs(funcMap).ParseFiles(path)
}
