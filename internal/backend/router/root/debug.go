package root

import (
	// Initialize pprof
	_ "net/http/pprof"

	"net/http"

	"github.com/Arimeka/anifag-com/internal/pkg/configuration"

	"github.com/gorilla/mux"
	"go.uber.org/zap"
)

// Debug add endpoint to access profiler
func Debug(_ *mux.Router, logger *zap.Logger) {
	router := mux.NewRouter()

	BuildInfo(router, logger)

	http.DefaultServeMux.Handle("/", router)

	go func() {
		if err := http.ListenAndServe(configuration.DebugBind(), nil); err != nil {
			logger.Error("Run Debug Server", zap.Error(err))
		}
	}()
}
