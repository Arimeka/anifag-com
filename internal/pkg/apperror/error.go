package apperror

import (
	"sync"

	"github.com/goph/emperror"
)

// Error builder
type Error struct {
	code   code
	detail string

	errors *emperror.MultiErrorBuilder

	mu *sync.RWMutex
}

// New new error builder
func New(errs ...error) *Error {
	e := &Error{
		code:   Unknown,
		errors: emperror.NewMultiErrorBuilder(),
		mu:     &sync.RWMutex{},
	}

	for _, err := range errs {
		e.Add(err)
	}

	return e
}

// Add error to builder
func (e *Error) Add(err error) {
	e.mu.Lock()
	defer e.mu.Unlock()

	e.errors.Add(err)
}

// ChangeDetail change error detail
func (e *Error) ChangeDetail(detail string) {
	e.mu.Lock()
	defer e.mu.Unlock()

	e.detail = detail
	e.errors.Message = detail
}

// ChangeCode change error code
func (e *Error) ChangeCode(c code) {
	e.mu.Lock()
	defer e.mu.Unlock()

	e.code = c
}

// Code return error code
func (e Error) Code() int {
	e.mu.RLock()
	defer e.mu.RUnlock()

	return int(e.code)
}

// HTTPCode return http-code
func (e Error) HTTPCode() int {
	e.mu.RLock()
	defer e.mu.RUnlock()

	return e.code.HTTPCode()
}

// ErrOrNil return error or nil
func (e Error) ErrOrNil() error {
	e.mu.RLock()
	defer e.mu.RUnlock()

	return e.errors.ErrOrNil()
}
