package main

import (
	"crypto/sha256"
	"github.com/go-yaml/yaml"
	"github.com/gorilla/securecookie"
	"net/http"
	"os"
)

// Login information should be stored in maps where accounts["username"].password_hash/username/others

// Encrypted cookies, i should look into making these stored on stack
var cookieHandler = securecookie.New(
	securecookie.GenerateRandomKey(64),
	securecookie.GenerateRandomKey(32),
)

const (
	permUser  = 3
	permMod   = 2
	permAdmin = 1
)

// UserClient .
type UserClient struct {
	Username   string
	Password   string
	Permission int
}

// UserServer .
// This might seem weird but the difference is that on UserServer, the Password string is a hash
type UserServer struct {
	Username   string
	Password   string
	Permission int
}

// HTTP handler called at /check, only for debugging purposes
func checkLogin(w http.ResponseWriter, r *http.Request) {
	if isLoggedIn(r) {
		dinfo("You're logged in")
	} else {
		dinfo("You're not logged in")
	}
}

// TODO: Registration approval
func (s session) login(w http.ResponseWriter, r *http.Request) {

	r.ParseForm()

	var u UserClient

	u.Username = r.Form["username"][0]
	u.Password = r.Form["password"][0]
	r.Form.Del("password") // Faster you can clear the better ¯\_(ツ)_/¯

	// Checks if form contains correct amount of values, and values meet minimun length
	// This might seem weird but the difference is that on UserServer, the Password string is a hash
	if len(r.Form) > 2 || len([]rune(u.Username)) <= 1 || len([]rune(u.Password)) <= 1 {
		dwarn("I got some strange login info which doesn't fit the requirements, dismissing")
		return
	}

	// Check against database ( yamlfile? )
	if matchAgainstDatabase(u) {
		setSession(u, w)
		dinfo(u.Username + " Has logged in")
		http.ServeFile(w, r, "www/forums/index.html")
	}
}

func logout(w http.ResponseWriter, r *http.Request) {
	clearSession(w)
	http.Redirect(w, r, "/", httpRedirect) // Might be needed ¯\_(ツ)_/¯

}

func matchAgainstDatabase(u UserClient) bool {

	f, err := os.OpenFile("db/accounts/"+u.Username, os.O_RDONLY, 0777)
	if err != nil {
		if os.IsNotExist(err) {
			return false
		}
		derr("Could not open file " + u.Username + " and it exists!")
		return false
	}

	var SavedUser UserServer

	dec := yaml.NewDecoder(f)
	dec.Decode(&SavedUser)

	// Check if valid password
	hasher := sha256.New()
	hasher.Write([]byte(u.Password))
	if string(hasher.Sum(nil)) == SavedUser.Password {
		// Password correct, log in!
		return true
	}
	// Password incorrect, access denied!
	return false
}

// Fetches user session cookie (automatically decrypts with symetric key)
// Instead of returning bool, i could return a privilidge value to have ranks
func isLoggedIn(r *http.Request) bool {
	cookie, err := r.Cookie("session")
	if err != nil {
		derr(err.Error())
		return false
	}

	var u UserClient
	if err = cookieHandler.Decode("session", cookie.Value, &u); err != nil {
		derr(err.Error())
		return false
	}
	if len([]rune(u.Username)) > 1 {
		return true
	}
	return false
}

// Sends user session cookie (automatically encrypts with symetric key)
func setSession(s UserClient, w http.ResponseWriter) {
	if encoded, err := cookieHandler.Encode("session", s); err == nil {
		cookie := &http.Cookie{
			Name:  "session",
			Value: encoded,
			Path:  "/",
			// Expires after 3 hours
			MaxAge: 10800,
		}
		http.SetCookie(w, cookie)
	} else {
		derr("Could not create cookie", err.Error())
	}
}

func clearSession(w http.ResponseWriter) {
	cookie := &http.Cookie{
		Name:  "session",
		Value: "",
		Path:  "/",
		// Expire instantly
		MaxAge: -1,
	}
	http.SetCookie(w, cookie)
}
