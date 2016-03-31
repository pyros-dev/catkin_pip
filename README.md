catkin_pure_python
==================

Provides catkin extension (cmake hooks) to work with pure python packages in catkin workspaces.
Because [idiomatic python](http://jeffknupp.com/blog/2013/08/16/open-sourcing-a-python-project-the-right-way/) should be working with catkin.

* catkin_pip_setup()
* catkin_pip_requirements(requirements_file)
* catkin_pip_package()

* Example
```
...
cmake_minimum_required(VERSION 2.8.3)
project(my_project)

find_package(catkin REQUIRED COMPONENTS
    catkin_pure_python
)

# Getting pip requirements for catkin_pip itself
catkin_pip_setup()

# We need to install the pip dependencies in the devel workspace being created
catkin_pip_requirements(${CMAKE_CURRENT_SOURCE_DIR}/requirements.txt)

# defining current package as a package that should be managed by pip (not catkin - even though we make it usable with workspaces)
catkin_pip_package()

# Corresponding install rules are also setup by each of these macros.
...
```


