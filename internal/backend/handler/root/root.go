package root

import (
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
		return data, http.StatusInternalServerError, appErr
	}

	viewData := &view.RootPage{
		Articles: articles,
	}

	data, err = h.Renderer.Render(viewData)
	if err != nil {
		appErr := apperror.New(err)
		appErr.ChangeCode(apperror.RenderFailed)
		return data, http.StatusInternalServerError, apperror.New(err)
	}

	return data, h.DefaultCode, nil
}
