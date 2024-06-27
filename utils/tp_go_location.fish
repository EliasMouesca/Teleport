function tp_go_location -a NAME
    set DIR "$TP_LOCATIONS_DIR/$NAME"

    if test -f $DIR
        cd (cat $DIR)
        return 0
    else
        echo -n "'"
        tput bold
        echo -n "$NAME"
        tput sgr0
        echo "' is not a saved location!"
        return 1
    end
end

