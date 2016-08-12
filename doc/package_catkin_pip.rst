Package structure for Catkin PIP
================================

Ref : http://wiki.ros.org/ROS/Tutorials/catkin/CreatingPackage

We are introducing here a hybrid way of working with python packages in catkin environment.

Files hierarchy
---------------


Dependencies
------------

Workflow
--------

This is a description of the generic ROS catkin workflow to develop, build, test and release a catkin based package.
We will use this as the reference when implementing catkin_pip improvements

- Build with catkin_make. this will use pip.

- Source devel space. this will source extra python environments

- Run tests with catkin_make test. This will use latest tests frameworks

- Debug tests with catkin_make run_tests. This will use latest tests frameworks

From a different shell to not have your environment polluted with devel space:

- Install with catkin_make install. This will use latest setuptools

- Source the install space. This will

- Run tests as a final user would.

Release

- catkin_generate_changelog OR gitchangelog

- catkin_prepare_release OR manual changes (or your own way in setup.py)

- pypi upload with twine

- bloom-release --rosdistro indigo --track indigo <package_name>


