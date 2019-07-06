package category

import (
	"fmt"
	"net/http"
	"strconv"

	"github.com/Arimeka/anifag-com/internal/backend/handler"
	"github.com/Arimeka/anifag-com/internal/backend/view"
	"github.com/Arimeka/anifag-com/internal/pkg/apperror"
	"github.com/Arimeka/anifag-com/internal/pkg/repository/errors"

	"github.com/gorilla/mux"
)

// Show return data for category show page
type Show struct {
	*handler.Base

	Controller controller
	Renderer   renderer
}

// Process request processing
func (h *Show) Process(rw http.ResponseWriter, req *http.Request) (data []byte, code int, appErr *apperror.Error) {
	params := mux.Vars(req)
	page, _ := strconv.Atoi(req.FormValue("page"))

	id, err := strconv.Atoi(params["id"])
	if err != nil {
		appErr := apperror.New(err)
		appErr.ChangeCode(apperror.NotFound)
		return data, appErr.HTTPCode(), appErr
	}

	category, err := h.Controller.Category(id)
	if err != nil {
		appErr := apperror.New(err)
		if err == errors.ErrNotFound {
			appErr.ChangeCode(apperror.NotFound)
		} else {
			appErr.ChangeCode(apperror.DBFailed)
		}

		return data, appErr.HTTPCode(), appErr
	}

	articles, err := h.Controller.Articles(category.ID, page)
	if err != nil {
		appErr := apperror.New(err)
		appErr.ChangeCode(apperror.DBFailed)

		return data, appErr.HTTPCode(), appErr
	}

	viewData := &view.RootPage{
		Title:       fmt.Sprintf("%s - Anime Fag", category.Title),
		Description: "Новости аниме и манги.",
		Articles:    articles,
	}

	if len(articles) == 5 {
		if page == 0 {
			page++
		}
		viewData.NextPage = fmt.Sprintf("%s?page=%d", category.Link(), page+1)
	}
	if page > 1 {
		if page == 2 {
			viewData.PrevPage = category.Link()
		} else {
			viewData.PrevPage = fmt.Sprintf("%s?page=%d", category.Link(), page-1)
		}
	}

	data, err = h.Renderer.Render(viewData)
	if err != nil {
		appErr := apperror.New(err)
		appErr.ChangeCode(apperror.RenderFailed)
		return data, appErr.HTTPCode(), apperror.New(err)
	}

	return data, h.DefaultCode, nil
}
