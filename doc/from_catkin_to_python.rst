=====================
From Catkin to Python
=====================

This document should mirror the from_python_to_catkin document.

Step 1 : Hybrid Package
-----------------------

The goal is to generalize an existing catkin package into a python environment.
However this project is only about build environments. For :

- a solution to find dependencies at runtime, check pyros_setup
- a solution to discover message type and convert them dynamically, check pyros

In a catkin devel workspace, you should :

- edit your CMakeLists.txt to use catkin_pip
- edit your setup.py, in order to use latest setuptools, and not the obsolete distutils required by catkin. Note you can leave the dependencies in package.xml to be resolved by rosdep in this first step. We can deal with that in Step 2.

You should compare the python package structure and the hybrid package structure to become familiar with the differences.

Running `catkin_make` will trigger a workflow very similar to the usual catkin workflow.

This makes it easier to :

- write a generic setup.py without requiring catkin to parse it.
- integrate recent python habits into catkin workflow.

An example of the normal catkin package is the pyros_test package : https://github.com/asmodehn/pyros-test

An example of the basic catkin_pip workflow is the pyros_utils package : https://github.com/asmodehn/pyros-utils

For more details, you should check our reference python workflow there <TODO> and compare it with the hybrid workflow there <TODO>.

After you successfully build your package with catkin_pip, your dependencies can be handled by pip in the devel workspace, so you can get started with adjusting your dependencies for python.

Step 2 : Dependencies adjustments
---------------------------------

You should refer to the python way of handling dependencies in package_catkin_pip, and start adding your dependencies in requirements.txt or in setup.py.

This does mean there will be duplicated dependencies in package.xml and in setup.py.
It might be unsuitable in some cases (same versions everywhere), but necessary in some others (different version on different systems), so this is currently the best option.

Finally you should already be able to create a python package, and even publish it on pypi. Be careful to test it, in order to verify all python dependencies are working.

For more details about setting up travis tests for a hybrid package, check <TODO>.


Step 3 : Python Enhancements (optional)
---------------------------------------

There are multiple ways to improve your package, using recent python tools.
In random order:

- bump up your dependencies to use more recent version than the ones provided with your system or with ROS.
- use a recent test framework like pytest.
- use tox to test multiple python environment at once.
- use read-the-docs to publish your documentation for all to see.
- upgrade your workflow by using setup.py for preparing a release.
- publish your package on Pypi for all to use.


Step 4 : Third Party Package (optional)
---------------------------------------

You can work with your current hybrid packge, if :

- you have write access to the original catkin package repository, you don't mind adding a few files, and you can make the hybrid package structure there.
- you have forked the original catkin package repository, and you are happy to do the maintenance of the versions in ROS versus the versions in pypi.

However if you don't have write access to the original repository, or you don't want the hassle of maintaining all different versions between the ROS distributions and the python environments, you should consider building a Third Party package.
Ref : http://wiki.ros.org/bloom/Tutorials/ReleaseThirdParty

It does mean that the source repository will be the python code repository, as the python code should work cross-platform.
What needs to be adjusted is the catkin build to make a ROS system package out of the python package.
This is doable via small patches in the release repository, along with a more "generic code" handling all differences in the environment.

For more details about this step, you should consult `Build a Third Party package from Hybrid Package`.



