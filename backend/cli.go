package main

import (
	"bufio"
	"crypto/sha256"
	"fmt"
	"github.com/fatih/color"
	"github.com/go-yaml/yaml"
	"os"
	"path/filepath"
	"strconv"
	"strings"
)

const banner = `
.---------------------------------------------------.
|  Made With Love By github.com/AlmightyFloppyFish  |
'---------------------------------------------------'
`
const folder = "db/accounts/"

func (s *session) commandLineInterface() {

	scanner := bufio.NewScanner(os.Stdin)

	for {
		// Get STDIN
		scanner.Scan()
		parse := scanner.Bytes()

		if len(parse) == 0 {
			continue
		}

		// Is command?
		if parse[0] != byte('!') {
			clilog("Commands start with !")
			continue
		}
		// It is command
		command := string(parse[1:])
		args := strings.Split(command, " ")

		// Command acctions
		switch args[0] {

		case "ping":
			clilog("pong")

		case "help":
			helpMessages := map[string]string{
				"help": "views this message",
				"ping": "check if CLI is responding",

				"register <name> <pass> <1-3>": "register a new account",
				"dump_user <name/all>":         "displays one or all users",
			}

			// For all messages
			for i, v := range helpMessages {
				var spacing = []byte("                               ")

				// Calculate spacing so all arrows match up
				spacing = spacing[len([]byte(i)):]

				// Print iterated message
				fmt.Println(" !" + color.GreenString(i+string(spacing)+"->  ") + v)
			}

		case "root":
			clilog("Todo")

		case "register":
			if len(args) != 4 {
				clilog("Wrong amount of args")
			} else {

				var u UserServer

				u.Username = args[1]
				hasher := sha256.New()
				hasher.Write([]byte(args[2]))
				u.Password = string(hasher.Sum(nil))

				var err error
				if u.Permission, err = strconv.Atoi(args[3]); err != nil {
					derr(args[3], "is not a number")
					continue
				}
				if u.Permission < 1 || u.Permission > 3 {
					derr("Permission number needs to be 1 (admin), 2 (moderator), or 3 (user)")
					continue
				}

				s.RegSig <- u
				if !<-s.Ok {
					derr("Could not write new account")
				} else {
					clilog("Successfully created account")
				}
			}

		case "dump_user":
			displayUserOrAll(args[1])

		case "delete_user":
			if len(args) != 2 {
				derr("you need to specify which user to delete")
				continue
			}
			os.Remove(folder + args[1])

		default:
			clilog(args[0] + " Command not found")
		}
	}
}

func displayUserOrAll(user string) {
	if len([]byte(user)) == 0 || user == "all" {
		dumpAll()
	} else {
		dumpUser(user)
	}
}

func (u UserServer) print() {
	var perm string
	switch u.Permission {
	case 1:
		perm = "admin"
	case 2:
		perm = "moderator"
	case 3:
		perm = "member"
	}
	var spacing = []byte("                ")

	// Calculate spacing so all arrows match up
	spacing = spacing[len([]byte(perm)):]

	fmt.Println(" " + color.GreenString(perm) + string(spacing) + u.Username)
}

func dumpAll() {

	// Get list of account files
	files, err := filepath.Glob(folder + "*")
	if err != nil {
		derr("Could not look in " + folder)
		return
	}

	for i := range files {

		file, err := os.OpenFile(files[i], os.O_RDONLY, 0777)
		if err != nil {
			derr(err)
			return
		}
		dec := yaml.NewDecoder(file)

		var user UserServer
		if err := dec.Decode(&user); err != nil {
			derr(err)
		}
		user.print()
	}
}

func dumpUser(u string) {

	files, err := filepath.Glob(folder + "*")
	if err != nil {
		derr("Could not look in " + folder)
		return
	}

	for i := range files {

		if files[i] == folder+u {

			file, err := os.OpenFile(files[i], os.O_RDONLY, 0777)
			if err != nil {
				derr(err)
				return
			}
			dec := yaml.NewDecoder(file)

			var user UserServer
			if err := dec.Decode(&user); err != nil {
				derr(err)
			}
			user.print()
		}
	}
}
