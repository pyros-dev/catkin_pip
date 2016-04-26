message(STATUS "Loading catkin-pip.cmake from ${CMAKE_CURRENT_LIST_DIR}... ")

# Since we need (almost) the same configuration for both devel and install space, we create cmake files for each workspace setup.
set(CONFIGURE_PREFIX ${CATKIN_DEVEL_PREFIX})
set(PIP_PACKAGE_INSTALL_COMMAND \${CATKIN_PIP} install -e \${package_path} --prefix "${CONFIGURE_PREFIX}")
configure_file(${CMAKE_CURRENT_LIST_DIR}/catkin-pip-setup.cmake.in ${CONFIGURE_PREFIX}/.catkin-pip-setup.cmake @ONLY)
configure_file(${CMAKE_CURRENT_LIST_DIR}/catkin-pip-base.req ${CONFIGURE_PREFIX}/.catkin-pip-base.req COPYONLY)
configure_file(${CMAKE_CURRENT_LIST_DIR}/catkin-pip-fixups.req ${CONFIGURE_PREFIX}/.catkin-pip-fixups.req COPYONLY)

set(CONFIGURE_PREFIX ${CMAKE_INSTALL_PREFIX})
set(PIP_PACKAGE_INSTALL_COMMAND \${CATKIN_PIP} install \${package_path} --prefix "${CONFIGURE_PREFIX}")
configure_file(${CMAKE_CURRENT_LIST_DIR}/catkin-pip-setup.cmake.in ${CONFIGURE_PREFIX}/.catkin-pip-setup.cmake @ONLY)
configure_file(${CMAKE_CURRENT_LIST_DIR}/catkin-pip-base.req ${CONFIGURE_PREFIX}/.catkin-pip-base.req @ONLY)
configure_file(${CMAKE_CURRENT_LIST_DIR}/catkin-pip-fixups.req ${CONFIGURE_PREFIX}/.catkin-pip-fixups.req @ONLY)

unset(CONFIGURE_PREFIX)
unset(PIP_PACKAGE_INSTALL_COMMAND)

# And here we need to do the devel workspace setup.
include(${CATKIN_DEVEL_PREFIX}/.catkin-pip-setup.cmake)


macro(catkin_pip_requirements requirements_txt )

    catkin_pip_requirements_prefix(${requirements_txt})

endmacro()

macro(catkin_pip_package)

    set (extra_macro_args ${ARGN})

    # Did we get any optional args?
    list(LENGTH extra_macro_args num_extra_args)
    if (${num_extra_args} GREATER 0)
        list(GET extra_macro_args 0 package_path)
        #message ("Got package_path: ${package_path}")
    else()
        set(package_path .)
    endif()

    catkin_pip_package_prefix(${package_path})

    # Setting up the command for install space for user convenience
    install(CODE "
        #Setting paths for install by including our configured install cmake file
        include(${CMAKE_INSTALL_PREFIX}/.catkin-pip-setup.cmake)
        catkin_pip_package_prefix(${package_path})
    ")
endmacro()

# TODO :
# venv for easy pip install : investigate https://github.com/KitwareMedical/TubeTK/blob/master/CMake/TubeTKVirtualEnvSetup.cmake # maybe not a good idea. workspace do the job for ROS now.
# install pip packages to be embedded with install workspace. BUT not in catkin deb package...
# CPACK to deb : investigate https://cmake.org/pipermail/cmake/2011-February/042687.html
#
