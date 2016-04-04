cmake_minimum_required(VERSION 2.8.3)
project(mypippkg)

# This is a full project CMakeLists (in case we call it independently for tests or so)
set (PIP_PROJECT_DIR ${CMAKE_CURRENT_SOURCE_DIR}/mypippkg)

find_package(catkin REQUIRED)
# Include our own extension from source (to be sure)
include(../cmake/catkin-pip.cmake)
# But in your own packages you want to :
# find_package(catkin REQUIRED COMPONENTS catkin_pure_python)

# We need to install the pip dependencies in the workspace being created
catkin_pip_requirements(${PIP_PROJECT_DIR}/requirements.txt)
# CAREFUL : all projects for test here will share the same workspace. pip might have conflicts...

# defining current package as a package that should be managed by pip (not catkin - even though we make it usable with workspaces)
catkin_pip_package(${PIP_PROJECT_DIR})

## Unit tests
if (CATKIN_ENABLE_TESTING)
    catkin_add_nosetests(${PIP_PROJECT_DIR}/tests)
endif()
