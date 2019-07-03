package router

import (
	"fmt"
	"net/http"

	"github.com/Arimeka/anifag-com/internal/backend/router/root"
	"github.com/Arimeka/anifag-com/internal/pkg/configuration"
	errorHandler "github.com/Arimeka/anifag-com/internal/pkg/handler/error"

	"github.com/gorilla/mux"
	"go.uber.org/zap"
)

// New initialize router
func New(logger *zap.Logger) *mux.Router {
	r := mux.NewRouter()

	addRoutes(r, logger)

	return r
}

func addRoutes(router *mux.Router, logger *zap.Logger) {
	router.NotFoundHandler = &errorHandler.Error{Code: http.StatusNotFound}
	router.MethodNotAllowedHandler = &errorHandler.Error{Code: http.StatusMethodNotAllowed}

	Root(router, logger)

	root.Prometheus(router, logger)
	root.Debug(router, logger)

	if configuration.IsDevelopment() {
		var arr []interface{}

		arr = append(arr, "Registered routes:\n")
		err := router.Walk(func(route *mux.Route, router *mux.Router, ancestors []*mux.Route) error {
			if route.GetHandler() != nil {
				t, err := route.GetPathTemplate()
				if err != nil {
					return err
				}
				methods, err := route.GetMethods()
				if err != nil {
					return err
				}

				arr = append(arr, fmt.Sprintf("%s: %+v %s\n", route.GetName(), methods, t))
			}

			return nil
		})
		if err != nil {
			logger.Error("Routes", zap.Error(err))
		} else {
			logger.Sugar().Info(arr...)
		}
	}
}
