=====================
From Python to Catkin
=====================

This document should mirror the from_catkin_to_python document.

Step 1 : Hybrid Package for devel
---------------------------------

The goal is to integrate an existing python package into a catkin environment.
This is available right away for a devel workspace, you just need to create a CMakeLists.txt using catkin_pip, and a matching package.xml for catkin to detect it.
you should compare the python package structure and the hybrid package structure to become familiar with the differences.

Running `catkin_make` will trigger a workflow very similar to the usual python workflow.

This makes it easier to :

- write a setup.py without requiring catkin to parse it.
- fork an existing python code to integrate into a ROS package, provided that all its dependencies are available via rosdep.

An example of the normal python package is the pyros_setup package : https://github.com/asmodehn/pyros-setup

An example of the basic catkin_pip workflow is the pyros_utils package : https://github.com/asmodehn/pyros-utils

For more details, you should check our reference python workflow there <TODO> and compare it with the hybrid workflow there <TODO>.

Your dependencies are still handled by pip in the devel workspace, so you can get started with using your package in catkin quickly.


Step 2 : Dependencies adjustments
---------------------------------

Once your existing python package works fine in source, you can adjust your dependencies version to make sure all dependencies can be found on the system, or in ROS packages.
All these dependencies should be resolvable from packages.xml, and installable via `rosdep`.

This does mean there will be duplicated dependencies in package.xml and in setup.py.
It might be unsuitable in some cases (same versions everywhere), but necessary in some others (different version on different systems), so this is currently the best option.

Finally you should be able to create a ROS package. Be careful to test it, in order to verify all system dependencies are working.

For more details about setting up travis tests for a hybrid package, check <TODO>.


Step 3 : Third Party Package (optional)
---------------------------------------

You can work with your current hybrid package, if :

- you have write access to the original python package repository, you don't mind adding a few files, and you can make the hybrid package structure there.
- you have forked the original python package repository, and you are happy to do the maintenance of the versions in python versus the versions in ROS.

However if you don't have write access to the original repository, or you don't want the hassle of maintaining all different versions between the ROS distributions and the python environments, you should consider building a Third Party package.
Ref : http://wiki.ros.org/bloom/Tutorials/ReleaseThirdParty

It is useful especially for all the python dependencies you might use in your project, but on which you have no control, except choosing the version you d like to use in you ROS distro.


Build a Third Party package from Hybrid Package
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This is achieved by extracting the files useful only for catkin (CMakeLists.txt, package.xml, rosdoc.yml) from the hybrid package made before, and putting them in the rosrelease repository created by bloom when releasing a ROS package.

Be aware that now, your source package cannot be built in a catkin workspace, and you should use:

- The ROS package as a dependency in you parent catkin project, via rosdep (using depend keys in packages.xml)
- The pip package as a dependency in you parent python project, via pip (using setup.py install_requires and requirements.txt)

This makes it easier to :

- write a ROS python package using recent python habits and dependencies
- test your package with different version of packages available on pypi in your development environment.
- test the package on multiple python environment from the source repo (using travis or other build providers)
- test the package on multiple ROS distros from the release repo (using travis or other build providers)
- synchronize release on pypi for python users and on ros buildfarm for ros users.

An example of the ros/python hybrid workflow is the pyzmp package : https://github.com/asmodehn/pyzmp
This is a pure python package, imported into ROS ecosystem as is, in a deb package so other ROS packages can depend on it.

To check how the release repository itself can be checked with travis to ensure the package tests are still passing when in a ROS environment.
A few examples from the pyros dependencies:

- https://travis-ci.org/asmodehn/pyros-config-rosrelease
- https://travis-ci.org/asmodehn/pyzmp-rosrelease

Again, the third party package release is sometime not necessary. If your package doesnt have to be distributed via ROS package system, having a simple pip package is enough.
https://github.com/asmodehn/pyros-setup is an example of this : it is a simple pip package, that is retrieved and used only via pip.
Your package can use it as a dependency to access ROS modules from a python virtual env.
For more user interaction with ROS from pure python, you want to have a look at https://github.com/asmodehn/pyros itself (provided as a pip package and a ROS package)


