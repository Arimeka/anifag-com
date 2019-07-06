package static

import (
	"net/http"
	"strings"

	errorHandler "github.com/Arimeka/anifag-com/internal/pkg/handler/error"
)

// Handler send static files
type Handler struct {
	Dir        string
	SingleFile string
}

func (handler *Handler) ServeHTTP(rw http.ResponseWriter, req *http.Request) {
	if handler.SingleFile != "" {
		http.ServeFile(rw, req, handler.SingleFile)

		return
	}

	errHandler := &errorHandler.Error{Code: http.StatusNotFound}
	if strings.HasSuffix(req.URL.Path, "/") {
		errHandler.ServeHTTP(rw, req)
		return
	}

	http.FileServer(http.Dir(handler.Dir)).ServeHTTP(rw, req)
}
