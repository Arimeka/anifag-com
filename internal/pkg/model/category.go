package model

import (
	"strconv"
	"strings"
)

// Category represents records from categories table
type Category struct {
	ID    int
	Name  string
	Title string
}

// Link return link to category page
func (category *Category) Link() string {
	return "/categories/" + strings.Join([]string{strconv.Itoa(category.ID), category.Name}, "-")
}
