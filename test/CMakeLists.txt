cmake_minimum_required(VERSION 2.8.3)
#
# Here we generate a set of python projects with different structures
# and use them as tests for catkin_pip, in same workspace.
# This CMakeLists is just a way to gather all subprojects
# We assume here that the global workspace setup is already done by the parent CMakeLists.txt
#

find_package(catkin REQUIRED)

# Setting up catkin-pip from source via symlink
add_subdirectory(catkin_pip)

# include the extras (as a catkin components / find_package() would normally do)
# Just because we need to install pip requirements here
include(${CATKIN_DEVEL_PREFIX}/share/catkin_pip/cmake/catkin-pip-requirements.cmake)

# We need to install the common pip dependencies in the workspace being created
# For now we ignore existing platform setup. (might not be best choice ?)
catkin_pip_requirements(${CMAKE_CURRENT_SOURCE_DIR}/test_requirements.txt --ignore-installed)

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
  WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/pipproject
  RESULT_VARIABLE PIP_RESULT
  OUTPUT_VARIABLE PIP_VARIABLE
)
message(STATUS "    ... Done ...")

#
# Configuring catkin-pip extras from source by ourselves
# we should reproduce catkin behavior here
#
# set (DEVELSPACE True)
# set (INSTALLSPACE False)
# configure_file( ../cmake/catkin-pip-setup.cmake.in ${CATKIN_DEVEL_PREFIX}/share/catkin_pip/cmake/catkin-pip-setup.cmake @ONLY)

# set (DEVELSPACE False)
# set (INSTALLSPACE True)
# configure_file( ../cmake/catkin-pip-setup.cmake.in ${CMAKE_CURRENT_BINARY_DIR}/catkin_generated/installspace/catkin-pip-setup.cmake @ONLY)


#
# and make sure they still work with catkin by building them all as subprojects
#

if (CATKIN_ENABLE_TESTING)

    ########################
    # Nose Tests should work
    ########################

    add_subdirectory(pipproject)

endif()