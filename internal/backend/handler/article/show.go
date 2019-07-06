package article

import (
	"net/http"
	"strconv"

	"github.com/Arimeka/anifag-com/internal/backend/handler"
	"github.com/Arimeka/anifag-com/internal/backend/view"
	"github.com/Arimeka/anifag-com/internal/pkg/apperror"
	"github.com/Arimeka/anifag-com/internal/pkg/repository/errors"

	"github.com/gorilla/mux"
)

// Root return data for article show page
type Show struct {
	*handler.Base

	Controller controller
	Renderer   renderer
}

// Process request processing
func (h *Show) Process(rw http.ResponseWriter, req *http.Request) (data []byte, code int, appErr *apperror.Error) {
	params := mux.Vars(req)

	id, err := strconv.Atoi(params["id"])
	if err != nil {
		appErr := apperror.New(err)
		appErr.ChangeCode(apperror.NotFound)
		return data, appErr.HTTPCode(), appErr
	}

	article, err := h.Controller.Article(id)
	if err != nil {
		appErr := apperror.New(err)
		if err == errors.ErrNotFound {
			appErr.ChangeCode(apperror.NotFound)
		} else {
			appErr.ChangeCode(apperror.DBFailed)
		}

		return data, appErr.HTTPCode(), appErr
	}

	viewData := &view.ArticleShowPage{
		Title:       article.Title,
		Description: article.MetaDescription,
		Article:     article,
	}

	data, err = h.Renderer.Render(viewData)
	if err != nil {
		appErr := apperror.New(err)
		appErr.ChangeCode(apperror.RenderFailed)
		return data, appErr.HTTPCode(), apperror.New(err)
	}

	return data, h.DefaultCode, nil
}
