package router

import (
	"fmt"
	"net/http"

	"github.com/Arimeka/anifag-com/internal/backend/router/root"
	"github.com/Arimeka/anifag-com/internal/pkg/configuration"
	errorHandler "github.com/Arimeka/anifag-com/internal/pkg/handler/error"
	staticHandler "github.com/Arimeka/anifag-com/internal/pkg/handler/static"

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

	router.Handle(
		"/favicon.ico",
		&staticHandler.Handler{
			SingleFile: "./web/public/favicon.ico",
		},
	).Methods(http.MethodGet, http.MethodHead).Name("favicon.ico")

	router.Handle(
		"/robots.txt",
		&staticHandler.Handler{
			SingleFile: "./web/public/robots.txt",
		},
	).Methods(http.MethodGet, http.MethodHead).Name("robots.txt")

	router.PathPrefix("/css/").Handler(
		http.StripPrefix(
			"/css/",
			&staticHandler.Handler{
				Dir: "./web/static/css",
			},
		),
	).Methods(http.MethodGet, http.MethodHead).Name("css")

	router.PathPrefix("/system/").Handler(
		http.StripPrefix(
			"/system/",
			&staticHandler.Handler{
				Dir: "./web/static/images/system",
			},
		),
	).Methods(http.MethodGet, http.MethodHead).Name("images")

	Root(router, logger)

	root.Prometheus(router, logger)
	root.Debug(router, logger)
	root.Articles(router, logger)
	root.Tags(router, logger)
	root.Categories(router, logger)

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
