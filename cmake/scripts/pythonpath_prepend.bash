#!/usr/bin/env bash

# This scripts takes one arguments and try to insert it
# into PYTHONPATH env variable in a way that makes sense for ROS workspaces
# and returns the new PYTHONPATH.
# A second argument can be passed, to indicate which workspace paths we want to be in front of.

if [[ $# -gt 2 || $# -lt 1 ]]; then
    echo "Usage : pythonpath_prepend <arg_path> [<arg_ws>]"
    exit 127
fi
if [[ $# -eq 2 ]]; then
    # The workspace in front of which we need to prepend
    WS="$2"
fi
if [[ $# -ge 1 ]]; then
    # The path to insert
    ARG="$1"
fi

# TODO : make this a sh script for increased portability...

# if ARG exists
if [ -d "$ARG" ]; then
    # if PYTHONPATH is empty
    if [ -z "$PYTHONPATH" ]; then
        PYTHONPATH="$ARG"
    else
        # we move it from tail to head of workspace paths in PATH list
        IFS=':' read -ra PP_ARRAY <<< "${PYTHONPATH}"
        SUFFXPATH=""
        PYTHONPATH=""
        # careful we are starting from the back of the list here...
        for (( idx=${#PP_ARRAY[@]}-1 ; idx>=0 ; idx-- )); do
            p="${PP_ARRAY[idx]}"
            #echo $p
            if [ -z "${PYTHONPATH:-}" ]; then
                #echo "=> building suffix"
                if [ "$p" != "$ARG" ]; then
                    [ -z "${SUFFXPATH:-}" ] && SUFFXPATH="$p" || SUFFXPATH="$p":"${SUFFXPATH}"
                    #echo "SUFFXPATH: $SUFFXPATH"
                fi
                if [[ "$p" == "$WS" || $idx -eq 0 ]]; then
                    #echo "that's it, we are in front of the path we care about"
                    [ -z "${SUFFXPATH:-}" ] && PYTHONPATH="$ARG" || PYTHONPATH="$ARG":"$SUFFXPATH"
                    #echo "PYTHONPATH: $PYTHONPATH"
                fi
            else
                #echo "=> building pythonpath"
                if [ "$p" != "$ARG" ]; then
                    [ -z "${PYTHONPATH:-}" ] && PYTHONPATH="$p" || PYTHONPATH="$p":"${PYTHONPATH}"
                    #echo "PYTHONPATH: $PYTHONPATH"
                fi
            fi
        done
    fi
fi

# returning our new PYTHONPATH
echo $PYTHONPATH

