message(STATUS "Loading catkin-pip.cmake from ${CMAKE_CURRENT_LIST_DIR}... ")

# TODO : we probably should move some of these variables into an env hook ?

if ( NOT CATKIN_PIP_REQUIREMENTS_PATH )
    # Needs to be here to avoid copying all dependent script into the workspace on configure step
    set (CATKIN_PIP_REQUIREMENTS_PATH ${CMAKE_CURRENT_LIST_DIR})
endif()

if ( NOT CATKIN_PIP_GLOBAL_PYTHON_DESTINATION )
    # using site-packages as it is the default for pip and should also be used on debian systems for installs from non system packages
    # Explanation here : http://stackoverflow.com/questions/9387928/whats-the-difference-between-dist-packages-and-site-packages
    set (CATKIN_PIP_GLOBAL_PYTHON_DESTINATION "lib/python2.7/site-packages")
endif()

# note ${CMAKE_CURRENT_SOURCE_DIR}/env-hooks points to final package source env-hook DIR
# note ${CMAKE_CURRENT_LIST_DIR}/env-hooks points to catkin-pip env-hook DIR
catkin_add_env_hooks(42.site-packages SHELLS bash DIRECTORY ${CMAKE_CURRENT_LIST_DIR}/../env-hooks)

# Since we need (almost) the same configuration for both devel and install space, we create cmake files for each workspace setup.
# set(DEVELSPACE True)
# set(INSTALLSPACE False)
# configure_file(${CMAKE_CURRENT_LIST_DIR}/catkin-pip-setup.cmake.in ${CMAKE_CURRENT_BINARY_DIR}/.catkin-pip-setup-devel.cmake @ONLY)
#
# set(DEVELSPACE False)
# set(INSTALLSPACE True)
# configure_file(${CMAKE_CURRENT_LIST_DIR}/catkin-pip-setup.cmake.in ${CMAKE_CURRENT_BINARY_DIR}/.catkin-pip-setup-install.cmake @ONLY)
#
# unset(DEVELSPACE)
# unset(INSTALLSPACE)

#
# Devel Space Only
#

# Make sure the catkin python package directory for the workspace is in python path
# This is only needed if the user didn't source the current workspace setup.bash.
# This happens the first time when using catkin_pure_python in workspace
string(FIND "$ENV{PYTHONPATH}" ${CATKIN_DEVEL_PREFIX}/${CATKIN_GLOBAL_PYTHON_DESTINATION} FOUND_PPATH)
string(FIND "$ENV{PYTHONPATH}" ${CATKIN_DEVEL_PREFIX}/${CATKIN_PIP_GLOBAL_PYTHON_DESTINATION} FOUND_PPPATH)
string(FIND "$ENV{PATH}" ${CATKIN_DEVEL_PREFIX}/${CATKIN_GLOBAL_BIN_DESTINATION} FOUND_SPATH)

if ( ( FOUND_PPATH LESS 0 ) OR ( FOUND_PPPATH LESS 0 ) OR ( FOUND_SPATH LESS 0 ) )
    message(AUTHOR_WARNING "Incomplete catkin-pip setup detected."
    "This is expected if you use catkin-pip from source, and did not source the current develspace yet."
    "Quick patch will be applied to the current cmake process environment."
    )

    if ( FOUND_PPATH LESS 0 )
        message(STATUS "Adding ${CATKIN_DEVEL_PREFIX}/${CATKIN_GLOBAL_PYTHON_DESTINATION} to PYTHONPATH")
        set(ENV{PYTHONPATH} "${CATKIN_DEVEL_PREFIX}/${CATKIN_GLOBAL_PYTHON_DESTINATION}:$ENV{PYTHONPATH}")
    endif()

    if ( FOUND_PPPATH LESS 0 )
        message(STATUS "Adding ${CATKIN_DEVEL_PREFIX}/${CATKIN_PIP_GLOBAL_PYTHON_DESTINATION} to PYTHONPATH")
        set(ENV{PYTHONPATH} "${CATKIN_DEVEL_PREFIX}/${CATKIN_PIP_GLOBAL_PYTHON_DESTINATION}:$ENV{PYTHONPATH}")
    endif()

    if ( FOUND_SPATH LESS 0 )
        message(STATUS "Adding ${CATKIN_DEVEL_PREFIX}/${CATKIN_GLOBAL_BIN_DESTINATION} to PATH")
        set(ENV{PATH} "${CATKIN_DEVEL_PREFIX}/${CATKIN_GLOBAL_BIN_DESTINATION}:$ENV{PATH}")
    endif()
endif()

message(STATUS "Catkin pip PYTHONPATH : $ENV{PYTHONPATH}")
message(STATUS "Catkin pip PATH : $ENV{PATH}")

# Note : this is obviously not changing anything in the shell environment where cmake was started from.
# Since this cmake extension depends on catkin we also do the same in an envhook for normal usage (source setup.bash).



# Note : we need to install our fixups here as normal requirements and we need our catkin_pip executable to do it
macro(catkin_pip_requirements requirements_txt)

    # we add extra arguments to the command
    set(FULL_CMD ${CATKIN_PIP} install ${ARGN} -r ${requirements_txt} --src ${CMAKE_SOURCE_DIR} --exists-action b --prefix "${CATKIN_DEVEL_PREFIX}")

    string(REPLACE ";" " " PIP_REQUIREMENTS_INSTALL_CMDSTR "${FULL_CMD}")
    message(STATUS "    ... Running ${PIP_REQUIREMENTS_INSTALL_CMDSTR} ...")

    execute_process(
      COMMAND ${FULL_CMD}
      WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
      RESULT_VARIABLE PIP_RESULT
      OUTPUT_VARIABLE PIP_VARIABLE
      ERROR_VARIABLE PIP_ERROR
    )

    message(STATUS "    ... Done ... [${PIP_RESULT}]: ${PIP_VARIABLE}")
    if (PIP_RESULT)
        message(STATUS "Command ${PIP_REQUIREMENTS_INSTALL_CMDSTR} FAILED !")
        message(FATAL_ERROR "${PIP_ERROR}")
    endif()
endmacro()



# Trying to find our own pip
# Careful this creates a CACHE variable that we need to recreate here in case people clean devel without cleaning build
unset(CATKIN_PIP CACHE)
find_program(CATKIN_PIP NAMES pip pip2 pip2.7 PATHS ${CATKIN_DEVEL_PREFIX}/${CATKIN_GLOBAL_BIN_DESTINATION} NO_DEFAULT_PATH)

if (CATKIN_PIP)
    message(STATUS "    ... Catkin pip was found at ${CATKIN_PIP} ...")
else ()
    # If not found, it means we need to do the whole setup...
    unset(CATKIN_PIP CACHE)
    message(STATUS "    ... Catkin pip was not found in ${CATKIN_DEVEL_PREFIX}/${CATKIN_GLOBAL_BIN_DESTINATION} ...")
    # Assuming Ubuntu Trusty here. platform detection is another hurdle
    set(CMAKE_SYSTEM_PREFIX_PATH / /usr /usr/local)
    find_program(CATKIN_SYS_PIP NAMES pip pip2 pip2.7 NO_CMAKE_PATH NO_CMAKE_ENVIRONMENT_PATH NO_SYSTEM_ENVIRONMENT_PATH)  # we need to make sure we don't find any other catkin-pip from somewhere else if our path is not clean (careful with underlays or install/devel)
    if(NOT CATKIN_SYS_PIP)
        message( FATAL_ERROR "pip system command not found. Make sure you have installed the python-pip package on your system.")
    endif()

    # message(STATUS "    ... Creating pip packages prefix ...")
    # If needed we create the directory (to avoid later errors)
    # file(MAKE_DIRECTORY ${CATKIN_DEVEL_PREFIX}/${CATKIN_PIP_GLOBAL_PYTHON_DESTINATION})

    message(STATUS "    ... Retrieving catkin_pure_python requirements using system pip ...")

    # We need to find a pip command that works for old pip versions (indigo supports trusty which is pip v1.5.4)
    # Note --target here means we cannot check if a package is already installed or not before installing, using old pip.
    # which means we have to reinstall dependencies everytime and specify --exists-action w to avoid "already exists" errors
    # Avoid --install-option since the setuptools version found will be different the first time and the following times
    execute_process(
      COMMAND ${CATKIN_SYS_PIP} -q install -r "${CATKIN_PIP_REQUIREMENTS_PATH}/catkin-pip-base.req" --download-cache "${CMAKE_BINARY_DIR}/pip-cache" --target "${CATKIN_DEVEL_PREFIX}/${CATKIN_PIP_GLOBAL_PYTHON_DESTINATION}" --exists-action w
      WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
      RESULT_VARIABLE PIP_RESULT
      OUTPUT_VARIABLE PIP_VARIABLE
      ERROR_VARIABLE PIP_ERROR
    )

    message(STATUS "    ... Done ... [${PIP_RESULT}]: ${PIP_VARIABLE}")
    if (PIP_RESULT)
        message(STATUS "Command ${CATKIN_SYS_PIP} install -r \"${CATKIN_PIP_REQUIREMENTS_PATH}/catkin-pip-base.req\" --download-cache \"${CMAKE_BINARY_DIR}/pip-cache\" --target \"${CATKIN_DEVEL_PREFIX}/${CATKIN_PIP_GLOBAL_PYTHON_DESTINATION}\" --exists-action w FAILED")
        message(FATAL_ERROR "${PIP_ERROR}")
    endif()

    set(CATKIN_PIP python -m pip)  # to make sure we use our recently downloaded pip version (its entrypoints were not installed by old pip/setuptools)
    unset(CATKIN_SYS_PIP CACHE)  # we dont need this any longer

    # Fixing security since python 2.7.6 on trusty is broken : https://stackoverflow.com/questions/29099404/ssl-insecureplatform-error-when-using-requests-package
    # Also reinstalling pip to finally get it in bin/
    catkin_pip_requirements("${CATKIN_PIP_REQUIREMENTS_PATH}/catkin-pip-fixups.req" --ignore-installed)

    unset(CATKIN_PIP)
    # now we can finally use the simple "pip" entry_point (forcing cmake to find it)
    find_program( CATKIN_PIP NAMES pip pip2 pip2.7 PATHS ${CATKIN_DEVEL_PREFIX}/${CATKIN_GLOBAL_BIN_DESTINATION} NO_DEFAULT_PATH)
    if (CATKIN_PIP)
        message( STATUS "Found catkin_pure_python pip command at ${CATKIN_PIP}.")
    else()
        message( FATAL_ERROR "catkin_pure_python pip command not found in ${CATKIN_DEVEL_PREFIX}/${CATKIN_GLOBAL_BIN_DESTINATION}. Make sure you have installed the pip pip package on ${CATKIN_DEVEL_PREFIX} workspace.")
    endif()

    # Providing another catkin nosetests usage...
    # now we can finally use the simple "nosetests" entry_point (forcing cmake to find it)
    find_program( PIP_NOSETESTS NAMES nosetests PATHS ${CATKIN_DEVEL_PREFIX}/${CATKIN_GLOBAL_BIN_DESTINATION} NO_DEFAULT_PATH)
    if(PIP_NOSETESTS)
        message( STATUS "Found catkin_pure_python nosetests command at ${PIP_NOSETESTS}.")
    else()
        message( FATAL_ERROR "catkin_pure_python nosetests command not found in ${CATKIN_DEVEL_PREFIX}/${CATKIN_GLOBAL_BIN_DESTINATION}. Make sure you have installed the nose pip package on your ${CATKIN_DEVEL_PREFIX} workspace.")
    endif()

endif()


#
# Install Space should have same behavior as package build
# We want to check dependencies are all satisfied, without relying on pip requirements.
#

include(${CMAKE_CURRENT_LIST_DIR}/catkin-pip-setup.cmake)

# TODO :
# venv for easy pip install : investigate https://github.com/KitwareMedical/TubeTK/blob/master/CMake/TubeTKVirtualEnvSetup.cmake # maybe not a good idea. workspace do the job for ROS now.
# install pip packages to be embedded with install workspace. BUT not in catkin deb package...
# CPACK to deb : investigate https://cmake.org/pipermail/cmake/2011-February/042687.html
#
