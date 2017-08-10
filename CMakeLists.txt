cmake_minimum_required(VERSION 2.8.3)
project(catkin_pip)

# Attempting auto detection of ros install if needed
# sourcing a ros workspace would have already fill up the CMAKE_PREFIX_PATH
if ( NOT CMAKE_PREFIX_PATH )
    if (EXISTS "/opt/ros/lunar")
        set(CMAKE_PREFIX_PATH "/opt/ros/lunar")
    elseif (EXISTS "/opt/ros/kinetic")
        set(CMAKE_PREFIX_PATH "/opt/ros/kinetic")
    elseif (EXISTS "/opt/ros/jade")
        set(CMAKE_PREFIX_PATH "/opt/ros/jade")
    elseif (EXISTS "/opt/ros/indigo")
        set(CMAKE_PREFIX_PATH "/opt/ros/indigo")
    endif ()
endif ()

find_package(catkin REQUIRED)

#
# Here we put catkin_pip settings
# So that we can manipulate them like catkin settings from inside the cfg_extras scripts

if ( NOT CATKIN_PIP_GLOBAL_PYTHON_DESTINATION )
    # using site-packages as it is the default for pip and should also be used on debian systems for installs from non system packages
    # Explanation here : http://stackoverflow.com/questions/9387928/whats-the-difference-between-dist-packages-and-site-packages
    set (CATKIN_PIP_GLOBAL_PYTHON_DESTINATION "lib/python2.7/site-packages")
endif()

#
# All cmake files here are CFG_EXTRAS, because they need to be loaded by any package using catkin_pip.

catkin_package(
  CFG_EXTRAS
  catkin-pip.cmake
  catkin-pip-runcmd.cmake
  catkin-pip-package.cmake
  catkin-pip-prefix.cmake
  catkin-pip-requirements.cmake
  pytest.cmake
  nosetests.cmake
)

# to be found in devel space
configure_file(cmake/catkin-pip-base.req ${CATKIN_DEVEL_PREFIX}/${CATKIN_PACKAGE_SHARE_DESTINATION}/cmake/catkin-pip-base.req COPYONLY)
configure_file(cmake/catkin-pip-fixups.req ${CATKIN_DEVEL_PREFIX}/${CATKIN_PACKAGE_SHARE_DESTINATION}/cmake/catkin-pip-fixups.req COPYONLY)
configure_file(cmake/scripts/path_prepend.sh ${CATKIN_DEVEL_PREFIX}/${CATKIN_PACKAGE_SHARE_DESTINATION}/cmake/scripts/path_prepend.sh COPYONLY)
configure_file(cmake/env-hooks/42.site_packages.sh.develspace.in ${CATKIN_DEVEL_PREFIX}/${CATKIN_PACKAGE_SHARE_DESTINATION}/cmake/env-hooks/42.site_packages.sh.develspace.in COPYONLY)
#configure_file(cmake/templates/python_setuptools_install.bat.in ${CATKIN_DEVEL_PREFIX}/${CATKIN_PACKAGE_SHARE_DESTINATION}/cmake/templates/python_setuptools_install.bat.in COPYONLY)
configure_file(cmake/templates/python_setuptools_install.sh.in ${CATKIN_DEVEL_PREFIX}/${CATKIN_PACKAGE_SHARE_DESTINATION}/cmake/templates/python_setuptools_install.sh.in COPYONLY)

# to be found in install space and from package
install(FILES
    cmake/catkin-pip-base.req
    cmake/catkin-pip-fixups.req
    DESTINATION
    ${CATKIN_PACKAGE_SHARE_DESTINATION}/cmake
)

install(PROGRAMS
    cmake/scripts/path_prepend.sh
    DESTINATION
    ${CATKIN_PACKAGE_SHARE_DESTINATION}/cmake/scripts
)

# We install in cmake folder the files that are needed by cmake code
install(FILES
    cmake/env-hooks/42.site_packages.sh.develspace.in
    DESTINATION
    ${CATKIN_PACKAGE_SHARE_DESTINATION}/cmake/env-hooks
)

install(PROGRAMS
#    cmake/templates/python_setuptools_install.bat.in
    cmake/templates/python_setuptools_install.sh.in
    DESTINATION
    ${CATKIN_PACKAGE_SHARE_DESTINATION}/cmake/templates
)

# Not testing when building here.
# But travis should.
