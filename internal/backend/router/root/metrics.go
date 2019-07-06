package root

import (
	"net/http"
	"time"

	"github.com/Arimeka/anifag-com/internal/pkg/configuration"

	"github.com/gorilla/mux"
	"github.com/prometheus/client_golang/prometheus/promhttp"
	"go.uber.org/zap"
)

// Prometheus add router for Prometheus metrics
func Prometheus(_ *mux.Router, logger *zap.Logger) {
	router := mux.NewRouter()
	server := &http.Server{
		Addr:         configuration.MetricsBind(),
		Handler:      router,
		ReadTimeout:  time.Second * 5,
		WriteTimeout: time.Second * 30,
		IdleTimeout:  time.Second * 60,
	}

	router.HandleFunc(
		"/metrics",
		promhttp.Handler().ServeHTTP,
	)

	go func() {
		if err := server.ListenAndServe(); err != nil {
			logger.Error("Run Metrics Server", zap.Error(err))
		}
	}()
}
