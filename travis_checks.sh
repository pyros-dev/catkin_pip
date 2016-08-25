#!/bin/bash
set -e

# This script run basic checks on this project.
# It is used by travis and can also be used by a developer for checking his current working tree.
#
# These variables need to be setup before calling this script:
# CI_ROS_DISTRO [indigo | jade]
# ROS_FLOW [devel | install]

source /opt/ros/$CI_ROS_DISTRO/setup.bash
mkdir -p testbuild
cd testbuild
cmake ../test -DCMAKE_INSTALL_PREFIX=./install
if [ "$ROS_FLOW" == "devel" ]; then
    make -j1
    source devel/setup.bash
    make -j1 tests
    make -j1 run_tests
    catkin_test_results .
elif [ "$ROS_FLOW" == "install" ]; then
    make -j1 install
    source install/setup.bash
    # TMP disabling test from now, since mypippkg has no tests
    #nosetests mypippkg
    #python -m pytest --pyargs mypippkg
fi
