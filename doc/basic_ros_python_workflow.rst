Basic ROS Python workflow
=========================

This workflow is the exact same as the usual catkin workflow.
The package file structure is the exact same as the usual catkin package structure.
The dependencies of your package are only handled by rosdep (using depend keys in packages.xml) as usual with catkin.

The only difference is that Catkin-pip will bring along the latest python tools in your build environment.

This makes it easier to :

- write a setup.py without requiring catkin to parse it.
- integrate recent python habits into catkin workflow.
- fork an existing python code to integrate into a ROs package, provided that all its dependencies are available via rosdep.

