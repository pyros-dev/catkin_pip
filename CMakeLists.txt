cmake_minimum_required(VERSION 2.8.3)
project(catkin_pure_python)

find_package(catkin REQUIRED)

catkin_package(
  CFG_EXTRAS catkin-pip.cmake
)

# to be found in devel space
configure_file(cmake/catkin-pip-setup.cmake.in ${CATKIN_DEVEL_PREFIX}/${CATKIN_PACKAGE_SHARE_DESTINATION}/cmake/catkin-pip-setup.cmake.in COPYONLY)
configure_file(cmake/catkin-pip-base.req ${CATKIN_DEVEL_PREFIX}/${CATKIN_PACKAGE_SHARE_DESTINATION}/cmake/catkin-pip-base.req COPYONLY)
configure_file(cmake/catkin-pip-fixups.req ${CATKIN_DEVEL_PREFIX}/${CATKIN_PACKAGE_SHARE_DESTINATION}/cmake/catkin-pip-fixups.req COPYONLY)
configure_file(env-hooks/42.site-packages.bash.in ${CATKIN_DEVEL_PREFIX}/${CATKIN_PACKAGE_SHARE_DESTINATION}/env-hooks/42.site-packages.bash.in COPYONLY)

# to be found in install space and from package
install(DIRECTORY cmake
        DESTINATION ${CATKIN_PACKAGE_SHARE_DESTINATION}
)
install(DIRECTORY env-hooks
        DESTINATION ${CATKIN_PACKAGE_SHARE_DESTINATION}
)

# Not testing when building here.
# But travis should.
