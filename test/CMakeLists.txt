cmake_minimum_required(VERSION 2.8.3)
project(catkin_pure_python_tests)

# Here we generate a set of python projects with different structures
# and make sure they still work with catkin by running the tests

# TODO : use cookiecutter


# For ease of use, this CMakeLists allows to use this code from source, as if it were a normal catkin package.
# However no ROS/catkin debian package is provided for it.
# It is just a pip package that your packages should depend on (using rosdep dependency mechanism).
# We should follow closely https://github.com/gerkey/ros1_external_use

# Minimal Python module setup - catkin is assumed preinstalled along with ROS
# This assume catkin is installed along with a minimal ROS system.
find_package(catkin REQUIRED)

# Using our own catkin extras (to make sure we use latest)
include(../cmake/catkin-pip.cmake)

# We need to install the pip dependencies in the workspace being created
#catkin_pip_install_requirements(sampleproject/)

if (CATKIN_ENABLE_TESTING)

    ########################
    # Nose Tests should work
    ########################

    #catkin_add_nosetests(sampleproject/tests)

endif()