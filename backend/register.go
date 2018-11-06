package main

import (
	"crypto/sha256"
	"github.com/go-yaml/yaml"
	"net/http"
	"os"
)

// TODO: I need to add manual approval and also something to add permission levels
// TODO: Proper error handling
func (s *session) register(w http.ResponseWriter, r *http.Request) {
	r.ParseForm()

	var u UserServer

	if username, ok := r.Form["username"]; ok {
		u.Username = username[0]
	} else {
		// invalid username
		return
	}

	// Set permission to "user"
	u.Permission = permUser

	// Parse for valid input
	u.Password = r.Form["password"][0]
	if !u.isValid() {
		dwarn("User tried to enter with a to short/long username/password")
		return
	}

	if password, ok := r.Form["password"]; ok {
		hasher := sha256.New()
		hasher.Write([]byte(password[0]))
		u.Password = string(hasher.Sum(nil))
	} else {
		// invalid password
		return
	}

	s.RegSig <- u
	if !<-s.Ok {
		// Could not register account
		derr("Could not register user " + u.Username)
		return
	}

	// Successfull registration
	dinfo("Registered user " + u.Username)
	return
}

// Waits for signal to write, writes info to db/<username>.yaml
func accountWriter(RegSig *chan UserServer, Ok *chan bool) {

	accPath := "db/accounts/"

	for {
		u := <-*RegSig

		f, err := os.Create(accPath + u.Username)
		if err != nil {
			derr("Could not create user account file in " + accPath + u.Username)
			*Ok <- false
		}

		enc := yaml.NewEncoder(f)
		if err := enc.Encode(u); err != nil {
			derr("Could not write user " + u.Username + "; " + err.Error())
			*Ok <- false
		} else {
			*Ok <- true
		}
	}
}

func (u UserServer) isValid() bool {
	uLen := len([]byte(u.Username))
	pLen := len([]byte(u.Password))

	if uLen > 1 && uLen < 17 && pLen > 3 && pLen < 100 {
		return true
	}
	return false
}
