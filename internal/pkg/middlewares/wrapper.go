package middlewares

import (
	"crypto/md5"
	"fmt"
	"net/http"
	"time"

	"github.com/Arimeka/anifag-com/internal/pkg/apperror"

	"go.uber.org/zap"
	"go.uber.org/zap/zapcore"
)

type processor interface {
	Process(rw http.ResponseWriter, req *http.Request) (data []byte, code int, appErr *apperror.Error)
}

type errorRenderer interface {
	Render(appErr *apperror.Error) ([]byte, error)
}

// Wrapper wrap handlers
type Wrapper struct {
	Processor     processor
	ErrorRenderer errorRenderer
	Logger        *zap.Logger
}

func (handler *Wrapper) ServeHTTP(rw http.ResponseWriter, req *http.Request) {
	entity := &logEntity{
		logger:  handler.Logger,
		request: req,
		start:   time.Now(),
	}

	defer entity.log()

	data, code, appErr := handler.Processor.Process(rw, req)
	if appErr != nil {
		data, _ = handler.ErrorRenderer.Render(appErr)

		rw.WriteHeader(appErr.HTTPCode())
		rw.Write(data)

		entity.err = appErr.ErrOrNil()
		entity.level = zapcore.WarnLevel
		entity.statusCode = appErr.HTTPCode()

		return
	}

	entity.level = zapcore.InfoLevel
	entity.statusCode = code

	handler.WriteResponse(rw, req, code, data)
}

// WriteResponse send response to client
func (handler *Wrapper) WriteResponse(rw http.ResponseWriter, req *http.Request, code int, data []byte) error {
	checkSum := fmt.Sprintf("W/%08x", md5.Sum(data))

	rw.Header().Set("ETag", checkSum)
	rw.Header().Set("Cache-Control", "no-cache, no-store, must-revalidate")

	reqETag := req.Header.Get("If-None-Match")
	if reqETag != "" && reqETag == checkSum {
		rw.Header().Del("ETag")
		rw.WriteHeader(http.StatusNotModified)
		return nil
	}
	rw.WriteHeader(code)

	if req.Method == "HEAD" {
		return nil
	}

	_, err := rw.Write(data)
	return err
}

type logEntity struct {
	request    *http.Request
	start      time.Time
	level      zapcore.Level
	statusCode int
	msg        string
	err        error
	logger     *zap.Logger
}

func (l *logEntity) log() {
	fields := []zap.Field{
		zap.String("method", l.request.Method),
		zap.String("path", l.request.RequestURI),
		zap.String("remote_addr", l.request.RemoteAddr),
		zap.String("referer", l.request.Referer()),
		zap.Int("status", l.statusCode),
		zap.Duration("latency", time.Since(l.start)),
	}

	if l.err != nil {
		fields = append(fields, zap.Error(l.err))
	}

	if ce := l.logger.Check(l.level, l.msg); ce != nil {
		ce.Write(fields...)
	}
}
