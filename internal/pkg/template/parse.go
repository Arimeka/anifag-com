package template

import (
	"fmt"
	"html/template"
	"path/filepath"
)

// Parse parsing template by name
func Parse(name string) (*template.Template, error) {
	path, err := filepath.Abs(fmt.Sprintf("./web/static/html/%s.html", name))
	if err != nil {
		return nil, err
	}
	return template.New(filepath.Base(path)).ParseFiles(path)
}
