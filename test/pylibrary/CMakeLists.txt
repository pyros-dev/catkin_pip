cmake_minimum_required(VERSION 2.8.12)
project(python_nameless)

# This is a full project CMakeLists (in case we call it independently for tests or so)
set (PIP_PROJECT_DIR ${CMAKE_CURRENT_SOURCE_DIR}/python-nameless)

# NEEDED ONLY FOR TESTING INDEPENDENTLY : Setting up catkin-pip from source via symlink
# add_subdirectory(catkin_pip)

find_package(catkin REQUIRED COMPONENTS catkin_pip)

# no requirements file in this project template

# This replace catkin_python_setup()
# For devel, this will install all your unsatisfied pip dependencies.
# Upon install, this will bark if some dependencies are not already satisfied (by ROS).
catkin_pip_target(nameless ${PIP_PROJECT_DIR})

catkin_package()

# CAREFUL : all projects for test here will share the same workspace. pip might have conflicts...

## Unit tests
if (CATKIN_ENABLE_TESTING)
    catkin_add_nosetests(${PIP_PROJECT_DIR}/tests DEPENDENCIES nameless)
    catkin_add_pytests(${PIP_PROJECT_DIR}/tests DEPENDENCIES nameless)
endif()
