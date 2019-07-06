package model

import (
	"strconv"
)

// Tag represents records from tags table
type Tag struct {
	ID   int
	Name string
}

// Link return link to tag page
func (tag *Tag) Link() string {
	return "/tags/" + strconv.Itoa(tag.ID)
}
