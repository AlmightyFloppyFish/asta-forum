package main

import (
	"github.com/go-yaml/yaml"
	"os"
)

type session struct {
	Port                string
	ViewRequiresAccount bool
	RegNeedsApproval    bool
	RegSig              chan UserServer
	Ok                  chan bool

	Forums map[string]Forum
}

func loadConfig(location string) (session, error) {

	// Does config exist? If not create default
	if _, err := os.Stat(location); os.IsNotExist(err) {
		createInitialConfig(location)
	}

	// Allocate stack space
	var conf session
	yamlFile := new(os.File)

	// Open config file
	yamlFile, err := os.OpenFile(location, os.O_RDONLY, 0777)
	if err != nil {
		return conf, err
	}
	dec := yaml.NewDecoder(yamlFile)
	err = dec.Decode(&conf)

	// Add channels to session
	conf.RegSig = make(chan UserServer)
	conf.Ok = make(chan bool)

	return conf, nil
}

// Creates default config
// this function doesn't check if current config exists
func createInitialConfig(location string) error {

	forums := make(map[string]Forum)

	forums["Announcements"] = Forum{
		Title:     "Announcements",
		Priority:  first,
		Path:      "db/forums/announcements/",
		SubForums: []string{"Official", "Other"},
	}
	forums["General"] = Forum{
		Title:     "General",
		Priority:  second,
		Path:      "db/forums/general/",
		SubForums: []string{"Uppcomming Events", "Discussion", "Other"},
	}

	var defaultConfig = session{
		Port:                "4444",
		ViewRequiresAccount: true,
		RegNeedsApproval:    false,

		Forums: forums,
	}

	f, err := os.Create(location)
	if err != nil {
		return err
	}

	enc := yaml.NewEncoder(f)
	err = enc.Encode(defaultConfig)
	if err != nil {
		return err
	}
	return nil
}

// Detects missing forum / subforum folders using config
func (s session) makeFolderHierarchy() {

	for _, v := range s.Forums {
		if _, err := os.Stat(v.Path); os.IsNotExist(err) {
			dwarn("Couldn't find " + v.Title + " in db, creating...")

			err := os.Mkdir(v.Path, 0777)
			if err != nil {
				panic(err.Error())
			}

			for _, v2 := range v.SubForums {
				os.Mkdir(v.Path+v2, 0777)
			}

		} else {
			dinfo("Found " + v.Title + " in db")

			for _, v2 := range v.SubForums {
				if _, err := os.Stat(v.Path + v2); os.IsNotExist(err) {
					dwarn("Missing subforum in " + v.Title + ", creating...")
					os.Mkdir(v.Path+v2, 0777)
				}
			}
		}
	}

}
