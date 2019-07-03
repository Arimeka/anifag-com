package error

import (
	"fmt"
	"net/http"
	"path/filepath"
)

type Error struct {
	Code int
}

func (handler *Error) ServeHTTP(rw http.ResponseWriter, req *http.Request) {
	path, _ := filepath.Abs(fmt.Sprintf("./web/public/%d.html", handler.Code))

	http.ServeFile(rw, req, path)
}
