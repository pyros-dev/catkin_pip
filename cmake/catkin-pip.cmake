message(STATUS "Loading catkin-pip.cmake from ${CMAKE_CURRENT_LIST_DIR}... ")

if ( NOT CATKIN_PIP_REQUIREMENTS_PATH )
    set (CATKIN_PIP_REQUIREMENTS_PATH ${CMAKE_CURRENT_LIST_DIR})
endif()

# Make sure the pip target directory for devel workspace is in python path
# this is only needed if the user didn't source the current workspace devel setup.bash (happens the first time)
string(FIND $ENV{PYTHONPATH} ${CATKIN_DEVEL_PREFIX}/${CATKIN_GLOBAL_PYTHON_DESTINATION} FOUND_DEVEL_PPATH)
if ( FOUND_DEVEL_PPATH LESS 0 )
    set(ENV{PYTHONPATH} "${CATKIN_DEVEL_PREFIX}/${CATKIN_GLOBAL_PYTHON_DESTINATION}:$ENV{PYTHONPATH}")
endif()

# Make sure the bin target directory for devel is in system path
# this is only needed if the user didn't source the current workspace devel setup.bash (happens the first time)
string(FIND $ENV{PATH} ${CATKIN_DEVEL_PREFIX}/${CATKIN_GLOBAL_BIN_DESTINATION} FOUND_DEVEL_SPATH)
if ( FOUND_DEVEL_SPATH LESS 0 )
    set(ENV{PATH} "${CATKIN_DEVEL_PREFIX}/${CATKIN_GLOBAL_BIN_DESTINATION}:$ENV{PATH}")
endif()

# Note : this is obviously not changing anything in the shell environment where cmake was started from.
# And WE DO NOT WANT to do it there. The user controls his bash environment independently of what runs in it.

# Defining this macro early since we use it here on include time
macro(catkin_pip_requirements requirements_txt)

    message(STATUS "    ... Retrieving Pip requirements ${requirements_txt}...")

    execute_process(
      COMMAND ${CATKIN_PIP} install -r ${requirements_txt} --ignore-installed --prefix "${CATKIN_DEVEL_PREFIX}" --install-option "--install-layout=deb"
      WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
      RESULT_VARIABLE PIP_RESULT
      OUTPUT_VARIABLE PIP_VARIABLE
      ERROR_VARIABLE PIP_ERROR
    )

    message(STATUS "    ... Done ... [${PIP_RESULT}]: ${PIP_VARIABLE}")
    if (PIP_RESULT)
        message(STATUS "Command ${CATKIN_PIP} install -r ${requirements_txt} --ignore-installed --prefix \"${CATKIN_DEVEL_PREFIX}\" --install-option \"--install-layout=deb\" FAILED")
        message(FATAL_ERROR "${PIP_ERROR}")
    endif()

    # Setting up the command for install space
    install(CODE "
      message(STATUS \"    ... Installing Pip requirements ...\")
      execute_process(
          COMMAND ${CATKIN_PIP} install -r ${requirements_txt} --ignore-installed --prefix \"${CATKIN_DEVEL_PREFIX}\" --install-option \"--install-layout=deb\"
          WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
          RESULT_VARIABLE PIP_RESULT
          OUTPUT_VARIABLE PIP_VARIABLE)
      message(STATUS \"    ... Done ... [${PIP_RESULT}]: ${PIP_VARIABLE}\")
    ")

endmacro()


# Trying to find our own pip
# Careful this creates a CACHE variable
find_program(CATKIN_PIP NAMES pip PATHS ${CATKIN_DEVEL_PREFIX}/${CATKIN_GLOBAL_BIN_DESTINATION})

# Make sure we find the right one
# message(STATUS "    ... FINDING ${CATKIN_DEVEL_PREFIX}/${CATKIN_GLOBAL_BIN_DESTINATION} in ${CATKIN_PIP} ...")
string(FIND ${CATKIN_PIP} ${CATKIN_DEVEL_PREFIX}/${CATKIN_GLOBAL_BIN_DESTINATION} FOUND_CATKIN_PIP)
# message(STATUS "    ... RESULT ${FOUND_CATKIN_PIP} ...")

if (NOT FOUND_CATKIN_PIP LESS 0)
    message(STATUS "    ... Catkin pip was found at ${CATKIN_PIP} ...")
else ()
    # If not found, it means we need to do the whole setup...
    unset(CATKIN_PIP CACHE)
    message(STATUS "    ... Catkin pip was not found in devel workspace ...")
    find_program(CATKIN_SYS_PIP NAMES pip)
    if(NOT CATKIN_SYS_PIP)
        message( FATAL_ERROR "pip system command not found. Make sure you have installed the python-pip package on your system.")
    endif()

    message(STATUS "    ... Retrieving catkin_pure_python requirements using system pip ...")

    file(MAKE_DIRECTORY ${CATKIN_DEVEL_PREFIX}/${CATKIN_GLOBAL_PYTHON_DESTINATION})

    # We need to find a pip command that works for old pip versions (indigo supports trusty which is pip v1.5.4)
    # Note --target here means we cannot check if a package is already installed or not before installing, using old pip.
    # which means we have to reinstall dependencies everytime and specify --exists-action w to avoid "already exists" errors
    # Avoid --install-option since the setuptools version found will be different the first time and the following times
    execute_process(
      COMMAND ${CATKIN_SYS_PIP} install -r "${CATKIN_PIP_REQUIREMENTS_PATH}/catkin-pip-base.req" --download-cache "${CMAKE_BINARY_DIR}/pip-cache" --target "${CATKIN_DEVEL_PREFIX}/${CATKIN_GLOBAL_PYTHON_DESTINATION}" --exists-action w
      WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
      RESULT_VARIABLE PIP_RESULT
      OUTPUT_VARIABLE PIP_VARIABLE
      ERROR_VARIABLE PIP_ERROR
    )

    message(STATUS "    ... Done ... [${PIP_RESULT}]: ${PIP_VARIABLE}")
    if (PIP_RESULT)
        message(STATUS "Command ${CATKIN_SYS_PIP} install -r \"${CATKIN_PIP_REQUIREMENTS_PATH}/catkin-pip-base.req\" --download-cache \"${CMAKE_BINARY_DIR}/pip-cache\" --target \"${CATKIN_DEVEL_PREFIX}/${CATKIN_GLOBAL_PYTHON_DESTINATION}\" --exists-action w FAILED")
        message(FATAL_ERROR "${PIP_ERROR}")
    endif()

    # Setting up the command for install space is not needed here. It will be done by the fixups from our catkin pip.

    set(CATKIN_PIP python -m pip)  # to make sure we use our recently downloaded pip version (its entrypoints were not installed by old pip/setuptools)
    unset(CATKIN_SYS_PIP CACHE)  # we dont need this any longer

    # Fixing security since python 2.7.6 on trusty is broken : https://stackoverflow.com/questions/29099404/ssl-insecureplatform-error-when-using-requests-package
    catkin_pip_requirements("${CATKIN_PIP_REQUIREMENTS_PATH}/catkin-pip-fixups.req")

    unset(CATKIN_PIP)
    # now we can finally use the simple "pip" entry_point (forcing cmake to find it)
    find_program( CATKIN_PIP NAMES pip PATHS ${CMAKE_DEVEL_PREFIX}/${CATKIN_GLOBAL_BIN_DESTINATION})
    string(FIND ${CATKIN_PIP} ${CATKIN_DEVEL_PREFIX}/${CATKIN_GLOBAL_BIN_DESTINATION} FOUND_CATKIN_PIP)

    if (CATKIN_PIP AND NOT FOUND_CATKIN_PIP LESS 0)
        message( STATUS "Found catkin_pure_python pip command at ${CATKIN_PIP}.")
    else()
        message( FATAL_ERROR "catkin_pure_python pip command not found in ${CMAKE_DEVEL_PREFIX}/${CATKIN_GLOBAL_BIN_DESTINATION}. Make sure you have installed the pip pip package on your devel workspace.")
    endif()

    # Providing another catkin nosetests usage...
    # now we can finally use the simple "pip" entry_point (forcing cmake to find it)
    find_program( PIP_NOSETESTS NAMES nosetests PATHS ${CMAKE_DEVEL_PREFIX}/${CATKIN_GLOBAL_BIN_DESTINATION})
    string(FIND ${PIP_NOSETESTS} ${CATKIN_DEVEL_PREFIX}/${CATKIN_GLOBAL_BIN_DESTINATION} FOUND_CATKIN_PIP_NOSETESTS)
    if(PIP_NOSETESTS AND NOT FOUND_CATKIN_PIP_NOSETESTS LESS 0)
        message( STATUS "Found catkin_pure_python nosetests command at ${PIP_NOSETESTS}.")
    else()
        message( FATAL_ERROR "catkin_pure_python nosetests command not found in ${CMAKE_DEVEL_PREFIX}/${CATKIN_GLOBAL_BIN_DESTINATION}. Make sure you have installed the nose pip package on your devel workspace.")
    endif()

endif()

macro(catkin_pip_package package_path)

    if( NOT package_path)
        set(package_path .)
    endif()
    message(STATUS "    ... Configuring ${package_path} as a Pip package ...")

    execute_process(
      COMMAND ${CATKIN_PIP} install -e ${package_path} --install-option "--install-dir=${CATKIN_DEVEL_PREFIX}/${CATKIN_GLOBAL_PYTHON_DESTINATION}" --install-option "--script-dir=${CATKIN_DEVEL_PREFIX}/${CATKIN_GLOBAL_BIN_DESTINATION}"
      WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
      RESULT_VARIABLE PIP_RESULT
      OUTPUT_VARIABLE PIP_VARIABLE
      ERROR_VARIABLE PIP_ERROR
    )

    message(STATUS "    ... Done ... [${PIP_RESULT}]: ${PIP_VARIABLE}")
    if (PIP_RESULT)
        message(STATUS "Command ${CATKIN_PIP} install -e ${package_path} --install-option \"--install-dir=${CATKIN_DEVEL_PREFIX}/${CATKIN_GLOBAL_PYTHON_DESTINATION}\" --install-option \"--script-dir=${CATKIN_DEVEL_PREFIX}/${CATKIN_GLOBAL_BIN_DESTINATION}\" FAILED")
        message(FATAL_ERROR "${PIP_ERROR}")
    endif()

    # Setting up the command for install space
    install(CODE "
        message(STATUS \"    ... Installing as a Pip package ...\")
        execute_process(
          COMMAND ${CATKIN_PIP} install ${package_path} --install-option \"--install-dir=${CATKIN_DEVEL_PREFIX}/${CATKIN_GLOBAL_PYTHON_DESTINATION}\" --install-option \"--script-dir=${CATKIN_DEVEL_PREFIX}/${CATKIN_GLOBAL_BIN_DESTINATION}\"
          WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
          RESULT_VARIABLE PIP_RESULT
          OUTPUT_VARIABLE PIP_VARIABLE)
        message(STATUS \"    ... Done ... [${PIP_RESULT}]: ${PIP_VARIABLE}\")
    ")
endmacro()

# TODO :
# venv for easy pip install : investigate https://github.com/KitwareMedical/TubeTK/blob/master/CMake/TubeTKVirtualEnvSetup.cmake # maybe not a good idea. workspace do the job for ROS now.
# install pip packages to be embedded with install workspace. BUT not in catkin deb package...
# CPACK to deb : investigate https://cmake.org/pipermail/cmake/2011-February/042687.html
#
