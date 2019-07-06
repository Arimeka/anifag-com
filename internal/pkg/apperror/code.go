package apperror

import "net/http"

// code app-specific error code
type code int

const (
	// Unknown unknown error
	Unknown code = iota
	// Panic app throw panic
	Panic
	// DBFailed request to DB failed
	DBFailed
	// NotFound route or record not found
	NotFound
	// NotImplemented route not implemented
	NotImplemented
	// RenderFailed rendering failed
	RenderFailed
)

// codeTitle error codes titles
var codeTitle = map[code]string{
	Unknown:      "Unknown error",
	Panic:        "Panic!",
	DBFailed:     "Database failed",
	NotFound:     "Not Found",
	RenderFailed: "Render failed",
}

// String code to string
func (c code) String() string {
	if v, ok := codeTitle[c]; ok {
		return v
	}
	return codeTitle[Unknown]
}

// HTTPCode http-code for error
func (c code) HTTPCode() int {
	if v, ok := codeHTTP[c]; ok {
		return v
	}
	return codeHTTP[Unknown]
}

// codeHTTP http-codes for errors
var codeHTTP = map[code]int{
	Unknown:        http.StatusInternalServerError,
	Panic:          http.StatusInternalServerError,
	DBFailed:       http.StatusInternalServerError,
	NotFound:       http.StatusNotFound,
	NotImplemented: http.StatusNotImplemented,
	RenderFailed:   http.StatusInternalServerError,
}
