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

        endWithColors("Saved ", "working directory", ".", ExitSuccess)

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
    assertIsALocation(loc)
    path, err := os.ReadFile(LocationsDirectory + loc)
    if err != nil {
        die(err.Error())
    }
    cd(string(path))
}

func createLocation(name string, path string) {
	if !isValidName(name) {
        dieNamed(name, "is not a valid location name!")
	}

	if exists(LocationsDirectory + name) {
        dieNamed(name, "already exists!")
	}

	info, err := os.Stat(path)
	if err != nil {
        dieNamed(path, "is not a valid path!")
	} else if !info.IsDir() {
		die("Locations must point to a directory!")
	}

	err = os.WriteFile(LocationsDirectory+name, []byte(path), 0666)
	if err != nil {
		die("Could NOT save location.")
	}

    endWithColors("Saved '", name, "' location.", ExitSuccess);

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
        assertIsALocation(name)
		err := os.Remove(LocationsDirectory + name)
		if err != nil {
			die(err.Error())
		}
	}

	os.Exit(ExitSuccess)

}

func printLocation(name string) {
    assertIsALocation(name)

	path, err := os.ReadFile(LocationsDirectory + os.Args[2])
	if err != nil {
		die(err.Error())
	}
	fmt.Print(string(path))
	os.Exit(ExitSuccess)

}
