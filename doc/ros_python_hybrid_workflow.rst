ROS Python Hybrid workflow
==========================

This workflow is an upgrade to the basic ros python workflow.
The package file structure is the exact same as the usual catkin package structure, although using a pure python setup.py.
The dependencies of your package can be handled by:

- pip (using setup.py install_requires and requirements.txt)
- rosdep (using depend keys in packages.xml).

This makes it easier to :

- write ROS python code using recent python habits and dependencies.
- fork an existing python repository to integrate in your ROS development environment.
- test your package with different version of packages available on pypi.

An important limitation here is that this package will only work from source (inside a catkin devel workspace), and cannot be made into a ROS package, until all dependencies are resolvable via rosdep.
This is due to the complexity of managing multiple package managers with different strategies and policies in place.

However it is perfectly releasable on pypi, just like any python package, provided that all your ROS dependencies are optional...

An example of the ros/python hybrid workflow is the pyros_setup package : https://github.com/asmodehn/pyros-setup
This package is useful only in "pyros from python" usecase and does not need to be turned into a ROS package. All ROS dependencies are expected to exist.
Having a way to retrieve ros package from the python install is a long term goal.

This workflow is usually a transition workflow during the conversion from a python package (usable in source with catkin pip) to a ROS package (deployable via debs).
As such it is important to test both the ROS devel workflow, and the ROS install workflow, separately. pyros_setup has such a setup.

If one would try to enable the install workflow in the pyros-setup repository, that would fail because pip dependencies could not be found.
It is exactly the behavior expected from catkin_pip, since the install flow needs to fail if the deb package would not be "viable" (in this case it would lack pip dependencies).

Building a ROS package from it
------------------------------

To turn your python code into a ROS package, you first need to turn all the python/pip dependencies into ros (ie. system) packages.
Fortunately catkin_pip makes this relatively easy.

You can choose between:

- making a ROS package using the basic ros python workflow.
   - upside is simplicity and ease of use in ROS ecosystem.
   - downside is maintenance work to upgrade the ros versions following the original python versions for all the dependencies.
     Catkin pip makes it easier than catkin itself, because you at least do not need to modify the python code.
     However you still need to maintain a fork of the upstream source repository and manage all the ros branches in addition to the upstream branches.
- making a third party package for ROS, and a pure python package for Pypi.
   - upside is the simplicity of the maintenance required to follow the upstream python package and its dependencies.
   - downside is the level of knowledge required to be able to manipulate the release repository to get it to behave as you want.

