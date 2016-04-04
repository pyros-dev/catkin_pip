cmake_minimum_required(VERSION 2.8.3)
#
# Here we generate a set of python projects with different structures
# and use them as tests for catkin_pure_python
# This CMakeLists is just a way to gather all subprojects
# We assume here that the global workspace setup is already done by the parent CMakeLists.txt
#

find_package(catkin REQUIRED)
# Include our own extension from source (to be sure), only to be able to get common pip requirements
include(../cmake/catkin-pip.cmake)

# We need to install the common pip dependencies in the workspace being created
catkin_pip_requirements(${CMAKE_CURRENT_SOURCE_DIR}/test_requirements.txt)

message(STATUS "PATH $ENV{PATH}")

# Make sure we get the right cookiecutter
find_program( CATKIN_COOKIECUTTER NAMES cookiecutter PATHS ${CATKIN_DEVEL_PREFIX}/${CATKIN_GLOBAL_BIN_DESTINATION} NO_DEFAULT_PATH)
if( NOT CATKIN_COOKIECUTTER )
    message( FATAL_ERROR "cookiecutter pip command not found. Make sure you have installed the cookiecutter pip package on your workspace.")
else()
    message(STATUS "cookiecutter found at ${CATKIN_COOKIECUTTER}")
endif()

message(STATUS "    ... Getting cookiecutter-pipproject template from cookiecutter ...")
execute_process(
  COMMAND ${CATKIN_COOKIECUTTER} --no-input https://github.com/wdm0006/cookiecutter-pipproject.git
  WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
  RESULT_VARIABLE PIP_RESULT
  OUTPUT_VARIABLE PIP_VARIABLE
)
message(STATUS "    ... Done ...")

#
# and make sure they still work with catkin by building them all as subprojects
#

if (CATKIN_ENABLE_TESTING)

    ########################
    # Nose Tests should work
    ########################

    include(mypippkg.cmake)

endif()