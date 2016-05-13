
message(STATUS "Loading ${CMAKE_CURRENT_LIST_FILE}... ")

include(${CMAKE_CURRENT_LIST_DIR}/catkin-pip-runcmd.cmake)

macro(catkin_pip_setup)

    set (extra_macro_args ${ARGN})

    # Did we get any optional args?
    list(LENGTH extra_macro_args num_extra_args)
    if (${num_extra_args} GREATER 0)
        list(GET extra_macro_args 0 package_path)
        #message ("Got package_path: ${package_path}")
    else()
        set(package_path .)
    endif()

    catkin_pip_runcmd(install -e ${package_path} --prefix "${CATKIN_DEVEL_PREFIX}")

    install(CODE "
        include(${CMAKE_CURRENT_LIST_FILE})
        catkin_pip_runcmd(install ${package_path} --prefix \"${CMAKE_INSTALL_PREFIX}\" --no-deps)
        ")
endmacro()
