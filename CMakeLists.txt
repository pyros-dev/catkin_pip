cmake_minimum_required(VERSION 2.8.3)
project(catkin_pure_python)

find_package(catkin REQUIRED)

set(${PROJECT_NAME}_MODULES "")
list(APPEND ${PROJECT_NAME}_MODULES catkin-pip.cmake)

catkin_package(
  CFG_EXTRAS ${${PROJECT_NAME}_MODULES}
)

install(DIRECTORY cmake
        DESTINATION ${CATKIN_PACKAGE_SHARE_DESTINATION}
)

# Not testing when building now.
# Tests are not ready for packaging
#
# if (CATKIN_ENABLE_TESTING)
#     add_subdirectory(test)
# endif()