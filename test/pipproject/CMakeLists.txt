cmake_minimum_required(VERSION 2.8.3)
project(mypippkg)

# This is a full project CMakeLists (in case we call it independently for tests or so)
set (PIP_PROJECT_DIR ${CMAKE_CURRENT_SOURCE_DIR}/mypippkg)

find_package(catkin REQUIRED)
# Include our own extension from source (to be sure)
include(../../cmake/catkin-pip.cmake)
# Include our own configured extra
# include(${CATKIN_DEVEL_PREFIX}/share/catkin_pip/cmake/catkin-pip-setup.cmake)
# But in your own packages you want to :
# find_package(catkin REQUIRED COMPONENTS catkin_pure_python)

# For development, we need to install the pip dependencies in the workspace being created
# Upon install, this will not do anything. All requirements should be satisfied by ROS dependencies system.
# => pip dependencies will work from source only
# => to release a pip dependency in a ROS system, you need to catkinize all dependencies.
catkin_pip_requirements(${PIP_PROJECT_DIR}/requirements.txt)

# This replace catkin_python_setup()
# Upon install, this will check that all dependencies are satisfied.
catkin_pip_setup(${PIP_PROJECT_DIR})

# CAREFUL : all projects for test here will share the same workspace. pip might have conflicts...

# This is still a catkin package
catkin_package()

## Unit tests
if (CATKIN_ENABLE_TESTING)
    catkin_add_nosetests(${PIP_PROJECT_DIR}/tests)
endif()
