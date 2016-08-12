=========================
Hybrid Catkin-pip Package
=========================

Ref : http://wiki.ros.org/ROS/Tutorials/catkin/CreatingPackage

We are introducing here a hybrid way of working with python packages in catkin environment.

These Packages are structured to support both catkin workflow and python workflow.
They can be built either from an existing python package, or from an existing catkin package.

Because of the dynamic nature of python, we do not need to care about message type definition (pyros deals with it dynamically).
So we will not consider these in this document.

The dependencies of the package can be handled by:

- pip (using setuptools.setup 'install_requires' parameter and requirements.txt files)
- rosdep (using depend keys in packages.xml).

This makes it easier to :

- write ROS python code using recent python habits and dependencies.
- test your package with different version of packages available on pypi.
- specialize an existing python repository to integrate in your ROS development environment.
- generalize a ROS package to a more "high level" "system independent" python package.

An important limitation here is that this package will only work from source (inside a catkin devel workspace), and cannot be made into a ROS package, until all dependencies are resolvable via rosdep.
This is due to the complexity of managing multiple package managers with different strategies and policies in place.

However it is perfectly releasable on pypi, just like any python package, provided that all your ROS dependencies are optional.

An example of the ros/python hybrid workflow is the pyros package : https://github.com/asmodehn/pyros
Having a way to retrieve ros packages from the python install is a long term goal.

This workflow is usually a transition workflow during the conversion from a python package (usable in source with catkin pip) to a ROS package (deployable via debs).
As such it is important to test both the ROS devel workflow, and the ROS install workflow, separately. pyros has such a setup.

The catkin devel and install workflow rely on rosdep for depencencies and the multiple pure python workflow rely on pip packages for dependencies.
Therefore great care is needed to support interoparable version of all dependencies in all the different platforms.

This documents describes a hybrid package.
For the step by step process to convert a python package into a ROS package, follow this documentation <TODO>.


Package Structure
=================

This is a generic example inspired by the hybrid catkin-pip package from Pyros : `pyros-test <https://github.com/asmodehn/pyros>`_


Files hierarchy
---------------


Dependencies
------------


Package Development Workflow
============================

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



Continuous Testing Workflow
===========================

Because no software works until it has been tested, you should configure travis on your repository to run test with each commit and pull request.

Catkin testing can be done with a simple `.travis.yml` file and a small shell script.
One important part is to separate the devel and the install flow to make sure dependencies used in the devel workspace wont affect the install test (which should use hte system dependencies)

A matrix build can be setup to test behavior in ROS as well as in python virtualenvs.
An example is there https://travis-ci.org/asmodehn/pyros.