cmake_minimum_required(VERSION 2.8.12)
project(cookiecutter_pypackage_minimal)

# This is a full project CMakeLists (in case we call it independently for tests or so)
set (PIP_PROJECT_DIR ${CMAKE_CURRENT_SOURCE_DIR}/cookiecutter_pypackage_minimal)

# NEEDED ONLY FOR TESTING INDEPENDENTLY : Setting up catkin-pip from source via symlink
add_subdirectory(catkin_pip)

find_package(catkin REQUIRED COMPONENTS catkin_pip)

# no requirements file here

# This replace catkin_python_setup()
# For devel, this will install all your unsatisfied pip dependencies.
# Upon install, this will bark if some dependencies are not already satisfied (by ROS).
catkin_pip_setup(${PIP_PROJECT_DIR})

# CAREFUL : all projects for test here will share the same workspace. pip might have conflicts...

# Here we plug back into usual catkin package build flow
catkin_package()

## Unit tests
# if (CATKIN_ENABLE_TESTING)
#     catkin_add_nosetests(${PIP_PROJECT_DIR}/tests)
#     catkin_add_pytests(${PIP_PROJECT_DIR}/tests)
# endif()
