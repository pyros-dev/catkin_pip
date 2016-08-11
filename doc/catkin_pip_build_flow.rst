Catkin-pip build flow
=====================


Pip package
-----------

Catkin-pip doesnt not change hte behavior of a pip package. It just amke its use easier in a catkin context.

Catkin-pip however suppose that the pip package needs to use latest python tools (setuptools, pip, pytest, nose) for manipulating it.
This is in line with python expectation to use latest stable software (and not obsolete system dependencies).



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

ROS Package
-----------

A ROS package can be built from the install space, as usual. One should be careful to have verified the package still behave as expected when not using pip dependencies before releasing.


