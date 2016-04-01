message(STATUS "Loading catkin-pip.cmake from ${CMAKE_CURRENT_LIST_DIR}... ")

if ( NOT CATKIN_PIP_REQUIREMENTS_PATH )
    set (CATKIN_PIP_REQUIREMENTS_PATH ${CMAKE_CURRENT_LIST_DIR})
endif()

# Since we need the same configuration for both devel and install space, we create cmake files for each workspace setup.
set(CONFIGURE_PREFIX ${CATKIN_DEVEL_PREFIX})
configure_file(${CMAKE_CURRENT_LIST_DIR}/catkin-pip-setup.cmake.in ${CONFIGURE_PREFIX}/.catkin-pip-setup.cmake @ONLY)
set(CONFIGURE_PREFIX ${CMAKE_INSTALL_PREFIX})
configure_file(${CMAKE_CURRENT_LIST_DIR}/catkin-pip-setup.cmake.in ${CONFIGURE_PREFIX}/.catkin-pip-setup.cmake @ONLY)
unset(CONFIGURE_PREFIX)

# And here we need to do the devel workspace setup.
include(${CATKIN_DEVEL_PREFIX}/.catkin-pip-setup.cmake)


macro(catkin_pip_requirements requirements_txt )

    catkin_pip_requirements_prefix(${requirements_txt})

    # Setting up the command for install space for user convenience
    install(CODE "
      #Setting paths for install by including our configured install cmake file
      include(${CMAKE_INSTALL_PREFIX}/.catkin-pip-setup.cmake)
      catkin_pip_requirements_prefix(requirements_txt)
    ")

endmacro()

macro(catkin_pip_package)

    set (extra_macro_args ${ARGN})

    # Did we get any optional args?
    list(LENGTH extra_macro_args num_extra_args)
    if (${num_extra_args} GREATER 0)
        list(GET extra_macro_args 0 package_path)
        message ("Got package_path: ${package_path}")
    else()
        set(package_path .)
    endif()

    catkin_pip_package_prefix(TRUE ${package_path})

    # Setting up the command for install space for user convenience
    install(CODE "
        #Setting paths for install by including our configured install cmake file
        include(${CMAKE_INSTALL_PREFIX}/.catkin-pip-setup.cmake)
        catkin_pip_package_prefix(FALSE ${package_path})
    ")
endmacro()

# TODO :
# venv for easy pip install : investigate https://github.com/KitwareMedical/TubeTK/blob/master/CMake/TubeTKVirtualEnvSetup.cmake # maybe not a good idea. workspace do the job for ROS now.
# install pip packages to be embedded with install workspace. BUT not in catkin deb package...
# CPACK to deb : investigate https://cmake.org/pipermail/cmake/2011-February/042687.html
#
