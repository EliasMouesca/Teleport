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

func printOneLocation(name string, path string) {
	fmt.Printf("%v -> %v\n", name, path)
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
	fmt.Println("TP command - help message")
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
