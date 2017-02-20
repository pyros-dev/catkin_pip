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
include(${CATKIN_DEVEL_PREFIX}/share/catkin_pip/cmake/catkin-pip.cmake)
# note : including only the catkin-pip-requirements cmake here will break because some required variables are not set

# We need to install the common pip dependencies in the workspace being created
# For now we ignore existing platform setup. (might not be best choice ?)
catkin_pip_requirements(${CMAKE_CURRENT_SOURCE_DIR}/test_requirements.txt --ignore-installed)

message(STATUS "PATH $ENV{PATH}")
message(STATUS "PYTHONPATH $ENV{PYTHONPATH}")

# Make sure we get the right cookiecutter
find_program( CATKIN_COOKIECUTTER NAMES cookiecutter PATHS ${CATKIN_DEVEL_PREFIX}/${CATKIN_GLOBAL_BIN_DESTINATION} NO_DEFAULT_PATH)
if( NOT CATKIN_COOKIECUTTER )
    message( FATAL_ERROR "cookiecutter pip command not found. Make sure you have installed the cookiecutter pip package on your workspace.")
else()
    message(STATUS "cookiecutter found at ${CATKIN_COOKIECUTTER}")
endif()

if (NOT EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/pipproject/mypippkg")
    message(STATUS "    ... Getting cookiecutter-pipproject template from cookiecutter ...")
    execute_process(
      # TMP waiting for PR
      COMMAND ${CATKIN_ENV} ${CATKIN_COOKIECUTTER} --no-input https://github.com/asmodehn/cookiecutter-pipproject.git --checkout adding_test_sample
      WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/pipproject
      RESULT_VARIABLE PIP_RESULT
      OUTPUT_VARIABLE PIP_VARIABLE
    )
    message(STATUS "    ... Done ...")
endif()

if (NOT EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/pylibrary/python-nameless")
    message(STATUS "    ... Getting cookiecutter-pylibrary template from cookiecutter ...")
    execute_process(
      COMMAND ${CATKIN_ENV} ${CATKIN_COOKIECUTTER} --no-input https://github.com/ionelmc/cookiecutter-pylibrary
      WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/pylibrary
      RESULT_VARIABLE PIP_RESULT
      OUTPUT_VARIABLE PIP_VARIABLE
    )
    message(STATUS "    ... Done ...")
endif()

if (NOT EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/pypackage/python_boilerplate")
    message(STATUS "    ... Getting cookiecutter-pypackage template from cookiecutter ...")
    execute_process(
      COMMAND ${CATKIN_ENV} ${CATKIN_COOKIECUTTER} --no-input https://github.com/audreyr/cookiecutter-pypackage
      WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/pypackage
      RESULT_VARIABLE PIP_RESULT
      OUTPUT_VARIABLE PIP_VARIABLE
    )
    message(STATUS "    ... Done ...")
endif()

if (NOT EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/pypackage-minimal/cookiecutter_pypackage_minimal")
    message(STATUS "    ... Getting cookiecutter-pypackage-minimal template from cookiecutter ...")
    execute_process(
    # TMP : fork to get proper default package name. upstream : https://github.com/kragniz/cookiecutter-pypackage-minimal
      COMMAND ${CATKIN_ENV} ${CATKIN_COOKIECUTTER} --no-input https://github.com/asmodehn/cookiecutter-pypackage-minimal
      WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/pypackage-minimal
      RESULT_VARIABLE PIP_RESULT
      OUTPUT_VARIABLE PIP_VARIABLE
    )
    message(STATUS "    ... Done ...")
endif()


#
# and make sure they still work with catkin by building them all as subprojects
#


# Testing project itself
# We need to call rosdep for each packages (to install dependencies if there are any)
# note $ROS_DISTRO must be already defined in the environment
catkin_pip_runcmd(rosdep install --from-paths "pipproject" -y)
add_subdirectory(pipproject)

# Testing project itself
catkin_pip_runcmd(rosdep install --from-paths "pylibrary" -y)
add_subdirectory(pylibrary)

# Testing project itself
catkin_pip_runcmd(rosdep install --from-paths "pypackage" -y)
add_subdirectory(pypackage)

# Testing project itself
catkin_pip_runcmd(rosdep install --from-paths "pypackage-minimal" -y)
add_subdirectory(pypackage-minimal)


if (CATKIN_ENABLE_TESTING)

    ########################
    # Nose Tests should work
    ########################

    # Testing environment setup by catkin_pip
    # We need to add all subprojects as dependencies for this test
    catkin_add_pytests(
        catkin_pip_pytest
        --build-dir ${CMAKE_BINARY_DIR}
        DEPENDENCIES
        ${mypippkg_PIP_TARGET}                      # from pipproject
        ${nameless_PIP_TARGET}                      # from pylibrary
        ${python_boilerplate_PIP_TARGET}            # from pypackage
        ${cookiecutter_pypackage_minimal_PIP_TARGET}      # from pypackage-minimal
    )

endif()