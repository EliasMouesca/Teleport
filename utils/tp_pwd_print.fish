function tp_pwd_print

    if test -f $TP_TMP
        /usr/bin/cat $TP_TMP
    else
        echo 'There is no temporary location saved.'
    end

end

