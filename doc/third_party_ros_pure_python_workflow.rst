Third Party ROS Pure Python workflow
====================================

This workflow is an upgrade to the ros python hybrid workflow.
The package file structure:

- is the exact same as the usual python package structure in the upstream source repository (so it can be used on existing python package) plus a CMakeLists.txt file to test the catkin build from a ROS development environment.
- is the exact same as the usual ROS package structure in the rosrelease repository (so it can be used to build ros package - this is a third party release using patches).

The dependencies of your package are handled by :

- pip (using setup.py install_requires and requirements.txt) in the upstream source repo and by the final pip package.
- rosdep (using depend keys in packages.xml) in the release repo and the final released ROS package.

This makes it easier to :

- write a ROS python package using recent python habits and dependencies
- fork an existing python repository to integrate in your ROS development environment.
- test your package with different version of packages available on pypi in you development environment.
- test the package on multiple python environment from the source repo (using travis or other build providers)
- test the package on multiple ROS distros from the release repo (using travis or other build providers)
- synchronize release on pypi for python users and on ros buildfarm for ros users.

An example of the ros/python hybrid workflow is the pyzmp package : https://github.com/asmodehn/pyzmp
This is a pure python package, imported into ROS ecosystem as is, in a deb package so other ROS packages can depend on it.