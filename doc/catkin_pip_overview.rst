Catkin-Pip Overview
===================

This document describe the different areas where catkin-pip makes Python ROS development easier.


Pip package
-----------

Catkin-pip doesnt not change the behavior of a pip package. It just make its use easier in a catkin context.

Catkin-pip however suppose that the pip package needs to use latest python tools (setuptools, pip, pytest, nose) for manipulating it.
This is in line with python expectation to use latest stable software (and not obsolete system dependencies).

ROS Package
-----------

Catkin-pip doesnt not change the behavior of a ROS package. It just make it easier to build one from a recent python package.

As ROS packages should only depend on other ros packages, one should be careful to have verified the package still behave as expected when not using pip dependencies before releasing.


Devel Space
-----------

When used to build a devel space, catkin-pip retrieves it s own dependencies (latest python tools) in the build folder.
It also plug into the cmake flow to trigger pip download of the package dependencies (unless CATKIN_PIP_NO_DEPS is enabled)

After sourcing the devel space, the catkin-pip python tools are overlayed on top of the system ones, and the package dependencies also overlay the system version of it, if there are any.
this makes it simple to use any version you would like and manage your dependencies with pip, as usual in python workflow.

With CATKIN_PIP_NO_DEPS enabled, only the catkin-pip python tools are retrieved by pip, and your package needs to rely on the system installed python dependencies.
This is done in order for package developer to be able to slowly migrate from pip version to system version, so that they are eventually able to create a system package from their pip package.


Install Space
-------------

When used to create an install space, catkin-pip doesnt do anything special, except using the latest setuptools version to create the layout of that system package.
No pip dependencies are ever loaded in that system, so using the install space requires your package to be able to run with system python dependencies, just as running from a system package would do.

When in that step, one should be careful that tools used to manipulate the package (test, docs) might be at a different version now (system) than in the devel space (catkin-pip version)

Creating a ROs package from the install space is done as usual, only using a recent version of setuptools.


Virtual environments
--------------------

Since Catkin-pip allows normal python package to "merge" easily with a ROS package, into what we call a "hybrid" package, one can now choose to use either :
- a ROS package, installed on the system, in the ros environment.
- a pip package, installed on a virtual env, with access to the system packages.

Note that catkin-pip only solve the "build part" of the problem:

- To dynamically use the python packages from your catkin workspace when launching a python program outside a ROS environment , you should check pyros-setup.
- To dynamically discover/marshall/serialize messages format from your ROS processes, you should check pyros.

