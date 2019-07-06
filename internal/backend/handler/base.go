package handler

import "go.uber.org/zap"

// Base handler for mixin
type Base struct {
	Name        string
	DefaultCode int
	Logger      *zap.Logger
}

// New initialize base handler
func New(logger *zap.Logger) *Base {
	return &Base{
		Logger: logger,
	}
}
