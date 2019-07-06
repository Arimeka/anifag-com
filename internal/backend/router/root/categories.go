package root

import (
	"github.com/Arimeka/anifag-com/internal/backend/router/root/categories"
	"github.com/gorilla/mux"
	"go.uber.org/zap"
)

// Categories group routes for categories
func Categories(router *mux.Router, logger *zap.Logger) {
	subRouter := router.PathPrefix("/categories").Subrouter()

	categories.Show(subRouter, logger)
}
