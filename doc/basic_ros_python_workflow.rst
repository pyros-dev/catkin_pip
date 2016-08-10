Basic ROS Python workflow
=========================

This workflow is the exact same as the usual catkin workflow.
The package file structure is the exact same as the usual catkin package structure, although using a pure python setup.py.
The dependencies of your package are only handled by rosdep (using depend keys in packages.xml) as usual with catkin.

The only difference is that Catkin-pip will massage your code with a recent version of the python tools in your build environment.
Many stable systems have out of date python packages embedded with them, and if your code is more about application rather than system, it is usually desired to use most uptodate python tools instead of the obsolete ones used by your system.

This makes it easier to :

- write a setup.py without requiring catkin to parse it.
- integrate recent python habits into catkin workflow.
- fork an existing python code to integrate into a ROS package, provided that all its dependencies are available via rosdep.

An example of the normal catkin workflow is the pyros_test package : https://github.com/asmodehn/pyros-test

An example of the basic catkin_pip workflow is the pyros_utils package : https://github.com/asmodehn/pyros-utils