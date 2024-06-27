function tp_pwd
    # If the file exists, go there, if not, save it temporarily
    if test -f $TP_TMP
        cd (cat $TP_TMP)
        rm $TP_TMP
    else
        touch $TP_TMP
        pwd > $TP_TMP
        echo -n 'Saved '
        tput bold
        echo -n 'working directory'
        tput sgr0
        echo '.'
    end

end

