package main

import (
	"fmt"
	"os"
	"regexp"
)

func die(str string) {
	fmt.Print(str)
	os.Exit(ExitError)
}

func dieNamed(name string, msg string) {
    dieColored("'", name, "' " + msg)
}

func dieColored(begin string, name string, end string) {
    endWithColors(begin, name, end, ExitError)
}

func endWithColors(begin string, name string, end string, code int) {
    fmt.Print(begin)
    bold()
    fmt.Print(name)
    clean()
    fmt.Print(end)
    os.Exit(code)
}

func bold() {
    if !BeingPiped {
        fmt.Print("\033[1m")
    }
}

func clean() {
    if !BeingPiped {
        fmt.Print("\033[0m")
    }
}

func color() {
    if !BeingPiped {
        fmt.Print("\033[34m")
    }
}

func printOneLocation(name string, path string) {
    bold()
    fmt.Printf("%v", name)
    color()
    fmt.Printf(" -> ")
    clean()
    fmt.Printf("%v\n", path)
}

func cd(where string) {
	fmt.Print(where)
	os.Exit(ExitCd)
}

func exists(path string) bool {
	if _, err := os.Stat(path); err != nil {
		if os.IsNotExist(err) {
			return false
		} else {
			die(err.Error())
		}
	}
	return true
}

func printHelp() {
    bold()
	fmt.Println("TP command - help message")
    clean()
	fmt.Println("tp -l                   => list saved locations")
	fmt.Println("tp -c {name} [path]     => create location '{name}' pointing to [path]")
	fmt.Println("tp -r [saved_location]  => remove the specified location")
	fmt.Println("tp -p [location]        => print location instead of changing directory")
	fmt.Println("tp -h                   => outputs help message")
}

func isValidName(loc string) bool {
	regex := `^(.*/)|(\..*)$`
	match, err := regexp.MatchString(regex, loc)
	if err != nil {
		die(err.Error())
	}
	return !match
}

func assertIsALocation(name string) {
    if !exists(LocationsDirectory + name) {
        dieNamed(name, "is not a saved location!")
    }
}

