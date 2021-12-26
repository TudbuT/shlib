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
    touch "$TMPDIR/$INSTANCE.out" "$TMPDIR/$INSTANCE.in"
    tail -f "$TMPDIR/$INSTANCE.out" | $@ | (
        while true ; do
            read -r line || exit
            [ "$line" = '' ] && continue 
            echo "$line" >> "$TMPDIR/$INSTANCE.in"
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
        rm -rf "$TMPDIR/$INSTANCE.in" "$TMPDIR/$INSTANCE.out"
    ) > /dev/null 2>&1 & 
}
write() {
    echo -n "$@" >> "$TMPDIR/$INSTANCE.out"
}
writee() {
    echo -ne "$@" >> "$TMPDIR/$INSTANCE.out"
}
writeln() {
    echo "$@" >> "$TMPDIR/$INSTANCE.out"
}
writelne() {
    echo -e "$@" >> "$TMPDIR/$INSTANCE.out"
}
readln() {
    tail -fn+1 "$TMPDIR/$INSTANCE.in" | head -n1 2> /dev/null
    tail -n+2 "$TMPDIR/$INSTANCE.in" > "$TMPDIR/$INSTANCE.in.tmp" 2> /dev/null
    mv "$TMPDIR/$INSTANCE.in.tmp" "$TMPDIR/$INSTANCE.in" 2> /dev/null
}
