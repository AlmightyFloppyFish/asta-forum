package main

import (
	"net/http"
)

// This one matches elm type alias!
type forumList struct {
	Title     string
	subForums []string
	icon      string // Link to image, i might not even need this but indexes don't work same way in elm
}

func (s *session) getForums(w http.ResponseWriter, r *http.Request) {
	// Used by bg post request to get list of forums
	// Should send back an []forumList

	//TODO:

}

func (s session) newPost(w http.ResponseWriter, r *http.Request) {
	// Parse from forms: which forum, postname, postcontent
	// Then give that information to the same function as cli ( saveNewPost() )

	/*

		if !isLoggedIn(r) {
			dwarn("User is not logged in")
			return
		}

		if err := r.ParseForm(); err != nil {
			dwarn("Could not parse form, was it empty?: ", err.Error())
			return
		}

		post := Post{
			Title: r.FormValue("Title"),
			// Author: getUserName()
			Content:  r.FormValue("Content"),
			Comments: []Comment{},
		}

		Forums[r.FormValue("Forum")].saveNewPost(post)
	*/
}

// I don't even need to specify which forum because it'll be appended to the post slice of the forum which
// is taken as reciever for method
func (forum Forum) saveNewPost(post Post) {
	// ¯\_(ツ)_/¯
	// Before this I need to decide on DB forum hierarchy
	// Probably just make a encoder and gather path info from map

}

func newComment(w http.ResponseWriter, r *http.Request) {
	// ¯\_(ツ)_/¯
	// Fetch post and append to slice of comments?

}
