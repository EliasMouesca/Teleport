package main

import (
	"fmt"
	"os"
	"os/user"
)

// 0 = cd to there, 1 = Print but no error, 2 = Print with error
const (
	ExitCd = iota
	ExitSuccess
	ExitError
)

var (
	LocationsDirectory string
	TemporaryFile      string = "/tmp/tp"
    BeingPiped         bool
)

func main() {
    if os.Getenv("TP_BEING_PIPED") == "1" {
        BeingPiped = true
    } else {
        BeingPiped = false
    }

	currentUser, err := user.Current()
	if err != nil {
		die("Failed to get user!")
	}

	LocationsDirectory = currentUser.HomeDir + "/.config/Teleport/locations/"

	if !exists(LocationsDirectory) {
		err := os.MkdirAll(LocationsDirectory, 0700)
		if err != nil {
			die("Failed to create locations directory: " + err.Error())
		}
	}


	// Check if LocationsDirectory exists
	if _, err := os.Stat(LocationsDirectory); err != nil {
		// If not
		if os.IsNotExist(err) {
			// Create it
			err := os.Mkdir(LocationsDirectory, 0766)
			if err != nil {
				die("Could not create locations directory.")
			}
		} else {
			die("Failed to check for locations directory.")
		}
	}

	if len(os.Args) <= 1 {
		pwd()
	}

	if os.Args[1][0] != '-' {
		goLocation(os.Args[1])
	}

	switch os.Args[1] {
	case "-c":
		switch n := len(os.Args); n {
		case 2:
			die("Bad usage, try 'tp -h'")
		case 3:
			wd, err := os.Getwd()
			if err != nil {
				die("Could not get working directory :(")
			}
			createLocation(os.Args[2], wd)
		case 4:
			createLocation(os.Args[2], os.Args[3])
		default:
			die("Bad usage, try 'tp -h'")

		}

	case "-l":
		listLocations()

	case "-r":
		if len(os.Args) > 2 {
			removeLocation(os.Args[2:])
		} else {
            if exists(TemporaryFile) {
                err := os.Remove(TemporaryFile)
                if err != nil {
                    die(err.Error())
                }
                os.Exit(ExitSuccess)
            }
		}

	case "-p":
		if len(os.Args) <= 2 {
			if exists(TemporaryFile) {
				temp, err := os.ReadFile(TemporaryFile)
				if err != nil {
					die(err.Error())
				}
				fmt.Print(string(temp))
				os.Exit(ExitSuccess)
			} else {
				os.Exit(ExitError)
			}
		}

		printLocation(os.Args[2])

	case "-h":
		printHelp()
		os.Exit(ExitSuccess)

	default:
		printHelp()
		os.Exit(ExitError)
	}

    os.Exit(ExitSuccess)

}
