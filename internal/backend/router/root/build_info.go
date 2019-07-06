package root

import (
	"github.com/Arimeka/anifag-com/internal/pkg/configuration"
	"github.com/Arimeka/anifag-com/internal/pkg/version"

	"github.com/gorilla/mux"
	"go.uber.org/zap"
)

// BuildInfo return information about current build
func BuildInfo(router *mux.Router, _logger *zap.Logger) {
	router.Handle(
		version.DefaultRoute,
		version.Info().WithEnvironment(configuration.Environment()),
	)
}
