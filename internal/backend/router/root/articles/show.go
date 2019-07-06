package articles

import (
	"net/http"

	controller "github.com/Arimeka/anifag-com/internal/backend/controller/article"
	"github.com/Arimeka/anifag-com/internal/backend/handler"
	"github.com/Arimeka/anifag-com/internal/backend/handler/article"
	renderer "github.com/Arimeka/anifag-com/internal/backend/renderer/article"
	"github.com/Arimeka/anifag-com/internal/pkg/connection/postgres"
	"github.com/Arimeka/anifag-com/internal/pkg/middlewares"
	errorRenderer "github.com/Arimeka/anifag-com/internal/pkg/renderer/error"
	"github.com/Arimeka/anifag-com/internal/pkg/repository"
	"github.com/Arimeka/anifag-com/internal/pkg/template"

	"github.com/gorilla/mux"
	"go.uber.org/zap"
)

// Show request to articles show page
func Show(router *mux.Router, logger *zap.Logger) {
	subRouter := router.PathPrefix("/{id:[0-9]+}{slug:[^/]+}").Subrouter()

	dbClient, err := postgres.Client()
	if err != nil {
		logger.Fatal("postgres.Client", zap.Error(err))
	}

	tmpl, err := template.Parse("article")
	if err != nil {
		logger.Fatal("template.Parse", zap.Error(err))
	}

	handlerRoot := &article.Show{
		Base: &handler.Base{
			Logger:      logger,
			Name:        "Articles#Show",
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

	subRouter.Handle(
		"",
		&middlewares.Wrapper{
			Processor:     handlerRoot,
			Logger:        logger,
			ErrorRenderer: &errorRenderer.HTML{},
		},
	).Methods(http.MethodGet, http.MethodHead).Name(handlerRoot.Name)
}
