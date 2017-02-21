#!/bin/sh

# This scripts takes one argument (a path)
# and prepends it to the beginning of the second argument (a ':' separated list of path)
# It returns the new list.

# lets be safe : Ref : http://www.davidpashley.com/articles/writing-robust-shell-scripts/
set -o nounset
set -o noglob
# set -o errexit  # for development only
# tested with dash on ubuntu trusty

if [ $# -gt 3 -o $# -lt 1 ]; then
    # echo "Usage : path_prepend <arg_path> <path_list> [<path_before>]"  # TMP : we cannot echo anything in the way the script is used
    exit 127  # TODO this breaks calling script (with source setup.bash) -> FIX IT
fi
if [ $# -ge 1 ]; then
    if [ -z "$1" ]; then  # to protect against empty arg
        # echo "ERROR: Attempting to prepend an empty argument"  # TMP : we cannot echo anything in the way the script is used
        exit 63  # TODO this breaks calling script (with source setup.bash) -> FIX IT (easy test by changing -z -> -n)
    fi
    # The path to insert
    ARG="$1"
fi
if [ $# -lt 2 ]; then
    LIST=""
else
    LIST="$2"
fi
if [ $# -eq 3 ]; then
    BEFORE="$3"
fi

# if PATH is empty
if [ -z "$LIST" ]; then
    LIST="$ARG"
else
    # we move it from tail to head of paths in PATH list
    PATH_LIST=$(echo $LIST | /bin/sed 's/:/\n/g')
    LIST=""
    for p in $PATH_LIST; do
        if [ X"$p" = X"${BEFORE:-}" ]; then
            BEFORE_FOUND=1  # to mark we have found BEFORE
            [ -z "${LIST:-}" ] && LIST=${ARG} || LIST=${LIST}:${ARG}
            #echo $LIST
        fi
        if [ X$p != X$ARG ]; then
            [ -z "${LIST:-}" ] && LIST=${p} || LIST=${LIST}:${p}
            #echo $LIST
        fi
    done
    # we prepend ARG here, after we made sure it is not in LIST any longer
    if [ -z "${BEFORE:-}" -o -z "${BEFORE_FOUND:-}" ]; then  # if there was no before or if it was not found, we put it in front
        [ -z "${LIST:-}" ] && LIST="$ARG" || LIST="$ARG":"${LIST}"
    fi
fi

# returning our new PATH
echo $LIST


# Testing :
# TODO : detail how to test this and cover all usecases (even if ony manual steps at first)
# Unit testing : http://stackoverflow.com/questions/971945/unit-testing-for-shell-scripts
#
# $ PATHLIST=
    # 1. Testing empty path
# $ ./path_prepend.bash test/path $PATHLIST
# => test/path
# $ PATHLIST=test/path
    # 2. Testing going to the front
# $ ./path_prepend.bash test/blah $PATHLIST
# => test/blah:test/path
# $ PATHLIST=test/blah:test/path
    # 3. Testing going to the front more than once
# $ ./cmake/scripts/path_prepend.bash test/blah $PATHLIST
# => test/blah:test/path
# $ PATHLIST=test/blah:test/path
    # 4. Testing inserting
# ./cmake/scripts/path_prepend.bash test/boum $PATHLIST test/path
# => test/blah:test/boum:test/path