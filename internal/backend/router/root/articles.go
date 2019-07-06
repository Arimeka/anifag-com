package root

import (
	"github.com/Arimeka/anifag-com/internal/backend/router/root/articles"

	"github.com/gorilla/mux"
	"go.uber.org/zap"
)

// Articles group routes for articles
func Articles(router *mux.Router, logger *zap.Logger) {
	subRouter := router.PathPrefix("/articles").Subrouter()

	articles.Show(subRouter, logger)
}
