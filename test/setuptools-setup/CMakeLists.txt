cmake_minimum_required(VERSION 2.8.12)
project(setuptools_setup)

# This is a full project CMakeLists (in case we call it independently for tests or so)
set (PIP_PROJECT_DIR ${CMAKE_CURRENT_SOURCE_DIR}/setuptools_setup)

find_package(catkin REQUIRED COMPONENTS catkin_pip)

# This replace both catkin_python_setup() and catkin_package()
# For devel, this will install all your unsatisfied pip dependencies.
# Upon install, this will bark if some dependencies are not already satisfied (by ROS).
catkin_pip_package(sstest ${PIP_PROJECT_DIR})

# CAREFUL : all projects for test here will share the same workspace. pip might have conflicts...

## Unit tests
if (CATKIN_ENABLE_TESTING)
    catkin_add_nosetests(${PIP_PROJECT_DIR}/test DEPENDENCIES sstest)
    catkin_add_pytests(${PIP_PROJECT_DIR}/test DEPENDENCIES sstest)
    # Running embedded test from devel space
    catkin_add_pytests(${PIP_PROJECT_DIR}/sstest/test DEPENDENCIES sstest)
endif()
