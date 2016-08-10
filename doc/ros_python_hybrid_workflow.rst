ROS Python Hybrid workflow
==========================

This workflow is an upgrade to the basic ros python workflow.
The package file structure is the exact same as the usual catkin package structure.
The dependencies of your package can be handled by:

- pip (using setup.py install_requires and requirements.txt)
- rosdep (using depend keys in packages.xml).

This makes it easier to :

- write a ROS python package using recent python habits and dependencies
- fork an existing python repository to integrate in your ROS development environment.
- test your package with different version of packages available on pypi.

An important limitation here is that this package will only work from source (inside a catkin devel workspace), and cannot be made into a ROS pacakge, until all dependencies are resolvable via rosdep.
This is due to the complexity of managing multiple package managers with different strategies and policies in place.

To turn your package into a ROS package, you first need to turn all the python/pip dependencies into ros (ie. system) packages.
Fortunately catkin_pip makes this relatively easy.

If you need to build a package, you can choose between:

- making a ROS package using the basic ros python workflow.
   - upside is simplicity and ease of use in ROS ecosystem.
   - downside is maintenance work to upgrade the ros versions following the original python versions for all the dependencies.
     Catkin pip makes it easier than catkin itself, because you do not need to modify the python code.
     However you still need to maintain a fork of the upstream source repository and manage all the ros branches in addition to the upstream branches.
- making a third party package for ROS, and a pure python package for Pypi.
   - upside is the simplicity of the maintenance required to follow the upstream python package and its dependencies.
   - downside is the level of knowledge required to be able to manipulate the release repository.


