#!/usr/bin/env bash

pythonpathprepend() {
  for ARG in "$@"
  do
    # if ARG exists
    if [ -d "$ARG" ]; then
        # if PYTHONPATH is empty
        if [ -z "$PYTHONPATH" ]; then
            PYTHONPATH="$ARG"
        else
            # we move it from tail to head of PATH list
            IFS=':' read -ra PP_ARRAY <<< "${PYTHONPATH}"
            PYTHONPATH=$ARG
            for p in "${PP_ARRAY[@]}"; do
                if [ $p != $ARG ]; then
                    PYTHONPATH=${PYTHONPATH}:$p
                    #echo $PYTHONPATH
                fi
            done
        fi
    fi
  done
}

pythonpathprepend "$@"
