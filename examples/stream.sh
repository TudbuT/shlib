# Example script for TudbuT/shlib/stream.sh

# Change this path if necessary
export SHLIB=".."

# Import stream.sh
. $SHLIB/stream.sh


# Start server in separate thread:
(
    # Stream netcat -lp 4400
    stream netcat -lp 4400
    
    while true; do
        line="$(readln)"
        case "$line" in
        "BEGIN")
            echo "SERVER: Connection found"
            writeln "This is working!"
            ;;
        "END")
            echo "SERVER: Connection stopped"
            exit
            ;;
        esac
        unset line
    done
) &


# Client:

# Wait for Server thread
sleep 0.1

# Stream netcat localhost 4400
stream netcat localhost 4400
sleep 0.1
writeln BEGIN
readln
writeln END



