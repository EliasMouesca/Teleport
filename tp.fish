# __ tp __
set TP_DIR "/home/$USER/opt/Teleport"
# The dir where the locations are stored, may be changed
set TP_LOCATIONS_DIR "$TP_DIR/locations"
set TP_TMP "/tmp/tp"

for sourceFile in $TP_DIR/utils/*
    source $sourceFile
end

# Register the completion to fish
complete -c tp -f -a "(basename -a (/usr/bin/ls $TP_LOCATIONS_DIR/*))"

function tp
    # If the config directory does not exist, create it.
    if not test -d $TP_LOCATIONS_DIR
        mkdir -p $TP_LOCATIONS_DIR
    end
    
    # If no arguments were passed...
    if test (count $argv) -eq 0
        tp_pwd
    else
        # Check if the first letter is a '-', that means it's a parameter
        if not test (echo $argv[1] | cut -c1-1)  = '-'
            tp_go_location $argv[1]
        else
            switch $argv[1]
            # tp -l => list saved locations
            case '-l'
                for location in (/usr/bin/ls $TP_LOCATIONS_DIR);
                    tput bold
                    echo -n "$location "
                    tput setaf 8; echo -n "-> " 
                    tput sgr0
                    echo (/usr/bin/cat $TP_LOCATIONS_DIR/$location);
                end

                if test -f /tmp/tp
                    echo
                    tput bold
                    echo -n '[temporary]'
                    tput sgr0
                    echo ' ->' (cat /tmp/tp)
                end

            # tp -r [saved_location] => remove the specified location or the temporary if none are given
            case '-r'
                if test (count $argv) -eq 1
                    if test -f /tmp/tp
                        rm /tmp/tp
                    end
                else
                    set return 0

                    for arg in $argv
                        if not test $arg = $argv[1]
                            set LOCATION "$TP_LOCATIONS_DIR/$arg"
                            if test -f $LOCATION
                                rm $LOCATION
                            else
                                echo -n "There is no saved location named '"
                                tput bold
                                echo -n "$arg"
                                tput sgr0
                                echo "'."
                                set return (math $return + 1)
                            end
                        end
                    end

                    return $return

                end

            # tp -c {name} [path] => create a new location with {name} and {path}, if no path is given, the working directory will be used
            case '-c'
                if test (count $argv) -eq 3
                    tp_create_location $argv[2] $TP_LOCATIONS_DIR $argv[3]
                else if test (count $argv) -eq 2
                    tp_create_location $argv[2] $TP_LOCATIONS_DIR $PWD
                else
                    echo -n "Bad usage, try running '"
                    tput bold
                    echo -n "tp -h"
                    tput sgr0
                    echo "'"
                    return 1
                end

            # tp -p {location} => print location instead of changing directory
            case '-p'
                if test (count $argv) -eq 1
                    tp_pwd_print
                else
                    set DIR "$TP_LOCATIONS_DIR/$argv[2]"

                    if test -f $DIR
                        /usr/bin/cat $DIR
                        return 0
                    else
                        echo "'$argv[2]' is not a saved location!"
                        return 1
                    end
                end


            # tp -h => outputs help message
            case '-h' '--help'
                tput bold
                echo $TP_HELP_HEADER
                tput sgr0
                echo $TP_HELP_MESSAGE
            case '*'
                echo "Option '$argv[1]' not recognized."
                return 1
            
            end # End switch

        end # End if not a parameter

    end # End if no arguments passed

end

# Erase helper functions
#functions -e tp_create_location tp_go_location tp_pwd

set TP_HELP_HEADER "TP command - help message"
set TP_HELP_MESSAGE "
tp -l                   => list saved locations
tp -c {name} [path]     => create a new location with {name} and {path}, if no path is given, the working directory will be used
tp -r [saved_location]  => remove the specified location or the temporary if non are given
tp -p [location]        => print location instead of changing directory
tp -h                   => outputs help message"

