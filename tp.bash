#!/bin/bash

# The dir where the locations are stored, may be changed
TP_DIR="/home/$USER/.config/tp"

tp_go_location() {
    DIR="$TP_DIR/$1"

    if [ -f "$DIR" ]; then
        cd "$(cat "$DIR")" || return 1
        return 0
    else
        echo "'$1' is not a saved location!"
        return 1
    fi
}

tp_create_location() {
    DIR="$2/$1"

    if [ ! -d "$3" ]; then
        echo "'$3' directory does not exist!"
        return 1
    fi

    if [ "$(echo "$1" | cut -c1-1)" = '/' ]; then
        echo 'Location names can not begin with a slash (\'/')'
        return 1
    fi

    if [ "$(echo "$1" | cut -c1-1)" = '.' ]; then
        echo 'Location names can not begin with a dot (\'.')'
        return 1
    fi

    if [ "$(echo "$1" | rev | cut -c1-1)" = '/' ]; then
        echo 'Location names can not end with a slash (\'/')'
        return 1
    fi

    touch "$DIR"

    if [ "$(echo "$3" | cut -c1-1)" = '/' ]; then
        echo "$3" > "$DIR"
    else
        echo "$PWD/$3" > "$DIR"
    fi

    echo "Saved '$1' location."
}

tp_pwd() {
    DIR="/tmp/tp"

    # If the file exists, go there, if not, save it temporarily
    if [ -f "$DIR" ]; then
        cd "$(cat "$DIR")" || return 1
        rm "$DIR"
    else
        touch /tmp/tp
        pwd > /tmp/tp
        echo 'Saved working directory.'
    fi
}

tp() {
    # If the config directory does not exist, create it.
    if [ ! -d "$TP_DIR" ]; then
        mkdir -p "$TP_DIR"
    fi
    
    # If no arguments were passed...
    if [ "$#" -eq 0 ]; then
        tp_pwd
    else
        # Check if the first letter is a '-', it means it's a parameter
        if [ "$(echo "${1}" | cut -c1-1)" = '-' ]; then
            # tp -l => list saved locations
            if [ "$1" = '-l' ]; then
                for location in $(ls "$TP_DIR"); do
                    tput bold
                    echo -n "$location "
                    tput sgr0
                    echo '~>' "$(cat "$TP_DIR/$location")"
                done

                if [ -f /tmp/tp ]; then
                    echo
                    tput bold
                    echo -n '[temporary]'
                    tput sgr0
                    echo " ~> $(cat /tmp/tp)"
                fi
            # tp -r [saved_location] => remove the specified location or the temporary if none are given
            elif [ "$1" = '-r' ]; then
                if [ "$#" -eq 1 ]; then
                    if [ -f /tmp/tp ]; then
                        rm /tmp/tp
                    fi
                else
                    return_val=0

                    for arg in "$@"; do
                        if [ "$arg" != "${1}" ]; then
                            LOCATION="$TP_DIR/$arg"
                            if [ -f "$LOCATION" ]; then
                                rm "$LOCATION"
                            else
                                echo "There is no saved location named '$arg'."
                                return_val=$((return_val + 1))
                            fi
                        fi
                    done

                    return $return_val
                fi
            # tp -c {name} [path] => create a new location with {name} and {path}, if no path is given, the working directory will be used
            elif [ "$1" = '-c' ]; then
                if [ "$#" -eq 3 ]; then
                    tp_create_location "$2" "$TP_DIR" "$3"
                elif [ "$#" -eq 2 ]; then
                    tp_create_location "$2" "$TP_DIR" "$PWD"
                else
                    echo "Bad usage, try running 'tp -h'"
                    return 1
                fi
            # tp -p {location} => print location instead of changing directory
            elif [ "$1" = '-p' ]; then
                if [ "$#" -eq 1 ]; then
                    echo 'You must specify the name of the location!'
                    return 1
                else
                    DIR="$TP_DIR/$2"

                    if [ -f "$DIR" ]; then
                        cat "$DIR"
                        return 0
                    else
                        echo "'$2' is not a saved location!"
                        return 1
                    fi
                fi
            # tp -h => outputs help message
            elif [ "$1" = '-h' ] || [ "$1" = '--help' ]; then
                echo "$HELP_MESSAGE"
            else
                echo "Option '$1' not recognized."
                return 1
            fi
        else
            tp_go_location "$1"
        fi
    fi
}

HELP_MESSAGE="-- TP command - help message --

tp -l                   => list saved locations
tp -c {name} [path]     => create a new location with {name} and {path}, if no path is given, the working directory will be used
tp -r [saved_location]  => remove the specified location or the temporary if none are given
tp -p {location}        => print location instead of changing directory
tp -h                   => outputs help message
"

