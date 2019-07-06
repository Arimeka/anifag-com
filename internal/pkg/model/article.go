package model

import (
	"strconv"
	"strings"
	"time"

	"github.com/Arimeka/anifag-com/internal/pkg/configuration"
)

// Article represents records from articles table
type Article struct {
	ID              int
	Title           string
	MetaDescription string
	Permalink       string
	CreatedAt       time.Time
}

// Link return link to article page
func (article *Article) Link() string {
	return strings.Join([]string{strconv.Itoa(article.ID), article.Permalink}, "-")
}

// Description return article description
func (article *Article) Description() string {
	return article.MetaDescription
}

// FormattedDate time to string
func (article *Article) FormattedDate() string {
	return article.CreatedAt.In(configuration.TimeZone()).Format("2006-01-02 15:04 MST")
}
