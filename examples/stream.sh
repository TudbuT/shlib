# Example script for TudbuT/shlib/stream.sh

# Change this path if necessary
export SHLIB=".."


# Separating is required so the two streams do not interfere
. $SHLIB/separate.sh
# Set all separations to fork instead of staying
FORK=1

# Server
sep '
    # Set command to stream: netcat -lp 4400
    pargs="netcat -lp 4400"
    # Import stream.sh
    . $SHLIB/stream.sh
    
    while true; do
        line="$(readln)"
        case "$line" in
        "BEGIN")
            echo "SERVER: Connection found"
            writeln "This is working!"
            ;;
        "END")
            echo "SERVER: Connection stopped"
            ;;
        esac
        unset line
    done
'


# Client:

# Wait for Server thread
sleep 0.1

# Set command to stream: netcat localhost 4400
pargs="netcat localhost 4400"
# Import stream.sh
. $SHLIB/stream.sh
sleep 0.1
writeln BEGIN
readln
writeln END
