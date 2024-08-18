package main

import (
	"fmt"
	"io/fs"
	"os"
	"path/filepath"
)

func pwd() {
	// If no temporary location saved
	if !exists(TemporaryFile) {
		// Get the wd
		wd, err := os.Getwd()
		if err != nil {
			die(err.Error())
		}
		// Save it to the file
		err = os.WriteFile(TemporaryFile, []byte(wd), 0666)
		if err != nil {
			die(err.Error())
		}
		fmt.Printf("Saved working directory!")
		os.Exit(ExitSuccess)
	} else {
		path, err := os.ReadFile(TemporaryFile)
		if err != nil {
			die(err.Error())
		}

		err = os.Remove(TemporaryFile)
		if err != nil {
			die(err.Error())
		}
		cd(string(path))
	}
}

func goLocation(loc string) {
	if exists(LocationsDirectory + loc) {
		path, err := os.ReadFile(LocationsDirectory + loc)
		if err != nil {
			die(err.Error())
		}
		cd(string(path))
	} else {
		die("'" + loc + "' is not a saved location!")
	}
}

func createLocation(name string, path string) {
	if !isValidName(name) {
		die("'" + name + "' is not a valid location name!")
	}

	if exists(LocationsDirectory + name) {
		die("'" + name + "' already exists!")
	}

	info, err := os.Stat(path)
	if err != nil {
		die("'" + path + "' is not a valid path!")
	} else if !info.IsDir() {
		die("All locations must point to a directory!")
	}

	err = os.WriteFile(LocationsDirectory+name, []byte(path), 0666)
	if err != nil {
		die("Could NOT save location")
	}

	os.Exit(ExitSuccess)

}

func listLocations() {
	err := filepath.WalkDir(LocationsDirectory, func(location string, d fs.DirEntry, err error) error {
		if err != nil {
			die(err.Error())
		}
		if !d.IsDir() {
			path, err := os.ReadFile(location)
			if err != nil {
				die(err.Error())
			}
			printOneLocation(filepath.Base(location), string(path))
		}
		return nil
	})
	if err != nil {
		die(err.Error())
	}

	if exists(TemporaryFile) {
		path, err := os.ReadFile(TemporaryFile)
		if err != nil {
			die(err.Error())
		}
		printOneLocation("\n[Temporary]", string(path))
	}

	os.Exit(ExitSuccess)

}

func removeLocation(names []string) {
	for _, name := range names {
		if !exists(LocationsDirectory + name) {
			die("'" + name + "' is not a saved location!")
		}
		err := os.Remove(LocationsDirectory + name)
		if err != nil {
			die(err.Error())
		}
	}

	os.Exit(ExitSuccess)

}

func printLocation(name string) {
	if !exists(LocationsDirectory + name) {
		die("'" + name + "' is not a saved location!")
	}

	path, err := os.ReadFile(LocationsDirectory + os.Args[2])
	if err != nil {
		die(err.Error())
	}
	fmt.Print(string(path))
	os.Exit(ExitSuccess)

}
