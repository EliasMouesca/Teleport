# __ tp __

# The dir where the locations are stored, may be changed
set TP_DIR "/home/$USER/.config/tp"

function tp_go_location -a NAME
    set DIR "$TP_DIR/$NAME"

    if test -f $DIR
        cd (cat $DIR)
        return 0
    else
        echo "'$NAME' is not a saved location!"
        return 1
    end
end

function tp_create_location -a NAME WHERE LOCATION

    set DIR "$WHERE/$NAME"

    if not test -d $LOCATION
        echo "'$LOCATION' directory does not exist!"
        return 1
    end

    if test (echo $NAME | cut -c1-1)  = '/'
        echo 'Location names can not begin with a slash (\'/\')'
        return 1
    end

    if test (echo $NAME | cut -c1-1)  = '.'
        echo 'Location names can not begin with a dot (\'.\')'
        return 1
    end

    if test (echo $NAME | rev | cut -c1-1) = '/'
        echo 'Location names can not end with a slash (\'/\')'
        return 1
    end

    touch $DIR

    if test (echo $LOCATION | cut -c1-1)  = '/'
        echo "$LOCATION" > $DIR
    else
        echo "$PWD/$LOCATION" > $DIR
    end

    echo "Saved '$NAME' location."

end

function tp_pwd

    set DIR "/tmp/tp"

    # If the file exists, go there, if not, save it temporarily
    if test -f $DIR
        cd (cat $DIR)
        rm $DIR
    else
        touch /tmp/tp
        pwd > /tmp/tp
        echo 'Saved working directory.'
    end

end


function tp

    # If the config directory does not exist, create it.
    if not test -d $TP_DIR
        mkdir -p $TP_DIR
    end
    
    # If no arguments were passed...
    if test (count $argv) -eq 0
        tp_pwd
    else

        # Check if the first letter is a '-', it means its a parameter
        if test (echo $argv[1] | cut -c1-1)  = '-'

            # tp -l => list saved locations
            if test $argv[1] = '-l'
                for location in (/usr/bin/ls $TP_DIR);
                    tput bold
                    echo -n "$location "
                    tput sgr0
                    echo \~\> (cat $TP_DIR/$location);
                end

                if test -f /tmp/tp
                    echo
                    tput bold
                    echo -n '[temporary]'
                    tput sgr0
                    echo ' ~>' (cat /tmp/tp)
                end

            # tp -r [saved_location] => remove the specified location or the temporary if non are given
            else if test $argv[1] = '-r'
                if test (count $argv) -eq 1
                    if test -f /tmp/tp
                        rm /tmp/tp
                    end
                else
                    set return 0

                    for arg in $argv
                        if not test $arg = $argv[1]
                            set LOCATION "$TP_DIR/$arg"
                            if test -f $LOCATION
                                rm $LOCATION
                            else
                                echo "There is no saved location named '$arg'."
                                set return (math $return + 1)
                            end
                        end
                    end

                    return $return

                end

            # tp -c {name} [path] => create a new location with {name} and {path}, if no path is given, the working directory will be used
            else if test $argv[1] = '-c'
                if test (count $argv) -eq 3
                    tp_create_location $argv[2] $TP_DIR $argv[3]
                else if test (count $argv) -eq 2
                    tp_create_location $argv[2] $TP_DIR $PWD
                else
                    echo 'Bad usage, try running \'tp -h\''
                    return 1
                end

            # tp -p {location} => print location instead of chaning directory
            else if test $argv[1] = '-p'
                if test (count $argv) -eq 1
                    echo 'You must specify the name of the location!'
                    return 1
                else
                    set DIR "$TP_DIR/$argv[2]"

                    if test -f $DIR
                        /usr/bin/cat $DIR
                        return 0
                    else
                        echo "'$argv[2]' is not a saved location!"
                        return 1
                    end
                end


            # tp -h => outputs help message
            else if test $argv[1] = '-h'
                echo $HELP_MESSAGE
            else if test $argv[1] = '--help'
                echo $HELP_MESSAGE
            else
                echo "Option '$argv[1]' not recognized."
                return 1
            end

        else
            tp_go_location $argv[1]
        end

    end

end

set HELP_MESSAGE "-- TP command - help message --

tp -l                   => list saved locations
tp -c {name} [path]     => create a new location with {name} and {path}, if no path is given, the working directory will be used
tp -r [saved_location]  => remove the specified location or the temporary if non are given
tp -p {location}        => print location instead of changing directory
tp -h                   => outputs help message
"

