package categories

import (
	"net/http"

	controller "github.com/Arimeka/anifag-com/internal/backend/controller/category"
	"github.com/Arimeka/anifag-com/internal/backend/handler"
	"github.com/Arimeka/anifag-com/internal/backend/handler/category"
	renderer "github.com/Arimeka/anifag-com/internal/backend/renderer/root"
	"github.com/Arimeka/anifag-com/internal/pkg/connection/postgres"
	"github.com/Arimeka/anifag-com/internal/pkg/middlewares"
	errorRenderer "github.com/Arimeka/anifag-com/internal/pkg/renderer/error"
	"github.com/Arimeka/anifag-com/internal/pkg/repository"
	"github.com/Arimeka/anifag-com/internal/pkg/template"

	"github.com/gorilla/mux"
	"go.uber.org/zap"
)

// Show request to categories show page
func Show(router *mux.Router, logger *zap.Logger) {
	subRouter := router.PathPrefix("/{id:[0-9]+}{slug:[^/]+}").Subrouter()

	dbClient, err := postgres.Client()
	if err != nil {
		logger.Fatal("postgres.Client", zap.Error(err))
	}

	tmpl, err := template.Parse("root")
	if err != nil {
		logger.Fatal("template.Parse", zap.Error(err))
	}

	handlerRoot := &category.Show{
		Base: &handler.Base{
			Logger:      logger,
			Name:        "Categories#Show",
			DefaultCode: http.StatusOK,
		},
		Controller: controller.Controller{
			ArticlesRepository: &repository.ArticlesRepository{
				Client: dbClient,
			},
			CategoriesRepository: &repository.CategoriesRepository{
				Client: dbClient,
			},
		},
		Renderer: &renderer.HTML{
			Template: tmpl,
		},
	}

	subRouter.Handle(
		"",
		&middlewares.Wrapper{
			Processor:     handlerRoot,
			Logger:        logger,
			ErrorRenderer: &errorRenderer.HTML{},
		},
	).Methods(http.MethodGet, http.MethodHead).Name(handlerRoot.Name)
}
