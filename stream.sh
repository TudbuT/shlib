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
    touch "$INSTANCE.out" "$INSTANCE.in"
    tail -f "$INSTANCE.out" | $@ | (
        while true ; do
            read -r line || exit
            [ "$line" = '' ] && continue 
            echo "$line" >> "$INSTANCE.in"
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
        rm -rf "$INSTANCE.in" "$INSTANCE.out"
    ) > /dev/null 2>&1 & 
}
write() {
    echo -n "$@" >> "$INSTANCE.out"
}
writee() {
    echo -ne "$@" >> "$INSTANCE.out"
}
writeln() {
    echo "$@" >> "$INSTANCE.out"
}
writelne() {
    echo -e "$@" >> "$INSTANCE.out"
}
readln() {
    tail -fn+1 "$INSTANCE.in" | head -n1 2> /dev/null
    tail -n+2 "$INSTANCE.in" > "$INSTANCE.in.tmp" 2> /dev/null
    mv "$INSTANCE.in.tmp" "$INSTANCE.in" 2> /dev/null
}
