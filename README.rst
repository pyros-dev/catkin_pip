catkin_pip
==========

|Build Status|

| Provides catkin extension (cmake hooks) to work with pure python
  packages in catkin workspaces.
| Because state of the art python (ref.
  http://jeffknupp.com/blog/2013/08/16/open-sourcing-a-python-project-the-right-way/)
  should be allowed to work with catkin.

catkin_pip allows you to use your own package as a normal python
package, with python workflow (example using virtualenvwrapper)::

    $ mkvirtualenv my_package_venv --system-site-packages
    (my_package_venv)$ pip install -r requirements.txt
    (my_package_venv)$ python -m my_package
    (my_package_venv)$ nosetests my_package
    (my_package_venv)$ deactivate
    $

OR using the python workflow from inside a catkin workspace::

    $ source /opt/ros/indigo/setup.bash
    $ cd existing_catkin_ws
    $ catkin_make
    $ source devel/setup.bash
    $ python -m my_package
    $ nosetests my_package

TODO : improve this with real simple command line examples, copied
verbatim.

| It basically make use, through cmake, of the workspace as a virtual
  env would be used in a python flow.
| Mostly it’s just a few arguments added to pip to get it to install
  packages in the correct way in a workspace.

The provided cmake macros are:

-  catkin_pip_setup()
-  catkin_pip_requirements(requirements_file)
-  catkin_pip_package()

they can be used like this :

::

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

As a result you can:

- Use pip/setup.py dependency mechanism with any python git repo, for devel workspace.
- Use pip dependency requirements mechanism with any pip dependency, for devel workspace.
- Directly work with python package sources in your usual catkin workspaces (devel only), after just adding a `CMakeLists.txt` and a `package.xml` files.
- Work with "hybrid" packages that can be released both via pip packages and ros packages, provided the proper dependencies exists for both package management systems (Note rosdep support of pip is not clear...).
- Do a Third Party release of an existing python package into a ROS package (no setup.py changes required).
   

.. |Build Status| image:: https://travis-ci.org/asmodehn/catkin_pip.svg?branch=devel
   :target: https://travis-ci.org/asmodehn/catkin_pip
