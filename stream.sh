# Strictly POSIX script for running a RW process
# Include using `. <this script file>` and remember
# to set $pargs to your command / args first
# THIS FILE MAY ONLY BE INCLUDED ONCE PER SHELL!
#
# Made by TudbuT and licensed under GPL version 3

PID=$$
touch "$PID.out" "$PID.in"
tail -f "$PID.out" | $(echo $pargs) | (
    while true ; do
        read -r line || exit
        [ "$line" = '' ] && continue 
        echo "$line" >> "$PID.in"
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
    rm -rf "$PID.in" "$PID.out"
) > /dev/null 2>&1 & 
write() {
    echo -n "$@" >> "$PID.out"
}
writee() {
    echo -ne "$@" >> "$PID.out"
}
writeln() {
    echo "$@" >> "$PID.out"
}
writelne() {
    echo -e "$@" >> "$PID.out"
}
readln() {
    tail -fn+1 "$PID.in" | head -n1 2> /dev/null
    tail -n+2 "$PID.in" > "$PID.in.tmp" 2> /dev/null
    mv "$PID.in.tmp" "$PID.in" 2> /dev/null
}
