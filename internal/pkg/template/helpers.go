package template

import (
	"html"
	"time"
)

func seoDescription(description string) string {
	return html.EscapeString(description)
}

func seoTitle(title string) string {
	return html.EscapeString(title)
}

func currentYear() int {
	return time.Now().Year()
}
