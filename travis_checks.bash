#!/bin/bash
set -e

# first we ensure we change to the directory where this script is.
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

# This script run basic checks on this project.
# It is used by travis and can also be used by a developer for checking his current working tree.
#
# These variables need to be setup before calling this script:
# CI_ROS_DISTRO [indigo | jade | kinetic]
# ROS_FLOW [devel | install]

# For travis docker, this is already done by the entrypoint in docker image.
# However when using 'docker exec' we still need to source it ourselves.
# Also it is mandatory when this script is run directly by the developer.
source /opt/ros/$ROS_DISTRO/setup.bash

mkdir -p testbuild
cd testbuild
cmake ../test -DCMAKE_INSTALL_PREFIX=./install
if [ "$ROS_FLOW" == "devel" ]; then
    make -j1
    echo PYTHONPATH = $PYTHONPATH
    source devel/setup.bash
    echo PYTHONPATH = $PYTHONPATH
    rospack profile
    echo PYTHONPATH = $PYTHONPATH
    make -j1 tests
    echo PYTHONPATH = $PYTHONPATH
    make -j1 run_tests
    echo PYTHONPATH = $PYTHONPATH
    catkin_test_results .
elif [ "$ROS_FLOW" == "install" ]; then
    make -j1 install
    source install/setup.bash
    echo PYTHONPATH = $PYTHONPATH
    rospack profile
    # some test packages have embedded tests to validate installed package structure
    python -m nose dstest
    python -m pytest --pyargs sstest
fi
