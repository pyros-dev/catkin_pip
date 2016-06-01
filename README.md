catkin_pip
==================

[![Build Status](https://travis-ci.org/asmodehn/catkin_pip.svg?branch=indigo)](https://travis-ci.org/asmodehn/catkin_pip)

Provides catkin extension (cmake hooks) to work with pure python packages in catkin workspaces.
Because state of the art python (ref. http://jeffknupp.com/blog/2013/08/16/open-sourcing-a-python-project-the-right-way/) should be allowed to work in catkin.

catkin_pip allows you to use your own package as a normal python package, with python workflow (example using virtualenvwrapper):
```
$ mkvirtualenv my_package_venv --system-site-packages
(my_package_venv)$ pip install -r requirements.txt
(my_package_venv)$ python -m my_package
(my_package_venv)$ nosetests my_package
(my_package_venv)$ deactivate
$
```
OR using the python workflow from inside a catkin workspace:
```
$ source /opt/ros/indigo/setup.bash
$ cd existing_catkin_ws
$ catkin_make
$ source devel/setup.bash
$ python -m my_package
$ nosetests my_package
```
TODO : improve this with real simple command line examples, copied verbatim.

It basically make use, through cmake, of the workspace as a virtual env would be used in a python flow.
Mostly it's just a few arguments added to pip to get it to install packages in the correct way in a workspace.

The provided cmake macros are:

* catkin_pip_setup()
* catkin_pip_requirements(requirements_file)
* catkin_pip_package()

they can be used like this :
```
...
cmake_minimum_required(VERSION 2.8.3)
project(my_project)

find_package(catkin REQUIRED COMPONENTS
    catkin_pip
)

# Getting pip requirements for catkin_pip itself
catkin_pip_setup()

# We need to install the project pip dependencies in the devel workspace being created
catkin_pip_requirements(${CMAKE_CURRENT_SOURCE_DIR}/requirements.txt)

# defining current package as a package that should be managed by pip (not catkin - even though we make it usable with workspaces)
catkin_pip_package()

# Corresponding install rules are also setup by each of these macros.
...
```

As a result, for source dependencies (available only for development) you can :
- Use pip dependency requirements mechanism with any python git repo, for devel workspace
- Use wstool/rosinstall to retrieve multiple git repository in one place.

And for package dependencies (available for development and for your package) you can :
- Use pip dependency requirements mechanism with any python package from pypi, for both devel and install workspace.
- Use rosdep dependency mechanism, with any ros package dependency.

Roadmap
=======

- [] check if suitable to have catkin always look into site-packages by default, it would avoid this code to hack `_setup_util.py` in each workspace
- [] multiple packages using catkin_pip in same workspace should find each other in the right order and avoid pip version error...
- [] debian packaging. Not sure yet if this is even suitable/possible without huge changes...
