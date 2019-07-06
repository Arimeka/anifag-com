package root

import (
	"github.com/Arimeka/anifag-com/internal/backend/router/root/tags"

	"github.com/gorilla/mux"
	"go.uber.org/zap"
)

// Tags group routes for tags
func Tags(router *mux.Router, logger *zap.Logger) {
	subRouter := router.PathPrefix("/tags").Subrouter()

	tags.Show(subRouter, logger)
}
