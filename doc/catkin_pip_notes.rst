Catkin-Pip Notes
================

This documents gather various notes and detailed issues with Catkin-Pip


Python virtualenvs, imports /vs/ ROS workspaces
-----------------------------------------------

It is important to keep in mind that the way Python imports works, with or without virtualenv, is not compatible with the way ROS workspaces work.

Python Virtual envs allow only 2 layers, ie. you cannot overlay a venv on top of another venv :

- system python
- python in virtualenv

ROS workspaces allow many layers, by using CMAKE_PREFIX_PATH when building, and relying on the user to do  `source setup.sh` before usage :

- system ROS
- ROS workspace1
- ROS workspace2
- etc.

Python imports behavior depends on sys.path. This is managed by the python site module.
Python uses PYTHONPATH as a "last measure" of *temporarily* setting a site directory (usually called site-packages or dist-packages on debian), or any path containing python packages and modules.
Python adds a directory to the sys.path only if it exists, and if it is not there yet.
This behavior is relied upon to decide which packages to import and from where (1st PYTHONPATH paths, 2nd any dynamically discovered package (pth files, etc.), 3rd standard python directories on your system)

ROS uses PYTHONPATH as the "first and only way" to *permanently* (from ROS point of view) set a list of workspaces
The PYTHONPATH is setup to contain the ROS workspaces paths in the appropriate order.

=> Using any python import feature might break this order that ROS relies on to have this workspace hierarchy working properly.

So the following behavior has been decided for Catkin-Pip :
- Catkin-Pip adds extra site directories to the PYTHONPATH (to make things as obvious as possible for a ROS user)
- Catkin-Pip does NOT do any dynamic discoveries (reading easy-install.pth file to discover editable packages). Better keep things simple and not reimplement a python behavior in a shell script...
  Because of this, **it can happen that a package PKG installed in an underlay will be imported before a catkin-pip'ed editable package PKG during development**.
  The expected workaround, is to **use pyros_setup in that package**. It will dynamically reset the desired path order in sys.path, following its user-modifiable configuration configuration file.

More work can be done here, to make things more obvious (like add a field to a catkin-pip'ed package and use pkg_resources on import to find the correct one for example)...