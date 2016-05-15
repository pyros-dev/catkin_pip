cmake_minimum_required(VERSION 2.8.3)
project(catkin_pure_python)

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
# All cmake files here are CFG_EXTRAS, because they need to be loaded by any package using catkin_pure_python.

catkin_package(
  CFG_EXTRAS
  catkin-pip.cmake
  catkin-pip-env.cmake
  catkin-pip-runcmd.cmake
  catkin-pip-setup.cmake
  catkin-pip-prefix.cmake
  catkin-pip-requirements.cmake
)

# to be found in devel space
configure_file(cmake/catkin-pip-base.req ${CATKIN_DEVEL_PREFIX}/${CATKIN_PACKAGE_SHARE_DESTINATION}/cmake/catkin-pip-base.req COPYONLY)
configure_file(cmake/catkin-pip-fixups.req ${CATKIN_DEVEL_PREFIX}/${CATKIN_PACKAGE_SHARE_DESTINATION}/cmake/catkin-pip-fixups.req COPYONLY)
configure_file(env-hooks/42.site-packages.bash.in ${CATKIN_DEVEL_PREFIX}/${CATKIN_PACKAGE_SHARE_DESTINATION}/env-hooks/42.site-packages.bash.in COPYONLY)
configure_file(templates/python_setuptools_install.bat.in ${CATKIN_DEVEL_PREFIX}/${CATKIN_PACKAGE_SHARE_DESTINATION}/templates/python_setuptools_install.bat.in COPYONLY)
configure_file(templates/python_setuptools_install.sh.in ${CATKIN_DEVEL_PREFIX}/${CATKIN_PACKAGE_SHARE_DESTINATION}/templates/python_setuptools_install.sh.in COPYONLY)

# to be found in install space and from package
install(FILES
    cmake/catkin-pip-base.req
    cmake/catkin-pip-fixups.req
    DESTINATION
    ${CATKIN_PACKAGE_SHARE_DESTINATION}/cmake
)

install(FILES
    env-hooks/42.site-packages.bash.in
    DESTINATION
    ${CATKIN_PACKAGE_SHARE_DESTINATION}/env-hooks
)

install(FILES
    templates/python_setuptools_install.bat.in
    templates/python_setuptools_install.sh.in
    DESTINATION
    ${CATKIN_PACKAGE_SHARE_DESTINATION}/templates
)

# Not testing when building here.
# But travis should.
