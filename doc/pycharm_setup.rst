PyCharm Setup
=============

This describe how to setup pycharm to work on your ROS workspace(s)

Basic ROS workflow
------------------

The environment for your project is not a specific environment per Project/Repository/Package, but rather one environment per Workspace.
=> The project for Pycharm is at the workspace level.

- Basic ROS commands and python commands will work from the terminal, after sourcing the devel space as usual with ROS `source devel/setup.bash`
- Pycharm integrated python tools will work, but only if you have sourced the devel space before launching PyCharm, which might not be convenient in some cases...

BEWARE : PyCharm (and Python imports ?) have some issues with symlinks, so you should avoid them if possible when setting up your workspace.

Hybrid workflow
---------------

This assumes you are developing ROS packages at the same time as Python packages, in the same workspace.
Both workflow need to be combined in order to develop and test with ROS and simultaneously develop and test with Python.

- ROS still finds all modules after a `source devel/setup.bash`
- Python (system python) configured in PyCharm will find all modules (from system or from workspaces) using pyros_setup.
  This is useful to use all PyCharm tools for python, even without sourcing the environment yourself, pyros_setup will do that for you.
  You will need to configure pyros_setup appropriately to describe your environment.

TODO : check pip requirements to retrieve git clones.
TODO : check working on ROS workspace + independent python projects in same Pycharm window.

Python workflow (but still using ROS)
-------------------------------------

You can work as usual with Python. Pyros_setup will use the configuration provided to setup your ROS environment and be able to import it.