package main

import (
	"fmt"
	"net/http"
	"os"
	"os/signal"
)

// HTTP codes
const (
	httpRedirect = 302
	httpNotfound = 404
)

func main() {

	fmt.Println(banner)

	// Init config and check existence of files
	dinfo("Fetching config file...")
	c, err := loadConfig("config.yaml")
	if err != nil {
		panic(err)
	}
	c.makeFolderHierarchy()

	// Start HTTP server
	dinfo("Starting http server...")
	go c.initHTTPServer(c.Port)

	// Account write handler
	go accountWriter(&c.RegSig, &c.Ok)

	// Start STDIN command handler
	go c.commandLineInterface()

	exitSignal := make(chan os.Signal, 1)
	signal.Notify(exitSignal, os.Interrupt)

	<-exitSignal

}

func (s *session) initHTTPServer(p string) {

	http.HandleFunc("/login/", func(w http.ResponseWriter, r *http.Request) {
		http.ServeFile(w, r, "www/index.html")
	})
	// -> temporary redirects
	http.HandleFunc("/loginsend/", s.login)
	http.HandleFunc("/register/", s.register)
	http.HandleFunc("/check/", checkLogin)
	// These path should match hierarchy. Which isn't implemented yet
	http.HandleFunc("/getforums/", s.getForums)
	http.HandleFunc("/new/post/", s.newPost)
	http.HandleFunc("/new/comment/", newComment)
	// <- temporary redirects

	if err := http.ListenAndServe(":"+p, nil); err != nil {
		derr("Http server has shut down! ", err.Error(), "\n")
		panic(err)
	}
}
