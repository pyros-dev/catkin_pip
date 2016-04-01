cmake_minimum_required(VERSION 2.8.3)
project(catkin_pure_python_tests)

#
# Here we generate a set of python projects with different structures
# and use them as tests for catkin_pure_python
#

find_package(catkin REQUIRED)
# Include our own extension from source (to be sure)
include(../cmake/catkin-pip.cmake)
# But in your own packages you want to :
# find_package(catkin REQUIRED COMPONENTS catkin_pure_python)

# First we need to setup our test requirements (using latest pip packages)
catkin_pip_setup()

# We need to install the pip dependencies in the workspace being created
catkin_pip_requirements(${CMAKE_CURRENT_SOURCE_DIR}/test_requirements.txt)

message(STATUS "PATH $ENV{PATH}")

# Make sure we get the right cookiecutter
find_program( CATKIN_COOKIECUTTER NAMES cookiecutter PATHS ${CATKIN_DEVEL_PREFIX}/${CATKIN_GLOBAL_BIN_DESTINATION} NO_DEFAULT_PATH)
message(STATUS "cookiecutter found at ${COOKIECUTTER}")
if( NOT CATKIN_COOKIECUTTER )
    message( FATAL_ERROR "cookiecutter pip command not found. Make sure you have installed the cookiecutter pip package on your workspace.")
endif( NOT CATKIN_COOKIECUTTER )

message(STATUS "    ... Getting cookiecutter-pipproject template from cookiecutter ...")
execute_process(
  COMMAND ${CATKIN_COOKIECUTTER} --no-input https://github.com/wdm0006/cookiecutter-pipproject.git
  WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
  RESULT_VARIABLE PIP_RESULT
  OUTPUT_VARIABLE PIP_VARIABLE
)
message(STATUS "    ... Done ...")



# and make sure they still work with catkin by running the tests
#



if (CATKIN_ENABLE_TESTING)

    ########################
    # Nose Tests should work
    ########################

    #catkin_add_nosetests(sampleproject/tests)

endif()