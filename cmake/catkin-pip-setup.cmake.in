message(STATUS "Loading catkin-pip-setup.cmake from ${CMAKE_CURRENT_LIST_DIR}... ")

if ( CMAKE_BACKWARDS_COMPATIBILITY LESS 2.8 )
	message ( FATAL_ERROR " CMAKE MINIMUM BACKWARD COMPATIBILITY REQUIRED : 2.8 !" )
endif( CMAKE_BACKWARDS_COMPATIBILITY LESS 2.8 )

# Enforcing one time include https://cmake.org/Wiki/CMake_Performance_Tips#Use_an_include_guard
if(catkin_pip_setup_included)
  return()
endif(catkin_pip_setup_included)
set(catkin_pip_setup_included true)

# protecting against missing cmake file
include ( "${CMAKE_CURRENT_LIST_DIR}/catkin-pip-env.cmake" RESULT_VARIABLE CATKIN_PIP_ENV_FOUND )
IF ( NOT CATKIN_PIP_ENV_FOUND )
    message ( FATAL_ERROR "{CMAKE_CURRENT_LIST_DIR}/catkin-pip-env.cmake Not Found !!!" )
ENDIF ( NOT CATKIN_PIP_ENV_FOUND )

# protecting against missing cmake file
include ( "${CMAKE_CURRENT_LIST_DIR}/catkin-pip-runcmd.cmake" RESULT_VARIABLE CATKIN_PIP_RUNCMD_FOUND )
IF ( NOT CATKIN_PIP_RUNCMD_FOUND )
    message ( FATAL_ERROR "{CMAKE_CURRENT_LIST_DIR}/catkin-pip-runcmd.cmake Not Found !!!" )
ENDIF ( NOT CATKIN_PIP_RUNCMD_FOUND )

# protecting against missing cmake file
include ( "${CMAKE_CURRENT_LIST_DIR}/catkin-pip-prefix.cmake" RESULT_VARIABLE CATKIN_PIP_PREFIX_FOUND )
IF ( NOT CATKIN_PIP_PREFIX_FOUND )
    message ( FATAL_ERROR "{CMAKE_CURRENT_LIST_DIR}/catkin-pip-prefix.cmake Not Found !!!" )
ENDIF ( NOT CATKIN_PIP_PREFIX_FOUND )


# These are set on include time by catkin-pip and point to catkin-pip folders
if ( NOT CATKIN_PIP_TEMPLATES_PATH )
    # templates should found relative to our current path
    set (CATKIN_PIP_TEMPLATES_PATH ${CMAKE_CURRENT_LIST_DIR}/templates CACHE PATH "templates path")
endif()

# We are replacing catkin's python_setup functionality
# This is run by the package and CMAKE_CURRENT_LIST_DIR refer to the package one.
function(catkin_pip_python_setup)

    # Setting up variables for scripts configuration (in a function to keep it here)
    set(CATKIN_PIP_PACKAGE_PATH ${package_path})

    # BEGIN : This is from catkin_python_setup
    # we follow same process but with slightly different scripts
    #

      assert(PYTHON_INSTALL_DIR)
      assert(CATKIN_PIP_PYTHON_INSTALL_DIR)
      set(INSTALL_CMD_WORKING_DIRECTORY ${package_path})

      if(NOT WIN32)
        set(INSTALL_SCRIPT
          ${CMAKE_CURRENT_BINARY_DIR}/catkin_generated/python_setuptools_install.sh)
        configure_file(${CATKIN_PIP_TEMPLATES_PATH}/python_setuptools_install.sh.in
          ${INSTALL_SCRIPT}
          @ONLY)
      else()
        # need to convert install prefix to native path for python setuptools --prefix (its fussy about \'s)
        file(TO_NATIVE_PATH ${CMAKE_INSTALL_PREFIX} PYTHON_INSTALL_PREFIX)
        set(INSTALL_SCRIPT
          ${CMAKE_CURRENT_BINARY_DIR}/catkin_generated/python_setuptools_install.bat)
        configure_file(${CATKIN_PIP_TEMPLATES_PATH}/python_setuptools_install.bat.in
          ${INSTALL_SCRIPT}
          @ONLY)
      endif()

      # generate python script which gets executed at install time
      configure_file(${catkin_EXTRAS_DIR}/templates/safe_execute_install.cmake.in
        ${CMAKE_CURRENT_BINARY_DIR}/catkin_generated/safe_execute_install.cmake)
      install(SCRIPT ${CMAKE_CURRENT_BINARY_DIR}/catkin_generated/safe_execute_install.cmake)

    # END : This is the end of catkin_python_setup copy
    # Ideally we shouldn't need any more tricks for building the install space
    #

endfunction()

function(catkin_pip_setup)

    set (extra_macro_args ${ARGN})

    # Did we get any optional args?
    list(LENGTH extra_macro_args num_extra_args)
    if (${num_extra_args} GREATER 0)
        list(GET extra_macro_args 0 package_path)
        #message ("Got package_path: ${package_path}")
    else()
        set(package_path ${CMAKE_CURRENT_SOURCE_DIR})
    endif()

    # Note : environment should already be setup at configure time for devel

    # Then we can run the pip command
    if(CATKIN_PIP_NO_DEPS)
        catkin_pip_runcmd(${CATKIN_PIP} install -e ${package_path} --no-dependencies --prefix "${CATKIN_DEVEL_PREFIX}")
    else()
        catkin_pip_runcmd(${CATKIN_PIP} install -e ${package_path} --prefix "${CATKIN_DEVEL_PREFIX}")
    endif()

    if(NOT EXISTS ${package_path}/setup.py)
        message(FATAL_ERROR "catkin_pip_setup() called without 'setup.py' in project folder '${package_path}'")
    endif()

    catkin_pip_python_setup()

    # TODO : we might want to generate a package.xml on the fly from setup.py contents...

    # Hijacking catkin scripts again
    #set(_PACKAGE_XML_DIRECTORY ${package_path})

endfunction()
