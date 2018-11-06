package main

import (
	"time"
)

// Forum contains data of a forum
type Forum struct {
	Title     string
	Priority  uint
	Path      string
	SubForums []string
}

// SubForum is a forum within one of the root categories
type SubForum struct {
	Title string
	Posts []Post
}

// Post is what the avarage user can make
// {-| maybe i should create a mode where any user is allowed to create subForum like in reddit? -}
type Post struct {
	Title    string
	Author   UserServer
	Time     time.Time
	Content  string
	Comments []Comment
	Currency int
}

// Comment .
type Comment struct {
	Author   UserServer
	Time     time.Time
	Content  string
	Currency int
}
