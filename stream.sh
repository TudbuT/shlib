# Strictly POSIX script for running a RW process
# Include using `. <this script file>` 
# THIS FILE MAY ONLY BE INCLUDED ONCE PER SHELL!
#
# Made by TudbuT and licensed under GPL version 3

PID=$$
stream() {
    # Generate instance ID
    echo -n '' &
    INSTANCE=$!

    # Initialize instance
    touch "/tmp/$INSTANCE.out" "/tmp/$INSTANCE.in"
    tail -f "/tmp/$INSTANCE.out" | $@ | (
        while true ; do
            read -r line || exit
            [ "$line" = '' ] && continue 
            echo "$line" >> "/tmp/$INSTANCE.in"
            unset line
        done 
    ) > /dev/null 2>&1 &
    ncpid=$!
    (
        while kill -0 "$PID" "$ncpid" ; do 
            sleep 0.1
        done
        # Main process got killed
        kill "$PID" "$ncpid"
        rm -rf "/tmp/$INSTANCE.in" "/tmp/$INSTANCE.out"
    ) > /dev/null 2>&1 & 
}
write() {
    echo -n "$@" >> "/tmp/$INSTANCE.out"
}
writee() {
    echo -ne "$@" >> "/tmp/$INSTANCE.out"
}
writeln() {
    echo "$@" >> "/tmp/$INSTANCE.out"
}
writelne() {
    echo -e "$@" >> "/tmp/$INSTANCE.out"
}
readln() {
    tail -fn+1 "/tmp/$INSTANCE.in" | head -n1 2> /dev/null
    tail -n+2 "/tmp/$INSTANCE.in" > "/tmp/$INSTANCE.in.tmp" 2> /dev/null
    mv "/tmp/$INSTANCE.in.tmp" "/tmp/$INSTANCE.in" 2> /dev/null
}
