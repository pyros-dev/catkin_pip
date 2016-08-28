cmake_minimum_required(VERSION 2.8.3)
project(catkin_pip)

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
  catkin-pip-env.cmake
  catkin-pip-runcmd.cmake
  catkin-pip-setup.cmake
  catkin-pip-prefix.cmake
  catkin-pip-requirements.cmake
  pytest.cmake
  nosetests.cmake
)

# to be found in devel space
configure_file(cmake/catkin-pip-base.req ${CATKIN_DEVEL_PREFIX}/${CATKIN_PACKAGE_SHARE_DESTINATION}/cmake/catkin-pip-base.req COPYONLY)
configure_file(cmake/catkin-pip-fixups.req ${CATKIN_DEVEL_PREFIX}/${CATKIN_PACKAGE_SHARE_DESTINATION}/cmake/catkin-pip-fixups.req COPYONLY)
configure_file(cmake/scripts/pythonpath_prepend.bash ${CATKIN_DEVEL_PREFIX}/${CATKIN_PACKAGE_SHARE_DESTINATION}/cmake/scripts/pythonpath_prepend.bash COPYONLY)
configure_file(cmake/env-hooks/42.site_packages.sh.develspace.in ${CATKIN_DEVEL_PREFIX}/${CATKIN_PACKAGE_SHARE_DESTINATION}/cmake/env-hooks/42.site_packages.sh.develspace.in COPYONLY)
configure_file(cmake/env-hooks/42.site_packages.bash.develspace.in ${CATKIN_DEVEL_PREFIX}/${CATKIN_PACKAGE_SHARE_DESTINATION}/cmake/env-hooks/42.site_packages.bash.develspace.in COPYONLY)
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
    cmake/scripts/pythonpath_prepend.bash
    DESTINATION
    ${CATKIN_PACKAGE_SHARE_DESTINATION}/cmake/scripts
)

# We install in cmake folder the files that are needed by cmake code
install(FILES
    cmake/env-hooks/42.site_packages.sh.develspace.in
    cmake/env-hooks/42.site_packages.bash.develspace.in
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
