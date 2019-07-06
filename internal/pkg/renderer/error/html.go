package error

import (
	"io/ioutil"
	"path/filepath"

	"github.com/Arimeka/anifag-com/internal/pkg/apperror"
)

// HTML render html for root page
type HTML struct{}

// Render run rendering
func (renderer *HTML) Render(appErr *apperror.Error) ([]byte, error) {
	var (
		path string
		err  error
	)

	switch appErr.Code() {
	case int(apperror.NotFound):
		path, err = filepath.Abs("./web/public/404.html")
	default:
		path, err = filepath.Abs("./web/public/500.html")
	}
	if err != nil {
		return []byte{}, err
	}

	return ioutil.ReadFile(path)
}
