message(STATUS "Loading catkin-pip.cmake from ${CMAKE_CURRENT_LIST_DIR}... ")

if ( NOT CATKIN_PIP_REQUIREMENTS_PATH )
    set (CATKIN_PIP_REQUIREMENTS_PATH ${CMAKE_CURRENT_LIST_DIR})
endif()

macro(catkin_pip_setup)
    # Check if our pip command is defined
    if( NOT CATKIN_PIP )

        # Trying to find pip
        find_program( PIP NAMES pip)
        if( PIP)
            set( SYS_PIP "${PIP}" )
        else( PIP )
            message( FATAL_ERROR "pip system command not found. Make sure you have installed the python-pip package on your system.")
        endif( PIP )

        message(STATUS "    ... Retrieving catkin-pip requirements using system pip ...")

        file(MAKE_DIRECTORY ${CATKIN_DEVEL_PREFIX}/${CATKIN_GLOBAL_PYTHON_DESTINATION})

        # need to find a pip command that works for old pip versions (indigo supports trusty which is pip v1.5.4)
        # note target here means we cannot check if a package is already installed or not before installing, using old pip.
        # Avoid --install-option since the setuptools version found will be different the first time and the following times
        execute_process(
          COMMAND /usr/bin/pip install -r "${CATKIN_PIP_REQUIREMENTS_PATH}/catkin-pip-latest.req" --download-cache "${CMAKE_BINARY_DIR}/pip-cache" --target "${CATKIN_DEVEL_PREFIX}/${CATKIN_GLOBAL_PYTHON_DESTINATION}"
          WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
          RESULT_VARIABLE PIP_RESULT
          OUTPUT_VARIABLE PIP_VARIABLE
        )

        message(STATUS "    ... Done ... [${PIP_RESULT}]: ${PIP_VARIABLE}")

        # Setting up the command for install space
        install(CODE "
            message(STATUS \"    ... Installing catkin-pip requirements using system pip ...\")
            execute_process(
              COMMAND /usr/bin/pip install -r \"${CATKIN_PIP_REQUIREMENTS_PATH}/catkin-pip-latest.req\" --download-cache \"${CMAKE_BINARY_DIR}/pip-cache\" --target \"${CMAKE_INSTALL_PREFIX}/${CATKIN_GLOBAL_PYTHON_DESTINATION}\"
              WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
              RESULT_VARIABLE PIP_RESULT
              OUTPUT_VARIABLE PIP_VARIABLE)
            message(STATUS \"    ... Done ... [${PIP_RESULT}]: ${PIP_VARIABLE}\")
        ")

        set( CATKIN_PIP python -m pip )  # this should retrieve the recently downloaded pip since using catkin means we have sourced a ROS env setup.bash

    endif( NOT CATKIN_PIP )
endmacro(catkin_pip_setup)

macro(catkin_pip_requirements requirements_txt)

    message(STATUS "    ... Retrieving Pip requirements ...")

    file(MAKE_DIRECTORY ${CATKIN_DEVEL_PREFIX}/${CATKIN_GLOBAL_PYTHON_DESTINATION})

    execute_process(
      COMMAND ${CATKIN_PIP} install -r ${requirements_txt} --ignore-installed --prefix "${CATKIN_DEVEL_PREFIX}" --install-option "--install-layout=deb"
      WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
      RESULT_VARIABLE PIP_RESULT
      OUTPUT_VARIABLE PIP_VARIABLE
    )

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

    message(STATUS "    ... Done ... [${PIP_RESULT}]: ${PIP_VARIABLE}")

endmacro()

macro(catkin_pip_package)

    message(STATUS "    ... Configuring as a Pip package ...")

    # Make sure the destination directory is in python path or install will fail.
    string(FIND ${CATKIN_DEVEL_PREFIX}/${CATKIN_GLOBAL_PYTHON_DESTINATION} ${CATKIN_DEVEL_PREFIX} FOUND_DEVEL_PPATH)
    if ( NOT FOUND_DEVEL_PPATH )
        set(ENV{PYTHONPATH} "${CATKIN_DEVEL_PREFIX}/${CATKIN_GLOBAL_PYTHON_DESTINATION}:$ENV{PYTHONPATH}")
    endif()
    # Note this is obvisouly not doing it for the user shell where cmake was started from, and the pyros_setup module is still found in source (which is fine I guess?)

    execute_process(
      COMMAND ${CATKIN_PIP} install -e . --install-option "--install-dir=${CATKIN_DEVEL_PREFIX}/${CATKIN_GLOBAL_PYTHON_DESTINATION}" --install-option "--script-dir=${CATKIN_DEVEL_PREFIX}/${CATKIN_GLOBAL_BIN_DESTINATION}"
      WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
      RESULT_VARIABLE PIP_RESULT
      OUTPUT_VARIABLE PIP_VARIABLE
    )

    # Setting up the command for install space
    install(CODE "
        message(STATUS \"    ... Installing as a Pip package ...\")
        execute_process(
          COMMAND ${CATKIN_PIP} install . --install-option \"--install-dir=${CATKIN_DEVEL_PREFIX}/${CATKIN_GLOBAL_PYTHON_DESTINATION}\" --install-option \"--script-dir=${CATKIN_DEVEL_PREFIX}/${CATKIN_GLOBAL_BIN_DESTINATION}\"
          WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
          RESULT_VARIABLE PIP_RESULT
          OUTPUT_VARIABLE PIP_VARIABLE)
        message(STATUS \"    ... Done ... [${PIP_RESULT}]: ${PIP_VARIABLE}\")
    ")

    message(STATUS "    ... Done ... [${PIP_RESULT}]: ${PIP_VARIABLE}")

endmacro()


# TODO :
# venv for easy pip install : investigate https://github.com/KitwareMedical/TubeTK/blob/master/CMake/TubeTKVirtualEnvSetup.cmake # maybe not a good idea. workspace do the job for ROS now.
# install pip packages to be embedded with install workspace. BUT not in catkin deb package...
# CPACK to deb : investigate https://cmake.org/pipermail/cmake/2011-February/042687.html
#