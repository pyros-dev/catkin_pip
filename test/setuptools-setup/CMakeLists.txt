cmake_minimum_required(VERSION 2.8.12)
project(setuptools_setup)

# This is a full project CMakeLists (in case we call it independently for tests or so)
set (PIP_PROJECT_DIR ${CMAKE_CURRENT_SOURCE_DIR}/setuptools_setup)

find_package(catkin REQUIRED COMPONENTS catkin_pip)

# This replace catkin_python_setup()
# For devel, this will install all your unsatisfied pip dependencies.
# Upon install, this will bark if some dependencies are not already satisfied (by ROS).
catkin_pip_target(sstest ${PIP_PROJECT_DIR})

catkin_package()

# CAREFUL : all projects for test here will share the same workspace. pip might have conflicts...

# Testing potential extra files installation
install(FILES extra_installs/bin.txt DESTINATION ${CATKIN_PACKAGE_BIN_DESTINATION})
install(FILES extra_installs/etc.txt DESTINATION ${CATKIN_PACKAGE_ETC_DESTINATION})
install(FILES extra_installs/include.txt DESTINATION ${CATKIN_PACKAGE_INCLUDE_DESTINATION})
install(FILES extra_installs/lib.txt DESTINATION ${CATKIN_PACKAGE_LIB_DESTINATION})
install(FILES extra_installs/python.txt DESTINATION ${CATKIN_PACKAGE_PYTHON_DESTINATION})
install(FILES extra_installs/share.txt DESTINATION ${CATKIN_PACKAGE_SHARE_DESTINATION})

## Unit tests
if (CATKIN_ENABLE_TESTING)
    catkin_add_nosetests(${PIP_PROJECT_DIR}/test DEPENDENCIES sstest)
    catkin_add_pytests(${PIP_PROJECT_DIR}/test DEPENDENCIES sstest)
    # Running embedded test from devel space
    catkin_add_pytests(${PIP_PROJECT_DIR}/sstest/test DEPENDENCIES sstest)
endif()
