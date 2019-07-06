package errors

import "errors"

var (
	// ErrNotFound record not found
	ErrNotFound = errors.New("record not found")
)
