Catkin Build Release Flow
=========================

This is a description of the generic ROS catkin workflow to develop, build, test and release a catkin based package.
We will use this as the reference when implementing catkin_pip improvements

- your package repository must have
   - package.xml
   - CMakeLists.txt

- Build with catkin_make

- Source devel space

- Run tests with catkin_make test

- Debug tests with catkin_make run_tests

From a different shell to not have your environment polluted with devel space:

- Install with catkin_make install

- Source hte install space

- Run tests as a final user would.

Release

- catkin_generate_changelog

- catkin_prepare_release

- bloom-release --rosdistro indigo --track indigo <package_name>




TODO : review this with the new catkin tools coming up (ie catkin build)