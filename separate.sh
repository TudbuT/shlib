# Strictly POSIX script for creating another script instance
# with different environment (for example, to include a
# script twice)
# To add variables, EXPORT THEM!
# Include using `. <this script file>` 
# THIS FILE MAY ONLY BE INCLUDED ONCE PER SHELL
#
# Made by TudbuT and licensed under GPL version 3

export separate_seps=0
sep() {
    (( separate_seps++ ))
    export separate_seps
    name="/tmp/$$_$separate_seps.sep"
    echo "$@" > $name
    [ '$FORK' = '' ] &&
    ($SHELL $name || true) ||
    $SHELL $name &
}

