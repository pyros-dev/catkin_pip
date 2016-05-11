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

# # Hacking existing ROS _setup_util.py
# # TODO : that would be better in a env hook...
# macro(catkin_pip_hack_setup python_path_extra setup_util_path )
#     # _setup_util.py should already exist here.
#     # catkin should have done the workspace setup before we reach here
#     if ( EXISTS ${setup_util_path} )
#         message(STATUS "Hacking ${setup_util_path}...")
#         file(READ ${setup_util_path} SETUP_UTIL_PY)
#         string(REPLACE
#             "'PYTHONPATH': 'lib/python2.7/dist-packages',"
#             "'PYTHONPATH': ['${python_path_extra}', 'lib/python2.7/dist-packages']"
#             PATCHED_SETUP_UTIL_PY
#             "${SETUP_UTIL_PY}"
#         )
#         file(WRITE ${setup_util_path} "${PATCHED_SETUP_UTIL_PY}")
#     else()
#         message(FATAL_ERROR "SETUP_UTIL.PY DOES NOT EXISTS YET at ${setup_util_path}")
#     endif()
# endmacro()

# # devel space
# catkin_pip_hack_setup( ${CATKIN_PIP_GLOBAL_PYTHON_DESTINATION} ${CATKIN_DEVEL_PREFIX}/_setup_util.py)

# # install space (following catkin_generate_environment cmake code structure)
# if(NOT CATKIN_BUILD_BINARY_PACKAGE)
#     catkin_pip_hack_setup( ${CATKIN_PIP_GLOBAL_PYTHON_DESTINATION} ${CMAKE_BINARY_DIR}/catkin_generated/installspace/_setup_util.py)
# endif()

# env hook solution
# note ${CMAKE_CURRENT_SOURCE_DIR}/env-hooks points to final package source env-hook DIR
# note ${CMAKE_CURRENT_LIST_DIR}/env-hooks points to catkin-pip env-hook DIR
catkin_add_env_hooks(42.site-packages SHELLS bash DIRECTORY ${CMAKE_CURRENT_LIST_DIR}/../env-hooks)

# Since we need (almost) the same configuration for both devel and install space, we create cmake files for each workspace setup.
set(CONFIGURE_PREFIX ${CATKIN_DEVEL_PREFIX})
set(PIP_PACKAGE_INSTALL_COMMAND \${CATKIN_PIP} install -e \${package_path} --prefix "${CONFIGURE_PREFIX}")
configure_file(${CMAKE_CURRENT_LIST_DIR}/catkin-pip-setup.cmake.in ${CMAKE_CURRENT_BINARY_DIR}/.catkin-pip-setup-devel.cmake @ONLY)
#configure_file(${CMAKE_CURRENT_LIST_DIR}/catkin-pip-base.req ${CONFIGURE_PREFIX}/.catkin-pip-base.req COPYONLY)
#configure_file(${CMAKE_CURRENT_LIST_DIR}/catkin-pip-fixups.req ${CONFIGURE_PREFIX}/.catkin-pip-fixups.req COPYONLY)

# TODO : We start from source to go to devel/ or install/. We should instead use scripts from the build/ folder as dispatcher to devel or install, somehow...
set(CONFIGURE_PREFIX ${CMAKE_INSTALL_PREFIX})
set(PIP_PACKAGE_INSTALL_COMMAND \${CATKIN_PIP} install \${package_path} --prefix "${CONFIGURE_PREFIX}" --ignore-installed)
configure_file(${CMAKE_CURRENT_LIST_DIR}/catkin-pip-setup.cmake.in ${CMAKE_CURRENT_BINARY_DIR}/.catkin-pip-setup-install.cmake @ONLY)
#configure_file(${CMAKE_CURRENT_LIST_DIR}/catkin-pip-base.req ${CONFIGURE_PREFIX}/.catkin-pip-base.req COPYONLY)
#configure_file(${CMAKE_CURRENT_LIST_DIR}/catkin-pip-fixups.req ${CONFIGURE_PREFIX}/.catkin-pip-fixups.req COPYONLY)

unset(CONFIGURE_PREFIX)
unset(PIP_PACKAGE_INSTALL_COMMAND)

# And here we need to do the devel workspace setup.
include(${CMAKE_CURRENT_BINARY_DIR}/.catkin-pip-setup-devel.cmake)


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

    # TODO this whole cmake is a actually a template, and we can probably integrate this in normal catkin flow
    # Setting up the command for install space for user convenience
    install(CODE "
        #Setting paths for install by including our configured install cmake file
        include(${CMAKE_CURRENT_BINARY_DIR}/.catkin-pip-setup-install.cmake)
        catkin_pip_package_prefix(${package_path})
    ")
endmacro()

# TODO :
# venv for easy pip install : investigate https://github.com/KitwareMedical/TubeTK/blob/master/CMake/TubeTKVirtualEnvSetup.cmake # maybe not a good idea. workspace do the job for ROS now.
# install pip packages to be embedded with install workspace. BUT not in catkin deb package...
# CPACK to deb : investigate https://cmake.org/pipermail/cmake/2011-February/042687.html
#
