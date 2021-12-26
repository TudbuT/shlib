# Strictly POSIX script for running a RW process
# Include using `. <this script file>` and remember
# to set $pargs to your command / args first
# THIS FILE MAY ONLY BE INCLUDED ONCE PER SHELL!
#
# Made by TudbuT and licensed under GPL version 3

PID=$$
touch "$PID.out" "$PID.in" "$PID.in.buf"
tail -f "$PID.out" | $pargs > "$PID.in.buf" &
ncpid=$!
tail -fn+1 "$PID.in.buf" | while true ; do
    read -r line
    echo "$line" >> "$PID.in"
done > /dev/null 2>&1 &
readerpid=$!
(
    while kill -0 "$PID" ; do 
        sleep 0.1
    done
    # Main process got killed
    sleep 0.1
    kill "$ncpid" "$readerpid"
    sleep 0.1
    rm -rf "$PID.in" "$PID.in.buf" "$PID.out"
) > /dev/null 2>&1 & 
writeln() {
    echo "$@" >> "$PID.out"
}
write() {
    echo -n "$@" >> "$PID.out"
}
readln() {
    tail -fn+1 "$PID.in" | head -n1 2> /dev/null
    tail -n+2 "$PID.in" > "$PID.in.tmp" 2> /dev/null
    mv "$PID.in.tmp" "$PID.in"
}
