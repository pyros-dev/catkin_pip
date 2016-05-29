cmake_minimum_required(VERSION 2.8.12)
project(mypippkg)

# This is a full project CMakeLists (in case we call it independently for tests or so)
set (PIP_PROJECT_DIR ${CMAKE_CURRENT_SOURCE_DIR}/mypippkg)

find_package(catkin REQUIRED COMPONENTS catkin_pure_python)

# For development, we need to install the pip dependencies in the workspace being created
# Upon install, this will not do anything. All requirements should be satisfied by ROS dependencies system.
# => pip dependencies will work from source only
# => to release a pip dependency in a ROS system, you need to catkinize all dependencies.
catkin_pip_requirements(${PIP_PROJECT_DIR}/requirements.txt --ignore-installed)
# Here we ignore already installed packages, to avoid conflicts with system installed packages (pygments for example)
# However this also means that existing packages in the workspace will not be used to satisfy requirements,
# and will be reinstalled everytime...

# This replace catkin_python_setup()
# For devel, this will install all your unsatisfied pip dependencies.
# Upon install, this will bark if some dependencies are not already satisfied (by ROS).
catkin_pip_setup(${PIP_PROJECT_DIR})

# CAREFUL : all projects for test here will share the same workspace. pip might have conflicts...

# Here we plug back into usual catkin package build flow
catkin_package()

## Unit tests
if (CATKIN_ENABLE_TESTING)
    catkin_add_nosetests(${PIP_PROJECT_DIR}/tests)
endif()
