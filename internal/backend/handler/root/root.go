package root

import (
	"fmt"
	"net/http"
	"strconv"

	"github.com/Arimeka/anifag-com/internal/backend/handler"
	"github.com/Arimeka/anifag-com/internal/backend/view"
	"github.com/Arimeka/anifag-com/internal/pkg/apperror"
)

// Root return data for root page
type Root struct {
	*handler.Base

	Controller controller
	Renderer   renderer
}

// Process request processing
func (h *Root) Process(rw http.ResponseWriter, req *http.Request) (data []byte, code int, appErr *apperror.Error) {
	page, _ := strconv.Atoi(req.FormValue("page"))

	articles, err := h.Controller.Articles(page)
	if err != nil {
		appErr := apperror.New(err)
		appErr.ChangeCode(apperror.DBFailed)
		return data, appErr.HTTPCode(), appErr
	}

	viewData := &view.RootPage{
		Title:       "Anime Fag",
		Description: "Новости аниме и манги.",
		Articles:    articles,
	}

	if len(articles) == 5 {
		if page == 0 {
			page++
		}
		viewData.NextPage = fmt.Sprintf("/?page=%d", page+1)
	}
	if page > 1 {
		if page == 2 {
			viewData.PrevPage = "/"
		} else {
			viewData.PrevPage = fmt.Sprintf("/?page=%d", page-1)
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
