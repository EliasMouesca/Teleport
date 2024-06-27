function tp_create_location -a NAME WHERE LOCATION

    set DIR "$WHERE/$NAME"

    if not test -d $LOCATION
        echo -n "'"
        tput bold
        echo -n "$LOCATION"
        tput sgr0
        echo "' does not exist!"
        return 1
    end

    if string match -q '*/*' "$NAME"
        echo 'Location names can not contain a slash! (\'/\')'
        return 1
    end

    if test (echo $NAME | cut -c1-1)  = '.'
        echo 'Location names can not begin with a dot (\'.\')'
        return 1
    end

    touch $DIR

    if test (echo $LOCATION | cut -c1-1)  = '/'
        echo "$LOCATION" > $DIR
    else
        echo "$PWD/$LOCATION" > $DIR
    end

    echo -n "Saved '"
    tput bold
    echo -n "$NAME"
    tput sgr0
    echo "' location."

end

