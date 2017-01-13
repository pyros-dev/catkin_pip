message(STATUS "Loading catkin-pip-requirements.cmake from ${CMAKE_CURRENT_LIST_DIR}... ")

if ( CMAKE_BACKWARDS_COMPATIBILITY LESS 2.8 )
	message ( FATAL_ERROR " CMAKE MINIMUM BACKWARD COMPATIBILITY REQUIRED : 2.8 !" )
endif( CMAKE_BACKWARDS_COMPATIBILITY LESS 2.8 )

# Enforcing one time include https://cmake.org/Wiki/CMake_Performance_Tips#Use_an_include_guard
if(catkin_pip_requirements_included)
  return()
endif(catkin_pip_requirements_included)
set(catkin_pip_requirements_included true)

# protecting against missing cmake file
include ( "${CMAKE_CURRENT_LIST_DIR}/catkin-pip-prefix.cmake" RESULT_VARIABLE CATKIN_PIP_PREFIX_FOUND )
IF ( NOT CATKIN_PIP_PREFIX_FOUND )
    message ( FATAL_ERROR "{CMAKE_CURRENT_LIST_DIR}/catkin-pip-prefix.cmake Not Found !!!" )
ENDIF ( NOT CATKIN_PIP_PREFIX_FOUND )

#
# Here we also setup the environment so that detected pip version is usable enough
# This is used by any other project directly (at configure time).
# It will automatically setup a prefix with catkin-pip.
#
function(catkin_pip_requirements requirements_txt)

    # Setting up our environment (for devel space only)
    # Needed in case user call this directly (configure time)
    catkin_pip_setup_prefix(${CATKIN_PIP_ENV})

    # runnig the pip command (configure time)
    catkin_pip_runcmd(${CATKIN_PIP} install ${ARGN} -r ${requirements_txt} --ignore-installed --src ${CMAKE_SOURCE_DIR} --exists-action b --prefix "${CATKIN_DEVEL_PREFIX}")

endfunction()
