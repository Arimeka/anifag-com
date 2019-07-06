package router

import (
	"net/http"

	controller "github.com/Arimeka/anifag-com/internal/backend/controller/root"
	"github.com/Arimeka/anifag-com/internal/backend/handler"
	"github.com/Arimeka/anifag-com/internal/backend/handler/root"
	renderer "github.com/Arimeka/anifag-com/internal/backend/renderer/root"
	"github.com/Arimeka/anifag-com/internal/pkg/connection/postgres"
	"github.com/Arimeka/anifag-com/internal/pkg/middlewares"
	errorRenderer "github.com/Arimeka/anifag-com/internal/pkg/renderer/error"
	"github.com/Arimeka/anifag-com/internal/pkg/repository"
	"github.com/Arimeka/anifag-com/internal/pkg/template"

	"github.com/gorilla/mux"
	"go.uber.org/zap"
)

// Root request to root page
func Root(router *mux.Router, logger *zap.Logger) {
	dbClient, err := postgres.Client()
	if err != nil {
		logger.Fatal("postgres.Client", zap.Error(err))
	}

	tmpl, err := template.Parse("root")
	if err != nil {
		logger.Fatal("template.Parse", zap.Error(err))
	}

	handlerRoot := &root.Root{
		Base: &handler.Base{
			Logger:      logger,
			Name:        "Root#Root",
			DefaultCode: http.StatusOK,
		},
		Controller: controller.Controller{
			Repository: &repository.ArticlesRepository{
				Client: dbClient,
			},
		},
		Renderer: &renderer.HTML{
			Template: tmpl,
		},
	}

	router.Handle(
		"/",
		&middlewares.Wrapper{
			Processor:     handlerRoot,
			Logger:        logger,
			ErrorRenderer: &errorRenderer.HTML{},
		},
	).Methods(http.MethodGet, http.MethodHead).Name(handlerRoot.Name)
}
