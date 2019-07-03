package main

import (
	"context"
	"log"
	"net/http"
	"os"
	"os/signal"
	"syscall"
	"time"

	"github.com/Arimeka/anifag-com/internal/backend/router"
	"github.com/Arimeka/anifag-com/internal/pkg/configuration"

	"go.uber.org/zap"
)

func main() {
	logger, err := zap.NewProduction()
	if err != nil {
		log.Fatal(err)
	}

	if err := configuration.Init(); err != nil {
		logger.Fatal("Configuration", zap.Error(err))
	}

	logger, err = zap.NewDevelopment()
	if err != nil {
		log.Fatal(err)
	}

	start(logger)
}

func start(logger *zap.Logger) {
	handler := http.Handler(router.New(logger))

	server := &http.Server{
		Addr:         configuration.Bind(),
		Handler:      handler,
		ReadTimeout:  time.Second * 5,
		WriteTimeout: time.Second * 30,
		IdleTimeout:  time.Second * 60,
	}

	go func() {
		if err := server.ListenAndServe(); err != nil {
			logger.Fatal("Run Server", zap.Error(err))
		}
	}()

	logger.Info("", zap.String("Listening", configuration.Bind()))

	sigc := make(chan os.Signal)
	signal.Notify(sigc, syscall.SIGTERM, syscall.SIGQUIT, syscall.SIGKILL, syscall.SIGSTOP)
	<-sigc
	ctx, cancel := context.WithTimeout(
		context.Background(),
		configuration.GracefulTimeout(),
	)
	defer cancel()
	if err := server.Shutdown(ctx); err != nil {
		logger.Error("Server shutdown", zap.Error(err))
	}

}
